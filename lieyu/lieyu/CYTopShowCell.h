//
//  CYTopShowCell.h
//  lieyu
//
//  Created by 薛斯岐 on 15/10/19.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CYTopShowCell : UITableViewCell<LYTableViewCellLayout>
@property (weak, nonatomic) IBOutlet UILabel *titleLal;
@property (weak, nonatomic) IBOutlet UILabel *priceLal;
@property (weak, nonatomic) IBOutlet UIImageView *jiubaImageView;
@property (weak, nonatomic) IBOutlet UILabel *jiubaNameLal;
@property (weak, nonatomic) IBOutlet UILabel *typeLal;
@end
