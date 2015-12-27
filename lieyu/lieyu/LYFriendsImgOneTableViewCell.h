//
//  LYFriendsImgOneTableViewCell.h
//  lieyu
//
//  Created by 狼族 on 15/12/25.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LYFriendsImgOneTableViewCell;
@class FriendsRecentModel;

@protocol LYFriendsImgOneTableViewCellDelegate <NSObject>

- (void)friendsImgOneCell:(LYFriendsImgOneTableViewCell *)imgOneCell;

@end

@interface LYFriendsImgOneTableViewCell : UITableViewCell
@property (nonatomic,unsafe_unretained) id<LYFriendsImgOneTableViewCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *imageView_one;
@property (nonatomic,strong) FriendsRecentModel *recentM;
@end
