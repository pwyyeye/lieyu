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
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
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
        
        /*
        DetailFootCell = [[[NSBundle mainBundle]loadNibNamed:@"HDDetailFootCell" owner:nil options:nil]firstObject];
        if (_barActivity) {
//            if (!DetailFootCell.webView.delegate) {
//                DetailFootCell.webView.delegate = self;
//            }
            [DetailFootCell.webView sizeToFit];
            [DetailFootCell.webView.scrollView setScrollEnabled:NO];
            NSString *str = @"<p class=\"MsoNormal\" style=\"text-indent:24.0pt;\">\n\t玛雅酒吧如梦的环境：投资数百万元引入有玛田音响系统，全系统由广东汇丰音响公司精心调试保证了完美的音响效果。另外由四面高清晰LED墙，5W寰宇激光雨系统，玛雅酒吧特有的梦幻影像柱组成的视觉影像系统更是给予了每一个在场人员无与伦比的震撼。\n</p>\n<p class=\"MsoNormal\" style=\"text-indent:24.0pt;\">\n\t&nbsp;<img src=\"http://source.lie98.com/男生@2x20151206205509.png\" alt=\"\" /> \n</p>\n<p class=\"MsoNormal\" align=\"left\" style=\"text-indent:24pt;\">\n\t每天表演舞蹈众多。目前舞蹈有街舞，巴西桑巴，欧美芭蕾等。加上不定期的精彩互动的活动，都是吸引你的理由<span></span> \n</p>\n<p class=\"MsoNormal\" align=\"left\" style=\"text-indent:24pt;\">\n\t&nbsp;<img src=\"http://source.lie98.com/Rectangle 1 Copy 4 (1)20151206205655.png\" alt=\"\" /> \n</p>\n<p class=\"MsoNormal\" align=\"left\" style=\"text-indent:24pt;background-color:white;\">\n\t驾驭生活的“霸道”， 时尚前卫的型男索女激情邂逅，简约、时尚、另类的舞台表演奉呈予你视觉盛宴，加上不定期的精彩互动的主题<span>PARTY</span>，绝伦的世界排名<span>DJ</span>现场秀，都是吸引你的理由。时尚潮流、动感活力的现场电音音乐，配有全自动<span>VOD</span>点歌系统歌曲齐全的豪华<span>KTV</span>包厢。在<span>CLUB MAYA</span>，专业化、人性化的服务给你皇家般礼遇的享受，以及前所未有的娱乐新体验是我们面向全世界宾客的承诺，让你在<span>CLUB MAYA</span>激情渡过你最精彩的夜晚<br />\n<br />\n<br />\ntest<br />\n<br />\ntest<br />\n<br />\ntest test\n</p>\n<script type=\"text/javaScript\">\n            var messagingIframe;\n            \n            messagingIframe = document.createElement('iframe');\n            \n            messagingIframe.style.display = 'none';\n            \n            document.documentElement.appendChild(messagingIframe);\n            \n            function testClick(cmd)  \n            {  \n                //var str1 = ducument.getElementById(\"text1\").value;  \n                //var str2 = ducument.getElementById(\"text2\").value;  \n                var str1=document.getElementById(\"text1\").value;  \n                var str2=document.getElementById(\"text2\").value;  \n                //var str1=\"我来自ios苹果\"; //%25u6211%25u6765%25u81EAios%25u82F9%25u679C  \n                //var str2=\"我来自earth地球\";//%25u6211%25u6765%25u81EAearth%25u5730%25u7403  \n                document.write(Date());  \n                //window.location.href=\"objc://\"+cmd+\":/1:/2\";\n                messagingIframe.src=\"objc://\"+cmd+\":/1:/2\";\n                \n                setTimeout(function() { document.documentElement.removeChild(messagingIframe) }, 0)\n\n            }</script>";
            NSString *webStr =  [NSString stringWithFormat:@"<head><meta name=\"viewport\" content=\"width=device-width, initial-scale=1, maximum-scale=1, minimum-scale=1, user-scalable=no\" charset=\"utf-8\"/></head><body><div id=\"webview_content_wrapper\">%@</div><script type=\"text/javascript\">var imgs = document.getElementsByTagName('img');for(var i = 0; i<imgs.length; i++){imgs[i].style.width = '%f';imgs[i].style.height = 'auto';imgs[i].style.margin=0;}</script></body>",str,SCREEN_WIDTH-36];

            [DetailFootCell.webView loadHTMLString:webStr baseURL:nil];
        }
//      cell.decriptLbl.text = @"fjdkshakjfdhsfhsdkjhfjsfgkdsiuoewuroipweutrihdjskfkdlsanfjdkslhfjkladhsjklfhdsajfhlkdshfkljhakdshlfkdhsajlkfhdklsjhfkyuyroietyireytuiowrhfjlkdsvnl,vnkjshjfklhgfdlsjgl;jwoiretpuuriehjgllskghfjkdlhgjklfdhlgjkhfugoeujfsljfkldjglfdhgiurheuihrkjlehjkrehgljkfjdkshakjfdhsfhsdkjhfjsfgkdsiuoewuroipweutrihdjskfkdlsanfjdkslhfjkladhsjklfhdsajfhlkdshfkljhakdshlfkdhsajlkfhdklsjhfkyuyroietyireytuiowrhfjlkdsvnl,vnkjshjfklhgfdlsjgl;jwoiretpuuriehjgllskghfjkdlhgjklfdhlgjkhfugoeujfsljfkldjglfdhgiurheuihrkjlehjkrehgljkfjdkshakjfdhsfhsdkjhfjsfgkdsiuoewuroipweutrihdjskfkdlsanfjdkslhfjkladhsjklfhdsajfhlkdshfkljhakdshlfkdhsajlkfhdklsjhfkyuyroietyireytuiowrhfjlkdsvnl,vnkjshjfklhgfdlsjgl;jwoiretpuuriehjgllskghfjkdlhgjklfdhlgjkhfugoeujfsljfkldjglfdhgiurheuihrkjlehjkrehgljk";
        DetailFootCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return DetailFootCell;*/
    }
}

- (void)loadWebView{
    WebView = [[UIWebView alloc]initWithFrame:CGRectMake(12, 40, SCREEN_WIDTH - 36, 2500)];
    WebView.tag = 45;
    WebView.delegate = self;
    [WebView sizeToFit];
    [WebView.scrollView setScrollEnabled:NO];
//    NSString *str = @"<p class=\"MsoNormal\" style=\"text-indent:24.0pt;\">\n\t玛雅酒吧如梦的环境：投资数百万元引入有玛田音响系统，全系统由广东汇丰音响公司精心调试保证了完美的音响效果。另外由四面高清晰LED墙，5W寰宇激光雨系统，玛雅酒吧特有的梦幻影像柱组成的视觉影像系统更是给予了每一个在场人员无与伦比的震撼。\n</p>\n<p class=\"MsoNormal\" style=\"text-indent:24.0pt;\">\n\t&nbsp;<img src=\"http://source.lie98.com/男生@2x20151206205509.png\" alt=\"\" /> \n</p>\n<p class=\"MsoNormal\" align=\"left\" style=\"text-indent:24pt;\">\n\t每天表演舞蹈众多。目前舞蹈有街舞，巴西桑巴，欧美芭蕾等。加上不定期的精彩互动的活动，都是吸引你的理由<span></span> \n</p>\n<p class=\"MsoNormal\" align=\"left\" style=\"text-indent:24pt;\">\n\t&nbsp;<img src=\"http://source.lie98.com/Rectangle 1 Copy 4 (1)20151206205655.png\" alt=\"\" /> \n</p>\n<p class=\"MsoNormal\" align=\"left\" style=\"text-indent:24pt;background-color:white;\">\n\t驾驭生活的“霸道”， 时尚前卫的型男索女激情邂逅，简约、时尚、另类的舞台表演奉呈予你视觉盛宴，加上不定期的精彩互动的主题<span>PARTY</span>，绝伦的世界排名<span>DJ</span>现场秀，都是吸引你的理由。时尚潮流、动感活力的现场电音音乐，配有全自动<span>VOD</span>点歌系统歌曲齐全的豪华<span>KTV</span>包厢。在<span>CLUB MAYA</span>，专业化、人性化的服务给你皇家般礼遇的享受，以及前所未有的娱乐新体验是我们面向全世界宾客的承诺，让你在<span>CLUB MAYA</span>激情渡过你最精彩的夜晚<br />\n<br />\n<br />\ntest<br />\n<br />\ntest<br />\n<br />\ntest test\n</p>\n<script type=\"text/javaScript\">\n            var messagingIframe;\n            \n            messagingIframe = document.createElement('iframe');\n            \n            messagingIframe.style.display = 'none';\n            \n            document.documentElement.appendChild(messagingIframe);\n            \n            function testClick(cmd)  \n            {  \n                //var str1 = ducument.getElementById(\"text1\").value;  \n                //var str2 = ducument.getElementById(\"text2\").value;  \n                var str1=document.getElementById(\"text1\").value;  \n                var str2=document.getElementById(\"text2\").value;  \n                //var str1=\"我来自ios苹果\"; //%25u6211%25u6765%25u81EAios%25u82F9%25u679C  \n                //var str2=\"我来自earth地球\";//%25u6211%25u6765%25u81EAearth%25u5730%25u7403  \n                document.write(Date());  \n                //window.location.href=\"objc://\"+cmd+\":/1:/2\";\n                messagingIframe.src=\"objc://\"+cmd+\":/1:/2\";\n                \n                setTimeout(function() { document.documentElement.removeChild(messagingIframe) }, 0)\n\n            }</script>";
    NSString *webStr = [NSString stringWithFormat:@"<head><meta name=\"viewport\" content=\"width=device-width, initial-scale=1, maximum-scale=1, minimum-scale=1, user-scalable=no\" charset=\"utf-8\"/></head><body><div id=\"webview_content_wrapper\">%@</div><script type=\"text/javascript\">var imgs = document.getElementsByTagName('img');for(var i = 0; i<imgs.length; i++){imgs[i].style.width = '%f';imgs[i].style.height = 'auto';imgs[i].style.margin=0;}</script></body>",_barActivity.contents,SCREEN_WIDTH-36];
    [WebView loadHTMLString:webStr baseURL:nil];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    //获取页面高度（像素）
    NSString *clientHeight_str =  [webView stringByEvaluatingJavaScriptFromString: @"document.getElementById('webview_content_wrapper').offsetHeight"];//scroll
    float clientHeight = [clientHeight_str floatValue];
    webView.frame = CGRectMake(12, 40, SCREEN_WIDTH - 32, clientHeight + 24);
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
        return 109;
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
