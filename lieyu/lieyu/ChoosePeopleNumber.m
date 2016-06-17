//
//  ChoosePeopleNumber.m
//  lieyu
//
//  Created by 狼族 on 16/6/16.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "ChoosePeopleNumber.h"

@implementation ChoosePeopleNumber

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib{
}
- (void)setSelectedTag:(NSInteger)selectedTag{
    _selectedTag = selectedTag;
    if (_selectedTag <= 0 || _selectedTag >= 11) {
        _selectedTag = 1;
    }
    for (LYKaZuoTypeButton *button in _choosebuttons) {
        NSLog(@"%ld",button.tag);
        if (button.tag == _selectedTag) {
            button.selected = YES;
        }else{
            button.selected = NO;
        }
    }
}

- (IBAction)chooseTypeClick:(UIButton *)sender {
    for (LYKaZuoTypeButton *button in _choosebuttons) {
        if (button.tag == sender.tag) {
            button.selected = YES;
        }else{
            button.selected = NO;
        }
//        NSLog(@"button:%@   selected:%d",button,button.choosed);
    }
}
@end
