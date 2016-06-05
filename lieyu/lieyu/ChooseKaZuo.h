//
//  ChooseKaZuo.h
//  lieyu
//
//  Created by 狼族 on 16/5/31.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LYKaZuoTypeButton.h"

@interface ChooseKaZuo : UIView
@property (weak, nonatomic) IBOutlet UILabel *title_label;
@property (strong, nonatomic) IBOutletCollection(LYKaZuoTypeButton) NSArray *choose_buttons;

@property (nonatomic, assign) NSInteger selectedTag;

- (IBAction)chooseTypeClick:(LYKaZuoTypeButton *)sender;

@end
