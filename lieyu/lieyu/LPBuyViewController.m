
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
#import "LPBuyManagerCell.h"

#import "LYHomePageHttpTool.h"
#import "ChoosePayController.h"

//2.7.3 【0002】task=lyUsersVipStoreAction?action=list (已可用) 请求所有的专属经理列表
//2.7.4 【R0002】反馈所有专属经理列表
//2.7.7 【0004】task=lyUsersVipStoreAction?action=list (已可用) 请求用户收藏的专属经理列表
//2.7.8 【R0004】反馈用户收藏的专属经理列表

@interface LPBuyViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) LPBuyTaocanCell *buyTaocanCell;
@property (nonatomic, strong) LPBuyPriceCell *buyPriceCell;
@property (nonatomic, strong) LPBuyInfoCell *buyInfoCell;
@property (nonatomic, strong) ContentTableViewCell *contentCell;
@property (nonatomic, strong) LPBuyManagerCell *managerCell;
@end

@implementation LPBuyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.showsVerticalScrollIndicator = NO;
//    self.tableView.scrollIndicatorInsets
//    self.view.backgroundColor = [UIColor redColor];
//    [self.view setBackgroundColor:RGBA(256, 256, 256, 1)];
//    UIView *view = [[UIView alloc]initWithFrame:self.view.frame];
//    view.backgroundColor = [UIColor redColor];
//    [self.view addSubview:view];
    
//    [view addSubview:self.tableView];
//    [view addSubview:self.buyNowBtn];
    
    self.title = @"确认拼客订单";
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"leftBackItem"] style:UIBarButtonItemStylePlain target:self action:@selector(backClick)];
    self.navigationItem.leftBarButtonItem = backBtn;
//    NSLog(@"pinkeModel:%@",self.pinkeModel);
//    NSLog(@"dictionary:%@",self.InfoDict);
    
    /*
     进行能否购买的判断
     */
//    if(self.pinkeModel.managerList.count == 0){
//        self.buyNowBtn.enabled = NO;
//        [self.buyNowBtn setBackgroundColor:[UIColor grayColor]];
//    }
    
}

//- (void)getUserManagers{
//    NSDictionary *dic = @{@"":@""};
//    __weak __typeof(self)weakSelf = self;
//    [[LYHomePageHttpTool shareInstance]getBarVipWithParams:dic block:^(NSMutableArray *result) {
//        
//    }];
//}

- (void)getAllManagers{
    
}

- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

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
        [button addTarget:self action:@selector(selectedManager) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        
        return view;
    }
    return nil;
}

- (void)selectedManager{
    NSLog(@"ninini");
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
            return 16;
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
        if(self.pinkeModel.managerList.count == 0){
            return 40;
        }else{
            return 87 * self.pinkeModel.managerList.count;
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
        [_buyTaocanCell cellConfigureWithImage:self.pinkeModel.linkUrl name:self.pinkeModel.title way:self.InfoDict[@"way"] price:self.pinkeModel.price marketPrice:self.pinkeModel.marketprice];
        return _buyTaocanCell;
    }else if(indexPath.section == 1){
        _buyPriceCell = [tableView dequeueReusableCellWithIdentifier:@"buyPrice"];
        if(!_buyPriceCell){
            [tableView registerNib:[UINib nibWithNibName:@"LPBuyPriceCell" bundle:nil] forCellReuseIdentifier:@"buyPrice"];
            _buyPriceCell = [tableView dequeueReusableCellWithIdentifier:@"buyPrice"];
        }
        float profit = [self.pinkeModel.price floatValue] * [self.pinkeModel.rebate floatValue];
        [_buyPriceCell cellConfigureWithPay:self.InfoDict[@"money"] andProfit:profit];
        return _buyPriceCell;
    }else if(indexPath.section == 2){
        _buyInfoCell = [tableView dequeueReusableCellWithIdentifier:@"buyInfo"];
        if(!_buyInfoCell){
            [tableView registerNib:[UINib nibWithNibName:@"LPBuyInfoCell" bundle:nil] forCellReuseIdentifier:@"buyInfo"];
            _buyInfoCell = [tableView dequeueReusableCellWithIdentifier:@"buyInfo"];
        }
        [_buyInfoCell cellConfigureWithName:self.pinkeModel.barinfo.barname Address:self.pinkeModel.barinfo.address Time:self.InfoDict[@"time"] Number:self.InfoDict[@"number"]];
        return _buyInfoCell;
    }else if(indexPath.section == 3){
        _contentCell = [tableView dequeueReusableCellWithIdentifier:@"content"];
        if (!_contentCell) {
            [tableView registerNib:[UINib nibWithNibName:@"ContentTableViewCell" bundle:nil] forCellReuseIdentifier:@"content"];
            _contentCell = [tableView dequeueReusableCellWithIdentifier:@"content"];
        }
        _contentCell.goodList = self.pinkeModel.goodsList;
        [_contentCell cellConfigure];
        return _contentCell;
    }else{
        if(self.pinkeModel.managerList.count){
            _managerCell = [tableView dequeueReusableCellWithIdentifier:@"buyManager"];
            if(!_managerCell){
                [tableView registerNib:[UINib nibWithNibName:@"LPBuyManagerCell" bundle:nil] forCellReuseIdentifier:@"buyManager"];
                _managerCell = [tableView dequeueReusableCellWithIdentifier:@"buyManager"];
            }
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


- (void)imageClick{
    
}

- (void)nameClick{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buyNowClick:(UIButton *)sender {
    if(self.pinkeModel){
        bool issel = false;
        int userId=0;
//        for (ZSDetailModel *detaiModel in zsArr) {
//            if(detaiModel.issel){
//                userId=detaiModel.userid;
//                issel=true;
//                break;
//            }
//        }
//        if(!issel){
//            [self showMessage:@"请选择专属经理!"];
//            return;
//        }
        
        NSDictionary *dic=@{@"pinkerid":[NSNumber numberWithInt:_pinkeModel.id],@"reachtime":self.InfoDict[@"time"],@"checkuserid":[NSNumber numberWithInt:userId],@"allnum":self.InfoDict[@"number"],@"payamount":self.InfoDict[@"money"],@"pinkerType":self.InfoDict[@"type"]};
        [[LYHomePageHttpTool shareInstance]setTogetherOrderInWithParams:dic complete:^(NSString *result) {
            if(result){
                //支付宝页面"data": "P130637201510181610220",
                //result的值就是P130637201510181610220
                ChoosePayController *detailViewController =[[ChoosePayController alloc] init];
                detailViewController.orderNo=result;
                detailViewController.payAmount=[self.InfoDict[@"money"] doubleValue];
                detailViewController.productName=self.pinkeModel.title;
                detailViewController.productDescription=@"暂无";
                self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
                
                [self.navigationController pushViewController:detailViewController animated:YES];
            }
        }];
        
    }
    

}
@end
