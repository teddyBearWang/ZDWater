//
//  UINavigationController+Oritent.m
//  ZDWater
//
//  Created by teddy on 15/5/29.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "UINavigationController+Oritent.h"

@implementation UINavigationController (Oritent)

- (BOOL)shouldAutorotate{
    return self.topViewController.shouldAutorotate;
}
- (NSUInteger)supportedInterfaceOrientations{
    return self.topViewController.supportedInterfaceOrientations;
}

@end
