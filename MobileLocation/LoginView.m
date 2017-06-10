//
//  LoginView.m
//  MobileLocation
//
//  Created by zzy on 10/06/2017.
//  Copyright © 2017 lanmao. All rights reserved.
//

#import "LoginView.h"
#import "RegisterViewController.h"
#import "ContactViewController.h"
@interface LoginView ()
@property (weak, nonatomic) IBOutlet UITextField *phoneTxt;
@property (weak, nonatomic) IBOutlet UITextField *passwordTxt;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@end

@implementation LoginView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.phoneTxt setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.passwordTxt setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    self.loginBtn.backgroundColor = [UIColor colorWithHexString:@"3a9ddc"];
}

+ (LoginView *)instanceLoginView {
    
    NSArray *nibView = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil];
    return [nibView lastObject];
}

- (IBAction)loginClick:(id)sender {
    
    if (self.phoneTxt.text.length == 0) {
        
        [SVProgressHUD showErrorWithStatus:@"用户名不能为空！" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    
    if (self.passwordTxt.text.length == 0) {
        
        [SVProgressHUD showErrorWithStatus:@"密码不能为空！" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",nil];
    manager.requestSerializer.timeoutInterval = 15.0f;
    [manager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    NSString *urlStr = [Utils getUrl:@"/users/login"];
    NSDictionary *parameters = @{@"username": self.phoneTxt.text,
                                 @"password": self.passwordTxt.text};
    [SVProgressHUD show];
    [manager POST:urlStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dict = responseObject;
        if ([dict[@"flag"] integerValue] == 1) {
            [SVProgressHUD dismiss];
            NSString *authorizationState = dict[@"result"][@"authorizationState"];
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:self.phoneTxt.text forKey:@"username"];
            [userDefaults setObject:self.passwordTxt.text forKey:@"password"];
            [userDefaults setObject:authorizationState forKey:@"authorizationState"];
            [userDefaults synchronize];
            [self removeFromSuperview];
            
        } else {
            
            [SVProgressHUD showErrorWithStatus:dict[@"msg"] maskType:SVProgressHUDMaskTypeBlack];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (error.code == 500) {
            
            [SVProgressHUD showErrorWithStatus:@"服务器异常" maskType:SVProgressHUDMaskTypeBlack];
            
        } else {
            
            [SVProgressHUD showErrorWithStatus:@"请求超时,请检查网络状态" maskType:SVProgressHUDMaskTypeBlack];
        }
        NSLog(@"%@",error);
    }];
}

- (IBAction)registerClick:(id)sender {
    
    RegisterViewController *registerVC = [[RegisterViewController alloc]init];
    [self.vc.navigationController pushViewController:registerVC animated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.hidden = YES;
    });
}

- (IBAction)contactClick:(id)sender {
    
    ContactViewController *contactVC = [[ContactViewController alloc]init];
    [self.vc.navigationController pushViewController:contactVC animated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.hidden = YES;
    });
}
@end
