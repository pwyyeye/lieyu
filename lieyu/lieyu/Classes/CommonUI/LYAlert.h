//
//  LYAlert.h
//  lieyu
//
//  Created by pwy on 15/10/29.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LYAlertType) {
    LYAlertTypeDefault = 0, // 默认 自下而上
    LYAlertTypeUpToDown = 1, // 自上而下
    LYAlertTypeCenter=2     //弹出居中
};

@protocol LYAlertDelegate <NSObject>

-(void)button_ok;

-(void)button_cancel;
 
@end

@interface LYAlert : UIView

-(instancetype)initWithType:(LYAlertType)type;

-(void)show;

@property(assign,nonatomic) LYAlertType alertType;

@property(strong,nonatomic) id<LYAlertDelegate> delegate;

//阴影部分
@property(strong,nonatomic) UIButton *shadeButton;
//显示部分
@property(strong,nonatomic) UIView *showView;
//确定
@property(strong,nonatomic) UIButton *btn_ok;
//取消
@property(strong,nonatomic) UIButton *btn_cancel;

//阴影部分占比 默认50％
@property(assign,nonatomic) CGFloat shade_proportion;

@end
