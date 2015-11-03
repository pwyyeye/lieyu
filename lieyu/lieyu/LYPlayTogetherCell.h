//
//  LYPlayTogetherCell.h
//  lieyu
//
//  Created by 薛斯岐 on 15/10/15.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSObject+MJKeyValue.h"
@interface LYPlayTogetherCell : UITableViewCell<LYTableViewCellLayout>
@property (weak, nonatomic) IBOutlet UIImageView *pkIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *barnameLal;
@property (weak, nonatomic) IBOutlet UILabel *introductionLal;
@property (weak, nonatomic) IBOutlet UILabel *addressLal;
@property (weak, nonatomic) IBOutlet UILabel *scLal;
@property (weak, nonatomic) IBOutlet UIButton *pkBtn;

@property (weak, nonatomic) IBOutlet UILabel *price;

@property (weak, nonatomic) IBOutlet UILabel *marketprice;
@property (weak, nonatomic) IBOutlet UILabel *favNum;
@end
