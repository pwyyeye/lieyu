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

- (void)awakeFromNib{
    _addToShoppingCarBtn.layer.cornerRadius = 2;
    _addToShoppingCarBtn.layer.masksToBounds = YES;
    self.goodImage.image=nil;
    self.layer.borderColor = [RGBA(237, 237, 237, 1)CGColor];
    self.layer.borderWidth = 0.5;
    self.layer.cornerRadius = 2.f;
    self.layer.masksToBounds = YES;
    self.userInteractionEnabled = YES;
}

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
            NSDictionary *dict = @{@"actionName":@"确定",@"pageName":@"吃喝专场",@"titleName":@"加入购物车",@"value":self.model.fullname};
            [MTA trackCustomKeyValueEvent:@"LYClickEvent" props:dict];
            [MyUtil showCleanMessage:@"添加购物车成功!"];
            [self.delegate refreshGoodsNum];
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
    _addToShoppingCarBtn.tag = model.id;
    _PriceLbl.text=[NSString stringWithFormat:@"￥%@",model.price];
    float profit = [model.price floatValue] * model.rebate ;
    if(profit == 0){
        _ProfitLbl.hidden = YES;
        _fanliImage.hidden = YES;
        _fanliLbl.hidden = YES;
    }else{
       _ProfitLbl.text=[NSString stringWithFormat:@"%.1f元",profit];
    }
    
    [_goodImage sd_setImageWithURL:[NSURL URLWithString:model.img_260] placeholderImage:[UIImage imageNamed:@"empyImage120"]];
    self.lessBtn.enabled = NO;
}
@end
