//
//  DWTaoCanXQViewController.m
//  lieyu
//
//  Created by 薛斯岐 on 15/10/21.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "DWTaoCanXQViewController.h"
#import "LYTitleInfoCell.h"
#import "LYHomePageHttpTool.h"
#import "TaoCanModel.h"
#import "DWSureOrderViewController.h"
#import "LYTaoCanHeaderTableViewCell.h"
#import "LYBarPointTableViewCell.h"
#import "LYTaoCanContentTableViewCell.h"
#import "LYTaoCanListTableViewCell.h"
#import "UMSocial.h"
#import "LYUserHttpTool.h"
#import "LYUserLocation.h"
#import "LPAttentionViewController.h"
#import "JiuBaModel.h"
#import "IQKeyboardManager.h"

#define TAOCANDETAILPAGE_MTA @"TAOCANDETAILPAGE"

@interface DWTaoCanXQViewController ()<UITableViewDelegate>
{
    TaoCanModel *taoCanModel;
    LYTaoCanHeaderTableViewCell *_headerCell;
    UIButton *backBtn;
    UIButton *collectBtn;
    UIButton *shareBtn;
}
@end

@implementation DWTaoCanXQViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     _tableView.frame = CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    _tableView.showsHorizontalScrollIndicator=NO;
    _tableView.showsVerticalScrollIndicator=NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.edgesForExtendedLayout = UIRectEdgeAll;
    _tableView.separatorColor=[UIColor clearColor];
    [self getdata];
    // Do any additional setup after loading the view.
    [self setTableViewCell];
    [self createButton];
    
    self.image_header.hidden = YES;
    self.btn_back.hidden = YES;
    self.btn_collect.hidden = YES;
    self.btn_share.hidden = YES;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent] ;
    [self.btn_back addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.btn_collect addTarget:self action:@selector(collectClick) forControlEvents:UIControlEventTouchUpInside];
    [self.btn_share addTarget:self action:@selector(shareClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent] ;
}

- (void)createButton{
    backBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 26, 32, 32)];
//    [backBtn setBackgroundImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    CGFloat collectBtnWidth = 32;
    collectBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 64 - collectBtnWidth, 26, collectBtnWidth, collectBtnWidth)];
    [collectBtn setBackgroundImage:[UIImage imageNamed:@"icon_collect_2"] forState:UIControlStateNormal];
//    [collectBtn setImage:[UIImage imageNamed:@"icon_collect_2"] forState:UIControlStateNormal];
    [collectBtn addTarget:self action:@selector(collectClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:collectBtn];
    
    shareBtn = [[UIButton alloc]initWithFrame:CGRectMake( SCREEN_WIDTH - 8 - collectBtnWidth, 26, collectBtnWidth, collectBtnWidth)];
    [shareBtn setBackgroundImage:[UIImage imageNamed:@"icon_share2"] forState:UIControlStateNormal];
//    [shareBtn setImage:[UIImage imageNamed:@"icon_share2"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:shareBtn];
}

- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

//- (void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//     [self.navigationController setNavigationBarHidden:NO];
//}

#pragma mark 收藏按钮action
- (void)collectClick{
    NSDictionary *dic=@{@"barid":@(_jiubaModel.barid)};
    [[LYUserHttpTool shareInstance] addMyBarWithParams:dic complete:^(BOOL result) {
        if(result){
            [MyUtil showMessage:@"收藏成功"];
        }
    }];
    [MTA trackCustomKeyValueEvent:LYCLICK_MTA props:[self createMTADctionaryWithActionName:@"收藏" pageName:TAOCANDETAILPAGE_MTA titleName:_jiubaModel.barname]];
//    [MTA trackCustomKeyValueEvent:LYCLICK_MTA props:[self createMTADctionaryWithActionName:@"喜欢" pageName:BEERBARDETAIL_MTA titleName:_jiubaModel.barname]];
}

- (void)shareClick{
     NSString *string= [NSString stringWithFormat:@"大家一起来看看～%@酒吧不错啊!下载猎娱App即可优惠下单，还有超值返利。http://www.lie98.com",_jiubaModel.barname];
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeText;
    //    [UMSocialSnsService presentSnsController:self
    //                                appKey:UmengAppkey
    //                                shareText:string
    //                                shareImage:self.barinfoCell.barImage.image
    //                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSms,nil]
    //                                delegate:self];
    [UMSocialSnsService presentSnsIconSheetView:self appKey:UmengAppkey shareText:string shareImage:_headerCell.imageView_header.image shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina,UMShareToSms,nil] delegate:nil];
    [MTA trackCustomKeyValueEvent:LYCLICK_MTA props:[self createMTADctionaryWithActionName:@"分享" pageName:TAOCANDETAILPAGE_MTA titleName:_jiubaModel.barname]];
}

- (void)setTableViewCell{
    [self.tableView registerNib:[UINib nibWithNibName:@"LYTaoCanHeaderTableViewCell" bundle:nil] forCellReuseIdentifier:@"LYTaoCanHeaderTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"LYBarPointTableViewCell" bundle:nil] forCellReuseIdentifier:@"LYBarPointTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"LYTaoCanContentTableViewCell" bundle:nil] forCellReuseIdentifier:@"LYTaoCanContentTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"LYTaoCanListTableViewCell" bundle:nil] forCellReuseIdentifier:@"LYTaoCanListTableViewCell"];
}

#pragma mark 获取数据
-(void)getdata{
    NSDictionary *dic=@{@"smid":[NSString stringWithFormat:@"%d",self.smid]};
    __weak __typeof(self)weakSelf = self;
    [[LYHomePageHttpTool shareInstance]getWoYaoDinWeiTaoCanDetailWithParams:dic block:^(TaoCanModel *result) {
        taoCanModel = result;
        [weakSelf.tableView reloadData];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
    
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
    if (!section) {
        return 0.0001;
    }
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc]init];
}

#pragma mark -scrollViewDidScroll
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y > SCREEN_WIDTH - 64) {
        self.image_header.hidden = NO;
        self.btn_share.hidden = NO;
        self.btn_collect.hidden = NO;
        self.btn_back.hidden = NO;
        backBtn.hidden = YES;
        collectBtn.hidden = YES;
        shareBtn.hidden = YES;
        self.image_header.layer.shadowRadius = 2;
        self.image_header.layer.shadowOpacity = 0.8;
        self.image_header.layer.shadowOffset = CGSizeMake(0, 1);
        self.image_header.layer.shadowColor = [[UIColor blackColor]CGColor];
    }else{
        self.image_header.hidden = YES;
        self.btn_share.hidden = YES;
        self.btn_collect.hidden = YES;
        self.btn_back.hidden = YES;
        backBtn.hidden = NO;
        collectBtn.hidden = NO;
        shareBtn.hidden = NO;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    switch (indexPath.section)
    {
        case 0:
        {
            _headerCell = [tableView dequeueReusableCellWithIdentifier:@"LYTaoCanHeaderTableViewCell" forIndexPath:indexPath];
            _headerCell.model = taoCanModel;
            _headerCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return _headerCell;
        }
            break;
        case 1:
        {
            /*
            cell = [tableView dequeueReusableCellWithIdentifier:@"LYTitleInfoCell" forIndexPath:indexPath];
            if (cell) {
                LYTitleInfoCell * titleInfoCell = (LYTitleInfoCell *)cell;
                titleInfoCell.titleLal.text=@"套餐时间";
                titleInfoCell.delLal.text=_dateStr;
                
            }
             */
            LYBarPointTableViewCell *pointCell = [tableView dequeueReusableCellWithIdentifier:@"LYBarPointTableViewCell" forIndexPath:indexPath];
            pointCell.label_point.text = _jiubaModel.address;
            pointCell.selectionStyle = UITableViewCellSelectionStyleNone;
            pointCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return pointCell;
        }
            break;
        case 2:
        {
            //套餐时间
            cell = [tableView dequeueReusableCellWithIdentifier:@"LYTitleInfoCell" forIndexPath:indexPath];
            if (cell) {
                LYTitleInfoCell * titleInfoCell = (LYTitleInfoCell *)cell;
                titleInfoCell.titleLal.text=@"套餐时间";
                titleInfoCell.delLal.text= [NSString stringWithFormat:@"%@ %@",_dateStr,_weekStr];
            }
        }
            break;
        case 3://套餐内容
        {
            LYTaoCanListTableViewCell *listCell = [tableView dequeueReusableCellWithIdentifier:@"LYTaoCanListTableViewCell" forIndexPath:indexPath];
            listCell.goodListArray = taoCanModel.goodsList;
            listCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return listCell;
        }
            break;
        case 4:
        {
            LYTaoCanContentTableViewCell *contentCell = [tableView dequeueReusableCellWithIdentifier:@"LYTaoCanContentTableViewCell" forIndexPath:indexPath];
            contentCell.label_desrc.text = taoCanModel.introduction;
            contentCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return contentCell;
        
        }
            break;
            
        default:
        {
            LYTaoCanListTableViewCell *progressCell = [tableView dequeueReusableCellWithIdentifier:@"LYTaoCanListTableViewCell" forIndexPath:indexPath];
            progressCell.isProgress = YES;
            progressCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return progressCell;
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
            h = SCREEN_WIDTH + 146;
        }
            break;
        case 1:// 选项卡 ，酒吧或夜总会
        {
            h = 60;
        }
            break;
        case 2:// 选项卡 ，酒吧或夜总会
        {
            h = 40;
        }
            break;
        case 3:// 选项卡 ，酒吧或夜总会
        {
            h = 40 + taoCanModel.goodsList.count * 50;
        }
            break;
        case 4:// 选项卡 ，酒吧或夜总会
        {
            CGSize size = [taoCanModel.introduction boundingRectWithSize:CGSizeMake(320, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
                                                                                                                                    return size.height+44+22;
        }
            break;
        default:
        {
            h = (SCREEN_WIDTH - 16) * 311 / 608 + 52;
        }
            break;
    }
    return h;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        NSDictionary *dic=@{@"title":_jiubaModel.barname,@"latitude":_jiubaModel.latitude,@"longitude":_jiubaModel.longitude};
        [[LYUserLocation instance] daoHan:dic];
        [MTA trackCustomKeyValueEvent:LYCLICK_MTA props:[self createMTADctionaryWithActionName:@"地图导航" pageName:TAOCANDETAILPAGE_MTA titleName:taoCanModel.barinfo.barname]];
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
#pragma mark - 咨询
- (IBAction)queryAct:(UIButton *)sender {
    RCPublicServiceChatViewController *conversationVC = [[RCPublicServiceChatViewController alloc] init];
    conversationVC.conversationType = ConversationType_APPSERVICE;
    conversationVC.targetId = @"KEFU144946169476221";//KEFU144946169476221 KEFU144946167494566  测试
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
    [MTA trackCustomKeyValueEvent:LYCLICK_MTA props:[self createMTADctionaryWithActionName:@"跳转" pageName:TAOCANDETAILPAGE_MTA titleName:@"咨询猎娱"]];
}

- (void)backForword{
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].isAdd = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 注意事项
- (IBAction)warnAct:(UIButton *)sender {
    LPAttentionViewController *LPattentionVC = [[UIStoryboard storyboardWithName:@"NewMain" bundle:[NSBundle mainBundle]]instantiateViewControllerWithIdentifier:@"LPattention"];
    [self.navigationController pushViewController:LPattentionVC animated:YES];
    [MTA trackCustomKeyValueEvent:LYCLICK_MTA props:[self createMTADctionaryWithActionName:@"跳转" pageName:TAOCANDETAILPAGE_MTA titleName:@"注意事项"]];
}
#pragma mark - 马上购买
- (IBAction)payAct:(UIButton *)sender {
    UIStoryboard *stroyBoard=[UIStoryboard storyboardWithName:@"NewMain" bundle:nil];
    DWSureOrderViewController *sureOrderViewController=[stroyBoard instantiateViewControllerWithIdentifier:@"DWSureOrderViewController"];
    sureOrderViewController.title=@"确认订单";
    sureOrderViewController.smid=taoCanModel.smid;
    sureOrderViewController.dateStr=self.dateStr;
    [self.navigationController pushViewController:sureOrderViewController animated:YES];
    [MTA trackCustomKeyValueEvent:LYCLICK_MTA props:[self createMTADctionaryWithActionName:@"跳转" pageName:TAOCANDETAILPAGE_MTA titleName:@"确认订单"]];
}
@end
