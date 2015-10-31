//
//  LYUserTagButton.h
//  lieyu
//
//  Created by pwy on 15/10/29.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserTagModel.h"

@protocol LYChooseButtonDelegate <NSObject>

-(void)chooseButton:(UIButton *)sender andSelected:(BOOL)isSelected;

@end

@interface LYUserTagButton : UIButton
@property(strong,nonatomic) id<LYChooseButtonDelegate> delegate;
@property(strong,nonatomic) UserTagModel *usertag;
@end
