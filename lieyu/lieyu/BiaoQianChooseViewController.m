//
//  BiaoQianChooseViewController.m
//  lieyu
//
//  Created by 薛斯岐 on 15/9/22.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "BiaoQianChooseViewController.h"
#import "TypeChooseCell.h"
#import "BiaoQianBtn.h"
@interface BiaoQianChooseViewController ()

@end

@implementation BiaoQianChooseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.showsHorizontalScrollIndicator=NO;
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.separatorColor=[UIColor clearColor];
    // Do any additional setup after loading the view from its nib.
}
#pragma mark table代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    return @"今日发布套餐：15套";
//}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 34)];
    view.backgroundColor=[UIColor whiteColor];
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(15, 11, 200, 12)];
    label.text=@"酒水";
    label.font=[UIFont systemFontOfSize:12];
    label.textColor=RGB(51, 51, 51);
    [view addSubview:label];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 34;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"TypeChooseCell";
    
     TypeChooseCell*cell = (TypeChooseCell *)[_tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        cell = (TypeChooseCell *)[nibArray objectAtIndex:0];
        cell.backgroundColor=[UIColor whiteColor];
        
        
    }
    [cell.oneBtn setTitle:@"1000以内" forState:UIControlStateNormal];
    [cell.twoBtn setTitle:@"鸡尾酒" forState:UIControlStateNormal];
    cell.twoBtn.selected=YES;
    [cell.threeBtn setTitle:@"黑方" forState:UIControlStateNormal];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:false];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)sureAct:(id)sender {
}
@end
