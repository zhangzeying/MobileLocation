//
//  AuthorizationViewController.m
//  MobileLocation
//
//  Created by zzy on 10/06/2017.
//  Copyright © 2017 lanmao. All rights reserved.
//

#import "AuthorizationViewController.h"
#import "ContactViewController.h"
#import "BuyViewController.h"
@interface AuthorizationViewController ()
@property (weak, nonatomic) IBOutlet UITextField *authorizationCodeTxt;
//@property (weak, nonatomic) IBOutlet UIButton *questionBtn;
@property (weak, nonatomic) IBOutlet UIButton *buyBtn;
@property (weak, nonatomic) IBOutlet UIButton *contactBtn;
@property (weak, nonatomic) IBOutlet UIView *line;
@end

@implementation AuthorizationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.line.backgroundColor = [UIColor colorWithHexString:@"3f9ed9"];
//    [self.questionBtn setTitleColor:[UIColor colorWithHexString:@"3f9ed9"] forState:UIControlStateNormal];
    [self.buyBtn setTitleColor:[UIColor colorWithHexString:@"3f9ed9"] forState:UIControlStateNormal];
    [self.contactBtn setTitleColor:[UIColor colorWithHexString:@"3f9ed9"] forState:UIControlStateNormal];
    self.navigationItem.title = @"授权码";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(authorizationClick)];
    NSDictionary *dic = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:dic forState:UIControlStateNormal];
    
}

- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

- (void)authorizationClick {

    if (self.authorizationCodeTxt.text.length == 0) {
        
        [SVProgressHUD showErrorWithStatus:@"授权码不能为空" maskType:SVProgressHUDMaskTypeBlack];
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",nil];
    manager.requestSerializer.timeoutInterval = 15.0f;
    [manager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    NSString *urlStr = [Utils getUrl:@"/users/authorizationForUser"];
    NSDictionary *parameters = @{@"username":[[NSUserDefaults standardUserDefaults] objectForKey:@"username"],
                                 @"authorizationCode": self.authorizationCodeTxt.text};
    [SVProgressHUD show];
    [manager POST:urlStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dict = responseObject;
        if ([dict[@"flag"] integerValue] == 1) {
            
            [SVProgressHUD showImage:nil status:@"授权成功"];
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:self.authorizationCodeTxt.text forKey:@"authorizationCode"];
            [userDefaults setObject:@"1" forKey:@"authorizationState"];
            [userDefaults synchronize];
            [self.navigationController popViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadState" object:nil];
            
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

//- (IBAction)questionClick:(id)sender {
//    
//    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"软件授权码是激活本软件系统的一个激活码，本软件系统是付费软件系统，付费后自动生成授权码发送到您注册本软件系统的手机号码上，然后输入授权码后本软件系统即可授权，只需要知道对方号码即可对此号码随时随地的监控，且被监控者毫不知情" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
//    [alertView show];
//}

- (IBAction)buyClick:(id)sender {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",nil];
    manager.requestSerializer.timeoutInterval = 15.0f;
    [manager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    NSString *urlStr = [Utils getUrl:@"/order/buyGoods"];
    
    NSDictionary *parameters = @{@"productId":@"1"};
    [SVProgressHUD show];
    [manager POST:urlStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [SVProgressHUD dismiss];
        NSDictionary *dict = responseObject;
        if ([dict[@"flag"] integerValue] == 1) {
            
            BuyViewController *buyVC = [[BuyViewController alloc]initWithDictionary:dict[@"result"]];
            buyVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:buyVC animated:YES];
            
        } else {
            
            NSString *url = [[NSUserDefaults standardUserDefaults] objectForKey:@"url1"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD showErrorWithStatus:@"网络异常" maskType:SVProgressHUDMaskTypeBlack];
    }];
}

- (IBAction)contactClick:(id)sender {
    
    ContactViewController *contactVC = [[ContactViewController alloc]init];
    contactVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:contactVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
