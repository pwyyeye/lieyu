//
//  LYGuWenOutsideCollectionViewCell.h
//  lieyu
//
//  Created by 狼族 on 16/5/27.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendsRecentModel.h"


@protocol LYGuWenCollectionDelegate <NSObject>

@optional

- (void)GuWenSelected:(NSString *)userID;

- (void)VideoSelected:(FriendsRecentModel *)recentM;

- (void)publishVideo;

@end


@interface LYGuWenOutsideCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UICollectionView *collectViewInside;

@property (nonatomic,strong) NSArray *guWenArray;//顾问数组
@property (nonatomic, strong) NSArray *videoArray;//直播数组

@property (nonatomic, assign) int typeForShow;//1为顾问信息，2为直播数组

@property (nonatomic, assign) id<LYGuWenCollectionDelegate> delegate;

@end
