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
@property (weak, nonatomic) IBOutlet UIImageView *pkIconImageView;//图片名
@property (weak, nonatomic) IBOutlet UILabel *introductionLal;//介绍
@property (weak, nonatomic) IBOutlet UILabel *barName;
@property (weak, nonatomic) IBOutlet UILabel *price;//现价
@property (weak, nonatomic) IBOutlet UILabel *superProfit;
@property (weak, nonatomic) IBOutlet UILabel *marketprice;//市场价
@property (weak, nonatomic) IBOutlet UILabel *addressLal;//地址
@property (weak, nonatomic) IBOutlet UIButton *pkBtn;//拼客按钮
@end
