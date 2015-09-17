//
//  ZSOrderViewController.m
//  lieyu
//
//  Created by 薛斯岐 on 15/9/15.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "ZSOrderViewController.h"
#import "OrderBottomView.h"
#import "OrderHeadView.h"
#import "OrderHandleButton.h"
#import "DetailCell.h"
#import "ShopDetailmodel.h"
#import "OrderInfoModel.h"
#import "SerchHeadView.h"
#import "OrderBottomForLWView.h"
@interface ZSOrderViewController ()

@end

@implementation ZSOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.showsHorizontalScrollIndicator=NO;
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.separatorColor=[UIColor clearColor];
    self.view.backgroundColor=RGB(237, 237, 237 );
    daiXiaoFei=[[NSMutableArray alloc]init];
    serchDaiXiaoFei=[[NSMutableArray alloc]init];
    self.menuView.backgroundColor=[UIColor clearColor];
    dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *dateStr= [dateFormatter stringFromDate:[NSDate new]];
    self.timeLal.text=dateStr;
    self.calendarLogic = [[WQCalendarLogic alloc] init];
    [self getMenuHrizontal];
    [self getDaiXiaoFei];
    // Do any additional setup after loading the view from its nib.
}
#pragma mark 获取待消费数据
-(void)getDaiXiaoFei{

    [daiXiaoFei removeAllObjects];
    [serchDaiXiaoFei removeAllObjects];
    OrderInfoModel *order1=[[OrderInfoModel alloc]init];
    order1.name=@"小腻腻";
    order1.orderType=@"1";
    order1.orderStu=@"1";
    order1.money=@"1200";
    ShopDetailmodel *shopD11=[[ShopDetailmodel alloc]init];
    shopD11.name=@"散台特惠轩尼诗";
    shopD11.youfeiPrice=@"¥1200";
    shopD11.money=@"¥1550";
    shopD11.count=@"x1";
    NSArray *arr1=@[shopD11];
    order1.detailModel=arr1;
    [daiXiaoFei addObject:order1];
    OrderInfoModel *order2=[[OrderInfoModel alloc]init];
    order2.name=@"小腻腻";
    order2.orderType=@"1";
    order2.orderStu=@"1";
    order2.money=@"500";
    ShopDetailmodel *shopD21=[[ShopDetailmodel alloc]init];
    shopD21.name=@"散台特惠轩尼诗";
    shopD21.youfeiPrice=@"¥250";
    shopD21.money=@"¥1550";
    shopD21.count=@"x1";
    ShopDetailmodel *shopD22=[[ShopDetailmodel alloc]init];
    shopD22.name=@"散台特惠轩尼诗";
    shopD22.youfeiPrice=@"¥250";
    shopD22.money=@"¥1550";
    shopD22.count=@"x1";
    NSArray *arr2=@[shopD11,shopD22];
    order2.detailModel=arr2;
    [daiXiaoFei addObject:order2];
    serchDaiXiaoFei=[daiXiaoFei mutableCopy];
    
    
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"SerchHeadView" owner:nil options:nil];
    SerchHeadView *serchHeadView= (SerchHeadView *)[nibView objectAtIndex:0];
    [serchHeadView.serchText addTarget:self action:@selector(endEdit:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [serchHeadView.serchText addTarget:self action:@selector(serchTextValChange:) forControlEvents:UIControlEventEditingChanged];
    _tableView.tableHeaderView=serchHeadView;
    [self.tableView reloadData];
}
-(void)getDaiLiuWei{
    [daiXiaoFei removeAllObjects];
    [serchDaiXiaoFei removeAllObjects];
    OrderInfoModel *order1=[[OrderInfoModel alloc]init];
    order1.name=@"小腻腻";
    order1.orderType=@"1";
    order1.orderStu=@"1";
    order1.money=@"1200";
    order1.paytime=@"10:00消费";
    ShopDetailmodel *shopD11=[[ShopDetailmodel alloc]init];
    shopD11.name=@"散台特惠轩尼诗";
    shopD11.youfeiPrice=@"¥1200";
    shopD11.money=@"¥1550";
    shopD11.count=@"7人已购买［适合2-4人］";
    NSArray *arr1=@[shopD11];
    order1.detailModel=arr1;
    [daiXiaoFei addObject:order1];
    OrderInfoModel *order2=[[OrderInfoModel alloc]init];
    order2.name=@"小腻腻";
    order2.orderType=@"1";
    order2.orderStu=@"1";
    order2.money=@"500";
    order2.paytime=@"11:00消费";
    ShopDetailmodel *shopD21=[[ShopDetailmodel alloc]init];
    shopD21.name=@"散台特惠轩尼诗";
    shopD21.youfeiPrice=@"¥250";
    shopD21.money=@"¥1550";
    shopD21.count=@"7人已购买［适合2-4人］";
    ShopDetailmodel *shopD22=[[ShopDetailmodel alloc]init];
    shopD22.name=@"散台特惠轩尼诗";
    shopD22.youfeiPrice=@"¥250";
    shopD22.money=@"¥1550";
    shopD22.count=@"拼客人数7（7人参与）";
    NSArray *arr2=@[shopD11,shopD22];
    order2.detailModel=arr2;
    [daiXiaoFei addObject:order2];
    UIView *view1=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];
    view1.backgroundColor=[UIColor whiteColor];
    _tableView.tableHeaderView=view1;
    [self.tableView reloadData];

}
-(void)serchTextValChange:(UITextField *)sender{
    NSString *ss=sender.text;
    NSLog(@"*****%@",ss);
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (mMenuHriZontal.selectIndex) {
            
        case 0://待消费
        {
            OrderInfoModel *orderInfoModel=serchDaiXiaoFei[section];
            return orderInfoModel.detailModel.count;
            break;
        }
            
        case 1:// 待留位
        {
            OrderInfoModel *orderInfoModel=daiXiaoFei[section];
            return orderInfoModel.detailModel.count;
            break;
           
        }
            
        case 2:// 待催促
        {
            
            break;
        }
            
        case 3:// 已消费
        {
            
            break;
        }
        default://退单
        {
            
            break;
        }
            
    }
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    switch (mMenuHriZontal.selectIndex) {
            
        case 0://待消费
        {
            return serchDaiXiaoFei.count;
            break;
        }
            
        case 1:// 待留位
        {
            return daiXiaoFei.count;
            break;
        }
            
        case 2:// 待催促
        {
            
            break;
        }
            
        case 3:// 已消费
        {
            
            break;
        }
        default://退单
        {
            
            break;
        }
            
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 96;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    switch (mMenuHriZontal.selectIndex) {
            
        case 0://待消费
        {
            OrderInfoModel *orderInfoModel=serchDaiXiaoFei[section];
            NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"OrderBottomView" owner:nil options:nil];
            OrderBottomView *orderBottomView= (OrderBottomView *)[nibView objectAtIndex:0];
            orderBottomView.moneyLal.text=orderInfoModel.money;
            [orderBottomView.duimaBtn addTarget:self action:@selector(duimaAct:) forControlEvents:UIControlEventTouchUpInside];
            [orderBottomView.siliaoBtn addTarget:self action:@selector(siliaoAct:) forControlEvents:UIControlEventTouchUpInside];
            [orderBottomView.dianhuaBtn addTarget:self action:@selector(dianhuaAct:) forControlEvents:UIControlEventTouchUpInside];
            //    view.backgroundColor=[UIColor yellowColor];
            return orderBottomView;
            break;
        }
            
        case 1:// 待留位
        {
            OrderInfoModel *orderInfoModel=daiXiaoFei[section];
            
            NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"OrderBottomForLWView" owner:nil options:nil];
            OrderBottomForLWView *orderBottomView= (OrderBottomForLWView *)[nibView objectAtIndex:0];
            orderBottomView.moneyLal.text=orderInfoModel.money;
            [orderBottomView.kazuoBtn addTarget:self action:@selector(kazuoAct:) forControlEvents:UIControlEventTouchUpInside];
            [orderBottomView.siliaoBtn addTarget:self action:@selector(siliaoAct:) forControlEvents:UIControlEventTouchUpInside];
            [orderBottomView.dianhuaBtn addTarget:self action:@selector(dianhuaAct:) forControlEvents:UIControlEventTouchUpInside];
            //    view.backgroundColor=[UIColor yellowColor];
            return orderBottomView;
            break;
        }
            
        case 2:// 待催促
        {
            return nil;
            break;
        }
            
        case 3:// 已消费
        {
            return nil;
            break;
        }
        default://退单
        {
            return nil;
            break;
        }
            
    }
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    switch (mMenuHriZontal.selectIndex) {
            
        case 0://待消费
        {
            OrderInfoModel *orderInfoModel=serchDaiXiaoFei[section];
            
            NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"OrderHeadView" owner:nil options:nil];
            OrderHeadView *orderHeadView= (OrderHeadView *)[nibView objectAtIndex:0];
            orderHeadView.nameLal.text=orderInfoModel.name;
            
//            orderHeadView.detLal.text=orderInfoModel.paytime;
            //    view.backgroundColor=[UIColor yellowColor];
            return orderHeadView;
            break;
        }
            
        case 1:// 待留位
        {
            OrderInfoModel *orderInfoModel=daiXiaoFei[section];
            
            NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"OrderHeadView" owner:nil options:nil];
            OrderHeadView *orderHeadView= (OrderHeadView *)[nibView objectAtIndex:0];
            orderHeadView.nameLal.text=orderInfoModel.name;
            
            orderHeadView.detLal.text=orderInfoModel.paytime;
            //    view.backgroundColor=[UIColor yellowColor];
            return orderHeadView;
            break;
        }
            
        case 2:// 待催促
        {
            return nil;
            break;
        }
            
        case 3:// 已消费
        {
            return nil;
            break;
        }
        default://退单
        {
            return nil;
            break;
        }
            
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"DetailCell";
    
    DetailCell *cell = (DetailCell *)[_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = (DetailCell *)[nibArray objectAtIndex:0];
        cell.backgroundColor=[UIColor whiteColor];
        
        
    }
    OrderInfoModel *orderInfoModel;
    if(mMenuHriZontal.selectIndex==0){
        orderInfoModel=serchDaiXiaoFei[indexPath.section];

    }else{
        orderInfoModel=daiXiaoFei[indexPath.section];
    }
    NSArray *arr=orderInfoModel.detailModel;
    ShopDetailmodel *shopDetailmodel=arr[indexPath.row];
    cell.nameLal.text=shopDetailmodel.name;
    cell.countLal.text=shopDetailmodel.count;
    if(mMenuHriZontal.selectIndex==0){
        cell.countLal.text=shopDetailmodel.count;
    }else if(mMenuHriZontal.selectIndex==1){
        cell.countLal.text=shopDetailmodel.count;
    }
    
    cell.zhekouLal.text=shopDetailmodel.youfeiPrice;
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:shopDetailmodel.money attributes:attribtDic];
    cell.moneylal.attributedText=attribtStr;
//    @property (weak, nonatomic) IBOutlet UIImageView *detImageView;
    
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 89;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

#pragma mark 获取顶部菜单
-(void)getMenuHrizontal{
    NSArray *menuArrNew=@[@"待消费",@"待留位",@"待催促",@"已消费",@"退单"];
    NSMutableArray *barArr=[[NSMutableArray alloc]initWithCapacity:5];
    for (int i=0; i<=menuArrNew.count-1; i++) {
        
        NSString *ss=menuArrNew[i];
        NSMutableDictionary *itemTemp =[[NSMutableDictionary alloc]init] ;
        // 使用颜色创建UIImage//未选中颜色
        CGSize imageSize = CGSizeMake((SCREEN_WIDTH/5), 44);
        UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
        [RGB(229, 255, 245) set];
        UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
        UIImage *normalImg = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        [itemTemp setObject:normalImg forKey:NOMALKEY];
        
        // 使用颜色创建UIImage //选中颜色
        UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
        [[UIColor whiteColor] set];
        UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
        UIImage *selectedImg = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        [itemTemp setObject: selectedImg forKey:HEIGHTKEY];
        [itemTemp setObject: ss forKey:TITLEKEY];
        [itemTemp setObject:[NSNumber numberWithFloat:self.view.width/5]  forKey:TITLEWIDTH];
        [itemTemp setObject:@"88"  forKey:COUNTORDER];
        [barArr addObject:itemTemp];
    }

    if (mMenuHriZontal == nil) {
        mMenuHriZontal = [[MenuHrizontal alloc] initWithFrame:self.menuView.frame ButtonItems:barArr];
        mMenuHriZontal.delegate = self;
    }
    [self.view addSubview:mMenuHriZontal];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
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
#pragma mark MenuHrizontalDelegate
-(void)didMenuHrizontalClickedButtonAtIndex:(NSInteger)aIndex{
    switch (aIndex) {
            
        case 0://待消费
        {
            [self getDaiXiaoFei];
            break;
        }
            
        case 1:// 待留位
        {
            [self getDaiLiuWei];
            break;
        }
            
        case 2:// 待催促
        {
            
            break;
        }
            
        case 3:// 已消费
        {
            
            break;
        }
        default://退单
        {
            
            break;
        }
            
    }
    
}
#pragma mark 对码
-(void)duimaAct:(OrderHandleButton *)sender{
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH,SCREEN_HEIGHT)];
    [_bgView setTag:99999];
    [_bgView setBackgroundColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.4]];
    [_bgView setAlpha:1.0];
    [self.view addSubview:_bgView];
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"XiaoFeiMaUiew" owner:nil options:nil];
    xiaoFeiMaUiew= (XiaoFeiMaUiew *)[nibView objectAtIndex:0];
    xiaoFeiMaUiew.top=-xiaoFeiMaUiew.height;
    [xiaoFeiMaUiew.xiaofeiMaTextField addTarget:self action:@selector(endEdit:) forControlEvents:UIControlEventEditingDidEndOnExit];
    xiaoFeiMaUiew.xiaofeiMaTextField.returnKeyType=UIReturnKeyDone;
    xiaoFeiMaUiew.xiaofeiMaTextField.delegate=self;
    [_bgView addSubview:xiaoFeiMaUiew];
    [UIView beginAnimations:@"animationID" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:xiaoFeiMaUiew cache:NO];
    xiaoFeiMaUiew.top=20;
    [UIView commitAnimations];
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(0 ,xiaoFeiMaUiew.top+xiaoFeiMaUiew.height, SCREEN_WIDTH, SCREEN_HEIGHT-xiaoFeiMaUiew.top);
    [button setBackgroundColor:[UIColor clearColor]];
    [button addTarget:self action:@selector(SetViewDisappearForDuiMa:) forControlEvents:UIControlEventTouchDown];
    [_bgView insertSubview:button aboveSubview:_bgView];
    button.backgroundColor=[UIColor clearColor];

}
#pragma mark return事件
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self SetViewDisappearForDuiMa:nil];
    return YES;
}

#pragma mark 私聊
-(void)siliaoAct:(OrderHandleButton *)sender{
    
}
#pragma mark 电话
-(void)dianhuaAct:(OrderHandleButton *)sender{
    
}
#pragma mark 卡座
-(void)kazuoAct:(OrderHandleButton *)sender{
    
}

- (IBAction)backAct:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

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
    [UIView setAnimationDuration:0.5];
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
    [self SetViewDisappearForSure:sender];
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
-(void)SetViewDisappearForDuiMa:(id)sender{
    if (_bgView)
    {
        _bgView.backgroundColor=[UIColor clearColor];
        [UIView animateWithDuration:.5
                         animations:^{
                             
                             xiaoFeiMaUiew.top=-xiaoFeiMaUiew.height;
                             _bgView.frame=CGRectMake(0, -SCREEN_HEIGHT, self.view.frame.size.width, self.view.frame.size.height);
                             _bgView.alpha=0.0;
                         }];
        [_bgView performSelector:@selector(removeFromSuperview)
                      withObject:nil
                      afterDelay:2];
        
        _bgView=nil;
    }
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

@end
