//
//  CallMonitorViewController.m
//  MobileLocation
//
//  Created by zzy on 06/06/2017.
//  Copyright © 2017 lanmao. All rights reserved.
//

#import "CallMonitorViewController.h"
#import "CustomNavTitleView.h"
#import "MJRefresh.h"
#import "AuthorizationViewController.h"
@interface CallMonitorViewController ()<CustomNavTitleViewDelegate>
/** <##> */
@property (nonatomic, weak)UITableView *tableView;
/** <##> */
@property (nonatomic, weak)UIImageView *image;
@end

@implementation CallMonitorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    CustomNavTitleView *titleView = [[CustomNavTitleView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 44)];
    titleView.vc = self;
    titleView.delegate = self;
    titleView.btnTitle = @"开始监听";
    self.navigationItem.titleView = titleView;
    
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    tapGesture.numberOfTapsRequired = 1;
    [tableView addGestureRecognizer:tapGesture];
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
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"示例" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    btn.backgroundColor = [UIColor colorWithHexString:@"5a585a"];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(self.view.width - 80, self.view.height - 15 - 80, 80, 40);
    [self.view addSubview:btn];
}

- (void)loadNewData {
    
    [SVProgressHUD show];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD showImage:nil status:@"暂无最新数据"];
         [self.tableView.mj_header endRefreshing];
    });
}

- (void)btnClick {

    if (self.image == nil) {
        
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height - 120 - 64)];
        image.userInteractionEnabled = YES;
        image.image = [UIImage imageNamed:@"call_monitor_image"];
        [self.view addSubview:image];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
        tapGesture.numberOfTapsRequired = 1;
        [image addGestureRecognizer:tapGesture];
        self.image = image;
        
    } else {
    
        [self.image removeFromSuperview];
        self.image = nil;
    }
}

- (void)tapClick {

    if (self.image) {
        
        [self.image removeFromSuperview];
        self.image = nil;
    }
}

- (void)rightBtnClick:(NSString *)phoneStr {
    
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"authorizationState"] isEqualToString:@"0"]) {
        
        AuthorizationViewController *authorizationVC = [[AuthorizationViewController alloc]init];
        authorizationVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:authorizationVC animated:YES];
        
    } else {
        
        [SVProgressHUD showImage:nil status:@"网络未开通"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
