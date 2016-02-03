//
//  JoinedTableViewCell.h
//  lieyu
//
//  Created by 王婷婷 on 16/1/31.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HDDetailJumpToFriendDetail <NSObject>
- (void)HDDetailJumpToFriendDetail:(NSString *)friendId;
- (void)gotoUserPage:(UIButton *)button;
@end

@interface JoinedTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *title_label;
@property (nonatomic, strong) NSMutableArray *buttons_array;
@property (nonatomic, strong) UIImageView *view;
@property (nonatomic, strong) NSArray *pinkeModelList;

@property (nonatomic, assign) id<HDDetailJumpToFriendDetail> delegate;

- (void)configureJoinedNumber:(int)number andPeople:(NSArray *)pinkeList;
- (void)configureMessage;
- (void)configureMoreAction;

@end
