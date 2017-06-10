//
//  PhoneLocationViewController.m
//  MobileLocation
//
//  Created by zzy on 06/06/2017.
//  Copyright © 2017 lanmao. All rights reserved.
//

#import "PhoneLocationViewController.h"
#import <MAMapKit/MAMapKit.h>
#import "CustomNavTitleView.h"
#import "LoginView.h"
@interface PhoneLocationViewController ()
/** 地图对象 */
@property(nonatomic,strong)MAMapView *mapView;
/** <##> */
@property (nonatomic, weak)LoginView *loginView;
@end

@implementation PhoneLocationViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    CustomNavTitleView *titleView = [[CustomNavTitleView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 44)];
    titleView.vc = self;
    titleView.btnTitle = @"开始定位";
    self.navigationItem.titleView = titleView;
    [self setupMapView];
    
    
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"username"] || ![[NSUserDefaults standardUserDefaults] objectForKey:@"password"]) {
        
        if (!self.loginView) {
            
            LoginView *loginView = [LoginView instanceLoginView];
            loginView.frame = [UIScreen mainScreen].bounds;
            loginView.vc = self;
            loginView.backgroundColor = [UIColor blackColor];
            loginView.alpha = 0.8f;
            [self.tabBarController.view addSubview:loginView];
            self.loginView = loginView;
            
        } else {
        
            self.loginView.hidden = NO;
        }
        
    } else {
    
        if (self.loginView) {
            [self.loginView removeFromSuperview];
            self.loginView = nil;
        }
    }
}

/**
 * 初始化地图
 */
- (void)setupMapView {
    
    self.mapView = [[MAMapView alloc] initWithFrame:self.view.frame];
//    self.mapView.delegate = self;
    self.mapView.zoomLevel = 3;
    [self.view addSubview:self.mapView];
    
    UIButton *mapTypeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [mapTypeBtn setTitle:@"普通地图|卫星地图" forState:UIControlStateNormal];
    mapTypeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [mapTypeBtn setTitleColor:[UIColor colorWithHexString:@"787878"] forState:UIControlStateNormal];
    mapTypeBtn.layer.borderColor = [UIColor grayColor].CGColor;
    mapTypeBtn.layer.cornerRadius = 13;
    mapTypeBtn.layer.borderWidth = 1;
    [mapTypeBtn addTarget:self action:@selector(mapTypeClick:) forControlEvents:UIControlEventTouchUpInside];
    mapTypeBtn.backgroundColor = [UIColor whiteColor];
    mapTypeBtn.frame = CGRectMake(15, self.view.height - 25 - 49 - 25, 130, 25);
    [self.view addSubview:mapTypeBtn];
}

- (void)mapTypeClick:(UIButton *)sender {

    sender.selected = !sender.selected;
    self.mapView.mapType = sender.selected ? MAMapTypeSatellite : MAMapTypeStandard;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
