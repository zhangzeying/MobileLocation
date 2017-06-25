//
//  PhoneLocationViewController.m
//  MobileLocation
//
//  Created by zzy on 06/06/2017.
//  Copyright © 2017 lanmao. All rights reserved.
//

#import "PhoneLocationViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "CustomNavTitleView.h"
#import "LoginView.h"
#import "AuthorizationViewController.h"
@interface PhoneLocationViewController ()<CustomNavTitleViewDelegate,MAMapViewDelegate,AMapSearchDelegate>
/** 地图对象 */
@property(nonatomic,strong)MAMapView *mapView;
/** <##> */
@property (nonatomic, weak)LoginView *loginView;
/** <##> */
@property(nonatomic,strong)AMapSearchAPI *search;
/** <##> */
@property(assign,nonatomic)CGFloat longitude;
/** <##> */
@property(assign,nonatomic)CGFloat latitude;
/** <##> */
@property(assign,nonatomic)BOOL isFirst;
@end

@implementation PhoneLocationViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.isFirst = YES;
    [self setupMapView];
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    CustomNavTitleView *titleView = [[CustomNavTitleView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 44)];
    titleView.vc = self;
    titleView.delegate = self;
    titleView.btnTitle = @"开始定位";
    self.navigationItem.titleView = titleView;
   
    NSString *customerMobile = [[NSUserDefaults standardUserDefaults] objectForKey:@"customerMobile"];
    if (customerMobile.length == 0 && ([[[NSUserDefaults standardUserDefaults] objectForKey:@"authorizationState"] isEqualToString:@"0"] || [[NSUserDefaults standardUserDefaults] objectForKey:@"authorizationState"] == nil)) {
        
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
    }
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"isLogin"] boolValue]) {
        
        if (!self.loginView) {
            
            LoginView *loginView = [LoginView instanceLoginView];
            loginView.frame = [UIScreen mainScreen].bounds;
            loginView.vc = self;
            loginView.backgroundColor = [UIColor blackColor];
            loginView.alpha = 0.8f;
            [[[UIApplication sharedApplication] keyWindow] addSubview:loginView];
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

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];
    if (self.isFirst) {
        self.isFirst = NO;
        self.mapView.zoomLevel = 3;
    }
}

/**
 * 初始化地图
 */
- (void)setupMapView {
    
    self.mapView = [[MAMapView alloc] initWithFrame:self.view.frame];
    self.mapView.delegate = self;
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

- (void)rightBtnClick:(NSString *)phoneStr {
    
    
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    NSString *customerMobile = [[NSUserDefaults standardUserDefaults] objectForKey:@"customerMobile"];
    if ([phoneStr isEqualToString:username] || [phoneStr isEqualToString:customerMobile]) {
        
        [self location:phoneStr];
        
    } else {
    
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"authorizationState"] isEqualToString:@"0"]) {
            
            AuthorizationViewController *authorizationVC = [[AuthorizationViewController alloc]init];
            authorizationVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:authorizationVC animated:YES];
            
        } else {
            
            [self location:phoneStr];
        }
    }
}

- (void)location:(NSString *)phoneNum {

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",nil];
    manager.requestSerializer.timeoutInterval = 15.0f;
    [manager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    NSString *urlStr = [Utils getUrl:@"/users/findUserLocationByMobile"];
    NSDictionary *parameters = @{@"mobile":phoneNum};
    [manager POST:urlStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dict = responseObject;
        if ([dict[@"flag"] integerValue] == 1) {
            
            self.longitude = [dict[@"result"][@"longitude"] doubleValue];
            self.latitude = [dict[@"result"][@"latitude"] doubleValue];
            
            [self.mapView removeAnnotations:self.mapView.annotations];

            AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
            regeo.location = [AMapGeoPoint locationWithLatitude:self.latitude longitude:self.longitude];
            regeo.requireExtension = YES;
            [self.search AMapReGoecodeSearch:regeo];
            
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


- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation {
    
    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        MAPinAnnotationView *annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil) {
            
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.canShowCallout= YES;       //设置气泡可以弹出，默认为NO
        annotationView.animatesDrop = YES;        //设置标注动画显示，默认为NO
        annotationView.draggable = YES;        //设置标注可以拖动，默认为NO
        annotationView.pinColor = MAPinAnnotationColorPurple;
        return annotationView;
    }
    return nil;
}

/* 逆地理编码回调. */
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if (response.regeocode != nil)
    {
        self.mapView.zoomLevel = 17;
        MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
        pointAnnotation.coordinate = CLLocationCoordinate2DMake(self.latitude, self.longitude);
        NSLog(@"%@",response.regeocode.addressComponent.streetNumber.street);
        pointAnnotation.title = @"地址";
        pointAnnotation.subtitle = response.regeocode.formattedAddress;
        NSArray *annotationArr = [NSArray arrayWithObjects:pointAnnotation, nil];
        [self.mapView addAnnotations:annotationArr];
        [self.mapView showAnnotations:annotationArr edgePadding:UIEdgeInsetsMake(20, 20, 20, 80) animated:YES];
    }
}

- (void)dealloc {
    
    [self.mapView removeAnnotations:self.mapView.annotations];
    self.mapView = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
