//
//  ContactViewController.m
//  MobileLocation
//
//  Created by zzy on 10/06/2017.
//  Copyright © 2017 lanmao. All rights reserved.
//

#import "ContactViewController.h"

@interface ContactViewController ()<UITableViewDelegate,UITableViewDataSource>
/** <##> */
@property (nonatomic, weak)UITableView *tableView;
@end

@implementation ContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"联系我们";
    UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [UIView new];
    tableView.rowHeight = 50;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    NSString *customerMobile = [[NSUserDefaults standardUserDefaults] objectForKey:@"customerMobile"];
    if (customerMobile.length == 0 && ([[[NSUserDefaults standardUserDefaults] objectForKey:@"authorizationState"] isEqualToString:@"0"] || [[NSUserDefaults standardUserDefaults] objectForKey:@"authorizationState"] == nil)) {
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",nil];
        manager.requestSerializer.timeoutInterval = 15.0f;
        [manager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
        NSString *urlStr = [Utils getUrl:@"/customerService/getInfo"];
        [manager GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSDictionary *dict = responseObject;
            if ([dict[@"flag"] integerValue] == 1) {
                
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                NSString *customerMobile = dict[@"result"][@"mobile"];
                NSString *customerQQ = dict[@"result"][@"qq"];
                NSString *url1 = dict[@"result"][@"url"];
                NSString *url2 = dict[@"result"][@"url2"];
                if ([[userDefaults objectForKey:@"authorizationState"] isEqualToString:@"0"] || [userDefaults objectForKey:@"authorizationState"] == nil) {//未授权，更新客服信息
                    [userDefaults setObject:customerMobile forKey:@"customerMobile"];
                    [userDefaults setObject:customerQQ forKey:@"customerQQ"];
                    [userDefaults setObject:url1 forKey:@"url1"];
                    [userDefaults setObject:url2 forKey:@"url2"];
                    [userDefaults synchronize];
                    [self.tableView reloadData];
                }
                
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    }
    
    
    
}

- (void)viewDidLayoutSubviews{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UILabel *contentLbl = [[UILabel alloc]init];
    contentLbl.textColor = [UIColor lightGrayColor];
    contentLbl.font = [UIFont systemFontOfSize:15];
    if (indexPath.row == 0) {
        cell.textLabel.text = @"售前电话";
        contentLbl.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"customerMobile"]?:@"";
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"售后QQ";
        contentLbl.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"customerQQ"]?:@"";
    }
    [contentLbl sizeToFit];
    contentLbl.frame = CGRectMake(self.view.width - contentLbl.width - 40, 0, contentLbl.width, contentLbl.height);
    contentLbl.centerY = 25;
    [cell.contentView addSubview:contentLbl];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == 0) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"customerMobile"]]]];
        
    }else if (indexPath.row == 1) {
        
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
            //调用QQ客户端,发起QQ临时会话
            NSString *url = [NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web",[[NSUserDefaults standardUserDefaults] objectForKey:@"customerQQ"]];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        }else{
         
            [SVProgressHUD showErrorWithStatus:@"未安装QQ" maskType:SVProgressHUDMaskTypeBlack];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
