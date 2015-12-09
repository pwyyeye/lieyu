//
//  CarInfoCell.h
//  lieyu
//
//  Created by 薛斯岐 on 15/10/23.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarModel.h"
@interface CarInfoCell : UITableViewCell<LYTableViewCellLayout>{
    CarModel *carModel;
}
@property (weak, nonatomic) IBOutlet UIButton *selBtn;
@property (weak, nonatomic) IBOutlet UIImageView *danPinImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLal;
@property (weak, nonatomic) IBOutlet UILabel *delLal;
@property (weak, nonatomic) IBOutlet UILabel *zhekouLal;
@property (weak, nonatomic) IBOutlet UILabel *moneyLal;
@property (weak, nonatomic) IBOutlet UIButton *yjBtn;
@property (weak, nonatomic) IBOutlet UITextField *numLal;
@property (weak, nonatomic) IBOutlet UILabel *presentLbl;

@property (weak, nonatomic) IBOutlet UIButton *lessbtn;


- (IBAction)changeNum:(UIButton *)sender;
@end
