//
//  HuoDongLinkViewController.h
//  lieyu
//
//  Created by pwy on 16/2/19.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBaseViewController.h"

@interface HuoDongLinkViewController : LYBaseViewController<UIWebViewDelegate>
@property(strong,nonatomic) UIWebView *webView;
@property(strong,nonatomic) NSString *linkUrl;

// 两个参数
-(void)getParam1:(NSString*)str1 withParam2:(NSString*)str2;
@end
