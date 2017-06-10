//
//  AppDelegate.m
//  MobileLocation
//
//  Created by zzy on 06/06/2017.
//  Copyright © 2017 lanmao. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeTabBarController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 调整SVProgressHUD的背景色和前景色
    [SVProgressHUD setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.8]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [self buildKeyWindow];
    [self initSDK];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",nil];
    manager.requestSerializer.timeoutInterval = 15.0f;
    [manager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    NSString *urlStr = [Utils getUrl:@"/customerService/getInfo"];
    [manager GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dict = responseObject;
        if ([dict[@"flag"] integerValue] == 1) {
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSString *customerMobile = dict[@"result"][@"mobile"];
            NSString *customerQQ = dict[@"result"][@"qq"];
            NSString *url1 = dict[@"result"][@"url"];
            NSString *url2 = dict[@"result"][@"url2"];
            if ([[userDefaults objectForKey:@"authorizationState"] isEqualToString:@"0"] || [userDefaults objectForKey:@"authorizationState"] == nil) {//未授权，更新客服信息
                
                [userDefaults setObject:customerMobile forKey:@"customerMobile"];
                [userDefaults setObject:customerQQ forKey:@"customerQQ"];
                [userDefaults setObject:url1 forKey:@"url1"];
                [userDefaults setObject:url2 forKey:@"url2"];
                [userDefaults synchronize];
            }
            
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
    
    
    return YES;
}


- (void)buildKeyWindow {
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    HomeTabBarController *loginVC = [[HomeTabBarController alloc]init];
    self.window.rootViewController = loginVC;
    [self.window makeKeyAndVisible];
    
    
}

- (void)initSDK {

    //高德地图 开启 HTTPS
    [[AMapServices sharedServices] setEnableHTTPS:YES];
    [AMapServices sharedServices].apiKey = kAmapAppKey;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
