//
//  CustomNavTitleView.h
//  MobileLocation
//
//  Created by zzy on 09/06/2017.
//  Copyright © 2017 lanmao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomNavTitleViewDelegate <NSObject>

- (void)rightBtnClick:(NSString *)phoneStr;

@end
@interface CustomNavTitleView : UIView
/** <##> */
@property (nonatomic, weak)UIViewController *vc;
/** <##> */
@property(nonatomic,copy)NSString *btnTitle;
@property (nonatomic,weak) id<CustomNavTitleViewDelegate> delegate;
@end
