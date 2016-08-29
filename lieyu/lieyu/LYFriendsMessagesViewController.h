//
//  LYFriendsMessagesViewController.h
//  lieyu
//
//  Created by 狼族 on 16/4/22.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBaseViewController.h"
#import "FriendsUserInfoModel.h"
#import "LYFriendsUserHeaderView.h"
#import "FriendsRecentModel.h"
#import "FriendsPicAndVideoModel.h"
#import "FriendsCommentModel.h"
#import "EmojisView.h"
#import "LYFriendsHttpTool.h"
#import "LYFriendsSendViewController.h"
#import "FriendsLikeModel.h"
#import "LYMyFriendDetailViewController.h"

#import "LYFriendsNameTableViewCell.h"
#import "LYFriendsAddressTableViewCell.h"
#import "LYFriendsCommentTableViewCell.h"
#import "LYFriendsVideoTableViewCell.h"
#import "LYFriendsImgTableViewCell.h"
#import "LYFriendsLikeDetailTableViewCell.h"
#import <MediaPlayer/MediaPlayer.h>

#define LYFriendsNameCellID @"LYFriendsNameTableViewCell"
#define LYFriendsAddressCellID @"LYFriendsAddressTableViewCell"
#define LYFriendsCommentCellID @"LYFriendsCommentTableViewCell"
#define LYFriendsImgCellID @"LYFriendsImgTableViewCell"
#define LYFriendsVideoCellID @"LYFriendsVideoTableViewCell"
#define LYFriendsCellID @"cell"
#define LYFriendsAllLikeCellID @"LYFriendsLikeDetailTableViewCell"


typedef enum : NSUInteger {
    dataForFriendsMessage = 0,
    dataForMine = 1,
} dataType;

@protocol LYRecentMessageLikeDelegate <NSObject>

- (void)lyRecentMessageLikeChange:(NSString *)liked;

@end

@interface LYFriendsMessagesViewController : LYBaseViewController<LYRecentMessageLikeDelegate>
{
    NSMutableArray *_dataArray;//数据数组
    NSMutableArray *_tableViewArray;//表的数组
    int _pageStartCountArray[2];
    NSInteger _pageCount;//每页数
    NSString *_useridStr;//用户id
    NSString *_userBgImageUrl;//用户上传的个人背景图
    LYFriendsUserHeaderView *_headerView;//我的表头
   
    NSInteger _index;//判断是哪个节目 0－玩友圈 1-我的界面
    MPMoviePlayerViewController *player;
    NSInteger playerSection;
    BOOL isExidtEffectView;
    EmojisView *emojisView;//表情
    NSInteger _section;//点击的section
     NSInteger _indexRow;//表的那一行
    BOOL _isCommentToUser;//是否对用户评论
    UIVisualEffectView *effectView;//发布按钮的背LYFriendsCommentViewb景view
    UIButton *_carmerBtn;//照相机按钮
    LYFriendsSendViewController *friendsSendVC;
    CGFloat _contentOffSetY;//表的偏移量
}

@property (nonatomic,assign) id<LYRecentMessageLikeDelegate> delegate;

@property (nonatomic, strong) NSMutableDictionary *notificationDict;
@property (nonatomic,unsafe_unretained) NSInteger pageNum;
@property (nonatomic,unsafe_unretained) BOOL isFriendToUserMessage;//是否是好友动态
@property (nonatomic,unsafe_unretained) BOOL isTopic;//是否是话题
@property (nonatomic,unsafe_unretained) BOOL isMessageDetail;//是否是动态详情
@property (nonatomic,strong)  FriendsUserInfoModel *userM;//好友信息；
//@property (nonatomic,unsafe_unretained) BOOL isAMessageDetail;//是否是动态详情
#pragma mark - 获取最新玩友圈数据
- (void)getDataWithType:(dataType)type needLoad:(BOOL)need;

- (void)loadDataWith:(UITableView *)tableView dataArray:(NSMutableArray *)dataArray pageStartCount:(int)pageStartCount type:(dataType)type;
#pragma mark - 话题
- (void)addTableViewHeaderViewForTopic;

#pragma mark - 添加表头
- (void)addTableViewHeader;

- (void)setupTableForHeaderForMinPage;

#pragma mark - 配置导航
- (void)setupMenuView;

#pragma mark - 配置发布按钮
- (void)setupCarmerBtn;

#pragma mark - 获取我的未读消息数
- (void)getFriendsNewMessage;

#pragma mark - 为表配置上下刷新控件
- (void)setupMJRefreshForTableView:(UITableView *)tableView i:(NSInteger)i;

#pragma mark - 获取数据
- (void)startGetData;

#pragma mark - 为cell 中评论的按钮绑定方法
- (void)addTargetForBtn:(LYFriendsCommentButton *)button tag:(NSInteger)tag indexTag:(NSInteger)indexTag;

#pragma mark － 跳转消息详情页面
- (void)pushFriendsMessageDetailVCWithIndex:(NSInteger)index;

#pragma mark － 创建commentView
- (void)createCommentView;

#pragma mark imagepicker的代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info;

#pragma mark 选择玩照片后的操作
- (void)ImagePickerDidFinishWithImages:(NSArray *)imageArray;

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;

- (void)warningSheet:(UIButton *)button;

#pragma mark - sendSuccess
- (void)sendSucceed:(NSString *)messageId;

- (void)sendVedio:(NSString *)mediaUrl andImage:(UIImage *)image andContent:(NSString *)content andLocation:(NSString *)location andTopicID:(NSString *)topicID andTopicName:(NSString *)topicName;
- (void)sendImagesArray:(NSArray *)imagesArray andContent:(NSString *)content andLocation:(NSString *)location andTopicID:(NSString *)topicID andTopicName:(NSString *)topicName;

#pragma mark - 赞的人头像
- (void)zangBtnClick:(UIButton *)button;
@end
