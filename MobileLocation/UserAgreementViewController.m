//
//  UserAgreementViewController.m
//  MobileLocation
//
//  Created by zzy on 10/06/2017.
//  Copyright © 2017 lanmao. All rights reserved.
//

#import "UserAgreementViewController.h"

@interface UserAgreementViewController ()
@property (strong, nonatomic)UILabel *contentLbl;
@end

@implementation UserAgreementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"用户协议";
    self.view.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    UIScrollView *scroll = [[UIScrollView alloc]initWithFrame:self.view.frame];
    scroll.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:scroll];
    
    self.contentLbl = [[UILabel alloc]init];
    self.contentLbl.textColor = [UIColor darkGrayColor];
    self.contentLbl.font = [UIFont systemFontOfSize:15];
    self.contentLbl.numberOfLines = 0;
    self.contentLbl.lineBreakMode = NSLineBreakByWordWrapping;
    
    [scroll addSubview:self.contentLbl];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",nil];
    manager.requestSerializer.timeoutInterval = 15.0f;
    [manager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    NSString *urlStr = [Utils getUrl:@"/system/getUserAgreement"];
    [manager GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dict = responseObject;
        if ([dict[@"flag"] integerValue] == 1) {
            
            self.contentLbl.text = dict[@"result"][@"userAgreement"];
            CGRect rect = [self.contentLbl.text boundingRectWithSize:CGSizeMake(self.view.width - 2 * 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15],NSFontAttributeName, nil] context:nil];
            self.contentLbl.frame = CGRectMake(20, 15, self.view.width - 2 * 20, rect.size.height);
            scroll.contentSize = CGSizeMake(0, self.contentLbl.height + 25);
            
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
