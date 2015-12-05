//
//  LYOrderInfoTableViewCell.h
//  lieyu
//
//  Created by 狼族 on 15/12/1.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TaoCanModel;

@interface LYOrderInfoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *label_orderInfo;
@property (weak, nonatomic) IBOutlet UILabel *label_orderAddress;
@property (weak, nonatomic) IBOutlet UILabel *label_order_date;
@property (nonatomic,strong) TaoCanModel *taocanModel;
@end
