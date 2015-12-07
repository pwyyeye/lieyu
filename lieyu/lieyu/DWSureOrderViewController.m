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
#import "LYZSdetailCell.h"

#import "LYDinWeiTableViewCell.h"
#import "LYOrderWriteTableViewCell.h"
#import "LYOrderInfoTableViewCell.h"
#import "LYOrderManagerTableViewCell.h"
#import "TimePickerView.h"
#import "LPAlertView.h"
#import "ContentViewTaocan.h"
#import "ManagerInfoCell.h"

@interface DWSureOrderViewController ()<DateChooseDelegate,DateChoosegoTypeDelegate,LPAlertViewDelegate>
{
    TaoCanModel *taoCanModel;
    DWOredrNextCell *timeCell;
    DWOredrNextCell *typeCell;
    DWnumCell *numCell;
    NSArray *zsArr;
    NSString *reachtime;
    NSString *gotype;
    TimePickerView *_timeView;
    LYOrderWriteTableViewCell *_writeCell;
    ContentViewTaocan *view_taocan;
    NSInteger count;
}
@end

@implementation DWSureOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self deployCell];
    count = 1;
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView.showsHorizontalScrollIndicator=NO;
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.separatorColor=[UIColor clearColor];
    [self getdata];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(numChange) name:@"numChange" object:nil];
    // Do any additional setup after loading the view.
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.navigationController.navigationBarHidden = NO;
}

- (void)deployCell{
    [self.tableView registerNib:[UINib nibWithNibName:@"LYDinWeiTableViewCell" bundle:nil] forCellReuseIdentifier:@"LYDinWeiTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"LYOrderWriteTableViewCell" bundle:nil] forCellReuseIdentifier:@"LYOrderWriteTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"LYOrderInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"LYOrderInfoTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"LYOrderManagerTableViewCell" bundle:nil] forCellReuseIdentifier:@"LYOrderManagerTableViewCell"];
     [self.tableView registerNib:[UINib nibWithNibName:@"LPBuyManagerCell" bundle:nil] forCellReuseIdentifier:@"buyManager"];
    [self.tableView registerNib:[UINib nibWithNibName:@"LYZSdetailCell" bundle:nil] forCellReuseIdentifier:@"LYZSdetailCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ManagerInfoCell" bundle:nil] forCellReuseIdentifier:@"managerInfo"];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"numChange" object:nil];
}
-(void)numChange{
    int num = _writeCell.label_count.text.intValue;
    
    [_payBtn setTitle:[NSString stringWithFormat:@"马上支付（￥%.2f）",taoCanModel.price*num] forState:0];
}
#pragma mark 获取数据
-(void)getdata{
    NSDictionary *dic=@{@"smid":[NSString stringWithFormat:@"%d",self.smid],@"smdate":_dateStr};
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
    return 1;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return zsArr.count + 3;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 3) {
        return 48;
    }
    return 8;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section == 3){
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 48)];
        view.backgroundColor = RGBA(246, 246, 246, 1);
        
        UIImageView *iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 30, 30)];
        iconImage.image = [UIImage imageNamed:@"LPmanager"];
        [view addSubview:iconImage];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(50, 15, 200, 20)];
        label.text = @"选择我的VIP专属经理";
        label.textColor = RGBA(26, 26, 26, 1);
        label.font = [UIFont systemFontOfSize:16];
        [view addSubview:label];
        
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, 250, 30)];
        button.backgroundColor = [UIColor clearColor];
       // [button addTarget:self action:@selector(selectedManager) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        
        return view;
    }
    return nil;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    switch (indexPath.section)
    {
        case 0:
        {
            
            //            cell = [tableView dequeueReusableCellWithIdentifier:@"DWOrderTopCell" forIndexPath:indexPath];
            //            if (cell) {
            //               DWOrderTopCell * adCell = (DWOrderTopCell *)cell;
            //                [adCell configureCell:taoCanModel];
            //
            //
            //            }
            
            cell = [tableView dequeueReusableCellWithIdentifier:@"LYDinWeiTableViewCell" forIndexPath:indexPath];
            if (cell) {
                LYDinWeiTableViewCell *dinCell = (LYDinWeiTableViewCell *)cell;
                dinCell.taoCanModel = taoCanModel;
            }
            //            LYDinWeiTableViewCell *dinCell = [tableView dequeueReusableCellWithIdentifier:@"LYDinWeiTableViewCell" forIndexPath:indexPath];
            //            //dinCell.taoCanModel = taoCanModel;
            //            return dinCell;
        }
            break;
        case 1:
        {
            /*
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
             */
            cell = [tableView dequeueReusableCellWithIdentifier:@"LYOrderWriteTableViewCell" forIndexPath:indexPath];
            if (cell) {
                _writeCell = (LYOrderWriteTableViewCell *)cell;
                [_writeCell.btn_chooseTime addTarget:self action:@selector(choseTime) forControlEvents:UIControlEventTouchUpInside];
                [_writeCell.btn_isReserve addTarget:self action:@selector(isResrve) forControlEvents:UIControlEventTouchUpInside];
            }
        }
            break;
        case 2:
        {
            /*
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
             */
            cell = [tableView dequeueReusableCellWithIdentifier:@"LYOrderInfoTableViewCell" forIndexPath:indexPath];
            if (cell) {
                

                
                LYOrderInfoTableViewCell *infoCell = (LYOrderInfoTableViewCell *)cell;
                infoCell.taocanModel = taoCanModel;
                infoCell.label_order_date.text = self.dateStr;
            }
            
        }
            break;
            
        default:
        {
            //            cell = [tableView dequeueReusableCellWithIdentifier:@"PTContactCell" forIndexPath:indexPath];
            //            PTContactCell *contactCell = (PTContactCell *)cell;
            //            [contactCell.siliaoBtn addTarget:self action:@selector(siliaoAct:) forControlEvents:UIControlEventTouchUpInside];
            //            [contactCell.phoneBtn addTarget:self action:@selector(dianhuaAct:) forControlEvents:UIControlEventTouchUpInside];
            ZSDetailModel *zsModel=zsArr[indexPath.row];
            cell = [tableView dequeueReusableCellWithIdentifier:@"managerInfo" forIndexPath:indexPath];
            if (cell) {
                ManagerInfoCell *zsCell = (ManagerInfoCell *)cell;
                zsCell.selectBtn.enabled = NO;
                
                [zsCell cellConfigureWithImage:zsModel.avatar_img name:zsModel.username stars:zsModel.servicestar];
            }
            
        }
            break;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)choseTime{
    LPAlertView *alertView = [[LPAlertView alloc]initWithDelegate:self buttonTitles:@"确定", @"取消", nil];
    alertView.delegate = self;
    _timeView = [[[NSBundle mainBundle]loadNibNamed:@"TimePickerView" owner:nil options:nil]firstObject];
    _timeView.tag = 11;
    //    [_timeView showTimeWithDate:self.defaultDate];
    _timeView.timePicker.date = [NSDate date];
    alertView.contentView = _timeView;
    _timeView.frame = CGRectMake(10, SCREEN_HEIGHT - 270, SCREEN_WIDTH - 20, 200);
    [alertView show];
}

- (void)LPAlertView:(LPAlertView *)alertView clickedButtonAtIndexWhenTime:(NSInteger)buttonIndex{
    if (!buttonIndex) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"HH:mm"];
        NSString *dateString = [formatter stringFromDate:_timeView.timePicker.date];
        [_writeCell.btn_showTime setTitle:dateString forState:UIControlStateNormal];
        reachtime = dateString;
    }
}

- (void)isResrve{
    LPAlertView *alertView = [[LPAlertView alloc]initWithDelegate:self buttonTitles:@"确定", @"取消", nil];
    alertView.delegate = self;
    view_taocan = [[[NSBundle mainBundle] loadNibNamed:@"ContentViewTaocan" owner:nil options:nil] firstObject];
    view_taocan.tag = 12;
    alertView.contentView = view_taocan;
    _timeView.frame = CGRectMake(10, SCREEN_HEIGHT - 270, SCREEN_WIDTH - 20, 200);
    [alertView show];
}

- (void)LPAlertView:(LPAlertView *)alertView clickedButtonAtIndexWhenWay:(NSInteger)buttonIndex{
    NSString *remainStr = nil;
    if (((ContentViewTaocan *)alertView.contentView).image_remain.tag == 3) {
        //确定预留
        gotype = @"1";
        remainStr = @"确定预留";
    }else{
        //不确定预留
        gotype = @"0";
        remainStr = @"暂不预留";
    }
    [_writeCell.btn_showTaocan setTitle:remainStr forState:UIControlStateNormal];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat h = 0.0f;
    switch (indexPath.section) {
        case 0:
        {
            h = 70;
        }
            break;
        case 1:
        {
            h = 188;
        }
            break;
        case 2:
        {
            h = 188;
        }
            break;
        default:
        {
            h = 87;
        }
            break;
    }
    return h;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if(indexPath.section==1){
//        if(indexPath.row==3){
//            LYtimeChooseTimeController *timeChooseTimeController=[[LYtimeChooseTimeController alloc]initWithNibName:@"LYtimeChooseTimeController" bundle:nil];
//            timeChooseTimeController.title=@"时间选择";
//            NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
//            [formatter setDateFormat:@"yyyy-MM-dd"];
//            NSDate *dateTemp=[formatter dateFromString:_dateStr];
//            timeChooseTimeController.nowDate=dateTemp;
//            timeChooseTimeController.type=1;
//            timeChooseTimeController.delegate=self;
//            [self.navigationController pushViewController:timeChooseTimeController animated:YES];
//        }
//        if (indexPath.row==4) {
//            DWIsGoToViewController *isGoToViewController=[[DWIsGoToViewController alloc]initWithNibName:@"DWIsGoToViewController" bundle:nil];
//            isGoToViewController.title=@"是否会去";
//            isGoToViewController.delegate=self;
//            [self.navigationController pushViewController:isGoToViewController animated:YES];
//        }
//    }
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
            [self.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil  action:nil]];
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
                int num = _writeCell.label_count.text.intValue;
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
