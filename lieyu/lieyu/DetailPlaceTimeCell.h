//
//  DetailPlaceTimeCell.h
//  lieyu
//
//  Created by 王婷婷 on 16/4/11.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderInfoModel.h"
@interface DetailPlaceTimeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *placeLbl;
@property (weak, nonatomic) IBOutlet UILabel *TimeLbl;
@property (weak, nonatomic) IBOutlet UIView *backGround;

@property (nonatomic, strong) OrderInfoModel *orderInfoModel;

@end
