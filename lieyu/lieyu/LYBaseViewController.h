//
//  LYBaseViewController.h
//  lieyu
//
//  Created by SEM on 15/9/14.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//


#import "UIViewExt.h"
#import <UIKit/UIKit.h>
@interface LYBaseViewController : UIViewController
- (NSString *)randomStringWithLength:(int)len;
- (NSString *)getDateTimeString;
- (void)setCustomTitle:(NSString *)title;
-(void)showMessage:(NSString*) message;
@end
