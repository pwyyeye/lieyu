//
//  LYSearchLiveShowCollectionViewCell.h
//  lieyu
//
//  Created by 王婷婷 on 16/9/26.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LYLiveShowListModel.h"

@interface LYSearchLiveShowCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *backImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *guWenLabel;

@property (weak, nonatomic) IBOutlet UILabel *likeNum;

@property (weak, nonatomic) IBOutlet UIView *liveTypeView;

@property (weak, nonatomic) IBOutlet UILabel *liveTypeLabel;

@property (weak, nonatomic) IBOutlet UILabel *lookNumLabel;

@property (weak, nonatomic) IBOutlet UILabel *firstTaglabel;

@property (weak, nonatomic) IBOutlet UILabel *secondTagLabel;

@property (weak, nonatomic) IBOutlet UILabel *onlyOneTagLabel;

@property (nonatomic, strong) LYLiveShowListModel *listModel;

@end
