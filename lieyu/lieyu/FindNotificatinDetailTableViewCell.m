//
//  FindNotificatinDetailTableViewCell.m
//  lieyu
//
//  Created by 狼族 on 16/3/8.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "FindNotificatinDetailTableViewCell.h"
#import "FindNewMessageList.h"

@implementation FindNotificatinDetailTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}


- (void)setFindMessList:(FindNewMessageList *)findMessList{
    _findMessList = findMessList;
//    _img_icon = findMessList.
    _label_time.text = findMessList.createDate;
    _label_title.text = findMessList.title;
    _label_detail.text = findMessList.content;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
