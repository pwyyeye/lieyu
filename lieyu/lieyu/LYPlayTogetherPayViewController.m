//
//  LYPlayTogetherPayViewController.m
//  lieyu
//
//  Created by 薛斯岐 on 15/10/17.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYPlayTogetherPayViewController.h"
#import "LYHomePageHttpTool.h"
#import "PinKeModel.h"
#import "PTTaoCanDetailCell.h"
#import "PTTypeChooseCell.h"
#import "PTChooseNumCell.h"
#import "PTPayAmoutCell.h"
#import "PTTimeChooseCell.h"
#import "PTAddressCell.h"
#import "PTzsjlCell.h"
#import "ZSDetailModel.h"
#import "PTContactCell.h"
#import "LYtimeChooseTimeController.h"
#import <RongIMKit/RongIMKit.h>
@interface LYPlayTogetherPayViewController ()<DateChooseDelegate>
{
    PinKeModel *pinKeModel;
    PTTypeChooseCell *typeChooseCell;
    PTChooseNumCell *numCell;
    PTPayAmoutCell *payAmoutCell;
    PTTimeChooseCell *timeChooseCell;
    PTAddressCell *addressCell;
    NSArray *zsArr;
    NSString *reachtime;
}
@end

@implementation LYPlayTogetherPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    zsArr=[[NSArray alloc]init];
    _tableView.showsHorizontalScrollIndicator=NO;
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.separatorColor=[UIColor clearColor];
    //获取详细
    [self getdata];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(typeChange) name:@"typeChange" object:nil];
    // Do any additional setup after loading the view.
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"typeChange" object:nil];
   
    
    
}
-(void)typeChange{
    
    if([typeChooseCell.pinkertype isEqualToString:@"0"]){
        payAmoutCell.payAmountTex.enabled=false;
        payAmoutCell.payAmountTex.text=pinKeModel.price;
    }else if ([typeChooseCell.pinkertype isEqualToString:@"1"]){
        payAmoutCell.payAmountTex.enabled=false;
        payAmoutCell.payAmountTex.text=[NSString stringWithFormat:@"%.2f",pinKeModel.price.doubleValue/numCell.numLal.text.doubleValue];
        
    }else{
        payAmoutCell.payAmountTex.enabled=YES;
        payAmoutCell.payAmountTex.text=@"";
        payAmoutCell.payAmountTex.placeholder=@"支付的金额不低于100元";
    }
}
-(void)getdata{
    NSDictionary *dic=@{@"smid":[NSNumber numberWithInt:self.smid]};
    __weak __typeof(self)weakSelf = self;
    [[LYHomePageHttpTool shareInstance]getTogetherOrderWithParams:dic block:^(PinKeModel *result) {
        pinKeModel = result;
        zsArr=pinKeModel.managerList;
        [weakSelf.tableView reloadData];
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==6){
        return zsArr.count;
        
    }else{
        return 1;
    }
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(pinKeModel){
        return 8;
    }else{
        return 0;
    }
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section==0 || section==1  || section==4 || section==5 || section==7){
        return 1;
    }else{
        return 34;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section==0 || section==1  || section==4 || section==5 || section==7){
        return [[UIView alloc] initWithFrame:CGRectZero];
        
    }else{
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 34)];
        view.backgroundColor=RGB(247, 247, 247);
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(15, 11, 200, 12)];
        if(section==2){
            label.text=@"拼客人数";
        }else if(section==3) {
            label.text=@"付款金额:";
        }else{
            label.text=@"请选择我的专属经理";
        }
        
        label.font=[UIFont systemFontOfSize:12];
        label.textColor=RGB(51, 51, 51);
        [view addSubview:label];
        return view;
    }
    
    
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//
//    return 134;
//}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//
//}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    switch (indexPath.section)
    {
        case 0:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"PTTaoCanDetailCell" forIndexPath:indexPath];
            if (cell) {
                PTTaoCanDetailCell * adCell = (PTTaoCanDetailCell *)cell;
                [adCell configureCell:pinKeModel];
                
                
            }
        }
            break;
        case 1:
        {
           
            
            cell = [tableView dequeueReusableCellWithIdentifier:@"PTTypeChooseCell" forIndexPath:indexPath];
            typeChooseCell = (PTTypeChooseCell *)cell;
        }
            break;
        case 2:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"PTChooseNumCell" forIndexPath:indexPath];
            numCell = (PTChooseNumCell *)cell;

        }
            break;
        case 3:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"PTPayAmoutCell" forIndexPath:indexPath];
            payAmoutCell = (PTPayAmoutCell *)cell;
            double fljg=pinKeModel.price.doubleValue * pinKeModel.rebate.doubleValue;
            [payAmoutCell.flBtn setTitle:[NSString stringWithFormat:@"返利￥%.2f",fljg] forState:0];
            
        }
            break;
        case 4:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"PTTimeChooseCell" forIndexPath:indexPath];
            timeChooseCell = (PTTimeChooseCell *)cell;
            
        }
            break;
        case 5:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"PTAddressCell" forIndexPath:indexPath];
            addressCell = (PTAddressCell *)cell;
            addressCell.addresssLal.text=pinKeModel.barinfo.address;
        }
            break;
        case 6:
        {
            ZSDetailModel *zsModel=zsArr[indexPath.row];
            cell = [tableView dequeueReusableCellWithIdentifier:@"PTzsjlCell" forIndexPath:indexPath];
            if (cell) {
                PTzsjlCell * adCell = (PTzsjlCell *)cell;
                [adCell configureCell:zsModel];
                adCell.selBtn.tag=indexPath.row;
                [adCell.selBtn addTarget:self action:@selector(chooseZS:) forControlEvents:UIControlEventTouchUpInside];
                
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.section==4){
        LYtimeChooseTimeController *timeChooseTimeController=[[LYtimeChooseTimeController alloc]initWithNibName:@"LYtimeChooseTimeController" bundle:nil];
        timeChooseTimeController.title=@"时间选择";
        timeChooseTimeController.delegate=self;
        [self.navigationController pushViewController:timeChooseTimeController animated:YES];
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat h = 0.0f;
    switch (indexPath.section) {
        case 0://头部
        {
            h = 84;
        }
            break;
        case 1:// 拼客方式
        {
            h = 76;
        }
            break;
        case 2:// 选择人数
        {
            h = 64;
        }
            break;
        case 3:// 支付金额
        {
            h = 56;
        }
            break;
        case 4:// 选择时间
        {
            h = 44;
        }
            break;
        case 5:// 地点
        {
            h = 44;
        }
            break;
        case 6:// 地点
        {
            h = 76;
        }
            break;
        default://专属经理
        {
            h = 44;
        }
            break;
    }
    return h;
}
#pragma mark 选择专属经理
-(void)chooseZS:(UIButton *)sender{
    ZSDetailModel *zsModel=zsArr[sender.tag];
    zsModel.issel=true;
    for (int i=0; i<zsArr.count; i++) {
        ZSDetailModel *zsModelTemp=zsArr[i];
        if(i!=sender.tag){
            zsModelTemp.issel=false;
        }
    }
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:6];
    [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
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
    timeChooseCell.timeChooselal.text=reachtime;
}
#pragma mark - 立即支付
- (IBAction)payAct:(UIButton *)sender {
    if(pinKeModel){
        if(!typeChooseCell.pinkertype){
            
            [self showMessage:@"请选择拼客方式!"];
            return;
        }
        if(payAmoutCell.payAmountTex.text.length<1){
            [self showMessage:@"请输入金额!"];
            return;
        }
        if(!reachtime){
            [self showMessage:@"请选择时间!"];
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
        }
        
        NSDictionary *dic=@{@"pinkerid":[NSNumber numberWithInt:pinKeModel.id],@"reachtime":reachtime,@"checkuserid":[NSNumber numberWithInt:userId],@"allnum":numCell.numLal.text,@"payamount":payAmoutCell.payAmountTex.text,@"pinkerType":typeChooseCell.pinkertype};
        [[LYHomePageHttpTool shareInstance]setTogetherOrderInWithParams:dic complete:^(NSString *result) {
            if(!result){
                //支付宝页面"data": "P130637201510181610220",
                //result的值就是P130637201510181610220
            }
        }];

    }
    
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
@end
