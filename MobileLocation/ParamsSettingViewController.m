//
//  ParamsSettingViewController.m
//  MobileLocation
//
//  Created by zzy on 10/06/2017.
//  Copyright © 2017 lanmao. All rights reserved.
//

#import "ParamsSettingViewController.h"
#import "AuthorizationViewController.h"
@interface ParamsSettingViewController ()

@end

@implementation ParamsSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"参数设置";
}
- (IBAction)checkBoxClick:(UIButton *)sender {

    sender.selected = !sender.selected;
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
