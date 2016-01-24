
//
//  LPBuyViewController.m
//  lieyu
//
//  Created by 王婷婷 on 15/12/2.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LPBuyViewController.h"

#import "LPBuyTaocanCell.h"
#import "LPBuyPriceCell.h"
#import "LPBuyInfoCell.h"
#import "ContentTableViewCell.h"

#import "LYHomePageHttpTool.h"
#import "ChoosePayController.h"
#import "CommonShow.h"
#import "PayMoney.h"
#import "LPAlertView.h"
#import "ZSDetailModel.h"

//2.7.3 【0002】task=lyUsersVipStoreAction?action=list (已可用) 请求所有的专属经理列表
//2.7.4 【R0002】反馈所有专属经理列表
//2.7.7 【0004】task=lyUsersVipStoreAction?action=list (已可用) 请求用户收藏的专属经理列表
//2.7.8 【R0004】反馈用户收藏的专属经理列表

@interface LPBuyViewController ()<UITableViewDataSource,UITableViewDelegate,LPAlertViewDelegate>
{
    BOOL notFirstLayout;
}
@property (nonatomic, strong) NSArray *managerList;

@property (nonatomic, strong) LPBuyTaocanCell *buyTaocanCell;
@property (nonatomic, strong) LPBuyPriceCell *buyPriceCell;
@property (nonatomic, strong) LPBuyInfoCell *buyInfoCell;
@property (nonatomic, strong) ContentTableViewCell *contentCell;
@property (nonatomic, strong) LPBuyManagerCell *managerCell;


@property (nonatomic, strong) PayMoney *payContent;
@end

@implementation LPBuyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.bounces = NO;
    
    self.title = @"确认拼客订单";
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"return"] style:UIBarButtonItemStylePlain target:self action:@selector(backClick)];
    self.navigationItem.leftBarButtonItem = backBtn;
    [self getAllManagers];
    self.tableView.backgroundColor = [UIColor clearColor];
//    self.tableView.backgroundColor = RGBA(237, 237, 237, 1);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    /*
     进行能否购买的判断
     */
//    if(self.pinkeModel.managerList.count == 0){
//        self.buyNowBtn.enabled = NO;
//        [self.buyNowBtn setBackgroundColor:[UIColor grayColor]];
//    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

//- (void)getUserManagers{
//    NSDictionary *dic = @{@"":@""};
//    __weak __typeof(self)weakSelf = self;
//    [[LYHomePageHttpTool shareInstance]getBarVipWithParams:dic block:^(NSMutableArray *result) {
//        
//    }];
//}
#pragma mark 获取数据
- (void)getAllManagers{
    NSDictionary *dic=@{@"smid":[NSNumber numberWithInt:self.smid]};
    __weak __typeof(self)weakSelf = self;
    [[LYHomePageHttpTool shareInstance]getTogetherOrderWithParams:dic block:^(PinKeModel *result) {
        _pinkeModel = result;
        _managerList = _pinkeModel.managerList;
        [weakSelf.tableView reloadData];
    }];
}

- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark tableview的各个代理事件
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 4){
        return 48;
    }else{
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 4){
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
        [button addTarget:self action:@selector(selectedVIPManager) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        
        return view;
    }
    return nil;
}

- (void)selectedVIPManager{
    NSLog(@"1");
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 10;
            break;
        case 1:
            return 10;
            break;
        case 2:
            return 10;
            break;
        case 3:
            return 0;
            break;
        case 4:
            return 0;
            break;
        default:
            return 0;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        return 86;
    }else if(indexPath.section == 1){
        return 40;
    }else if(indexPath.section == 2){
        return 187;
    }else if(indexPath.section == 3){
        return 66 + 44 * (int)self.pinkeModel.goodsList.count;
    }else{
        if(self.managerList.count == 0){
            return 56;
        }else{
            return 87 * self.managerList.count + 16;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        _buyTaocanCell = [tableView dequeueReusableCellWithIdentifier:@"buyTaocan"];
        if(!_buyTaocanCell){
            [tableView registerNib:[UINib nibWithNibName:@"LPBuyTaocanCell" bundle:nil] forCellReuseIdentifier:@"buyTaocan"];
            _buyTaocanCell = [tableView dequeueReusableCellWithIdentifier:@"buyTaocan"];
        }
        if(self.pinkeModel){
            [_buyTaocanCell cellConfigureWithImage:self.pinkeModel.linkUrl name:self.pinkeModel.title way:self.InfoDict[@"way"] price:self.pinkeModel.price marketPrice:self.pinkeModel.marketprice];
        }
        return _buyTaocanCell;
    }else if(indexPath.section == 1){
        _buyPriceCell = [tableView dequeueReusableCellWithIdentifier:@"buyPrice"];
        if(!_buyPriceCell){
            [tableView registerNib:[UINib nibWithNibName:@"LPBuyPriceCell" bundle:nil] forCellReuseIdentifier:@"buyPrice"];
            _buyPriceCell = [tableView dequeueReusableCellWithIdentifier:@"buyPrice"];
        }
        if(self.pinkeModel){
            [_buyPriceCell.payBtn addTarget:self action:@selector(payMoney) forControlEvents:UIControlEventTouchUpInside];
            float profit = [self.pinkeModel.price floatValue] * [self.pinkeModel.rebate floatValue];
            [_buyPriceCell cellConfigureWithPay:self.InfoDict[@"money"] andProfit:profit];
        }
        return _buyPriceCell;
    }else if(indexPath.section == 2){
        _buyInfoCell = [tableView dequeueReusableCellWithIdentifier:@"buyInfo"];
        if(!_buyInfoCell){
            [tableView registerNib:[UINib nibWithNibName:@"LPBuyInfoCell" bundle:nil] forCellReuseIdentifier:@"buyInfo"];
            _buyInfoCell = [tableView dequeueReusableCellWithIdentifier:@"buyInfo"];
        }
        if(self.pinkeModel){
            [_buyInfoCell cellConfigureWithName:self.pinkeModel.barinfo.barname Address:self.pinkeModel.barinfo.address Time:self.InfoDict[@"time"] Number:self.InfoDict[@"number"]];
        }
        return _buyInfoCell;
    }else if(indexPath.section == 3){
        _contentCell = [tableView dequeueReusableCellWithIdentifier:@"content"];
        if (!_contentCell) {
            [tableView registerNib:[UINib nibWithNibName:@"ContentTableViewCell" bundle:nil] forCellReuseIdentifier:@"content"];
            _contentCell = [tableView dequeueReusableCellWithIdentifier:@"content"];
        }
        if(self.pinkeModel){
            _contentCell.goodList = self.pinkeModel.goodsList;
            [_contentCell cellConfigure];
        }
        return _contentCell;
    }else{
        if(self.pinkeModel.managerList.count){
            _managerCell = [tableView dequeueReusableCellWithIdentifier:@"buyManager"];
            if(!_managerCell){
                [tableView registerNib:[UINib nibWithNibName:@"LPBuyManagerCell" bundle:nil] forCellReuseIdentifier:@"buyManager"];
                _managerCell = [tableView dequeueReusableCellWithIdentifier:@"buyManager"];
            }
            _managerCell.managerList = self.managerList;
            _managerCell.delegate = self;
            [_managerCell cellConfigure];
            return _managerCell;
        }else{
            UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.textLabel.textColor = RGBA(76, 76, 76, 1);
            cell.textLabel.text = @"抱歉，该套餐还没有专属经理，无法购买!";
            return cell;
        }
    }
}

#pragma mark delegate处理事件
- (void)selectManager:(int)index{
    ZSDetailModel *zsDetail = _managerList[index];
    
    if([zsDetail.isFull isEqualToString:@"1"]){
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"该经理的卡座已满,请选择其他专属经理!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil]show];
        return;
    }
    zsDetail.issel = true;
    for (int i = 0 ; i < _managerList.count; i ++) {
        ZSDetailModel *zsModelTemp = _managerList[i];
        if(i != index){
            zsModelTemp.issel = false;
        }
    }
}

#pragma mark 付钱按钮，选择预付金额
- (void)payMoney{
    LPAlertView *alertView = [[LPAlertView alloc]initWithDelegate:self buttonTitles:@"确定",@"取消", nil];
    alertView.delegate = self;
    _payContent = [[[NSBundle mainBundle]loadNibNamed:@"PayMoney" owner:nil options:nil]firstObject];
    _payContent.tag = 13;
    _payContent.textField.keyboardType = UIKeyboardTypeNumberPad;
    alertView.contentView = _payContent;
    _payContent.frame = CGRectMake(10, SCREEN_HEIGHT - 270 , SCREEN_WIDTH - 20, 200);
    [alertView show];
}
#pragma mark 填完金额后的代理事件
- (void)LPAlertView:(LPAlertView *)alertView clickedButtonAtIndexPayMoney:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        if([((PayMoney *)alertView.contentView).textField.text intValue] < 100){
            ((PayMoney *)alertView.contentView).warningLabel.textColor = [UIColor redColor];
            ((PayMoney *)alertView.contentView).warningLabel.text = @"发起人预支付金额不可少于100元";
            ((PayMoney *)alertView.contentView).textField.text = @"";
        }else if ([((PayMoney *)alertView.contentView).textField.text intValue] > [_pinkeModel.price intValue]){
            ((PayMoney *)alertView.contentView).warningLabel.textColor = [UIColor redColor];
            ((PayMoney *)alertView.contentView).warningLabel.text = @"预支付金额不可超过套餐金额";
            ((PayMoney *)alertView.contentView).textField.text = @"";
        }else{
            [alertView hide];
            [self.InfoDict setValue:((PayMoney *)alertView.contentView).textField.text forKey:@"money"];
            self.buyPriceCell.LPMoney.text = [NSString stringWithFormat:@"¥%@",self.InfoDict[@"money"]];
        }
    }else{
        [alertView hide];
    }
}

//#pragma 填写支付金额
//- (void)payMoney{
//    UIAlertView *customAlert = [[UIAlertView alloc]initWithTitle:@"请填写您要支付的金额" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//        [customAlert setTintColor:RGBA(114, 5, 147, 1)];
//        [customAlert setAlertViewStyle:UIAlertViewStylePlainTextInput];
//        UITextField *payField = [customAlert textFieldAtIndex:0];
//        payField.keyboardType = UIKeyboardTypeNumberPad;
//        payField.placeholder = @"金额请不少于100元";
//        [customAlert show];
//}
//
//#pragma 填写支付金额
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    if (buttonIndex == alertView.firstOtherButtonIndex) {
//        if ([[alertView textFieldAtIndex:0].text intValue] < 100) {
//            [CommonShow showMessage:@"对不起，发起人预付金额不可少于100元!"];
//            
//        }else{
////            self.defaultPay = [[alertView textFieldAtIndex:0].text intValue];
//            [self.InfoDict setObject:[alertView textFieldAtIndex:0].text forKey:@"money"];
//        }
//    }
//}

- (void)imageClick{
    
}

- (void)nameClick{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 立即支付
- (IBAction)buyNowClick:(UIButton *)sender {
    if(self.pinkeModel){
        bool issel = false;
        int userId=0;
        for (ZSDetailModel *detaiModel in _managerList) {
            if(detaiModel.issel){
                
                //统计专属经理的选择
                NSDictionary *dict1 = @{@"actionName":@"选择",@"pageName":@"确认拼客订单",@"titleName":@"选择专属经理",@"value":detaiModel.username};
                [MTA trackCustomKeyValueEvent:@"LYClickEvent" props:dict1];
                
                userId=detaiModel.userid;
                issel=true;
                break;
            }
        }
        if(!issel){
            [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请选择专属经理!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil]show];
            return;
        }
        if([self.InfoDict[@"money"] isEqualToString:@"-1.00"]){
            [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请填写预付金额!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil]show];
            return;
        }
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *dateString = [formatter stringFromDate:self.InfoDict[@"time"]];
        
        
        NSDictionary *dic=@{
            @"pinkerid":[NSNumber numberWithInt:_pinkeModel.id],
            @"reachtime":dateString,
            @"checkuserid":[NSNumber numberWithInt:userId],
            @"allnum":self.InfoDict[@"number"],
            @"payamount":self.InfoDict[@"money"],
            @"pinkerType":self.InfoDict[@"type"],
            @"memo":@""};
        [[LYHomePageHttpTool shareInstance]setTogetherOrderInWithParams:dic complete:^(NSString *result) {
            if(result){
                //支付宝页面"data": "P130637201510181610220",
                //result的值就是P130637201510181610220
                NSLog(@"result-------%@",result);
                ChoosePayController *detailViewController =[[ChoosePayController alloc] init];
                detailViewController.orderNo=result;
                detailViewController.payAmount=[self.InfoDict[@"money"] doubleValue];
                detailViewController.productName=self.pinkeModel.title;
                detailViewController.productDescription=@"暂无";
                UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"return"] style:UIBarButtonItemStylePlain target:self action:nil];
                self.navigationItem.backBarButtonItem = left;
                [self.navigationController pushViewController:detailViewController animated:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"loadUserInfo" object:nil];

            }
        }];
    }
}
@end
