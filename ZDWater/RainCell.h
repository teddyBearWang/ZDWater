//
//  RainCell.h
//  ZDWater
//
//  Created by teddy on 15/5/18.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RainCell : UITableViewCell


@property (nonatomic, strong) IBOutlet UILabel *StationName;
@property (nonatomic, strong) IBOutlet UILabel *oneHour;
@property (nonatomic, strong) IBOutlet UILabel *threeHour;
@property (nonatomic, strong) IBOutlet UILabel *today;
@end
