//
//  WanTanCell.m
//  lieyu
//
//  Created by 狼族 on 16/8/29.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "WanTanCell.h"

@implementation WanTanCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}
-(void) setIamge:(UIImage *) image andLabel:(NSString *)text{
    [self.tagIamgeView setImage:image];
    [self.tagLabel setText:text];
}

@end
