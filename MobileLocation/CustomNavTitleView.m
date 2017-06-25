//
//  CustomNavTitleView.m
//  MobileLocation
//
//  Created by zzy on 09/06/2017.
//  Copyright © 2017 lanmao. All rights reserved.
//

#import "CustomNavTitleView.h"
#import <ContactsUI/ContactsUI.h>
#import <Contacts/Contacts.h>
#import <AddressBookUI/AddressBookUI.h>
#import <AddressBook/AddressBook.h>
@interface CustomNavTitleView ()<CNContactPickerDelegate,ABPeoplePickerNavigationControllerDelegate>
/** <##> */
@property (nonatomic, weak)UIButton *dropMenuBtn;
/** <##> */
@property (nonatomic, weak)UIView *dropDownMenuView;
/** <##> */
@property (nonatomic, weak)UIButton *rightBtn;
/** <##> */
@property (nonatomic, weak)UITextField *phoneTxt;
@end

@implementation CustomNavTitleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIButton *dropMenuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [dropMenuBtn setTitle:@"手机" forState:UIControlStateNormal];
        dropMenuBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [dropMenuBtn setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
        dropMenuBtn.frame = CGRectMake(0, 0, 70, self.height);
        [dropMenuBtn addTarget:self action:@selector(dropDownClick:) forControlEvents:UIControlEventTouchUpInside];
        CGFloat labelWidth = dropMenuBtn.titleLabel.intrinsicContentSize.width; //注意不能直接使用titleLabel.frame.size.width,原因为有时候获取到0值
        CGFloat imageWidth = dropMenuBtn.imageView.frame.size.width;
        CGFloat space = 2.f; //定义两个元素交换后的间距
        dropMenuBtn.titleEdgeInsets = UIEdgeInsetsMake(0, - imageWidth - space,0,imageWidth + space);
        dropMenuBtn.imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth + space, 0,  -labelWidth - space);
        [self addSubview:dropMenuBtn];
        self.dropMenuBtn = dropMenuBtn;
        
        UIButton *addressBookBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [addressBookBtn setImage:[UIImage imageNamed:@"address_book"] forState:UIControlStateNormal];
        addressBookBtn.frame = CGRectMake(CGRectGetMaxX(dropMenuBtn.frame), 0, 24, self.height);
        [addressBookBtn addTarget:self action:@selector(addressBookClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:addressBookBtn];
        
        
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
        rightBtn.frame = CGRectMake(self.width - 82, 0, 70, self.height);
        [self addSubview:rightBtn];
        self.rightBtn = rightBtn;
        
        
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = [UIColor whiteColor];
        line.frame = CGRectMake(CGRectGetMaxX(addressBookBtn.frame)+2, 34, rightBtn.x - CGRectGetMaxX(addressBookBtn.frame)-2, 1);
        [self addSubview:line];
        
        UITextField *phoneTxt = [[UITextField alloc]init];
        phoneTxt.placeholder = @"请输入号码";
        [phoneTxt setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
        phoneTxt.font = [UIFont systemFontOfSize:16];
        phoneTxt.textColor = [UIColor whiteColor];
        phoneTxt.keyboardType = UIKeyboardTypeNumberPad;
        phoneTxt.frame = CGRectMake(line.x, 10, line.width, 20);
        [self addSubview:phoneTxt];
        self.phoneTxt = phoneTxt;
    }
    return self;
}

- (void)setBtnTitle:(NSString *)btnTitle {

    [self.rightBtn setTitle:btnTitle forState:UIControlStateNormal];
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

    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0f) {
        
        CNContactPickerViewController *picketVC = [[CNContactPickerViewController alloc] init];
        picketVC.delegate = self;
        picketVC.displayedPropertyKeys = @[CNContactPhoneNumbersKey];
        [self.vc presentViewController:picketVC animated:YES completion:nil];
        
    } else {
    
        ABPeoplePickerNavigationController *pvc = [[ABPeoplePickerNavigationController alloc] init];
        pvc.peoplePickerDelegate = self;
        if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined)
        {
            ABAddressBookRef bookRef = ABAddressBookCreate();
            ABAddressBookRequestAccessWithCompletion(bookRef, ^(bool granted, CFErrorRef error) {
                if (granted)
                {
                    [self.vc presentViewController:pvc animated:YES completion:nil];
                }
            });
        }
        else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized)
        {
            [self.vc presentViewController:pvc animated:YES completion:nil];
        }
    }
    

}

- (void)creatDropDownMenu {
    
    NSArray *arr = @[@"手机",@"QQ",@"微信"];
    UIView *dropDownMenuView = [[UIView alloc]init];
    dropDownMenuView.backgroundColor = [UIColor colorWithHexString:@"aaaaaa"];
    dropDownMenuView.frame = CGRectMake(0, 64, 70, 0);
    [UIView animateWithDuration:0.1 animations:^{
        
        dropDownMenuView.height = arr.count * 40;
    }];
    
    [self.vc.view addSubview:dropDownMenuView];
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

- (void)rightBtnClick {

    self.phoneTxt.text = [self.phoneTxt.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    [self.phoneTxt resignFirstResponder];
    if (self.phoneTxt.text.length == 0) {
        
        [SVProgressHUD showErrorWithStatus:@"号码不能为空" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(rightBtnClick:)]) {
        
        [self.delegate rightBtnClick:self.phoneTxt.text];
    }
}

- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty {
    
    CNPhoneNumber *phoneNumer = contactProperty.value;
    self.phoneTxt.text = phoneNumer.stringValue;
    self.phoneTxt.text = [self.phoneTxt.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
}

// 选择某个联系人时调用
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person
{
    ABMultiValueRef multi = ABRecordCopyValue(person, kABPersonPhoneProperty);
    CFIndex count = ABMultiValueGetCount(multi);
    if (count > 0) {
        
        NSString *phone =(__bridge_transfer NSString *)  ABMultiValueCopyValueAtIndex(multi, 0);
        self.phoneTxt.text = phone;
        self.phoneTxt.text = [self.phoneTxt.text stringByReplacingOccurrencesOfString:@"-" withString:@""];

    }
    
}
@end
