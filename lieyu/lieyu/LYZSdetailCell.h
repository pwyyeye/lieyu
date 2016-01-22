//
//  LYZSdetailCell.h
//  lieyu
//
//  Created by 薛斯岐 on 15/9/25.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZSDetailModel.h"

@interface LYZSdetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLal;
@property (weak, nonatomic) IBOutlet UILabel *biaoqianLal;
//@property (weak, nonatomic) IBOutlet UILabel *jiubaLal;
@property (weak, nonatomic) IBOutlet UIButton *messageBtn;
@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;
@property (weak, nonatomic) IBOutlet UIButton *scBtn;

@property (weak, nonatomic) IBOutlet UIImageView *iconStar1;
@property (weak, nonatomic) IBOutlet UIImageView *iconStar2;
@property (weak, nonatomic) IBOutlet UIImageView *iconStar3;
@property (weak, nonatomic) IBOutlet UIImageView *iconStar4;
@property (weak, nonatomic) IBOutlet UIImageView *iconStar5;

@property (weak, nonatomic) IBOutlet UIView *backView;

@property (nonatomic, strong) NSArray *imagesArray;

@property (nonatomic, strong) ZSDetailModel *zsModel;

- (void)cellConfigure:(ZSDetailModel *)ZSModel;

@end
