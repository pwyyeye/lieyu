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
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _label_constellation.layer.cornerRadius = 2;
    _label_constellation.layer.masksToBounds = YES;
    
    _label_work.layer.cornerRadius = 2;
    _label_work.layer.masksToBounds = YES;
}

- (void)setRecentM:(FriendsRecentModel *)recentM{
    _recentM = recentM;
    [_btn_headerImg sd_setBackgroundImageWithURL:[NSURL URLWithString:recentM.avatar_img] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"empyImage120"]];
    _btn_headerImg.layer.cornerRadius = CGRectGetHeight(_btn_headerImg.frame) / 2.f;
    _btn_headerImg.layer.masksToBounds = YES;
    [_btn_name setTitle:recentM.usernick forState:UIControlStateNormal];
    [_label_time setText:[MyUtil calculatedDateFromNowWith:recentM.date]];
    NSLog(@"---------%@-->%@",recentM.usernick,recentM.date);
//    if(recentM.message.length >26){
//        [_label_content setText:[recentM.message substringToIndex:25]];
//    }else{
    
    
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
        
        if(recentM.tags.count){
            _label_work.text = ((FriendsTagModel *)recentM.tags[0]).tagname;
            _label_work.hidden = NO;
        }else {
            _label_work.hidden = YES;
        }
    }
    
    NSString *topicNameStr = nil;
    if(_recentM.topicTypeName.length) topicNameStr = [NSString stringWithFormat:@"#%@#",_recentM.topicTypeName];
    CGSize topicSize = [topicNameStr boundingRectWithSize:CGSizeMake(MAXFLOAT, 30) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithString:recentM.message];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    if(topicNameStr.length) paragraphStyle.firstLineHeadIndent = topicSize.width+3;
    [paragraphStyle setLineSpacing:3];
    [attributeStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [recentM.message length])];
    
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
