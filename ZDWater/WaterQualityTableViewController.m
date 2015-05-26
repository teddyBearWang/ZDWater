                                                                                                                                   //
//  WaterQualityTableViewController.m
//  ZDWater
//
//  Created by teddy on 15/5/19.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "WaterQualityTableViewController.h"
#import "CustomHeaderView.h"
#import "WaterQuality.h"
#import "WaterCell.h"
#import "QualityDetailController.h"
#import "QualityDetaiObject.h"

@interface WaterQualityTableViewController ()


@end

@implementation WaterQualityTableViewController


static NSArray *_dataSource = nil;
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    [self.tableView reloadData];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDate *now = [NSDate date];
    NSArray *dates =(NSArray *)[self getRequestDates:now];
    
    BOOL ret = [WaterQuality FetchWithType:@"GetSzInfo" withStrat:[dates objectAtIndex:0] withEnd:[dates objectAtIndex:1]];
    if (ret) {
        _dataSource = [WaterQuality RequestData];
    }
}

- (NSMutableArray *)getRequestDates:(NSDate *)nowDate
{
    NSMutableArray *dates = [NSMutableArray array];
    NSTimeInterval seconds = 24 * 60 *60;
    //当前时间的前一天
    NSDate *torrow = [nowDate dateByAddingTimeInterval:seconds];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    //时间字符串
    NSString *now = [formatter stringFromDate:nowDate];
    NSString *torrTd = [formatter stringFromDate:torrow];
    [dates addObject:now];
    [dates addObject:torrTd];
    return dates;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WaterCell *cell = (WaterCell *)[tableView dequeueReusableCellWithIdentifier:@"WaterCell"];
    if (cell) {
        cell = (WaterCell *)[[[NSBundle mainBundle] loadNibNamed:@"WaterCell" owner:nil options:nil] lastObject];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSDictionary *dic = [_dataSource objectAtIndex:indexPath.row];
    cell.stationName.text = [[dic objectForKey:@"CZMC"] isEqual:@""] ? @"--" : [dic objectForKey:@"CZMC"];
    cell.lastestLevel.text = [[dic objectForKey:@"JD"] isEqual:@""] ? @"--" : [dic objectForKey:@"JD"];
    cell.warnWater.text = [[dic objectForKey:@"WD"] isEqual:@""] ? @"--" : [dic objectForKey:@"WD"];
    return cell;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CustomHeaderView *view = [[CustomHeaderView alloc] initWithFirstLabel:@"区域" withSecond:@"站名" withThree:@"水质"];
    view.backgroundColor = BG_COLOR;
    return view;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDate *now = [NSDate date];
    NSArray *dates =(NSArray *)[self getRequestDates:now]; //时间数组
    
    NSDictionary *dic = [_dataSource objectAtIndex:indexPath.row];
    BOOL ret = [QualityDetaiObject fetchWithType:@"GetSzInfoView" start:[dates objectAtIndex:0] end:[dates objectAtIndex:1] stcd:[dic objectForKey:@"CZBH"]];
    if (ret) {
        QualityDetailController *quality = [[QualityDetailController alloc] init];
        //获取数据源
        quality.datas = [QualityDetaiObject requestDetailData];
        [self.navigationController pushViewController:quality animated:YES];
    }else{
        //获取数据失败
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

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
