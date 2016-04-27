//
//  LYBaseViewController.h
//  lieyu
//
//  Created by SEM on 15/9/14.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//


#import "UIViewExt.h"
#import <UIKit/UIKit.h>
#import "IMchatViewController.h"
@interface LYBaseViewController : UIViewController
@property (nonatomic,retain)UserModel *userModel;
- (NSString *)randomStringWithLength:(int)len;
- (NSString *)getDateTimeString;
- (void)setCustomTitle:(NSString *)title;
-(void)showMessage:(NSString*) message;

-(void)BaseGoBack;

-(void)initMJRefeshHeaderForGif:(MJRefreshGifHeader *) header;
-(void)initMJRefeshFooterForGif:(MJRefreshBackGifFooter *) footer;

- (NSDictionary *)createMTADctionaryWithActionName:(NSString *)actionName pageName:(NSString *)pageName titleName:(NSString *)titleName;
@end
