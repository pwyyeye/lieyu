//
//  LoadingView.h
//  lieyu
//
//  Created by 狼族 on 16/3/15.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingView : UIView
- (instancetype)initWith:(UIView *)view;

- (void)hideAnimation:(BOOL)animation afterDelay:(NSInteger)delay;
@end
