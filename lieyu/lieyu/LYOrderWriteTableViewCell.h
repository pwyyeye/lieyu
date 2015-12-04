//
//  LYOrderWriteTableViewCell.h
//  lieyu
//
//  Created by 狼族 on 15/11/30.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYOrderWriteTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *btn_chooseTime;
@property (weak, nonatomic) IBOutlet UIButton *btn_isReserve;
@property (weak, nonatomic) IBOutlet UIImageView *btn_minus;
@property (weak, nonatomic) IBOutlet UIImageView *btn_add;
@property (weak, nonatomic) IBOutlet UILabel *label_count;
@property (weak, nonatomic) IBOutlet UIButton *btn_showTime;
@property (weak, nonatomic) IBOutlet UIButton *btn_showTaocan;

@end
