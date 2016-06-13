//
//  LYGuWenBannerCollectionViewCell.m
//  lieyu
//
//  Created by 狼族 on 16/5/27.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYGuWenBannerCollectionViewCell.h"

@implementation LYGuWenBannerCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [[UIScreen mainScreen]scale];
    
    _imgView_banner.layer.cornerRadius = 2;
    _imgView_banner.layer.masksToBounds = YES;
}

@end
