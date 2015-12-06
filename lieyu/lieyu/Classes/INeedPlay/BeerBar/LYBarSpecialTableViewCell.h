//
//  LYBarSpecialTableViewCell.h
//  lieyu
//
//  Created by 狼族 on 15/11/29.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BeerBarOrYzhDetailModel.h"
@interface LYBarSpecialTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *typeBtn1;
@property (weak, nonatomic) IBOutlet UILabel *typeBtn2;

@property (weak, nonatomic) IBOutlet UILabel *teseBtn1;
@property (weak, nonatomic) IBOutlet UILabel *teseBtn2;
@property (weak, nonatomic) IBOutlet UILabel *teseBtn3;
@property (weak, nonatomic) IBOutlet UILabel *teseBtn4;


- (void)configureCell:(BeerBarOrYzhDetailModel *)model;

@end
