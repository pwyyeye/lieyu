//
//  LYChatrommAllPeopleTableViewCell.m
//  lieyu
//
//  Created by 狼族 on 16/5/20.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYChatrommAllPeopleTableViewCell.h"

@implementation LYChatrommAllPeopleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _imgV_header.layer.cornerRadius = CGRectGetWidth(_imgV_header.frame)/2.f;
    _imgV_header.layer.masksToBounds = YES;
    
}

- (void)drawRect:(CGRect)rect{//画底线
    UIColor *color = RGBA(178, 178, 178, 0.5);
    [color set];
    UIBezierPath *bezierP = [[UIBezierPath alloc]init];
    bezierP.lineWidth = 1;
    [bezierP moveToPoint:CGPointMake(0, rect.size.height)];
    [bezierP addLineToPoint:CGPointMake(rect.size.width, rect.size.height)];
    [bezierP stroke];
}

- (void)setUserM:(UserModel *)userM{
    _userM = userM;
    _label_name.text = userM.usernick;
    NSArray *strArr = [userM.birthday componentsSeparatedByString:@" "];
    _label_constellation.text = [MyUtil getAstroWithBirthday:strArr.firstObject];
    [_imgV_header sd_setImageWithURL:[NSURL URLWithString:userM.avatar_img]];
    if (userM.gender.intValue == 0) {
        _img_sex.image = [UIImage imageNamed:@"manIcon"];
    }else{
        _img_sex.image = [UIImage imageNamed:@"woman"];
    }
}

- (void)setIsQunZhu:(BOOL)isQunZhu{
    _isQunZhu = isQunZhu;
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ [群主]",_userM.usernick]];
    [attrStr addAttribute:NSForegroundColorAttributeName value:RGBA(197,55, 255, 1) range:NSMakeRange(_userM.usernick.length + 1, 4)];
    _label_name.attributedText = attrStr;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
