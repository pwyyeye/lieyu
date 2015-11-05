//
//  CarInfoCell.m
//  lieyu
//
//  Created by 薛斯岐 on 15/10/23.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "CarInfoCell.h"

#import "LYHomePageHttpTool.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
@implementation CarInfoCell

- (void)awakeFromNib {
    // Initialization code
    self.danPinImageView.layer.masksToBounds =YES;
    
    self.danPinImageView.layer.cornerRadius =self.danPinImageView.frame.size.width/2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)jiaAct:(UIButton *)sender {
    int count = self.numLal.text.intValue;
    count++;
    NSDictionary *dic=@{@"ids":[NSString stringWithFormat:@"%d",carModel.id],@"quantitys":[NSString stringWithFormat:@"%d",count]};
    [[LYHomePageHttpTool shareInstance]updataCarNumWithParams:dic complete:^(BOOL result) {
        self.numLal.text=[NSString stringWithFormat:@"%d",count];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"carnumChange" object:nil];
    }];
    

}

- (IBAction)jianAct:(UIButton *)sender {
    int count = self.numLal.text.intValue;
    if (count>1) {
        count--;
        NSDictionary *dic=@{@"ids":[NSString stringWithFormat:@"%d",carModel.id],@"quantitys":[NSString stringWithFormat:@"%d",count]};
        [[LYHomePageHttpTool shareInstance]updataCarNumWithParams:dic complete:^(BOOL result) {
            self.numLal.text=[NSString stringWithFormat:@"%d",count];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"carnumChange" object:nil];
        }];
    }
    
    
}
- (void)configureCell:(CarModel*)model
{
    carModel=model;
    [_danPinImageView  setImageWithURL:[NSURL URLWithString:model.product.image]];
    _nameLal.text=model.product.fullname;
    _delLal.text=[NSString stringWithFormat:@"(%@)",model.product.unit];
    _zhekouLal.text=model.product.price;
    _numLal.text=model.quantity;
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"￥%@",model.product.marketprice] attributes:attribtDic];
    _moneyLal.attributedText=attribtStr;
    
    NSString *flTem=[NSString stringWithFormat:@"再返利%.f%%",model.product.rebate.doubleValue*100];
    [_yjBtn setTitle:flTem forState:0];
}
@end
