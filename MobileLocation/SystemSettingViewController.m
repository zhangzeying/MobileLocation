//
//  SystemSettingViewController.m
//  MobileLocation
//
//  Created by zzy on 06/06/2017.
//  Copyright © 2017 lanmao. All rights reserved.
//

#import "SystemSettingViewController.h"

@interface SystemSettingViewController ()<UITableViewDelegate,UITableViewDataSource>
/** <##> */
@property (nonatomic, weak)UITableView *tableView;
@end

@implementation SystemSettingViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationItem.title = @"设置";
    self.view.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

- (void)createTableHeaderView {

//    UIView *bgView
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}

@end
