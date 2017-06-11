//
//  RegisterViewController.m
//  MobileLocation
//
//  Created by zzy on 06/06/2017.
//  Copyright © 2017 lanmao. All rights reserved.
//

#import "RegisterViewController.h"
#import "UserAgreementViewController.h"
#import "AppDelegate.h"
@interface RegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneTxt;
@property (weak, nonatomic) IBOutlet UITextField *passwordTxt;
@property (weak, nonatomic) IBOutlet UITextField *verifyCodeTxt;
@property (weak, nonatomic) IBOutlet UIButton *verifyCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *checkBoxBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UIButton *userAgreementBtn;
@property (weak, nonatomic) IBOutlet UIButton *agreementBtn;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.verifyCodeBtn.backgroundColor = [UIColor colorWithHexString:@"3f9ed9"];
    self.registerBtn.backgroundColor = [UIColor colorWithHexString:@"3f9ed9"];
    [self.userAgreementBtn setTitleColor:[UIColor colorWithHexString:@"3f9ed9"] forState:UIControlStateNormal];
    [self.agreementBtn setTitleColor:[UIColor colorWithHexString:@"3f9ed9"] forState:UIControlStateNormal];
    self.navigationItem.title = @"注册";
}

- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

- (IBAction)getVerifyCodeClick:(id)sender {
    
    if (self.phoneTxt.text.length == 0) {
        
        [SVProgressHUD showErrorWithStatus:@"手机号不能为空！" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",nil];
    manager.requestSerializer.timeoutInterval = 15.0f;
    [manager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    NSString *urlStr = [Utils getUrl:@"/sms/send"];
    NSDictionary *parameters = @{@"mobile": self.phoneTxt.text};
    [SVProgressHUD show];
    [manager POST:urlStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dict = responseObject;
        if ([dict[@"flag"] integerValue] == 1) {
            [SVProgressHUD dismiss];
            [self startTime];
            
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

- (IBAction)checkBoxClick:(UIButton *)sender {
    
    sender.selected = !sender.selected;
}
- (IBAction)agreementClick:(id)sender {
    
    [self checkBoxClick:self.checkBoxBtn];
}

- (IBAction)registerClick:(id)sender {
    
    if (!self.checkBoxBtn.selected) {
        
        [SVProgressHUD showErrorWithStatus:@"请勾选用户协议！" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    
    if (self.phoneTxt.text.length == 0) {
        
        [SVProgressHUD showErrorWithStatus:@"手机号不能为空！" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    
    if (self.passwordTxt.text.length == 0) {
        
        [SVProgressHUD showErrorWithStatus:@"密码不能为空！" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    
    if (self.verifyCodeTxt.text.length == 0) {
        
        [SVProgressHUD showErrorWithStatus:@"验证码不能为空！" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",nil];
    manager.requestSerializer.timeoutInterval = 15.0f;
    [manager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    NSString *urlStr = [Utils getUrl:@"/users/register"];
    NSDictionary *parameters = @{@"username": self.phoneTxt.text,
                                 @"password": self.passwordTxt.text,
                                 @"verifyCode": self.verifyCodeTxt.text};
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
            [userDefaults setObject:@(YES) forKey:@"isLogin"];
            [userDefaults synchronize];
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [appDelegate startLocation];
            [self.navigationController popViewControllerAnimated:NO];
            
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
- (IBAction)userAgreementClick:(id)sender {
    
    UserAgreementViewController *userAgreementVC = [[UserAgreementViewController alloc]init];
    userAgreementVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:userAgreementVC animated:YES];
}

- (void)startTime {
    
    __block int timeout= 59; //倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if(timeout<=0){ //倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置界面的按钮显示 根据自己需求设置
                
                [self.verifyCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                
                self.verifyCodeBtn.userInteractionEnabled = YES;
                
            });
            
        }else{
            
            //            int minutes = timeout / 60;
            
            int seconds = timeout % 60;
            
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置界面的按钮显示 根据自己需求设置
                
                [UIView beginAnimations:nil context:nil];
                
                [UIView setAnimationDuration:1];
                
                [self.verifyCodeBtn setTitle:[NSString stringWithFormat:@"%@秒重发",strTime] forState:UIControlStateNormal];
                
                [UIView commitAnimations];
                
                self.verifyCodeBtn.userInteractionEnabled = NO;
                
            });
            
            timeout--;
        }
        
    });
    
    dispatch_resume(_timer);
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
