//
//  LYGuWenPersonCollectionViewCell.h
//  lieyu
//
//  Created by 狼族 on 16/5/26.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UserModel;

@interface LYGuWenPersonCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIImageView *imgHeaderView;
@property (weak, nonatomic) IBOutlet UIImageView *imgHot;
@property (weak, nonatomic) IBOutlet UILabel *labelNick;
@property (weak, nonatomic) IBOutlet UILabel *labelBarName;
@property (weak, nonatomic) IBOutlet UILabel *labelAddress;
@property (weak, nonatomic) IBOutlet UILabel *labelDistance;
@property (weak, nonatomic) IBOutlet UIButton *btnFlower;
@property (weak, nonatomic) IBOutlet UIButton *btnPopular;
@property (weak, nonatomic) IBOutlet UIImageView *sexImage;

@property (nonatomic,strong) UserModel *vipModel;
@end
