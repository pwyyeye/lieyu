//
//  LYHotsCollectionViewCell.h
//  lieyu
//
//  Created by 狼族 on 16/2/14.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JiuBaModel;

@protocol LYHotsCollectionViewCellDelegate <NSObject>

- (void)hotsCollectionViewCellClickWithJiubaModel:(JiuBaModel *)jiubaM;

@end

@interface LYHotsCollectionViewCell : UICollectionViewCell
@property (nonatomic,unsafe_unretained) id<LYHotsCollectionViewCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UICollectionView *collectViewInside;
@property (nonatomic,strong) NSArray *jiubaArray;
@end
