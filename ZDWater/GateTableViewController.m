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

@interface GateTableViewController ()
{
    NSArray *listData;// 数据源
}

@end

@implementation GateTableViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
