//
//  RainObject.m
//  ZDWater
//
//  Created by teddy on 15/5/25.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "RainObject.h"
#import "ASIHTTPRequest.h"

#define  URL @"http://115.236.2.245:38027/data.ashx?t=GetYqInfo&results=33$2015-05-25$0$10000"

@implementation RainObject


+ (BOOL)fetch
{
    __block BOOL ret = NO;
    
    NSURL *url = [NSURL URLWithString:URL];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    
    [request setCompletionBlock:^{
        //成功
        if (request.responseStatusCode == 200) {
            ret = YES;
            NSData *json = (NSData *)request.responseData;
            NSArray *jsonArr = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingMutableLeaves error:nil];
            rainData = jsonArr;
        }
        
    }];
    
    [request setFailedBlock:^{
        //失败
    }];
    
    [request startSynchronous];
    
    
    return ret;
}

static NSArray *rainData = nil;
+ (NSArray *)requestRainData
{
    return rainData;
}

@end
