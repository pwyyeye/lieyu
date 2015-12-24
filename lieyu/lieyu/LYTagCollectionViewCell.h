//
//  LYTagCollectionViewCell.h
//  lieyu
//
//  Created by 狼族 on 15/12/22.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LYTagLabel.h"
@class UserTagModel;

@interface LYTagCollectionViewCell : UICollectionViewCell
@property (nonatomic,strong) UILabel *tagLabel;
- (void)deployCellWith:(UserTagModel *)tagM selectedTagM:(UserTagModel *)selectedTagM;
@end
