//
//  LYBarDescTitleTableViewCell.m
//  lieyu
//
//  Created by 狼族 on 15/11/29.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBarDescTitleTableViewCell.h"

@implementation LYBarDescTitleTableViewCell

- (void)awakeFromNib {
    // Initialization code
   
}

- (void)drawRect:(CGRect)rect{

     _image_yinHao_left.frame = CGRectMake(0, 0, 24, 24);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)configneCellWith:(NSString *)title{
    
   
    
    _label_descr.text = title;
    
    CGSize strSize = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, 48.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18]} context:nil].size;
   
    _label_descr.center = CGPointMake(SCREEN_WIDTH/2.0, _label_descr.center.y);

    if (self.label_descr.frame.origin.x > 38) {
        _image_yinHao_left.frame = CGRectMake(self.label_descr.frame.origin.x - 24, self.image_yinHao_left.frame.origin.y, 24, 24);
        _image_yinHao_right.frame = CGRectMake(CGRectGetMaxX(self.label_descr.frame) + 24, self.image_yinHao_left.frame.origin.y, 24, 24);
         _label_descr.bounds = CGRectMake(0,0,strSize.width,48);
    }else{
        _label_descr.bounds = CGRectMake(0, 0, 256, CGRectGetHeight(_label_descr.frame));
    }
    
    
    
                                                                                                                                     
}

@end
