//
//  LPOrdersHeaderView.h
//  lieyu
//
//  Created by 王婷婷 on 16/4/8.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderInfoModel.h"
@interface LPOrdersHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIView *backGround;
@property (weak, nonatomic) IBOutlet UILabel *placeLbl;
@property (weak, nonatomic) IBOutlet UILabel *orderNumberLbl;
@property (weak, nonatomic) IBOutlet UILabel *orderStatusLbl;
@property (weak, nonatomic) IBOutlet UILabel *orderTimeLbl;
@property (weak, nonatomic) IBOutlet UILabel *shaperLbl;

@property (nonatomic, strong) OrderInfoModel *model;
@end
