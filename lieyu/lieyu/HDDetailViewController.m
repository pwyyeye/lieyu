//
//  HDDetailViewController.m
//  lieyu
//
//  Created by 王婷婷 on 16/1/31.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//
#import "HDDetailViewController.h"
#import "HeaderTableViewCell.h"
#import "HDDetailTableViewCell.h"
#import "LYDinWeiTableViewCell.h"
#import "LPAlertView.h"
#import "ChooseNumber.h"
#import "UIImageView+WebCache.h"
#import "YUOrderInfo.h"
#import "LYUserLocation.h"
#import "LYHomePageHttpTool.h"
#import "BeerBarDetailViewController.h"
#import "YUPinkerinfo.h"
#import "YUPinkerListModel.h"
#import "LYMyOrderManageViewController.h"
#import "ChoosePayController.h"
#import "LYFriendsToUserMessageViewController.h"
#import "DetailView.h"
#import "preview.h"

@interface HDDetailViewController ()<UITableViewDataSource,UITableViewDelegate,LPAlertViewDelegate,showImageInPreview>
{
    YUOrderInfo *orderInfo;
    YUPinkerinfo *pinkeModel;
    YUPinkerListModel *listModel;
    int store;
    double allMoney;
}
@property (nonatomic, strong) HeaderTableViewCell *headerCell;
@property (nonatomic, strong) LYDinWeiTableViewCell *LYdwCell;
@property (nonatomic, strong) HDDetailTableViewCell *HDDetailCell;
@property (nonatomic, strong) JoinedTableViewCell *joinedCell;
@property (nonatomic, strong) ChooseNumber *chooseNumber;

@property (nonatomic, strong) preview *subView;

@end

@implementation HDDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    orderInfo = _YUModel.orderInfo;
    pinkeModel = orderInfo.pinkerinfo;
//    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH - 52);
    [self configureStore];
    [self configurePinkeStatus];
    [self registerCell];
    self.label_bottom.layer.shadowColor = [RGBA(0, 0, 0, 0.2) CGColor];
    self.label_bottom.layer.shadowOffset = CGSizeMake(-1, 0);
    self.label_bottom.layer.shadowOpacity = 0.5;
    self.label_bottom.layer.shadowRadius = 1;
    self.title = @"活动详情";
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBarHidden=YES;
}

-(void)viewWillLayoutSubviews{
    [super  viewWillLayoutSubviews];
    self.navigationController.navigationBarHidden=NO;
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=NO;
}

//计算剩余参与人数
- (void)configureStore{
    int num = 0;
    for (int i = 0 ; i < orderInfo.pinkerList.count; i ++) {
        listModel = [orderInfo.pinkerList objectAtIndex:i];
        num = num + [listModel.quantity intValue];
    }
    store = [orderInfo.allnum intValue] - num ;
}

//判断拼客形成
- (void)configurePinkeStatus{
    if(![orderInfo.orderStatus isEqualToString:@"0"]){
        self.joinBtn.enabled = NO;
        self.joinBtn.backgroundColor = RGBA(181, 181, 181, 1);
    }
    if ([[MyUtil residueTimeFromDate:orderInfo.reachtime] isEqualToString:@"已过期"]) {
        self.joinBtn.enabled = NO;
        self.joinBtn.backgroundColor = RGBA(181, 181, 181, 1);
    }
}

- (void)registerCell{
    [self.tableView registerNib:[UINib nibWithNibName:@"HeaderTableViewCell" bundle:nil] forCellReuseIdentifier:@"HeaderTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"LYDinWeiTableViewCell" bundle:nil] forCellReuseIdentifier:@"LYDinWeiTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HDDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"HDDetailTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"JoinedTableViewCell" bundle:nil] forCellReuseIdentifier:@"JoinedTableViewCell"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        _headerCell = [tableView dequeueReusableCellWithIdentifier:@"HeaderTableViewCell" forIndexPath:indexPath];
        [_headerCell.avatar_image sd_setImageWithURL:[NSURL URLWithString:orderInfo.avatar_img] placeholderImage:[UIImage imageNamed:@"empyImage120"]];
        _headerCell.name_label.text = orderInfo.username;
        [_headerCell.avatar_button addTarget:self action:@selector(CheckMyMessage) forControlEvents:UIControlEventTouchUpInside];
        _headerCell.viewNumber_label.text = @"";
        _headerCell.title_label.text = _YUModel.shareContent;
        _headerCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return _headerCell;
    }else if (indexPath.section == 1){
        _LYdwCell = [tableView dequeueReusableCellWithIdentifier:@"LYDinWeiTableViewCell" forIndexPath:indexPath];
        [_LYdwCell.imageView_button addTarget:self action:@selector(clickThisImageView) forControlEvents:UIControlEventTouchUpInside];
        _LYdwCell.pinkeInfo = pinkeModel;
        _LYdwCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return _LYdwCell;
    }else if(indexPath.section == 2){
        _HDDetailCell = [tableView dequeueReusableCellWithIdentifier:@"HDDetailTableViewCell" forIndexPath:indexPath];
        
        NSArray *reachTimeArray1 = [orderInfo.reachtime componentsSeparatedByString:@" "];
        if (reachTimeArray1.count == 2) {
            NSArray *reachTimeArray2 = [reachTimeArray1[0] componentsSeparatedByString:@"-"];
            NSArray *reachTimeArray3 = [reachTimeArray1[1] componentsSeparatedByString:@":"];
            if (reachTimeArray2.count == 3 && reachTimeArray3.count == 3) {
                NSString *timeStr = [NSString stringWithFormat:@"%@-%@ (%@) %@:%@",reachTimeArray2[1],reachTimeArray2[2],[MyUtil weekdayStringFromDate:orderInfo.reachtime],reachTimeArray3[0],reachTimeArray3[1]];
                _HDDetailCell.startTime_label.text = timeStr;
            }
        }
        _HDDetailCell.residue_label.text = [MyUtil residueTimeFromDate:orderInfo.reachtime];
        _HDDetailCell.joinedNumber_label.text = [NSString stringWithFormat:@"参加人数(%d/%d)",orderInfo.pinkerCount,[orderInfo.allnum intValue]];
        if ([_YUModel.allowSex isEqualToString:@"0"]) {
            _HDDetailCell.joinedpro_label.text = @"只邀请女生";
        }else if ([_YUModel.allowSex isEqualToString:@"1"]){
            _HDDetailCell.joinedpro_label.text = @"只邀请男生";
        }else{
            _HDDetailCell.joinedpro_label.text = @"全部";
        }
        _HDDetailCell.address_label.text = orderInfo.barinfo.address;
        _HDDetailCell.barName_label.text = orderInfo.barinfo.barname;
        [_HDDetailCell.checkAddress_button addTarget:self action:@selector(checkAddress) forControlEvents:UIControlEventTouchUpInside];
        [_HDDetailCell.checkBar_button addTarget:self action:@selector(checkBar) forControlEvents:UIControlEventTouchUpInside];
        _HDDetailCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return _HDDetailCell;
    }else if(indexPath.section == 3){
        _joinedCell = [tableView dequeueReusableCellWithIdentifier:@"JoinedTableViewCell" forIndexPath:indexPath];
        [_joinedCell configureJoinedNumber:[orderInfo.allnum intValue]andPeople:orderInfo];
        _joinedCell.delegate = self;
        _joinedCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return _joinedCell;
//    }else if(indexPath.section == 4){
//        _joinedCell = [tableView dequeueReusableCellWithIdentifier:@"JoinedTableViewCell" forIndexPath:indexPath];
//        [_joinedCell configureMessage];
//        _joinedCell.selectionStyle = UITableViewCellSelectionStyleNone;
//        return _joinedCell;
    }else if (indexPath.section == 4){
        _joinedCell = [tableView dequeueReusableCellWithIdentifier:@"JoinedTableViewCell" forIndexPath:indexPath];
        [_joinedCell configureMoreAction];
        _joinedCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return _joinedCell;
    }else{
        return nil;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 8;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height;
    if (indexPath.section == 0) {
        _headerCell.title_label.font = [UIFont systemFontOfSize:14];
        CGSize size = [_headerCell.title_label.text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 146, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
        height = size.height + 51;
    }else if (indexPath.section == 1){
        height = 104;
    }else if(indexPath.section == 2){
        height = 200;
    }else if (indexPath.section == 3){
        int width = SCREEN_WIDTH - 24;
        int shang = width / 50;
        int yushu = width % 50;
        if(yushu / 10 * 50 >= 40){
            shang ++;
        }
        //shang为一行能摆几个头像
        int row = (int)orderInfo.pinkerList.count / shang;
        int duoyu = orderInfo.pinkerList.count % shang;
        if(duoyu > 0){
            row ++;
        }
        height = row * 50 + 34;
    }else if(indexPath.section == 4){
        height = 164;
    }else if(indexPath.section == 5){
        return 320 / 16 * 9;
    }
    return height;
}

#pragma --mark 参与拼客

- (IBAction)WannaJoin:(UIButton *)sender {
    LPAlertView *alertView = [[LPAlertView alloc]initWithDelegate:self buttonTitles:@"取消", @"确定", nil];
    alertView.delegate = self;
    _chooseNumber = [[[NSBundle mainBundle]loadNibNamed:@"ChooseNumber" owner:nil options:nil]firstObject];
    _chooseNumber.tag = 14;
    
    _chooseNumber.store = store;
    _chooseNumber.frame = CGRectMake(10, SCREEN_HEIGHT - 320, SCREEN_WIDTH - 20, 250);
    
    alertView.contentView = _chooseNumber;
    [alertView show];
}

- (void)LPAlertView:(LPAlertView *)alertView clickedButtonAtIndexChooseNum:(NSInteger)buttonIndex{
    if(buttonIndex){
        allMoney = [orderInfo.pinkerNum intValue] * [pinkeModel.price doubleValue];
        //    orderInfo.pinkerType
        //    0、请客 1、AA付款 2、自由付款 （发起人自由 其他AA）
        //    _YUModel.allowSex
        //    0、只有女生 1、只有男生 2、全部
        //    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        //    _context = app.managedObjectContext;
        //    _userid = [NSString stringWithFormat:@"%d",app.userModel.userid];
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        //    app.userModel.gender   0表示女生
        if ([_YUModel.allowSex isEqualToString:@"2"]) {
            //全部都可以参加
        }else if ([_YUModel.allowSex isEqualToString:@"0"]){
            if (![app.userModel.gender isEqualToString:@"0"]) {
                //不是女生
                [MyUtil showCleanMessage:@"抱歉，该组局仅允许女生加入"];
                return;
            }
        }else if ([_YUModel.allowSex isEqualToString:@"1"]){
            if (![app.userModel.gender isEqualToString:@"1"]) {
                //不是男生
                [MyUtil showCleanMessage:@"抱歉，该组局仅允许男生生加入"];
                return;
            }
        }
        double payamout;
        if ([orderInfo.pinkerType isEqualToString:@"0"]) {
            //发起人请客
            payamout = 0 ;
        }else if([orderInfo.pinkerType isEqualToString:@"1"]){
            //AA付款
            if ([_chooseNumber.numberField.text intValue] == store) {
                [self configureRestMoney];
                payamout = allMoney;
            }else{
                payamout = allMoney / [orderInfo.allnum intValue];
                payamout = payamout * [_chooseNumber.numberField.text intValue];
            }
        }else if ([orderInfo.pinkerType isEqualToString:@"2"]){
            //发起人自由付款，其他人AA
            if ([_chooseNumber.numberField.text intValue] == store) {
                [self configureRestMoney];
                payamout = allMoney;
            }else{
                payamout = allMoney / ([orderInfo.allnum intValue] - 1);
                payamout = payamout * [_chooseNumber.numberField.text intValue];
            }
        }
//        NSString *string = [NSString stringWithFormat:@"%f",payamout];
        NSDictionary *dic = @{@"id":[NSString stringWithFormat:@"%@",_YUModel.orderInfo.id],
                              @"payamount":[NSString stringWithFormat:@"%.2f",payamout],
                              @"allnum":_chooseNumber.numberField.text};
        [[LYHomePageHttpTool shareInstance]inTogetherOrderInWithParams:dic complete:^(NSString *result) {
            if(payamout == 0.0){
                LYMyOrderManageViewController *detailVC = [[LYMyOrderManageViewController alloc]initWithNibName:@"LYMyOrderManageViewController" bundle:nil];
                [self.navigationController pushViewController:detailVC animated:YES];
            }else{
                ChoosePayController *detailVC = [[ChoosePayController alloc]init];
                detailVC.orderNo = result;
                detailVC.payAmount = payamout;
                detailVC.productName = pinkeModel.smname;
                detailVC.productDescription = @"暂无";
                UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"return"] style:UIBarButtonItemStylePlain target:self action:nil];
                self.navigationItem.backBarButtonItem = left;
                [self.navigationController pushViewController:detailVC animated:YES];
            }
        }];
    }
    
//    [[LYHomePageHttpTool shareInstance]inTogetherOrderInWithParams:@{@"id":[NSString stringWithFormat:@"%@",_YUModel.orderInfo.pinkerinfo.id],@"payamount":pinKeModel.pinkerNeedPayAmount} complete:^(NSString *result) {
//        if(result){
//            //支付宝页面"data": "P130637201510181610220",
//            //result的值就是P130637201510181610220
//            if (pinKeModel.pinkerNeedPayAmount.doubleValue==0.0) {
//                UIViewController *detailViewController;
//                
//                detailViewController  = [[LYMyOrderManageViewController alloc] initWithNibName:@"LYMyOrderManageViewController" bundle:nil];
//                
//                [self.navigationController pushViewController:detailViewController animated:YES];
//                
//            }else{
//                ChoosePayController *detailViewController =[[ChoosePayController alloc] init];
//                detailViewController.orderNo=result;
//                detailViewController.payAmount=pinKeModel.pinkerNeedPayAmount.doubleValue;
//                detailViewController.productName=pinKeModel.fullname;
//                detailViewController.productDescription=@"暂无";
//                UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"return"] style:UIBarButtonItemStylePlain target:self action:nil];
//                self.navigationItem.backBarButtonItem = left;
//                [self.navigationController pushViewController:detailViewController animated:YES];
//            }
//            
//        }
//    }];
}

#pragma mark - 计算还需要多少钱
- (void)configureRestMoney{
//    double money = 0.00;
//    for (int i = 0 ; i < orderInfo.pinkerList.count; i ++) {
//        listModel = [orderInfo.pinkerList objectAtIndex:i];
////        num = num + [listModel.price floatValue];;
//        NSDecimalNumber *num = [NSDecimalNumber decimalNumberWithString:listModel.price];
//        NSLog(@"%f",[num doubleValue]);
//        money = money + [num doubleValue];
//    }
//    allMoney = allMoney - money;
    NSDecimalNumber *money = [NSDecimalNumber decimalNumberWithString:@"0"];
    for (int i = 0 ; i < orderInfo.pinkerList.count ; i ++) {
        listModel = [orderInfo.pinkerList objectAtIndex:i];
        NSDecimalNumber *num = [NSDecimalNumber decimalNumberWithString:listModel.price];
        money = [money decimalNumberByAdding:num];
    }
    NSDecimalNumber *one = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",allMoney]];
    one = [one decimalNumberBySubtracting:money];
    NSLog(@"%f",[one doubleValue]);
    allMoney = [one doubleValue];
}

- (void)checkAddress{
    NSDictionary *dic=@{@"title":orderInfo.barinfo.barname,@"latitude":orderInfo.barinfo.latitude,@"longitude":orderInfo.barinfo.longitude};
    [[LYUserLocation instance] daoHan:dic];
}

- (void)checkBar{
    BeerBarDetailViewController * controller = [[BeerBarDetailViewController alloc] initWithNibName:@"BeerBarDetailViewController" bundle:nil];
    controller.beerBarId = [NSNumber numberWithInt:orderInfo.barinfo.id];
    [self.navigationController pushViewController:controller animated:YES];
    [MTA trackCustomKeyValueEvent:LYCLICK_MTA props:[self createMTADctionaryWithActionName:@"跳转" pageName:@"活动详情" titleName:orderInfo.barinfo.barname]];
}

- (void)CheckMyMessage{
    [self HDDetailJumpToFriendDetail:orderInfo.userid];
}

- (void)gotoUserPage:(UIButton *)button{
        NSInteger index = button.tag;
//    NSInteger index = tap.view.tag;
   
    [self HDDetailJumpToFriendDetail:((YUPinkerListModel *)[orderInfo.pinkerList objectAtIndex:index]).inmember];
}


- (void)HDDetailJumpToFriendDetail:(NSString *)friendId{
    LYFriendsToUserMessageViewController *messageVC = [[LYFriendsToUserMessageViewController alloc]init];
    messageVC.friendsId = friendId;
    [self.navigationController pushViewController:messageVC animated:YES];
}

- (void)clickThisImageView{
    UIView *bigView = [[UIView alloc]initWithFrame:self.view.bounds];
    bigView.backgroundColor = RGBA(0, 0, 0, 0.3);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideBigView:)];
    [bigView addGestureRecognizer:tap];
    
    DetailView *detailView = [[[NSBundle mainBundle]loadNibNamed:@"DetailView" owner:nil options:nil]firstObject];
    detailView.frame = CGRectMake(8, 64, SCREEN_WIDTH - 16, 268 + SCREEN_WIDTH / 3);
//    detailView.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2);
//    RecommendPackageModel *model = [jiubaModel.recommend_package objectAtIndex:sender.tag];
//    detailView.packModel = model;
    detailView.delegate = self;
    NSDictionary *dic=@{@"smid":pinkeModel.id};
    [[LYHomePageHttpTool shareInstance]getWoYaoDinWeiTaoCanDetailWithParams:dic block:^(TaoCanModel *result) {
        NSLog(@"%@",result);
        [detailView setTcModel:result];
        [detailView Configure];
    }];
    
    
    [self.view addSubview:bigView];
    [bigView addSubview:detailView];
}

- (void)hideBigView:(UITapGestureRecognizer *)gesture{
    [gesture.view removeFromSuperview];
}

- (void)showImageInPreview:(UIImage *)image{
//    [self.navigationController.navigationBar setHidden:YES];
    _subView = [[[NSBundle mainBundle]loadNibNamed:@"preview" owner:nil options:nil]firstObject];
    _subView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    _subView.button.hidden = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(previewHide)];
    [_subView addGestureRecognizer:tap];
    _subView.image = image;
    [_subView viewConfigure];
    //    _subView.imageView.contentMode = UIViewContentModeScaleAspectFit;
    //    _subView.imageView.center = _subView.center;
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:_subView];
}

- (void)previewHide{
//    [self.navigationController.navigationBar setHidden:NO];
    [_subView removeFromSuperview];
}

@end
