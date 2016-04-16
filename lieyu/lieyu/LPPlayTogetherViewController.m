//
//  LPPlayTogetherViewController.m
//  lieyu
//
//  Created by 王婷婷 on 15/12/1.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LPPlayTogetherViewController.h"
#import "BarInfoTableViewCell.h"
#import "TaocanTableViewCell.h"
#import "AddressTableViewCell.h"
#import "BitianTableViewCell.h"
#import "ContentTableViewCell.h"
#import "LiuchengTableViewCell.h"
#import "UMSocial.h"

#import "LYHomePageHttpTool.h"
#import "ContentView.h"
#import "LPAttentionViewController.h"
#import "LPBuyViewController.h"
#import "LYtimeChooseTimeController.h"
#import "TimePickerView.h"
#import "CommonShow.h"
#import "LYUserLocation.h"
#import "IQKeyboardManager.h"

@interface LPPlayTogetherViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UITextFieldDelegate,UMSocialUIDelegate>

@property (nonatomic, strong) BarInfoTableViewCell *barinfoCell;
@property (nonatomic, strong) TaocanTableViewCell *taocanCell;
@property (nonatomic, strong) AddressTableViewCell *addressCell;
@property (nonatomic, strong) BitianTableViewCell *biTianCell;
@property (nonatomic, strong) ContentTableViewCell *contentCell;
@property (nonatomic, strong) LiuchengTableViewCell *liuchengCell;


@property (nonatomic, strong) ContentView *contentView;
@property (nonatomic, strong) TimePickerView *LPtimeView;

@property (nonatomic, strong) NSArray *labelArray;

@property (nonatomic, strong) NSString *defaultString;
@property (nonatomic, strong) NSDate *defaultDate;
@property (nonatomic, assign) CGFloat defaultPay;
@property (nonatomic, assign) int defaultNumber;
@property (nonatomic, assign) int defaultIndex;

@property (weak, nonatomic) IBOutlet UIButton *headerBackBtn;
@property (weak, nonatomic) IBOutlet UIButton *headerShareBtn;
@property (weak, nonatomic) IBOutlet UIImageView *headerLbl;

@end

@implementation LPPlayTogetherViewController
//- (UIViewController *)childViewControllerForStatusBarStyle{
//    UIViewController *statusview = [[UIViewController alloc]init];
//    statusview.view.frame = CGRectMake(0, 0, 320, 20);
//    statusview.view.backgroundColor = [UIColor purpleColor];
//    return statusview;
//}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y > self.headerLbl.frame.size.height){
//        [self.view bringSubviewToFront:self.headerBackground];
//        [self.view addSubview:self.headerBackground];
        self.headerLbl.hidden = NO;
        self.headerShareBtn.hidden = NO;
        self.headerBackBtn.hidden = NO;
        self.headerLbl.layer.shadowColor = [[UIColor blackColor]CGColor];
        self.headerLbl.layer.shadowOffset = CGSizeMake(0, 1);
        self.headerLbl.layer.shadowOpacity = 0.8;
        self.headerLbl.layer.shadowRadius = 2;
//        self.headerLbl.hidden = NO;
    }else{
        self.headerLbl.hidden = YES;
        self.headerBackBtn.hidden = YES;
        self.headerShareBtn.hidden = YES;
//        self.headerLbl.hidden = YES;
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController setNavigationBarHidden:NO];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if([[MyUtil deviceString] isEqualToString:@"iPhone 4S"]||
       [[MyUtil deviceString] isEqualToString:@"iPhone 4"]){
        _tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 100);
//        _headerBackground.frame = CGRectMake(0, 0, SCREEN_WIDTH, 64);
    }
    
    [self.headerBackBtn addTarget:self action:@selector(backForword) forControlEvents:UIControlEventTouchUpInside];
    [self.headerShareBtn addTarget:self action:@selector(ShareClick:) forControlEvents:UIControlEventTouchUpInside];
    self.headerLbl.hidden = YES;
    self.headerBackBtn.hidden = YES;
    self.headerShareBtn.hidden = YES;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view_back.layer.shadowColor = [[UIColor lightGrayColor]CGColor];
    self.view_back.layer.shadowOffset = CGSizeMake(0, -1);
    self.view_back.layer.shadowOpacity = 0.8;
    self.view_back.layer.shadowRadius = 1;
    
    self.defaultString = @"选择正确的拼客方式";
    self.defaultPay = -2;
    self.defaultDate = [NSDate date];
    self.defaultNumber = 2;
    self.defaultIndex = -1;
    
    self.biTianCell.numTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.biTianCell.numTextField.returnKeyType = UIReturnKeyDone;
    self.biTianCell.numTextField.delegate = self;
    
    self.likeBtn.enabled = NO;
    self.likeBtn.hidden = YES;
    
    self.tableView.bounces = NO;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorColor = [UIColor clearColor];
    self.labelArray = @[@"我请客",
                        @"AA付款",
                        @"自由付款"];
    [self.backBtn addTarget:self action:@selector(backForword) forControlEvents:UIControlEventTouchUpInside];
//    [self.shareBtn addTarget:self action:@selector(shareTaocan) forControlEvents:UIControlEventTouchUpInside];
//    [self.likeBtn addTarget:self action:@selector(likeTaocan) forControlEvents:UIControlEventTouchUpInside];
    [self getdata];
    
}

#pragma mark  回退按钮
- (void)backForword{
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].isAdd = NO;
    [self.navigationController popViewControllerAnimated:YES];
//    for (UIViewController *controller in self.navigationController.childViewControllers) {
//        if(controller isKindOfClass:[])
//    }
}

//- (void)shareTaocan{
//    NSLog(@"Share Success!");
//}
//
//- (void)likeTaocan{
//    NSLog(@"Like Success!");
//}

//- (void)addStatusView{
//    UIView *status = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 20)];
//    status.backgroundColor = [UIColor purpleColor];
//    [self.view addSubview:status];
//}

#pragma mark  页面进来获取数据
- (void)getdata{
    NSDictionary *dic = @{@"smid":[NSNumber numberWithInt:self.smid]};
    __weak __typeof(self)weakSelf = self;
    [[LYHomePageHttpTool shareInstance]getTogetherDetailWithParams:dic block:^(PinKeModel *result) {
        _pinKeModel = result;
        [weakSelf.tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark  tableView各个代理功能
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    int height;
    switch (indexPath.section) {
        case 0:
            height = 40 + SCREEN_WIDTH;
            break;
        case 1:
            height = 146;
            break;
        case 2:
            height = 60;
            break;
        case 3:
            height = 195;
            break;
        case 4:
            height = 66 + 44 * (int)self.pinKeModel.goodsList.count;
            break;
        case 5:
            height = 55 + (SCREEN_WIDTH / 2);
            break;
        default:
            break;
    }
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        _barinfoCell = [tableView dequeueReusableCellWithIdentifier:@"barInfo"];
        if(!_barinfoCell){
            [tableView registerNib:[UINib nibWithNibName:@"BarInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"barInfo"];
            _barinfoCell = [tableView dequeueReusableCellWithIdentifier:@"barInfo"];
        }
        if(self.pinKeModel){
            NSString * star_num ;
            if([self.pinKeModel.barinfo.star_num isEqualToString:@""]){
                star_num = @"5";
            }else{
                star_num = self.pinKeModel.barinfo.star_num;
            }
            NSDictionary *dict;
            if(self.pinKeModel.banner.count > 0){
                dict = @{@"barName":self.pinKeModel.barinfo.barname,@"stars":star_num,@"imageURL":self.pinKeModel.banner[0]};
            }else{
                dict = @{@"barName":self.pinKeModel.barinfo.barname,@"stars":star_num};
            }
            [_barinfoCell cellConfigure:dict];
        }
        return _barinfoCell;
    }else if(indexPath.section == 1){
        _taocanCell = [tableView dequeueReusableCellWithIdentifier:@"taocan"];
        if(!_taocanCell){
            [tableView registerNib:[UINib nibWithNibName:@"TaocanTableViewCell" bundle:nil] forCellReuseIdentifier:@"taocan"];
            _taocanCell = [tableView dequeueReusableCellWithIdentifier:@"taocan"];
        }
        if(self.pinKeModel){
            NSDictionary *dict = @{
                                   @"taocanInfo":self.pinKeModel.title,
                                   @"price":self.pinKeModel.price,
                                   @"marketPrice":self.pinKeModel.marketprice,
                                   @"profit":self.pinKeModel.rebate,
                                   @"image":@""};
            _taocanCell.dict = dict;
            [_taocanCell cellConfigure];
        }
        return _taocanCell;
    }else if(indexPath.section == 2){
        _addressCell = [tableView dequeueReusableCellWithIdentifier:@"address"];
        if(!_addressCell){
            [tableView registerNib:[UINib nibWithNibName:@"AddressTableViewCell" bundle:nil] forCellReuseIdentifier:@"address"];
            _addressCell = [tableView dequeueReusableCellWithIdentifier:@"address"];
        }
        if(self.pinKeModel){
            NSLog(@"%@",self.pinKeModel.barinfo.address);
            [_addressCell cellConfigure:self.pinKeModel.barinfo.address];
            [_addressCell.addressBtn addTarget:self action:@selector(daohang) forControlEvents:UIControlEventTouchUpInside];
        }
        return _addressCell;
    }else if(indexPath.section == 3){
        _biTianCell = [tableView dequeueReusableCellWithIdentifier:@"biTian"];
        if(!_biTianCell){
            [tableView registerNib:[UINib nibWithNibName:@"BitianTableViewCell" bundle:nil] forCellReuseIdentifier:@"biTian"];
            _biTianCell = [tableView dequeueReusableCellWithIdentifier:@"biTian"];
            _biTianCell.numTextField.delegate = self;
            [_biTianCell.chooseTime addTarget:self action:@selector(chooseTimeForTaocan) forControlEvents:UIControlEventTouchUpInside];
            [_biTianCell.chooseWay addTarget:self action:@selector(chooseWayForTaocan) forControlEvents:UIControlEventTouchUpInside];
            [_biTianCell.addBtn addTarget:self action:@selector(addPeople) forControlEvents:UIControlEventTouchUpInside];
            [_biTianCell.lessBtn addTarget:self action:@selector(lessPeople) forControlEvents:UIControlEventTouchUpInside];
        }
        return _biTianCell;
    }else if(indexPath.section == 4){
        _contentCell = [tableView dequeueReusableCellWithIdentifier:@"content"];
        if(!_contentCell){
            [tableView registerNib:[UINib nibWithNibName:@"ContentTableViewCell" bundle:nil] forCellReuseIdentifier:@"content"];
            _contentCell = [tableView dequeueReusableCellWithIdentifier:@"content"];
        }
        if(self.pinKeModel){
            _contentCell.goodList = self.pinKeModel.goodsList;
            [_contentCell cellConfigure];
        }
        return _contentCell;
    }else{
        _liuchengCell = [tableView dequeueReusableCellWithIdentifier:@"liucheng"];
        if(!_liuchengCell){
            [tableView registerNib:[UINib nibWithNibName:@"LiuchengTableViewCell" bundle:nil] forCellReuseIdentifier:@"liucheng"];
            _liuchengCell = [tableView dequeueReusableCellWithIdentifier:@"liucheng"];
        }
        return _liuchengCell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section == 5){
        return -100;
    }else{
        return 8;
    }
}


#pragma mark  进入地图
- (void)daohang{
    NSDictionary *dic=@{@"title":self.pinKeModel.barinfo.barname,@"latitude":self.pinKeModel.barinfo.latitude,@"longitude":self.pinKeModel.barinfo.longitude};
    [[LYUserLocation instance] daoHan:dic];
}

#pragma mark  实现代理的方法，选择拼客方式
- (void)LPAlertView:(LPAlertView *)alertView clickedButtonAtIndexWhenWay:(NSInteger)buttonIndex{
    if(buttonIndex == 1){
        for (int index = 0 ; index < _contentView.buttonStatusArray.count; index ++) {
            if([_contentView.buttonStatusArray[index] isEqualToString:@"1"]){
                [self.biTianCell.chooseWay setTitle:self.labelArray[index] forState:UIControlStateNormal];
                self.defaultString = self.labelArray[index];
                
                //统计拼客方式的选择
                NSDictionary *dict = @{@"actionName":@"选择",@"pageName":@"拼客详情",@"titleName":@"选择拼客方式",@"value":self.defaultString};
                [MTA trackCustomKeyValueEvent:@"LYClickEvent" props:dict];
                
                self.defaultIndex = index;//作为已选方式的判断以及后期参数
            }
        }
        
    }
}

//#pragma mark  填写支付金额
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    if (buttonIndex == alertView.firstOtherButtonIndex) {
//        if ([[alertView textFieldAtIndex:0].text intValue] < 100) {
//            [CommonShow showMessage:@"对不起，发起人预付金额不可少于100元!"];
//        }else{
//            self.defaultIndex = 2;
//            self.defaultPay = [[alertView textFieldAtIndex:0].text intValue];
//        }
//    }
//}

#pragma mark   选择消费时间
- (void)LPAlertView:(LPAlertView *)alertView clickedButtonAtIndexWhenTime:(NSInteger)buttonIndex{
    if(buttonIndex == 1){
//        for (int index = 0 ; index < _contentView.buttonStatusArray.count; index ++) {
            self.defaultDate = _LPtimeView.timePicker.date;
            NSLog(@"--------%@",_LPtimeView.timePicker.date);
//            NSLog(@"--------2%@",_LPtimeView.timePicker.c)
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"MM月dd日 EEE HH:mm"];
            NSString *dateString = [formatter stringFromDate:self.defaultDate];
            [self.biTianCell.chooseTime setTitle:dateString forState:UIControlStateNormal];
//        }
        self.defaultPay = -1;//作为已选时间的条件以及后期将要改变的参数
    }
}

#pragma mark  选择消费时间
- (void)chooseTimeForTaocan{
    LPAlertView *alertView = [[LPAlertView alloc]initWithDelegate:self buttonTitles:@"取消", @"确定", nil];
//    alertView.delegate = self;
    _LPtimeView = [[[NSBundle mainBundle]loadNibNamed:@"TimePickerView" owner:nil options:nil]firstObject];
    _LPtimeView.tag = 11;
//    [_timeView showTimeWithDate:self.defaultDate];
    _LPtimeView.timePicker.date = self.defaultDate;
    alertView.contentView = _LPtimeView;
    _LPtimeView.frame = CGRectMake(10, SCREEN_HEIGHT - 270, SCREEN_WIDTH - 20, 200);
    [alertView show];
}

#pragma mark  选择拼客方式
- (void)chooseWayForTaocan{
    LPAlertView *alertView = [[LPAlertView alloc]initWithDelegate:self buttonTitles:@"取消", @"确定", nil];
    alertView.delegate = self;
    _contentView = [[[NSBundle mainBundle]loadNibNamed:@"ContentView" owner:nil options:nil]firstObject];
    _contentView.tag = 12;
    _contentView.defaultString = self.defaultString;
    [_contentView contentViewChooseBtn];
    _contentView.frame = CGRectMake(10, SCREEN_HEIGHT- 320, SCREEN_WIDTH - 20, 250);
    alertView.contentView = _contentView;
    [alertView show];
}

#pragma mark  加按钮点击
- (void)addPeople{
    self.defaultNumber ++;
//    self.biTianCell.numTextField.text = [NSString stringWithFormat:@"%d",self.defaultNumber];
    [self.biTianCell.numTextField setText:[NSString stringWithFormat:@"%d",self.defaultNumber]];
    if(self.defaultNumber > 2){
        self.biTianCell.lessBtn.enabled = YES;
//        [self.biTianCell.lessBtn setBackgroundImage:[UIImage imageNamed:@"purper_less"] forState:UIControlStateNormal];
        [self.biTianCell.lessBtn setImage:[UIImage imageNamed:@"purper_less"] forState:UIControlStateNormal];
    }
}

#pragma mark  减按钮点击
- (void)lessPeople{
    if(self.defaultNumber <= 2){
        self.biTianCell.lessBtn.enabled = NO;
        [self.biTianCell.lessBtn setBackgroundImage:[UIImage imageNamed:@"gray_less"] forState:UIControlStateNormal];
    }else{
        self.defaultNumber --;
        [self.biTianCell.numTextField setText:[NSString stringWithFormat:@"%d",self.defaultNumber]];
    }
}


#pragma mark  textFieldDelegate代理方法
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    self.biTianCell.numTextField.text = @"";
}// became first responder

- (void)textFieldDidEndEditing:(UITextField *)textField{
    self.defaultNumber = [self.biTianCell.numTextField.text intValue];
}

#pragma mark  咨询猎娱
- (IBAction)ZiXunLieyu:(UIButton *)sender {
    RCPublicServiceChatViewController *conversationVC = [[RCPublicServiceChatViewController alloc] init];
    conversationVC.conversationType = ConversationType_APPSERVICE;
    conversationVC.targetId = @"KEFU144946169476221";
//    conversationVC.userName = @"猎娱客服";
    conversationVC.title = @"猎娱客服";
    
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].isAdd = YES;
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(-10, 0, 44, 44)];
    [button setImage:[UIImage imageNamed:@"backBtn"] forState:UIControlStateNormal];
    [view addSubview:button];
    [button addTarget:self action:@selector(backForword) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:view];
    conversationVC.navigationItem.leftBarButtonItem = item;
    [self.navigationController pushViewController:conversationVC animated:YES];
}

#pragma mark  mark  mark  注意事项
- (IBAction)ZhuYiShixiang:(UIButton *)sender {
    LPAttentionViewController *LPattentionVC = [[UIStoryboard storyboardWithName:@"NewMain" bundle:[NSBundle mainBundle]]instantiateViewControllerWithIdentifier:@"LPattention"];
    [self.navigationController pushViewController:LPattentionVC animated:YES];
}

#pragma mark  mark  立即购买
- (IBAction)BuyNow:(UIButton *)sender {
    if(self.defaultIndex == -1){
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"抱歉，请选择正确的拼客方式!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil]show ];
    }else if(self.defaultPay == -2){
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"抱歉，请选择到店时间!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil]show ];
    }else{
        LPBuyViewController *LPBuyVC = [[UIStoryboard storyboardWithName:@"NewMain" bundle:[NSBundle mainBundle]]instantiateViewControllerWithIdentifier:@"LPBuyVC"];
//        LPBuyVC.pinkeModel = self.pinKeModel;
        LPBuyVC.smid = self.pinKeModel.smid;
//        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
//        [formatter setDateFormat:@"yy年MM月dd日 EEE HH:mm"];
//        NSString *dateString = [formatter stringFromDate:self.defaultDate];
        
        if(self.defaultIndex == 1){
            self.defaultPay = [self.pinKeModel.price floatValue] * 1.0 / self.defaultNumber;
        }else if (self.defaultIndex == 0){
            self.defaultPay = [self.pinKeModel.price floatValue];
        }else if(self.defaultIndex == 2){
            self.defaultPay = -1;
        }
        
        
        
        //统计拼客人数的选择
        NSDictionary *dict1 = @{@"actionName":@"选择",@"pageName":@"拼客详情",@"titleName":@"确定拼客人数",@"value":[NSString stringWithFormat:@"%d",self.defaultNumber]};
        [MTA trackCustomKeyValueEvent:@"LYClickEvent" props:dict1];
        
        NSDictionary *dict = @{@"time":self.defaultDate,
                               @"way":self.defaultString,
                               @"money":[NSString stringWithFormat:@"%.2f",self.defaultPay],
                               @"number":[NSString stringWithFormat:@"%d",self.defaultNumber],
                               @"type":[NSString stringWithFormat:@"%d",self.defaultIndex]};
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithDictionary:dict];
        
        LPBuyVC.InfoDict = dictionary;
        [self.navigationController pushViewController:LPBuyVC animated:YES];
    }
}


#pragma mark  mark  喜欢按钮
- (IBAction)LikeClick:(UIButton *)sender {
    
}

#pragma mark  mark  分享按钮
- (IBAction)ShareClick:(UIButton *)sender {
//    
    NSString *string=@"大家一起来看看～猎娱不错啊! 下载猎娱App即可优惠下单，还有超值返利。http://www.lie98.com\n";
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeText;
//    [UMSocialSnsService presentSnsController:self
//                                appKey:UmengAppkey
//                                shareText:string
//                                shareImage:self.barinfoCell.barImage.image
//                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSms,nil]
//                                delegate:self];
    [UMSocialSnsService presentSnsIconSheetView:self appKey:UmengAppkey shareText:string shareImage:self.barinfoCell.barImage.image shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatTimeline,UMShareToWechatSession,UMShareToSina,UMShareToSms,nil] delegate:self];
    
}

- (BOOL)isDirectShareInIconActionSheet{
    return NO;
}

- (BOOL)closeOauthWebViewController:(UINavigationController *)navigationCtroller socialControllerService:(UMSocialControllerService *)socialControllerService{
//    UIViewController *view1 = [[UIViewController alloc]init];
//    view1.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
//    view1.view.backgroundColor = [UIColor redColor];
//    [self.navigationController pushViewController:view1 animated:YES];
    return YES;
}

//- (void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response{
//    
//}

//- (void)didCloseUIViewController:(UMSViewControllerType)fromViewControllerType{
//    UIViewController *view1 = [[UIViewController alloc]init];
//    view1.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
//    view1.view.backgroundColor = [UIColor redColor];
//    [self.navigationController pushViewController:view1 animated:YES];
//}

@end
