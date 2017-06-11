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
#import "NewFeatureController.h"
@interface AppDelegate ()<AMapLocationManagerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 调整SVProgressHUD的背景色和前景色
    [SVProgressHUD setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.8]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [self buildKeyWindow];
    [self checkIsShowNewFeature];
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
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    
    return YES;
}


- (void)buildKeyWindow {
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    
}

- (void)initSDK {

    //高德地图 开启 HTTPS
    [[AMapServices sharedServices] setEnableHTTPS:YES];
    [AMapServices sharedServices].apiKey = kAmapAppKey;
    [self startLocation];
    
}

- (void)checkIsShowNewFeature {
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    NSString *lastVersion = [ud objectForKey:@"newFeatureVersion"]; //取出上次版本号
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey]; //现在的版本号
    
    if ([version isEqualToString:lastVersion]) {//如果版本相同
        
        HomeTabBarController *tabVC = [[HomeTabBarController alloc]init];
        self.window.rootViewController = tabVC;
        
    } else {//如果版本不相同
        
        NewFeatureController *newFeatureVC = [[NewFeatureController alloc]init];
        self.window.rootViewController = newFeatureVC;
        [ud setObject:version forKey:@"newFeatureVersion"];
        [ud synchronize];
        self.window.rootViewController = newFeatureVC;
    }
}

- (void)startLocation {

    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    if (username.length > 0) {
        
        self.locationManager = [[AMapLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [self.locationManager setPausesLocationUpdatesAutomatically:NO];
        self.locationManager.distanceFilter = 50;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9) {
            self.locationManager.allowsBackgroundLocationUpdates = YES;
        }
        [self.locationManager startUpdatingLocation];
    }
}

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location
{
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    BOOL isLogin = [[[NSUserDefaults standardUserDefaults] objectForKey:@"isLogin"] boolValue];
    if (username.length > 0 && isLogin) {
    
        AFHTTPSessionManager *httpManager = [AFHTTPSessionManager manager];
        httpManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        httpManager.responseSerializer = [AFJSONResponseSerializer serializer];
        httpManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",nil];
        httpManager.requestSerializer.timeoutInterval = 15.0f;
        [httpManager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
        NSString *urlStr = [Utils getUrl:@"/users/realTimeUpdateLocation"];
        NSDictionary *parameters = @{@"latitude": @(location.coordinate.latitude),
                                     @"longitude":@(location.coordinate.longitude),
                                     @"username":username?:@""};
        [httpManager POST:urlStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        }];
    }
    
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
