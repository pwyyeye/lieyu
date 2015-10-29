//
//  LYTagTableViewCell.h
//  lieyu
//
//  Created by pwy on 15/10/29.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//
#import "LYUserTagButton.h"
#import <UIKit/UIKit.h>

@interface LYTagTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet LYUserTagButton *button1;

@property (weak, nonatomic) IBOutlet LYUserTagButton *button2;

@property (weak, nonatomic) IBOutlet LYUserTagButton *button3;

@end
