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

@interface WaterLevelTableViewController ()
{
    NSArray *waterLevels; //水情数据源
}

@end

@implementation WaterLevelTableViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
    // Return the number of rows in the section.
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

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
