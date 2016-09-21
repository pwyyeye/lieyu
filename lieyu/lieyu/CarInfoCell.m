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
    [super awakeFromNib];
    self.lessbtn.enabled = NO;
//    self.danPinImageView.layer.masksToBounds =YES;
//    
//    self.danPinImageView.layer.cornerRadius =self.danPinImageView.frame.size.width/2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)changeNum:(UIButton *)sender {
    int count = self.numLal.text.intValue;
    if(sender.tag == 1){
        count --;
        if(count <= 1){
            _lessbtn.enabled = NO;
            [_lessbtn setBackgroundImage:[UIImage imageNamed:@"gray_less"] forState:UIControlStateNormal];
        }
        carModel.quantity = [NSString stringWithFormat:@"%d",[carModel.quantity intValue] - 1];
        _numLal.text = carModel.quantity;
    }else if(sender.tag == 2){
        count ++;
        if(_lessbtn.enabled == NO){
            _lessbtn.enabled = YES;
            [_lessbtn setBackgroundImage:[UIImage imageNamed:@"purper_less"] forState:UIControlStateNormal];
        }
        carModel.quantity = [NSString stringWithFormat:@"%d",[carModel.quantity intValue] + 1];
        _numLal.text = carModel.quantity;
    }
    [self.delegate carlistFooterPrice:self.tag];
//    NSDictionary *dic=@{@"ids":[NSString stringWithFormat:@"%d",carModel.id],@"quantitys":[NSString stringWithFormat:@"%d",count]};
//    [[LYHomePageHttpTool shareInstance]updataCarNumWithParams:dic complete:^(BOOL result) {
//        self.numLal.text=[NSString stringWithFormat:@"%d",count];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"carnumChange" object:nil];
//    }];
    

}

- (void)configureCell:(CarModel*)model
{
    carModel=model;
    [_danPinImageView sd_setImageWithURL:[NSURL URLWithString:model.product.image] placeholderImage:[UIImage imageNamed:@"empyImage120"]];
    _nameLal.text=model.product.fullname;
    _delLal.text=[NSString stringWithFormat:@"(%@)",model.product.unit];
    _zhekouLal.text=[NSString stringWithFormat:@"¥%@",model.product.price];
    _numLal.text=model.quantity;
    if([_numLal.text intValue] > 1){
        self.lessbtn.enabled = YES;
        [self.lessbtn setBackgroundImage:[UIImage imageNamed:@"purper_less"] forState:UIControlStateNormal];
    }else{
        self.lessbtn.enabled = NO;
        [self.lessbtn setBackgroundImage:[UIImage imageNamed:@"gray_less"] forState:UIControlStateNormal];
    }
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"￥%@",model.product.marketprice] attributes:attribtDic];
    _moneyLal.attributedText=attribtStr;
    
//    NSString *flTem=[NSString stringWithFormat:@"再返利%.f%%",model.product.rebate.doubleValue*100];
    _presentLbl.text = [NSString stringWithFormat:@"%.f%%",[model.product.rebate doubleValue]* 100];
//    [_yjBtn setTitle:flTem forState:0];
}
@end
