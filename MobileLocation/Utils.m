//
//  Utils.m
//  MobileLocation
//
//  Created by zzy on 10/06/2017.
//  Copyright © 2017 lanmao. All rights reserved.
//

#import "Utils.h"

@implementation Utils
+ (NSString *)getUrl:(NSString *)resource {
    
    return [NSString stringWithFormat:@"%@%@",baseurl, resource];
}
@end
