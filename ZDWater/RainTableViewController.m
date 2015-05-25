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

@interface RainTableViewController ()
{
    NSArray *dataSource;
}

@end

@implementation RainTableViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //会随着tableVIew滑动
//    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.tableView.frame.size.width,50)];
//    headView.backgroundColor = [UIColor colorWithRed:35/255.0 green:140/255.0 blue:233/255.0 alpha:1.0f];
//    self.tableView.tableHeaderView = headView;
    
    BOOL ret = [RainObject fetch];
    if (ret) {
        dataSource = [RainObject requestRainData];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RainCell *cell = (RainCell *)[tableView dequeueReusableCellWithIdentifier:@"RainCell" forIndexPath:indexPath];
    
    
    NSDictionary *dic = [dataSource objectAtIndex:indexPath.row];
    cell.StationName.text = [dic objectForKey:@"Stnm"]?[dic objectForKey:@"Stnm"] :@"--";
   // NSString *str = [dic objectForKey:@"Last1Hours"];
    cell.oneHour.text = [[dic objectForKey:@"Last1Hours"] isEqual:@""] ? @"--" :[dic objectForKey:@"Last1Hours"];
    
   // NSLog(@"%@",[dic objectForKey:@"Last1Hours"]);
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
