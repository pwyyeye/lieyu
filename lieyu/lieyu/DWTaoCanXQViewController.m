//
//  DWTaoCanXQViewController.m
//  lieyu
//
//  Created by 薛斯岐 on 15/10/21.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "DWTaoCanXQViewController.h"
#import "PTTaoCanCell.h"
#import "PTShowIntroductionsCell.h"
#import "LYTaoCanXQCell.h"
#import "LYTitleInfoCell.h"
#import "LYHomePageHttpTool.h"
#import "TaoCanModel.h"
#import "DWSureOrderViewController.h"
@interface DWTaoCanXQViewController ()
{
    TaoCanModel *taoCanModel;
}
@end

@implementation DWTaoCanXQViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.showsHorizontalScrollIndicator=NO;
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.separatorColor=[UIColor clearColor];
    [self getdata];
    // Do any additional setup after loading the view.
}
#pragma mark 获取数据
-(void)getdata{
    NSDictionary *dic=@{@"smid":[NSString stringWithFormat:@"%d",self.smid]};
    __weak __typeof(self)weakSelf = self;
    [[LYHomePageHttpTool shareInstance]getWoYaoDinWeiTaoCanDetailWithParams:dic block:^(TaoCanModel *result) {
        taoCanModel=result;
        [weakSelf.tableView reloadData];
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==2){
        if(taoCanModel.goodsList){
            return taoCanModel.goodsList.count;
        }else{
            return 0;
        }
        
    }else{
        return 1;
    }
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(taoCanModel){
        return 6;
    }else{
        return 0;
    }
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section==2 || section==4 || section==5){
        return 34;
    }else{
        return 1;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section==0  || section==1 || section==3){
        return [[UIView alloc] initWithFrame:CGRectZero];
    }else{
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 34)];
        view.backgroundColor=RGB(247, 247, 247);
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(15, 11, 200, 12)];
        if(section==2){
            label.text=@"套餐内容";
        }else if (section==4){
            label.text=@"套餐说明";
        }else{
            label.text=@"套餐消费流程";
        }
        
        label.font=[UIFont systemFontOfSize:12];
        label.textColor=RGB(51, 51, 51);
        [view addSubview:label];
        return view;
    }
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    switch (indexPath.section)
    {
        case 0:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"LYTaoCanXQCell" forIndexPath:indexPath];
            if (cell) {
                LYTaoCanXQCell * adCell = (LYTaoCanXQCell *)cell;
                [adCell configureCell:taoCanModel];
                
                
            }
        }
            break;
        case 1:
        {
            
            
            cell = [tableView dequeueReusableCellWithIdentifier:@"LYTitleInfoCell" forIndexPath:indexPath];
            if (cell) {
                LYTitleInfoCell * titleInfoCell = (LYTitleInfoCell *)cell;
                titleInfoCell.titleLal.text=@"套餐时间";
                titleInfoCell.delLal.text=_dateStr;
                
            }
        }
            break;
        case 2:
        {
            NSArray *taocanArr=taoCanModel.goodsList;
            
            cell = [tableView dequeueReusableCellWithIdentifier:@"PTTaoCanCell" forIndexPath:indexPath];
            if (cell) {
                PTTaoCanCell * taocanCell = (PTTaoCanCell *)cell;
                [taocanCell configureCell:taocanArr[indexPath.row]];
                
                
            }
            UILabel *lineLal=[[UILabel alloc]initWithFrame:CGRectMake(15, 43.5, 290, 0.5)];
            lineLal.backgroundColor=RGB(199, 199, 199);
            [cell addSubview:lineLal];
        }
            break;
        case 3:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"LYTitleInfoCell" forIndexPath:indexPath];
            if (cell) {
                LYTitleInfoCell * titleInfoCell = (LYTitleInfoCell *)cell;
                titleInfoCell.titleLal.text=@"服务类型";
                titleInfoCell.delLal.text=@"1对1专属服务";
                
            }
        }
            break;
        case 4:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"shoumingCell" forIndexPath:indexPath];
            
        }
            break;
        default:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"PTShowIntroductionsCell" forIndexPath:indexPath];
        }
            break;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat h = 0.0f;
    switch (indexPath.section) {
        case 0://广告
        {
            h = 256;
        }
            break;
        case 1:// 选项卡 ，酒吧或夜总会
        {
            h = 44;
        }
            break;
        case 2:// 选项卡 ，酒吧或夜总会
        {
            h = 44;
        }
            break;
        case 3:// 选项卡 ，酒吧或夜总会
        {
            h = 44;
        }
            break;
        case 4:// 选项卡 ，酒吧或夜总会
        {
            h = 71;
        }
            break;
        default:
        {
            h = 162;
        }
            break;
    }
    return h;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //        BeerBarDetailViewController * controller = [[BeerBarDetailViewController alloc] initWithNibName:@"BeerBarDetailViewController" bundle:nil];
    //        [self.navigationController pushViewController:controller animated:YES];
    
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
#pragma mark - 咨询


- (IBAction)queryAct:(UIButton *)sender {
    
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",@"02136512128"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        
    
}

#pragma mark - 注意事项
- (IBAction)warnAct:(UIButton *)sender {
    [MyUtil showMessage:@"1. 关于退款：若专属经理未确认留位前退款，则我们将全额退款；若专属经理确认给予您留位后退款，则退款需收20%卡座占用费（100元封顶）。由于占用卡位时间会对酒吧造成经济损失，所以敬请谅解！\n2.若有任何疑问？投诉和建议，欢迎拨打客户热线；\n3.商品图片为参考，具体以实物为准；\n4.客户热线：021-36512128"];
}
#pragma mark - 马上购买
- (IBAction)payAct:(UIButton *)sender {
    UIStoryboard *stroyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DWSureOrderViewController *sureOrderViewController=[stroyBoard instantiateViewControllerWithIdentifier:@"DWSureOrderViewController"];
    sureOrderViewController.title=@"确认订单";
    sureOrderViewController.smid=taoCanModel.smid;
    sureOrderViewController.dateStr=self.dateStr;
    [self.navigationController pushViewController:sureOrderViewController animated:YES];
}
@end
