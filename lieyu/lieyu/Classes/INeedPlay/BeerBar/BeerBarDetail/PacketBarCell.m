//
//  PacketBarCell.m
//  lieyu
//
//  Created by newfly on 9/20/15.
//  Copyright © 2015 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "PacketBarCell.h"
#import "RecommendPackageModel.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
@interface PacketBarCell ()

@property(nonatomic,weak)IBOutlet UIView * delLine;

@end

@implementation PacketBarCell

- (void)awakeFromNib {
    // Initialization code
    _labFanli.layer.cornerRadius = 10.0f;
    _labFanli.layer.masksToBounds = YES;
    self.photoImage.layer.masksToBounds =YES;
    
    self.photoImage.layer.cornerRadius =self.photoImage.frame.size.width/2;
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
//    [_photoImage sd_setImageWithURL:[NSURL URLWithString:model.linkUrl] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        
//    }];
    [_photoImage setImageWithURL:[NSURL URLWithString:model.linkUrl]];
//    _labFanli.text = model.
    _labCost.text = [NSString stringWithFormat:@"￥%@",model.price.stringValue];
//    if (model.maketprice == nil) {
//        _delLine.hidden = YES;
//    }
//    else
//    {
//        _delLine.hidden = NO;
//    }
    if(model.marketprice){
        NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
        NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"￥%@",model.marketprice] attributes:attribtDic];
        _labCostDel.attributedText=attribtStr;
    }
    
    _labTitle.text = model.title;
    [_flBtn setTitle:[NSString stringWithFormat:@"再返利%d%%",(int)([model.rebate doubleValue]*100)] forState:0];
    
//    _labFanli.adjustsFontSizeToFitWidth = YES;
}



@end
