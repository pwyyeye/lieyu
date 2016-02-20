//
//  LYBarDescTableViewCell.m
//  lieyu
//
//  Created by 狼族 on 15/12/9.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBarDescTableViewCell.h"


@implementation LYBarDescTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)drawRect:(CGRect)rect{
   
    
//    _label_left = [[UILabel alloc]initWithFrame:CGRectMake(0, 23, 25, 25)];
//    _label_left.text = @"“";
//    _label_left.backgroundColor = [UIColor redColor];
//    _label_left.textAlignment = NSTextAlignmentCenter;
//        _label_left.font = [UIFont boldSystemFontOfSize:30];
//    [self addSubview:_label_left];
//    
//    _label_right = [[UILabel alloc]initWithFrame:CGRectMake(0, 23, 25, 25)];
//    _label_right.text = @"”";
//    _label_right.font = [UIFont boldSystemFontOfSize:30];
//        _label_right.textAlignment = NSTextAlignmentCenter;
//        _label_right.backgroundColor = [UIColor redColor];
//    [self addSubview:_label_right];
    
    
    
}

- (void)setTitle:(NSString *)title{
    _title = title;
    UILabel *view_label = (UILabel *)[self viewWithTag:10086];
    if (view_label) {
        [view_label removeFromSuperview];
    }
    UIImageView *view_imgLeft = (UIImageView *)[self viewWithTag:100861];
    if (view_imgLeft) {
        [view_imgLeft removeFromSuperview];
    }
    UIImageView *view_imgRight = (UIImageView *)[self viewWithTag:100862];
    if (view_imgRight) {
        [view_imgRight removeFromSuperview];
    }
    _label_descr = [[UILabel alloc]initWithFrame:CGRectMake(87, 10, 144, 48)];
    _label_descr.numberOfLines = 0;
    _label_descr.tag = 10086;
    _label_descr.textAlignment = NSTextAlignmentCenter;
    _label_descr.font = [UIFont boldSystemFontOfSize:18];
    _label_descr.textColor = RGBA(26, 26, 26, 1);
    [self addSubview:_label_descr];
    _label_descr.text = title;
    
    _image_yinHao_left = [[UIImageView alloc]initWithFrame:CGRectMake(-40, 23, 24, 24)];
    _image_yinHao_left.image = [UIImage imageNamed:@"yinHao"];
    _image_yinHao_left.tag = 100861;
    [self addSubview:_image_yinHao_left];
    
    _image_yinHao_right = [[UIImageView alloc]initWithFrame:CGRectMake(-100, 23, 24, 24)];
    _image_yinHao_right.image = [UIImage imageNamed:@"yinHaoRight"];
    _image_yinHao_right.tag = 100862;
    [self addSubview:_image_yinHao_right];
    
    CGSize strSize = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, 48.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18]} context:nil].size;
    
    _label_descr.center = CGPointMake(SCREEN_WIDTH/2.0, _label_descr.center.y);
 NSLog(@"---------->%@",NSStringFromCGRect(_label_descr.frame));

    CGFloat maxWidth = SCREEN_WIDTH - 2 * (CGRectGetWidth(_image_yinHao_right.frame) + 18);
    if (strSize.width < maxWidth) {
         _label_descr.bounds = CGRectMake(0,0,strSize.width,48);
       
    }else {
        if(self.label_descr.frame.origin.x >1){
            _label_descr.bounds = CGRectMake(0, 0, maxWidth, CGRectGetHeight(_label_descr.frame));
        }
    }
    _image_yinHao_left.frame = CGRectMake(self.label_descr.frame.origin.x - 34, _image_yinHao_left.frame.origin.y, 24, 24);
    _image_yinHao_right.frame = CGRectMake(CGRectGetMaxX(self.label_descr.frame) +10, _image_yinHao_left.frame.origin.y, 24, 24);
}


@end
