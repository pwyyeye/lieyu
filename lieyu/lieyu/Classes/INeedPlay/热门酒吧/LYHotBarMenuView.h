//
//  LYHotBarMenuView.h
//  lieyu
//
//  Created by 狼族 on 15/12/1.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LYHotBarMenuDropDelegate <NSObject>

- (void)didClickHotBarMenuDropWithIndex:(NSInteger)index;

@end

@interface LYHotBarMenuView : UIView
@property (nonatomic,unsafe_unretained) id<LYHotBarMenuDropDelegate> delegate;
- (void)deploy;
@end
