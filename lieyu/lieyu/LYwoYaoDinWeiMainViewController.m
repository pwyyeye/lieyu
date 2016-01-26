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
#import "DetailView.h"

#define WOYAODINGWEIPAGE_MTA @"WOYAODINGWEIPAGE"

@interface LYwoYaoDinWeiMainViewController ()<UITableViewDataSource,UITableViewDelegate,LPAlertViewDelegate>
{
    int index;//选择的第几个专属经理
    NSString *time;//到店时间
    NSIndexPath *oldIndex;//选择的cell的indexpath
    LYDinWeiTableViewCell *oldCell;//选择的cell的indexpath
    int oldNumber;//选择的商品数量
    
    ChooseTime *chooseTimeAlert;
    TimeView *timeView;
    JiuBaModel *jiubaModel;
    NSMutableArray *zsList;
}
@end

@implementation LYwoYaoDinWeiMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    _tableView.frame = CGRectMake(0, 64 + 50, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 50);
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView.showsHorizontalScrollIndicator=NO;
    _tableView.showsVerticalScrollIndicator=NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeAll;
    _tableView.separatorColor=[UIColor clearColor];
    weekDateArr = [[NSMutableArray alloc]initWithCapacity:7];
    [self getweekDate];
    [self getMenuHrizontal];
    [self getdata];
    [self initThisBottomView];
    [self managerList];
    // Do any additional setup after loading the view from its nib.
    [self.tableView registerNib:[UINib nibWithNibName:@"LYDinWeiTableViewCell" bundle:nil] forCellReuseIdentifier:@"LYDinWeiTableViewCell"];
    self.navigationItem.title = @"所有套餐";
    UIBarButtonItem *item=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return"] style:UIBarButtonItemStylePlain target:self action:@selector(gotoBack)];
    [self.navigationItem setLeftBarButtonItem:item];
}

#pragma mark - 初始化界面
- (void)initThisBottomView{
    _bottomView.backgroundColor = RGBA(243, 243, 243, 1);
    _bottomView.layer.shadowRadius = 2;
    _bottomView.layer.shadowColor = [[UIColor lightGrayColor]CGColor];
    _bottomView.layer.shadowOffset = CGSizeMake(0, 1);
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
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:[NSString stringWithFormat:@"yyyy-MM-dd HH:mm"]];
//    NSDate *minDate = [formatter dateFromString:[NSString stringWithFormat:@"2016-01-26 20:00"]];
//    NSDate *maxDate = [formatter dateFromString:[NSString stringWithFormat:@"2016-01-27 05:00"]];
//    chooseTimeAlert.minDate = minDate;
//    chooseTimeAlert.maxDate = maxDate;
//    [chooseTimeAlert configure];
//    chooseTimeAlert.timePicker.date = [NSDate date];
    chooseTimeAlert.tag = 11;
    alertView.contentView = chooseTimeAlert;
    chooseTimeAlert.frame = CGRectMake(10, SCREEN_HEIGHT - 270, SCREEN_WIDTH - 20, 200) ;
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
    }
}

#pragma mark - 营业时间与专属经理选框
- (void)managerList{
    timeView = [[TimeView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    UITapGestureRecognizer *chooseTime = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseTime:)];
    [timeView addGestureRecognizer:chooseTime];
    [_managersView addSubview:timeView];
    
    
    zsList = [NSMutableArray array];
    NSDictionary *dic=@{@"barid":[NSNumber numberWithInt:_barid]};
    [[LYHomePageHttpTool shareInstance]getBarVipWithParams:dic block:^(NSMutableArray *result) {
        [zsList addObjectsFromArray:result];
        ManagersView *managerView = [[ManagersView alloc]initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, 54)];
        managerView.layer.shadowRadius = 2;
        managerView.layer.shadowColor = [[UIColor lightGrayColor]CGColor];
        managerView.layer.shadowOffset = CGSizeMake(0, 1);
        managerView.layer.shadowOpacity = 0.5;
        managerView.delegate = self;
        managerView.backgroundColor = [UIColor whiteColor];
        [managerView configure:zsList];
        [_managersView addSubview:managerView];
    }];
}

- (void)chooseManagerDone:(ManagerChooseButton *)button{
    index = (int)button.tag;
}

#pragma mark - 立即支付
- (void)PayMoneyNow{
    NSLog(@"index:%d",index);
    NSLog(@"oldCell:%@",oldCell);
    NSLog(@"oldIndex:%@",oldIndex);
    NSLog(@"oldNumber:%d",oldNumber);
    NSLog(@"time:%@",time);
}

- (void)gotoBack{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    
}
#pragma mark 获取七天日期
-(void)getweekDate{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
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
    self.navigationController.navigationBarHidden = NO;
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
//        });
            
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
        cell.imageView_button.tag = indexPath.row;
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
//    NSDictionary *dic=weekDateArr[mMenuHriZontal.selectIndex];
//    NSString *dataChoose=[dic objectForKey:@"date"];
//    RecommendPackageModel *model=jiubaModel.recommend_package[indexPath.section];
//    UIStoryboard *stroyBoard=[UIStoryboard storyboardWithName:@"NewMain" bundle:nil];
//    DWTaoCanXQViewController *taoCanXQViewController=[stroyBoard instantiateViewControllerWithIdentifier:@"DWTaoCanXQViewController"];
//    taoCanXQViewController.title=@"套餐详情";
//    taoCanXQViewController.smid=model.smid.intValue;
//    taoCanXQViewController.dateStr=dataChoose;
//    taoCanXQViewController.weekStr = [dic objectForKey:@"week"];
//    taoCanXQViewController.jiubaModel = jiubaModel;
//    [self.navigationController pushViewController:taoCanXQViewController animated:YES]; 
//    [MTA trackCustomKeyValueEvent:LYCLICK_MTA props:[self createMTADctionaryWithActionName:@"跳转" pageName:WOYAODINGWEIPAGE_MTA titleName:model.title]];
//    [MTA trackCustomKeyValueEvent:@"TCList" props:nil];
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
}

#pragma mark MenuHrizontalDelegate
-(void)didMenuHrizontalClickedButtonAtIndex:(NSInteger)aIndex{
     NSDictionary *dic=weekDateArr[aIndex];
    datePar=[dic objectForKey:@"month"];
    [self initThisCell];
    [self initBottomLabelAndButton];
    [self getdata];
}

@end
