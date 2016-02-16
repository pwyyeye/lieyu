//
//  HomeBarCollectionViewCell.m
//  lieyu
//
//  Created by 狼族 on 16/1/25.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "HomeBarCollectionViewCell.h"
#import "JiuBaModel.h"

@implementation HomeBarCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)drawRect:(CGRect)rect{
    self.imgView_bg.layer.cornerRadius = 2;
    self.imgView_bg.layer.masksToBounds = YES;
//    self.shadowView.layer.shadowColor = RGBA(0, 0, 0, .2).CGColor;
//    self.shadowView.layer.shadowOffset = CGSizeMake(0, .5);
//    self.shadowView.layer.shadowRadius = 1;
//    self.shadowView.layer.shadowOpacity = 1;
    self.imgView_bg.layer.borderWidth = 0.5;
    self.imgView_bg.layer.borderColor = RGBA(204, 204, 204, 1).CGColor;
    
    
    _view_cons_width.constant = 0.5;
    _view_cont_one_width.constant = 0.5;
    
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    _bulrView = [[UIVisualEffectView alloc]initWithEffect:effect];
    _bulrView.frame = CGRectMake(240, 20, 40, 40);
//    [self addSubview:_bulrView];
    _bulrView.layer.cornerRadius = CGRectGetWidth(_bulrView.frame) / 2.f;
    _bulrView.layer.masksToBounds = YES;
    _bulrView.layer.shouldRasterize = YES;
    
    _label_yu.layer.cornerRadius = 2;
    _label_yu.layer.masksToBounds = YES;
    
//    _label_address.shadowOffset = CGSizeMake(0, 0.5);
//    _label_barName.shadowOffset = CGSizeMake(0, 0.5);
//        _label_distance.shadowOffset = CGSizeMake(0, 0.5);
//        _label_fanli.shadowOffset = CGSizeMake(0, 0.5);
//        _label_price.shadowOffset = CGSizeMake(0, 0.5);
//    _label_barDescr.shadowOffset = CGSizeMake(0, 0.5);
//    _label_collect.shadowOffset = CGSizeMake(0, 0.5);
//        _label_zang.shadowOffset = CGSizeMake(0, 0.5);
}

- (void)setJiuBaM:(JiuBaModel *)jiuBaM{
    _jiuBaM = jiuBaM;
    
    _label_barName.text = jiuBaM.barname;
    if(jiuBaM.banners.count){
        [_imgView_bg sd_setImageWithURL:[NSURL URLWithString:jiuBaM.banners[0]] placeholderImage:[UIImage imageNamed:@"empyImage16_9"]];
    }
    
    _label_barDescr.text = jiuBaM.subtitle;
    _label_price.text = [NSString stringWithFormat:@"%@元起",jiuBaM.lowest_consumption];
    if([MyUtil isEmptyString:jiuBaM.addressabb]){
        _label_address.text = jiuBaM.addressabb;
        _view_line_distance.hidden = YES;
        _label_disstance_left_cons.constant = -7;
    }
    
    if(![MyUtil isEmptyString:jiuBaM.distance] && jiuBaM.distance.floatValue != 0.f){
        CGFloat distanceStr = jiuBaM.distance.floatValue * 1000;
        if (distanceStr > 1000) {
            [_label_distance setText:[NSString stringWithFormat:@"%.0fKM",distanceStr/1000]];
        }else{
            [_label_distance setText:[NSString stringWithFormat:@"%.0fM",distanceStr]];
        }
    }
    
    if ([jiuBaM.fav_num integerValue]) {
        int num = [jiuBaM.fav_num intValue];
        if(num < 10000){
            [_label_collect setText:jiuBaM.fav_num];
        }else{
            [_label_collect setText:[NSString stringWithFormat:@"%dw+",num / 10000]];
        }
    }else{
        [_label_collect setText:@"0"];
    }
    
    if ([jiuBaM.like_num integerValue]) {
        int num = [jiuBaM.like_num intValue];
        if(num < 10000){
            [_label_zang setText:jiuBaM.like_num ];
        }else{
              [_label_zang setText:[NSString stringWithFormat:@"%dw+",num / 10000] ];
        }
    }else{
         [_label_zang setText:@"0"];
    }
    
    int fanli=jiuBaM.rebate.floatValue * 100;
    
    NSLog(@"------>%@",jiuBaM.isSign);
    if([jiuBaM.isSign isEqualToString:@"0"]) _label_yu.hidden = YES;
    else _label_yu.hidden = NO;
    if (!fanli) {
        _label_fanli.text = @"";
        _label_fanli.hidden = YES;
        _view_withFanli.hidden = YES;
        _label_fanli_right_const.constant = 0;
        _view_fanli_right_const.constant = 2;
        return;
    }
    _label_fanli.hidden = NO;
    _view_withFanli.hidden = NO;
    _label_fanli_right_const.constant = 10;
    _view_fanli_right_const.constant = 7;
    _label_fanli.text =[NSString stringWithFormat:@"返利%d%@",fanli,@"%"];
}


@end
