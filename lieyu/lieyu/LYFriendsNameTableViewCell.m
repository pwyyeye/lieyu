//
//  LYFriendsNameTableViewCell.m
//  lieyu
//
//  Created by 狼族 on 15/12/25.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYFriendsNameTableViewCell.h"
#import "UIButton+WebCache.h"
#import "FriendsRecentModel.h"
#import "FriendsTagModel.h"

@implementation LYFriendsNameTableViewCell

- (void)awakeFromNib {
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _label_constellation.layer.cornerRadius = 2;
    _label_constellation.layer.masksToBounds = YES;
    
    _label_work.layer.cornerRadius = 2;
    _label_work.layer.masksToBounds = YES;
//    _label_work.layer.cornerRadius = CGRectGetHeight(_label_work.frame)/2.f;
//    _label_work.layer.borderColor = RGBA(186, 20, 227, 1).CGColor;
//    _label_work.layer.borderWidth = 0.5;
//    _label_work.layer.masksToBounds = YES;
}

- (void)setRecentM:(FriendsRecentModel *)recentM{
    _recentM = recentM;

    
    [_btn_headerImg sd_setBackgroundImageWithURL:[NSURL URLWithString:recentM.avatar_img] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"empyImage120"]];
    _btn_headerImg.layer.cornerRadius = CGRectGetHeight(_btn_headerImg.frame) / 2.f;
    _btn_headerImg.layer.masksToBounds = YES;
    [_btn_name setTitle:recentM.usernick forState:UIControlStateNormal];
    [_label_time setText:[MyUtil calculatedDateFromNowWith:recentM.date]];
    
    
    if(![MyUtil isEmptyString:[MyUtil getAstroWithBirthday:recentM.birthday]]){
         CGSize size = [[MyUtil getAstroWithBirthday:recentM.birthday] boundingRectWithSize:CGSizeMake(MAXFLOAT, 15) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]} context:nil].size;
        _label_constellation.text = [MyUtil getAstroWithBirthday:recentM.birthday];
        self.label_constellation_constraint_width.constant = size.width + 6;
        [self updateConstraints];
        _label_constellation.hidden = NO;
    }else{
                _label_constellation.hidden = YES;
    }
    
    if(recentM.tags.count){
        CGSize size = [((FriendsTagModel *)recentM.tags[0]).tagname boundingRectWithSize:CGSizeMake(MAXFLOAT, 15) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]} context:nil].size;
        self.label_work_contraint_width.constant = size.width + 6;
        [self updateConstraints];
            _label_work.text = ((FriendsTagModel *)recentM.tags[0]).tagname;
            _label_work.hidden = NO;
    }else{
        _label_work.hidden = YES;
    }
    
    NSString *topicNameStr = nil;
    if(_recentM.topicTypeName.length) topicNameStr = [NSString stringWithFormat:@"#%@#",_recentM.topicTypeName];
    CGSize topicSize = [topicNameStr boundingRectWithSize:CGSizeMake(MAXFLOAT, 30) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    NSMutableAttributedString *attributeStr = nil;
    if(_recentM.topicTypeName.length){
        
        attributeStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@%@",topicNameStr,recentM.message]];
    }else{
        attributeStr = [[NSMutableAttributedString alloc]initWithString:recentM.message];
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
//    if(topicNameStr.length) paragraphStyle.firstLineHeadIndent = topicSize.width;
    [paragraphStyle setLineSpacing:3];
    [attributeStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attributeStr length])];
    if(_recentM.topicTypeName.length){
        [attributeStr addAttribute:NSForegroundColorAttributeName value:RGBA(186, 40, 227, 1) range:NSMakeRange(0, topicNameStr.length)];
    }
    
    if(recentM.message != nil){
//        [_label_content setText:recentM.message];
        _label_content.attributedText = attributeStr;
    }else{
        _label_content.text = @" ";
    }
    
    [_btn_topic setTitle:topicNameStr forState:UIControlStateNormal];
    
}

- (void)updateConstraints{
    [super updateConstraints];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
