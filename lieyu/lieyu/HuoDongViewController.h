//
//  HuoDongViewController.h
//  lieyu
//
//  Created by pwy on 15/12/8.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBaseViewController.h"

@interface HuoDongViewController : LYBaseViewController<UIWebViewDelegate>

@property(strong,nonatomic) UIWebView *webView;
@property(strong,nonatomic) NSString *content;
@property(strong,nonatomic) UIScrollView *scrollView;
@property(assign,nonatomic) NSInteger linkid;
@property (nonatomic, strong) NSString *subTitle;

@end
