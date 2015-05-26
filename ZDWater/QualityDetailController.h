//
//  QualityDetailController.h
//  ZDWater
// ************水质详细信息********************
//  Created by teddy on 15/5/26.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "RootViewController.h"

@interface QualityDetailController : RootViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *tableView;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *datas;

@end
