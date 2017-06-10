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
        contentLbl.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"customerMobile"];
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"售后QQ";
        contentLbl.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"customerQQ"];
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
