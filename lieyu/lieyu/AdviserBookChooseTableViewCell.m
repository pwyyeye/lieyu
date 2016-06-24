//
//  AdviserBookChooseTableViewCell.m
//  lieyu
//
//  Created by 王婷婷 on 16/6/24.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "AdviserBookChooseTableViewCell.h"
@implementation AdviserBookChooseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)configureChoosePeopleNumber{
    [_titleLabel setText:@"参与人数"];
    _choosePeople = [[[NSBundle mainBundle]loadNibNamed:@"ChoosePeopleNumber" owner:nil options:nil] firstObject];
    [_choosePeople setFrame:CGRectMake(0, 0, SCREEN_WIDTH - 72, 90)];
    [_chooseView setFrame:CGRectMake(0, 0, SCREEN_WIDTH - 72, 90)];
    [_chooseView addSubview:_choosePeople];
}

- (void)configureChooseKazuo{
    [_titleLabel setText:@"选择卡座"];
    _chooseKazuo = [[[NSBundle mainBundle]loadNibNamed:@"ChooseKaZuo" owner:nil options:nil] firstObject];
    [_chooseKazuo setFrame:CGRectMake(0, 0, _chooseView.frame.size.width, 60)];
    [_chooseView setFrame:CGRectMake(0, 0, _chooseView.frame.size.width, 60)];
    [_chooseView addSubview:_chooseKazuo];
}

@end
