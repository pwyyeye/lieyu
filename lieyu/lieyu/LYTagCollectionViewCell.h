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

@protocol LYTagCollectionViewCellDelegate <NSObject>

- (void)selectedCellWith:(NSInteger)indexItem;

@end

@interface LYTagCollectionViewCell : UICollectionViewCell
@property (nonatomic,strong) UILabel *tagLabel;
@property (nonatomic,unsafe_unretained) id<LYTagCollectionViewCellDelegate> delegate;
- (void)deployCellWith:(UserTagModel *)tagM index:(NSInteger)index selectedTagM:(UserTagModel *)selectedTagM;
@end
