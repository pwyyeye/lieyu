//
//  LYHotBarMenuDropView.h
//  lieyu
//
//  Created by 狼族 on 15/12/1.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LYHotBarMenuDropViewDelegate <NSObject>

- (void)lyHotBarMenuButton:(UIButton *)menuBtn withIndex:(NSInteger)index;

@end


@interface LYHotBarMenuDropView : UIView

@property (nonatomic,strong) NSMutableArray *btnArray;
@property (nonatomic,unsafe_unretained) BOOL isYu;
@property (nonatomic,unsafe_unretained) id<LYHotBarMenuDropViewDelegate> delegate;
- (void)deployWithItemArrayWith:(NSArray *)itemArray;

- (void)deployWithItemArrayWith:(NSArray *)itemArray withTitle:(NSString *)title;

- (instancetype)initWithFrame:(CGRect)frame itemArray:(NSArray *)itemArray withTitle:(NSString *)title;
@end
