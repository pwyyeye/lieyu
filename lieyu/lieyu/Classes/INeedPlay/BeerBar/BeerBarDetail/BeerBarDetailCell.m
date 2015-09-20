//
//  BeerBarDetailCell.m
//  lieyu
//
//  Created by newfly on 9/20/15.
//  Copyright © 2015 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "BeerBarDetailCell.h"

@interface BeerBarDetailCell()

@end

@implementation BeerBarDetailCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat )adjustCellHeight:(id)model
{
    return 220;
}

- (void)configureCell:(id)model
{
//--TODO: 需要根据 右边的，酒吧类型和特色 修改cell的展示
    
    
}

@end





