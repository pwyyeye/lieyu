//
//  ChoosePeopleNumber.h
//  lieyu
//
//  Created by 狼族 on 16/6/16.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LYKaZuoTypeButton.h"

@interface ChoosePeopleNumber : UIView

@property (weak, nonatomic) IBOutlet UILabel *title_Label;

@property (strong, nonatomic) IBOutletCollection(LYKaZuoTypeButton) NSArray *choosebuttons;

@property (nonatomic, assign) NSInteger selectedTag;

- (IBAction)chooseTypeClick:(UIButton *)sender;


@end
