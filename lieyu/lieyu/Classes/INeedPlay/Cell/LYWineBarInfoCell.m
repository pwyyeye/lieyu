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
    _label_jiuba.textColor = RGB(114, 5, 147);
    _label_price.textColor = RGB(255, 64, 64);
    _label_line_red.frame = CGRectMake(0, 0.5, 4, 45);
    /*
    _imageView_fire.frame = CGRectMake(12, 12.5, 15, 20);
    
    _imageView_content.frame = CGRectMake(0, 106, 320, 177);
    //_imageView_content.backgroundColor = [UIColor cyanColor];
   // _imageView_content.image = [UIImage imageNamed:@"CommonIcon"];
   // [self.contentView sendSubviewToBack:<#(nonnull UIView *)#>
    _imageView_header.backgroundColor = [UIColor cyanColor];
    _imageView_header.frame = CGRectMake(10, 54, 44, 44);
    _label_jiuba.frame = CGRectMake(64, 54, 64, 20);
    _label_descr.frame = CGRectMake(64, 76, 320-64, 21);
    _label_price.frame = CGRectMake(248, 54, 64, 22);
    
    
    _imageView_rectangle.frame = CGRectMake(0, 106, 66.5, 42);
    _view_bottom.frame = CGRectMake(0, 323, 320, 8);
    _label_fanli.frame = CGRectMake(15, 110, 36, 9);
    _label_fanli_percent.frame = CGRectMake(13.5, 121.5, 37.5, 24);
    _label_descr.frame = CGRectMake(64, 79, 144, 21);
    _label_price.frame = CGRectMake(248, 57, 64, 21.5);
    
    _imageView_star.frame = CGRectMake(186.5, 261.5, 13.5, 13.5);
    _imageView_zang.frame = CGRectMake(260, 261.5, 14.5, 13);
    _label_star_count.frame = CGRectMake(205.5, 261.5, 29.5, 17);
    _label_zang_count.frame = CGRectMake(279.5, 261.5, 29.5, 17);
    
    _imageView_point.frame = CGRectMake(10, 291, 14, 20);
    _label_point.frame = CGRectMake(32, 291, 320, 18);
    
    _btn_star.frame = CGRectMake(180, 258, 60, 20);
    _btn_zang.frame = CGRectMake(255, 258, 60, 20);
    
    */
    
    _label_line_bottom.frame = CGRectMake(0, 319, 320, 0.5);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)drawRect:(CGRect)rect{
    if (_hidden) {
        _label_line_red.hidden = YES;
        _imageView_fire.hidden = YES;
        _label_hot.hidden = YES;
        _label_line.hidden = YES;
        _imageView_header.frame = CGRectMake(10, 8, 44, 44);
        _label_jiuba.frame = CGRectMake(64, 8, 40, 20);
        _label_descr.frame = CGRectMake(64, 31, 144, 21);
        _label_price.frame = CGRectMake(253, 8, 64, 21.5);
        _imageView_content.frame = CGRectMake(0, 60.3, 320, 177);
        _view_bottom.frame = CGRectMake(0, 273.5, 320, 8);
        
        _imageView_star.frame = CGRectMake(186.5 , 265 - 53, 13.5, 13.5);
        _imageView_zang.frame = CGRectMake(260 , 265 - 53, 14.5, 13);
        _label_star_count.frame = CGRectMake(205.5, 265 -53, 29.5, 17);
        _label_zang_count.frame = CGRectMake(279.5, 265 -53, 29.5, 17);
        
        _imageView_rectangle.frame = CGRectMake(0, 60, 60.5, 42);
        _label_fanli.frame = CGRectMake(15, 113-53, 36, 9);
        _label_fanli_percent.frame = CGRectMake(13.5, 125-53, 37.5, 24);
        
        _imageView_point.frame = CGRectMake(10, 294.5-53, 14, 20);
        _label_point.frame = CGRectMake(32, 295.5-53, 320, 18);
        
        _btn_star.frame = CGRectMake(180, 261.5-53, 60, 20);
        _btn_zang.frame = CGRectMake(255, 261.5-53, 60, 20);
        _label_line_bottom.frame = CGRectMake(0, 322-53, 320, 0.5);
}
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
