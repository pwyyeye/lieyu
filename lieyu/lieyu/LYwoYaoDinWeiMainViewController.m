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
@interface LYwoYaoDinWeiMainViewController ()
{
    JiuBaModel *jiubaModel;
}
@end

@implementation LYwoYaoDinWeiMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.showsHorizontalScrollIndicator=NO;
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.separatorColor=[UIColor clearColor];
    weekDateArr = [[NSMutableArray alloc]initWithCapacity:7];
    [self getweekDate];
    [self getMenuHrizontal];
    [self getdata];
    // Do any additional setup after loading the view from its nib.
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
            weekStr=@"星期天";
        }else if(week==2){
            weekStr=@"星期一";
            
        }else if(week==3){
            weekStr=@"星期二";
            
        }else if(week==4){
            weekStr=@"星期三";
            
        }else if(week==5){
            weekStr=@"星期四";
            
        }else if(week==6){
            weekStr=@"星期五";
            
        }else if(week==7){
            weekStr=@"星期六";
            
        }
        if(i==0){
            datePar=dateStr;
            _moonLal.text=[MyUtil getMoonValue:[NSString stringWithFormat:@"%d",month]];
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
        [itemTemp setObject:[NSNumber numberWithFloat:67.5]  forKey:TITLEWIDTH];
        [itemTemp setObject:@""  forKey:COUNTORDER];
        [barArr addObject:itemTemp];
    }
    
    if (mMenuHriZontal == nil) {
        mMenuHriZontal = [[MenuHrizontal alloc] initWithFrameForTime:CGRectMake(52, 21, SCREEN_WIDTH-52, self.menuView.height-21) ButtonItems:barArr];
        mMenuHriZontal.delegate = self;
    }
    [self.view addSubview:mMenuHriZontal];
}
#pragma mark 获取数据
-(void)getdata{
    NSDictionary *dic=@{@"barid":[NSString stringWithFormat:@"%d",self.barid],@"smdate":datePar};
    __weak __typeof(self)weakSelf = self;
    [[LYHomePageHttpTool shareInstance]getWoYaoDinWeiDetailWithParams:dic block:^(JiuBaModel *result) {
        jiubaModel=result;
        NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"DWTopInfoView" owner:nil options:nil];
        DWTopInfoView *topInfoView= (DWTopInfoView *)[nibView objectAtIndex:0];
        
        [topInfoView.jiubaImageView setImageWithURL:[NSURL URLWithString:jiubaModel.baricon]];
        topInfoView.addressLal.text=jiubaModel.address;
        topInfoView.jiubaName.text=jiubaModel.barname;
        topInfoView.yudingliangLal.text=jiubaModel.today_sm_buynum;
        weakSelf.tableView.tableHeaderView=topInfoView;
        [weakSelf.tableView reloadData];
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
        return jiubaModel.recommend_package.count;
   
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 48;
}



-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
 
    
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"TaoCanTitleView" owner:nil options:nil];
    TaoCanTitleView *taoCanTitleView= (TaoCanTitleView *)[nibView objectAtIndex:0];
    taoCanTitleView.orderNumLal.text=[NSString stringWithFormat:@"%ld",jiubaModel.recommend_package.count];
    return taoCanTitleView;
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"OrderDetailCell";
    RecommendPackageModel *model=jiubaModel.recommend_package[indexPath.row];
    OrderDetailCell *cell = (OrderDetailCell *)[_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = (OrderDetailCell *)[nibArray objectAtIndex:0];
        cell.backgroundColor=[UIColor whiteColor];
    }
    
    cell.nameLal.text=model.title;
    cell.delLal.text=[NSString stringWithFormat:@"[适合%@-%@人]",model.minnum,model.maxnum];
    NSString *flTem=[NSString stringWithFormat:@"再返利%.f%%",model.rebate.doubleValue*100];
    [cell.yjBtn setTitle:flTem forState:0];
    cell.zhekouLal.text=[NSString stringWithFormat:@"￥%@",model.price];
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"￥%@",model.marketprice] attributes:attribtDic];
    cell.moneyLal.attributedText=attribtStr;
    NSString *str=model.linkUrl ;
    [cell.taoCanImageView setImageWithURL:[NSURL URLWithString:str]];
    UILabel *lineLal=[[UILabel alloc]initWithFrame:CGRectMake(15, 75.5, 290, 0.5)];
    lineLal.backgroundColor=RGB(199, 199, 199);
    [cell addSubview:lineLal];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic=weekDateArr[mMenuHriZontal.selectIndex];
    NSString *dataChoose=[dic objectForKey:@"date"];
    RecommendPackageModel *model=jiubaModel.recommend_package[indexPath.row];
    UIStoryboard *stroyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DWTaoCanXQViewController *taoCanXQViewController=[stroyBoard instantiateViewControllerWithIdentifier:@"DWTaoCanXQViewController"];
    taoCanXQViewController.title=@"套餐详情";
    taoCanXQViewController.smid=model.smid.intValue;
    taoCanXQViewController.dateStr=dataChoose;
    [self.navigationController pushViewController:taoCanXQViewController animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 76;
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
    _moonLal.text=_moonLal.text=[MyUtil getMoonValue:[dic objectForKey:@"month"]];
    datePar=[dic objectForKey:@"date"];
    [self getdata];
}
- (IBAction)soucangAct:(UIButton *)sender {

    NSDictionary *dic=@{@"barid":[NSNumber numberWithInt:jiubaModel.barid]};
    [[LYUserHttpTool shareInstance] addMyBarWithParams:dic complete:^(BOOL result) {
        if(result){
            
            [MyUtil showMessage:@"收藏成功"];
        }
    }];

    
}

- (IBAction)backAct:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
