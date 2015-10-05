//
//  LYWineBarInfoCell.m
//  lieyu
//
//  Created by newfly on 9/14/15.
//  Copyright (c) 2015 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYWineBarInfoCell.h"
#import "MacroDefinition.h"
#import "JiuBaModel.h"

@implementation LYWineBarInfoCell

- (void)awakeFromNib {
    // Initialization code
    _barNameLabel.textColor = UIColorFromRGB(0x333333);
    _barDescLabel.textColor = UIColorFromRGB(0x666666);
    _barAddrLabel.textColor = UIColorFromRGB(0x666666);

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCell:(JiuBaModel*)model
{
    //--TODO: 需要根据 右边的，酒吧类型和特色 修改cell的展示
    [_mImageView sd_setImageWithURL:[NSURL URLWithString:model.baricon] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    
    [_barNameLabel setText:model.barname];
    [_barDescLabel setText:model.subtitle];
    [_barAddrLabel setText:model.address];
    [_costLabel setText:@(model.lowest_consumption).stringValue];
    [_distanceLabel setText:model.distance];
    [_starLabel setText:model.star_num];

}
@end
