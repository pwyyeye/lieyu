//
//  LYPlayTogetherCell.m
//  lieyu
//
//  Created by 薛斯岐 on 15/10/15.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYPlayTogetherCell.h"
#import "PinKeModel.h"
#import "JiuBaModel.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
@implementation LYPlayTogetherCell

//@property (weak, nonatomic) IBOutlet UIImageView *pkIconImageView;//图片名
//@property (weak, nonatomic) IBOutlet UILabel *introductionLal;//介绍
//@property (weak, nonatomic) IBOutlet UILabel *barName;
//@property (weak, nonatomic) IBOutlet UILabel *price;//现价
//@property (weak, nonatomic) IBOutlet UILabel *superProfit;//
//@property (weak, nonatomic) IBOutlet UILabel *marketprice;//市场价
//@property (weak, nonatomic) IBOutlet UILabel *addressLal;//地址
//@property (weak, nonatomic) IBOutlet UIButton *pkBtn;//拼客按钮


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)configureCell:(PinKeModel*)model
{
    NSLog(@"LP----model:%@",model);
    //--TODO: 需要根据 右边的，酒吧类型和特色 修改cell的展示
    NSString *str=model.linkUrl;
    [_pkIconImageView  setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"empyImage120"]];
    
    _introductionLal.text=model.title;
    _barName.text = model.barinfo.barname;
//    _scLal.text=model.barinfo.fav_num;
    _price.text=[NSString stringWithFormat:@"¥%@",model.price];
    double profit = [model.price doubleValue] * [model.rebate doubleValue];
    _superProfit.text = [NSString stringWithFormat:@"超返利:%.2lf元",profit];
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"￥%@",model.marketprice] attributes:attribtDic];
    _marketprice.attributedText=attribtStr;
    _addressLal.text=model.barinfo.address;
}
@end
