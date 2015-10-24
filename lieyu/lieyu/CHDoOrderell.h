//
//  CHDoOrderell.h
//  lieyu
//
//  Created by 薛斯岐 on 15/10/24.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarModel.h"
@interface CHDoOrderell : UITableViewCell<LYTableViewCellLayout>{
    CarModel *carModel;
}
@property (weak, nonatomic) IBOutlet UIImageView *danPinImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLal;
@property (weak, nonatomic) IBOutlet UILabel *delLal;
@property (weak, nonatomic) IBOutlet UILabel *zhekouLal;
@property (weak, nonatomic) IBOutlet UILabel *moneyLal;
@property (weak, nonatomic) IBOutlet UIButton *yjBtn;


@end
