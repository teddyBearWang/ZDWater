//
//  WaterQuality.h
//  ZDWater
//
//  Created by teddy on 15/5/25.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"

@interface WaterQuality : NSObject

//是否获取数据成功
+ (BOOL)Fetch;

//获取详细的数据
+ (NSArray *)RequestData;

@end
