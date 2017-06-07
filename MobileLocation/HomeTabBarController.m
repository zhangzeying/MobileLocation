//
//  HomeTabBarController.m
//  chemistry
//
//  Created by zzy on 3/5/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "HomeTabBarController.h"
#import "BaseNavigationController.h"

@interface HomeTabBarController ()

@end

@implementation HomeTabBarController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setTabBar];
}

//设置tabBar
- (void)setTabBar {
    
    //添加子控制器
    NSArray *classNames = @[@"PhoneLocationViewController", @"CallMonitorViewController", @"MessageInterceptViewController", @"SystemSettingViewController"];
    
    NSArray *titles = @[@"号码定位", @"通话监听", @"信息拦截", @"系统设置"];
    
    NSArray *imageNames = @[@"tab_location", @"tab_phone", @"tab_message", @"tab_setting"];
    
    NSArray *selectedImageNames = @[@"tab_location_selected", @"tab_phone_selected", @"tab_message_selected", @"tab_setting_selected"];
    
    for (int i = 0; i < classNames.count; i++) {
        
        UIViewController *vc = (UIViewController *)[[NSClassFromString(classNames[i]) alloc] init];
        BaseNavigationController *nc = [[BaseNavigationController alloc] initWithRootViewController:vc];
        vc.tabBarItem.title = titles[i];
        vc.tabBarItem.image = [[UIImage imageNamed:imageNames[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImageNames[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        vc.view.layer.shadowColor = [UIColor blackColor].CGColor;
        vc.view.layer.shadowOffset = CGSizeMake(-3.5, 0);
        vc.view.layer.shadowOpacity = 0.2;
        [self addChildViewController:nc];
        
    }
    
    self.tabBar.barTintColor = [UIColor whiteColor];
    self.selectedIndex = 0;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
