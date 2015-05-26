//
//  RainCell.h
//  ZDWater
//
//  Created by teddy on 15/5/18.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RainCell : UITableViewCell


@property (nonatomic, strong) IBOutlet UILabel *area; //区域
@property (nonatomic, strong) IBOutlet UILabel *StationName; //测站
@property (nonatomic, strong) IBOutlet UILabel *oneHour; //一小时
@property (nonatomic, strong) IBOutlet UILabel *threeHour; //三小时
@property (nonatomic, strong) IBOutlet UILabel *today; //今日
@end
