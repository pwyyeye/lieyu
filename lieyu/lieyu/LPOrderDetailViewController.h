//
//  LPOrderDetailViewController.h
//  lieyu
//
//  Created by 王婷婷 on 16/4/11.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBaseViewController.h"
#import "OrderInfoModel.h"

@interface LPOrderDetailViewController : LYBaseViewController

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIButton *firstButton;
@property (weak, nonatomic) IBOutlet UIButton *secondButton;
@property (weak, nonatomic) IBOutlet UILabel *consumerCodeLbl;

@property (nonatomic, strong) OrderInfoModel *orderInfoModel;
@end
