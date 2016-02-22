//
//  ZujuViewController.m
//  lieyu
//
//  Created by 王婷婷 on 16/1/28.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "ZujuViewController.h"
#import "LYHomePageHttpTool.h"
#import "LYDinWeiTableViewCell.h"
#import "ZSDetailModel.h"
#import "ChoosePayController.h"
#import "LYMyOrderManageViewController.h"
#import "PinkerShareController.h"

#import "TimeView.h"
#import "WaysView.h"
#import "NumberView.h"
#import "ManagersView.h"

#import "LPAlertView.h"
#import "ChooseTime.h"
#import "ChoosePeople.h"
#import "ContentView.h"
#import "TimeView.h"

@interface ZujuViewController ()<UITableViewDataSource,UITableViewDelegate,LPAlertViewDelegate>
{
    int index;//选择的第几个专属经理
    NSString *time;//到店时间
    NSIndexPath *oldIndex;//选择的cell的indexpath
    LYDinWeiTableViewCell *oldCell;//选择的cell的indexpath
    int oldNumber;//选择的商品数量
    int oldDate;//选择的是第几天
    NSString *oldWay;//选择的方式
    int oldPeople;//选择的人数
    float oldmoney;//需要支付的钱款
    
    NSMutableArray *dataList;
    NSMutableArray *zsList;
    
    //view
    TimeView *timeView;
    WaysView *waysView;
    NumberView *numberView;
    ManagersView *managerView;
    
    //alertView
    ChooseTime *chooseTimeAlert;
    ChoosePeople *chooseNumberAlert;
    ContentView *chooseWayAlert;
}

@property (nonatomic, strong) NSArray *labelArray;
@property (nonatomic, assign) int defaultIndex;
@end

@implementation ZujuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorColor = [UIColor clearColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeAll;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.contentInset = UIEdgeInsetsMake(284, 0, 0, 0);
    [self.tableView registerNib:[UINib nibWithNibName:@"LYDinWeiTableViewCell" bundle:nil] forCellReuseIdentifier:@"LYDinWeiTableViewCell"];
    weekDateArr = [[NSMutableArray alloc]initWithCapacity:7];
    self.defaultIndex = -1;
    oldPeople = 1;
    self.labelArray = @[@"我请客",
                        @"AA付款",
                        @"免费发起"];
    
    [self getweekDate];
    [self getMenuHrizontal];
    [self getdata];
    [self initThisBottomView];
    [self managerList];
    [self initManagerView];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController setNavigationBarHidden:NO];
}

#pragma mark 获取七天日期
-(void)getweekDate{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *nowDate=[NSDate new];
    NSDateComponents *comps ;
    for (int i=0; i<7; i++) {
        comps = [calendar components:unitFlags fromDate:nowDate];
        //        int year = (int)[comps year];
        int week = (int)[comps weekday];
        int month = (int)[comps month];
        
        int day = (int)[comps day];
        NSString *dateStr=[dateFormatter stringFromDate:nowDate];
        NSString *weekStr;
        if(week==1)
        {
            weekStr=@"周日";
        }else if(week==2){
            weekStr=@"周一";
            
        }else if(week==3){
            weekStr=@"周二";
            
        }else if(week==4){
            weekStr=@"周三";
            
        }else if(week==5){
            weekStr=@"周四";
            
        }else if(week==6){
            weekStr=@"周五";
            
        }else if(week==7){
            weekStr=@"周六";
            
        }
        if(i==0){
            datePar=dateStr;
            weekStr=@"今天";
        }
        NSDictionary *dic=@{@"date":dateStr,@"week":weekStr,@"month":[NSString stringWithFormat:@"%d",month],@"day":[NSString stringWithFormat:@"%d",day]};
        [weekDateArr addObject:dic];
        nowDate = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([nowDate timeIntervalSinceReferenceDate] + 24*3600)];
    }
}

#pragma mark 获取顶部菜单
-(void)getMenuHrizontal{
    NSMutableArray *barArr=[[NSMutableArray alloc]initWithCapacity:7];
    for (int i=0; i<=weekDateArr.count-1; i++) {
        NSDictionary *dic=weekDateArr[i];
        NSMutableDictionary *itemTemp =[[NSMutableDictionary alloc]init] ;
        [itemTemp setObject: [dic objectForKey:@"week"] forKey:WEEKKEY];
        [itemTemp setObject:[dic objectForKey:@"day"]  forKey:TITLEKEY];
        [itemTemp setObject:[dic objectForKey:@"month"] forKey:MONTHKEY];
        [itemTemp setObject:[NSNumber numberWithFloat:67.5]  forKey:TITLEWIDTH];
        [itemTemp setObject:@""  forKey:COUNTORDER];
        [barArr addObject:itemTemp];
    }
    if (mMenuHriZontal == nil) {
        mMenuHriZontal = [[MenuHrizontal alloc] initWithFrameForTime:CGRectMake(0,64, SCREEN_WIDTH, 34) ButtonItems:barArr];
        mMenuHriZontal.delegate = self;
        
        mMenuHriZontal.layer.shadowRadius = 2;
        mMenuHriZontal.layer.shadowColor = [[UIColor lightGrayColor]CGColor];
        mMenuHriZontal.layer.shadowOffset = CGSizeMake(0, 1);
        mMenuHriZontal.layer.shadowOpacity = 0.5;
    }
    [self.view addSubview:mMenuHriZontal];
}

#pragma mark MenuHrizontalDelegate
-(void)didMenuHrizontalClickedButtonAtIndex:(NSInteger)aIndex{
    oldDate = (int)aIndex;
    NSDictionary *dic=weekDateArr[aIndex];
    datePar=[dic objectForKey:@"month"];
    [self initThisCell];
    [self initBottomLabelAndButton];
    [self initManagerView];
    [self getdata];
    NSDictionary *dict = @{@"actionName":@"筛选",@"pageName":@"组局",@"titleName":@"选择组局日期",@"value":[dic objectForKey:@"week"]};
    [MTA trackCustomKeyValueEvent:@"LYClickEvent" props:dict];
}

- (void)initThisCell{
    oldCell.button_less.enabled = NO;
    oldCell.label_number.text = @"1";
    oldCell = nil;
    oldIndex = nil;
    oldNumber = 1;
}

#pragma mark - 初始化界面
- (void)initThisBottomView{
    _bottomView.backgroundColor = RGBA(252, 252, 252, 0.75);
    _bottomView.layer.shadowRadius = 2;
    _bottomView.layer.shadowColor = [[UIColor lightGrayColor]CGColor];
    _bottomView.layer.shadowOffset = CGSizeMake(0, -1);
    _bottomView.layer.shadowOpacity = 0.5;
    [_payBtn addTarget:self action:@selector(PayMoneyNow) forControlEvents:UIControlEventTouchUpInside];
    [self initBottomLabelAndButton];
}

- (void)initBottomLabelAndButton{
    _payBtn.backgroundColor = RGBA(204, 204, 204, 1);
    _payBtn.enabled = NO;
    _numberLbl.text = @"共0点单";
    _moneyLbl.text = @"总需支付:¥0";
}

#pragma mark - 立即支付
- (void)PayMoneyNow{
    if(time == nil){
        [MyUtil showCleanMessage:@"请选择到店时间！"];
        return;
    }else if (_defaultIndex == -1){
        [MyUtil showCleanMessage:@"请选择拼客方式！"];
        return;
    }else if(oldPeople == 1){
        [MyUtil showCleanMessage:@"请选择拼客人数！"];
        return;
    }else{
        NSString *dataAndTime = [[[weekDateArr objectAtIndex:oldDate][@"date"] stringByAppendingString:time] stringByAppendingString:@":00"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        PinKeModel *pkModel = [dataList objectAtIndex:oldIndex.section];
        if (zsList.count==0) {
            [MyUtil showCleanMessage:@"该酒吧暂无专属经理，无法下单！"];
            return;
        }
        ZSDetailModel *zsModel = [zsList objectAtIndex:index];
        NSDictionary *dic=@{
                            @"pinkerid":[NSNumber numberWithInt:pkModel.id],
                            @"reachtime":dataAndTime,
                            @"checkuserid":[NSNumber numberWithInt:zsModel.userid],
                            @"allnum":[NSNumber numberWithInt:oldPeople],
                            @"payamount":[NSNumber numberWithInt:oldmoney],
                            @"pinkerType":[NSNumber numberWithInt:_defaultIndex],
                            @"pinkerNum":[NSNumber numberWithInt:oldNumber],
                            @"memo":@""};
        [[LYHomePageHttpTool shareInstance]setTogetherOrderInWithParams:dic complete:^(NSString *result) {
            if(result){
                //支付宝页面"data": "P130637201510181610220",
                //result的值就是P130637201510181610220
                NSLog(@"result-------%@",result);
                if (oldmoney > 0) {
                    ChoosePayController *detailViewController =[[ChoosePayController alloc] init];
                    detailViewController.orderNo=result;
                    detailViewController.payAmount=oldmoney;
                    detailViewController.productName=pkModel.title;
                    detailViewController.isPinker=YES;
                    detailViewController.isFaqi=YES;
                    detailViewController.productDescription=@"暂无";
                    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"return"] style:UIBarButtonItemStylePlain target:self action:nil];
                    self.navigationItem.backBarButtonItem = left;
                    [self.navigationController pushViewController:detailViewController animated:YES];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"loadUserInfo" object:nil];
                    
                    [MTA trackCustomKeyValueEvent:LYCLICK_MTA props:[self createMTADctionaryWithActionName:@"跳转" pageName:@"组局" titleName:@"马上支付"]];
                    
                }else{
                    PinkerShareController *zujuVC = [[PinkerShareController alloc]initWithNibName:@"PinkerShareController" bundle:nil];
                    zujuVC.sn=result;
                    [self.navigationController pushViewController:zujuVC animated:YES];
                    [MTA trackCustomKeyValueEvent:LYCLICK_MTA props:[self createMTADctionaryWithActionName:@"跳转" pageName:@"组局" titleName:@"分享组局"]];
//                    LYMyOrderManageViewController *detailViewController  =[[LYMyOrderManageViewController alloc] initWithNibName:@"LYMyOrderManageViewController" bundle:nil];
//                    AppDelegate *delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
//                    UIBarButtonItem *item=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return"] style:UIBarButtonItemStylePlain target:nil action:nil];
//                    delegate.navigationController.navigationItem.backBarButtonItem=item;
//                    [delegate.navigationController pushViewController:detailViewController animated:YES];
                }
            }
        }];
    }
}

- (void)initManagerView{
    if(managerView){
        [managerView removeFromSuperview];
    }
    managerView = [[ManagersView alloc]initWithFrame:CGRectMake(0, 132, SCREEN_WIDTH, 54)];
    managerView.layer.shadowRadius = 2;
    managerView.layer.shadowColor = [[UIColor lightGrayColor]CGColor];
    managerView.layer.shadowOffset = CGSizeMake(0, 1);
    managerView.layer.shadowOpacity = 0.5;
    managerView.delegate = self;
    managerView.backgroundColor = [UIColor whiteColor];
    [_termView addSubview:managerView];
    zsList = [NSMutableArray array];
    NSDictionary *dic=@{@"barid":[NSNumber numberWithInt:_barid],@"":@""};
    [[LYHomePageHttpTool shareInstance]getBarVipWithParams:dic block:^(NSMutableArray *result) {
        [zsList addObjectsFromArray:result];
        [managerView configure:zsList];
    }];
}

#pragma mark - 营业时间与专属经理选框
- (void)managerList{
    timeView = [[TimeView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    UITapGestureRecognizer *chooseTime = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseTime:)];
    [timeView addGestureRecognizer:chooseTime];
    [self initTimeView];
    [_termView addSubview:timeView];
    
    waysView = [[WaysView alloc]initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, 44)];
    UITapGestureRecognizer *chooseWay = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseWay:)];
    [waysView addGestureRecognizer:chooseWay];
    [waysView configure];
    [_termView addSubview:waysView];
    
    numberView = [[NumberView alloc]initWithFrame:CGRectMake(0, 88, SCREEN_WIDTH, 44)];
    UITapGestureRecognizer *chooseNumber = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseNumber:)];
    [numberView addGestureRecognizer:chooseNumber];
    [numberView configure];
    [_termView addSubview:numberView];
}

- (void)initTimeView{
    timeView.startTime = self.startTime;
    timeView.endTime = self.endTime;
    [timeView congigure];
}

#pragma mark - 选择时间－方式－人数
- (void)chooseTime:(UITapGestureRecognizer *)tap{
    chooseTimeAlert = [[[NSBundle mainBundle]loadNibNamed:@"ChooseTime" owner:nil options:nil]firstObject];
    chooseTimeAlert.frame = CGRectMake(10, SCREEN_HEIGHT - 270, SCREEN_WIDTH - 20, 200) ;
    chooseTimeAlert.tag = 11;
    if (oldDate == 0) {
        [chooseTimeAlert configure];
    }
    [self initAlertView:chooseTimeAlert];
}

- (void)chooseWay:(UITapGestureRecognizer *)tap{
    chooseWayAlert = [[[NSBundle mainBundle]loadNibNamed:@"ContentView" owner:nil options:nil]firstObject];
    chooseWayAlert.frame = CGRectMake(10, SCREEN_HEIGHT- 320, SCREEN_WIDTH - 20, 250);
    chooseWayAlert.tag = 12;
    chooseWayAlert.defaultString = oldWay;
    [chooseWayAlert contentViewChooseBtn];
    [self initAlertView:chooseWayAlert];
}

- (void)chooseNumber:(UITapGestureRecognizer *)tap{
//    if(_defaultIndex == -1){//未选择拼客方式
//        [MyUtil showCleanMessage:@"请先选择拼客方式"];
//        return;
//    }else{
        chooseNumberAlert = [[[NSBundle mainBundle]loadNibNamed:@"ChoosePeople" owner:nil options:nil]firstObject];
        chooseNumberAlert.tag = 14;
        chooseNumberAlert.frame = CGRectMake(10, SCREEN_HEIGHT - 270, SCREEN_WIDTH - 20, 200) ;
        [chooseNumberAlert configure:oldPeople];
        [self initAlertView:chooseNumberAlert];
//    }
}

#pragma mark - LPAlertViewDelegate 
- (void)LPAlertView:(LPAlertView *)alertView clickedButtonAtIndexWhenTime:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:[NSString stringWithFormat:@"yyyy-MM-dd HH:mm"]];
        NSString *minDate = [formatter stringFromDate:chooseTimeAlert.timePicker.date];
        time = [minDate substringFromIndex:10];
        timeView.label3.text = time;
    }
}

- (void)LPAlertView:(LPAlertView *)alertView clickedButtonAtIndexWhenWay:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        for (int i = 0 ; i < chooseWayAlert.buttonStatusArray.count; i ++) {
            if([chooseWayAlert.buttonStatusArray[i] isEqualToString:@"1"]){
                waysView.label3.text = self.labelArray[i];
                oldWay = self.labelArray[i];
                
                //统计拼客方式的选择
                NSDictionary *dict = @{@"actionName":@"选择",@"pageName":@"拼客详情",@"titleName":@"选择拼客方式",@"value":oldWay};
                [MTA trackCustomKeyValueEvent:@"LYClickEvent" props:dict];
                
                self.defaultIndex = i;//作为已选方式的判断以及后期参数
                [self computerMoney];
                break;
            }
        }
    }
}

- (void)LPAlertView:(LPAlertView *)alertView clickedButtonAtIndexChooseNum:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        numberView.label3.text = chooseNumberAlert.numberField.text;
        oldPeople = [numberView.label3.text intValue];
        [self computerMoney];
    }
}

- (void)chooseManagerDone:(ManagerChooseButton *)button{
    index = (int)button.tag;
}

#pragma mark - initAlertView
- (void)initAlertView:(UIView *)content{
    LPAlertView *alertView = [[LPAlertView alloc]initWithDelegate:self buttonTitles:@"取消", @"确定",  nil];
    alertView.contentView = content;
    [alertView show];
}


#pragma mark - 获取数据
- (void)getdata{
    NSDictionary *dict = @{@"barid":[NSString stringWithFormat:@"%d",_barid],
                           @"smdate":datePar};
    __weak __typeof(self)weakSelf = self;
    [[LYHomePageHttpTool shareInstance]getTogetherListWithParams:dict block:^(NSMutableArray *result) {
        if(result.count>0){
            dataList = [[NSMutableArray alloc]initWithArray:result];
            [weakSelf.tableView reloadData];
            weakSelf.tableView.contentOffset = CGPointMake(0, -284);
            [weakSelf removeNoGoodView];
        }else{
            [weakSelf createNoGoodView];
        }
    }];
}

#pragma mark 无商品时界面
- (void)createNoGoodView{
    UILabel *alerLabel = [[UILabel alloc]init];
    alerLabel.frame = CGRectMake(0, 64 + 50, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 50);
    alerLabel.tag = 10086;
    alerLabel.textAlignment = NSTextAlignmentCenter;
    alerLabel.text = @"暂无组局拼客";
    [self.view addSubview:alerLabel];
}

#pragma mark 移除无商品时界面
- (void)removeNoGoodView{
    UIView *label = [self.view viewWithTag:10086];
    if (label) {
        [label removeFromSuperview];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return dataList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LYDinWeiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LYDinWeiTableViewCell" forIndexPath:indexPath];
    
    if(![indexPath isEqual: oldIndex]){
        cell.backView.layer.borderWidth = 0;
        cell.button_add.hidden = YES;
        cell.button_less.hidden = YES;
        cell.label_number.hidden = YES;
        [cell.button_add addTarget:self action:@selector(addGoodNum) forControlEvents:UIControlEventTouchUpInside];
        [cell.button_less addTarget:self action:@selector(lessGoodNum) forControlEvents:UIControlEventTouchUpInside];
        cell.imageView_button.tag = indexPath.section;
        [cell.imageView_button addTarget:self action:@selector(clickThisImageView:) forControlEvents:UIControlEventTouchUpInside];
        PinKeModel *model = [dataList objectAtIndex:indexPath.section];
        cell.pinkeModel = model;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else{
        cell.backView.layer.borderWidth = 2;
        cell.backView.layer.borderColor = [RGB(186, 40, 227)CGColor];
        cell.button_add.hidden = NO;
        cell.button_less.hidden = NO;
        cell.label_number.hidden = NO;
        cell.label_number.text = [NSString stringWithFormat:@"%d",oldNumber];
        if(oldNumber > 1){
            cell.button_less.enabled = YES;
            [cell.button_less setImage:[UIImage imageNamed:@"purper_less_circle"] forState:UIControlStateNormal];
        }
        oldCell = cell;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 104;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

#pragma mark - tableview的各项操作

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath != oldIndex){
        //旧的cell去除描边
        LYDinWeiTableViewCell *old_Cell = [tableView cellForRowAtIndexPath:oldIndex];
        [old_Cell setSelected:NO];
        
        //新的cell描边
        LYDinWeiTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell setSelected:YES];
        
        oldCell = [tableView cellForRowAtIndexPath:indexPath];
        oldIndex = indexPath;
        oldNumber = 1;
        
        oldCell.button_less.enabled = NO;
        [oldCell.button_less setImage:[UIImage imageNamed:@"gray_less_circle"] forState:UIControlStateNormal];
        self.payBtn.enabled = YES;
        self.payBtn.backgroundColor = RGB(186, 40, 207);
        self.numberLbl.text = @"共1点单";
        [self computerMoney];
        
        NSDictionary *dict = @{@"actionName":@"选择",@"pageName":@"组局",@"titleName":@"选择拼客套餐",@"value":[NSNumber numberWithInt:((PinKeModel *)[dataList objectAtIndex:indexPath.section]).smid]};
        [MTA trackCustomKeyValueEvent:@"LYClickEvent" props:dict];
    }
}

- (CGFloat)computerMoney{
    oldmoney = [oldCell.pinkeModel.price floatValue] * oldNumber;
    if (_defaultIndex == -1 || _defaultIndex == 0) {
        //未选择方式或者我请客
    }else if(_defaultIndex == 1){//AA付款
        if(oldPeople == 1){
            //还未选择拼客人数
        }else{
            oldmoney = oldmoney / oldPeople;
        }
    }else if(_defaultIndex == 2){
        //免费发起
        oldmoney = 0;
    }
    self.moneyLbl.text = [NSString stringWithFormat:@"总需支付:¥%g",oldmoney];
    return oldmoney;
}

- (void)addGoodNum{
    oldCell.label_number.text = [NSString stringWithFormat:@"%d",++oldNumber];
    self.numberLbl.text = [NSString stringWithFormat:@"共%d点单",oldNumber];
    //
    [self computerMoney];
//    int money = [oldCell.pinkeModel.price floatValue] * oldNumber;
//    self.moneyLbl.text = [NSString stringWithFormat:@"总需支付:¥%d",money];
    //    if(oldCell.button_less.enabled == NO){
    oldCell.button_less.enabled = YES;
    [oldCell.button_less setImage:[UIImage imageNamed:@"purper_less_circle"] forState:UIControlStateNormal];
    //    }
    NSDictionary *dict = @{@"actionName":@"确定",@"pageName":@"组局",@"titleName":@"增加拼客数量"};
    [MTA trackCustomKeyValueEvent:@"LYClickEvent" props:dict];
}

- (void)lessGoodNum{
    oldCell.label_number.text = [NSString stringWithFormat:@"%d",--oldNumber];
    self.numberLbl.text = [NSString stringWithFormat:@"共%d点单",oldNumber];
//    int money = [oldCell.pinkeModel.price intValue] * oldNumber;
//    self.moneyLbl.text = [NSString stringWithFormat:@"总需支付：%d",money];
    [self computerMoney];
    if(oldNumber > 1){
        oldCell.button_less.enabled = YES;
        [oldCell.button_less setImage:[UIImage imageNamed:@"purper_less_circle"] forState:UIControlStateNormal];
    }else{
        oldCell.button_less.enabled = NO;
        [oldCell.button_less setImage:[UIImage imageNamed:@"gray_less_circle"] forState:UIControlStateNormal];
    }
    NSDictionary *dict = @{@"actionName":@"确定",@"pageName":@"组局",@"titleName":@"减少拼客数量"};
    [MTA trackCustomKeyValueEvent:@"LYClickEvent" props:dict];
}

- (void)clickThisImageView:(UIButton *)sender{
    UIView *bigView = [[UIView alloc]initWithFrame:self.view.frame];
    bigView.backgroundColor = RGBA(0, 0, 0, 0.3);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideBigView:)];
    [bigView addGestureRecognizer:tap];
    
    DetailView *detailView = [[[NSBundle mainBundle]loadNibNamed:@"DetailView" owner:nil options:nil]firstObject];
    detailView.frame = CGRectMake(8, 64, SCREEN_WIDTH - 16, 268 + SCREEN_WIDTH / 3);
    detailView.center = self.view.center;
    PinKeModel *model = [dataList objectAtIndex:sender.tag];
//    RecommendPackageModel *model = [jiubaModel.recommend_package objectAtIndex:sender.tag];
//    detailView.packModel = model;
    detailView.delegate = self;
    NSDictionary *dic=@{@"smid":[NSString stringWithFormat:@"%d",model.smid]};
    [[LYHomePageHttpTool shareInstance]getTogetherDetailWithParams:dic block:^(PinKeModel *result) {
        [detailView fillPinkeModel:result];
    }];
//    [[LYHomePageHttpTool shareInstance]getWoYaoDinWeiTaoCanDetailWithParams:dic block:^(TaoCanModel *result) {
//        PinKeModel *pkModel = result;
////        detailView fillPinkeModel:<#(PinKeModel *)#>
//    }];
    NSDictionary *dict = @{@"actionName":@"确定",@"pageName":@"组局",@"titleName":@"查看拼客详情",@"value":model.title};
    [MTA trackCustomKeyValueEvent:@"LYClickEvent" props:dict];
    [self.view addSubview:bigView];
    [bigView addSubview:detailView];
}

#pragma mark - 将详情界面撤销
- (void)hideBigView:(UITapGestureRecognizer *)gesture{
    [gesture.view removeFromSuperview];
}

- (void)showImageInPreview:(UIImage *)image{
//    [self.navigationController.navigationBar setHidden:YES];
    _subView = [[[NSBundle mainBundle]loadNibNamed:@"preview" owner:nil options:nil]firstObject];
    _subView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    _subView.button.hidden = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(previewHide)];
    [_subView addGestureRecognizer:tap];
    _subView.image = image;
    [_subView viewConfigure];
    //    _subView.imageView.contentMode = UIViewContentModeScaleAspectFit;
    //    _subView.imageView.center = _subView.center;
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:_subView];
    NSDictionary *dict = @{@"actionName":@"确定",@"pageName":@"组局",@"titleName":@"预览拼客图片"};
    [MTA trackCustomKeyValueEvent:@"LYClickEvent" props:dict];
}

- (void)previewHide{
//    [self.navigationController.navigationBar setHidden:NO];
    [_subView removeFromSuperview];
}


@end
