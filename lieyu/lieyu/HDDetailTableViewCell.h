//
//  HDDetailTableViewCell.h
//  lieyu
//
//  Created by 王婷婷 on 16/1/31.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HDDetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *startTime_label;
@property (weak, nonatomic) IBOutlet UILabel *shangyu_label;
@property (weak, nonatomic) IBOutlet UILabel *residue_label;
@property (weak, nonatomic) IBOutlet UILabel *joinedNumber_label;
@property (weak, nonatomic) IBOutlet UILabel *joinedpro_label;
@property (weak, nonatomic) IBOutlet UILabel *address_label;
@property (weak, nonatomic) IBOutlet UILabel *barName_label;
@property (weak, nonatomic) IBOutlet UIButton *checkAddress_button;
@property (weak, nonatomic) IBOutlet UIButton *checkBar_button;

@end
