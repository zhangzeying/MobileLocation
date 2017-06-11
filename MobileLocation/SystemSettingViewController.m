//
//  SystemSettingViewController.m
//  MobileLocation
//
//  Created by zzy on 06/06/2017.
//  Copyright © 2017 lanmao. All rights reserved.
//

#import "SystemSettingViewController.h"
#import "AuthorizationViewController.h"
#import "ContactViewController.h"
#import "ParamsSettingViewController.h"
#import "UserAgreementViewController.h"
#import "AppDelegate.h"
@interface SystemSettingViewController ()<UITableViewDelegate,UITableViewDataSource>
/** <##> */
@property (nonatomic, weak)UITableView *tableView;
/** <##> */
@property(nonatomic,strong)NSArray *dataArr;
@end
@implementation SystemSettingViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadState) name:@"ReloadState" object:nil];
    self.navigationItem.title = @"设置";
    self.view.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    self.dataArr = @[@{@"0":@[@"用户状态",@"用户名",@"修改密码",@"软件授权码",@"批量后台控制",@"高级设置",@"参数设置"]},@{@"1":@[@"联系我们",@"用户协议",@"版本"]}];
    UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 50;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    [self createTableHeaderView];
    [self createTableFooterView];
}

- (void)viewDidLayoutSubviews{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
}

- (void)createTableHeaderView {
    
    UIView *tableHeaderView = [[UIView alloc]init];
    tableHeaderView.backgroundColor = [UIColor clearColor];
    tableHeaderView.width = self.view.width;
    tableHeaderView.height = 150;
    
    UIImageView *locationImg = [[UIImageView alloc]init];
    locationImg.frame = CGRectMake(0, 0, 106, 90);
    locationImg.image = [UIImage imageNamed:@"setting_location_icon"];
    locationImg.center = CGPointMake(self.view.width / 2, tableHeaderView.height / 2 + 10);
    [tableHeaderView addSubview:locationImg];
    
    self.tableView.tableHeaderView = tableHeaderView;
}

- (void)createTableFooterView {
    
    UIView *tableFooterView = [[UIView alloc]init];
    tableFooterView.backgroundColor = [UIColor clearColor];
    tableFooterView.width = self.view.width;
    tableFooterView.height = 80;
    
    UIButton *quitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    quitBtn.frame = CGRectMake(50, tableFooterView.height - 65, self.view.width - 2*50, 45);
    quitBtn.backgroundColor = [UIColor colorWithHexString:@"ca0814"];
    [quitBtn setTitle:@"退出" forState:UIControlStateNormal];
    quitBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [quitBtn addTarget:self action:@selector(quitClick) forControlEvents:UIControlEventTouchUpInside];
    [tableFooterView addSubview:quitBtn];
    
    self.tableView.tableFooterView = tableFooterView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSDictionary *dict = self.dataArr[section];
    NSArray *array = [dict objectForKey:[NSString stringWithFormat:@"%zd",section]];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dict = self.dataArr[indexPath.section];
    NSArray *array = [dict objectForKey:[NSString stringWithFormat:@"%zd",indexPath.section]];
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text = array[indexPath.row];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UILabel *contentLbl = [[UILabel alloc]init];
    contentLbl.textColor = [UIColor lightGrayColor];
    contentLbl.font = [UIFont systemFontOfSize:15];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        contentLbl.textColor = [UIColor redColor];
        contentLbl.hidden = NO;
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"authorizationState"] isEqualToString:@"0"]) {
            contentLbl.text = @"未输入授权码";
           
        } else {
        
            contentLbl.text = @"网络未开通";
        }
        
        [contentLbl sizeToFit];
        contentLbl.frame = CGRectMake(self.view.width - contentLbl.width - 30, 0, contentLbl.width, contentLbl.height);
        
    } else if (indexPath.section == 0 && indexPath.row == 1) {
    
        cell.accessoryType = UITableViewCellAccessoryNone;
        contentLbl.hidden = NO;
        contentLbl.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
        [contentLbl sizeToFit];
        contentLbl.frame = CGRectMake(self.view.width - contentLbl.width - 18, 0, contentLbl.width, contentLbl.height);
        
    }else if (indexPath.section == 0 && indexPath.row == 3) {
        
        contentLbl.hidden = NO;
        contentLbl.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"authorizationCode"];
        [contentLbl sizeToFit];
        contentLbl.frame = CGRectMake(self.view.width - contentLbl.width - 30, 0, contentLbl.width, contentLbl.height);
        
    } else if (indexPath.section == 1 && indexPath.row == 2) {
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        contentLbl.hidden = NO;
        contentLbl.text = @"V10.0.0";
        [contentLbl sizeToFit];
        contentLbl.frame = CGRectMake(self.view.width - contentLbl.width - 18, 0, contentLbl.width, contentLbl.height);
    } else {
    
        contentLbl.hidden = YES;
    }
    
    contentLbl.centerY = 25;
    [cell.contentView addSubview:contentLbl];
    return cell;
}

//头视图高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}
//脚视图高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0 && indexPath.row == 0) {
    
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"authorizationState"] isEqualToString:@"0"]) {
        
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:@"url1"]]];
            
        } else {
        
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:@"url2"]]];
        }
    } else if ((indexPath.section == 0 && indexPath.row == 2)) {//修改密码
    
        [self dealAuthorizationState];
        
    } else if (indexPath.section == 0 && indexPath.row == 3) {//软件授权码
        
        AuthorizationViewController *authorizationVC = [[AuthorizationViewController alloc]init];
        authorizationVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:authorizationVC animated:YES];
        
    } else if (indexPath.section == 0 && indexPath.row == 4) {//批量后台控制
        
        [self dealAuthorizationState];
        
    } else if (indexPath.section == 0 && indexPath.row == 5) {//高级设置
        
        [self dealAuthorizationState];
    } else if (indexPath.section == 0 && indexPath.row == 6) {//参数设置
        
        ParamsSettingViewController *paramsSettingVC = [[ParamsSettingViewController alloc]init];
        paramsSettingVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:paramsSettingVC animated:YES];
        
    } else if (indexPath.section == 1 && indexPath.row == 0) {//联系我们
        
        ContactViewController *contactVC = [[ContactViewController alloc]init];
        contactVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:contactVC animated:YES];
        
    } else if (indexPath.section == 1 && indexPath.row == 1) {//用户协议
        
        UserAgreementViewController *userAgreementVC = [[UserAgreementViewController alloc]init];
        userAgreementVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:userAgreementVC animated:YES];
    }
}

- (void)quitClick {

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@(NO) forKey:@"isLogin"];
    [userDefaults synchronize];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.locationManager stopUpdatingLocation];
    self.tabBarController.selectedIndex = 0;
}

- (void)dealAuthorizationState {

    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"authorizationState"] isEqualToString:@"0"]) {
        
        AuthorizationViewController *authorizationVC = [[AuthorizationViewController alloc]init];
        authorizationVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:authorizationVC animated:YES];
        
    } else {
    
        [SVProgressHUD showImage:nil status:@"网络未开通"];
    }
}

- (void)reloadState {

    [self.tableView reloadData];
}

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}

@end
