//
//  ChartViewController.m
//  ZDWater
//
//  Created by teddy on 15/5/28.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "ChartViewController.h"
#import "UUChart.h"
#import "ChartObject.h"

@interface ChartViewController ()<UUChartDataSource>
{
    UUChart *chartView;
    NSArray *x_Labels;
    NSArray *y_Values;
}

@end

@implementation ChartViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //强制屏幕横屏
        if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
            SEL selector = NSSelectorFromString(@"setOrientation:");
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
            [invocation setSelector:selector];
            [invocation setTarget:[UIDevice currentDevice]];
            int val = UIInterfaceOrientationLandscapeRight;
            [invocation setArgument:&val atIndex:2];
            [invocation invoke];
    }
    
    if (chartView) {
        [chartView removeFromSuperview];
        chartView = nil;
    }
    
    chartView = [[UUChart alloc]initwithUUChartDataFrame:CGRectMake(10, 40,
                                                                    self.view.frame.size.height, 240)
                                              withSource:self
                                               withStyle:UUChartBarStyle];
    [chartView showInView:self.view];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    BOOL ret = [ChartObject fetcChartDataWithType:@"GetStDayYL" stcd:@"8217" WithDate:@"2015-05-24"];
    if (ret) {
        x_Labels = (NSArray *)[ChartObject requestXLables];
        y_Values = (NSArray *)[ChartObject requestYValues];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UUChartDataSource

//横坐标标题数组
- (NSArray *)UUChart_xLableArray:(UUChart *)chart
{
//    NSArray *xTitles = [NSArray array];
//    xTitles = @[@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17"];
//    return xTitles;
    return x_Labels;
}

//数值多重数组
- (NSArray *)UUChart_yValueArray:(UUChart *)chart
{
//    NSArray *ary1 = @[@"0.5",@"0.0",@"0.0",@"31",@"14.5",@"4.0",@"3.0",@"0.0",@"5"];
//    NSArray *ary2 = @[@"0.0",@"0.55",@"0.6",@"30",@"10",@"30",@"8.0",@"9.0",@"8"];
//    return @[ary1,ary2];
    @try {
         return @[y_Values];
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
   
}

#pragma mark 折线图专享功能
//判断显示横线条
- (BOOL)UUChart:(UUChart *)chart ShowHorizonLineAtIndex:(NSInteger)index
{
    if (index == 4) {
        return YES;
    }else{
        return NO;
    }
    // return YES;
    
}

//判断显示竖线条
- (BOOL)UUChart:(UUChart *)chart ShowVericationLineAtIndex:(NSInteger)index
{
    if (index == 0) {
        return YES;
    }else{
        return NO;
    }
}

//颜色数组
- (NSArray *)UUChart_ColorArray:(UUChart *)chart
{
    return @[UUGreen,UURed,UUBrown];
}


@end
