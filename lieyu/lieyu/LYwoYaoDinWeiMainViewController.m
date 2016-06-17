//
//  LYwoYaoDinWeiMainViewController.m
//  lieyu
//
//  Created by 薛斯岐 on 15/10/20.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYwoYaoDinWeiMainViewController.h"
#import "DWTopInfoView.h"
#import "TaoCanTitleView.h"
#import "OrderDetailCell.h"
#import "ShopDetailmodel.h"
#import "OrderInfoModel.h"
#import "LYHomePageHttpTool.h"
#import "JiuBaModel.h"
#import "LYUserHttpTool.h"
#import "DWTaoCanXQViewController.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "LYDinWeiTableViewCell.h"
#import "TimeView.h"
#import "LPAlertView.h"
#import "ChooseTime.h"
#import "ChoosePayController.h"
#import "MTA.h"

#define WOYAODINGWEIPAGE_MTA @"WOYAODINGWEIPAGE"

@interface LYwoYaoDinWeiMainViewController ()<UITableViewDataSource,UITableViewDelegate,LPAlertViewDelegate>
{
    int index;//选择的第几个专属经理
    NSString *time;//到店时间
    NSIndexPath *oldIndex;//选择的cell的indexpath
    LYDinWeiTableViewCell *oldCell;//选择的cell的indexpath
    int oldNumber;//选择的商品数量
    int oldDate;//选择的是第几天
    
    ChooseTime *chooseTimeAlert;
    TimeView *timeView;
    ManagersView *managerView;
    JiuBaModel *jiubaModel;
    RecommendPackageModel *tcModel;
    NSMutableArray *zsList;
}
@end

@implementation LYwoYaoDinWeiMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView.showsHorizontalScrollIndicator=NO;
    _tableView.showsVerticalScrollIndicator=NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeAll;
    _tableView.contentInset = UIEdgeInsetsMake(200, 0, 0, 0);
    _tableView.separatorColor=[UIColor clearColor];
    weekDateArr = [[NSMutableArray alloc]initWithCapacity:7];
    [self getweekDate];
    [self getMenuHrizontal];
    [self getdata];
    [self initThisBottomView];
    [self managerList];
    [self initManagerView];
    // Do any additional setup after loading the view from its nib.
    [self.tableView registerNib:[UINib nibWithNibName:@"LYDinWeiTableViewCell" bundle:nil] forCellReuseIdentifier:@"LYDinWeiTableViewCell"];
    self.navigationItem.title = @"预定";
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
    _NumberLbl.text = @"共0点单";
    _moneyLbl.text = @"总需支付:¥0";
}

#pragma mark - 选择套餐时间
- (void)chooseTime:(UITapGestureRecognizer *)tap{
    LPAlertView *alertView = [[LPAlertView alloc]initWithDelegate:self buttonTitles:@"取消", @"确定",  nil];
    chooseTimeAlert = [[[NSBundle mainBundle]loadNibNamed:@"ChooseTime" owner:nil options:nil]firstObject];
//    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
//    [formatter setDateFormat:[NSString stringWithFormat:@"yyyy-MM-dd HH:mm"]];
//    NSDate *minDate = [formatter dateFromString:[NSString stringWithFormat:@"2016-01-26 20:00"]];
//    NSDate *maxDate = [formatter dateFromString:[NSString stringWithFormat:@"2016-01-27 05:00"]];
//    chooseTimeAlert.minDate = minDate;
//    chooseTimeAlert.maxDate = maxDate;
//    [chooseTimeAlert configure];
//    chooseTimeAlert.timePicker.date = [NSDate date];
    chooseTimeAlert.tag = 11;
    alertView.contentView = chooseTimeAlert;
    chooseTimeAlert.frame = CGRectMake(10, SCREEN_HEIGHT - 270, SCREEN_WIDTH - 20, 200) ;
    if (oldDate == 0) {
        [chooseTimeAlert configure];
    }
    [alertView show];
}

#pragma mark - 选择时间后的代理事件
- (void)LPAlertView:(LPAlertView *)alertView clickedButtonAtIndexWhenTime:(NSInteger)buttonIndex{
    if (buttonIndex) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:[NSString stringWithFormat:@"yyyy-MM-dd HH:mm"]];
        NSString *minDate = [formatter stringFromDate:chooseTimeAlert.timePicker.date];
        time = [minDate substringFromIndex:10];
        timeView.label3.text = time;
        if (oldIndex) {
            [self PayMoneyNow];
        }
    }
}

- (void)initTimeView{
//    if(self.startTime.length <= 0){
//        self.startTime = @"20:00";
//    }
//    if (self.endTime.length <= 0 ) {
//        self.endTime = @"24:00";
//    }
    
    if ([MyUtil isEmptyString:self.startTime] && jiubaModel) {
        timeView.startTime = jiubaModel.startTime;
    }else if (![MyUtil isEmptyString:self.startTime]){
        timeView.startTime = self.startTime;
    }
    if ([MyUtil isEmptyString:self.endTime] && jiubaModel) {
        timeView.endTime = jiubaModel.endTime;
    }else if (![MyUtil isEmptyString:self.endTime]){
        timeView.endTime = self.endTime;
    }
    [timeView congigure];
}

- (void)initManagerView{
    if(managerView){
        [managerView removeFromSuperview];
    }
    managerView = [[ManagersView alloc]initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, 54)];
    _managersView.layer.shadowRadius = 2;
    _managersView.layer.shadowColor = [[UIColor lightGrayColor]CGColor];
    _managersView.layer.shadowOffset = CGSizeMake(0, 1);
    _managersView.layer.shadowOpacity = 0.5;
    managerView.delegate = self;
    managerView.backgroundColor = [UIColor whiteColor];
    [_managersView addSubview:managerView];
    zsList = [NSMutableArray array];
    NSDictionary *dic=@{@"barid":[NSNumber numberWithInt:_barid],@"":@""};
    [[LYHomePageHttpTool shareInstance]getBarVipWithParams:dic block:^(NSMutableArray *result) {
        [zsList addObjectsFromArray:result];
        if (![MyUtil isEmptyString:_choosedManagerID]) {
            managerView.choosedManagerID = _choosedManagerID;
        }
        [managerView configure:zsList];
    }];
}

#pragma mark - 营业时间与专属经理选框
- (void)managerList{
    timeView = [[TimeView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    timeView.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *chooseTime = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseTime:)];
    [timeView addGestureRecognizer:chooseTime];
    [self initTimeView];
    [_managersView addSubview:timeView];

}

- (void)chooseManagerDone:(ManagerChooseButton *)button{
    index = (int)button.tag;
}

#pragma mark - 立即支付
- (void)PayMoneyNow{
    if(time == nil){
        LPAlertView *alertView = [[LPAlertView alloc]initWithDelegate:self buttonTitles:@"取消", @"确定",  nil];
        chooseTimeAlert = [[[NSBundle mainBundle]loadNibNamed:@"ChooseTime" owner:nil options:nil]firstObject];
        chooseTimeAlert.tag = 11;
        alertView.contentView = chooseTimeAlert;
        chooseTimeAlert.frame = CGRectMake(10, SCREEN_HEIGHT - 270, SCREEN_WIDTH - 20, 200) ;
        if (oldDate == 0) {
            [chooseTimeAlert configure];
        }
        [alertView show];
        return;
    }else{
        NSString *dataAndTime = [[[weekDateArr objectAtIndex:oldDate][@"date"] stringByAppendingString:time] stringByAppendingString:@":00"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//        NSString *reachtime = [formatter stringFromDate:_timeView.timePicker.date];
        if (zsList.count==0) {
            [MyUtil showCleanMessage:@"该酒吧暂无专属经理，无法下单！"];
            return;
        }
        tcModel = jiubaModel.recommend_package[oldIndex.section];
        ZSDetailModel *zsModel = zsList[index];
        NSLog(@"%@",tcModel.smid);
        NSDictionary *dic=@{@"smid":tcModel.smid,@"reachtime":dataAndTime,@"checkuserid":[NSNumber numberWithInt:zsModel.userid],@"allnum":[NSNumber numberWithInt:oldNumber],@"consumptionStatus":@"1"};
        __weak LYwoYaoDinWeiMainViewController *weakSelf = self;
            [[LYHomePageHttpTool shareInstance]setWoYaoDinWeiOrderInWithParams:dic complete:^(NSString *result) {
                if(result){
                    //支付宝页面"data": "P130637201510181610220",
                    //result的值就是P130637201510181610220
                    ChoosePayController *detailViewController =[[ChoosePayController alloc] init];
                    detailViewController.orderNo=result;
                    detailViewController.payAmount=[tcModel.price intValue]*oldNumber;
                    detailViewController.productName=tcModel.title;
                    detailViewController.productDescription=@"暂无";
                    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"return"] style:UIBarButtonItemStylePlain target:weakSelf action:nil];
                    weakSelf.navigationItem.backBarButtonItem = left;
                    [weakSelf.navigationController pushViewController:detailViewController animated:YES];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"loadUserInfo" object:nil];
                    [MTA trackCustomKeyValueEvent:LYCLICK_MTA props:[self createMTADctionaryWithActionName:@"跳转" pageName:@"预定" titleName:@"马上支付"]];
                }
            }];
    }
}

- (void)gotoBack1{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.layer.shadowOffset = CGSizeMake(0, 0);
    self.navigationController.navigationBar.layer.borderWidth = 0;
//    [[UINavigationBar appearance]setBackgroundImage:nil forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [self.navigationController setNavigationBarHidden:NO];

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

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

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController setNavigationBarHidden:NO];
}

#pragma mark 获取顶部菜单
-(void)getMenuHrizontal{
    NSMutableArray *barArr=[[NSMutableArray alloc]initWithCapacity:7];
    
    for (int i=0; i<=weekDateArr.count-1; i++) {
        
        NSDictionary *dic=weekDateArr[i];
        NSMutableDictionary *itemTemp =[[NSMutableDictionary alloc]init] ;
//        // 使用颜色创建UIImage//未选中颜色
//        CGSize imageSize = CGSizeMake((SCREEN_WIDTH/5.5), 34);
//        UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
//        [RGB(229, 255, 245) set];
//        UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
//        UIImage *normalImg = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
        
//        [itemTemp setObject:normalImg forKey:NOMALKEY];
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
        mMenuHriZontal.layer.borderWidth = 0;
        mMenuHriZontal.layer.shadowRadius = 2;
        mMenuHriZontal.layer.shadowColor = [[UIColor lightGrayColor]CGColor];
        mMenuHriZontal.layer.shadowOffset = CGSizeMake(0, 1);
        mMenuHriZontal.layer.shadowOpacity = 0.5;
    }
    [self.view addSubview:mMenuHriZontal];
}

#pragma mark 获取数据
-(void)getdata{
    NSDictionary *dic=@{@"barid":[NSString stringWithFormat:@"%d",self.barid],@"smdate":datePar};
    NSLog(@"------>%@",dic);
    __weak __typeof(self)weakSelf = self;
    [[LYHomePageHttpTool shareInstance]getWoYaoDinWeiDetailWithParams:dic block:^(JiuBaModel *result) {
        if(result.recommend_package.count){
        jiubaModel=result;
//        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
            weakSelf.tableView.contentOffset = CGPointMake(0, -200);
//        });
            [weakSelf initTimeView];
            [weakSelf removeNoGoodView];
        }else{
            [weakSelf createNoGoodView];
        }
    }];
}

- (void)initThisCell{
    oldCell.button_less.enabled = NO;
    oldCell.label_number.text = @"1";
    oldCell = nil;
    oldIndex = nil;
    oldNumber = 1;
}

#pragma mark 无商品时界面
- (void)createNoGoodView{
    UILabel *alerLabel = [[UILabel alloc]init];
    alerLabel.frame = CGRectMake(0, 64 + 50, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 50);
    alerLabel.tag = 10086;
    alerLabel.textAlignment = NSTextAlignmentCenter;
    alerLabel.text = @"暂无套餐";
    [self.view addSubview:alerLabel];
}

#pragma mark 移除无商品时界面
- (void)removeNoGoodView{
    UIView *label = [self.view viewWithTag:10086];
    if (label) {
        [label removeFromSuperview];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return jiubaModel.recommend_package.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
        RecommendPackageModel *model=jiubaModel.recommend_package[indexPath.section];
        cell.model = model;
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
        self.NumberLbl.text = @"共1点单";
        self.moneyLbl.text = [NSString stringWithFormat:@"总需支付：%@",cell.label_price_now.text];
        
        NSDictionary *dict = @{@"actionName":@"选择套餐",
                               @"pageName":@"预定",
                               @"titleName":((RecommendPackageModel *)[jiubaModel.recommend_package objectAtIndex:indexPath.section]).title};
        [MTA trackCustomKeyValueEvent:@"LYClickEvent" props:dict];
        
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 104;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 点击图片查看详情
- (void)clickThisImageView:(UIButton *)sender{
    UIView *bigView = [[UIView alloc]initWithFrame:self.view.frame];
    bigView.backgroundColor = RGBA(0, 0, 0, 0.3);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideBigView:)];
    [bigView addGestureRecognizer:tap];
    
    __weak DetailView *detailView = [[[NSBundle mainBundle]loadNibNamed:@"DetailView" owner:nil options:nil]firstObject];
    detailView.frame = CGRectMake(8, 64, SCREEN_WIDTH - 16, 268 + SCREEN_WIDTH / 3);
    detailView.center = self.view.center;
    RecommendPackageModel *model = [jiubaModel.recommend_package objectAtIndex:sender.tag];
    detailView.packModel = model;
    detailView.delegate = self;
    NSDictionary *dic=@{@"smid":[NSString stringWithFormat:@"%@",model.smid]};
    [[LYHomePageHttpTool shareInstance]getWoYaoDinWeiTaoCanDetailWithParams:dic block:^(TaoCanModel *result) {
        [detailView setTcModel:result];
        [detailView Configure];
    }];

    NSDictionary *dict = @{@"actionName":@"查看套餐详情",
                           @"pageName":@"预定",
                           @"titleName":model.title};
    [MTA trackCustomKeyValueEvent:@"LYClickEvent" props:dict];
    
    [self.view addSubview:bigView];
    [bigView addSubview:detailView];
}

#pragma mark - 将详情界面撤销
- (void)hideBigView:(UITapGestureRecognizer *)gesture{
    [gesture.view removeFromSuperview];
}

#pragma mark - 加减法
- (void)addGoodNum{
    oldCell.label_number.text = [NSString stringWithFormat:@"%d",++oldNumber];
    self.NumberLbl.text = [NSString stringWithFormat:@"共%d点单",oldNumber];
    int money = [oldCell.model.price intValue] * oldNumber;
    self.moneyLbl.text = [NSString stringWithFormat:@"总需支付:¥%d",money];
//    if(oldCell.button_less.enabled == NO){
        oldCell.button_less.enabled = YES;
        [oldCell.button_less setImage:[UIImage imageNamed:@"purper_less_circle"] forState:UIControlStateNormal];
//    }
    NSDictionary *dict = @{@"actionName":@"确定",
                           @"pageName":@"预定",
                           @"titleName":@"增加套餐数量"};
    [MTA trackCustomKeyValueEvent:@"LYClickEvent" props:dict];
}

- (void)lessGoodNum{
    oldCell.label_number.text = [NSString stringWithFormat:@"%d",--oldNumber];
    self.NumberLbl.text = [NSString stringWithFormat:@"共%d点单",oldNumber];
    int money = [oldCell.model.price intValue] * oldNumber;
    self.moneyLbl.text = [NSString stringWithFormat:@"总需支付：%d",money];
    if(oldNumber > 1){
        oldCell.button_less.enabled = YES;
        [oldCell.button_less setImage:[UIImage imageNamed:@"purper_less_circle"] forState:UIControlStateNormal];
    }else{
        oldCell.button_less.enabled = NO;
        [oldCell.button_less setImage:[UIImage imageNamed:@"gray_less_circle"] forState:UIControlStateNormal];
    }
    
    NSDictionary *dict = @{@"actionName":@"确定",
                           @"pageName":@"预定",
                           @"titleName":@"减少套餐数量"};
    [MTA trackCustomKeyValueEvent:@"LYClickEvent" props:dict];
}

#pragma mark - MTA字典

#pragma mark MenuHrizontalDelegate
-(void)didMenuHrizontalClickedButtonAtIndex:(NSInteger)aIndex{
    oldDate = (int)aIndex;
    NSDictionary *dic=weekDateArr[aIndex];
    datePar=[dic objectForKey:@"month"];
    
    NSDictionary *dict = @{@"actionName":@"筛选",@"pageName":@"我要订位",@"titleName":@"选择预定日期",@"value":[dic objectForKey:@"week"]};
    [MTA trackCustomKeyValueEvent:@"LYClickEvent" props:dict];
    
    [self initThisCell];
    [self initBottomLabelAndButton];
    [self initManagerView];
    [self getdata];
}

#pragma mark - 显示预览图片
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
    NSDictionary *dict = @{@"actionName":@"确定",
                           @"pageName":@"预定",
                           @"titleName":@"预览套餐图片"};
    [MTA trackCustomKeyValueEvent:@"LYClickEvent" props:dict];
    
}

- (void)previewHide{
//    [self.navigationController.navigationBar setHidden:NO];
    [_subView removeFromSuperview];
}

@end
