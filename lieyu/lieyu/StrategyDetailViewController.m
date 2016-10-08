//
//  StrategyDetailViewController.m
//  lieyu
//
//  Created by 王婷婷 on 16/9/1.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "StrategyDetailViewController.h"
#import "StrategryModel.h"
#import "LYHeaderTableViewCell.h"
#import "StrategyDetailInfoTableViewCell.h"
#import "LYBarDescTableViewCell.h"
#import "LYHomePageHttpTool.h"
#import "UMSocial.h"
#import "StrategyCommentListViewController.h"

#define banner_height SCREEN_WIDTH / 4 * 3 

@interface StrategyDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate,StrategyCommentSendDelegate>
{
    LYHeaderTableViewCell *_headerCell;//表的第一个cell图片
    StrategyDetailInfoTableViewCell *_infoCell;
    UIImageView *_tableHeaderImgView;
    UIWebView *_webView;//加载酒吧html5载体
}

@property (nonatomic, strong) StrategryModel *strategyModel;

@end

@implementation StrategyDetailViewController
#pragma mark - 准备事件，生命周期
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_image_layer.alpha == 0.f) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        _image_header.hidden = NO;
    }else{
        _image_header.hidden = YES;
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _shareButton.hidden = YES;
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.image_layer.alpha = 0.f;
    [self setupTableview];
    [self getdata];
}

- (void)setupTableview{
    [_tableView registerNib:[UINib nibWithNibName:@"LYHeaderTableViewCell" bundle:nil] forCellReuseIdentifier:@"LYHeaderTableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"StrategyDetailInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"StrategyDetailInfoTableViewCell"];
    [_tableView registerClass:[LYBarDescTableViewCell class] forCellReuseIdentifier:@"LYBarDescTableViewCell"];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 获取数据
- (void)getdata{
    __weak __typeof(self) weakSelf = self;
    NSDictionary *dict = @{@"id":_strategyID};
    [LYHomePageHttpTool getStrategyDetailWith:dict complete:^(StrategryModel *model) {
        _strategyModel = model;
        //加载数据成功以后load webview
        [weakSelf loadWebView];
        [weakSelf setupBottomView];
        [_tableView reloadData];
    }];
}

- (void)setupBottomView{
    [_likeNumber setText:_strategyModel.likeNum];
    [_collectNumber setText:_strategyModel.favNum];
    if ([_strategyModel.isLiked isEqualToString:@"1"]) {
        [_likeImage setImage:[UIImage imageNamed:@"strategyLiked"]];
    }else{
        [_likeImage setImage:[UIImage imageNamed:@"strategyUnLike"]];
    }
    if ([_strategyModel.isCollected isEqualToString:@"1"]) {
        [_collectImage setImage:[UIImage imageNamed:@"strategyColled"]];
    }else{
        [_collectImage setImage:[UIImage imageNamed:@"strategyUnColl"]];
    }
    [_commentNumber setText:_strategyModel.commentNum];
}

- (void)loadWebView{
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 55, SCREEN_WIDTH, 2500)];
    _webView.delegate = self;
    _webView.tag = 200;
    [_webView sizeToFit];
    [_webView.scrollView setScrollEnabled:NO];
    NSString *webStr = [NSString stringWithFormat:@"<head><meta name=\"viewport\" content=\"width=device-width, initial-scale=1, maximum-scale=1, minimum-scale=1, user-scalable=no\" charset=\"utf-8\"/></head><body><div id=\"webview_content_wrapper\">%@</div><script type=\"text/javascript\">var imgs = document.getElementsByTagName('img');for(var i = 0; i<imgs.length; i++){imgs[i].style.width = '%f';imgs[i].style.height = 'auto';imgs[i].style.margin=0;}</script></body>",_strategyModel.content,SCREEN_WIDTH - 17];
    [_webView loadHTMLString:webStr baseURL:nil];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    //获取页面高度
    NSString *clientHeight_str = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('webview_content_wrapper').offsetHeight"];
    float clientHeight = [clientHeight_str floatValue];
    //设置到WebView上
    webView.frame = CGRectMake(0, 55, SCREEN_WIDTH, clientHeight + 20);
    //获取WebView最佳尺寸（点）
    [_tableView reloadData];
}

#pragma mark - scrollview的代理事件
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
        _tableHeaderImgView.frame = CGRectMake(- ((hegiht - y) * 16 / 9.f - SCREEN_WIDTH ) /2.f, y, (hegiht - y) * 16 / 9.f, hegiht -y);
    }
}

#pragma mark - tableView的代理事件
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_strategyModel) {
        return 1;
    }else{
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_strategyModel) {
        return 3;
    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        _headerCell = [tableView dequeueReusableCellWithIdentifier:@"LYHeaderTableViewCell" forIndexPath:indexPath];
        UIImageView *imageView = [_headerCell viewWithTag:100];
        if (imageView) {
            [imageView removeFromSuperview];
        }
        _tableHeaderImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, banner_height)];
        _tableHeaderImgView.tag = 100;
        if (![MyUtil isEmptyString:_strategyModel.strategyIconAll]) {
            [_tableHeaderImgView sd_setImageWithURL:[NSURL URLWithString:_strategyModel.strategyIconAll] placeholderImage:[UIImage imageNamed:@"empyImageBar16_9"]];
        }
        _tableHeaderImgView.contentMode = UIViewContentModeScaleAspectFill;
        _tableHeaderImgView.layer.masksToBounds = YES;
        [_headerCell addSubview:_tableHeaderImgView];
        _headerCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return _headerCell;
    }else if (indexPath.row == 1){
        _infoCell = [tableView dequeueReusableCellWithIdentifier:@"StrategyDetailInfoTableViewCell" forIndexPath:indexPath];
        _infoCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _infoCell.strategyModel = _strategyModel;
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
        CGSize titleSize = [_infoCell.titleLabel.text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 58, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size;
        CGSize subtitleSize = [_infoCell.subtitleLabel.text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 58, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
        return 35 + titleSize.height + subtitleSize.height;
    }else if (indexPath.row == 2){
        return _webView.frame.size.height + 55;
    }else{
        return 0;
    }
}

#pragma mark - 按钮点击事件
- (IBAction)likeButtonClick:(UIButton *)sender {
    NSDictionary *dict = @{@"strategyId":_strategyID};
    if ([_strategyModel.isLiked isEqualToString:@"1"]) {
        //已经喜欢过
        [LYHomePageHttpTool cancelLikeStrategyWith:dict complete:^(BOOL result) {
            if (result) {
                int likeNum = [_strategyModel.likeNum intValue] - 1;
                _strategyModel.likeNum = [NSString stringWithFormat:@"%d",likeNum];
                _strategyModel.isLiked = @"0";
                [_likeNumber setText:_strategyModel.likeNum];
                [_likeImage setImage:[UIImage imageNamed:@"strategyUnLike"]];
            }
        }];
    }else{
        [LYHomePageHttpTool addLikeStrategyWith:dict complete:^(BOOL result) {
            if (result) {
                int likeNum = [_strategyModel.likeNum intValue] + 1;
                _strategyModel.likeNum = [NSString stringWithFormat:@"%d",likeNum];
                _strategyModel.isLiked = @"1";
                [_likeNumber setText:_strategyModel.likeNum];
                [_likeImage setImage:[UIImage imageNamed:@"strategyLiked"]];
            }
        }];
    }
}

- (IBAction)commentButtonClick:(UIButton *)sender {
    StrategyCommentListViewController *strategyCommentVC = [[StrategyCommentListViewController alloc]initWithNibName:@"StrategyCommentListViewController" bundle:nil];
    strategyCommentVC.strategyId = _strategyModel.id;
    strategyCommentVC.delegate = self;
    [self.navigationController pushViewController:strategyCommentVC animated:YES];
}

- (void)StrategySendCommentSuccess{
    int commentNum = [_strategyModel.commentNum intValue];
    _strategyModel.commentNum = [NSString stringWithFormat:@"%d",commentNum + 1];
    [_commentNumber setText:_strategyModel.commentNum];
}

- (void)StrategyDeleteCommentSuccess{
    int commentNum = [_strategyModel.commentNum intValue];
    _strategyModel.commentNum = [NSString stringWithFormat:@"%d",commentNum - 1];
    [_commentNumber setText:_strategyModel.commentNum];
}

- (IBAction)collectButtonClick:(UIButton *)sender {
    NSDictionary *dict = @{@"strategyId":_strategyID};
    if ([_strategyModel.isCollected isEqualToString:@"1"]) {
        [LYHomePageHttpTool cancelCollectStrategyWith:dict complete:^(BOOL result) {
            if (result) {
                int collectNum = [_strategyModel.favNum intValue] - 1;
                _strategyModel.favNum = [NSString stringWithFormat:@"%d",collectNum];
                _strategyModel.isCollected = @"0";
                [_collectNumber setText:_strategyModel.favNum];
                [_collectImage setImage:[UIImage imageNamed:@"strategyUnColl"]];
            }
        }];
    }else{
        [LYHomePageHttpTool addCollectStrategyWith:dict complete:^(BOOL result) {
            if (result) {
                int collectNum = [_strategyModel.favNum intValue] + 1;
                _strategyModel.favNum = [NSString stringWithFormat:@"%d",collectNum];
                _strategyModel.isCollected = @"1";
                [_collectNumber setText:_strategyModel.favNum];
                [_collectImage setImage:[UIImage imageNamed:@"strategyColled"]];
            }
        }];
    }
}

- (IBAction)backButtonClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)shareButtonClick:(UIButton *)sender {
    NSString *string= [NSString stringWithFormat:@"我要推荐下～%@攻略!下载猎娱App猎寻更多特色酒吧。",_strategyModel.title];
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = [NSString stringWithFormat:@"http://www.lie98.com/lieyu/toPlayAction.do?action=login&barid=%@",_strategyModel.id];
    [UMSocialData defaultData].extConfig.wechatSessionData.url = [NSString stringWithFormat:@"http://www.lie98.com/lieyu/toPlayAction.do?action=login&barid=%@",_strategyModel.id];
    [UMSocialSnsService presentSnsIconSheetView:self appKey:UmengAppkey shareText:string shareImage:_headerCell.imageView.image shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina,UMShareToSms,nil] delegate:nil];
    [MTA trackCustomKeyValueEvent:LYCLICK_MTA props:[self createMTADctionaryWithActionName:@"分享" pageName:@"攻略详情" titleName:_strategyModel.title]];
}


@end
