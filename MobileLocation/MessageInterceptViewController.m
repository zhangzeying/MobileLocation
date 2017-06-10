//
//  MessageInterceptViewController.m
//  MobileLocation
//
//  Created by zzy on 06/06/2017.
//  Copyright © 2017 lanmao. All rights reserved.
//

#import "MessageInterceptViewController.h"
#import "CustomNavTitleView.h"
#import "MJRefresh.h"
@interface MessageInterceptViewController ()
/** <##> */
@property (nonatomic, weak)UITableView *tableView;
@end

@implementation MessageInterceptViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    CustomNavTitleView *titleView = [[CustomNavTitleView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 44)];
    titleView.vc = self;
    titleView.btnTitle = @"开始拦截";
    self.navigationItem.titleView = titleView;
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    
    UIView *bgView = [[UIView alloc]init];
    UILabel *messageLabel = [[UILabel alloc]init];
    messageLabel.text = @"暂无数据，请下拉刷新";
    messageLabel.font = [UIFont systemFontOfSize:18];
    messageLabel.textColor = [UIColor lightGrayColor];
    [messageLabel sizeToFit];
    messageLabel.frame = CGRectMake(0, 0, messageLabel.frame.size.width, messageLabel.frame.size.height + 20);
    messageLabel.center = CGPointMake(tableView.frame.size.width / 2, tableView.frame.size.height / 2 - 30);
    [bgView addSubview:messageLabel];
    tableView.backgroundView = bgView;
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    header.automaticallyChangeAlpha = YES;
    
    tableView.mj_header = header;
    
    self.tableView = tableView;
}

- (void)loadNewData {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.mj_header endRefreshing];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
