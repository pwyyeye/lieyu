//
//  LYTagTableViewCell.h
//  lieyu
//
//  Created by pwy on 15/10/29.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//
#import "LYUserTagButton.h"
#import <UIKit/UIKit.h>

@protocol LYTagTablViewCellDelegate <NSObject>

- (void)tagTableViewCellAlertViewClick;

@end

@interface LYTagTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet LYUserTagButton *button1;

@property (weak, nonatomic) IBOutlet LYUserTagButton *button2;

@property (weak, nonatomic) IBOutlet LYUserTagButton *button3;
@property (weak, nonatomic) IBOutlet UIButton *btn_custom;
@property (nonatomic,unsafe_unretained) id<LYTagTablViewCellDelegate> delegate;
@end
