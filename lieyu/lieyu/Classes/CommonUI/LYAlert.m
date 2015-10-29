//
//  LYAlert.m
//  lieyu
//
//  Created by pwy on 15/10/29.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYAlert.h"

@implementation LYAlert




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
}
*/
-(instancetype)initWithType:(LYAlertType)type{
    self=[super init]; 
    if (self) {
        if (type==LYAlertTypeDefault) {
            self.frame=CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);

        }else if (type==LYAlertTypeUpToDown){
            self.frame=CGRectMake(0, -SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
        }
        self.backgroundColor=CLEARCOLOR;
        self.shade_proportion=0.5;
        self.alertType=type;
        self.showView=[[UIView alloc] initWithFrame:CGRectZero];
    }
    return self;
}

-(void)show{
    //阴影部分高度
    CGFloat shadeHeight=SCREEN_HEIGHT*_shade_proportion-50;
    
    _shadeButton=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, shadeHeight)];
    
    [_shadeButton addTarget:self action:@selector(removeAlertView) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_shadeButton];
    
    CGFloat showHeight=SCREEN_HEIGHT-shadeHeight;
    UIView *buttomView=[[UIView alloc] initWithFrame:CGRectMake(0, shadeHeight, SCREEN_WIDTH, showHeight)];
    buttomView.backgroundColor=[UIColor whiteColor];
    [self addSubview:buttomView];
    
    UIView *barView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    barView.backgroundColor=RGB(247, 247, 247);
    
    
    //取消按钮
    if(_btn_cancel==nil){
        _btn_cancel=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 50)];
        [_btn_cancel setTitle:@"取消" forState:UIControlStateNormal];
        _btn_cancel.titleLabel.font=[UIFont systemFontOfSize:15];
        [_btn_cancel setTitleColor:RGB(35, 166, 116) forState:UIControlStateNormal];
        [_btn_cancel addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if(_btn_ok==nil){
        _btn_ok=[[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-80, 0, 80, 50)];
        [_btn_ok setTitleColor:RGB(35, 166, 116) forState:UIControlStateNormal];
        [_btn_ok setTitle:@"确定" forState:UIControlStateNormal];
        _btn_ok.titleLabel.font=[UIFont systemFontOfSize:15];
        [_btn_ok addTarget:self action:@selector(ok) forControlEvents:UIControlEventTouchUpInside];

    }
    [barView addSubview:_btn_ok];
    [barView addSubview:_btn_cancel];
    
   
    _showView.frame=CGRectMake(0, 50, SCREEN_WIDTH, showHeight-50);
    [buttomView addSubview:_showView];
    [buttomView addSubview:barView];
    
//    if (_alertType==LYAlertTypeDefault) {
        [self MoveView:self To:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) During:0.5];
        _shadeButton.backgroundColor=[UIColor colorWithWhite:0 alpha:0.2];
//    }
    
    
}
//代理方法
-(void)cancel{
    if ([self.delegate respondsToSelector:@selector(button_cancel)]) {
        [self.delegate button_cancel];
    }
}
//代理方法
-(void)ok{
    if ([self.delegate respondsToSelector:@selector(button_ok)]) {
        [self.delegate button_ok];
    }
}

-(void)removeAlertView{
    [self removeFromSuperview];
}

-(void)MoveView:(UIView *)view To:(CGRect)frame During:(float)time{
    
    // 动画开始
    
    [UIView beginAnimations:nil context:nil];
    
    // 动画时间曲线 EaseInOut效果
    
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    // 动画时间
    
    [UIView setAnimationDuration:time];
    
    view.frame = frame;
    
    // 动画结束（或者用提交也不错）
    
    [UIView commitAnimations];
    
}
@end
