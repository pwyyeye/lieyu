//
//  ZSReleaseGoodViewController.m
//  lieyu
//
//  Created by 薛斯岐 on 15/9/22.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "ZSReleaseGoodViewController.h"
#import "FBDanPinView.h"
#import "ChanPinListViewController.h"
#import "FBTaoCanSectionHead.h"
#import "FBTaoCanSectionBottom.h"
#import "TaoCanMCell.h"
#import "BiaoQianChooseViewController.h"
@interface ZSReleaseGoodViewController ()<UITextFieldDelegate,UITextViewDelegate,UITextViewDelegate>
{
    FBDanPinView *danPinView;
}
@end

@implementation ZSReleaseGoodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    chanPinDelList=[[NSMutableArray alloc]init];
    biaoQianList=[[NSMutableArray alloc]init];
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"FBDanPinView" owner:nil options:nil];
    danPinView= (FBDanPinView *)[nibView objectAtIndex:0];

    [danPinView.jiageTex addTarget:self action:@selector(endEdit:) forControlEvents:UIControlEventEditingDidEndOnExit];
    danPinView.jiageTex.delegate=self;
    [danPinView.danpinTitleTex addTarget:self action:@selector(endEdit:) forControlEvents:UIControlEventEditingDidEndOnExit];
    danPinView.danpinTitleTex.delegate=self;
    
    danPinView.shuoMingTextView.delegate=self;
    self.tableView.tableHeaderView=danPinView;
    // Do any additional setup after loading the view from its nib.
}
#pragma mark选择套餐明细
-(void)taoCanChoose:(id)sender{
    ChanPinListViewController *chanPinListViewController=[[ChanPinListViewController alloc]initWithNibName:@"ChanPinListViewController" bundle:nil];
    [self.navigationController pushViewController:chanPinListViewController animated:YES];
}
#pragma mark选择产品
-(void)chanPinChoose:(id)sender{
    BiaoQianChooseViewController *biaoQianChooseViewController=[[BiaoQianChooseViewController alloc]initWithNibName:@"BiaoQianChooseViewController" bundle:nil];
    biaoQianChooseViewController.title=@"产品标签";
    [self.navigationController pushViewController:biaoQianChooseViewController animated:YES];
}

#pragma mark table代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==0){
        return biaoQianList.count;
    }
    return chanPinDelList.count;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    return @"今日发布套餐：15套";
//}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section==0){
        NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"FBTaoCanSectionHead" owner:nil options:nil];
        FBTaoCanSectionHead *taoCanSectionHead= (FBTaoCanSectionHead *)[nibView objectAtIndex:0];
        taoCanSectionHead.titleLal.text=@"产品标签";
        [taoCanSectionHead.addTaoCanBtn addTarget:self action:@selector(chanPinChoose:) forControlEvents:UIControlEventTouchDown] ;
        
        //            orderHeadView.detLal.text=orderInfoModel.paytime;
        //    view.backgroundColor=[UIColor yellowColor];
        return taoCanSectionHead;
    }else{
        NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"FBTaoCanSectionHead" owner:nil options:nil];
        FBTaoCanSectionHead *taoCanSectionHead= (FBTaoCanSectionHead *)[nibView objectAtIndex:0];
        taoCanSectionHead.titleLal.text=@"添加吃喝";
        [taoCanSectionHead.addTaoCanBtn addTarget:self action:@selector(taoCanChoose:) forControlEvents:UIControlEventTouchDown] ;
        
        //            orderHeadView.detLal.text=orderInfoModel.paytime;
        //    view.backgroundColor=[UIColor yellowColor];
        return taoCanSectionHead;
    }
    
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if(section==1){
        NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"FBTaoCanSectionBottom" owner:nil options:nil];
        FBTaoCanSectionBottom *taoCanSectionBottom= (FBTaoCanSectionBottom *)[nibView objectAtIndex:0];
        
        
        //            orderHeadView.detLal.text=orderInfoModel.paytime;
        //    view.backgroundColor=[UIColor yellowColor];
        return taoCanSectionBottom;
    }
    UIView *viewtemp=[[UIView alloc]initWithFrame:CGRectZero];
    return viewtemp;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 34;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section==1){
        return 65;
    }
    return 0;
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
-(void)endEdit:(id)sender{
    [sender resignFirstResponder];
}
- (IBAction)sureAct:(UIButton *)sender {
}
@end
