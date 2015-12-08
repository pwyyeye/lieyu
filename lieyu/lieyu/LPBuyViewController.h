//
//  LPBuyViewController.h
//  lieyu
//
//  Created by 王婷婷 on 15/12/2.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PinKeModel.h"
#import "LPBuyManagerCell.h"

@interface LPBuyViewController : UIViewController<SelectManager>
@property (nonatomic, assign) int smid;

@property (nonatomic, strong) PinKeModel *pinkeModel;
@property (nonatomic, strong) NSMutableDictionary *InfoDict;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *buyNowBtn;

- (IBAction)buyNowClick:(UIButton *)sender;


@end
