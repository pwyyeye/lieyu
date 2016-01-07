//
//  LYFriendsImgVTableViewCell.h
//  lieyu
//
//  Created by 狼族 on 16/1/7.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FriendsRecentModel;

@interface LYFriendsImgVTableViewCell : UITableViewCell
@property(nonatomic,strong) FriendsRecentModel *recentModel;
@property(nonatomic,strong) NSMutableArray *imgVArray;

@end
