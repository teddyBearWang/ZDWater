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
//#import "ChartViewController.h"
#import "UUChart.h"

@interface WaterYieldTableViewController ()
{
    NSArray *listData; //数据源
    UIButton *tableBtn; //
    UIButton *chartBtn;
    
    UUChart *chartView;
    UIView *chart_bg_view; //chart的父视图
}
@property (strong, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation WaterYieldTableViewController



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.myTableView reloadData];
    [self initChartView];

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
    
   // self.myTableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64);
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    
    
    //默"tableButton"是选中状态
    tableBtn = (UIButton *)[self.view viewWithTag:301];
    chartBtn = (UIButton *)[self.view viewWithTag:302];
    tableBtn.selected = YES;
    
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

//创建chartVIew
- (void)initChartView
{
    
    chart_bg_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 40)];
    [self.view addSubview:chart_bg_view];
    if (chartView) {
        [chartView removeFromSuperview];
        chartView = nil;
    }
    
    chartView = [[UUChart alloc]initwithUUChartDataFrame:CGRectMake(10, 10,
                                                                    chart_bg_view.frame.size.width-10, chart_bg_view.frame.size.height - 30)
                                              withSource:self
                                               withStyle: UUChartBarStyle];
    [chartView showInView:chart_bg_view];
    chart_bg_view.hidden = YES;
    
    UILabel *explanLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, chart_bg_view.frame.size.height - 30, chart_bg_view.frame.size.width, 30)];
    explanLabel.layer.borderWidth = 1.0;
    explanLabel.layer.borderColor = [UIColor blackColor].CGColor;
    explanLabel.text = @"红色:表示计划水量；绿色:表示实际水量";
    explanLabel.font = [UIFont systemFontOfSize:14];
    [chart_bg_view addSubview:explanLabel];
    
    
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
        if (cell == nil) {
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CustomHeaderView *headview = [[CustomHeaderView alloc] initWithFirstLabel:@"站名" withSecond:@"计划流量" withThree:@"实际流量"];
    headview.backgroundColor = BG_COLOR;
    return headview;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)tablebuttonSelectAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if (!btn.selected) {
        btn.selected = YES;
        chartBtn.selected = NO;
        chart_bg_view.hidden = YES;
        self.myTableView.hidden = NO;
    }
}

- (IBAction)chartButtonSelectAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if (!btn.selected) {
        btn.selected = YES;
        tableBtn.selected = NO;
        self.myTableView.hidden = YES;
        chart_bg_view.hidden = NO;
    }
}


#pragma mark - UUChartDataSource

//横坐标标题数组
- (NSArray *)UUChart_xLableArray:(UUChart *)chart
{
    NSMutableArray *x_labels = [NSMutableArray arrayWithCapacity:listData.count];
    for (int i=0; i<listData.count; i++) {
        NSDictionary *dic = [listData objectAtIndex:i];
        [x_labels addObject:[dic objectForKey:@"Stnm"]];
    }
    
    return x_labels;
}

//数值多重数组
- (NSArray *)UUChart_yValueArray:(UUChart *)chart
{
    NSMutableArray *y_realAry = [NSMutableArray arrayWithCapacity:listData.count];
    NSMutableArray *y_planAry = [NSMutableArray arrayWithCapacity:listData.count];
    for (int i=0; i<listData.count; i++) {
        NSDictionary *dic = [listData objectAtIndex:i];
        [y_realAry addObject:[dic objectForKey:@"realVal"]];
        [y_planAry addObject:[dic objectForKey:@"planVal"]];
    }
    return @[y_realAry,y_planAry];
}

//颜色数组
- (NSArray *)UUChart_ColorArray:(UUChart *)chart
{
    return @[UUGreen,UURed,UUBrown];
}

@end
