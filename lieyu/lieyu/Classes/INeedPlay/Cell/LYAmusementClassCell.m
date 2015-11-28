//
//  LYAmusementClassCell.m
//  lieyu
//
//  Created by 狼族 on 15/11/27.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYAmusementClassCell.h"

@implementation LYAmusementClassCell

- (void)awakeFromNib {
    // Initialization code
//    self.scrollView.directionalLockEnabled = YES;
//    _imageView_three = [[UIImageView alloc]initWithFrame:CGRectMake(328, 8, 150, 150)];
//    _imageView_three.image = [UIImage imageNamed:@"CommonIcon"];
//    [self.scrollView addSubview:_imageView_three];
//    
//    _imageView_four = [[UIImageView alloc]initWithFrame:CGRectMake(328+ 160, 8, 150, 150)];
//    _imageView_four.image = [UIImage imageNamed:@"CommonIcon"];
//    [self.scrollView addSubview:_imageView_four];
    
    self.label_lineTop.frame = CGRectMake(0, 0, 320, 0.5);
    self.label_line_middle.frame = CGRectMake(0, 44.5, 320, 0.5);
    self.view_bottom.frame = CGRectMake(0,211, 320, 8);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
