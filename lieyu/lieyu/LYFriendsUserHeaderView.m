//
//  LYFriendsUserHeaderView.m
//  lieyu
//
//  Created by 狼族 on 15/12/26.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYFriendsUserHeaderView.h"

@implementation LYFriendsUserHeaderView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    _btn_header.layer.cornerRadius = CGRectGetHeight(_btn_header.frame) / 2.f;
    _btn_header.layer.masksToBounds = YES;
    
    _btn_newMessage.layer.cornerRadius = 4;
    _btn_newMessage.layer.masksToBounds = YES;
}




@end
