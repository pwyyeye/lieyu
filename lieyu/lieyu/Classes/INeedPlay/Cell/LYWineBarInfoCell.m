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
    _label_line_bottom.frame = CGRectMake(0, 319, 320, 0.5);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCell:(JiuBaModel*)model
{
    /*
    NSString *str=model.baricon ;
    //--TODO: 需要根据 右边的，酒吧类型和特色 修改cell的展示
    [_mImageView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    
    [_barNameLabel setText:model.barname];
    [_barDescLabel setText:model.subtitle];
    [_barAddrLabel setText:model.address];
    [_scCountLal setText:model.fav_num];
    [_costLabel setText:[NSString stringWithFormat:@"￥%@起",model.lowest_consumption]];
    [_distanceLabel setText:[NSString stringWithFormat:@"%@km",model.distance]];
    [_starLabel setText:model.star_num];
*/
}
@end
