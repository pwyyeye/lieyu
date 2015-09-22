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
@interface ZSMyShopsManageViewController ()

@end

@implementation ZSMyShopsManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    dataList=[[NSMutableArray alloc]init];
    serchDataList=[[NSMutableArray alloc]init];
    _tableView.showsHorizontalScrollIndicator=NO;
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.separatorColor=[UIColor clearColor];
//    _tableView.backgroundColor=RGB(237, 237, 237 );
    self.view.backgroundColor=RGB(237, 237, 237 );
    [self.navigationController setNavigationBarHidden:YES];
    dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *dateStr= [dateFormatter stringFromDate:[NSDate new]];
    self.timeLal.text=dateStr;
    self.calendarLogic = [[WQCalendarLogic alloc] init];
    [self getTaoCanList];
    // Do any additional setup after loading the view from its nib.
}

-(void)getTaoCanList{
    [dataList removeAllObjects];
    [serchDataList removeAllObjects];
    TaoCanModel * taoCanModel=[[TaoCanModel alloc]init];
    taoCanModel.name=@"散台特惠轩单支洋酒套餐";
    taoCanModel.del=@"［适合2-4人］";
    taoCanModel.zhekouMoney=@"￥1200";
    taoCanModel.money=@"￥1550";
    taoCanModel.yongjin=@"分销佣金：30%";
    taoCanModel.time=@"6.12 - 617";
    
    TaoCanModel * taoCanModel1=[[TaoCanModel alloc]init];
    taoCanModel1.name=@"散台特惠轩单支洋酒套餐";
    taoCanModel1.del=@"［适合2-4人］";
    taoCanModel1.zhekouMoney=@"￥1200";
    taoCanModel1.money=@"￥1550";
    taoCanModel1.yongjin=@"分销佣金：30%";
    taoCanModel1.time=@"6.12 - 617";
    
    TaoCanModel * taoCanModel2=[[TaoCanModel alloc]init];
    taoCanModel2.name=@"散台特惠轩单支洋酒套餐";
    taoCanModel2.del=@"［适合2-4人］";
    taoCanModel2.zhekouMoney=@"￥1200";
    taoCanModel2.money=@"￥1550";
    taoCanModel2.yongjin=@"分销佣金：30%";
    taoCanModel2.time=@"6.12 - 617";
    [dataList addObject:taoCanModel];
    [dataList addObject:taoCanModel1];
    [dataList addObject:taoCanModel2];
    UIView *view1=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];
    view1.backgroundColor=[UIColor whiteColor];
    _tableView.tableHeaderView=view1;
    
    
    [self.tableView reloadData];
    
}
-(void)getinKeList{
    [dataList removeAllObjects];
    [serchDataList removeAllObjects];
    PinKeModel * pinKeModel=[[PinKeModel alloc]init];
    pinKeModel.name=@"十周年庆卡座5人套餐3000元";
    pinKeModel.jiubaName=@"颜色酒吧";
    pinKeModel.dizhi=@"上海市浦东新区张杨北路112号";
    pinKeModel.time=@"6.12 - 617";
    
    PinKeModel * pinKeModel2=[[PinKeModel alloc]init];
    pinKeModel2.name=@"十周年庆卡座5人套餐3000元";
    pinKeModel2.jiubaName=@"颜色酒吧";
    pinKeModel2.dizhi=@"上海市浦东新区张杨北路112号";
    pinKeModel2.time=@"6.12 - 617";
    
    PinKeModel * pinKeModel3=[[PinKeModel alloc]init];
    pinKeModel3.name=@"十周年庆卡座5人套餐3000元";
    pinKeModel3.jiubaName=@"颜色酒吧";
    pinKeModel3.dizhi=@"上海市浦东新区张杨北路112号";
    pinKeModel3.time=@"6.12 - 617";
    [dataList addObject:pinKeModel];
    [dataList addObject:pinKeModel2];
    [dataList addObject:pinKeModel3];
    UIView *view1=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];
    view1.backgroundColor=[UIColor whiteColor];
    _tableView.tableHeaderView=view1;
    [self.tableView reloadData];
}
-(void)getChiHeList{
    [dataList removeAllObjects];
    [serchDataList removeAllObjects];
    CheHeModel * cheHeModel=[[CheHeModel alloc]init];
    cheHeModel.name=@"散台特惠轩尼诗";
    cheHeModel.money=@"￥1550";
    cheHeModel.yongjin=@"分销佣金：30%";
    cheHeModel.kucun=@"13";
    CheHeModel * cheHeModel1=[[CheHeModel alloc]init];
    cheHeModel1.name=@"散台特惠轩尼诗";
    cheHeModel1.money=@"￥1550";
    cheHeModel1.yongjin=@"分销佣金：30%";
    cheHeModel1.kucun=@"13";
    CheHeModel * cheHeModel2=[[CheHeModel alloc]init];
    cheHeModel2.name=@"散台特惠轩尼诗";
    cheHeModel2.money=@"￥1550";
    cheHeModel2.yongjin=@"分销佣金：30%";
    cheHeModel2.kucun=@"13";
    [dataList addObject:cheHeModel];
    [dataList addObject:cheHeModel1];
    [dataList addObject:cheHeModel2];
    UIView *view1=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];
    view1.backgroundColor=[UIColor whiteColor];
    _tableView.tableHeaderView=view1;
    [self.tableView reloadData];
}
-(void)getKuCunList{
    [dataList removeAllObjects];
    [serchDataList removeAllObjects];
    KuCunModel *kuCunModel=[[KuCunModel alloc]init];
    kuCunModel.name=@"散台特惠轩尼诗";
    kuCunModel.count=@"200件";
    KuCunModel *kuCunModel1=[[KuCunModel alloc]init];
    kuCunModel1.name=@"散台特惠轩尼诗";
    kuCunModel1.count=@"200件";
    KuCunModel *kuCunModel2=[[KuCunModel alloc]init];
    kuCunModel2.name=@"散台特惠轩尼诗";
    kuCunModel2.count=@"200件";
    [dataList addObject:kuCunModel];
    [dataList addObject:kuCunModel1];
    [dataList addObject:kuCunModel2];
    serchDataList = dataList.mutableCopy;
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"SerchHeadView" owner:nil options:nil];
    SerchHeadView *serchHeadView= (SerchHeadView *)[nibView objectAtIndex:0];
    [serchHeadView.serchText addTarget:self action:@selector(endEdit:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [serchHeadView.serchText addTarget:self action:@selector(serchTextValChange:) forControlEvents:UIControlEventEditingChanged];
    _tableView.tableHeaderView=serchHeadView;
    [self.tableView reloadData];
}

#pragma mark 搜索
-(void)serchTextValChange:(UITextField *)sender{
    NSString *ss=sender.text;
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
    label.text=@"共产品：50个";
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
            cell.nameLal.text=taoCanModel.name;
            cell.delLal.text=taoCanModel.del;
            cell.timeLal.text=taoCanModel.time;
            cell.moneyLal.text=taoCanModel.money;
            cell.zhekouLal.text=taoCanModel.zhekouMoney;
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
            cell.nameLal.text=pinKeModel.name;
            cell.didianLal.text=pinKeModel.dizhi;
            cell.shopNameLal.text=pinKeModel.jiubaName;
            cell.timeLal.text=pinKeModel.time;
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
            cell.countLal.text=cheHeModel.kucun;
            cell.moneyLal.text=cheHeModel.money;
            [cell.yjBtn setTitle:cheHeModel.yongjin forState:0];
            return cell;
            break;
        }
            
        default:// 已消费
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
            cell.countLal.text=kuCunModel.count;
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
            
        case 0://待消费
        {
            return 83;
            break;
        }
            
        case 1:// 待留位
        {
            return 90;
            break;
            
        }
            
        case 2:// 待催促
        {
            return 83;
            break;
        }
            
        default:// 已消费
        {
            return 64;
            break;
        }
            
    }
    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}
#pragma mark 添加
- (IBAction)addSomeAct:(UIButton *)sender {
    switch (self.titleSeq.selectedSegmentIndex) {
            
        case 0://套餐
        {
            ZSReleasePackagesViewController *releasePackageViewController=[[ZSReleasePackagesViewController alloc]initWithNibName:@"ZSReleasePackagesViewController" bundle:nil];
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
    [surebutton setBackgroundColor:RGB(35, 166, 116)];
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
    nextBtn.frame = (CGRect){235, 3, 60, 44};
    [nextBtn addTarget:self action:@selector(goToNextMonth:) forControlEvents:UIControlEventTouchUpInside];
    [nextBtn setTitle:@"下一月" forState:UIControlStateNormal];
    [monView addSubview:nextBtn];
    
    CGRect labelRect = (CGRect){110, 3, 100, 44};
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
