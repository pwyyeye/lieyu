//
//  LYYUTableViewCell.m
//  lieyu
//
//  Created by 狼族 on 16/1/31.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYYUTableViewCell.h"
#import "UIButton+WebCache.h"
#import "YUOrderShareModel.h"
#import "YUOrderInfo.h"
#import "YUPinkerListModel.h"
#import "JiuBaModel.h"

@implementation LYYUTableViewCell

- (void)awakeFromNib {
    
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _btn_headerImg.layer.cornerRadius = CGRectGetHeight(_btn_headerImg.frame)/2.f;
    _btn_headerImg.layer.masksToBounds = YES;
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(68, 180, SCREEN_WIDTH - 68 - 16, 0.5)];
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
    
    _btn_more = [[UIButton alloc]init];
    UIButton *lastBtn = ((UIButton *)_btnArray[4]);
    CGRect rect = lastBtn.frame;
    _btn_more.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
    _btn_more.backgroundColor = COMMON_PURPLE_HALF;
    [lastBtn addSubview:_btn_more];
    
    for (UIButton *btn in _btnArray) {
        btn.layer.cornerRadius = CGRectGetHeight(btn.frame)/2.f;
        btn.layer.masksToBounds = YES;
        btn.hidden = YES;
    }
}

- (void)setOrderModel:(YUOrderShareModel *)orderModel{
    _orderModel = orderModel;
    [_btn_headerImg sd_setBackgroundImageWithURL:[NSURL URLWithString:orderModel.orderInfo.avatar_img] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"lieyuIcon"]];
//    _label_age.text = [NSString stringWithFormat:@"%d",orderModel.orderInfo.]
    _label_name.text = orderModel.orderInfo.username;
    
    if (![MyUtil isEmptyString:orderModel.orderInfo.birthday]) {
         _label_age.text = [NSString stringWithFormat:@"%@岁",[MyUtil getAgefromDate:orderModel.orderInfo.birthday]];
        _label_constell.text = [MyUtil getAstroWithBirthday:orderModel.orderInfo.birthday];
    }else{
        _label_age.hidden = YES;
        _label_constell.hidden = YES;
    }
    
    _label_distance.text = orderModel.orderInfo.barinfo.distance;
    
    _label_message.text = orderModel.shareContent;
    
    _label_fanshi.text = [NSString stringWithFormat:@"[%@]",orderModel.orderInfo.orderStatusName];
    
    if (orderModel.orderInfo.tags.count) {
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
            sexStr = @"男女均可";
            break;
    }
    _label_peopleCount.text = [NSString stringWithFormat:@"邀请人数: %@ (%@)", orderModel.orderInfo.allnum,sexStr];
    
    NSArray *reachTimeArray1 = [orderModel.orderInfo.reachtime componentsSeparatedByString:@" "];
    if (reachTimeArray1.count == 2) {
        NSArray *reachTimeArray2 = [reachTimeArray1[0] componentsSeparatedByString:@"-"];
        NSArray *reachTimeArray3 = [reachTimeArray1[1] componentsSeparatedByString:@":"];
        if (reachTimeArray2.count == 3 && reachTimeArray3.count == 3) {
            NSString *timeStr = [NSString stringWithFormat:@"%@-%@ (%@) %@:%@",reachTimeArray2[1],reachTimeArray2[2],[MyUtil weekdayStringFromDate:orderModel.orderInfo.reachtime],reachTimeArray3[0],reachTimeArray3[1]];
            _label_concreteTime.text = timeStr;
        }
    }
    
    _label_peoplePercent.text = [NSString stringWithFormat:@"以参与(%u / %@)",orderModel.orderInfo.pinkerList.count,orderModel.orderInfo.allnum];
    
    if (![MyUtil isEmptyString:orderModel.orderInfo.barinfo.address]) {
        _label_address.text = orderModel.orderInfo.barinfo.address;
    }
    
    _label_time.text = [MyUtil residueTimeFromDate:orderModel.orderInfo.reachtime];
//    _label_time.text = [MyUtil residueTimeFromDate:@"2016-02-01 20:45:39"];
    
    _label_barName.text = orderModel.orderInfo.barinfo.barname;
//    _label_distance.text = orderModel.orderInfo.

    for (int i = 0; i < orderModel.orderInfo.pinkerList.count; i ++) {
        if (i >= 5) {
            return;
        }
        YUPinkerListModel *pinkerInfo = orderModel.orderInfo.pinkerList[i];
        UIButton *btn = _btnArray[i];
        [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:pinkerInfo.inmenberAvatar_img] forState:UIControlStateNormal];
        btn.hidden = NO;
    }
    
    if(orderModel.orderInfo.pinkerList.count >= 5) [_btn_more setTitle:[NSString stringWithFormat:@"%u",orderModel.orderInfo.pinkerList.count] forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
