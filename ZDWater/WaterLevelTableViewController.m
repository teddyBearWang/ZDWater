//
//  WaterLevelTableViewController.m
//  ZDWater
//
//  Created by teddy on 15/5/19.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "WaterLevelTableViewController.h"
#import "CustomHeaderView.h"
#import "WaterSituation.h"
#import "WaterCell.h"
#import "ChartViewController.h"

@interface WaterLevelTableViewController ()
{
    NSArray *waterLevels; //水情数据源
}

@end

@implementation WaterLevelTableViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //保证竖屏
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = UIInterfaceOrientationPortrait;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
    
    [self.tableView reloadData];
}
static BOOL ret = NO;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDate *now = [NSDate date];
    NSString *date_str = [self getStringWithDate:now];
    ret = [WaterSituation fetchWithType:@"GetSqInfo" area:@"33" date:date_str start:@"0" end:@"10000"];
    if (ret) {
        waterLevels = [WaterSituation requestWaterData];
    }else{
        waterLevels = [NSArray arrayWithObject:@"当前暂无水情数据"];
    }
}

//根据时间格式化时间字符串
- (NSString *)getStringWithDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *date_str = [formatter stringFromDate:date];
    return date_str;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return waterLevels.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(ret)
    {
        //有数据的时候
        WaterCell *cell = (WaterCell *)[tableView dequeueReusableCellWithIdentifier:@"WaterCell"];
        if (cell) {
            cell = (WaterCell *)[[[NSBundle mainBundle] loadNibNamed:@"WaterCell" owner:nil options:nil] lastObject];
        }
        NSDictionary *dic = [waterLevels objectAtIndex:indexPath.row];
        cell.stationName.text = [[dic objectForKey:@"Stnm"] isEqual:@""] ? @"--" : [dic objectForKey:@"Stnm"];
        cell.lastestLevel.text = [[dic objectForKey:@"NowValue"] isEqual:@""] ? @"--" : [dic objectForKey:@"NowValue"];
        cell.warnWater.text = [[dic objectForKey:@"WarningLine"] isEqual:@""] ? @"--" : [dic objectForKey:@"WarningLine"];
        return cell;
    }else{
        //无数据
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WaterCell"];
        cell.textLabel.text = [waterLevels objectAtIndex:0];
        return cell;
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CustomHeaderView *view = [[CustomHeaderView alloc] initWithFirstLabel:@"测站" withSecond:@"最新(m)" withThree:@"超警(m)"];
    view.backgroundColor = BG_COLOR;
    return view;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [waterLevels objectAtIndex:indexPath.row];
    ChartViewController *chart = [[ChartViewController alloc] init];
    chart.title_name = dic[@"Stnm"];
    chart.requestType = @"GetStDaySW";
    chart.stcd = dic[@"Stcd"];
    chart.chartType = 1;
    chart.functionType = FunctionSingleChart;
    [self.navigationController pushViewController:chart animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
