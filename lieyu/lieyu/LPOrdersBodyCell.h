//
//  LPOrdersBodyCell.h
//  lieyu
//
//  Created by 王婷婷 on 16/4/7.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderInfoModel.h"

@interface LPOrdersBodyCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *orderImage;
@property (weak, nonatomic) IBOutlet UILabel *orderNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *orderNumberLbl;
@property (weak, nonatomic) IBOutlet UILabel *orderPriceLbl;
@property (weak, nonatomic) IBOutlet UILabel *orderMarketPriceLbl;

@property (nonatomic, strong) OrderInfoModel *model;

@end
