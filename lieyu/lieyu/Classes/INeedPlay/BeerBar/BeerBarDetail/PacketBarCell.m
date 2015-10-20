//
//  PacketBarCell.m
//  lieyu
//
//  Created by newfly on 9/20/15.
//  Copyright © 2015 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "PacketBarCell.h"
#import "RecommendPackageModel.h"

@interface PacketBarCell ()

@property(nonatomic,weak)IBOutlet UIView * delLine;

@end

@implementation PacketBarCell

- (void)awakeFromNib {
    // Initialization code
    _labFanli.layer.cornerRadius = 10.0f;
    _labFanli.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)configureCell:(RecommendPackageModel *)model
{
    if (model == nil) {
        return;
    }
    
    _labBuyerDetail.text = [NSString stringWithFormat:@"%@人已购买[适合%@-%@人]",model.buynum
                            ,model.minnum,model.maxnum];
    [_photoImage sd_setImageWithURL:[NSURL URLWithString:model.linkUrl] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
//    _labFanli.text = model.
    _labCost.text = model.price.stringValue;
    if (model.maketprice == nil) {
        _delLine.hidden = YES;
    }
    else
    {
        _delLine.hidden = NO;
    }
    _labCostDel.text = model.maketprice.stringValue;
    _labTitle.text = model.title;
    _labFanli.text = [NSString stringWithFormat:@"再返利%d%%",(int)([model.rebate doubleValue]*100)];
    _labFanli.adjustsFontSizeToFitWidth = YES;
}



@end
