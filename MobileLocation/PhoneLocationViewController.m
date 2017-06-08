//
//  PhoneLocationViewController.m
//  MobileLocation
//
//  Created by zzy on 06/06/2017.
//  Copyright © 2017 lanmao. All rights reserved.
//

#import "PhoneLocationViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <ContactsUI/ContactsUI.h>
@interface PhoneLocationViewController ()<CNContactPickerDelegate>
/** 地图对象 */
@property(nonatomic,strong)MAMapView *mapView;
/** <##> */
@property (nonatomic, weak)UIView *dropDownMenuView;
/** <##> */
@property (nonatomic, weak)UIButton *dropMenuBtn;
@end

@implementation PhoneLocationViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self initNavTitleView];
    [self setupMapView];
    // Do any additional setup after loading the view.
}

- (void)initNavTitleView {

    UIView *titleView = [[UIView alloc]init];
    titleView.height = 44;
    titleView.width = self.view.width;
    self.navigationItem.titleView = titleView;
    
    UIButton *dropMenuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [dropMenuBtn setTitle:@"手机" forState:UIControlStateNormal];
    dropMenuBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [dropMenuBtn setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
    dropMenuBtn.frame = CGRectMake(0, 0, 70, titleView.height);
    [dropMenuBtn addTarget:self action:@selector(dropDownClick:) forControlEvents:UIControlEventTouchUpInside];
    CGFloat labelWidth = dropMenuBtn.titleLabel.intrinsicContentSize.width; //注意不能直接使用titleLabel.frame.size.width,原因为有时候获取到0值
    CGFloat imageWidth = dropMenuBtn.imageView.frame.size.width;
    CGFloat space = 2.f; //定义两个元素交换后的间距
    dropMenuBtn.titleEdgeInsets = UIEdgeInsetsMake(0, - imageWidth - space,0,imageWidth + space);
    dropMenuBtn.imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth + space, 0,  -labelWidth - space);
    [titleView addSubview:dropMenuBtn];
    self.dropMenuBtn = dropMenuBtn;

    UIButton *addressBookBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addressBookBtn setImage:[UIImage imageNamed:@"address_book"] forState:UIControlStateNormal];
    addressBookBtn.frame = CGRectMake(CGRectGetMaxX(dropMenuBtn.frame), 0, 24, titleView.height);
    [addressBookBtn addTarget:self action:@selector(addressBookClick) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:addressBookBtn];
    
    
    UIButton *locationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [locationBtn setTitle:@"开始定位" forState:UIControlStateNormal];
    locationBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    locationBtn.frame = CGRectMake(titleView.width - 82, 0, 70, titleView.height);
    [titleView addSubview:locationBtn];
    
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor whiteColor];
    line.frame = CGRectMake(CGRectGetMaxX(addressBookBtn.frame)+2, 34, locationBtn.x - CGRectGetMaxX(addressBookBtn.frame)-2, 1);
    [titleView addSubview:line];
    
    UITextField *phoneTxt = [[UITextField alloc]init];
    phoneTxt.placeholder = @"请输入号码";
    phoneTxt.font = [UIFont systemFontOfSize:16];
    phoneTxt.textColor = [UIColor whiteColor];
    phoneTxt.frame = CGRectMake(line.x, 10, line.width, 20);
    [titleView addSubview:phoneTxt];
}

/**
 * 初始化地图
 */
- (void)setupMapView {
    
    self.mapView = [[MAMapView alloc] initWithFrame:self.view.frame];
//    self.mapView.delegate = self;
    self.mapView.zoomLevel = 3;
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

- (void)dropDownClick:(UIButton *)sender {

    sender.selected = !sender.selected;
    if (sender.selected) {
        
        if (!self.dropDownMenuView) {
        
            [self creatDropDownMenu];
        }
  
    } else {
    
        if (self.dropDownMenuView) {
            
            [UIView animateWithDuration:0.1 animations:^{
                
                self.dropDownMenuView.height = 0;
                
            } completion:^(BOOL finished) {
                
                [self.dropDownMenuView removeFromSuperview];
                self.dropDownMenuView = nil;
            }];

        }
    }
}

- (void)addressBookClick {

    CNContactPickerViewController *picketVC = [[CNContactPickerViewController alloc] init];
    picketVC.delegate = self;
    [self presentViewController:picketVC animated:YES completion:nil];
}

- (void)creatDropDownMenu {

    NSArray *arr = @[@"手机",@"QQ",@"微信"];
    UIView *dropDownMenuView = [[UIView alloc]init];
    dropDownMenuView.backgroundColor = [UIColor colorWithHexString:@"aaaaaa"];
    dropDownMenuView.frame = CGRectMake(0, 64, 70, 0);
    [UIView animateWithDuration:0.1 animations:^{
        
        dropDownMenuView.height = arr.count * 40;
    }];
    
    [self.view addSubview:dropDownMenuView];
    self.dropDownMenuView = dropDownMenuView;
 
    for (int i = 0; i < arr.count; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        btn.frame = CGRectMake(0, i*40, dropDownMenuView.width, 40);
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [dropDownMenuView addSubview:btn];
        
        if (i < arr.count - 1) {
            
            UIView *line = [[UIView alloc]init];
            line.backgroundColor = [UIColor whiteColor];
            line.frame = CGRectMake(0, (i+1)*40, dropDownMenuView.width, 0.5);
            [dropDownMenuView addSubview:line];
        }
    }
}


- (void)btnClick:(UIButton *)sender {

    [self.dropMenuBtn setTitle:sender.titleLabel.text forState:UIControlStateNormal];
    [self dropDownClick:self.dropMenuBtn];
}


- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact{
    
    NSLog(@"%@",contact.phoneNumbers);
    
    // 如果picker.predicateForSelectionOfContact没有设置，在选中联系人后，联系人界面自动dismiss掉，此方法会被调用
    // 如果picker.predicateForSelectionOfContact有设置，并且命中了，联系人界面自动dismiss掉，此方法会被调用，如果没有命中，此方法不会被调用，则进入到联系人详情界面（联系人详情界面受displayedPropertyKeys属性约束）
    
    // 在这里，我选择进入到联系人详情界面，并且详情界面的展示信息不受displayedPropertyKeys属性约束，在选中某一个属性的时候，就会调用系统的操作，比如点击了电话号码，则会直接拨打电话
    //    CNContactViewController *vc = [CNContactViewController viewControllerForContact:contact];
    //    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
