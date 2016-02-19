//
//  HuoDongLinkViewController.m
//  lieyu
//
//  Created by pwy on 16/2/19.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "HuoDongLinkViewController.h"
#import "BeerBarDetailViewController.h"
#import "ActionDetailViewController.h"
#import "ActionPage.h"
#define HOMEPAGE_MTA @"HOMEPAGE"

@interface HuoDongLinkViewController ()

@end

@implementation HuoDongLinkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"活动详情";
    self.webView=[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    self.webView.delegate=self;
    [self.view addSubview:_webView];
    if (![MyUtil isEmptyString:_linkUrl]) {
        NSURL *url = [NSURL URLWithString:_linkUrl];
        NSURLRequest *request=[NSURLRequest requestWithURL:url];
        [_webView loadRequest:request];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
//    self.navigationController.navigationBarHidden=YES;
}

-(void)viewWillLayoutSubviews{
    [super  viewWillLayoutSubviews];
    self.navigationController.navigationBarHidden=NO;
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=NO;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


-(void)getParam1:(NSString*)str1 withParam2:(NSString*)str2
{
    if ([MyUtil isEmptyString:str2]) {
        return;
    }
    NSLog(@"收到html传过来的参数：str1=%@,str2=%@",str1,str2);
    if (![MyUtil isEmptyString:str1]&& [str1 isEqualToString:@"bar"]) {
        //酒吧
        BeerBarDetailViewController * controller = [[BeerBarDetailViewController alloc] initWithNibName:@"BeerBarDetailViewController" bundle:nil];
        
        controller.beerBarId = [NSNumber numberWithInt:str2.intValue] ;
        NSString *str = [NSString stringWithFormat:@"活动html打开酒吧ID%@",controller.beerBarId];
        [self.navigationController pushViewController:controller animated:YES];
        [MTA trackCustomKeyValueEvent:LYCLICK_MTA props:[self createMTADctionaryWithActionName:@"跳转" pageName:HOMEPAGE_MTA titleName:str]];
    }if (![MyUtil isEmptyString:str1]&& [str1 isEqualToString:@"topic"]){//专题
      
        ActionPage *actionPage=[[ActionPage alloc] initWithNibName:@"ActionPage" bundle:nil];
        actionPage.topicid=str2;
        [self.navigationController pushViewController:actionPage animated:YES];
        NSString *str = [NSString stringWithFormat:@"活动html打开专题ID%@",str2];
        [MTA trackCustomKeyValueEvent:LYCLICK_MTA props:[self createMTADctionaryWithActionName:@"跳转" pageName:HOMEPAGE_MTA titleName:str]];
    }else if (![MyUtil isEmptyString:str1]&& [str1 isEqualToString:@"activity"]){//专题活动
        NSString *str = [NSString stringWithFormat:@"活动html打开专题活动ID%@",str2];
        [MTA trackCustomKeyValueEvent:LYCLICK_MTA props:[self createMTADctionaryWithActionName:@"跳转" pageName:HOMEPAGE_MTA titleName:str]];
        ActionDetailViewController *actionDetailVC = [[ActionDetailViewController alloc]init];
        actionDetailVC.actionID=str2;
        [self.navigationController pushViewController:actionDetailVC animated:YES];
    }
    
    
}



- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *urlString = [[request URL] absoluteString];
    urlString = [urlString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"urlString=%@",urlString);
    NSArray *urlComps = [urlString componentsSeparatedByString:@"://"];
    
    if([urlComps count] && [[urlComps objectAtIndex:0] isEqualToString:@"objc"])
    {
        
        NSArray *arrFucnameAndParameter = [(NSString*)[urlComps objectAtIndex:1] componentsSeparatedByString:@":/"];
        NSString *funcStr = [arrFucnameAndParameter objectAtIndex:0];
        
        if (1 == [arrFucnameAndParameter count])
        {
            // 没有参数
            if([funcStr isEqualToString:@"doFunc1"])
            {
                
                /*调用本地函数1*/
                NSLog(@"doFunc1");
                
            }
        }
        else
        {
            //有参数的
            if([funcStr isEqualToString:@"getParam1:withParam2:"])
            {
                [self getParam1:[arrFucnameAndParameter objectAtIndex:1] withParam2:[arrFucnameAndParameter objectAtIndex:2]];
            }
        }
        return NO;
    }
    return TRUE;
}

@end
