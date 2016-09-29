//
//  LYCoinShopViewController.m
//  lieyu
//
//  Created by 王婷婷 on 16/9/27.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYCoinShopViewController.h"
#import "MineMoneyBagViewController.h"

@interface LYCoinShopViewController ()<UIWebViewDelegate>
{
    AppDelegate *_app;
}

@property (nonatomic, strong) NSMutableArray *urlArray;
@property (nonatomic, strong) UIWebView *webView;

@end

@implementation LYCoinShopViewController
#pragma mark - 生命周期
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = @"娱币商城";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",_urlString);
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    _webView.delegate = self;
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:_urlString];
    [self.view addSubview:_webView];
    [_webView loadRequest:request];
    _app = (AppDelegate *)[UIApplication sharedApplication].delegate;
}

#pragma mark - webview的代理事件
- (void)webViewDidStartLoad:(UIWebView *)webView{
    [_app startLoading];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [_app stopLoading];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [[[UIAlertView alloc]initWithTitle:@"提示" message:@"页面加载发生错误，请稍后重试！" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil]show];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if (navigationType == UIWebViewNavigationTypeLinkClicked){
        NSLog(@"%@",[request URL]);
        if ([[request URL] isEqual:[NSURL URLWithString:@"http://www.duiba.com.cn/mobile/index?dbbackroot"]]) {
            int i = 0 ;
            for (UIViewController *vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:[MineMoneyBagViewController class]]) {
                    break;
                }else{
                    i ++;
                }
            }
            UIViewController *vc = [self.navigationController.viewControllers objectAtIndex:i + 1];
            if ([vc isKindOfClass:[LYCoinShopViewController class]]) {
                [self.navigationController popToViewController:vc animated:YES];
            }
//            NSLog(@"%@",self.navigationController.viewControllers);
        }else{
            LYCoinShopViewController *coinShopVC = [[LYCoinShopViewController alloc]init];
            coinShopVC.urlString = [request URL];
            [self.navigationController pushViewController:coinShopVC animated:YES];
        }
        return NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
