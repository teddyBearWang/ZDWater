 //
//  RainTableViewController.m
//  ZDWater
//
//  Created by teddy on 15/5/19.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "RainTableViewController.h"
#import "RainObject.h"
#import "RainCell.h"
#import "UIView+RootView.h"

@interface RainTableViewController ()
{
    NSMutableArray *dataSource;
}

@end

@implementation RainTableViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
  //  [self.tableView reloadData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDate *now = [NSDate date];
    NSString *date_str = [self requestDate:now];
    
   BOOL ret = [RainObject fetchWithType:@"GetYqInfo" withArea:@"33" withDate:date_str withstart:@"0" withEnd:@"10000"];
    //if (ret) {
      //  NSArray *arr = [RainObject requestRainData];
       // dataSource = [NSMutableArray arrayWithArray:arr];
    //}
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = (CGRect){0,0,60,40};
    [btn setCorners:5.0];
    [btn setTitle:@"筛选" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(selectAreaAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = item;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadCompleteAction:) name:kLoadCompleteNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//页面消失的时候
- (void)viewWillDisappear:(BOOL)animated
{
    //移除详细对象
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kLoadCompleteNotification object:nil];
}
#pragma  mark - Private Method
//筛选按钮
- (void)selectAreaAction:(UIButton *)button
{
    SelectViewController *select = [[SelectViewController alloc] init];
    select.delegate = self;
    [self.navigationController pushViewController:select animated:YES];
}

//返回时间字符串
- (NSString *)requestDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *date_str = [formatter stringFromDate:date];
    return date_str;
    
}

- (void)loadCompleteAction:(NSNotification *)notification
{
    NSArray *array = (NSArray *)notification.object;
    dataSource = [NSMutableArray arrayWithArray:array];
    [self.tableView reloadData];
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RainCell *cell = (RainCell *)[tableView dequeueReusableCellWithIdentifier:@"RainCell" forIndexPath:indexPath];
    
    
    NSDictionary *dic = [dataSource objectAtIndex:indexPath.row];
    cell.area.text = [[dic objectForKey:@"Adnm"] isEqual:@""] ? @"--" : [dic objectForKey:@"Adnm"];
    cell.StationName.text = [[dic objectForKey:@"Stnm"] isEqual:@""]?@"--" : [dic objectForKey:@"Stnm"];
    cell.oneHour.text = [[dic objectForKey:@"Last1Hours"] isEqual:@""] ? @"--" :[dic objectForKey:@"Last1Hours"];
    
    cell.threeHour.text = [[dic objectForKey:@"Last3Hours"] isEqual:@""] ? @"--" : [dic objectForKey:@"Last3Hours"];
    cell.today.text = [[dic objectForKey:@"Last6Hours"] isEqual:@""] ?@"--" : [dic objectForKey:@"Last6Hours"];
    return cell;
}

//这样的话，headView不随着cell滚动
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
   // UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0,0,tableView.frame.size.width,40)];
    UIView *headView = (UIView *)[[[NSBundle mainBundle] loadNibNamed:@"RainHeaderView" owner:self options:nil] lastObject];

    headView.backgroundColor = BG_COLOR;
    return headView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - SelectItemsDelegate

- (void)selectItemAction:(NSString *)area
{
    NSMutableArray *countArr = [NSMutableArray arrayWithArray:dataSource]; //重新复制一个可变数组，保证数组内部每个元素都可以循环到
    for (int i=0; i<countArr.count; i++) {
        NSDictionary *dic = [countArr objectAtIndex:i];
        NSString *str = [dic objectForKey:@"Adnm"];
        if (![str isEqual:area]) {
            [dataSource removeObject:dic];
        }
    }
    
    [self.tableView reloadData];
}

@end
