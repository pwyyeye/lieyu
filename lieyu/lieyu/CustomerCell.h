//
//  CustomerCell.h
//  lieyu
//
//  Created by SEM on 15/9/16.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LYAdviserManagerBriefInfo.h"
#import "UserModel.h"
#import "CustomerModel.h"

@interface CustomerCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *cusImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLal;
@property (weak, nonatomic) IBOutlet UIImageView *smallImageView;
@property (weak, nonatomic) IBOutlet UILabel *countLal;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@property(assign,nonatomic) BOOL isSelected;

@property (nonatomic, strong) LYAdviserManagerBriefInfo *infoModel;

@property (nonatomic, strong) CustomerModel *memberModel;

@end
