//
//  LoginViewController.h
//  ZDWater
//
//  Created by teddy on 15/5/18.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "RootViewController.h"
#import "UIView+RootView.h"

@interface LoginViewController : RootViewController
@property (weak, nonatomic) IBOutlet UITextField *userField;
@property (weak, nonatomic) IBOutlet UITextField *psdField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
- (IBAction)login:(id)sender;

@end
