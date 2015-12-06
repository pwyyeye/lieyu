//
//  LYHotBarMenuView.h
//  lieyu
//
//  Created by 狼族 on 15/12/1.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LYHotBarMenuViewDelegate <NSObject>

- (void)didClickHotBarMenuDropWithButtonSection:(NSInteger)section dropButtonIndex:(NSInteger)index;

@end

@interface LYHotBarMenuView : UIView
@property (nonatomic,unsafe_unretained) id<LYHotBarMenuViewDelegate> delegate;
- (void)deployWithMiddleTitle:(NSString *)title ItemArray:(NSArray *)itemArray;
@end
