//
//  AdvisorBookChooseTableViewCell.m
//  lieyu
//
//  Created by 狼族 on 16/5/30.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "AdvisorBookChooseTableViewCell.h"

@implementation AdvisorBookChooseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureTime{
    _subView.hidden = YES;
    [_title_label setText:@"到店时间"];
    [_content_label setText:@"选择到达现场时间"];
    _cellTag = 0;
    _anvance_button.tag = _cellTag;
}

- (void)configureNumber{
    _subView.hidden = YES;
    [_title_label setText:@"参与人数"];
    [_content_label setText:@"选择到达现场人数"];
    _cellTag = 1;
    _anvance_button.tag = _cellTag;
}

- (void)configureType{
    _subView.hidden = YES;
    [_title_label setText:@"选择卡类"];
    [_content_label setText:@"选择卡座类型"];
    _cellTag = 2;
    _anvance_button.tag = _cellTag;
}



@end
