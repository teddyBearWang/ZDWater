//
//  WaterYieldTableViewController.m
//  ZDWater
//  
//  Created by teddy on 15/5/19.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "WaterYieldTableViewController.h"
#import "WaterYield.h"
#import "CustomHeaderView.h"
#import "WaterCell.h"
#import "ChartViewController.h"

@interface WaterYieldTableViewController ()
{
    NSArray *listData; //数据源
}

@end

@implementation WaterYieldTableViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

static BOOL ret = NO;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = UIInterfaceOrientationPortrait;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
    
    NSDate *data = [NSDate date];
    NSString *date_str = [self getStringWithDate:data];
    ret = [WaterYield fetchWithType:@"GetSlInfo" date:date_str];
    if (ret) {
        listData = [WaterYield requestWithDatas];
    }else{
        listData = [NSArray arrayWithObject:@"当前暂无数据信息"];
    }
    
}

//根据时间格式化时间字符串
- (NSString *)getStringWithDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *date_str = [formatter stringFromDate:date];
    return date_str;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return listData.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(ret)
    {
        //有数据的时候
        WaterCell *cell = (WaterCell *)[tableView dequeueReusableCellWithIdentifier:@"WaterCell"];
        if (cell) {
            cell = (WaterCell *)[[[NSBundle mainBundle] loadNibNamed:@"WaterCell" owner:nil options:nil] lastObject];
        }
        NSDictionary *dic = [listData objectAtIndex:indexPath.row];
        cell.stationName.text = [[dic objectForKey:@"Stnm"] isEqual:@""] ? @"--" : [dic objectForKey:@"Stnm"];
        cell.lastestLevel.text = [[dic objectForKey:@"planVal"] isEqual:@""] ? @"--" : [dic objectForKey:@"planVal"];
        cell.warnWater.text = [[dic objectForKey:@"realVal"] isEqual:@""] ? @"--" : [dic objectForKey:@"realVal"];
        return cell;
    }else{
        //无数据
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WaterCell"];
        cell.textLabel.text = [listData objectAtIndex:0];
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CustomHeaderView *headview = [[CustomHeaderView alloc] initWithFirstLabel:@"站名" withSecond:@"计划流量" withThree:@"实际流量"];
    headview.backgroundColor = BG_COLOR;
    return headview;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [listData objectAtIndex:indexPath.row];
    ChartViewController *chart = [[ChartViewController alloc] init];

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
