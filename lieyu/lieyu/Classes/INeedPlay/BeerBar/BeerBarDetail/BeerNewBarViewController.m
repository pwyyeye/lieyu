//
//  BeerBarDetailViewController.m
//  lieyu
//
//  Created by newfly on 9/19/15.
//  Copyright © 2015 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "BeerNewBarViewController.h"
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
#import "ChiHeViewController.h"
#import "MyBarModel.h"
#import "LYUserLoginViewController.h"
#import "zujuViewController.h"
#import "PinkerShareController.h"

#import "LYBarIconTableViewCell.h"
#import "LYBarScrollTableViewCell.h"
#import "SignViewController.h"
#import "ActionDetailViewController.h"
#import "BarActivityList.h"
#import "LYMyFriendDetailViewController.h"

#define COLLECTKEY  [NSString stringWithFormat:@"%@%@sc",_userid,self.beerBarDetail.barid]
#define LIKEKEY  [NSString stringWithFormat:@"%@%@",_userid,self.beerBarDetail.barid]
#define BEERBARDETAIL_MTA @"酒吧详情"

@interface BeerNewBarViewController ()<UIWebViewDelegate,UIScrollViewDelegate>
{
    NSManagedObjectContext *_context;
    NSString *_userid;
    UIWebView *_webView;
    LYHeaderTableViewCell *_headerCell;
    LYBarTitleTableViewCell *_barTitleCell;
    NSInteger _timeCount;
    CGSize _size;
    NSTimer *_timer;
    CGFloat offSet;
    EScrollerView *_scroller;
    BOOL _userLiked;
    UIVisualEffectView *effectView;
    BOOL _userCollected;
    UIImageView *_tableHeaderImgView;
    NSArray *_activityArray;
    CGFloat _contentOffSetY;
    UIButton *_signBtn;
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
@property (weak, nonatomic) IBOutlet UIVisualEffectView *bottomEffectView;

@end

@implementation BeerNewBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    _tableView.showsHorizontalScrollIndicator=NO;
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.separatorColor=[UIColor clearColor];
    //    _tableView.layer.zPosition = 2.0;
    
    //    self.navigationController.navigationBarHidden=YES;
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
    [self setupViewStyles];                                                     //tableView registe cell
    _scrollView.bounces = NO;
    
//    self.image_layer.hidden = YES;
    self.image_layer.alpha = 0.f;
    
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    _context = app.managedObjectContext;
    _userid = [NSString stringWithFormat:@"%d",app.userModel.userid];
    
    self.view_bottom.layer.shadowColor = [[UIColor lightGrayColor]CGColor];
    self.view_bottom.layer.shadowOffset = CGSizeMake(0, -1);
    self.view_bottom.layer.shadowOpacity = 0.8;
    self.view_bottom.layer.shadowRadius = 2;
    
    
    
    [self loadBarDetail];                                                       //load data
  
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadMyCollectedAndLikeBar) name:@"loadMyCollectedAndLikeBar" object:nil];
    
    [MTA trackCustomKeyValueEvent:@"BarDetail" props:nil];

}

- (void)loadMyCollectedAndLikeBar{
    [self loadMyBarInfo];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"loadMyCollectedAndLikeBar" object:nil];
}

//喜欢按钮圆角
- (void)setUpBtn_like{
    self.btn_like.layer.cornerRadius = CGRectGetWidth(self.btn_like.frame)/2.0;
    self.btn_like.layer.masksToBounds = YES;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    [_timer setFireDate:[NSDate distantPast]];
   
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    effectView = [[UIVisualEffectView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2.f - 30, SCREEN_HEIGHT - 60, 60, 60)];
    effectView.layer.cornerRadius = effectView.frame.size.width/2.f;
    effectView.layer.masksToBounds = YES;
    effectView.effect = effect;
    [self.view addSubview:effectView];
    
    _signBtn = [[UIButton alloc]initWithFrame:CGRectMake((effectView.frame.size.width - 60)/2.f,(effectView.frame.size.height - 60)/2.f , 60, 60)];
    [_signBtn addTarget:self action:@selector(signClick:) forControlEvents:UIControlEventTouchUpInside];
    [_signBtn setTitle:@"签到" forState:UIControlStateNormal];
    [_signBtn setTitleColor:RGBA(186, 40, 227, 1) forState:UIControlStateNormal ];
    _signBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    _signBtn.imageEdgeInsets = UIEdgeInsetsMake(-20,20, 0, 0);
    _signBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -13, -31, 0);
    [_signBtn setImage:[UIImage imageNamed:@"sign"] forState:UIControlStateNormal];
    
    [effectView addSubview:_signBtn];
    [self.view bringSubviewToFront:_bottomEffectView];
    [self.view bringSubviewToFront:_view_bottom];
    
    [UIView animateWithDuration:.4 animations:^{
        effectView.frame = CGRectMake((SCREEN_WIDTH - 60)/2.f, SCREEN_HEIGHT - 123, 60, 60);
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            effectView.frame = CGRectMake((SCREEN_WIDTH - 60)/2.f, SCREEN_HEIGHT - 120, 60, 60);
        }];
    }];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    [self.navigationController.navigationBar setHidden:YES];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_timer setFireDate:[NSDate distantFuture]];
    [self.navigationController.navigationBar setHidden:NO];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [effectView removeFromSuperview];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden=NO;
}

#pragma mart --约束
-(void)updateViewConstraints{
    [super updateViewConstraints];
    if (self.beerBarDetail.isSign==0) {
        _buttomViewHeight.constant=0;
        _bottomBarView.hidden = YES;
    }else{
        _buttomViewHeight.constant=49;
        _bottomBarView.hidden = NO;
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
             
//             _tableHeaderImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 9 /16)];
//             [_tableHeaderImgView sd_setImageWithURL:[NSURL URLWithString:detailItem.banners.firstObject]];
//             weakSelf.tableView.tableHeaderView = _tableHeaderImgView;
             
             weakSelf.title=weakSelf.beerBarDetail.barname;
             //判断用户是否已经喜欢过
             [_timer setFireDate:[NSDate distantPast]];
             
             [weakSelf updateViewConstraints];
             [weakSelf.tableView reloadData];
             [weakSelf loadMyBarInfo];
             //加载webview
             [weakSelf loadWebView];
             [weakSelf setTimer];
         }
     } failure:^(BeerBarOrYzhDetailModel *beerModel) {
         //本地加载酒吧详情数据
         weakSelf.beerBarDetail = beerModel;
         [weakSelf.tableView reloadData];
         [weakSelf loadWebView];
     }];
    
    
    NSDictionary *dic = @{@"barid":_beerBarId};
    [LYHomePageHttpTool getActivityListNoAppLoadingWithPara:dic compelte:^(NSMutableArray *result) {
        _activityArray = result;
        [_tableView reloadData];
    }];
}

- (void)loadMyBarInfo{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (app.userModel.userid) {
        //        __weak __typeof(self)weakSelf = self;
        [[LYUserHttpTool shareInstance]getMyBarWithParams:nil block:^(NSMutableArray *result) {
            for (MyBarModel *barModel in result) {
                if([_beerBarDetail.barid isEqual:@(barModel.barid)]){
                    _userCollected = YES;
                    
                    if (_image_layer.alpha <= 0.f) {//white
                         [_btn_collect setBackgroundImage:[UIImage imageNamed:@"收藏whited"] forState:UIControlStateNormal];
                    }else{
                        [_btn_collect setBackgroundImage:[UIImage imageNamed:@"icon_collect2"] forState:UIControlStateNormal];
                    }
                }
            }
        }];
        
        [[LYUserHttpTool shareInstance] getMyBarZangWithParams:nil block:^(NSMutableArray *result) {
            for (MyBarModel *barModel in result) {
                if([_beerBarDetail.barid isEqual:@(barModel.barid)]){
                    _userLiked = YES;
                    if (_image_layer.alpha <= 0.f) {//white
                        [_btn_like setBackgroundImage:[UIImage imageNamed:@"点赞whited"] forState:UIControlStateNormal];
                    }else{
                        [_btn_like setBackgroundImage:[UIImage imageNamed:@"icon_like2"] forState:UIControlStateNormal];
                    }
                }
            }
        }];
    }
    
}

- (void)setTimer{
    if (_timer == nil){
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.03 target:self selector:@selector(onTime) userInfo:nil repeats:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
   // if (scrollView.contentOffset.y > SCREEN_WIDTH/183*95 - self.image_layer.size.height) {
//        self.image_layer.hidden = NO;
        self.image_layer.alpha = scrollView.contentOffset.y / 64.f;
        self.image_layer.layer.shadowRadius = 2;
        self.image_layer.layer.shadowOpacity = 0.5;
        self.image_layer.layer.shadowOffset = CGSizeMake(0, 1);
        self.image_layer.layer.shadowColor = [[UIColor lightGrayColor]CGColor];
    if (self.image_layer.alpha <= 0.f) {//white
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        [_btnBack setImage:[UIImage imageNamed:@"return_white"] forState:UIControlStateNormal];
        if (_userCollected) {
            [_btn_collect setBackgroundImage:[UIImage imageNamed:@"收藏whited"] forState:UIControlStateNormal];
        }else{
            [_btn_collect setBackgroundImage:[UIImage imageNamed:@"收藏white"] forState:UIControlStateNormal];
        }
        if (_userLiked) {
            [_btn_like setBackgroundImage:[UIImage imageNamed:@"点赞whited"] forState:UIControlStateNormal];
        }else{
            [_btn_like setBackgroundImage:[UIImage imageNamed:@"点赞white"] forState:UIControlStateNormal];
        }
        [_btnShare setImage:[UIImage imageNamed:@"分享white"] forState:UIControlStateNormal];
    }else{//black
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
         [_btnBack setImage:[UIImage imageNamed:@"backBtn"] forState:UIControlStateNormal];
        if (_userCollected) {
            [_btn_collect setBackgroundImage:[UIImage imageNamed:@"icon_collect2"] forState:UIControlStateNormal];
        }else{
            [_btn_collect setBackgroundImage:[UIImage imageNamed:@"icon_collect_2"] forState:UIControlStateNormal];
        }
        if (_userLiked) {
            [_btn_like setBackgroundImage:[UIImage imageNamed:@"icon_like2"] forState:UIControlStateNormal];
        }else{
            [_btn_like setBackgroundImage:[UIImage imageNamed:@"icon_like_2"] forState:UIControlStateNormal];
        }
                [_btnShare setImage:[UIImage imageNamed:@"share_black"] forState:UIControlStateNormal];
    }
    
    if (_tableView.contentOffset.y < 0) {
        CGFloat y = scrollView.contentOffset.y;
        CGFloat hegiht = SCREEN_WIDTH * 95 / 183.f;
        _tableHeaderImgView.frame = CGRectMake(- ((hegiht - y) * 183 / 95.f - SCREEN_WIDTH ) /2.f, y, (hegiht - y) * 183 / 95.f, hegiht -y);
    }
    
   /* if (scrollView.contentOffset.y > _contentOffSetY) {
        if (scrollView.contentOffset.y <= 0.f) {
            [UIView animateWithDuration:0.2 animations:^{
                effectView.frame = CGRectMake((SCREEN_WIDTH - 60)/2.f, SCREEN_HEIGHT - 120, 60, 60);
            }];
        }else{
        [UIView animateWithDuration:0.4 animations:^{
            effectView.frame = CGRectMake((SCREEN_WIDTH - 60)/2.f, SCREEN_HEIGHT, 60, 60);
        }];
        }
    }else{
        if (scrollView.contentOffset.y <= 0.f) {
            
        }else{
        if(CGRectGetMaxY(effectView.frame) > SCREEN_HEIGHT - 5){
            [UIView animateWithDuration:.4 animations:^{
                effectView.frame = CGRectMake((SCREEN_WIDTH - 60)/2.f, SCREEN_HEIGHT - 123, 60, 60);
            }completion:^(BOOL finished) {
                [UIView animateWithDuration:0.2 animations:^{
                    effectView.frame = CGRectMake((SCREEN_WIDTH - 60)/2.f, SCREEN_HEIGHT - 120, 60, 60);
                }];
            }];
        }
        }
    } */
    if (scrollView.contentOffset.y > _contentOffSetY) {
//        [UIView animateWithDuration:0.4 animations:^{
//            effectView.frame = CGRectMake((SCREEN_WIDTH - 60)/2.f, SCREEN_HEIGHT, 60, 60);
//        }];
        if (scrollView.contentOffset.y <= 0.f) {
            [UIView animateWithDuration:0.2 animations:^{
                effectView.frame = CGRectMake((SCREEN_WIDTH - 60)/2.f, SCREEN_HEIGHT - 120, 60, 60);
            }];
        }else{
            [UIView animateWithDuration:0.4 animations:^{
                effectView.frame = CGRectMake((SCREEN_WIDTH - 60)/2.f, SCREEN_HEIGHT, 60, 60);
            }];
        }
    }else{
        if(CGRectGetMaxY(effectView.frame) > SCREEN_HEIGHT - 5){
            [UIView animateWithDuration:.4 animations:^{
                effectView.frame = CGRectMake((SCREEN_WIDTH - 60)/2.f, SCREEN_HEIGHT - 123, 60, 60);
            }completion:^(BOOL finished) {
                [UIView animateWithDuration:0.2 animations:^{
                    effectView.frame = CGRectMake((SCREEN_WIDTH - 60)/2.f, SCREEN_HEIGHT - 120, 60, 60);
                }];
            }];
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    _contentOffSetY = scrollView.contentOffset.y;
}

// load webView
- (void)loadWebView{
    
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 2500)];
    _webView.backgroundColor = [UIColor redColor];
    _webView.tintColor = [UIColor redColor];
    _webView.delegate = self;
    _webView.tag = 10086;
    
    
    [_webView sizeToFit];
    [_webView.scrollView setScrollEnabled:NO];
    NSString *webStr = [NSString stringWithFormat:@"<head><meta name=\"viewport\" content=\"width=device-width, initial-scale=1, maximum-scale=1, minimum-scale=1, user-scalable=no\" charset=\"utf-8\"/></head><body><div id=\"webview_content_wrapper\">%@</div><script type=\"text/javascript\">var imgs = document.getElementsByTagName('img');for(var i = 0; i<imgs.length; i++){imgs[i].style.width = '%f';imgs[i].style.height = 'auto';imgs[i].style.margin=0;}</script></body>",self.beerBarDetail.descriptions,SCREEN_WIDTH-17];
    
    //    dispatch_async(dispatch_get_main_queue(), ^{
    // 更UI
    [_webView loadHTMLString:webStr baseURL:nil];
    //    });
    
   
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
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (!app.userModel.userid) {
        LYUserLoginViewController *loginVC = [[LYUserLoginViewController alloc]init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }else{
        __weak BeerNewBarViewController *weakSelf = self;
        NSDictionary * param = @{@"barid":self.beerBarDetail.barid};
        //判断用户是否已经喜欢过
        if (_userLiked) {
            
            [[LYHomePageHttpTool shareInstance] unLikeJiuBa:param compelete:^(bool result) {
                //收藏过
                if(result){
                    if (self.image_layer.alpha <= 0.f) {//white
                        [weakSelf.btn_like setBackgroundImage:[UIImage imageNamed:@"点赞white"] forState:UIControlStateNormal];
                    }else{
                        [weakSelf.btn_like setBackgroundImage:[UIImage imageNamed:@"icon_like_2"] forState:UIControlStateNormal];
                    }
                    
                    _userLiked = NO;
                }
            }];
            [MTA trackCustomKeyValueEvent:LYCLICK_MTA props:[self createMTADctionaryWithActionName:@"喜欢" pageName:BEERBARDETAIL_MTA titleName:self.beerBarDetail.barname]];
        }else{
            [[LYHomePageHttpTool shareInstance] likeJiuBa:param compelete:^(bool result) {
                if (result) {
                    if (self.image_layer.alpha <= 0.f) {//white
                        [weakSelf.btn_like setBackgroundImage:[UIImage imageNamed:@"点赞whited"] forState:UIControlStateNormal];
                    }else{
                        [weakSelf.btn_like setBackgroundImage:[UIImage imageNamed:@"icon_like2"] forState:UIControlStateNormal];
                    }
                    _userLiked = YES;
                    
                }
                [MTA trackCustomKeyValueEvent:LYCLICK_MTA props:[self createMTADctionaryWithActionName:@"取消喜欢" pageName:BEERBARDETAIL_MTA titleName:self.beerBarDetail.barname]];
            }];
        }
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
    [_tableView registerNib:[UINib nibWithNibName:@"LYBarIconTableViewCell" bundle:nil] forCellReuseIdentifier:@"LYBarIconTableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"LYBarScrollTableViewCell" bundle:nil] forCellReuseIdentifier:@"LYBarScrollTableViewCell"];
    
    self.bottomBarView.backgroundColor = [LYColors tabbarBgColor];
    //_dyBarDetailH = [BeerBarDetailCell adjustCellHeight:nil];
}



#pragma mark-- webview delegate
/*
 - (void)webViewDidFinishLoad:(UIWebView *)webView{
 [_webView sizeToFit];
 //获取页面高度（像素）
 //    NSString * clientheight_str = [webView stringByEvaluatingJavaScriptFromString: @"document.getElementById('webview_content_wrapper').offsetHeight"];//scroll
 //    float clientheight = [clientheight_str floatValue];
 CGFloat documentHeight = [[webView stringByEvaluatingJavaScriptFromString:@"document.getElementById(\"content\").offsetHeight;"] floatValue];
 //     NSLog(@"--------->%f----",webView.scrollView.contentSize.height);
 //设置到WebView上
 // webView.frame = CGRectMake(0,0, SCREEN_WIDTH, clientheight);
 //获取WebView最佳尺寸（点）
 // CGSize frame = [webView sizeThatFits:webView.frame.size];
 //获取内容实际高度（像素）
 //    NSString * height_str= [webView stringByEvaluatingJavaScriptFromString: @"document.getElementById('webview_content_wrapper').offsetHeight;"];
 //    float height = [height_str floatValue];
 //内容实际高度（像素）* 点和像素的比
 //    height = height * frame.height / clientheight;
 //再次设置WebView高度（点）
 //    NSLog(@"--->%f",height);
 //    NSLog(@"---->%f",webView.scrollView.contentSize.height);
 webView.scrollView.scrollEnabled = NO;
 // NSLog(@"--------->%f----",webView.scrollView.contentSize.height);
 webView.frame = CGRectMake(0, self.tableView.contentSize.height - 30, SCREEN_WIDTH, webView.scrollView.contentSize.height);
 //    webView.backgroundColor = [UIColor redColor];
 // if(_tableView.contentSize.height > SCREEN_HEIGHT) {
 //        _tableView.frame = CGRectMake(_tableView.frame.origin.x, _tableView.frame.origin.y, SCREEN_WIDTH, _tableView.contentSize.height);
 //        self.tableView_Height.constant = _tableView.contentSize.height;
 //        [self updateViewConstraints];
 //    }
 _tableView.scrollEnabled = NO;
 //     NSLog(@"--------->%f----",webView.scrollView.contentSize.height);
 //    _scrollView.contentSize=CGSizeMake(SCREEN_WIDTH, self.tableView.frame.size.height+webView.frame.size.height-65);
 _scrollView.contentSize=CGSizeMake(SCREEN_WIDTH, self.tableView.contentSize.height+webView.scrollView.contentSize.height - 30);
 //    NSLog(@"--------->%f----",webView.scrollView.contentSize.height);
 
 //  CGFloat offsetHeight = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
 //
 //    NSLog(@"----pass-pass%f---",offsetHeight);
 //     webView.frame = CGRectMake(0, self.tableView.frame.size.height-70, 320, offsetHeight+100);
 //    _scrollView.contentSize=CGSizeMake(SCREEN_WIDTH, self.tableView.frame.size.height+webView.frame.size.height);
 }
 */

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    //获取页面高度（像素）
    NSString * clientheight_str = [webView stringByEvaluatingJavaScriptFromString: @"document.getElementById('webview_content_wrapper').offsetHeight"];//scroll
    float clientheight = [clientheight_str floatValue];
    //设置到WebView上
    webView.frame = CGRectMake(0,55, SCREEN_WIDTH, clientheight);
    //获取WebView最佳尺寸（点）
    CGSize frame = [webView sizeThatFits:webView.frame.size];

    //获取内容实际高度（像素）
    //    NSString * height_str= [webView stringByEvaluatingJavaScriptFromString: @"document.getElementById('webview_content_wrapper').offsetHeight;"];
    //    float height = [height_str floatValue];
    //内容实际高度（像素）* 点和像素的比
    //    height = height * frame.height / clientheight;
    //再次设置WebView高度（点）
    //    NSLog(@"--->%f",height);
    //webView.frame = CGRectMake(0, self.tableView.contentSize.height - 30, SCREEN_WIDTH, frame.height);
    //    webView.backgroundColor = [UIColor redColor];
    [_tableView reloadData];

}

#pragma mark -- tableviewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(_beerBarDetail)
    return 6;
    else return 0;
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
            UIImageView *imgV = [_headerCell viewWithTag:10086];
            if (imgV) {
                [imgV removeFromSuperview];
            }
            _tableHeaderImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 95/183.f)];
            _tableHeaderImgView.tag = 10086;
            [_tableHeaderImgView sd_setImageWithURL:[NSURL URLWithString:_beerBarDetail.banners.firstObject]];
            [_headerCell addSubview:_tableHeaderImgView];
            
            _headerCell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return _headerCell;
            
        }
            break;
        case 1:
        {
            
            _barTitleCell = [tableView dequeueReusableCellWithIdentifier:@"LYBarTitleTableViewCell" forIndexPath:indexPath];
            _barTitleCell.beerM = _beerBarDetail;
            _barTitleCell.selectionStyle = UITableViewCellSelectionStyleNone;
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
        case 3://iconlist
        {
            LYBarIconTableViewCell *iconCell = [tableView dequeueReusableCellWithIdentifier:@"LYBarIconTableViewCell" forIndexPath:indexPath];
            iconCell.iconArray = _beerBarDetail.signUsers;
            for (int i = 0; i < iconCell.btnArray.count; i ++) {
                UIButton *btn = iconCell.btnArray[i];
                btn.tag = i;
                [btn addTarget:self action:@selector(iconClick:) forControlEvents:UIControlEventTouchUpInside];
            }
            [iconCell.moreBtn addTarget:self action:@selector(moreClick:) forControlEvents:UIControlEventTouchUpInside];
            return iconCell;
            
        }
            break;
            
            case 4://activity
        {
            LYBarScrollTableViewCell *scrollCell = [tableView dequeueReusableCellWithIdentifier:@"LYBarScrollTableViewCell" forIndexPath:indexPath];
            //_activityArray = @[@"http://source.lie98.com/37680ChaletPlusLounge2.jpg"];
            scrollCell.activtyArray = _activityArray;
            for (int i = 0 ;  i < _activityArray.count; i ++) {
                
                UIButton *btn = scrollCell.activtyBtnArray[i];
                btn.tag = i;
                [btn addTarget:self action:@selector(activtyClick:) forControlEvents:UIControlEventTouchUpInside];
            }
            return scrollCell;
           /* UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
            cell.backgroundColor = [UIColor redColor];
            return cell; */
        }
            break;
        case 5:
        {
            LYBarDescTableViewCell *barDescTitleCell = [tableView dequeueReusableCellWithIdentifier:@"LYBarDescTableViewCell" forIndexPath:indexPath];
            barDescTitleCell.title = self.beerBarDetail.subtitle;
            barDescTitleCell.selectionStyle = UITableViewCellSelectionStyleNone;
//            barDescTitleCell con
            
            UIWebView *webV = [barDescTitleCell viewWithTag:10086];
            if (webV) {
                [webV removeFromSuperview];
            }
            
            [barDescTitleCell addSubview:_webView];
            
            return barDescTitleCell;
            
        }
            break;
            
    }
    return cell;
}

#pragma mark － 签到
- (void)signClick:(id)sender {
    NSDictionary *dic = @{@"barid":_beerBarId};
    [LYHomePageHttpTool signWith:dic complete:^(bool result) {
        if (result) {
            AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
            CustomerModel *customerM = [[CustomerModel alloc]init];
            UserModel *userM = [[UserModel alloc]init];
            userM.avatar_img = app.userModel.avatar_img;
            customerM.userInfo = userM;
            if (_beerBarDetail.signUsers.count) {
                [_beerBarDetail.signUsers insertObject:customerM atIndex:0];
            }else {
                [_beerBarDetail.signUsers addObject:customerM];
            }
            [_tableView reloadData];
        }
    }];
}
#pragma mark - 签到头像action
- (void)iconClick:(UIButton *)button{
    CustomerModel *cum = _beerBarDetail.signUsers[button.tag];
    CustomerModel *addressBook = [[CustomerModel alloc]init];
    addressBook.userid = cum.userid;
    addressBook.username = cum.userInfo.username;
    addressBook.userTag = cum.tag;
    addressBook.tag = cum.tag;
    addressBook.avatar_img = cum.userInfo.avatar_img;
    addressBook.birthday = cum.userInfo.birthday;
    addressBook.sex = cum.userInfo.sex;
    addressBook.usernick = cum.userInfo.usernick;
    
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (addressBook.userid == app.userModel.userid) {
        return;
    }
    
    LYMyFriendDetailViewController *friendDetailViewController=[[LYMyFriendDetailViewController alloc]initWithNibName:@"LYMyFriendDetailViewController" bundle:nil];
    friendDetailViewController.title=@"详细信息";
    friendDetailViewController.type=@"4";
    friendDetailViewController.customerModel=addressBook;
    [self.navigationController pushViewController:friendDetailViewController animated:YES];
}

#pragma mark - 所有签到action
- (void)moreClick:(UIButton *)button{
    SignViewController *signVC = [[SignViewController alloc]init];
    signVC.barid = [NSString stringWithFormat:@"%@",_beerBarId];
    [self.navigationController pushViewController:signVC animated:YES];
}

#pragma mark - 活动action
- (void)activtyClick:(UIButton *)button{
    BarActivityList *aBarList = _activityArray[button.tag];
    ActionDetailViewController *actionDetailVC = [[ActionDetailViewController alloc]init];
    actionDetailVC.barActivity = aBarList;
    [self.navigationController pushViewController:actionDetailVC animated:YES];
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

//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *headerView = [[UIView alloc]init];
//    headerView.backgroundColor = [UIColor clearColor];
//    return headerView;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section == 0 || section == 5){
        return 0.00001;
    }else{
        if (section == 3) {
            if(_beerBarDetail.signUsers.count) return 8;
            else return 0;
        }else if(section == 4){
            if(_activityArray.count) return 8;
            else return 0;
        }
        return 8;
    }
}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    UIView *headerView = [[UIView alloc]init];
//    headerView.backgroundColor = [UIColor clearColor];
//    return headerView;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat h = 0.0;
    switch (indexPath.section) {
        case 0:
        {
            return SCREEN_WIDTH * 95 / 183;
        }
            break;
        case 1:
        {
            return 88;
        }
            break;
        case 2:
        {
            return 60;
        }
            break;
        case 3:
        {
            CGFloat btnWidth = (SCREEN_WIDTH - 14 - (7 - 1) * 7)/7.f;
            if(_beerBarDetail.signUsers.count) return btnWidth + 16;
            else return 0;
        }
            break;
            case 4:
        {
            if(_activityArray.count) return 213;
            else return 0;
        }
            break;
            
        case 5:
        {
//            return 76;
            return _webView.frame.size.height + 55;
        }
            break;
//            case 5:
//        {
//            return _webView.frame.size.height;
//        }
//            break;
    }
    return h;
}

#pragma mark 分享按钮
- (IBAction)shareClick:(id)sender {
    NSString *string= [NSString stringWithFormat:@"我要推荐下～%@酒吧!下载猎娱App猎寻更多特色酒吧。http://www.lie98.com/lieyu/toPlayAction.do?action=login&barid=%@",self.beerBarDetail.barname,self.beerBarDetail.barid];
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = [NSString stringWithFormat:@"http://www.lie98.com/lieyu/toPlayAction.do?action=login&barid=%@",self.beerBarDetail.barid];
    [UMSocialData defaultData].extConfig.wechatSessionData.url = [NSString stringWithFormat:@"http://www.lie98.com/lieyu/toPlayAction.do?action=login&barid=%@",self.beerBarDetail.barid];
    [UMSocialSnsService presentSnsIconSheetView:self appKey:UmengAppkey shareText:string shareImage:_barTitleCell.imageView_header.image shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina,UMShareToSms,nil] delegate:nil];
    [MTA trackCustomKeyValueEvent:LYCLICK_MTA props:[self createMTADctionaryWithActionName:@"分享" pageName:BEERBARDETAIL_MTA titleName:self.beerBarDetail.barname]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        //        _image_layer.userInteractionEnabled = NO;
        [self daohang];
        [MTA trackCustomKeyValueEvent:LYCLICK_MTA props:[self createMTADctionaryWithActionName:@"地图导航" pageName:BEERBARDETAIL_MTA titleName:self.beerBarDetail.barname]];
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
    woYaoDinWeiMainViewController.startTime = _beerBarDetail.startTime;
    woYaoDinWeiMainViewController.endTime = _beerBarDetail.endTime;
    [self.navigationController pushViewController:woYaoDinWeiMainViewController animated:YES];
    [MTA trackCustomKeyValueEvent:LYCLICK_MTA props:[self createMTADctionaryWithActionName:@"跳转" pageName:BEERBARDETAIL_MTA titleName:@"我要订位"]];
    [MTA trackCustomEvent:@"YDList" args:nil];
}

- (IBAction)chiHeAct:(UIButton *)sender {
    ChiHeViewController *CHDetailVC = [[ChiHeViewController alloc]initWithNibName:@"ChiHeViewController" bundle:[NSBundle mainBundle]];
    CHDetailVC.title=@"吃喝专场";
    CHDetailVC.barid=_beerBarDetail.barid.intValue;
    CHDetailVC.barName=_beerBarDetail.barname;
    [self.navigationController pushViewController:CHDetailVC animated:YES];
    [MTA trackCustomKeyValueEvent:LYCLICK_MTA props:[self createMTADctionaryWithActionName:@"跳转" pageName:BEERBARDETAIL_MTA titleName:@"吃喝专场"]];
    [MTA trackCustomKeyValueEvent:@"SingleList" props:nil];
}

- (IBAction)zsliAct:(UIButton *)sender {
    
    
    ZujuViewController *zujuVC = [[ZujuViewController alloc]initWithNibName:@"ZujuViewController" bundle:nil];
    zujuVC.title = @"组局";
    zujuVC.barid = _beerBarDetail.barid.intValue;
    zujuVC.startTime = _beerBarDetail.startTime;
    zujuVC.endTime = _beerBarDetail.endTime;
    [self.navigationController pushViewController:zujuVC animated:YES];
    [MTA trackCustomKeyValueEvent:LYCLICK_MTA props:[self createMTADctionaryWithActionName:@"跳转" pageName:BEERBARDETAIL_MTA titleName:@"组局"]];
    [MTA trackCustomEvent:@"PKList" args:nil];
    /**/
    
    
    //    MyZSManageViewController *myZSManageViewController=[[MyZSManageViewController alloc]initWithNibName:@"MyZSManageViewController" bundle:nil];
    //    myZSManageViewController.title=@"专属经理";
    //    myZSManageViewController.barid=_beerBarDetail.barid.intValue;
    //    myZSManageViewController.isBarVip=true;
    //    [self.navigationController pushViewController:myZSManageViewController animated:YES];
    //    [MTA trackCustomKeyValueEvent:LYCLICK_MTA props:[self createMTADctionaryWithActionName:@"跳转" pageName:BEERBARDETAIL_MTA titleName:@"专属经理"]];
}
#pragma mark-- 收藏
- (IBAction)soucangAct:(UIButton *)sender {
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (!app.userModel.userid) {
        LYUserLoginViewController *loginVC = [[LYUserLoginViewController alloc]init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }else{
        NSDictionary *dic=@{@"barid":self.beerBarDetail.barid};
        
        
        __weak BeerNewBarViewController *weakSelf = self;
        //判断用户是否已经收藏过
        if (_userCollected) {
            
            [[LYUserHttpTool shareInstance] delMyBarWithParams:dic complete:^(BOOL result) {
                //收藏过
                if (self.image_layer.alpha <= 0.f) {//white
                    [weakSelf.btn_collect setBackgroundImage:[UIImage imageNamed:@"收藏white"] forState:UIControlStateNormal];
                }else{
                    [weakSelf.btn_collect setBackgroundImage:[UIImage imageNamed:@"icon_collect_2"] forState:UIControlStateNormal];
                    
                }
                _userCollected = NO;
                
            }];
            [MTA trackCustomKeyValueEvent:LYCLICK_MTA props:[self createMTADctionaryWithActionName:@"收藏" pageName:BEERBARDETAIL_MTA titleName:weakSelf.beerBarDetail.barname]];
        }else{
            
            [[LYUserHttpTool shareInstance] addMyBarWithParams:dic complete:^(BOOL result) {
                if (self.image_layer.alpha <= 0.f) {//white
                    [weakSelf.btn_collect setBackgroundImage:[UIImage imageNamed:@"收藏whited"] forState:UIControlStateNormal];
                }else{
                    [weakSelf.btn_collect setBackgroundImage:[UIImage imageNamed:@"icon_collect2"] forState:UIControlStateNormal];
                    
                }
                _userCollected = YES;
            }];
            [MTA trackCustomKeyValueEvent:LYCLICK_MTA props:[self createMTADctionaryWithActionName:@"取消收藏" pageName:BEERBARDETAIL_MTA titleName:weakSelf.beerBarDetail.barname]];
        }
    }
}
@end
