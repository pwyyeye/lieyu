//
//  LYYUCollectionViewCell.m
//  lieyu
//
//  Created by 狼族 on 16/2/2.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYYUCollectionViewCell.h"
#import "UIButton+WebCache.h"
#import "YUOrderShareModel.h"
#import "YUOrderInfo.h"
#import "YUPinkerListModel.h"
#import "JiuBaModel.h"
@implementation LYYUCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    self.view_cell.layer.shadowColor = RGBA(0, 0, 0, .2).CGColor;
    self.view_cell.layer.shadowOffset = CGSizeMake(0, 0.5);
    self.view_cell.layer.shadowRadius = 1;
    self.view_cell.layer.shadowOpacity = 1;
    
    self.view_cell.layer.cornerRadius = 2;
//    self.view_cell.layer.masksToBounds = YES;

    _btn_headerImg.layer.cornerRadius = CGRectGetHeight(_btn_headerImg.frame)/2.f;
    _btn_headerImg.layer.masksToBounds = YES;
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(68, 180 + 6, SCREEN_WIDTH - 68 - 25, 0.5)];
    lineView.backgroundColor = RGBA(204, 204, 204, 1);
    [self.view_cell addSubview:lineView];
    
    _label_constell.layer.cornerRadius = CGRectGetHeight(_label_constell.frame)/2.f;
    _label_constell.layer.masksToBounds = YES;
    _label_constell.layer.borderColor = RGBA(217, 217, 217, 1).CGColor;
    _label_constell.layer.borderWidth = 0.5;
    
    
    _label_work.layer.cornerRadius = CGRectGetHeight(_label_work.frame)/2.f;
    _label_work.layer.masksToBounds = YES;
    _label_work.layer.borderColor = RGBA(217, 217, 217, 1).CGColor;
    _label_work.layer.borderWidth = 0.5;
    

    CGFloat btnWidth = (SCREEN_WIDTH - 16 - 68 - 10 - 20 * 4)/5.f;
    for (UIButton *btn in _btnArray) {
        btn.layer.cornerRadius = btnWidth/2.f;
        btn.layer.masksToBounds = YES;
        btn.hidden = YES;
    }
    
    
    _btn_more = [[UIButton alloc]init];
    UIButton *lastBtn = ((UIButton *)_btnArray[4]);
    CGRect rect = CGRectMake(lastBtn.frame.origin.x, lastBtn.frame.origin.y, btnWidth, btnWidth);
    _btn_more.hidden = YES;
    _btn_more.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
    _btn_more.backgroundColor = RGBA(186, 20, 227, 0.5);
    [lastBtn addSubview:_btn_more];

}


- (void)setOrderModel:(YUOrderShareModel *)orderModel{
    _orderModel = orderModel;
    [_btn_headerImg sd_setBackgroundImageWithURL:[NSURL URLWithString:orderModel.orderInfo.avatar_img] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"CommonIcon"]];
    //    _label_age.text = [NSString stringWithFormat:@"%d",orderModel.orderInfo.]
    _label_name.text = orderModel.orderInfo.username;
    
    if (![MyUtil isEmptyString:orderModel.orderInfo.birthday]) {
        _label_age.text = [NSString stringWithFormat:@"%@岁",[MyUtil getAgefromDate:orderModel.orderInfo.birthday]];
        CGSize size = [[MyUtil getAstroWithBirthday:orderModel.orderInfo.birthday] boundingRectWithSize:CGSizeMake(MAXFLOAT, 21) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
        _label_constell_consWidth.constant = size.width + 20;
        [self updateConstraints];
        _label_constell.text = [MyUtil getAstroWithBirthday:orderModel.orderInfo.birthday];
    }else{
        _label_age.hidden = YES;
        _label_constell.hidden = YES;
    }
    
//    _label_distance.text = orderModel.orderInfo.barinfo.distance;
    if(![MyUtil isEmptyString:orderModel.orderInfo.barinfo.distance] && orderModel.orderInfo.barinfo.distance.floatValue != 0.f){
        CGFloat distanceStr = orderModel.orderInfo.barinfo.distance.floatValue * 1000;
        if (distanceStr > 1000) {
            [_label_distance setText:[NSString stringWithFormat:@"%.0fKM",distanceStr/1000]];
        }else{
            [_label_distance setText:[NSString stringWithFormat:@"%.0fM",distanceStr]];
        }
    }
    
    _label_message.text = orderModel.shareContent;
    
    if([orderModel.orderInfo.ordertype isEqualToString:@"0"]){
    _label_fanshi.text = @"[我请客]";
}else if([orderModel.orderInfo.ordertype isEqualToString:@"1"]){
    _label_fanshi.text = @"[AA付款]";
}

    if (orderModel.orderInfo.tags.count) {
        CGSize size = [orderModel.orderInfo.tags[0][@"tagname"] boundingRectWithSize:CGSizeMake(MAXFLOAT, 21) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
        _label_work_consWidth.constant = size.width + 20;
        [self updateConstraints];
        _label_work.text = orderModel.orderInfo.tags[0][@"tagname"];
    }else{
        _label_work.hidden = YES;
    }
    
    NSString *sexStr = nil;
    switch (orderModel.allowSex.integerValue) {
        case 0:
            sexStr = @"女";
            break;
        case 2:
            sexStr = @"男";
            break;
        case 3:
            sexStr = @"全部";
            break;
    }
    _label_peopleCount.text = [NSString stringWithFormat:@"邀请人数: %@ (%@)", orderModel.orderInfo.allnum,sexStr];
    
    NSArray *reachTimeArray1 = [orderModel.orderInfo.reachtime componentsSeparatedByString:@" "];
    if (reachTimeArray1.count == 2) {
        NSArray *reachTimeArray2 = [reachTimeArray1[0] componentsSeparatedByString:@"-"];
        NSArray *reachTimeArray3 = [reachTimeArray1[1] componentsSeparatedByString:@":"];
        if (reachTimeArray2.count == 3 && reachTimeArray3.count == 3) {
            NSString *timeStr = [NSString stringWithFormat:@"%@-%@  (%@)  %@:%@",reachTimeArray2[1],reachTimeArray2[2],[MyUtil weekdayStringFromDate:orderModel.orderInfo.reachtime],reachTimeArray3[0],reachTimeArray3[1]];
            _label_concreteTime.text = timeStr;
        }
    }
    
    _label_peoplePercent.text = [NSString stringWithFormat:@"已参与(%u / %@)",orderModel.orderInfo.pinkerCount,orderModel.orderInfo.allnum];
    
    if (![MyUtil isEmptyString:orderModel.orderInfo.barinfo.address]) {
        _label_address.text = orderModel.orderInfo.barinfo.addressabb;
    }
    
    _label_time.text = [MyUtil residueTimeFromDate:orderModel.orderInfo.reachtime];
    //    _label_time.text = [MyUtil residueTimeFromDate:@"2016-02-01 20:45:39"];
    
    _label_barName.text = orderModel.orderInfo.barinfo.barname;
    if (!_shortLineView) {
        _shortLineView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_label_address.frame) + 18, _label_distance.frame.origin.y + 3, 0.5, 10)];
        _shortLineView.backgroundColor = [UIColor grayColor];
        [self.view_cell addSubview:_shortLineView];
    }
    //    _label_distance.text = orderModel.orderInfo.
    
  /*  for (int i = 0; i < orderModel.orderInfo.pinkerList.count; i ++) {
        if (i >= 5) {
            return;
        }
        YUPinkerListModel *pinkerInfo = orderModel.orderInfo.pinkerList[i];
        UIButton *btn = _btnArray[i];
        [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:pinkerInfo.inmenberAvatar_img] forState:UIControlStateNormal];
        btn.hidden = NO;
    } */
    
    if(orderModel.orderInfo.pinkerList.count >= 5) [_btn_more setTitle:[NSString stringWithFormat:@"%u",orderModel.orderInfo.pinkerList.count] forState:UIControlStateNormal];
    
    
    for (int i = 0; i < orderModel.orderInfo.pinkerList.count; i ++) {
        if (i >= 5) {
            return;
        }
        YUPinkerListModel *pinkerInfo = orderModel.orderInfo.pinkerList[i];
        UIButton *btn = _btnArray[i];
        [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:pinkerInfo.inmenberAvatar_img] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"CommonIcon"]];
        btn.hidden = NO;
    }
    
    if (orderModel.orderInfo.pinkerList.count >= 5) {
        [_btn_more setTitle:[NSString stringWithFormat:@"%u",orderModel.orderInfo.pinkerList.count] forState:UIControlStateNormal];
    _btn_more.hidden = NO;
    }
}


- (void)updateConstraints{
    [super updateConstraints];
}

@end
