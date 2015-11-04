//
//  DWSureOrderViewController.m
//  lieyu
//
//  Created by 薛斯岐 on 15/10/21.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "DWSureOrderViewController.h"
#import "LYHomePageHttpTool.h"
#import "DWOrderTopCell.h"
#import "DWnumCell.h"
#import "DWOredrNextCell.h"
#import "LYTitleInfoCell.h"
#import "PTzsjlCell.h"
#import "PTContactCell.h"
#import "ZSDetailModel.h"
#import <RongIMKit/RongIMKit.h>
#import "LYtimeChooseTimeController.h"
#import "DWIsGoToViewController.h"
#import "ChoosePayController.h"
@interface DWSureOrderViewController ()<DateChooseDelegate,DateChoosegoTypeDelegate>
{
    TaoCanModel *taoCanModel;
    DWOredrNextCell *timeCell;
    DWOredrNextCell *typeCell;
    DWnumCell *numCell;
    NSArray *zsArr;
    NSString *reachtime;
    NSString *gotype;
}
@end

@implementation DWSureOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.showsHorizontalScrollIndicator=NO;
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.separatorColor=[UIColor clearColor];
    [self getdata];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(numChange) name:@"numChange" object:nil];
    // Do any additional setup after loading the view.
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"numChange" object:nil];
    
    
    
}
-(void)numChange{
    int num = numCell.numLal.text.intValue;
    
    [_payBtn setTitle:[NSString stringWithFormat:@"马上支付（￥%.2f）",taoCanModel.price*num] forState:0];
}
#pragma mark 获取数据
-(void)getdata{
    NSDictionary *dic=@{@"smid":[NSString stringWithFormat:@"%d",self.smid]};
    __weak __typeof(self)weakSelf = self;
    [[LYHomePageHttpTool shareInstance]getWoYaoDinWeiOrderWithParams:dic block:^(TaoCanModel *result) {
        taoCanModel=result;
        zsArr=taoCanModel.managerList;
        [_payBtn setTitle:[NSString stringWithFormat:@"马上支付（￥%.2f）",taoCanModel.price] forState:0];
        [weakSelf.tableView reloadData];
        
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==1){
        return 6;
        
    }else if(section==2){
        return zsArr.count;
    }
    else{
        return 1;
    }
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(taoCanModel){
        return 4;
    }else{
        return 0;
    }
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section==2){
        return 34;
    }else{
        return 1;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section!=2){
        return [[UIView alloc] initWithFrame:CGRectZero];
    }else{
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 34)];
        view.backgroundColor=RGB(247, 247, 247);
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(15, 11, 200, 12)];
        
        label.text=@"选择我的专属经理";
       
        
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
            cell = [tableView dequeueReusableCellWithIdentifier:@"DWOrderTopCell" forIndexPath:indexPath];
            if (cell) {
                DWOrderTopCell * adCell = (DWOrderTopCell *)cell;
                [adCell configureCell:taoCanModel];
                
                
            }
        }
            break;
        case 1:
        {
            
            if(indexPath.row==0){
                cell = [tableView dequeueReusableCellWithIdentifier:@"LYTitleInfoCell" forIndexPath:indexPath];
                if (cell) {
                    LYTitleInfoCell * titleInfoCell = (LYTitleInfoCell *)cell;
                    titleInfoCell.titleLal.text=@"消费地址";
                    titleInfoCell.delLal.text=taoCanModel.barinfo.barname;
                    
                }
                UILabel *lineLal=[[UILabel alloc]initWithFrame:CGRectMake(15, 43.5, 290, 0.5)];
                lineLal.backgroundColor=RGB(199, 199, 199);
                [cell addSubview:lineLal];
            }
            if(indexPath.row==1){
                cell = [tableView dequeueReusableCellWithIdentifier:@"LYTitleInfoCell" forIndexPath:indexPath];
                if (cell) {
                    LYTitleInfoCell * titleInfoCell = (LYTitleInfoCell *)cell;
                    titleInfoCell.titleLal.text=@"具体地址";
                    titleInfoCell.delLal.text=taoCanModel.barinfo.address;
                    
                }
                UILabel *lineLal=[[UILabel alloc]initWithFrame:CGRectMake(15, 43.5, 290, 0.5)];
                lineLal.backgroundColor=RGB(199, 199, 199);
                [cell addSubview:lineLal];
            }
            if(indexPath.row==2){
                cell = [tableView dequeueReusableCellWithIdentifier:@"LYTitleInfoCell" forIndexPath:indexPath];
                if (cell) {
                    LYTitleInfoCell * titleInfoCell = (LYTitleInfoCell *)cell;
                    titleInfoCell.titleLal.text=@"消费日期";
                    titleInfoCell.delLal.text=self.dateStr;
                    
                }
                UILabel *lineLal=[[UILabel alloc]initWithFrame:CGRectMake(15, 43.5, 290, 0.5)];
                lineLal.backgroundColor=RGB(199, 199, 199);
                [cell addSubview:lineLal];
            }
            if(indexPath.row==3){
                cell = [tableView dequeueReusableCellWithIdentifier:@"DWOredrNextCell" forIndexPath:indexPath];
                if (cell) {
                    timeCell = (DWOredrNextCell *)cell;
                    timeCell.titleLal.text=@"选择到店时间";
                    timeCell.delLal.text=@"到店时间";
                    [timeCell.delLal setTextColor:[UIColor redColor]];
                    
                }
                UILabel *lineLal=[[UILabel alloc]initWithFrame:CGRectMake(15, 43.5, 290, 0.5)];
                lineLal.backgroundColor=RGB(199, 199, 199);
                [cell addSubview:lineLal];
            }
            if(indexPath.row==4){
                cell = [tableView dequeueReusableCellWithIdentifier:@"DWOredrNextCell" forIndexPath:indexPath];
                if (cell) {
                    typeCell = (DWOredrNextCell *)cell;
                    typeCell.titleLal.text=@"消费状态";
                    typeCell.delLal.text=@"选择正确消费状态";
                    [typeCell.delLal setTextColor:[UIColor redColor]];
                }
                UILabel *lineLal=[[UILabel alloc]initWithFrame:CGRectMake(15, 43.5, 290, 0.5)];
                lineLal.backgroundColor=RGB(199, 199, 199);
                [cell addSubview:lineLal];
            }
            if(indexPath.row==5){
                cell = [tableView dequeueReusableCellWithIdentifier:@"DWnumCell" forIndexPath:indexPath];
                if (cell) {
                    numCell = (DWnumCell *)cell;
                    
                }
            }
        }
            break;
        case 2:
        {
            ZSDetailModel *zsModel=zsArr[indexPath.row];
            cell = [tableView dequeueReusableCellWithIdentifier:@"PTzsjlCell" forIndexPath:indexPath];
            if (cell) {
                PTzsjlCell * adCell = (PTzsjlCell *)cell;
                [adCell configureCell:zsModel];
                adCell.selBtn.tag=indexPath.row;
                [adCell.selBtn addTarget:self action:@selector(chooseZS:) forControlEvents:UIControlEventTouchUpInside];
                UILabel *lineLal=[[UILabel alloc]initWithFrame:CGRectMake(15, 75.5, 290, 0.5)];
                lineLal.backgroundColor=RGB(199, 199, 199);
                [cell addSubview:lineLal];
            }

        }
            break;
        
        default:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"PTContactCell" forIndexPath:indexPath];
            PTContactCell *contactCell = (PTContactCell *)cell;
            [contactCell.siliaoBtn addTarget:self action:@selector(siliaoAct:) forControlEvents:UIControlEventTouchUpInside];
            [contactCell.phoneBtn addTarget:self action:@selector(dianhuaAct:) forControlEvents:UIControlEventTouchUpInside];
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
        case 0:
        {
            h = 88;
        }
            break;
        case 1:
        {
            if(indexPath.row==5){
                h = 59;
            }else{
                h=44;
            }
        }
            break;
        case 2:
        {
            h = 76;
        }
            break;
        default:
        {
            h = 44;
        }
            break;
    }
    return h;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==1){
        if(indexPath.row==3){
            LYtimeChooseTimeController *timeChooseTimeController=[[LYtimeChooseTimeController alloc]initWithNibName:@"LYtimeChooseTimeController" bundle:nil];
            timeChooseTimeController.title=@"时间选择";
            timeChooseTimeController.type=1;
            timeChooseTimeController.delegate=self;
            [self.navigationController pushViewController:timeChooseTimeController animated:YES];
        }
        if (indexPath.row==4) {
            DWIsGoToViewController *isGoToViewController=[[DWIsGoToViewController alloc]initWithNibName:@"DWIsGoToViewController" bundle:nil];
            isGoToViewController.title=@"是否会去";
            isGoToViewController.delegate=self;
            [self.navigationController pushViewController:isGoToViewController animated:YES];
        }
    }
    //        BeerBarDetailViewController * controller = [[BeerBarDetailViewController alloc] initWithNibName:@"BeerBarDetailViewController" bundle:nil];
    //        [self.navigationController pushViewController:controller animated:YES];
    
}
#pragma mark 选择专属经理
-(void)chooseZS:(UIButton *)sender{
    ZSDetailModel *zsModel=zsArr[sender.tag];
    if([zsModel.isFull isEqualToString:@"1"]){
        [self showMessage:@"该经理的卡座已满,请选择其他专属经理!"];
        return;
    }
    zsModel.issel=true;
    for (int i=0; i<zsArr.count; i++) {
        ZSDetailModel *zsModelTemp=zsArr[i];
        if(i!=sender.tag){
            zsModelTemp.issel=false;
        }
    }
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:2];
    [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
}
#pragma mark 私聊
-(void)siliaoAct:(UIButton *)sender{
    for (ZSDetailModel *zsDetailModel in zsArr) {
        if(zsDetailModel.issel){
            RCConversationViewController *conversationVC = [[RCConversationViewController alloc]init];
            conversationVC.conversationType =ConversationType_PRIVATE; //会话类型，这里设置为 PRIVATE 即发起单聊会话。
            conversationVC.targetId = zsDetailModel.imUserId; // 接收者的 targetId，这里为举例。
            conversationVC.userName =zsDetailModel.username; // 接受者的 username，这里为举例。
            conversationVC.title =zsDetailModel.username; // 会话的 title。
            
            // 把单聊视图控制器添加到导航栈。
            [self.navigationController pushViewController:conversationVC animated:YES];
        }
    }
    
    
    
}
#pragma mark 电话
-(void)dianhuaAct:(UIButton *)sender{
    for (ZSDetailModel *zsDetailModel in zsArr) {
        if(zsDetailModel.issel){
            if( [MyUtil isPureInt:zsDetailModel.mobile]){
                NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",zsDetailModel.mobile];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
                
            }
        }
    }
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
-(void)changeDate:(NSString *)timeStr{
    reachtime=timeStr;
    timeCell.delLal.text=reachtime;
}
-(void)changeType:(NSString *)str{
    gotype=str;
    if([gotype isEqualToString:@"0"]){
        typeCell.delLal.text=@"不一定会去";
    }else{
        typeCell.delLal.text=@"一定会去";
    }
}
- (IBAction)payAct:(UIButton *)sender {
    if(taoCanModel){
        
        if(!reachtime){
            [self showMessage:@"请选择时间!"];
            return;
        }
        if(!gotype){
            
            [self showMessage:@"请选择消费状态!"];
            return;
        }
       
        bool issel = false;
        int userId=0;
        for (ZSDetailModel *detaiModel in zsArr) {
            if(detaiModel.issel){
                userId=detaiModel.userid;
                issel=true;
                break;
            }
        }
        if(!issel){
            [self showMessage:@"请选择专属经理!"];
            return;
        }
        
        NSDictionary *dic=@{@"smid":[NSNumber numberWithInt:taoCanModel.smid],@"reachtime":reachtime,@"checkuserid":[NSNumber numberWithInt:userId],@"allnum":numCell.numLal.text,@"consumptionStatus":gotype};
        [[LYHomePageHttpTool shareInstance]setWoYaoDinWeiOrderInWithParams:dic complete:^(NSString *result) {
            if(result){
//                [MyUtil showMessage:result];
                //支付宝页面"data": "P130637201510181610220",
                //result的值就是P130637201510181610220
                ChoosePayController *detailViewController =[[ChoosePayController alloc] init];
                detailViewController.orderNo=result;
                int num = numCell.numLal.text.intValue;
                detailViewController.payAmount=taoCanModel.price*num;
                detailViewController.productName=taoCanModel.title;
                detailViewController.productDescription=@"暂无";
                self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
                
                [self.navigationController pushViewController:detailViewController animated:YES];
            }
        }];
        
    }
}
@end
