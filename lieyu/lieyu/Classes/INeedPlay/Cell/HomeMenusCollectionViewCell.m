//
//  HomeMenusCollectionViewCell.m
//  lieyu
//
//  Created by pwy on 16/2/14.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "HomeMenusCollectionViewCell.h"

@implementation HomeMenusCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    
    for (UIButton *btn in _btnArray) {
        btn.layer.cornerRadius = 2;
//        btn.clipsToBounds = YES;
//        btn.layer.masksToBounds = YES;
    }
    
//    UIButton *btn1 = _btnArray[0];
//    btn1.layer.cornerRadius = 2;
//    btn1.layer.masksToBounds = YES;
    
//    UIButton *btn2 = _btnArray[1];
//    btn2.layer.cornerRadius = 2;
//    btn2.layer.masksToBounds = YES;
    
//    UIButton *btn3 = _btnArray[2];
//    btn3.layer.cornerRadius = 2;
//    btn3.layer.masksToBounds = YES;
//
//    UIButton *btn1 = _btnArray[0];
//    btn1.layer.cornerRadius = 2;
//    btn1.layer.masksToBounds = YES;
}

@end
