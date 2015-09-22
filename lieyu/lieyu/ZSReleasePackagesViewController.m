//
//  ZSReleasePackagesViewController.m
//  lieyu
//
//  Created by SEM on 15/9/21.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "ZSReleasePackagesViewController.h"
#import "FBTaoCanSectionBottom.h"
#import "FBTaoCanSectionHead.h"
#import "TaoCanMCell.h"
#import "FBTaoCanView.h"
#import "TimeChooseTwoViewController.h"
#import "ChanPinListViewController.h"
@interface ZSReleasePackagesViewController ()<TimeChooseDelegate,UITextFieldDelegate,UITextViewDelegate>
{
    FBTaoCanView *taoCanView;
}
@end

@implementation ZSReleasePackagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    taocanDelList=[[NSMutableArray alloc]init];
//    [self.navigationController setNavigationBarHidden:NO];
    self.title=@"发布套餐";
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"FBTaoCanView" owner:nil options:nil];
    taoCanView= (FBTaoCanView *)[nibView objectAtIndex:0];
    taoCanView.timeChooseBtn.backgroundColor=[UIColor clearColor];
    [taoCanView.timeChooseBtn addTarget:self action:@selector(timeChoose:) forControlEvents:UIControlEventTouchDown] ;
    [taoCanView.taocanTitleTex addTarget:self action:@selector(endEdit:) forControlEvents:UIControlEventEditingDidEndOnExit];
    taoCanView.taocanTitleTex.delegate=self;
    [taoCanView.fromPriceTex addTarget:self action:@selector(endEdit:) forControlEvents:UIControlEventEditingDidEndOnExit];
    taoCanView.fromPriceTex.delegate=self;
    [taoCanView.toPriceTex addTarget:self action:@selector(endEdit:) forControlEvents:UIControlEventEditingDidEndOnExit];
    taoCanView.toPriceTex.delegate=self;
    [taoCanView.fromPopulationTex addTarget:self action:@selector(endEdit:) forControlEvents:UIControlEventEditingDidEndOnExit];
    taoCanView.fromPopulationTex.delegate=self;
    [taoCanView.toPopulationTex addTarget:self action:@selector(endEdit:) forControlEvents:UIControlEventEditingDidEndOnExit];
    taoCanView.toPopulationTex.delegate=self;
    self.tableView.tableHeaderView=taoCanView;
    // Do any additional setup after loading the view from its nib.
}
#pragma mark 时间选择
-(void)timeChoose:(id)sender{
     TimeChooseTwoViewController *timeChooseViewController=[[TimeChooseTwoViewController alloc]initWithNibName:@"TimeChooseTwoViewController" bundle:nil];
    timeChooseViewController.title=@"选择时间";
    timeChooseViewController.delegate=self;
    [self.navigationController pushViewController:timeChooseViewController animated:YES];
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
    [taoCanSectionHead.addTaoCanBtn addTarget:self action:@selector(taoCanChoose:) forControlEvents:UIControlEventTouchDown] ;
    
    //            orderHeadView.detLal.text=orderInfoModel.paytime;
    //    view.backgroundColor=[UIColor yellowColor];
    return taoCanSectionHead;
    
}
#pragma mark选择套餐明细
-(void)taoCanChoose:(id)sender{
    ChanPinListViewController *chanPinListViewController=[[ChanPinListViewController alloc]initWithNibName:@"ChanPinListViewController" bundle:nil];
    [self.navigationController pushViewController:chanPinListViewController animated:YES];
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
#pragma mark - 时间选择代理
-(void)changetime:(NSDictionary *)timeDic{
    fromTime=[timeDic objectForKey:@"fromTime"];
    toTime=[timeDic objectForKey:@"toTime"];
    taoCanView.timeLal.text=[NSString stringWithFormat:@"%@ 至 %@",fromTime,toTime];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)endEdit:(id)sender{
    [sender resignFirstResponder];
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
