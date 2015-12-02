//
//  LPPlayTogetherViewController.h
//  lieyu
//
//  Created by 王婷婷 on 15/12/1.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PinKeModel.h"

@interface LPPlayTogetherViewController : UIViewController

@property (nonatomic, assign)int smid;
//@property (nonatomic, strong) 

@property (nonatomic, strong) PinKeModel *pinKeModel;


@property (weak, nonatomic) IBOutlet UIButton *zixunBtn;
@property (weak, nonatomic) IBOutlet UIButton *zhuyiBtn;
@property (weak, nonatomic) IBOutlet UIButton *buyBtn;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
