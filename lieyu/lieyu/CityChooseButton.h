//
//  CityChooseButton.h
//  lieyu
//
//  Created by pwy on 15/11/3.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LYChooseCityDelegate <NSObject>

-(void)chooseButton:(UIButton *)sender andSelected:(BOOL)isSelected;

@end

@interface CityChooseButton : UIButton

@property(strong,nonatomic) id<LYChooseCityDelegate> delegate;

@end
