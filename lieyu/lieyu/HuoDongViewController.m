//
//  HuoDongViewController.m
//  lieyu
//
//  Created by pwy on 15/12/8.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "HuoDongViewController.h"
#import "HTTPController.h"
@interface HuoDongViewController ()

@end

@implementation HuoDongViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.title=@"活动详情";
    self.webView=[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
;
    self.scrollView=[[UIScrollView alloc] initWithFrame:CGRectZero];
    self.scrollView.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64);

    self.webView.delegate=self;
    if (_content) {
        [self loadData];
    }else{
        [self getData];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getData{
   
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    
    __weak HuoDongViewController *weakSelf = self;
    [HTTPController requestWihtMethod:RequestMethodTypePost url:kHttpAPI_LY_TOPLAY_HOMELIST  baseURL:LY_SERVER params:@{@"bartype":@"0"} success:^(id response)
     {
         
         [app stopLoading];
         
         NSString *errorcode = response[@"errorcode"];
         if (errorcode.intValue==1) {
             NSDictionary *dataDic = response[@"data"];
             NSArray *newbanner=[dataDic objectForKey:@"newbanner"];
             for (NSDictionary *dic in newbanner) {
                 NSString *linkid=[dic objectForKey:@"linkid"];
                 if ([dic objectForKey:@"linkid"]!=nil && _linkid==linkid.intValue) {
                     _content=[dic objectForKey:@"content"];
                     [weakSelf loadData];
                 }
             }
         }else{
         
         }
         
         
     } failure:^(NSError *err)
     {
         [app stopLoading];

     }];
    

}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

    self.navigationController.navigationBarHidden=YES;
}

-(void)viewWillLayoutSubviews{
    [super  viewWillLayoutSubviews];
    self.navigationController.navigationBarHidden=NO;
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=NO;
}

-(void)loadData{
    NSString *webStr = [NSString stringWithFormat:@"<head><meta name=\"viewport\" content=\"width=device-width, initial-scale=1, maximum-scale=1, minimum-scale=1, user-scalable=no\" charset=\"utf-8\"/></head><body><div id=\"webview_content_wrapper\">%@</div><script type=\"text/javascript\">var imgs = document.getElementsByTagName('img');for(var i = 0; i<imgs.length; i++){imgs[i].style.width = '%f';imgs[i].style.height = 'auto';}</script></body>",self.content,SCREEN_WIDTH-17];
    
    self.webView.delegate = self;
    [self.webView sizeToFit];
    [self.webView.scrollView setScrollEnabled:NO];
    self.webView.scalesPageToFit = YES;
    [self.webView loadHTMLString:webStr baseURL:nil];
    [self.scrollView addSubview:_webView];
    [self.view addSubview:self.scrollView];


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
