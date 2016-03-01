//
//  LYNewMessageTableViewCell.m
//  lieyu
//
//  Created by 狼族 on 15/12/26.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYNewMessageTableViewCell.h"
#import "FriendsNewsModel.h"
#import "UIButton+WebCache.h"

@implementation LYNewMessageTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _btn_headerImg.layer.cornerRadius = CGRectGetHeight(_btn_headerImg.frame) / 2.f;
    _btn_headerImg.layer.masksToBounds = YES;
}

- (void)setFriendsNesM:(FriendsNewsModel *)friendsNesM{
    _friendsNesM = friendsNesM;
    [_btn_name setTitle:friendsNesM.likeNickName forState:UIControlStateNormal];
    if([friendsNesM.type isEqualToString:@"0"]){//赞
        _label_message.hidden = YES;
        _imageView_zang.hidden = NO;
    }else{//评论
        _label_message.hidden = NO;
        _label_message.text = friendsNesM.comment;
        _imageView_zang.hidden = YES;
    }
    _label_time.text = [MyUtil calculateDateFromNowWith:friendsNesM.date];
    [_btn_headerImg sd_setBackgroundImageWithURL:[NSURL URLWithString:friendsNesM.likeUserIcon] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"empyImage120"]];
    
    CGSize size = [friendsNesM.message boundingRectWithSize:CGSizeMake(57, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} context:nil].size;
    if(size.height < 15){
        _label_myMessage.text = [NSString stringWithFormat:@"%@\n\n",friendsNesM.message];
    }else if(size.height > 15 && size.height <30 ){
        _label_myMessage.text = [NSString stringWithFormat:@"%@\n",friendsNesM.message];
    }else{
        _label_myMessage.text = friendsNesM.message;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
