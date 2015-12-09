//
//  HuoDongViewController.m
//  lieyu
//
//  Created by pwy on 15/12/8.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "HuoDongViewController.h"

@interface HuoDongViewController ()

@end

@implementation HuoDongViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    _content=@"<p class=\"MsoNormal\" style=\"text-indent:24.0pt;\">\n\t玛雅酒吧如梦的环境：投资数百万元引入有玛田音响系统，全系统由广东汇丰音响公司精心调试保证了完美的音响效果。另外由四面高清晰LED墙，5W寰宇激光雨系统，玛雅酒吧特有的梦幻影像柱组成的视觉影像系统更是给予了每一个在场人员无与伦比的震撼。\n</p>\n<p class=\"MsoNormal\" style=\"text-indent:24.0pt;\">\n\t&nbsp;<img src=\"http://source.lie98.com/男生@2x20151206205509.png\" alt=\"\" /> \n</p>\n<p class=\"MsoNormal\" align=\"left\" style=\"text-indent:24pt;\">\n\t每天表演舞蹈众多。目前舞蹈有街舞，巴西桑巴，欧美芭蕾等。加上不定期的精彩互动的活动，都是吸引你的理由<span></span> \n</p>\n<p class=\"MsoNormal\" align=\"left\" style=\"text-indent:24pt;\">\n\t&nbsp;<img src=\"http://source.lie98.com/Rectangle 1 Copy 4 (1)20151206205655.png\" alt=\"\" /> \n</p>\n<p class=\"MsoNormal\" align=\"left\" style=\"text-indent:24pt;background-color:white;\">\n\t驾驭生活的“霸道”， 时尚前卫的型男索女激情邂逅，简约、时尚、另类的舞台表演奉呈予你视觉盛宴，加上不定期的精彩互动的主题<span>PARTY</span>，绝伦的世界排名<span>DJ</span>现场秀，都是吸引你的理由。时尚潮流、动感活力的现场电音音乐，配有全自动<span>VOD</span>点歌系统歌曲齐全的豪华<span>KTV</span>包厢。在<span>CLUB MAYA</span>，专业化、人性化的服务给你皇家般礼遇的享受，以及前所未有的娱乐新体验是我们面向全世界宾客的承诺，让你在<span>CLUB MAYA</span>激情渡过你最精彩的夜晚<br />\n<br />\n<br />\ntest<br />\n<br />\ntest<br />\n<br />\ntest<br />\n<br />\n</p>";
    self.title=@"活动详情";
    self.webView=[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.webView.delegate=self;
    
    NSString *webStr = [NSString stringWithFormat:@"<head><meta name=\"viewport\" content=\"width=device-width, initial-scale=1, maximum-scale=1, minimum-scale=1, user-scalable=no\" charset=\"utf-8\"/></head><body><div id=\"webview_content_wrapper\">%@</div><script type=\"text/javascript\">var imgs = document.getElementsByTagName('img');for(var i = 0; i<imgs.length; i++){imgs[i].style.width = '310';imgs[i].style.height = 'auto';}</script></body>",self.content];
    
    self.webView.delegate = self;
    [self.webView sizeToFit];
    [self.webView.scrollView setScrollEnabled:NO];
    self.webView.scalesPageToFit = YES;
    [self.webView loadHTMLString:webStr baseURL:nil];
    [self.scrollView addSubview:_webView];
    [self.view addSubview:self.scrollView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    self.webView.frame = CGRectMake(0, 0, 320, frame.height);
    _scrollView.contentSize=CGSizeMake(SCREEN_WIDTH, frame.height+64);
//    webView.backgroundColor = [UIColor redColor];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
