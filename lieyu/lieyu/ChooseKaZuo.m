//
//  ChooseKaZuo.m
//  lieyu
//
//  Created by 狼族 on 16/5/31.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "ChooseKaZuo.h"

@implementation ChooseKaZuo
- (void)awakeFromNib{
    
}

- (void)setSelectedTag:(NSInteger)selectedTag{
    _selectedTag = selectedTag;
    if (_selectedTag <= 0 || _selectedTag >= 5) {
        _selectedTag = 1;
    }
    for (LYKaZuoTypeButton *button in _choose_buttons) {
        if (button.tag == _selectedTag) {
            button.selected = YES;
        }else{
            button.selected = NO;
        }
    }
}

- (IBAction)chooseTypeClick:(LYKaZuoTypeButton *)sender {
    for (LYKaZuoTypeButton *button in _choose_buttons) {
        if (button.tag == sender.tag) {
            button.selected = YES;
        }else{
            button.selected = NO;
        }
        NSLog(@"button:%@   selected:%d",button,button.choosed);
    }
}
@end
