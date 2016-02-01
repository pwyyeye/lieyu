//
//  LYYUTableViewCell.h
//  lieyu
//
//  Created by 狼族 on 16/1/31.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYYUTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *view_cell;
@property (weak, nonatomic) IBOutlet UIButton *btn_headerImg;
@property (weak, nonatomic) IBOutlet UILabel *label_name;
@property (weak, nonatomic) IBOutlet UILabel *label_age;
@property (weak, nonatomic) IBOutlet UILabel *label_fanshi;
@property (weak, nonatomic) IBOutlet UILabel *label_constell;//星座
@property (weak, nonatomic) IBOutlet UILabel *label_work;//职业
@property (weak, nonatomic) IBOutlet UILabel *label_time;//剩余时间
@property (weak, nonatomic) IBOutlet UILabel *label_message;//中间信息
@property (weak, nonatomic) IBOutlet UILabel *label_concreteTime;//具体时间
@property (weak, nonatomic) IBOutlet UILabel *label_peopleCount;//邀请人数
@property (weak, nonatomic) IBOutlet UILabel *label_address;//地址
@property (weak, nonatomic) IBOutlet UILabel *label_distance;//距离
@property (weak, nonatomic) IBOutlet UILabel *label_peoplePercent;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btnArray;

@end
