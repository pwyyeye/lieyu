//
//  LYTaoCanHeaderTableViewCell.h
//  lieyu
//
//  Created by 狼族 on 15/11/30.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TaoCanModel;
#import "CheHeModel.h"

@interface LYTaoCanHeaderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView_header;
@property (weak, nonatomic) IBOutlet UILabel *label_name;
@property (weak, nonatomic) IBOutlet UILabel *label_price;
@property (weak, nonatomic) IBOutlet UILabel *label_price_old;
@property (weak, nonatomic) IBOutlet UILabel *btn_fanli;
@property (nonatomic,strong) TaoCanModel *model;

@property (nonatomic, strong) CheHeModel *chiheModel;

- (void)cellConfigure:(CheHeModel *)chiheModel;
@end