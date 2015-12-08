//
//  LYDinWeiTableViewCell.h
//  lieyu
//
//  Created by 狼族 on 15/11/30.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RecommendPackageModel;
@class TaoCanModel;

@interface LYDinWeiTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView_header;
@property (weak, nonatomic) IBOutlet UILabel *label_name;
@property (weak, nonatomic) IBOutlet UILabel *label_buyCount;
@property (weak, nonatomic) IBOutlet UILabel *label_price_now;
@property (weak, nonatomic) IBOutlet UILabel *label_price_old;
@property (weak, nonatomic) IBOutlet UILabel *label_percent;
@property (nonatomic,strong) RecommendPackageModel *model;
@property (nonatomic,strong) TaoCanModel *taoCanModel;
@end
