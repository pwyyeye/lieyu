//
//  BeerBarDetailViewController.m
//  lieyu
//
//  Created by newfly on 9/19/15.
//  Copyright © 2015 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "BeerBarDetailViewController.h"
#import "MacroDefinition.h"
#import "LYShareSnsView.h"
#import "UMSocial.h"
#import "LYColors.h"
#import "LYToPlayRestfulBusiness.h"
#import "BeerBarOrYzhDetailModel.h"
#import "RecommendPackageModel.h"
#import "LYwoYaoDinWeiMainViewController.h"
#import "CHshowDetailListViewController.h"
#import "DWTaoCanXQViewController.h"
#import "LYUserLocation.h"
#import "MyZSManageViewController.h"
#import "LYHeaderTableViewCell.h"
#import "LYBarTitleTableViewCell.h"
#import "LYBarPointTableViewCell.h"
#import "LYBarSpecialTableViewCell.h"
#import "LYBarDescTitleTableViewCell.h"
#import "LYBarDescTableViewCell.h"
#import "LYUserHttpTool.h"
#import "LYHomePageHttpTool.h"
#import "CHViewController.h"
#import "ChiHeViewController.h"

#define COLLECTKEY /*@"USERCOLLECT"*/  [NSString stringWithFormat:@"%@%@sc",_userid,self.beerBarDetail.barid]
#define LIKEKEY /*@"USERLIKE"*/ [NSString stringWithFormat:@"%@%@",_userid,self.beerBarDetail.barid]

@interface BeerBarDetailViewController ()<UIWebViewDelegate,UIScrollViewDelegate>
{
    NSManagedObjectContext *_context;
    NSString *_userid;
    UIWebView *_webView;
    LYHeaderTableViewCell *_headerCell;
    LYBarTitleTableViewCell *_barTitleCell;
    NSInteger _timeCount;
    CGSize _size;
    NSTimer *_timer;
}

@property(nonatomic,strong)NSMutableArray *aryList;
@property (weak, nonatomic) IBOutlet UIImageView *image_layer;
@property(nonatomic,weak)IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *image_like;
@property(nonatomic,weak)IBOutlet UIView *bottomBarView;
@property (weak, nonatomic) IBOutlet UIButton *btn_like;
@property(nonatomic,assign)CGFloat dyBarDetailH;
@property(nonatomic,strong) BeerBarOrYzhDetailModel *beerBarDetail;

@end

@implementation BeerBarDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     [self loadBarDetail];                                                       //load data
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    _tableView.showsHorizontalScrollIndicator=NO;
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.separatorColor=[UIColor clearColor];
     self.tableView.scrollEnabled = NO;
    
    self.navigationController.navigationBarHidden=YES;
    _scrollView.delegate = self;
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH,self.tableView.frame.size.height);
    self.scrollView.showsVerticalScrollIndicator=NO;
    self.scrollView.showsHorizontalScrollIndicator=NO;
    [self setupViewStyles];                                                     //tableView registe cell
    _scrollView.bounces = NO;

    self.image_layer.hidden = YES;
    
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    _context = app.managedObjectContext;
    _userid = [NSString stringWithFormat:@"%d",app.userModel.userid];
}

//喜欢按钮圆角
- (void)setUpBtn_like{
    self.btn_like.layer.cornerRadius = CGRectGetWidth(self.btn_like.frame)/2.0;
    self.btn_like.layer.masksToBounds = YES;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
     [_timer setFireDate:[NSDate distantPast]];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden=NO;
    
    [_timer setFireDate:[NSDate distantFuture]];
    
    
    
}
//-(void)viewDidDisappear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//    self.navigationController.navigationBarHidden=NO;
//}

#pragma mart --约束
-(void)updateViewConstraints{
    [super updateViewConstraints];
     NSLog(@"------->%ld",self.beerBarDetail.isSign);
    if (self.beerBarDetail.isSign==0) {
        _buttomViewHeight.constant=0;
       
    }else{
        _buttomViewHeight.constant=49;
    }
    
}

- (void)loadBarDetail
{
    __weak __typeof(self ) weakSelf = self;
    LYToPlayRestfulBusiness * bus = [[LYToPlayRestfulBusiness alloc] init];
    [bus getBearBarOrYzhDetail:_beerBarId results:^(LYErrorMessage *erMsg, BeerBarOrYzhDetailModel *detailItem)
    {
        if (erMsg.state == Req_Success) {
            weakSelf.beerBarDetail = detailItem;
            
            
            //判断用户是否已经喜欢过
            
            NSLog(@"------>%@-------%@",[[NSUserDefaults standardUserDefaults] valueForKey:LIKEKEY],LIKEKEY);
            if ([[NSUserDefaults standardUserDefaults] valueForKey:LIKEKEY]) {
                //收藏过
                [self.btn_like setBackgroundImage:[UIImage imageNamed:@"icon_like2"] forState:UIControlStateNormal];
            }
            //if(_timer){
            [_timer setFireDate:[NSDate distantPast]];
            //_timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(onTime) userInfo:nil repeats:YES];
            // }
            
            if ([[NSUserDefaults standardUserDefaults] valueForKey:COLLECTKEY]) {
                [self.btn_collect setBackgroundImage:[UIImage imageNamed:@"icon_collect2"] forState:UIControlStateNormal];
            }
            
            
            [weakSelf updateViewConstraints];
            [weakSelf.tableView reloadData];
            //加载webview
            
            [weakSelf loadWebView];
            [weakSelf setTimer];
        }
    }];
}

- (void)setTimer{
    if (_timer == nil){
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.03 target:self selector:@selector(onTime) userInfo:nil repeats:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y > SCREEN_WIDTH/16*9 - self.image_layer.size.height) {
        self.image_layer.hidden = NO;
    }else{
        self.image_layer.hidden = YES;
    }
}


// load webView
- (void)loadWebView{
    _webView = [[UIWebView alloc]initWithFrame:CGRectZero];
    
    NSString *webStr = [NSString stringWithFormat:@"<head><meta name=\"viewport\" content=\"width=device-width, initial-scale=1, maximum-scale=1, minimum-scale=1, user-scalable=no\" charset=\"utf-8\"/></head><body><div id=\"webview_content_wrapper\">%@</div><script type=\"text/javascript\">var imgs = document.getElementsByTagName('img');for(var i = 0; i<imgs.length; i++){imgs[i].style.width = '303';imgs[i].style.height = 'auto';imgs[i].style.margin=0;}</script></body>",self.beerBarDetail.descriptions];
    
    _webView.delegate = self;
    [_webView sizeToFit];
    [_webView.scrollView setScrollEnabled:NO];
    _webView.scalesPageToFit = YES;
    [_webView loadHTMLString:webStr baseURL:nil];
    [self.scrollView addSubview:_webView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --返回按钮
- (IBAction)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --喜欢按钮
- (IBAction)likeClick:(UIButton *)sender {
     __weak BeerBarDetailViewController *weakSelf = self;
     NSDictionary * param = @{@"barid":self.beerBarDetail.barid};
    //判断用户是否已经喜欢过
    if ([[NSUserDefaults standardUserDefaults] valueForKey:LIKEKEY]) {
        
        [[LYHomePageHttpTool shareInstance] unLikeJiuBa:param compelete:^(bool result) {
            //收藏过
            if(result){
            [weakSelf.btn_like setBackgroundImage:[UIImage imageNamed:@"icon_like_2"] forState:UIControlStateNormal];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey: LIKEKEY];
             [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }];
    }else{
    [[LYHomePageHttpTool shareInstance] likeJiuBa:param compelete:^(bool result) {
        if (result) {
            [weakSelf.btn_like setBackgroundImage:[UIImage imageNamed:@"icon_like2"] forState:UIControlStateNormal];
            
            [[NSUserDefaults standardUserDefaults] setObject:weakSelf.beerBarDetail.barid forKey:LIKEKEY];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            NSLog(@"---->%@", [[NSUserDefaults standardUserDefaults] valueForKey:LIKEKEY]);
        }
    }];
    }
}

//注册单元格
- (void)setupViewStyles
{
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [_tableView registerNib:[UINib nibWithNibName:@"LYHeaderTableViewCell" bundle:nil] forCellReuseIdentifier:@"LYHeaderTableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"LYBarTitleTableViewCell" bundle:nil] forCellReuseIdentifier:@"LYBarTitleTableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"LYBarPointTableViewCell" bundle:nil] forCellReuseIdentifier:@"LYBarPointTableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"LYBarSpecialTableViewCell" bundle:nil] forCellReuseIdentifier:@"LYBarSpecialTableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"LYBarDescTitleTableViewCell" bundle:nil] forCellReuseIdentifier:@"LYBarDescTitleTableViewCell"];
    [_tableView registerClass:[LYBarDescTableViewCell class] forCellReuseIdentifier:@"LYBarDescTableViewCell"];
    
    self.bottomBarView.backgroundColor = [LYColors tabbarBgColor];
    //_dyBarDetailH = [BeerBarDetailCell adjustCellHeight:nil];
}



#pragma mark-- webview delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    //获取页面高度（像素）
    NSString * clientheight_str = [webView stringByEvaluatingJavaScriptFromString: @"document.getElementById('webview_content_wrapper').offsetHeight"];//scroll
    float clientheight = [clientheight_str floatValue];
    //设置到WebView上
     webView.frame = CGRectMake(0,0, SCREEN_WIDTH, clientheight);
    //获取WebView最佳尺寸（点）
    CGSize frame = [webView sizeThatFits:webView.frame.size];
    //获取内容实际高度（像素）
//    NSString * height_str= [webView stringByEvaluatingJavaScriptFromString: @"document.getElementById('webview_content_wrapper').offsetHeight;"];
//    float height = [height_str floatValue];
    //内容实际高度（像素）* 点和像素的比
//    height = height * frame.height / clientheight;
    //再次设置WebView高度（点）
//    NSLog(@"--->%f",height);
    webView.frame = CGRectMake(0, self.tableView.frame.size.height-70, 320, frame.height-50);
//    webView.backgroundColor = [UIColor redColor];
    
    _scrollView.contentSize=CGSizeMake(SCREEN_WIDTH, self.tableView.frame.size.height+webView.frame.size.height);
    
    
//  CGFloat offsetHeight = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
//    
//    NSLog(@"----pass-pass%f---",offsetHeight);
//     webView.frame = CGRectMake(0, self.tableView.frame.size.height-70, 320, offsetHeight+100);
//    _scrollView.contentSize=CGSizeMake(SCREEN_WIDTH, self.tableView.frame.size.height+webView.frame.size.height);
    
  

}


#pragma mark -- tableviewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    switch (indexPath.section)
    {
        case 0:
        {
            _headerCell = [tableView dequeueReusableCellWithIdentifier:@"LYHeaderTableViewCell" forIndexPath:indexPath];
            _size = [self.beerBarDetail.announcement.content boundingRectWithSize:CGSizeMake(MAXFLOAT, 18) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
            _headerCell.label_laBa.frame = CGRectMake(SCREEN_WIDTH, CGRectGetMinY(_headerCell.label_laBa.frame), _size.width, 18);
                                                                                                                                                                            
                                                                                                                                                            
            _headerCell.label_laBa.text = self.beerBarDetail.announcement.content;
            
            
            NSMutableArray *bigArr=[[NSMutableArray alloc]init];
            for (NSString *iconStr in self.beerBarDetail.banners) {
                NSMutableDictionary *dicTemp=[[NSMutableDictionary alloc]init];
                [dicTemp setObject:iconStr forKey:@"ititle"];
                [dicTemp setObject:@"" forKey:@"mainHeading"];
                [bigArr addObject:dicTemp];
            }
            EScrollerView *scroller=[[EScrollerView alloc] initWithFrameRect:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/16*9)
                                                                  scrolArray:[NSArray arrayWithArray:bigArr] needTitile:YES];

            [_headerCell addSubview:scroller];

            
            _headerCell.selectionStyle = UITableViewCellSelectionStyleNone;

            return _headerCell;

        }
            break;
        case 1:
        {
           
            _barTitleCell = [tableView dequeueReusableCellWithIdentifier:@"LYBarTitleTableViewCell" forIndexPath:indexPath];
            [_barTitleCell.imageView_header sd_setImageWithURL:[NSURL URLWithString:self.beerBarDetail.baricon] placeholderImage:[UIImage imageNamed:@"empyImage120"]];
            
            
            CGSize nameSize = [self.beerBarDetail.barname boundingRectWithSize:CGSizeMake(150, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16]} context:nil].size;
            if (nameSize.height < 30) {
                 _barTitleCell.label_name.text = [NSString stringWithFormat:@"%@\n",self.beerBarDetail.barname];
            }else{
            
            _barTitleCell.label_name.text = self.beerBarDetail.barname;
            }
            
            if (![MyUtil isEmptyString:self.beerBarDetail.environment_num] ) {
                _barTitleCell.barStar.value=self.beerBarDetail.environment_num.floatValue;
            }else{
                _barTitleCell.barStar.value=3.0;
            }
            NSString *priceStr;
            if (self.beerBarDetail.lowest_consumption==nil) {
                 priceStr= [NSString stringWithFormat:@"¥%@起",@"    "];
            }else{
                 priceStr= [NSString stringWithFormat:@"¥%@起",self.beerBarDetail.lowest_consumption];
            }
            
            NSInteger a = 0 ;
            NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:priceStr];
            
            if ([self.beerBarDetail.lowest_consumption integerValue] > 9) {
                a = 2;
            }
            if ([self.beerBarDetail.lowest_consumption integerValue] > 99){
                a = 3;
            }
            if([self.beerBarDetail.lowest_consumption integerValue] > 999){
                a = 4;
            }
            [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(1, a)];
            
            _barTitleCell.label_price.attributedText = attributedStr;
            
            for (int i = 0;i < 5;i ++) {
                UIImageView *imageView = _barTitleCell.imageView_starArray[i];
                imageView.image = [UIImage imageNamed:@"starGray"];
            }
            if ([self.beerBarDetail.star_num integerValue]) {
                for (int y = 0; y < [self.beerBarDetail.star_num integerValue]; y++) {
                    UIImageView *imageView = _barTitleCell.imageView_starArray[y];
                    imageView.image = [UIImage imageNamed:@"starRed"];
                }
            }
            _barTitleCell.selectionStyle = UITableViewCellSelectionStyleNone;
            CGFloat fanliFloat = self.beerBarDetail.rebate * self.beerBarDetail.lowest_consumption.floatValue;
            _barTitleCell.label_fanli_num.text = [NSString stringWithFormat:@"¥%.0f起",fanliFloat];
            return _barTitleCell;
            
        }
            break;
            case 2:
        {
            LYBarPointTableViewCell *barPointCell = [tableView dequeueReusableCellWithIdentifier:@"LYBarPointTableViewCell" forIndexPath:indexPath];
            barPointCell.label_point.text = self.beerBarDetail.address;
            barPointCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                        barPointCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return barPointCell;
        }
            break;
            case 3://酒吧特色
        {
            LYBarSpecialTableViewCell *barSpecialCell = [tableView dequeueReusableCellWithIdentifier:@"LYBarSpecialTableViewCell" forIndexPath:indexPath];
            
            [barSpecialCell configureCell:self.beerBarDetail];
            
                                   barSpecialCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return barSpecialCell;
        }
            break;
        case 4:
        {
            LYBarDescTableViewCell *barDescTitleCell = [tableView dequeueReusableCellWithIdentifier:@"LYBarDescTableViewCell" forIndexPath:indexPath];
            barDescTitleCell.title = self.beerBarDetail.subtitle;
            barDescTitleCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return barDescTitleCell;
            
        }
            break;
        default:
            break;

    }
    return cell;
}

- (void)onTime{
    _timeCount ++;
    _headerCell.label_laBa.frame = CGRectMake(SCREEN_WIDTH - _timeCount, CGRectGetMinY(_headerCell.label_laBa.frame), _size.width, 18);
    _headerCell.image_laBa.frame = CGRectMake(CGRectGetMinX(_headerCell.label_laBa.frame) - CGRectGetWidth(_headerCell.image_laBa.frame), CGRectGetMinY(_headerCell.image_laBa.frame), _headerCell.image_laBa.frame.size.width,_headerCell.image_laBa.frame.size.height );
//    _headerCell.label_laBa.center = CGPointMake(_size.width/2.0 + SCREEN_WIDTH - _timeCount, _headerCell.label_laBa.center.y);
    NSString *width = [NSString stringWithFormat:@"%.0f",_size.width];
    if (_headerCell.label_laBa.frame.origin.x == -width.integerValue) {
        _timeCount = 0;
       _headerCell.label_laBa.frame = CGRectMake(SCREEN_WIDTH, CGRectGetMinY(_headerCell.label_laBa.frame), _size.width, 18);
    }
    [_headerCell bringSubviewToFront:_headerCell.image_laBa];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc]init];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 8;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc]init];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat h = 0.0;
    switch (indexPath.section) {
        case 0:
        {
            return 220;
        }
            break;
        case 1:
        {
            return 77;
        }
            break;
        case 2:
        {
            return 60;
        }
            break;
        case 3:
        {
            return 105;
        }
            break;
            
        default:
        {
            return 76;

        }
            break;
    }
        return h;
}

#pragma mark 分享按钮
- (IBAction)shareClick:(id)sender {
    NSString *string=@"大家一起来看看～猎娱不错啊! http://www.lie98.com\n";
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeText;
    //    [UMSocialSnsService presentSnsController:self
    //                                appKey:UmengAppkey
    //                                shareText:string
    //                                shareImage:self.barinfoCell.barImage.image
    //                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSms,nil]
    //                                delegate:self];
    [UMSocialSnsService presentSnsIconSheetView:self appKey:UmengAppkey shareText:string shareImage:_barTitleCell.imageView_header.image shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToSina,UMShareToWechatTimeline,UMShareToSms,nil] delegate:nil];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
//        _image_layer.userInteractionEnabled = NO;
        [self daohang];
    }
}

#pragma 进入地图
- (void)daohang{
    NSDictionary *dic=@{@"title":self.beerBarDetail.barname,@"latitude":self.beerBarDetail.latitude,@"longitude":self.beerBarDetail.longitude};
    [[LYUserLocation instance] daoHan:dic];
}

- (void)dealloc
{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }

    NSLog(@"dealoc bardetail viewcontroller");
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark-- 底部三个按钮方法

- (IBAction)dianweiAct:(UIButton *)sender {
    LYwoYaoDinWeiMainViewController *woYaoDinWeiMainViewController=[[LYwoYaoDinWeiMainViewController alloc]initWithNibName:@"LYwoYaoDinWeiMainViewController" bundle:nil];
    woYaoDinWeiMainViewController.barid=_beerBarDetail.barid.intValue;
    [self.navigationController pushViewController:woYaoDinWeiMainViewController animated:YES];
}

- (IBAction)chiHeAct:(UIButton *)sender {
    ChiHeViewController *CHDetailVC = [[ChiHeViewController alloc]initWithNibName:@"ChiHeViewController" bundle:[NSBundle mainBundle]];
    CHDetailVC.title=@"吃喝专场";
    CHDetailVC.barid=_beerBarDetail.barid.intValue;
    CHDetailVC.barName=_beerBarDetail.barname;
    [self.navigationController pushViewController:CHDetailVC animated:YES];
}

- (IBAction)zsliAct:(UIButton *)sender {
    MyZSManageViewController *myZSManageViewController=[[MyZSManageViewController alloc]initWithNibName:@"MyZSManageViewController" bundle:nil];
    myZSManageViewController.title=@"专属经理";
    myZSManageViewController.barid=_beerBarDetail.barid.intValue;
    myZSManageViewController.isBarVip=true;
    [self.navigationController pushViewController:myZSManageViewController animated:YES];
}

- (IBAction)soucangAct:(UIButton *)sender {
    
    NSDictionary *dic=@{@"barid":self.beerBarDetail.barid};
    
    
    __weak BeerBarDetailViewController *weakSelf = self;
    //判断用户是否已经收藏过
    if ([[NSUserDefaults standardUserDefaults] valueForKey:COLLECTKEY]) {
        
        [[LYUserHttpTool shareInstance] delMyBarWithParams:dic complete:^(BOOL result) {
            //收藏过
            [weakSelf.btn_collect setBackgroundImage:[UIImage imageNamed:@"icon_collect_2"] forState:UIControlStateNormal];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:COLLECTKEY];
            [[NSUserDefaults standardUserDefaults] synchronize];
               
        }];
    }else{
    
    [[LYUserHttpTool shareInstance] addMyBarWithParams:dic complete:^(BOOL result) {
            [weakSelf.btn_collect setBackgroundImage:[UIImage imageNamed:@"icon_collect2"] forState:UIControlStateNormal];
            [[NSUserDefaults standardUserDefaults] setObject:self.beerBarDetail.barid forKey:COLLECTKEY];
            [[NSUserDefaults standardUserDefaults] synchronize];
    }];
    }
}
@end
