//
//  LYFriendsToUserMessageViewController.h
//  lieyu
//
//  Created by 狼族 on 15/12/28.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBaseViewController.h"

#import "EmojisView.h"
@class LYFriendsCommentView;

@interface LYFriendsToUserMessageViewController : LYBaseViewController<emojiClickDelegate>
{
      NSString *_useridStr;
    NSMutableArray *_dataArray;
    BOOL _isCommentToUser;
    EmojisView *emojisView;
    UIVisualEffectView *emojiEffectView;
    BOOL isExidtEffectView;
    UIButton *emoji_angry;
    UIButton *emoji_sad;
    UIButton *emoji_wow;
    UIButton *emoji_kawayi;
    UIButton *emoji_happy;
    UIButton *emoji_zan;
    NSInteger _deleteMessageTag;
    LYFriendsCommentView *_commentView;
    UIView *_bigView;
}
@property (nonatomic,copy) NSString *friendsId;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (void)getData;
- (void)reloadTableViewAndSetUpProperty;
- (void)addTableViewHeader;
- (void)setupTableViewFresh;
- (void)setupAllProperty;

#pragma mark - 点击动态中话题文字
- (void)topicNameClick:(UIButton *)button;
#pragma mark － 跳转消息详情页面
- (void)pushFriendsMessageDetailVCWithIndex:(NSInteger)index;
#pragma mark - 动态头像点击
- (void)messageHeaderImgClick:(UIButton *)button;
#pragma mark － 创建commentView
- (void)createCommentView;
#pragma mark - 查看图片
- (void)checkImageClick:(UIButton *)button;
#pragma mark - 表白action
- (void)likeFriendsClick:(UIButton *)button;
#pragma mark - 评论action
- (void)commentClick:(UIButton *)button;
#pragma mark - 视频播放
- (void)playVideo:(UIButton *)button;
@end
