//
//  PayCell.m
//  haitao
//
//  Created by pwy on 15/8/9.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "PayCell.h"

@implementation PayCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)layoutSubviews{
    [super layoutSubviews];
    CGRect rect=self.textLabel.frame;
    self.textLabel.frame=CGRectMake(rect.origin.x-10, rect.origin.y-10, 150, rect.size.height);
    rect=self.detailTextLabel.frame;
    self.detailTextLabel.frame=CGRectMake(rect.origin.x-10, rect.origin.y+5, rect.size.width, rect.size.height);
    rect=self.imageView.frame;
    
    self.imageView.frame=CGRectMake(rect.origin.x, rect.origin.y+15, 40, 40);
    
}
@end
