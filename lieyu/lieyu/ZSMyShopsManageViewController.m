//
//  ZSMyShopsManageViewController.m
//  lieyu
//
//  Created by 薛斯岐 on 15/9/19.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "ZSMyShopsManageViewController.h"
#import "CaoCanCell.h"
#import "PinKeCell.h"
#import "CheHeCell.h"
#import "KuCunCell.h"
#import "TaoCanModel.h"
#import "PinKeModel.h"
#import "CheHeModel.h"
#import "KuCunModel.h"
#import "SerchHeadView.h"
#import "ZSReleasePackagesViewController.h"
#import "ZSReleaseGoodViewController.h"
#import "ZSAddStocksViewController.h"
#import "ZSManageHttpTool.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
@interface ZSMyShopsManageViewController ()<ZSAddStocksDelegate,ZSAddTaoCanDelegate,ZSAddDanPinDelegate>

@end

@implementation ZSMyShopsManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    userId=app.userModel.userid;
    userModel=app.userModel;
    dataList=[[NSMutableArray alloc]init];
    serchDataList=[[NSMutableArray alloc]init];
    _tableView.showsHorizontalScrollIndicator=NO;
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.separatorColor=[UIColor clearColor];
    _tableView.backgroundColor=RGB(237, 237, 237 );
    [self.navigationController setNavigationBarHidden:YES];
    dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *dateStr= [dateFormatter stringFromDate:[NSDate new]];
    self.timeLal.text=dateStr;
    self.calendarLogic = [[WQCalendarLogic alloc] init];
    [self getTaoCanList];
    // Do any additional setup after loading the view from its nib.
    [self.navigationController setNavigationBarHidden:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    
}
#pragma mark -套餐列表
-(void)getTaoCanList{
    [dataList removeAllObjects];
    [serchDataList removeAllObjects];
    __weak __typeof(self)weakSelf = self;
    NSDictionary *dic=@{@"barid":[NSNumber numberWithInt:userModel.barid]};
    [[ZSManageHttpTool shareInstance] getMyTaoCanListWithParams:dic block:^(NSMutableArray *result) {
        dataList =result;
        UIView *view1=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];
        view1.backgroundColor=[UIColor whiteColor];
        _tableView.tableHeaderView=view1;
        
        totolCount=[NSString stringWithFormat:@"共产品：%d个",(int)dataList.count];
        [weakSelf.tableView reloadData];
    }];
        
    
//    UIView *view1=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];
//    view1.backgroundColor=[UIColor whiteColor];
//    _tableView.tableHeaderView=view1;
//    
//    
//    [self.tableView reloadData];
    
}
#pragma mark -拼客列表
-(void)getinKeList{
    [dataList removeAllObjects];
    [serchDataList removeAllObjects];
    __weak __typeof(self)weakSelf = self;
    NSDictionary *dic=@{@"barid":[NSNumber numberWithInt:userModel.barid]};
    [[ZSManageHttpTool shareInstance] getMyPinkerListWithParams:dic block:^(NSMutableArray *result) {
        dataList =result;
        UIView *view1=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];
        view1.backgroundColor=[UIColor whiteColor];
        _tableView.tableHeaderView=view1;
        
        totolCount=[NSString stringWithFormat:@"共产品：%d个",(int)dataList.count];
        [weakSelf.tableView reloadData];
    }];
}
#pragma mark -吃喝列表
-(void)getChiHeList{
    [dataList removeAllObjects];
    [serchDataList removeAllObjects];
    __weak __typeof(self)weakSelf = self;
    NSDictionary *dic=@{@"barid":[NSNumber numberWithInt:userModel.barid]};
    [[ZSManageHttpTool shareInstance] getMyDanPinListWithParams:dic block:^(NSMutableArray *result) {
        dataList =result;
        UIView *view1=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];
        view1.backgroundColor=[UIColor whiteColor];
        _tableView.tableHeaderView=view1;
        
        totolCount=[NSString stringWithFormat:@"共产品：%d个",(int)dataList.count];
        [weakSelf.tableView reloadData];
    }];

}
#pragma mark -库存列表
-(void)getKuCunList{
    [dataList removeAllObjects];
    [serchDataList removeAllObjects];
    __weak __typeof(self)weakSelf = self;
    NSDictionary *dic=@{@"barid":[NSNumber numberWithInt:userModel.barid]};//,@"userid":[NSNumber numberWithInt:userModel.userid]
    [[ZSManageHttpTool shareInstance] getMyKuCunListWithParams:dic block:^(NSMutableArray *result) {
        dataList =result;
        totolCount=[NSString stringWithFormat:@"共产品：%d个",(int)dataList.count];
        serchDataList = dataList.mutableCopy;
        NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"SerchHeadView" owner:nil options:nil];
        SerchHeadView *serchHeadView= (SerchHeadView *)[nibView objectAtIndex:0];
        [serchHeadView.serchText addTarget:self action:@selector(endEdit:) forControlEvents:UIControlEventEditingDidEndOnExit];
        [serchHeadView.serchText addTarget:self action:@selector(serchTextValChange:) forControlEvents:UIControlEventEditingChanged];
        weakSelf.tableView.tableHeaderView=serchHeadView;
        
        [weakSelf.tableView reloadData];
    }];
    
    
}

#pragma mark 搜索
-(void)serchTextValChange:(UITextField *)sender{
    NSString *ss=sender.text;
    [serchDataList removeAllObjects];
    if([ss isEqualToString:@""]){
        serchDataList =[dataList mutableCopy];
    }else{
        for (KuCunModel *kuCunModel in dataList) {
            
            NSRange range = [kuCunModel.name rangeOfString:ss];//匹配得到的下标
            NSLog(@"rang:%@",NSStringFromRange(range));
            if (range.length >0){
                [serchDataList addObject:kuCunModel ];
            }
        }
    }
    [_tableView reloadData];
    NSLog(@"*****%@",ss);
}
- (IBAction)titelChangeAct:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
            
        case 0://套餐
        {
            [self getTaoCanList];
            break;
        }
            
        case 1://拼客
        {
            [self getinKeList];
            break;
            
        }
            
        case 2:// 吃喝
        {
            [self getChiHeList];
            break;
        }
            
        default:// 库存
        {
            [self getKuCunList];
            break;
        }
            
    }
}

#pragma mark table代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (self.titleSeq.selectedSegmentIndex) {
            
        case 0://套餐
        {
            return dataList.count;
            break;
        }
            
        case 1:// 拼客
        {
            return dataList.count;
            break;
            
        }
            
        case 2:// 吃喝
        {
            return dataList.count;
            break;
        }
            
        default:// 库存
        {
            return serchDataList.count;
            break;
        }
            
    }
    
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
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 34)];
    view.backgroundColor=RGB(247, 247, 247);
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(15, 11, 200, 12)];
    label.text=totolCount;
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
    switch (self.titleSeq.selectedSegmentIndex) {
            
        case 0://套餐列表
        {
            static NSString *taoCanCellIdentifier = @"CaoCanCell";
            
            CaoCanCell *cell = (CaoCanCell *)[_tableView dequeueReusableCellWithIdentifier:taoCanCellIdentifier];
            if (cell == nil) {
                NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:taoCanCellIdentifier owner:self options:nil];
                cell = (CaoCanCell *)[nibArray objectAtIndex:0];
                cell.backgroundColor=[UIColor whiteColor];
                
                
            }
            UILabel *lineLal=[[UILabel alloc]initWithFrame:CGRectMake(15, 81, 290, 0.5)];
            lineLal.backgroundColor=RGB(199, 199, 199);
            [cell addSubview:lineLal];
            TaoCanModel *taoCanModel=dataList[indexPath.row];
            cell.nameLal.text=taoCanModel.title;
            cell.delLal.text=taoCanModel.subtitle;
            cell.timeLal.text=taoCanModel.smdate;
            
            NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
            NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"￥%.2f",taoCanModel.price] attributes:attribtDic];
            cell.moneyLal.attributedText=attribtStr;
            cell.zhekouLal.text=[NSString stringWithFormat:@"￥%.2f",taoCanModel.price];
            NSString *flStr=[NSString stringWithFormat:@"分销佣金：%.f%\%",taoCanModel.rebate*100];
            NSString *str=taoCanModel.linkicon ;
            [cell.taoCanImageView setImageWithURL:[NSURL URLWithString:str]];
            [cell.yjBtn setTitle:flStr forState:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            break;
        }
            
        case 1:// 拼客列表
        {
            static NSString *pinKeCellIdentifier = @"PinKeCell";
            
            PinKeCell *cell = (PinKeCell *)[_tableView dequeueReusableCellWithIdentifier:pinKeCellIdentifier];
            if (cell == nil) {
                NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:pinKeCellIdentifier owner:self options:nil];
                cell = (PinKeCell *)[nibArray objectAtIndex:0];
                cell.backgroundColor=[UIColor whiteColor];
                
                
            }
            UILabel *lineLal=[[UILabel alloc]initWithFrame:CGRectMake(15, 88, 290, 0.5)];
            lineLal.backgroundColor=RGB(199, 199, 199);
            [cell addSubview:lineLal];

            PinKeModel *pinKeModel=dataList[indexPath.row];
            cell.nameLal.text=pinKeModel.title;
            cell.didianLal.text=pinKeModel.subtitle;
            cell.shopNameLal.text=@"";
            cell.timeLal.text=pinKeModel.smdate;
            NSString *str=pinKeModel.linkicon ;
            [cell.pinkeImageView setImageWithURL:[NSURL URLWithString:str]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
            break;
            
        }
            
        case 2:// 吃喝列表
        {
            static NSString *chiHeCellIdentifier = @"CheHeCell";
            
            CheHeCell *cell = (CheHeCell *)[_tableView dequeueReusableCellWithIdentifier:chiHeCellIdentifier];
            if (cell == nil) {
                NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:chiHeCellIdentifier owner:self options:nil];
                cell = (CheHeCell *)[nibArray objectAtIndex:0];
                cell.backgroundColor=[UIColor whiteColor];
                
                
            }
            UILabel *lineLal=[[UILabel alloc]initWithFrame:CGRectMake(15, 81, 290, 0.5)];
            lineLal.backgroundColor=RGB(199, 199, 199);
            [cell addSubview:lineLal];
            CheHeModel *cheHeModel=dataList[indexPath.row];
            cell.nameLal.text=cheHeModel.name;
            cell.countLal.text=[NSString stringWithFormat:@"%d",cheHeModel.ordernum];
            cell.moneyLal.text=[NSString stringWithFormat:@"￥%@",cheHeModel.price];
            NSString *flStr=[NSString stringWithFormat:@"分销佣金：%.f%\%",cheHeModel.rebate*100];
            [cell.yjBtn setTitle:flStr forState:0];
            NSString *str=cheHeModel.img_80 ;
            [cell.cheHeImageView setImageWithURL:[NSURL URLWithString:str]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            break;
        }
            
        default:// 库存
        {
            static NSString *kuCunCellIdentifier = @"KuCunCell";
            
            KuCunCell *cell = (KuCunCell *)[_tableView dequeueReusableCellWithIdentifier:kuCunCellIdentifier];
            if (cell == nil) {
                NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:kuCunCellIdentifier owner:self options:nil];
                cell = (KuCunCell *)[nibArray objectAtIndex:0];
                cell.backgroundColor=[UIColor whiteColor];
                
                
            }
            KuCunModel *kuCunModel=serchDataList[indexPath.row];
            cell.namelal.text=kuCunModel.name;
            cell.countLal.text=[NSString stringWithFormat:@"%d件",kuCunModel.stock];
            NSString *str=kuCunModel.linkurl ;
            [cell.kuCunImageView setImageWithURL:[NSURL URLWithString:str]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            break;
        }
            
    
    }
            
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:false];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (self.titleSeq.selectedSegmentIndex) {
            
        case 0://套餐列表
        {
            return 83;
            break;
        }
            
        case 1:// 拼客
        {
            return 90;
            break;
            
        }
            
        case 2:// 单品
        {
            return 83;
            break;
        }
            
        default:// 库存
        {
            return 64;
            break;
        }
            
    }
    
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"下架";
}
//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return UITableViewCellEditingStyleDelete;
//}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.titleSeq.selectedSegmentIndex==3){
        return false;
    }else{
        return YES;
    }
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        switch (self.titleSeq.selectedSegmentIndex) {
                
            case 0://套餐列表
            {
                __weak __typeof(self)weakSelf = self;
                TaoCanModel *taoCanModel=dataList[indexPath.row];
                NSDictionary *dic=@{@"smid":[NSNumber numberWithInt:taoCanModel.smid],@"offshelfUserid":[NSNumber numberWithInt:userId]};
                [[ZSManageHttpTool shareInstance] delTaoCanWithParams:dic complete:^(BOOL result) {
                    if(result){
                        [MyUtil showMessage:@"下架成功"];
                        [weakSelf getTaoCanList];
                    }
                }];
                break;
            }
                
            case 1:// 拼客
            {
                
                PinKeModel *pinKeModel=dataList[indexPath.row];
                __weak __typeof(self)weakSelf = self;
                NSDictionary *dic=@{@"smid":[NSNumber numberWithInt:pinKeModel.smid],@"offshelfUserid":[NSNumber numberWithInt:userId]};
                [[ZSManageHttpTool shareInstance] delPinKeWithParams:dic complete:^(BOOL result) {
                    if(result){
                        [MyUtil showMessage:@"下架成功"];
                        [weakSelf getinKeList];
                    }
                }];
                break;
                
            }
                
            case 2:// 单品
            {
                CheHeModel *cheHeModel=dataList[indexPath.row];
                __weak __typeof(self)weakSelf = self;
                NSDictionary *dic=@{@"smid":[NSNumber numberWithInt:cheHeModel.smid],@"offshelfUserid":[NSNumber numberWithInt:userId]};
                [[ZSManageHttpTool shareInstance] delProductWithParams:dic complete:^(BOOL result) {
                    if(result){
                        [MyUtil showMessage:@"下架成功"];
                        [weakSelf getChiHeList];
                    }
                }];

                break;
            }
                
            default:// 库存
            {
                KuCunModel *kuCunModel=serchDataList[indexPath.row];
                break;
            }
        }
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}
#pragma mark 下架
-(void)xiaJiaAct:(UIButton *)sender{
    
}
#pragma mark 添加
- (IBAction)addSomeAct:(UIButton *)sender {
    switch (self.titleSeq.selectedSegmentIndex) {
            
        case 0://套餐
        {
            ZSReleasePackagesViewController *releasePackageViewController=[[ZSReleasePackagesViewController alloc]initWithNibName:@"ZSReleasePackagesViewController" bundle:nil];
            releasePackageViewController.delegate=self;
            [self.navigationController pushViewController:releasePackageViewController animated:YES];
            break;
        }
            
        case 1:// 拼客
        {
            
            break;
            
        }
            
        case 2:// 吃喝
        {
            ZSReleaseGoodViewController *releaseGoodViewController=[[ZSReleaseGoodViewController alloc]initWithNibName:@"ZSReleaseGoodViewController" bundle:nil];
            releaseGoodViewController.title=@"发布单品";
            [self.navigationController pushViewController:releaseGoodViewController animated:YES];
            break;
        }
            
        default:// 库存
        {
            ZSAddStocksViewController *addStocksViewController=[[ZSAddStocksViewController alloc]initWithNibName:@"ZSAddStocksViewController" bundle:nil];
            addStocksViewController.title=@"添加库存";
            addStocksViewController.delegate=self;
            [self.navigationController pushViewController:addStocksViewController animated:YES];
            break;
        }
            
    }
}

#pragma mark 选择时间
- (IBAction)timeChooseAct:(UIButton *)sender {
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH,SCREEN_HEIGHT)];
    [_bgView setTag:99999];
    [_bgView setBackgroundColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.4]];
    [_bgView setAlpha:1.0];
    
    [self.view addSubview:_bgView];
    
    self.calendarView = [[WQDraggableCalendarView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT+50, SCREEN_WIDTH, 266+45)];
    self.calendarView.draggble = YES;
    
    
    /*
     //左右滑动
     UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goToPreviousMonth:)];
     
     [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
     
     [_bgView addGestureRecognizer:swipeLeft];
     
     
     
     UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goToNextMonth:)];
     
     [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
     
     [_bgView addGestureRecognizer:swipeRight];
     */
    [_bgView addSubview:self.calendarView];
    
    
    self.calendarView.backgroundColor = [UIColor lightGrayColor];
    [self.calendarLogic reloadCalendarView:self.calendarView];
    surebutton=[UIButton buttonWithType:UIButtonTypeCustom];
    surebutton.frame=CGRectMake(0 ,SCREEN_HEIGHT+50+266+45, SCREEN_WIDTH,45 );
    [surebutton setBackgroundColor:RGB(114, 5, 147)];
    [surebutton setTitle:@"确定" forState:0];
    [surebutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [surebutton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [surebutton addTarget:self action:@selector(SetViewDisappearForSure:) forControlEvents:UIControlEventTouchDown];
    [_bgView insertSubview:surebutton aboveSubview:_bgView];
    
    //上下月
    monView=[[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 50)];
    monView.backgroundColor=[UIColor whiteColor];
    UIButton *preBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    preBtn.frame = (CGRect){25, 3, 60, 44};
    [preBtn addTarget:self action:@selector(goToPreviousMonth:) forControlEvents:UIControlEventTouchUpInside];
    [preBtn setTitle:@"上一月" forState:UIControlStateNormal];
    [monView addSubview:preBtn];
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    nextBtn.frame = (CGRect){SCREEN_WIDTH - 85, 3, 60, 44};
    [nextBtn addTarget:self action:@selector(goToNextMonth:) forControlEvents:UIControlEventTouchUpInside];
    [nextBtn setTitle:@"下一月" forState:UIControlStateNormal];
    [monView addSubview:nextBtn];
    
    CGRect labelRect = (CGRect){SCREEN_WIDTH / 2 - 50, 3, 100, 44};
    self.monthLabel = [[UILabel alloc] initWithFrame:labelRect];
    self.monthLabel.textAlignment = NSTextAlignmentCenter;
    self.monthLabel.text = [NSString stringWithFormat:@"%lu年%lu月", (unsigned long)self.calendarLogic.selectedCalendarDay.year, (unsigned long)self.calendarLogic.selectedCalendarDay.month];
    self.monthLabel.textColor = [UIColor blackColor];
    [monView addSubview:self.monthLabel];
    [_bgView insertSubview:monView aboveSubview:_bgView];
    
    
    [UIView beginAnimations:@"animationID" context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.calendarView cache:NO];
    monView.frame=CGRectMake(0, SCREEN_HEIGHT-266-45-50, SCREEN_WIDTH, 50);
    self.calendarView.frame= CGRectMake(0, SCREEN_HEIGHT-266-45, SCREEN_WIDTH, 266+45);
    surebutton.frame=CGRectMake(0 ,SCREEN_HEIGHT-45, SCREEN_WIDTH,45 );
    [UIView commitAnimations];
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(0 ,0, SCREEN_WIDTH, SCREEN_HEIGHT-266-45-50);
    [button setBackgroundColor:[UIColor clearColor]];
    [button addTarget:self action:@selector(SetViewDisappear:) forControlEvents:UIControlEventTouchDown];
    [_bgView insertSubview:button aboveSubview:_bgView];
    button.backgroundColor=[UIColor clearColor];
    
    
    //    button.backgroundColor=[UIColor clearColor];
}
//
-(void)SetViewDisappear:(id)sender
{
    if (_bgView)
    {
        _bgView.backgroundColor=[UIColor clearColor];
        [UIView animateWithDuration:.5
                         animations:^{
                             
                             self.calendarView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 300);
                             _bgView.frame=CGRectMake(0, SCREEN_HEIGHT, self.view.frame.size.width, self.view.frame.size.height);
                             _bgView.alpha=0.0;
                         }];
        [_bgView performSelector:@selector(removeFromSuperview)
                      withObject:nil
                      afterDelay:2];
        
        _bgView=nil;
    }
    
}
-(void)SetViewDisappearForSure:(id)sender{
    
    self.timeLal.text=[dateFormatter stringFromDate:[self.calendarLogic.selectedCalendarDay date]];
    [self SetViewDisappear:sender];
    //    if (_bgView)
    //    {
    //        _bgView.backgroundColor=[UIColor clearColor];
    //        [UIView animateWithDuration:.5
    //                         animations:^{
    //
    //                             self.calendarView = [[WQDraggableCalendarView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 300)];
    //                             _bgView.frame=CGRectMake(0, SCREEN_HEIGHT, self.view.frame.size.width, self.view.frame.size.height);
    //                             _bgView.alpha=0.0;
    //                         }];
    //        [_bgView performSelector:@selector(removeFromSuperview)
    //                      withObject:nil
    //                      afterDelay:2];
    //        
    //        
    //    }
}

#pragma mark -

- (void)goToNextMonth:(id)sender
{
    [self.calendarLogic goToNextMonthInCalendarView:self.calendarView];
    self.monthLabel.text = [NSString stringWithFormat:@"%lu年%lu月", (unsigned long)self.calendarLogic.selectedCalendarDay.year, (unsigned long)self.calendarLogic.selectedCalendarDay.month];
    
    
}

- (void)goToPreviousMonth:(id)sender
{
    [self.calendarLogic goToPreviousMonthInCalendarView:self.calendarView];
    self.monthLabel.text = [NSString stringWithFormat:@"%lu年%lu月", (unsigned long)self.calendarLogic.selectedCalendarDay.year, (unsigned long)self.calendarLogic.selectedCalendarDay.month];
    
    
}


-(void)endEdit:(id)sender{
    [sender resignFirstResponder];
}

#pragma mark -添加库存代理
- (void)addStocks{
    [self showMessage:@"保存成功"];
    [self getKuCunList];
}
#pragma mark -添加套餐代理
- (void)addTaoCan{
    [self showMessage:@"保存成功"];
    [self getTaoCanList];
}
#pragma mark -添加套餐代理
- (void)addDanPin{
    [self showMessage:@"保存成功"];
    [self getChiHeList];
}
- (IBAction)backAct:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
