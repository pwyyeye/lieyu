//
//  UserHeader.m
//  lieyu
//
//  Created by 狼族 on 16/8/13.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "UserHeader.h"

@implementation UserHeader

-(void)layoutSubviews{
    [self setCornerRadiusView:self.iconIamgeView With:self.iconIamgeView.frame.size.height/2  and:YES];
}


-(void)setCornerRadiusView:(UIView *) maskView With:(CGFloat) size and:(BOOL) mask{
    maskView.layer.cornerRadius = size;
    maskView.layer.masksToBounds = YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
