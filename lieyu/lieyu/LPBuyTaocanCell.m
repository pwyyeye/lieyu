//
//  LPBuyTaocanCell.m
//  lieyu
//
//  Created by 王婷婷 on 15/12/2.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LPBuyTaocanCell.h"
#import "UIImageView+WebCache.h"

@implementation LPBuyTaocanCell

//
//@property (weak, nonatomic) IBOutlet UIImageView *LPimage;
//@property (weak, nonatomic) IBOutlet UILabel *LPName;
//@property (weak, nonatomic) IBOutlet UILabel *LPway;
//@property (weak, nonatomic) IBOutlet UILabel *LPprice;
//@property (weak, nonatomic) IBOutlet UILabel *LPmarketPrice;
//
- (void)awakeFromNib {
    self.LPName.textColor = RGBA(51, 51, 51, 1);
    self.LPway.textColor = RGBA(114, 5, 147, 1);
    self.LPprice.textColor = RGBA(255, 64, 64, 0.98);
    self.LPmarketPrice.textColor = RGBA(102, 102, 102, 1);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)cellConfigureWithImage:(NSString *)imageUrl name:(NSString *)name way:(NSString *)way price:(NSString *)price marketPrice:(NSString *)marketPrice{
    NSURL *image = [NSURL URLWithString:imageUrl];
    [self.LPimage sd_setImageWithURL:image];
    self.LPName.text = name;
    self.LPway.text = [NSString stringWithFormat:@"%@",way];
    self.LPprice.text = [NSString stringWithFormat:@"¥%@",price];
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName:
                                     [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"¥%@",marketPrice] attributes:attribtDic];
    self.LPmarketPrice.attributedText = attribtStr;
}

@end
