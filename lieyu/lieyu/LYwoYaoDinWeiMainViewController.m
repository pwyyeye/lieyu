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
@interface LYwoYaoDinWeiMainViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    JiuBaModel *jiubaModel;
}
@end

@implementation LYwoYaoDinWeiMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.showsHorizontalScrollIndicator=NO;
    _tableView.showsVerticalScrollIndicator=NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeAll;
    _tableView.separatorColor=[UIColor clearColor];
    weekDateArr = [[NSMutableArray alloc]initWithCapacity:7];
    [self getweekDate];
    [self getMenuHrizontal];
    [self getdata];
    // Do any additional setup after loading the view from its nib.
    [self.tableView registerNib:[UINib nibWithNibName:@"LYDinWeiTableViewCell" bundle:nil] forCellReuseIdentifier:@"LYDinWeiTableViewCell"];
    self.navigationItem.title = @"所有套餐";
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
        // 使用颜色创建UIImage//未选中颜色
        CGSize imageSize = CGSizeMake((SCREEN_WIDTH/5.5), 34);
        UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
        [RGB(229, 255, 245) set];
        UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
        UIImage *normalImg = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        [itemTemp setObject:normalImg forKey:NOMALKEY];
        [itemTemp setObject: [dic objectForKey:@"week"] forKey:WEEKKEY];
        [itemTemp setObject:[dic objectForKey:@"day"]  forKey:TITLEKEY];
        [itemTemp setObject:[dic objectForKey:@"month"] forKey:MONTHKEY];
        [itemTemp setObject:[NSNumber numberWithFloat:67.5]  forKey:TITLEWIDTH];
        [itemTemp setObject:@""  forKey:COUNTORDER];
        [barArr addObject:itemTemp];
    }
    
    if (mMenuHriZontal == nil) {
        mMenuHriZontal = [[MenuHrizontal alloc] initWithFrameForTime:CGRectMake(0,64, 320, 50) ButtonItems:barArr];
        mMenuHriZontal.delegate = self;
    }
    [self.view addSubview:mMenuHriZontal];
}
#pragma mark 获取数据
-(void)getdata{
    NSDictionary *dic=@{@"barid":[NSString stringWithFormat:@"%d",self.barid],@"smdate":datePar};
    NSLog(@"------>%@",dic);
    __weak __typeof(self)weakSelf = self;
    [[LYHomePageHttpTool shareInstance]getWoYaoDinWeiDetailWithParams:dic block:^(JiuBaModel *result) {
        jiubaModel=result;
        [weakSelf.tableView reloadData];
    }];
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
    NSLog(@"--------->%ld",jiubaModel.recommend_package.count);
    RecommendPackageModel *model=jiubaModel.recommend_package[indexPath.section];
    cell.model = model;
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic=weekDateArr[mMenuHriZontal.selectIndex];
    NSString *dataChoose=[dic objectForKey:@"date"];
    RecommendPackageModel *model=jiubaModel.recommend_package[indexPath.section];
    UIStoryboard *stroyBoard=[UIStoryboard storyboardWithName:@"NewMain" bundle:nil];
    DWTaoCanXQViewController *taoCanXQViewController=[stroyBoard instantiateViewControllerWithIdentifier:@"DWTaoCanXQViewController"];
    taoCanXQViewController.title=@"套餐详情";
    taoCanXQViewController.smid=model.smid.intValue;
    taoCanXQViewController.dateStr=dataChoose;
    taoCanXQViewController.weekStr = [dic objectForKey:@"week"];
    taoCanXQViewController.jiubaModel = jiubaModel;
    [self.navigationController pushViewController:taoCanXQViewController animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
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
#pragma mark MenuHrizontalDelegate
-(void)didMenuHrizontalClickedButtonAtIndex:(NSInteger)aIndex{
     NSDictionary *dic=weekDateArr[aIndex];
    datePar=[dic objectForKey:@"month"];
    [self getdata];
}

@end
