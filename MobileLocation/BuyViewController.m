//
//  BuyViewController.m
//  MobileLocation
//
//  Created by zzy on 09/07/2017.
//  Copyright © 2017 lanmao. All rights reserved.
//

#import "BuyViewController.h"

@interface BuyViewController ()<UITableViewDelegate, UITableViewDataSource>
/** <##> */
@property(nonatomic,strong)NSArray *dataArr;
/** <##> */
@property(nonatomic,strong)UIButton *selectedBtn;
/** <##> */
@property (nonatomic, weak)UIButton *payBtn;
/** <##> */
@property(nonatomic,strong)NSDictionary *dict;
@end

@implementation BuyViewController

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        
        self.dict = dict;
        
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationItem.title = @"商品支付";
    self.dataArr = @[@{@"image":@"alipay_icon",@"name":@"支付宝支付",@"subtitle":@"(推荐安装支付宝用户使用)"},@{@"image":@"wechat_icon",@"name":@"微信支付",@"subtitle":@"(推荐安装微信用户使用)"}];
    [self setupTableView];
    
    UIButton *payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    payBtn.frame = CGRectMake(0, ScreenH - 49, ScreenW, 49);
    payBtn.backgroundColor = [UIColor colorWithHexString:@"5eacdb"];
    [self.view addSubview:payBtn];
    [payBtn setTitle:[NSString stringWithFormat:@"支付宝支付：%.0f元   确定",[self.dict[@"price"] doubleValue]] forState:UIControlStateNormal];
    [payBtn addTarget:self action:@selector(payClick) forControlEvents:UIControlEventTouchUpInside];
    self.payBtn = payBtn;
}

- (void)setupTableView {
    
    UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH - 49) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.tableFooterView = [UIView new];
    table.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    table.backgroundColor = CustomColor(240, 243, 246);
    table.rowHeight = 60;
    [self.view addSubview:table];
    
    UIView *footerView = [[UIView alloc]init];
    table.tableFooterView = footerView;
    
    
    UILabel *tipLbl = [[UILabel alloc]init];
    tipLbl.x = 20;
    tipLbl.y = 15;
    tipLbl.text = self.dict[@"question"];
    tipLbl.font = [UIFont systemFontOfSize:14];
    tipLbl.numberOfLines = 0;
    tipLbl.width = ScreenW - 40;
    [tipLbl sizeToFit];
    
    [footerView addSubview:tipLbl];
    
    footerView.width = ScreenW;
    footerView.height = CGRectGetMaxY(tipLbl.frame) + 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    NSDictionary *dict = self.dataArr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.imageView.image = [UIImage imageNamed:dict[@"image"]];
    cell.textLabel.text = dict[@"name"];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.detailTextLabel.text = dict[@"subtitle"];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.detailTextLabel.textColor = [UIColor grayColor];
    UIButton *radioBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [radioBtn setBackgroundImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
    [radioBtn setBackgroundImage:[UIImage imageNamed:@"radio_selected"] forState:UIControlStateSelected];
    radioBtn.frame = CGRectMake(0, 0, 20, 20);
    [radioBtn addTarget:self action:@selector(radioClick:) forControlEvents:UIControlEventTouchUpInside];
    radioBtn.tag = indexPath.row+1;
    cell.accessoryView = radioBtn;
    radioBtn.selected = indexPath.row == 0;
    if (indexPath.row == 0) {
        
        self.selectedBtn = radioBtn;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIButton *radioBtn = (UIButton *)cell.accessoryView;
    [self radioClick:radioBtn];
}

- (void)radioClick:(UIButton *)sender {

    if (sender != self.selectedBtn) {
        
        if (sender.tag == 1) {
            
            [self.payBtn setTitle:[NSString stringWithFormat:@"支付宝支付：%.0f元   确定",[self.dict[@"price"] doubleValue]] forState:UIControlStateNormal];
            
        } else {
        
            [self.payBtn setTitle:[NSString stringWithFormat:@"微信支付：¥%.0f元   确定",[self.dict[@"price"] doubleValue]] forState:UIControlStateNormal];
        }
        sender.selected = !sender.selected;
        self.selectedBtn.selected = !self.selectedBtn.selected;
        self.selectedBtn = sender;
        
    }
    
}

- (void)payClick {

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",nil];
    manager.requestSerializer.timeoutInterval = 15.0f;
    [manager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    NSString *urlStr = [Utils getUrl:@"/order/payProduct"];
    NSDictionary *parameters = @{@"username":[[NSUserDefaults standardUserDefaults] objectForKey:@"username"],
                                 @"productId":self.dict[@"productId"],
                                 @"productName":self.dict[@"productName"],
                                 @"price":self.dict[@"price"],
                                 @"payType":self.selectedBtn.tag == 1 ? @"ALIWAP" : @"MWEB"};
    [SVProgressHUD show];
    [manager POST:urlStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dict = responseObject;
        if ([dict[@"flag"] integerValue] == 1) {
            [SVProgressHUD dismiss];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:dict[@"result"][@"payUrl"]]];
            
        } else {
            
            [SVProgressHUD showErrorWithStatus:@"操作失败，请尝试其他支付方式" maskType:SVProgressHUDMaskTypeBlack];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD showErrorWithStatus:@"网络异常" maskType:SVProgressHUDMaskTypeBlack];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
