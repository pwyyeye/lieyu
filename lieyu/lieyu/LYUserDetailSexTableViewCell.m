//
//  LYUserDetailSexTableViewCell.m
//  lieyu
//
//  Created by 狼族 on 15/12/6.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYUserDetailSexTableViewCell.h"

@implementation LYUserDetailSexTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (IBAction)sexClick:(UIButton *)sender {
     [sender setImage:[UIImage imageNamed:@"circleWhiteSelect"] forState:UIControlStateNormal];
    switch (sender.tag) {
        case 0:
        {
            [self.btn_women setImage:[UIImage imageNamed:@"circleWhite"] forState:UIControlStateNormal];
            self.btn_women.tag = 1;
        }
            break;
        case 1:
        {
            [self.btn_man setImage:[UIImage imageNamed:@"circleWhite"] forState:UIControlStateNormal];
            self.btn_man.tag = 0;
        }
            break;
            
        default:
            break;
    }
    sender.tag = 3;
}


@end
