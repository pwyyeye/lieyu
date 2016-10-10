//
//  ActivityDetailViewController.m
//  lieyu
//
//  Created by 王婷婷 on 16/9/3.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "ActivityDetailViewController.h"
#import "ActivityDetailInfoTableViewCell.h"
#import "LYHeaderTableViewCell.h"
#import "BarActivityList.h"
#import "LYBarDescTableViewCell.h"
#import "LYHomePageHttpTool.h"
#import "UMSocial.h"
#import "BeerBarOrYzhDetailModel.h"
#import "LYUserLocation.h"

#define banner_height SCREEN_WIDTH / 4 * 3

@interface ActivityDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate>
{
    LYHeaderTableViewCell *_headerCell;//表的第一个cell图片
    ActivityDetailInfoTableViewCell *_infoCell;
    UIImageView *_tableHeaderImageView;
    UIWebView *_webView;
}

@property (nonatomic, strong) BarActivityList *barActivity;
@property(strong,nonatomic) UIWebView *phoneCallWebView;

@end

@implementation ActivityDetailViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    if (_image_layer.alpha == 0.f) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        _image_header.hidden = NO;
    }else{
        _image_header.hidden = YES;
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.image_layer.alpha = 0.f;
    _bottomView.hidden = YES;
    [self setupTableView];
    [self getData];
}

- (void)setupTableView{
    [_tableView registerNib:[UINib nibWithNibName:@"LYHeaderTableViewCell" bundle:nil] forCellReuseIdentifier:@"LYHeaderTableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"ActivityDetailInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"ActivityDetailInfoTableViewCell"];
    [_tableView registerClass:[LYBarDescTableViewCell class] forCellReuseIdentifier:@"LYBarDescTableViewCell"];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - 获取数据
- (void)getData{
    __weak __typeof(self)weakSelf = self;
    NSDictionary *dict = @{@"id":_activityID};
    [LYHomePageHttpTool getActionDetail:dict complete:^(BarActivityList *action) {
        _barActivity = action;
        [weakSelf loadWebView];
        [_tableView reloadData];
    }];
}

#pragma mark - 加载网页
- (void)loadWebView{
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 55, SCREEN_WIDTH, 2500)];
    _webView.delegate = self;
    _webView.tag = 200;
    [_webView sizeToFit];
    [_webView.scrollView setScrollEnabled:NO];
    NSString *webStr = [NSString stringWithFormat:@"<head><meta name=\"viewport\" content=\"width=device-width, initial-scale=1, maximum-scale=1, minimum-scale=1, user-scalable=no\" charset=\"utf-8\"/></head><body><div id=\"webview_content_wrapper\">%@</div><script type=\"text/javascript\">var imgs = document.getElementsByTagName('img');for(var i = 0; i<imgs.length; i++){imgs[i].style.width = '%f';imgs[i].style.height = 'auto';imgs[i].style.margin=0;}</script></body>",_barActivity.contents,SCREEN_WIDTH - 17];
    [_webView loadHTMLString:webStr baseURL:nil];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    //获取页面高度
    NSString *clientHeight_str = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('webview_content_wrapper').offsetHeight"];
    float clientHeight = [clientHeight_str floatValue];
    //设置到webView上
    webView.frame = CGRectMake(0, 55, SCREEN_WIDTH, clientHeight + 20);
    //获取webview最佳尺寸点
    [_tableView reloadData];
}

#pragma mark - scrollView的代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y >= banner_height - 64) {
        self.image_layer.alpha = 1;
        self.image_layer.layer.shadowRadius = 2;
        self.image_layer.layer.shadowOpacity = 0.5;
        self.image_layer.layer.shadowOffset = CGSizeMake(0, 1);
        self.image_layer.layer.shadowColor = [[UIColor lightGrayColor]CGColor];
    }else{
        self.image_layer.alpha = 0;
    }
    if (self.image_layer.alpha <= 0.f) {//white
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        [_backButton setImage:[UIImage imageNamed:@"return_white"] forState:UIControlStateNormal];
        [_shareButton setImage:[UIImage imageNamed:@"分享white"] forState:UIControlStateNormal];
    }else{//black
        _image_header.hidden = NO;
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
        [_backButton setImage:[UIImage imageNamed:@"backBtn"] forState:UIControlStateNormal];
        [_shareButton setImage:[UIImage imageNamed:@"share_black"] forState:UIControlStateNormal];
    }
    
    if (_tableView.contentOffset.y < 0) {
        CGFloat y = scrollView.contentOffset.y;
        CGFloat hegiht = banner_height;
        _tableHeaderImageView.frame = CGRectMake(- ((hegiht - y) * 16 / 9.f - SCREEN_WIDTH ) /2.f, y, (hegiht - y) * 16 / 9.f, hegiht -y);
    }
}

#pragma mark - tableview的代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_barActivity) {
        return 1;
    }else{
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_barActivity) {
        return 3;
    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0){
        _headerCell = [tableView dequeueReusableCellWithIdentifier:@"LYHeaderTableViewCell" forIndexPath:indexPath];
        UIImageView *imageView = [_headerCell viewWithTag:100];
        if (imageView) {
            [imageView removeFromSuperview];
        }
        _tableHeaderImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, banner_height)];
        _tableHeaderImageView.tag = 100;
        if (![MyUtil isEmptyString:_barActivity.imageUrl]) {
            [_tableHeaderImageView sd_setImageWithURL:[NSURL URLWithString:_barActivity.imageUrl] placeholderImage:[UIImage imageNamed:@"empyImageBar16_9"]];
        }
        _tableHeaderImageView.contentMode = UIViewContentModeScaleAspectFill;
        _tableHeaderImageView.layer.masksToBounds = YES;
        [_headerCell addSubview:_tableHeaderImageView];
        _headerCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return _headerCell;
    }else if (indexPath.row == 1){
        _infoCell = [tableView dequeueReusableCellWithIdentifier:@"ActivityDetailInfoTableViewCell" forIndexPath:indexPath];
        _infoCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [_infoCell.activityAddressButton addTarget:self action:@selector(checkAddress) forControlEvents:UIControlEventTouchUpInside];
        [_infoCell.activityPhoneButton addTarget:self action:@selector(checkPhone) forControlEvents:UIControlEventTouchUpInside];
        _infoCell.barActivity = _barActivity;
        return _infoCell;
    }else if (indexPath.row == 2){
        LYBarDescTableViewCell *barDescTitleCell = [tableView dequeueReusableCellWithIdentifier:@"LYBarDescTableViewCell" forIndexPath:indexPath];
        UIWebView *webV = [barDescTitleCell viewWithTag:200];
        if (webV) {
            [webV removeFromSuperview];
        }
        [barDescTitleCell addSubview:_webView];
        barDescTitleCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return barDescTitleCell;
    }else{
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return banner_height;
    }else if (indexPath.row == 1){
        CGSize timeSize = [_infoCell.activityTime.text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 58, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size;
        CGSize placeSize = [_infoCell.activityAddress.text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 58, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size;
        return 149 + timeSize.height + placeSize.height;
    }else if (indexPath.row == 2){
        return _webView.frame.size.height + 55;
    }else{
        return 0;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 按钮事件
- (IBAction)buyTicketClick:(UIButton *)sender {
}

- (IBAction)backButtonClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)shareButtonClick:(UIButton *)sender {
    NSString *string= [NSString stringWithFormat:@"我要推荐下～%@攻略!下载猎娱App猎寻更多特色酒吧。http://www.lie98.com/lieyu/toPlayAction.do?action=login&barid=%@",_barActivity.name,_barActivity.id];
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = [NSString stringWithFormat:@"http://www.lie98.com/lieyu/toPlayAction.do?action=login&barid=%@",_barActivity.id];
    [UMSocialData defaultData].extConfig.wechatSessionData.url = [NSString stringWithFormat:@"http://www.lie98.com/lieyu/toPlayAction.do?action=login&barid=%@",_barActivity.id];
    [UMSocialSnsService presentSnsIconSheetView:self appKey:UmengAppkey shareText:string shareImage:_headerCell.imageView.image shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina,UMShareToSms,nil] delegate:nil];
    [MTA trackCustomKeyValueEvent:LYCLICK_MTA props:[self createMTADctionaryWithActionName:@"分享" pageName:@"活动详情" titleName:_barActivity.name]];
}

- (void)checkAddress{
    NSDictionary *dic=@{@"title":((BeerBarOrYzhDetailModel *)_barActivity.barInfo).address,@"latitude":((BeerBarOrYzhDetailModel *)_barActivity.barInfo).latitude,@"longitude":((BeerBarOrYzhDetailModel *)_barActivity.barInfo).longitude};
    [[LYUserLocation instance] daoHan:dic];
}

- (void)checkPhone{
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",((BeerBarOrYzhDetailModel *)_barActivity.barInfo).telephone]];
    if ( !_phoneCallWebView ) {
        _phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];// 这个webView只是一个后台的容易 不需要add到页面上来  效果跟方法二一样 但是这个方法是合法的
    }
    [_phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
}

@end
