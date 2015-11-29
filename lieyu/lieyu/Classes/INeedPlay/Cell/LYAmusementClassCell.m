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

    
    self.label_lineTop.frame = CGRectMake(0, 0, 320, 0.5);
    self.label_line_middle.frame = CGRectMake(0, 44.5, 320, 0.5);
    self.label_line_bottom.bounds = CGRectMake(0, 0, 320, 0.5);
    
    for (UIImageView *igv in _imageViewArray) {
        igv.layer.cornerRadius = 4;
        igv.layer.masksToBounds = YES;
        
    }
    ((UIImageView *)_imageViewArray[0]).image = [UIImage imageNamed:@"激情夜店.jpg"];
        ((UIImageView *)_imageViewArray[1]).image = [UIImage imageNamed:@"文艺清吧.jpg"];
        ((UIImageView *)_imageViewArray[2]).image = [UIImage imageNamed:@"音乐清吧1.jpg"];
        ((UIImageView *)_imageViewArray[3]).image = [UIImage imageNamed:@"ktv.jpg"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
