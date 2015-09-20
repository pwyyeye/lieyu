//
//  ZSReleasePackageViewController.m
//  lieyu
//
//  Created by SEM on 15/9/15.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "ZSReleasePackageViewController.h"
#import "FBTaoCanSectionBottom.h"
#import "FBTaoCanSectionHead.h"
#import "TaoCanMCell.h"
#import "FBTaoCanView.h"
@interface ZSReleasePackageViewController ()

@end

@implementation ZSReleasePackageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    taocanDelList=[[NSMutableArray alloc]init];
    [self.navigationController setNavigationBarHidden:NO];
    self.title=@"发布套餐";
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"FBTaoCanView" owner:nil options:nil];
    FBTaoCanView *taoCanView= (FBTaoCanView *)[nibView objectAtIndex:0];
    self.tableView.tableHeaderView=taoCanView;
    // Do any additional setup after loading the view from its nib.
}
#pragma mark table代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return taocanDelList.count;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    return @"今日发布套餐：15套";
//}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"FBTaoCanSectionHead" owner:nil options:nil];
    FBTaoCanSectionHead *taoCanSectionHead= (FBTaoCanSectionHead *)[nibView objectAtIndex:0];
    
    
    //            orderHeadView.detLal.text=orderInfoModel.paytime;
    //    view.backgroundColor=[UIColor yellowColor];
    return taoCanSectionHead;

}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"FBTaoCanSectionBottom" owner:nil options:nil];
    FBTaoCanSectionBottom *taoCanSectionBottom= (FBTaoCanSectionBottom *)[nibView objectAtIndex:0];
    
    
    //            orderHeadView.detLal.text=orderInfoModel.paytime;
    //    view.backgroundColor=[UIColor yellowColor];
    return taoCanSectionBottom;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 34;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 65;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
            static NSString *taoCanCellIdentifier = @"TaoCanMCell";
            
            TaoCanMCell *cell = (TaoCanMCell *)[_tableView dequeueReusableCellWithIdentifier:taoCanCellIdentifier];
            if (cell == nil) {
                NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:taoCanCellIdentifier owner:self options:nil];
                cell = (TaoCanMCell *)[nibArray objectAtIndex:0];
                cell.backgroundColor=[UIColor whiteColor];
                
                
            }
    
            return cell;
        
            
        
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:false];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
    
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

@end
