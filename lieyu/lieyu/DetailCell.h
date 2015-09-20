//
//  DetailCell.h
//  lieyu
//
//  Created by SEM on 15/9/17.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewExt.h"
@interface DetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *detImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLal;
@property (weak, nonatomic) IBOutlet UILabel *countLal;
@property (weak, nonatomic) IBOutlet UILabel *zhekouLal;
@property (weak, nonatomic) IBOutlet UILabel *moneylal;
@property (weak, nonatomic) IBOutlet UILabel *lineLal;

@end
