//
//  PTTaoCanDetailCell.h
//  lieyu
//
//  Created by 薛斯岐 on 15/10/17.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PTTaoCanDetailCell : UITableViewCell<LYTableViewCellLayout>
@property (weak, nonatomic) IBOutlet UILabel *titleLal;
@property (weak, nonatomic) IBOutlet UILabel *moneyLal;
@property (weak, nonatomic) IBOutlet UILabel *jiubaLal;
@property (weak, nonatomic) IBOutlet UILabel *pikeTypeLal;
@property (weak, nonatomic) IBOutlet UIImageView *jiuBaImageView;
@end
