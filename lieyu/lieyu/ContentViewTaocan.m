//
//  ContentViewTaocan.m
//  lieyu
//
//  Created by 狼族 on 15/12/4.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "ContentViewTaocan.h"

@implementation ContentViewTaocan

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.frame = CGRectMake(10, SCREEN_HEIGHT - 370, SCREEN_WIDTH - 20, 300);
}
- (IBAction)sureClick:(id)sender {
    UIButton *button = (UIButton *)sender;
    if (button.tag == 1) {
        [self.image_remain setImage:[UIImage imageNamed:@"CustomBtn_Selected.png"]];
        [self.image_notRemain setImage:[UIImage imageNamed:@"CustomBtn_unSelected.png"]];
        self.image_remain.tag = 3;
        self.image_notRemain.tag = 1;
    }else if(button.tag == 2){
        [self.image_remain setImage:[UIImage imageNamed:@"CustomBtn_unSelected.png"]];
        [self.image_notRemain setImage:[UIImage imageNamed:@"CustomBtn_Selected.png"]];
        self.image_notRemain.tag = 3;
        self.image_remain.tag = 0;
    }
}

@end
