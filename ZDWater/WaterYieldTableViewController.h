//
//  WaterYieldTableViewController.h
//  ZDWater
//  ***********实时水量***************
//  Created by teddy on 15/5/19.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UUChart.h"

@interface WaterYieldTableViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UUChartDataSource>

- (IBAction)tablebuttonSelectAction:(id)sender;
- (IBAction)chartButtonSelectAction:(id)sender;
@end
