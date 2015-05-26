//
//  SelectViewController.h
//  ZDWater
//
//  Created by teddy on 15/5/26.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "RootViewController.h"

@protocol SelectItemsDelegate <NSObject>

- (void)selectItemAction:(NSString *)area;

@end

@interface SelectViewController : RootViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *tableView;
}

@property (nonatomic) id<SelectItemsDelegate>delegate;
@property (nonatomic, strong) UITableView *tableView;

@end
