//
//  LPAlertView.h
//  lieyu
//
//  Created by 王婷婷 on 15/12/2.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LPAlertViewDelegate;

@interface LPAlertView : UIView

@property (nonatomic, strong) NSString *labelText;

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, assign) id<LPAlertViewDelegate> delegate;

- (instancetype)initWithDelegate:(id<LPAlertViewDelegate>) delegate buttonTitles:(NSString *)buttonTitles, ... NS_REQUIRES_NIL_TERMINATION;

- (void)show;

- (void)hide;

@end

@protocol LPAlertViewDelegate <NSObject>

- (void)LPAlertView:(LPAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end