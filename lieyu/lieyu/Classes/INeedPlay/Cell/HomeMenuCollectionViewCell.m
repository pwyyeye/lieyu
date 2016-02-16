//
//  HomeMenuCollectionViewCell.m
//  lieyu
//
//  Created by 狼族 on 16/1/25.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "HomeMenuCollectionViewCell.h"

@implementation HomeMenuCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    self.imgView_bg.layer.cornerRadius = 2;
    self.imgView_bg.layer.masksToBounds = YES;
    self.imgView_bg.layer.shouldRasterize = YES;
    
    self.imgView_bg.layer.borderWidth = 0.5;
    self.imgView_bg.layer.borderColor = RGBA(204, 204, 204, 1).CGColor;
//    self.shadowView.layer.cornerRadius = 2;
//    self.shadowView.layer.shadowColor = RGBA(0, 0, 0, .2).CGColor;
//    self.shadowView.layer.shadowOffset = CGSizeMake(0, .5);
//    self.shadowView.layer.shadowRadius = 1;
//    self.shadowView.layer.shadowOpacity = 1;
}

@end
