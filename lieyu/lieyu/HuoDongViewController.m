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
    self.title=@"活动详情";
    self.webView=[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.scrollView.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64);
;
    self.scrollView=[[UIScrollView alloc] initWithFrame:CGRectZero];
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
    self.webView.frame = CGRectMake(0, 0, SCREEN_WIDTH, frame.height);
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
