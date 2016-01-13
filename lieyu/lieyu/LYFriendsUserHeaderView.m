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
////    _btn_header.layer.cornerRadius = 5;
    _btn_header.layer.masksToBounds = YES;
//    _btn_header.clipsToBounds = YES;
//    _btn_header.layer.borderColor = RGBA(0, 0, 0, 0.5).CGColor;
//    _btn_header.layer.borderWidth = 2;
//    
//    _btn_header.layer.shadowColor = [[UIColor blackColor]CGColor];
//    _btn_header.layer.shadowOpacity = 0.8;
//    _btn_header.layer.shadowOffset = CGSizeMake(0, 10);
//    _btn_header.layer.masksToBounds = NO;
//    _btn_header.layer.shadowRadius = 10;
//    _btn_header.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:_btn_header.bounds cornerRadius:80].CGPath;
//    _btn_header.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:_btn_header.bounds cornerRadius:30].CGPath;
    
//    _btn_header.layer.shadowColor = [UIColor blackColor].CGColor;
//    _btn_header.layer.shadowOffset = CGSizeMake(10, 10);
//    _btn_header.layer.shadowOpacity = 0.8;
//    _btn_header.layer.shadowRadius = 20;
//    
//    _label_name.layer.shadowOffset = CGSizeMake(10, 10);
//    _label_name.layer.shadowColor = [UIColor blackColor].CGColor;
//    _label_name.layer.shadowRadius = 1;
    
    _btn_newMessage.layer.cornerRadius = 4;
    _btn_newMessage.layer.masksToBounds = YES;
    
    _imageView_NewMessageIcon.layer.cornerRadius = CGRectGetHeight(_imageView_NewMessageIcon.frame) / 2.f;
    _imageView_NewMessageIcon.layer.masksToBounds = YES;
}




@end
