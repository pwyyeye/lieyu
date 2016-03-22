//
//  GamePlayViewController.m
//  lieyu
//
//  Created by 狼族 on 16/3/7.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "GamePlayViewController.h"

@interface GamePlayViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation GamePlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.navigationController.navigationBarHidden = YES;
    [_webView sizeToFit];
    _webView.scrollView.scrollEnabled = NO;
    if (![_gameLink containsString:@"http://"]) {
        NSString *basePath = [[NSBundle mainBundle]bundlePath];
        _gameLink = [basePath stringByAppendingPathComponent:_gameLink];
//        [MyUtil showMessage:_gameLink];
        // get the model which is a html file for the webView
        NSString * htmlCont = [NSString stringWithContentsOfFile:_gameLink encoding:NSUTF8StringEncoding error:nil];
        
        // load the html file to webView
        NSURL *baseURL = [NSURL fileURLWithPath:basePath];
        [_webView loadHTMLString:htmlCont baseURL:baseURL];
    }else{
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_gameLink]];
        [_webView loadRequest:request];

    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSLog(@"---->%@",request.URL.absoluteString);
    NSString *absoluteStr = request.URL.absoluteString;
    NSArray *bigArray = [absoluteStr componentsSeparatedByString:@":"];
    if (bigArray.count >= 2) {
        NSString *smallUrlStr = bigArray[1];
        NSArray *smallArray = [smallUrlStr componentsSeparatedByString:@"/"];
        if (smallArray.count >= 3) {
            NSString *goback = smallArray[2];
            if ([goback isEqualToString:@"goback"]) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }
    }
    return YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
