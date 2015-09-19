//
//  LYWineBarInfoCell.m
//  lieyu
//
//  Created by newfly on 9/14/15.
//  Copyright (c) 2015 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYWineBarInfoCell.h"
#import "MacroDefinition.h"

@implementation LYWineBarInfoCell

- (void)awakeFromNib {
    // Initialization code
    _barNameLabel.textColor = UIColorFromRGB(0x333333);
    _barDescLabel.textColor = UIColorFromRGB(0x666666);
    _barAddrLabel.textColor = UIColorFromRGB(0x666666);

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
