//
//  Config.h
//  BathroomShopping
//
//  Created by zzy on 7/2/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#ifndef Config_h
#define Config_h

#define CustomColor(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha: 1.0]
#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height
#define BSNotificationCenter [NSNotificationCenter defaultCenter]
#define kAppDelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])
#define baseurl @"http://139.199.8.67:3000"
//高德地图
#define kAmapAppKey @"ea13e9fe9d74caf06f36f2d5af89b6e6"

#endif /* Config_h */



