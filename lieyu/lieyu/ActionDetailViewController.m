//
//  ActionDetailViewController.m
//  lieyu
//
//  Created by 王婷婷 on 16/2/16.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//
//介绍活动详情页面

#import "ActionDetailViewController.h"
#import "HDDetailHeaderCell.h"
#import "UIImageView+WebCache.h"
#import "BeerBarOrYzhDetailModel.h"
#import "HDDetailImageCell.h"
#import "HDDetailFootCell.h"
#import "LYwoYaoDinWeiMainViewController.h"
@interface ActionDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate>
{
    HDDetailImageCell *DetailImageCell;
    HDDetailFootCell *DetailFootCell;
    UIWebView *WebView;
}
@end


@implementation ActionDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.layer.cornerRadius = 2;
    self.tableView.layer.masksToBounds = YES;
    self.title = @"活动详情";
//    DetailFootCell.webView.delegate = self;
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = 100;
//    _actionID = @"7";
    if (_actionID) {
        [self getData];
    }else{
        [self loadWebView];
    }
    [self registerCell];
//    [self configureRightItem];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    [self.navigationController setNavigationBarHidden:NO];
}
- (void)configureRightItem{
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [button setImage:[UIImage imageNamed:@"share_black"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)registerCell{
    [self.tableView registerNib:[UINib nibWithNibName:@"HDDetailImageCell" bundle:nil] forCellReuseIdentifier:@"HDDetailImageCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HDDetailHeaderCell" bundle:nil] forCellReuseIdentifier:@"HDDetailHeaderCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HDDetailFootCell" bundle:nil] forCellReuseIdentifier:@"HDDetailFootCell"];
}

- (void)getData{
    NSDictionary *dict = @{@"id":_actionID};
    [LYHomePageHttpTool getActionDetail:dict complete:^(BarActivityList *action) {
        _barActivity = action;
        if (_barActivity.id==nil) {
            return ;
        }
        [self loadWebView];
        [self.tableView reloadData];
        
    }];
}

#pragma mark - 分享
- (void)shareAction{
//微信，微博，朋友圈
}

//- (void)viewDidLayoutSubviews{
//    [super viewDidLayoutSubviews];
//    if (self.navigationController.navigationBar.hidden == YES) {
//        [self.navigationController.navigationBar setHidden:NO];
//        
//    }
//    
//     [self.navigationController setNavigationBarHidden:NO];
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_barActivity) {
        return 3;
    }else{
        return 0;
    }
}

- (NSDictionary *)feedBackDictionary{
    NSDictionary *dict;
    if (_barActivity) {
        dict = @{@"startTime":_barActivity.beginDate,
                 @"endTime":_barActivity.endDate,
                 @"address":_barActivity.barInfo.address,
                 @"latitude":_barActivity.barInfo.latitude,
                 @"longitude":_barActivity.barInfo.longitude,
                 @"environment":_barActivity.environment,
                 @"music":_barActivity.music};
    }
    return dict;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        DetailImageCell = [[[NSBundle mainBundle]loadNibNamed:@"HDDetailImageCell" owner:nil options:nil]firstObject];
        if (_barActivity.imageUrl) {
            [DetailImageCell configureImageView:_barActivity.imageUrl];
        }
        DetailImageCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return DetailImageCell;
    }else if (indexPath.section == 1){
        HDDetailHeaderCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"HDDetailHeaderCell" owner:nil options:nil]firstObject];
        NSDictionary *dic=[self feedBackDictionary];
        if (dic!=nil) {
            cell.dict = dic;
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailFoot"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DetailFoot"];
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(12, 10, 100, 20)];
            label.font = [UIFont fontWithName:@"AppleSDGothicNeo-Medium" size:14];
            label.text = @"活动介绍";
            label.textColor = [UIColor blackColor];
            [cell addSubview:label];
        }
        UIWebView *webV = [cell viewWithTag:45];
        if (webV) {
            [webV removeFromSuperview];
        }
        [cell addSubview:WebView];
        return cell;
    }
}

- (void)loadWebView{
    WebView = [[UIWebView alloc]initWithFrame:CGRectMake(12, 40, SCREEN_WIDTH - 36, 2500)];
    NSLog(@"------>%@",NSStringFromCGRect(WebView.frame));
    WebView.tag = 45;
    WebView.delegate = self;
    [WebView sizeToFit];
//    WebView.contentMode = UIViewContentModeScaleToFill;
    [WebView.scrollView setScrollEnabled:NO];
    NSString *webStr = [NSString stringWithFormat:@"<head><meta name=\"viewport\" content=\"width=device-width-0, initial-scale=1, maximum-scale=1, minimum-scale=1, user-scalable=no\" charset=\"utf-8\"/></head><body><div id=\"webview_content_wrapper\">%@</div><script type=\"text/javascript\">var imgs = document.getElementsByTagName('img');for(var i = 0; i<imgs.length; i++){imgs[i].style.width = '%f';imgs[i].style.height = 'auto';imgs[i].style.margin=0;}</script></body>",_barActivity.contents,SCREEN_WIDTH-36];
    [WebView loadHTMLString:webStr baseURL:nil];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    //获取页面高度（像素）
    NSString *clientHeight_str =  [webView stringByEvaluatingJavaScriptFromString: @"document.getElementById('webview_content_wrapper').offsetHeight"];//scroll
    float clientHeight = [clientHeight_str floatValue];
    webView.frame = CGRectMake(12, 40, SCREEN_WIDTH - 36, clientHeight + 24);
//    //获取WebView最佳尺寸（点）
//    CGSize frame = [webView sizeThatFits:webView.frame.size];
    NSLog(@"%@",NSStringFromCGRect(webView.frame));
    [_tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.000001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return 6;
    }else{
        return 0.000001;
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (_tableView.contentSize.height < SCREEN_HEIGHT - 113) {
        _tableView.scrollEnabled = NO;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        NSLog(@"%@",NSStringFromCGRect(DetailImageCell.image.frame));
//        return DetailImageCell.image.frame.size.height;
        return UITableViewAutomaticDimension;
//        return 100;
    }else
    if (indexPath.section == 2) {
        return WebView.frame.size.height + 50;
    }else{
        return UITableViewAutomaticDimension;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - 查看套餐
- (IBAction)YuDingClick:(UIButton *)sender {
    LYwoYaoDinWeiMainViewController *woYaoDinWeiMainViewController=[[LYwoYaoDinWeiMainViewController alloc]initWithNibName:@"LYwoYaoDinWeiMainViewController" bundle:nil];
    woYaoDinWeiMainViewController.barid=[_barActivity.barInfo.id intValue];
    woYaoDinWeiMainViewController.startTime = _barActivity.barInfo.startTime;
    woYaoDinWeiMainViewController.endTime = _barActivity.barInfo.endTime;
    [self.navigationController pushViewController:woYaoDinWeiMainViewController animated:YES];
    [MTA trackCustomKeyValueEvent:LYCLICK_MTA props:[self createMTADctionaryWithActionName:@"跳转" pageName:@"活动详情" titleName:@"我要订位"]];
}
@end
