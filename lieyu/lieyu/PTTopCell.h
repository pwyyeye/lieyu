//
//  PTTopCell.h
//  lieyu
//
//  Created by 薛斯岐 on 15/10/17.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EScrollerView.h"
#import "PinKeModel.h"
@interface PTTopCell : UITableViewCell<LYTableViewCellLayout>
{
    EScrollerView *scroller;
    PinKeModel *pinKeModel;
}
@property (weak, nonatomic) IBOutlet UILabel *shoucangCountLal;
@property (weak, nonatomic) IBOutlet UILabel *addressLal;
@property (weak, nonatomic) IBOutlet UIImageView *jiubaImageView;
@property (weak, nonatomic) IBOutlet UILabel *jiubaNameLal;
@property (weak, nonatomic) IBOutlet UILabel *taoCanNameLal;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIButton *daohanBtn;
@property (weak, nonatomic) IBOutlet UILabel *price;

@property (weak, nonatomic) IBOutlet UILabel *marketprice;
//套餐适合人数说明
@property (weak, nonatomic) IBOutlet UILabel *fitNum;

- (IBAction)daohan:(UIButton *)sender;

@end
