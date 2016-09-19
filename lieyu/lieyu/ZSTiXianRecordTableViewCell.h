//
//  ZSTiXianRecordTableViewCell.h
//  lieyu
//
//  Created by 狼族 on 16/3/29.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZSTiXianRecord;

@interface ZSTiXianRecordTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *label_type;
@property (weak, nonatomic) IBOutlet UILabel *label_time;
@property (weak, nonatomic) IBOutlet UILabel *label_money;
@property (weak, nonatomic) IBOutlet UILabel *label_poundage;
@property (nonatomic,strong) ZSTiXianRecord *tiXianR;
@property (nonatomic ,strong) ZSTiXianRecord *chongzhiR;
@end
