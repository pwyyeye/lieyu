//
//  UserMomentViewController.h
//  lieyu
//
//  Created by 狼族 on 16/9/8.
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


@interface UserMomentViewController : LYBaseViewController
{
    UITableView *_userTablewView;//页面
    NSMutableArray *_dataArray;//数据数组

    NSInteger _pageCount;//每页数
    NSString *_useridStr;//用户id
    NSString *_userBgImageUrl;//用户上传的个人背景图
    int _pageStartCount;
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
    LYFriendsUserHeaderView *_headerView;//我的表头

}

@property (nonatomic, strong) NSMutableDictionary *notificationDict;
@property (nonatomic,unsafe_unretained) BOOL isMessageDetail;//是否是动态详情
@property (nonatomic,strong)  FriendsUserInfoModel *userM;//好友信息；

@end
