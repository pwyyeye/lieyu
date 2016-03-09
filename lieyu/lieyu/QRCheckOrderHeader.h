//
//  QRCheckOrderHeader.h
//  lieyu
//
//  Created by 王婷婷 on 16/3/9.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderInfoModel.h"
@interface QRCheckOrderHeader : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *user_avater;
@property (weak, nonatomic) IBOutlet UILabel *user_name;
@property (weak, nonatomic) IBOutlet UIButton *IsSelected;
@property (weak, nonatomic) IBOutlet UILabel *OrderNumber;
@property (weak, nonatomic) IBOutlet UILabel *OrderTime;

@property (nonatomic, strong) OrderInfoModel *orderinfo;

@end
