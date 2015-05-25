//
//  LoginViewController.m
//  ZDWater
//
//  Created by teddy on 15/5/18.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "LoginViewController.h"
#import "MenuViewController.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.loginBtn setCorners:5.0];
    [self.loginBtn setShadow];
    
    [self.bgView setCorners:5.0];
    
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

- (IBAction)login:(id)sender
{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MenuViewController *menu = (MenuViewController *)[story instantiateInitialViewController];
    [self presentViewController:menu animated:YES completion:NULL];
}
@end
