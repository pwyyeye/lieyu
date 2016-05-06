//
//  LYYuWishesListTableViewCell.m
//  lieyu
//
//  Created by 王婷婷 on 16/4/22.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYYuWishesListTableViewCell.h"
#import "LYYUHttpTool.h"
@implementation LYYuWishesListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _bgView.layer.borderWidth = 0.5;
    _bgView.layer.borderColor = [RGBA(204, 204, 204, 1) CGColor];
    _avatarImage.layer.cornerRadius = 30;
    _avatarImage.layer.masksToBounds = YES;
    _reLabel.layer.cornerRadius = 2;
    _reLabel.layer.masksToBounds = YES;
    _shareButton.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(YUWishesModel *)model{
    _model = model;
    UserModel *userModel = ((AppDelegate *)[UIApplication sharedApplication].delegate).userModel;
    if (userModel.userid == _model.releaseUserid) {
        _reportButton.hidden = YES;
        if ([model.isfinishedStr isEqualToString:@"搞定"] || [model.isfinishedStr isEqualToString:@"扑街"]) {
            //非空，里面有字符串：搞定／扑街
            _shareButton.hidden = NO;
            [_shareButton addTarget:self action:@selector(delegateShare) forControlEvents:UIControlEventTouchUpInside];
        }else{
            _shareButton.hidden = YES;
        }
    }else{
        _reportButton.hidden = NO;
    }
    CGRect themeRect = [_model.tagName boundingRectWithSize:CGSizeMake(MAXFLOAT, 16) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil];
    _themeWidth.constant = themeRect.size.width + 10;
    _themeLabel.layer.cornerRadius = 8;
    _themeLabel.layer.masksToBounds = YES;
    [_themeLabel setText:[NSString stringWithFormat:@"  %@",_model.tagName]];
    [_avatarImage sd_setImageWithURL:[NSURL URLWithString:_model.releaseAvatarImg] placeholderImage:[UIImage imageNamed:@"empyImage120"]];
    [_usernickLabel setText:_model.releaseUserName];
    [_contentLabel setText:_model.desc];
    if(_model.replyContent.length > 0){
        _reLabel.hidden = NO;
        _replyLabel.hidden = NO;
        [_replyLabel setText:_model.replyContent];
    }else{
        _replyLabel.hidden = YES;
        _reLabel.hidden = YES;
    }
//    if (_model.moneyEnd == _model.moneyStart) {
        [_balanceButton setTitle:[NSString stringWithFormat:@"  预估：¥%d",_model.moneyStart] forState:UIControlStateNormal];
//    }else{
//        [_balanceButton setTitle:[NSString stringWithFormat:@"  预估：¥%d-%d",_model.moneyStart,_model.moneyEnd] forState:UIControlStateNormal];
//    }
    [_timeLabel setText:[_model.createDate substringToIndex:_model.createDate.length - 3]];
    if(_model.replyContent.length > 0 && userModel.userid == _model.releaseUserid && [_model.isfinished isEqualToString:@"0"]){
        //未选择&&是我自己
        _addressImage.hidden = YES;
        _addressLabel.hidden = YES;
        _finishButton.hidden = NO;
        _unFinishButton.hidden = NO;
        _orLabel.hidden = NO;
        [_finishButton addTarget:self action:@selector(finishClick) forControlEvents:UIControlEventTouchUpInside];
        [_unFinishButton addTarget:self action:@selector(unFinishClick) forControlEvents:UIControlEventTouchUpInside];
    }else{
        _addressLabel.hidden = NO;
        _addressImage.hidden = NO;
        _finishButton.hidden = YES;
        _unFinishButton.hidden = YES;
        _orLabel.hidden = YES;
        [_addressLabel setText:_model.address];
    }
    if ([model.isfinishedStr isEqualToString:@"搞定"]) {
        _isFinishImage.hidden = NO;
//        [_isFinishImage setBackgroundColor:[UIColor purpleColor]];
        [_isFinishImage setImage:[UIImage imageNamed:@"YU_gaoding"]];
    }else if ([model.isfinishedStr isEqualToString:@"扑街"]){
        _isFinishImage.hidden = NO;
//        [_isFinishImage setBackgroundColor:[UIColor grayColor]];
        [_isFinishImage setImage:[UIImage imageNamed:@"YU_pujie"]];
    }else{
        _isFinishImage.hidden = YES;
    }
}

#pragma mark - 搞定／扑街
- (void)finishClick{
    NSDictionary *dict = @{@"id":[NSNumber numberWithInt:_model.id],
                           @"isfinished":@"1"};
    [LYYUHttpTool YUFinishWishOrNotWithParams:dict complete:^(BOOL result) {
        if (result == YES) {
            //搞定
            _model.isfinished = @"1";
            _model.isfinishedStr = @"搞定";
            _isFinishImage.hidden = NO;
            [_isFinishImage setImage:[UIImage imageNamed:@"YU_gaoding"]];
            _addressLabel.hidden = NO;
            _addressImage.hidden = NO;
            _finishButton.hidden = YES;
            _unFinishButton.hidden = YES;
            _orLabel.hidden = YES;
            _shareButton.hidden = NO;
            [_addressLabel setText:_model.address];
            if ([self.delegate respondsToSelector:@selector(deleteUnFinishedNumber)]) {
                [self.delegate deleteUnFinishedNumber];
            }
            if([self.delegate respondsToSelector:@selector(delegateShareWish:)]){
                [self.delegate delegateShareWish:_model];
            }
        }
    }];
}

- (void)unFinishClick{
    NSDictionary *dict = @{@"id":[NSNumber numberWithInt:_model.id],
                           @"isfinished":@"2"};
    [LYYUHttpTool YUFinishWishOrNotWithParams:dict complete:^(BOOL result) {
        if (result == YES) {
            //扑街
            _model.isfinished = @"2";
            _model.isfinishedStr = @"扑街";
            _isFinishImage.hidden = NO;
//            [_isFinishImage setBackgroundColor:[UIColor grayColor]];
            [_isFinishImage setImage:[UIImage imageNamed:@"YU_pujie"]];
            _addressLabel.hidden = NO;
            _addressImage.hidden = NO;
            _finishButton.hidden = YES;
            _unFinishButton.hidden = YES;
            _orLabel.hidden = YES;
            [_addressLabel setText:_model.address];
            _shareButton.hidden = NO;
            if ([self.delegate respondsToSelector:@selector(deleteUnFinishedNumber)]) {
                [self.delegate deleteUnFinishedNumber];
            }
            if ([self.delegate respondsToSelector:@selector(delegateShareWish:)]) {
                [self.delegate delegateShareWish:_model];
            }
        }
    }];
}

- (void)delegateShare{
    if ([self.delegate respondsToSelector:@selector(delegateShareWish:)]) {
        [self.delegate delegateShareWish:_model];
    }
}

@end
