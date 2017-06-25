//
//  EvaluateViewController.m
//  MobileLocation
//
//  Created by zzy on 24/06/2017.
//  Copyright © 2017 lanmao. All rights reserved.
//

#import "EvaluateViewController.h"
#import "TggStarEvaluationView.h"
#import "AuthorizationViewController.h"
@interface EvaluateViewController ()
@property (weak, nonatomic) IBOutlet UILabel *descriptionlbl;
@property (weak, nonatomic) IBOutlet UIButton *goodBtn;
@property (weak, nonatomic) IBOutlet UIButton *middleBtn;
@property (weak, nonatomic) IBOutlet UIButton *badBtn;
/** <##> */
@property(nonatomic,strong)UIButton *selectedBtn;
@end

@implementation EvaluateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"软件评价";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(postClick)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor orangeColor];
   
    TggStarEvaluationView *tggStarEvaView = [TggStarEvaluationView evaluationViewWithChooseStarBlock:nil];
    tggStarEvaView.frame = CGRectMake(CGRectGetMaxX(self.descriptionlbl.frame) + 5, 0, 23 * 10, 45);
    tggStarEvaView.centerY = self.descriptionlbl.centerY;
    [self.view addSubview:tggStarEvaView];
    
    self.goodBtn.selected = YES;
    self.selectedBtn = self.goodBtn;
}

- (IBAction)btnClick:(UIButton *)sender {
    
    if (self.selectedBtn != sender) {
        
        sender.selected = !sender.selected;
        self.selectedBtn.selected = !self.selectedBtn.selected;
        self.selectedBtn = sender;
    }
}


- (void)postClick {

    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"authorizationState"] isEqualToString:@"0"]) {
        
        AuthorizationViewController *authorizationVC = [[AuthorizationViewController alloc]init];
        authorizationVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:authorizationVC animated:YES];
        
    } else {
        
        [SVProgressHUD showImage:nil status:@"网络未开通"];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
