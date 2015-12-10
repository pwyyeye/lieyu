//
//  PTzsjlCell.h
//  lieyu
//
//  Created by 薛斯岐 on 15/10/17.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PTzsjlCell : UITableViewCell<LYTableViewCellLayout>

@property (weak, nonatomic) IBOutlet UIImageView *managerAvatar;
@property (weak, nonatomic) IBOutlet UILabel *managerName;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

@property (weak, nonatomic) IBOutlet UIImageView *icon1;
@property (weak, nonatomic) IBOutlet UIImageView *icon2;
@property (weak, nonatomic) IBOutlet UIImageView *icon3;
@property (weak, nonatomic) IBOutlet UIImageView *icon4;
@property (weak, nonatomic) IBOutlet UIImageView *icon5;

@property (nonatomic, strong) NSArray *starsArray;
@property (weak, nonatomic) IBOutlet UIButton *chooseBtn;

@end
