//
//  CHDetailCollectionCell.m
//  lieyu
//
//  Created by 薛斯岐 on 15/10/22.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "chiheDetailCollectionCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "LYHomePageHttpTool.h"

@implementation chiheDetailCollectionCell

- (IBAction)ChangeGoodsNumberClick:(UIButton *)sender{
    int num = [self.numField.text intValue];
    
    if(sender.tag == 1 && sender.enabled == YES){
        self.numField.text = [NSString stringWithFormat:@"%d",--num];
        if(self.addBtn.enabled == NO){
            self.addBtn.enabled = YES;
            [self.addBtn setBackgroundImage:[UIImage imageNamed:@"purper_add"] forState:UIControlStateNormal];
        }
    }else if(sender.tag == 2 && sender.enabled == YES){
        self.numField.text = [NSString stringWithFormat:@"%d",++num ];
        if(self.lessBtn.enabled == NO){
            self.lessBtn.enabled = YES;
            [self.lessBtn setBackgroundImage:[UIImage imageNamed:@"purper_less"] forState:UIControlStateNormal];
        }
    }
    if(num <= 1){
        self.lessBtn.enabled = NO;
        [self.lessBtn setBackgroundImage:[UIImage imageNamed:@"gray_less"] forState:UIControlStateNormal];
    }
//    else if(num >= 11){
//        self.addBtn.enabled = NO;
//        [self.addBtn setBackgroundImage:[UIImage imageNamed:@"gray_add"] forState:UIControlStateNormal];
//    }
}

- (IBAction)AddToShoppingCarClick:(UIButton *)sender {
    NSDictionary *dic=@{@"product_id":[NSNumber numberWithInt:self.model.id],@"quantity":self.numField.text};
    [[LYHomePageHttpTool shareInstance] addCarWithParams:dic block:^(BOOL result) {
        if (result) {
            [MyUtil showMessage:@"添加购物车成功!"];
        }
    }];

}

-(void)configureCell:(CheHeModel *)model{
    self.model = model;
    _GoodNameLbl.text=model.fullname;
    if(model.marketprice){
        NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
        NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"￥%@",model.marketprice] attributes:attribtDic];
        _MarketPriceLbl.attributedText=attribtStr;
    }
    _numField.text = @"1";
    _PriceLbl.text=[NSString stringWithFormat:@"￥%@",model.price];
    _ProfitLbl.text=[NSString stringWithFormat:@"%.f元",[model.price floatValue] * model.rebate];
    [_goodImage sd_setImageWithURL:[NSURL URLWithString:model.img_260] placeholderImage:[UIImage imageNamed:@"empyImage120"]];
    self.lessBtn.enabled = NO;
}
@end
