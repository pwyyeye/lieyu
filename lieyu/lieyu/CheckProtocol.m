//
//  CheckProtocol.m
//  lieyu
//
//  Created by 王婷婷 on 16/2/22.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "CheckProtocol.h"
@interface CheckProtocol()<UIWebViewDelegate>

@end

@implementation CheckProtocol

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = @"猎娱用户协议";
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
//    [_webView setScalesPageToFit:YES];
    _webView.delegate = self;
//    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:@"http://www.lie98.com/lieyu/xieyi.htm"]];
//    [_webView loadRequest:request];
    
    NSURL *url = [NSURL URLWithString:@"http://www.lie98.com/lieyu/xieyi.htm"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    [_webView loadData:data MIMEType:@"text/html" textEncodingName:@"GBK" baseURL:nil];
    
//    NSString *urlString = @"http://wwww....";
//    NSURL *url = [NSURL URLWithString:urlString];
//    NSData *data = [NSData dataWithContentsOfURL:url];
//    [webView loadData:data MIMEType:@"text/html" textEncodingName:@"UTF-8" baseURL:nil];
    
    [self.view addSubview:_webView];
}



@end


