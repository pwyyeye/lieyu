//
//  AlertBlock.h
//  lieyu
//
//  Created by 薛斯岐 on 15/11/5.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AlertBlock;
typedef void (^TouchBlock)(NSInteger) ;
@interface AlertBlock : UIAlertView
@property(nonatomic,copy)TouchBlock block;
//需要自定义初始化方法，调用Block
- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
  cancelButtonTitle:(NSString *)cancelButtonTitle
  otherButtonTitles:(NSString*)otherButtonTitles
              block:(TouchBlock)block;
@end
