//
//  CHJiuPinDetailViewController.m
//  lieyu
//
//  Created by 薛斯岐 on 15/10/23.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "CHJiuPinDetailViewController.h"
#import "LYHomePageHttpTool.h"
#import "PTShowIntroductionsCell.h"
#import "CHTopDetailCell.h"
#import "CHBarCell.h"
#import "CHPorTypeCell.h"
#import "LYCarListViewController.h"
#import "LYUserLocation.h"

#import "AddressTableViewCell.h"
#import "LPAlertView.h"
#import "ChooseNumber.h"
#import "IQKeyboardManager.h"

@interface CHJiuPinDetailViewController ()<UITableViewDataSource,UITableViewDelegate,LPAlertViewDelegate>
{
    CheHeModel *chiHeModel;
}

@property (nonatomic, strong) CHTopDetailCell *danpinCell;
@property (nonatomic, strong) AddressTableViewCell *addressCell;
@property (nonatomic, strong) CHPorTypeCell *typeCell;
@property (nonatomic, strong) PTShowIntroductionsCell *showCell;
@property (nonatomic, strong) RCPublicServiceChatViewController *conversationVC;
@property (nonatomic, strong) ChooseNumber *chooseNumView;

@end

@implementation CHJiuPinDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 40) ;
    self.backImage.hidden = YES;
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    _tableView.showsHorizontalScrollIndicator=NO;
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.bounces = NO;
    _tableView.separatorColor=[UIColor clearColor];
    [self getdata];
//    [self.navigationController.navigationBar setHidden:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}

#pragma mark 获取数据
-(void)getdata{
    NSDictionary *dic=@{@"id":[NSString stringWithFormat:@"%d",self.shopid]};
    __weak __typeof(self)weakSelf = self;
    [[LYHomePageHttpTool shareInstance]getCHDetailWithParams:dic block:^(CheHeModel *result) {
        chiHeModel=result;
        [weakSelf.tableView reloadData];
    }];
}

#pragma mark tableView的各个代理方法实现
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(chiHeModel){
        return 5;
    }else{
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.00001;
}
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    if(section!=2){
//        return [[UIView alloc] initWithFrame:CGRectZero];
//    }else{
//        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 34)];
//        view.backgroundColor=RGB(247, 247, 247);
//        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(15, 11, 200, 12)];
//        
//        label.text=@"酒水消费流程";
//        
//        
//        label.font=[UIFont systemFontOfSize:12];
//        label.textColor=RGB(51, 51, 51);
//        [view addSubview:label];
//        return view;
//    }
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    if(indexPath.section == 0){
        _danpinCell = [tableView dequeueReusableCellWithIdentifier:@"danpinCell"];
        if(!_danpinCell){
            [tableView registerNib:[UINib nibWithNibName:@"DanPinCell" bundle:nil] forCellReuseIdentifier:@"danpinCell"];
            _danpinCell = [tableView dequeueReusableCellWithIdentifier:@"danpinCell"];
        }
        [_danpinCell configureCell:chiHeModel];
        _danpinCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return _danpinCell;
    }else if(indexPath.section == 1){
        _addressCell = [tableView dequeueReusableCellWithIdentifier:@"address"];
        if(!_addressCell){
            [tableView registerNib:[UINib nibWithNibName:@"AddressTableViewCell" bundle:nil] forCellReuseIdentifier:@"address"];
            _addressCell = [tableView dequeueReusableCellWithIdentifier:@"address"];
        }
        [_addressCell cellConfigure:chiHeModel.barinfo.address];
        [_addressCell.addressBtn addTarget:self action:@selector(daohang) forControlEvents:UIControlEventTouchUpInside];
        return _addressCell;
    }else if(indexPath.section == 2){
        cell = [tableView dequeueReusableCellWithIdentifier:@"CHPorTypeCell" forIndexPath:indexPath];
        if (cell) {
            CHPorTypeCell * porTypeCell = (CHPorTypeCell *)cell;
            [porTypeCell.typeBtn setTitle:chiHeModel.category forState:0];
            [porTypeCell.brandBtn setTitle:chiHeModel.brand forState:0];
        }
        return cell;
    }else if(indexPath.section == 3){
        NSString *kCustomCellID = @"QBPeoplePickerControllerCell";
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCustomCellID] ;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor=[UIColor whiteColor];
            UILabel *lal1=[[UILabel alloc]initWithFrame:CGRectMake(15, 37, SCREEN_WIDTH-30, 25)];
            [lal1 setTag:1];
            lal1.textAlignment=NSTextAlignmentLeft;
            lal1.font=[UIFont systemFontOfSize:14];
            lal1.backgroundColor=[UIColor clearColor];
            lal1.textColor= RGB(76, 76, 76);
            lal1.numberOfLines = 0;  //必须定义这个属性，否则UILabel不会换行
//            lal1.text = @"店家发货的设计开发和肯德基啊是否健康的好办法靠近阿斯顿打开了哈风 等级分拉开；放大看哈付款，大方经典款拉链大码，方面，下放劳动啥回复的好风景，你都发空间很大的反馈；了解大陆凤凰健康的好你们， 。，点击放大是否看见大家都快乐的";
            lal1.lineBreakMode = NSLineBreakByWordWrapping;
            [cell.contentView addSubview:lal1];
        }
        
        UILabel *titleLbl = [[UILabel alloc]initWithFrame:CGRectMake(12, 8, 200, 21)];
        titleLbl.text = @"产品说明:";
        titleLbl.font = [UIFont fontWithName:@"Bold" size:18];
        titleLbl.textColor = RGBA(51, 51, 51, 1);
        [cell.contentView addSubview:titleLbl];
        
        UILabel *lal = (UILabel*)[cell viewWithTag:1];
        
        NSString *title = @"";
        
        if([chiHeModel.introduction isEqualToString:@""]){
            title = [NSString stringWithFormat:@"图片仅供参考，具体以实物为准！",chiHeModel.fullname];
        }else{
            title = chiHeModel.introduction;
        }
        
        //高度固定不折行，根据字的多少计算label的宽度
        CGSize size = [title sizeWithFont:lal.font
                        constrainedToSize:CGSizeMake(lal.width, MAXFLOAT)
                            lineBreakMode:NSLineBreakByWordWrapping];
        //        NSLog(@"size.width=%f, size.height=%f", size.width, size.height);
        //根据计算结果重新设置UILabel的尺寸
        lal.height=size.height;
        lal.text=title;
    
        CGRect cellFrame = [cell frame];
        cellFrame.origin=CGPointMake(0, 0);
        cellFrame.size.width=SCREEN_WIDTH;
        cellFrame.size.height=lal.size.height + 50;
//        UILabel *lineLal=[[UILabel alloc]initWithFrame:CGRectMake(15, lal.size.height+ 61 -0.5, 290, 0.5)];
//        lineLal.backgroundColor=RGB(199, 199, 199);
//        [cell addSubview:lineLal];
        [cell setFrame:cellFrame];
        return cell;
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"PTShowIntroductionsCell" forIndexPath:indexPath];
        return cell;
    }
}
#pragma mark 进入导航页面
- (void)daohang{
    NSDictionary *dic=@{@"title":chiHeModel.barinfo.barname,@"latitude":chiHeModel.barinfo.latitude,@"longitude":chiHeModel.barinfo.longitude};
    [[LYUserLocation instance] daoHan:dic];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat h = 0.0f;
    if(indexPath.section == 0){
        h = 118 + SCREEN_WIDTH;
    }else if(indexPath.section == 1){
        h = 60;
    }else if(indexPath.section == 2){
        h = 76;
    }else if (indexPath.section == 3){
        UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.frame.size.height;
    }else{
        h = 45 + SCREEN_WIDTH / 2;
    }
    return h;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==1){
        if(indexPath.row==0){
            
            NSDictionary *dic=@{@"title":chiHeModel.barinfo.barname,@"latitude":chiHeModel.barinfo.latitude,@"longitude":chiHeModel.barinfo.longitude};
            [[LYUserLocation instance] daoHan:dic];
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark -添加购物车
- (IBAction)AddToShopCar:(UIButton *)sender {
    LPAlertView *alertView = [[LPAlertView alloc]initWithDelegate:self buttonTitles:@"取消", @"确定", nil];
    alertView.delegate = self;
    _chooseNumView = [[[NSBundle mainBundle]loadNibNamed:@"ChooseNumber" owner:nil options:nil]firstObject];
    _chooseNumView.tag = 14;
    _chooseNumView.frame = CGRectMake(10, SCREEN_HEIGHT - 320, SCREEN_WIDTH - 20, 250);
    alertView.contentView = _chooseNumView;
    [alertView show];
}

#pragma mark 选择数量后上传
- (void)LPAlertView:(LPAlertView *)alertView clickedButtonAtIndexChooseNum:(NSInteger)buttonIndex{
    if(buttonIndex == 1){
        NSDictionary *dic=@{@"product_id":[NSNumber numberWithInt:chiHeModel.id],
                            @"quantity":_chooseNumView.numberField.text};
        
        
        //统计从吃喝明细页面添加购物车
        NSDictionary *dict = @{@"actionName":@"确定",@"pageName":@"吃喝明细",@"titleName":@"确认数量后加入购物车",@"value":chiHeModel.name};
        [MTA trackCustomKeyValueEvent:@"LYClickEvent" props:dict];
        __weak CHJiuPinDetailViewController *weakSelf = self;
        [[LYHomePageHttpTool shareInstance] addCarWithParams:dic block:^(BOOL result) {
            if (result) {
                [MyUtil showCleanMessage:@"添加购物车成功!"];
                [weakSelf.refreshNumDelegate getNumAdd];
            }
        }];
    }
    [alertView hide];
    
}

#pragma  mark 消失
-(void)SetViewDisappear:(id)sender{
    
    if (_bgView)
    {
        _bgView.backgroundColor=[UIColor clearColor];
        [UIView animateWithDuration:.5
                         animations:^{
                             
                             numView.top=-numView.height;
                             surebutton.top=SCREEN_HEIGHT;
//                             _bgView.frame=CGRectMake(0, -SCREEN_HEIGHT, self.view.frame.size.width, self.view.frame.size.height);
                             _bgView.alpha=0.0;
                         }];
        [_bgView performSelector:@selector(removeFromSuperview)
                      withObject:nil
                      afterDelay:2];
        
        _bgView=nil;
    }
    
}
#pragma mark 选择数量后点击确定加入购物车
-(void)sureAct:(id)sender{
    [self SetViewDisappear:nil];
    //统计从吃喝明细页面添加购物车
    NSDictionary *dict = @{@"actionName":@"确定",@"pageName":@"吃喝明细",@"titleName":@"加入购物车",@"value":chiHeModel.name};
    [MTA trackCustomKeyValueEvent:@"LYClickEvent" props:dict];
    
    NSDictionary *dic=@{@"product_id":[NSNumber numberWithInt:chiHeModel.id],@"quantity":numView.numLal.text};
    [[LYHomePageHttpTool shareInstance] addCarWithParams:dic block:^(BOOL result) {
        if (result) {
            [MyUtil showCleanMessage:@"添加购物车成功!"];
        }
    }];
}

#pragma mark - 出现顶部紫色框
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y > SCREEN_WIDTH - 64) {
        self.backImage.hidden = NO;
        self.backImage.layer.shadowRadius = 2;
        self.backImage.layer.shadowOpacity = 0.5;
        self.backImage.layer.shadowOffset = CGSizeMake(0, 1);
        self.backImage.layer.shadowColor = [[UIColor lightGrayColor]CGColor];
    }else{
        self.backImage.hidden = YES;
    }
}

#pragma mark -购物车
- (IBAction)showShopCar:(UIButton *)sender {
    LYCarListViewController *carListViewController=[[LYCarListViewController alloc]initWithNibName:@"LYCarListViewController" bundle:nil];
    carListViewController.title=@"购物车";
    
    NSDictionary *dict = @{@"actionName":@"跳转",@"pageName":@"吃喝明细",@"titleName":@"进入购物车"};
    [MTA trackCustomKeyValueEvent:@"LYClickEvent" props:dict];
    
    [self.navigationController pushViewController:carListViewController animated:YES];
}

#pragma mark 猎娱客服
- (IBAction)LYkefu:(UIButton *)sender {
    //统计我的页面的选择
    NSDictionary *dict1 = @{@"actionName":@"跳转",@"pageName":@"吃喝明细",@"titleName":@"客服"};
    [MTA trackCustomKeyValueEvent:@"LYClickEvent" props:dict1];
    
    _conversationVC = [[RCPublicServiceChatViewController alloc] init];
    _conversationVC.conversationType = ConversationType_APPSERVICE;;
    _conversationVC.targetId = @"KEFU144946169476221";
    [_conversationVC.navigationController.navigationBar setHidden:NO];
//    _conversationVC.userName = @"猎娱客服";
    _conversationVC.title = @"猎娱客服";
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].isAdd = YES;
    [USER_DEFAULT setObject:@"0" forKey:@"needCountIM"];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(-10, 0, 44, 44)];
    [button setImage:[UIImage imageNamed:@"backBtn"] forState:UIControlStateNormal];
    [view addSubview:button];
    [button addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:view];
    _conversationVC.navigationItem.leftBarButtonItem = item;
    [self.navigationController pushViewController:_conversationVC animated:YES];

}

- (void)backBtnClick{
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].isAdd = NO;
    [USER_DEFAULT setObject:@"1" forKey:@"needCountIM"];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 立即下单
- (IBAction)buyNow:(UIButton *)sender {
}

#pragma mark 返回按钮
- (IBAction)backAct:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
