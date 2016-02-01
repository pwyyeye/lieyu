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
#import "JoinedTableViewCell.h"
#import "LYDinWeiTableViewCell.h"
#import "LPAlertView.h"
#import "ChooseNumber.h"
#import "UIImageView+WebCache.h"
#import "YUOrderInfo.h"
#import "LYUserLocation.h"
#import "LYHomePageHttpTool.h"

@interface HDDetailViewController ()<UITableViewDataSource,UITableViewDelegate,LPAlertViewDelegate>
@property (nonatomic, strong) HeaderTableViewCell *headerCell;
@property (nonatomic, strong) LYDinWeiTableViewCell *LYdwCell;
@property (nonatomic, strong) HDDetailTableViewCell *HDDetailCell;
@property (nonatomic, strong) JoinedTableViewCell *joinedCell;
@property (nonatomic, strong) ChooseNumber *chooseNumber;

@end

@implementation HDDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.showsVerticalScrollIndicator = NO;
//    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH - 52);
    [self registerCell];
    self.title = @"活动详情";
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
        [_headerCell.avatar_image sd_setImageWithURL:[NSURL URLWithString:((YUOrderInfo *)_YUModel.orderInfo).avatar_img] placeholderImage:[UIImage imageNamed:@"empyImage120"]];
        _headerCell.name_label.text = ((YUOrderInfo *)_YUModel.orderInfo).username;
        
        _headerCell.viewNumber_label.text = @"";
        _headerCell.title_label.text = _YUModel.shareContent;
        _headerCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return _headerCell;
    }else if (indexPath.section == 1){
        _LYdwCell = [tableView dequeueReusableCellWithIdentifier:@"LYDinWeiTableViewCell" forIndexPath:indexPath];
//        [_LYdwCell.imageView_header sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"empyImage120"]];
        _LYdwCell.pinkeInfo = ((YUOrderInfo *)_YUModel.orderInfo).pinkerinfo;
        _LYdwCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return _LYdwCell;
    }else if(indexPath.section == 2){
        _HDDetailCell = [tableView dequeueReusableCellWithIdentifier:@"HDDetailTableViewCell" forIndexPath:indexPath];
        
        NSArray *reachTimeArray1 = [_YUModel.orderInfo.reachtime componentsSeparatedByString:@" "];
        if (reachTimeArray1.count == 2) {
            NSArray *reachTimeArray2 = [reachTimeArray1[0] componentsSeparatedByString:@"-"];
            NSArray *reachTimeArray3 = [reachTimeArray1[1] componentsSeparatedByString:@":"];
            if (reachTimeArray2.count == 3 && reachTimeArray3.count == 3) {
                NSString *timeStr = [NSString stringWithFormat:@"%@-%@ (%@) %@:%@",reachTimeArray2[1],reachTimeArray2[2],[MyUtil weekdayStringFromDate:_YUModel.orderInfo.reachtime],reachTimeArray3[0],reachTimeArray3[1]];
                _HDDetailCell.startTime_label.text = timeStr;
            }
        }
//        _HDDetailCell.startTime_label.text = @"";
        _HDDetailCell.residue_label.text = [MyUtil residueTimeFromDate:((YUOrderInfo *)_YUModel.orderInfo).reachtime];
//        _HDDetailCell.residue_label.text = @"";
        _HDDetailCell.joinedNumber_label.text = [NSString stringWithFormat:@"参加人数(%lu/%d)",((YUOrderInfo *)_YUModel.orderInfo).pinkerList.count,[((YUOrderInfo *)_YUModel.orderInfo).allnum intValue]];
        if ([_YUModel.allowSex isEqualToString:@"0"]) {
            _HDDetailCell.joinedpro_label.text = @"只邀请女生";
        }else if ([_YUModel.allowSex isEqualToString:@"1"]){
            _HDDetailCell.joinedpro_label.text = @"只邀请男生";
        }else{
            _HDDetailCell.joinedpro_label.text = @"全部";
        }
        _HDDetailCell.address_label.text = ((YUOrderInfo *)_YUModel.orderInfo).barinfo.address;
        _HDDetailCell.barName_label.text = ((YUOrderInfo *)_YUModel.orderInfo).barinfo.barname;
        [_HDDetailCell.checkAddress_button addTarget:self action:@selector(checkAddress) forControlEvents:UIControlEventTouchUpInside];
        [_HDDetailCell.checkBar_button addTarget:self action:@selector(checkBar) forControlEvents:UIControlEventTouchUpInside];
        _HDDetailCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return _HDDetailCell;
    }else if(indexPath.section == 3){
        _joinedCell = [tableView dequeueReusableCellWithIdentifier:@"JoinedTableViewCell" forIndexPath:indexPath];
        [_joinedCell configureJoinedNumber:[((YUOrderInfo *)_YUModel.orderInfo).allnum intValue]andPeople:((YUOrderInfo *)_YUModel.orderInfo).pinkerList];
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
        int row = ((YUOrderInfo *)_YUModel.orderInfo).pinkerList.count / shang;
        int duoyu = ((YUOrderInfo *)_YUModel.orderInfo).pinkerList.count % shang;
//        int row = 22 / shang;
//        int duoyu = 22 % shang;
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

- (IBAction)WannaJoin:(UIButton *)sender {
    LPAlertView *alertView = [[LPAlertView alloc]initWithDelegate:self buttonTitles:@"取消", @"确定", nil];
    alertView.delegate = self;
    _chooseNumber = [[[NSBundle mainBundle]loadNibNamed:@"ChooseNumber" owner:nil options:nil]firstObject];
    _chooseNumber.tag = 14;
    
    int num = [((YUOrderInfo *)_YUModel.orderInfo).allnum intValue] - (int)((YUOrderInfo *)_YUModel.orderInfo).pinkerList.count;
    _chooseNumber.store = num;
    _chooseNumber.frame = CGRectMake(10, SCREEN_HEIGHT - 320, SCREEN_WIDTH - 20, 250);
    alertView.contentView = _chooseNumber;
    [alertView show];
}

- (void)LPAlertView:(LPAlertView *)alertView clickedButtonAtIndexChooseNum:(NSInteger)buttonIndex{
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

- (void)checkAddress{
    YUOrderInfo *model = _YUModel.orderInfo;
    NSDictionary *dic=@{@"title":model.barinfo.barname,@"latitude":model.barinfo.latitude,@"longitude":model.barinfo.longitude};
    [[LYUserLocation instance] daoHan:dic];
}

- (void)checkBar{
    
}

@end
