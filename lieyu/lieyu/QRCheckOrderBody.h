//
//  QRCheckOrderBody.h
//  lieyu
//
//  Created by 王婷婷 on 16/3/9.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopDetailmodel.h"
@interface QRCheckOrderBody : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *OrderImage;
@property (weak, nonatomic) IBOutlet UILabel *OrderName;
@property (weak, nonatomic) IBOutlet UILabel *OrderPrice;
@property (weak, nonatomic) IBOutlet UILabel *OrderNumber;

@property (nonatomic, strong) ShopDetailmodel *model;
@end
