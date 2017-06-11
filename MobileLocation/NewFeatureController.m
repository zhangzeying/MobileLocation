//
//  NewFeatureController.m
//  HeXin
//
//  Created by zzy on 10/10/15.
//  Copyright © 2015 zzy. All rights reserved.
//

#import "NewFeatureController.h"
#import "HomeTabBarController.h"
#import "UIView+Frame.h"
#define ImgCount 4
@interface NewFeatureController ()<UIScrollViewDelegate>
/** <##> */
@property(nonatomic,strong)UIScrollView *scrollView;
/** <##> */
@property(nonatomic,strong)UIPageControl *pageControl;
@end

@implementation NewFeatureController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setScrollView];
    [self setScrollImg];
}

- (void)setScrollView {

    self.scrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:self.scrollView];
    self.scrollView.contentSize = CGSizeMake(ImgCount*self.view.frame.size.width, 0);
    self.scrollView.bounces = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator = NO;
}

- (void)setScrollImg {
    
    for (int i = 0; i < ImgCount; i++) {
        
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake((self.scrollView.frame.size.width)*i, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
        img.image = [UIImage imageNamed:[NSString stringWithFormat:@"lead%d",i+1]];
        if (i == ImgCount - 1) {
            img.userInteractionEnabled = YES;
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setBackgroundImage:[UIImage imageNamed:@"lead_btn"] forState:UIControlStateNormal];
            btn.frame = CGRectMake(0, self.view.height - 45 - 80, 213, 45);
            btn.centerX = self.view.centerX;
            [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
            [img addSubview:btn];
        }
        [self.scrollView addSubview:img];
    }
    
    self.pageControl = [[UIPageControl alloc]init];
    self.pageControl.frame = CGRectMake(0, self.view.height - 30, self.view.width, 15);
    self.pageControl.centerX = self.view.centerX;
    self.pageControl.numberOfPages = ImgCount;
    self.pageControl.currentPage = 0;
    self.pageControl.pageIndicatorTintColor = [UIColor colorWithRed:0.263 green:0.365 blue:0.447 alpha:1.0];
    self.pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    self.pageControl.userInteractionEnabled = NO;
    [self.view addSubview:self.pageControl];
}


- (void)btnClick {

    HomeTabBarController *tabVC = [[HomeTabBarController alloc]init];
    [[UIApplication sharedApplication] keyWindow].rootViewController = tabVC;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    self.pageControl.currentPage = scrollView.contentOffset.x / scrollView.width;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
