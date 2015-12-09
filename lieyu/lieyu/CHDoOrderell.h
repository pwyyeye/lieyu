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
@property (weak, nonatomic) IBOutlet UIImageView *goodImageView;
@property (weak, nonatomic) IBOutlet UILabel *goodNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *numLbl;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;
@property (weak, nonatomic) IBOutlet UILabel *marketPriceLbl;
@property (weak, nonatomic) IBOutlet UILabel *presentLbl;


@end
