//
//  GateTableViewController.m
//  ZDWater
//  ********实时闸门开度*****************
//  Created by teddy on 15/5/19.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "GateTableViewController.h"
#import "CustomHeaderView.h"
#import "WaterCell.h"
#import "GateObject.h"
#import "ChartViewController.h"

@interface GateTableViewController ()
{
    NSArray *listData;// 数据源
}

@end

@implementation GateTableViewController

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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    BOOL ret = [GateObject fetchWithType:@"GetZmInfo"];
    if (ret) {
        listData = [GateObject requestGateDatas];
    }
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return listData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //有数据的时候
    WaterCell *cell = (WaterCell *)[tableView dequeueReusableCellWithIdentifier:@"WaterCell"];
    if (cell) {
        cell = (WaterCell *)[[[NSBundle mainBundle] loadNibNamed:@"WaterCell" owner:nil options:nil] lastObject];
    }
    NSDictionary *dic = [listData objectAtIndex:indexPath.row];
    cell.stationName.text = [[dic objectForKey:@"SubStnm"] isEqual:@""] ? @"--" : [dic objectForKey:@"SubStnm"];
    cell.lastestLevel.text = [[dic objectForKey:@"ZkCount"] isEqual:@""] ? @"--" : [dic objectForKey:@"ZkCount"];
    cell.warnWater.text = [[dic objectForKey:@"maxKD"] isEqual:@""] ? @"--" : [dic objectForKey:@"maxKD"];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CustomHeaderView *headview = [[CustomHeaderView alloc] initWithFirstLabel:@"名称" withSecond:@"闸孔" withThree:@"开度"];
    headview.backgroundColor = BG_COLOR;
    return headview;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [listData objectAtIndex:indexPath.row];
    ChartViewController *chart = [[ChartViewController alloc] init];
    chart.requestType = @"GetZmChart";
    chart.chartType = 1;//折线图
    chart.title_name = dic[@"SubStnm"];
    chart.stcd = dic[@"SubStcd"];
    chart.functionType = FunctionDoubleChart;
    [self.navigationController pushViewController:chart animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
