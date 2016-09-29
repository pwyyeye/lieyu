//
//  WatchLiveShowViewController.m
//  lieyu
//
//  Created by 狼族 on 16/8/16.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "WatchLiveShowViewController.h"

#import <PLPlayerKit/PLPlayerKit.h>
#import "AppDelegate.h"
#import "Reachability.h"
#import "IQKeyboardManager.h"
#import <asl.h>
#import "UMSocial.h"
#import "ISEmojiView.h"
#import "LYFriendsCommentView.h"

#import "RegisterLiveShowView.h"
#import "CloseLiveShowView.h"
#import "AnchorDetailView.h"
#import "UserHeader.h"
#import "LiveSetView.h"
#import "LiveShowEndView.h"
#import "ChatUseres.h"
#import "DaShangView.h"
#import "DMHeartFlyView.h"
#import "AudienceCell.h"

#import "LYFriendsHttpTool.h"
#import "LYYUHttpTool.h"
#import "LYMyFriendDetailViewController.h"

#import "LYMessageCell.h"
#import "LYTextMessageCell.h"
#import "LYGiftMessageCell.h"
#import "LYGiftMessage.h"
#import "LYTipMessageCell.h"
#import "RCMessageModel.h"
#import "LYStystemMessage.h"
#import "LYSystemTextMessageCell.h"
#import "RCIM.h"
#import "RCCollectionViewHeader.h"
#import "RCKitUtility.h"
#import "RCKitCommonDefine.h"
#import <RongIMLib/RongIMLib.h>
#import <objc/runtime.h>
#import "MBProgressHUD.h"
#import <RongIMToolKit/RongIMToolKit.h>
#import <RongIMToolKit/RCInputBarControl.h>
#import <RongIMToolKit/RCInputBarTheme.h>



//输入框的高度
#define MinHeight_InputView SCREEN_WIDTH /8

#define bottomContaristont CGRectGetMaxY(self.view.bounds) - SCREEN_WIDTH /8 + 15 ;

#define kReloadConfigurationEnable  0

// 假设在 videoFPS 低于预期 50% 的情况下就触发降低推流质量的操作，这里的 40% 是一个假定数值，你可以更改数值来尝试不同的策略
#define kMaxVideoFPSPercent 0.5

// 假设当 videoFPS 在 10s 内与设定的 fps 相差都小于 5% 时，就尝试调高编码质量
#define kMinVideoFPSPercent 0.05
#define kHigherQualityTimeInterval  10

#define kBrightnessAdjustRatio  1.03
#define kSaturationAdjustRatio  1.03
//距离底部
#define distanceOfBottom CGRectGetMaxY(self.view.bounds) - 20

@interface WatchLiveShowViewController () <PLPlayerDelegate,ISEmojiViewDelegate>

{
    NSTimer *_timer;//定时器
    int _takeNum;//聊天数
    long _likeNum;//点赞数
    LYFriendsCommentView *_commentView;//弹出的评论框
    UILabel *_textLabel;//输入框
    NSString *defaultComment;//残留评论
    ISEmojiView *_emojiView;//表情键盘
    UIView *_bigView;//评论的背景view
    UIButton *_iconButton, *_giftButton;
    CGFloat _heartSize;//红心的大小
    UILabel *_likeLabel;//
    NSTimer *_burstTimer;//延时
    NSInteger _giftNumber;//礼物数量
    NSString *_giftValue;//礼物价值
    NSArray *_dataArr;//礼物数组
    NSInteger _chatuserid;
    BOOL _isActiveNow;//是否是前台
    BOOL _isLiveing;//直播状态
    
}
@property (nonatomic, strong) NSMutableArray *giftValueArray;

@property (nonatomic, strong) PLPlayer  *player;

//上方主播View
@property (nonatomic, strong) UserHeader *userView;
@property (nonatomic, strong) UIImageView *userIcon;
@property (nonatomic, strong) UILabel *userNickname;
@property (nonatomic, strong) UILabel *unKnowNumber;
@property (nonatomic, strong) UIButton *isFoucsButton;


//注册/退出/详情/打赏View
@property (nonatomic, strong) RegisterLiveShowView *registerView;
@property (nonatomic, strong) LiveShowEndView *closeView;
@property (nonatomic, strong) UIImageView *backImage;
@property (nonatomic, strong) AnchorDetailView *anchorDetailView;
@property (nonatomic, strong) DaShangView *daShangView;

//退出
@property (nonatomic, strong) UIButton *backButton;

//观众列表
@property (nonatomic, strong) UICollectionView *audienceCollectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;
/** 直播开始前的占位图片 */
@property(nonatomic, weak) UIImageView *placeHolderView;
/** 粒子动画 */
@property(nonatomic, weak) CAEmitterLayer *emitterLayer;


@property(nonatomic, strong)RCCollectionViewHeader *collectionViewHeader;

/**
 *  存储长按返回的消息的model
 */
@property(nonatomic, strong) RCMessageModel *longPressSelectedModel;

/**
 *  是否需要滚动到底部
 */
@property(nonatomic, assign) BOOL isNeedScrollToButtom;

/**
 *  是否正在加载消息
 */
@property(nonatomic) BOOL isLoading;

/**
 *  会话名称
 */
@property(nonatomic,copy) NSString *navigationTitle;

/**
 *  点击空白区域事件
 */
@property(nonatomic, strong) UITapGestureRecognizer *resetBottomTapGesture;

/**
 *  直播互动文字显示
 */
@property(nonatomic,strong) UIView *titleView ;

/**
 *  底部显示未读消息view
 */
@property (nonatomic, strong) UIView *unreadButtonView;
@property(nonatomic, strong) UILabel *unReadNewMessageLabel;

/**
 *  滚动条不在底部的时候，接收到消息不滚动到底部，记录未读消息数
 */
@property (nonatomic, assign) NSInteger unreadNewMsgCount;

@property(nonatomic,strong)UIButton *flowerBtn;

@property(nonatomic,strong)UIButton *clapBtn;

@property(nonatomic, strong) UIButton *giftButton;
@property(nonatomic, strong) UIButton *likeButton;

@property(nonatomic, strong) UIButton *shareButton;
@property(nonatomic, assign) BOOL isShowSetView;

@property (nonatomic, strong) UIView *CAEmitterView;

@end
/**
 *  文本cell标示
 */
static NSString *const rctextCellIndentifier = @"LYtextCellIndentifier";

/**
 *  小灰条提示cell标示
 */
static NSString *const rcTipMessageCellIndentifier = @"LYTipMessageCellIndentifier";

/**
 *  礼物cell标示
 */
static NSString *const rcGiftMessageCellIndentifier = @"LYGiftMessageCellIndentifier";
/**
 *  系统cell标示
 */
static NSString *const rcStystemMessageCellIndentifier = @"LYStystemMessageCellIndentifier";
#define _CELL @ "audienceCellID"
@implementation WatchLiveShowViewController


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [RCIM sharedRCIM].disableMessageAlertSound = YES;//关闭融云的提示音

}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [RCIM sharedRCIM].disableMessageAlertSound = NO;//打开提示音
    self.navigationController.navigationBarHidden = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"sendGift" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.emitterLayer setHidden:NO];
    _isLiveing = YES;
    [self initPLplayer];
    [self initUI];
    if (_chatRoomId != nil) {
        [self joinChatRoom];
        _timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(timerUpdataAction) userInfo:nil repeats:YES];
        [_timer fire];
        [self timerUpdataAction];
    }
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].isAdd = YES;
    //获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(notice:) name:@"sendGift" object:nil];
    _giftValueArray = [NSMutableArray arrayWithCapacity:1];
    _isActiveNow = YES;
    [center addObserver:self selector:@selector(LieYuStauts:) name:UIApplicationWillResignActiveNotification object:nil];
    [center addObserver:self selector:@selector(LieYuStauts:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

#pragma mark --- 判断是否进入后台
-(void)LieYuStauts:(NSNotification *) sender{
    if (sender.name == UIApplicationDidBecomeActiveNotification) {
        [self.player play];
    } else {
        
    }
}


#pragma mark -- 定时获取直播室人员和点赞数
-(void)timerUpdataAction{
    NSDictionary *dictionary = @{@"chatNum":[NSString stringWithFormat:@"%d",_takeNum],@"liveChatId":_chatRoomId};
    [self.dataArray removeAllObjects];
    [LYFriendsHttpTool requestListWithParms:dictionary complete:^(NSDictionary *dict) {
        _likeLabel.text = [NSString stringWithFormat:@"%@",dict[@"likeNum"]];
        if ([dict valueForKey:@"total"]) {
            _userView.numberLabel.text = [NSString stringWithFormat:@"%@",dict[@"total"]];
        } else {
            _userView.numberLabel.text = @"";
        }
        if ([dict valueForKey:@"users"]) {
            self.dataArray = dict[@"users"];
        }
        [_audienceCollectionView reloadData];
    }];
    NSDictionary *watchDict = @{@"liveChatId":_chatRoomId};
    [LYFriendsHttpTool getLiveStatusWithParms:watchDict complete:^(NSDictionary *dict) {
        if ([dict[@"livestatus"] isEqualToString:@"1"]) {
            _isLiveing = YES;
        } else {
            _isLiveing = NO;
        }
    }];
}

#pragma mark --- 初始化页面
-(void)initUI {
    //粒子动画
    _CAEmitterView = [[UIView alloc] initWithFrame:self.view.bounds];
    _CAEmitterView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_CAEmitterView];
    _heartSize = 36;
    //返回按钮
    _backButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _backButton.frame = CGRectMake(SCREEN_WIDTH - 50, 30, 40, 40);
    [_backButton setImage:[UIImage imageNamed:@"live_close.png"] forState:(UIControlStateNormal)];
    [_backButton addTarget:self action:@selector(closebackButtonAction) forControlEvents:(UIControlEventTouchUpInside)];
    [_CAEmitterView addSubview:_backButton];
    
    //顶部用户信息
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"UserHeader" owner:self options:nil];
    _userView = [nib objectAtIndex:0];
    CGSize textSize = CGSizeZero;
    textSize = [LYTextMessageCell getContentSize:_hostUser[@"usernick"] withFrontSize:16 withWidth:270];
    _userView.frame = CGRectMake(SCREEN_WIDTH / 50, 30, textSize.width + 110 , 40);
    _userView.layer.cornerRadius = 20;
    _userView.layer.masksToBounds = YES;
    _userView.backgroundColor = RGBA(68, 64, 67, 0.5);
    NSString *imgStr = [NSString stringWithFormat:@"%@",_hostUser[@"avatar_img"]];
    if (imgStr.length < 50) {
        imgStr = [MyUtil getQiniuUrl:_hostUser[@"avatar_img"] width:0 andHeight:0];
    }
     [_userView.iconIamgeView sd_setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:[UIImage imageNamed:@"empyImage120"]];
    _userView.userNameLabel.text = _hostUser[@"usernick"];
    _userView.numberLabel.text = @"";
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(anchorDetail)];
    _userView.iconIamgeView.userInteractionEnabled  = YES;
    [_userView.iconIamgeView addGestureRecognizer:tapGes];
    [_userView.isFoucsButton setTitle:@"关注" forState:(UIControlStateNormal)];
    [_userView.isFoucsButton addTarget:self action:@selector(foucsButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    NSInteger status = [_hostUser[@"friendStatus"] integerValue];
    if (status == 2 || status == 0) {//0 没有关系   1 关注   2 粉丝   3 好友
        _userView.isFoucsButton.tag = 2;
        dispatch_async(dispatch_get_main_queue(), ^{
            [_userView.isFoucsButton setTitle:@"关注" forState:(UIControlStateNormal)];
        });
    } else if (status == 1 || status == 3) {
        _userView.isFoucsButton.tag = 1;
        dispatch_async(dispatch_get_main_queue(), ^{
            [_userView.isFoucsButton setTitle:@"已关注" forState:(UIControlStateNormal)];
        });
        _userView.isFoucsButton.userInteractionEnabled = NO;
    }
    
    [_CAEmitterView addSubview:_userView];
    
    if (_chatRoomId) {//有chatroomid就是直播间否则为回放
        //观众列表
        UICollectionViewFlowLayout *layout=[[ UICollectionViewFlowLayout alloc ] init ];
        [layout setScrollDirection:(UICollectionViewScrollDirectionHorizontal)];
        _audienceCollectionView = [[ UICollectionView alloc ] initWithFrame : CGRectMake(SCREEN_WIDTH / 50, 70 + 10, SCREEN_WIDTH - 20, 50) collectionViewLayout :layout];
        [_audienceCollectionView registerNib:[UINib nibWithNibName:@"AudienceCell" bundle:nil] forCellWithReuseIdentifier:_CELL];
        _audienceCollectionView.showsHorizontalScrollIndicator = NO;
        _audienceCollectionView. backgroundColor =[ UIColor clearColor];
        _audienceCollectionView. delegate = self ;
        _audienceCollectionView. dataSource = self ;
        _audienceCollectionView.tag = 188;
        [_CAEmitterView addSubview:_audienceCollectionView];
        
        //礼物按钮
        UIButton *giftButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        giftButton.frame = CGRectMake(SCREEN_WIDTH / 49, distanceOfBottom - SCREEN_WIDTH / 8, SCREEN_WIDTH / 8 , SCREEN_WIDTH / 8);
        [giftButton setImage:[UIImage imageNamed:@"live_gift.png"] forState:(UIControlStateNormal)];
        [giftButton addTarget:self action:@selector(giftButtonAction) forControlEvents:(UIControlEventTouchUpInside)];
        _giftButton = giftButton;
        [self.view addSubview:_giftButton];
        //点赞按钮
        UIButton *likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        likeButton.size = CGSizeMake(SCREEN_WIDTH / 8,  SCREEN_WIDTH /8);
        likeButton.center = CGPointMake(CGRectGetMaxX(self.view.bounds) -SCREEN_WIDTH / 10 , CGRectGetMaxY(self.view.bounds) - SCREEN_WIDTH / 4 - 15 );
        [likeButton setImage:[UIImage imageNamed:@"live_like.png"] forState:(UIControlStateNormal)];
        [likeButton addTarget:self action:@selector(watchlikeButtonAction) forControlEvents:(UIControlEventTouchUpInside)];
        _likeButton = likeButton;
        [self.view addSubview:_likeButton];
        _likeLabel = [[UILabel alloc] init];
        _likeLabel.size = CGSizeMake(SCREEN_WIDTH / 12, 15);
        _likeLabel.center = CGPointMake(CGRectGetMidX(_likeButton.bounds), CGRectGetMidY(_likeButton.bounds) + 11);
        _likeLabel.textAlignment = NSTextAlignmentCenter;
        _likeLabel.font = [UIFont systemFontOfSize:11];
        _likeLabel.textColor = [UIColor whiteColor];
        [_likeButton addSubview:_likeLabel];
        UIButton *shareButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        shareButton.size = CGSizeMake(MinHeight_InputView, MinHeight_InputView);
        shareButton.center = CGPointMake(self.view.frame.size.width - SCREEN_WIDTH / 10,distanceOfBottom - MinHeight_InputView / 2);
        [shareButton setImage:[UIImage imageNamed:@"live_watchShare.png"] forState:(UIControlStateNormal)];
        [shareButton addTarget:self action:@selector(liveShareButtonAction) forControlEvents:(UIControlEventTouchUpInside)];
        _shareButton = shareButton;
        [self.view addSubview:_shareButton];
    }
}

#pragma mark --- 礼物、点赞等事件
-(void) giftButtonAction{
    _daShangView = [[[NSBundle mainBundle] loadNibNamed:@"DaShangView" owner:self options:nil] lastObject];
    _daShangView.frame = CGRectMake(0, SCREEN_HEIGHT- 300, SCREEN_WIDTH, 300);
    _daShangView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.5f];
    _daShangView.type = textTypeWhite;
    _daShangView.giftCollectionView.tag = 888;
    _daShangView.giftCollectionView.delegate = self;
    _daShangView.giftCollectionView.dataSource = self;
    [self.view addSubview:_daShangView];
    [self.view bringSubviewToFront:_daShangView];
    [_daShangView.closeButton addTarget:self action:@selector(dashangCloseViewAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [_daShangView.sendGiftButton addTarget:self action:@selector(sendGiftButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
}

-(void)sendGiftButtonAction:(UIButton *)sender{
    _dataArr = @[@{@"giftIamge":@"rose.png",@"giftName":@"玫瑰花",@"giftValue":@"10娱币"},
                 @{@"giftIamge":@"gold.png",@"giftName":@"元宝",@"giftValue":@"2500娱币"},
                 @{@"giftIamge":@"biantai.png",@"giftName":@"风油精",@"giftValue":@"50娱币"},
                 @{@"giftIamge":@"apple.png",@"giftName":@"Iphone10",@"giftValue":@"6666娱币"},
                 @{@"giftIamge":@"book.png",@"giftName":@"金瓶梅",@"giftValue":@"100娱币"},
                 @{@"giftIamge":@"watch.png",@"giftName":@"百达翡丽",@"giftValue":@"39999娱币"},
                 @{@"giftIamge":@"chicken.png",@"giftName":@"烤鸡",@"giftValue":@"200娱币"},
                 @{@"giftIamge":@"airport.png",@"giftName":@"私人飞机",@"giftValue":@"222222娱币"},
                 @{@"giftIamge":@"moreRose.png",@"giftName":@"玫瑰",@"giftValue":@"520娱币"},
                 @{@"giftIamge":@"ring.png",@"giftName":@"钻戒",@"giftValue":@"8888娱币"},
                 @{@"giftIamge":@"champagne.png",@"giftName":@"香槟",@"giftValue":@"680娱币"},
                 @{@"giftIamge":@"car.png",@"giftName":@"跑车",@"giftValue":@"88888娱币"},
                 @{@"giftIamge":@"lafei.png",@"giftName":@"拉菲",@"giftValue":@"1280娱币"},
                 @{@"giftIamge":@"ship.png",@"giftName":@"游艇",@"giftValue":@"131400娱币"},
                 @{@"giftIamge":@"huangjia.png",@"giftName":@"皇家礼炮",@"giftValue":@"1880娱币"},
                 @{@"giftIamge":@"house.png",@"giftName":@"别墅",@"giftValue":@"334400娱币"}
                 ];
    NSString *img = nil;
    for (NSDictionary *dic in _dataArr) {
        if (_giftValue == dic[@"giftValue"]) {
            img = dic[@"giftIamge"];
        }
    }
//    NSDictionary *dictGift = @{@"amount":_giftValue,
//                               @"toUserid":_hostUser[@"id"],
//                               @"rid":@"live",
//                               @"businessid":_chatRoomId};
//    __weak typeof(self) weakSelf = self;
//    [LYFriendsHttpTool daShangWithParms:dictGift complete:^(NSDictionary *dic) {
//        LYGiftMessage *giftMessage = [[LYGiftMessage alloc]init];
//        giftMessage.type = @"1";
//        giftMessage.gift.giftId = _giftValue;
//        [weakSelf sendMessage:giftMessage pushContent:@""];
//        [WeakSelf showGiftIamgeAnmiationWith:img];
//    }];
    LYGiftMessage *giftMessage = [[LYGiftMessage alloc]init];
    giftMessage.type = @"1";
    GiftContent *giftContent = [[GiftContent alloc] init];
    giftContent.giftId = _giftValue;
    giftMessage.gift = giftContent;
    [self sendMessage:giftMessage pushContent:@""];
    [_daShangView removeFromSuperview];
    _daShangView = nil;
}

-(void) showGiftIamgeAnmiationWith:(NSString *) giftImg{
    UIImage *img = [UIImage imageNamed:giftImg];
    UIImageView *giftIamge = [[UIImageView alloc] initWithImage:img];
    giftIamge.center = self.view.center;
    giftIamge.size = CGSizeMake(60, 60);
    [self.view addSubview:giftIamge];
    [self.view bringSubviewToFront:giftIamge];
    [UIView animateWithDuration:2 delay:2 usingSpringWithDamping:.7f initialSpringVelocity:.3f options:UIViewAnimationOptionOverrideInheritedCurve animations:^{
        giftIamge.size = CGSizeMake(0, 0);
    } completion:^(BOOL finished) {
        [giftIamge removeFromSuperview];
    }];
}

-(void)notice:(NSNotification *)notification{
    _giftValue = notification.userInfo[@"value"];
}

-(void)dashangCloseViewAction:(UIButton *) sender{
    [_daShangView removeFromSuperview];
    _daShangView = nil;
}


-(void)watchlikeButtonAction{
    NSDictionary *dic = @{@"liveChatId":_chatRoomId};
    [LYFriendsHttpTool watchLikeWithParms:dic complete:^(NSDictionary *dict) {
        
    }];
    NSInteger temp = [_likeLabel.text integerValue];
    temp +=1;
    [_likeLabel setText:[NSString stringWithFormat:@"%ld", temp]];
    LYGiftMessage *giftMessage = [[LYGiftMessage alloc]init];
    giftMessage.type = @"2";
    [self sendMessage:giftMessage pushContent:@""];
}


#pragma mark -- 分享
-(void)liveShareButtonAction{
    NSString *string= [NSString stringWithFormat:@"猎娱直播间"];
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = [NSString stringWithFormat:@"%@%@%@",LY_LIVE_SERVER,LY_LIVE_share,self.chatRoomId];
    [UMSocialData defaultData].extConfig.wechatSessionData.url = [NSString stringWithFormat:@"%@%@%@",LY_LIVE_SERVER,LY_LIVE_share,self.chatRoomId];
    [UMSocialData defaultData].extConfig.qqData.url = [NSString stringWithFormat:@"%@%@%@",LY_LIVE_SERVER,LY_LIVE_share,self.chatRoomId];

    [UMSocialSnsService presentSnsIconSheetView:self appKey:UmengAppkey shareText:string shareImage:_shareIamge shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina,UMShareToSms,nil] delegate:nil];
}


#pragma mark --- 初始化播放器
-(void) initPLplayer{
    PLPlayerOption *option = [PLPlayerOption defaultOption];
    [option setOptionValue:@15 forKey:PLPlayerOptionKeyTimeoutIntervalForMediaPackets];
//    NSURL *url = [NSURL URLWithString:@"rtmp://pili-live-rtmp.zhibo.lie98.com/lei98/test78"];
   
        NSURL *url = [NSURL URLWithString:_contentURL];
        self.player = [PLPlayer playerWithURL:url option:option];
        self.player.delegate = self;
        [self.view addSubview:self.player.playerView];
        [self.view sendSubviewToBack:self.player.playerView];
        [self.player play];
    
}

#pragma mark ---- 检测播放状态改变
- (void)player:(nonnull PLPlayer *)player statusDidChange:(PLPlayerStatus)state{
    
    switch (state) {
        case PLPlayerStatusUnknow:
            NSLog(@"0");
            break;
        case PLPlayerStatusPreparing:
            NSLog(@"1");
            break;
        case PLPlayerStatusReady:
            NSLog(@"2");
            break;
        case PLPlayerStatusCaching:
            NSLog(@"3");
            break;
        case PLPlayerStatusPlaying:
            NSLog(@"4");
            break;
        case PLPlayerStatusPaused:
            [MyUtil showMessage:@"主播暂停了直播..."];
            NSLog(@"5");
            break;
        case PLPlayerStatusStopped:
            if (_isActiveNow) {
                [self watchBackButtonAction];
            }
            NSLog(@"6");
            break;
        case PLPlayerStatusError:
            [self watchBackButtonAction];
            NSLog(@"7");
            break;
        case PLPlayerStateAutoReconnecting:
            [MyUtil showMessage:@"连接中..."];
            NSLog(@"8");
            break;
        default:
            break;
    }
}

- (void)player:(nonnull PLPlayer *)player stoppedWithError:(nullable NSError *)error{
    if (_isLiveing) {//有直播但是获取失败
        if (![_contentURL isEqual: [NSNull null]] || _contentURL != nil) {
            //        [app stopLoading];
            [MyUtil showMessage:@"链接失败！"];
            [self dismissViewControllerAnimated:YES completion:NULL];
        }
    } else {
        [MyUtil showMessage:@"直播结束"];
        [self dismissViewControllerAnimated:YES completion:NULL];
    }

}


#pragma mark -- 返回（结束播放）
-(void)watchBackButtonAction{
    _backImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BackImage.png"]];
    _backImage.frame = self.view.bounds;
    [self.view addSubview:_backImage];
    [self.view bringSubviewToFront:_backImage];
    _backImage.userInteractionEnabled = YES;
    _closeView = [[[NSBundle mainBundle] loadNibNamed:@"LiveShowEndView" owner:self options:nil] lastObject];
    _closeView.frame = self.view.bounds;
    [_closeView.lookNumLabel setText:_userView.numberLabel.text];
    if ([_userView.isFoucsButton.titleLabel.text isEqualToString:@"关注"]) {
        [_closeView.focusButton setTitle:@"关注" forState:(UIControlStateNormal)];
    } else {
        _closeView.focusButton.hidden = YES;
    }
    [self.view addSubview:_closeView];
    [self.view bringSubviewToFront:_closeView];
    _closeView.shareImage = self.shareIamge;
    _closeView.chatRoomID = _chatRoomId;
    [_closeView.backButton addTarget:self action:@selector(closebackButtonAction) forControlEvents:(UIControlEventTouchUpInside)];
    [_closeView.focusButton addTarget:self action:@selector(closeFocusButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
}

-(void)closebackButtonAction{
    [self.player stop];//关闭播放器
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(void)closeFocusButtonAction:(UIButton *)sender{
    NSInteger userid = [_hostUser[@"id"] integerValue];
    NSDictionary *dict = @{@"followid":[NSString stringWithFormat:@"%ld",userid]};
    [LYFriendsHttpTool followFriendWithParms:dict complete:^(NSDictionary *dict) {
        sender.titleLabel.text = @"已关注";
        sender.userInteractionEnabled = NO;
    }];
    [self.player stop];//关闭播放器
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark -- 关注
-(void)foucsButtonAction: (UIButton *) sender{
    NSInteger userid = [_hostUser[@"id"] integerValue];
    NSDictionary *dict = @{@"followid":[NSString stringWithFormat:@"%ld",userid]};
//    if (sender.tag == 1) {//不能取消关注
//        [LYFriendsHttpTool unFollowFriendWithParms:dict complete:^(NSDictionary *dict) {
//            sender.titleLabel.text = @"关注";
//        }];
//    } else {
        [LYFriendsHttpTool followFriendWithParms:dict complete:^(NSDictionary *dict) {
            sender.titleLabel.text = @"已关注";
            sender.userInteractionEnabled = NO;
        }];
//    }
}

#pragma mark -- 点击主播头像事件
-(void)anchorDetail{
    _anchorDetailView = [[[NSBundle mainBundle] loadNibNamed:@"AnchorDetailView" owner:self options:nil] lastObject];
    _anchorDetailView.frame = CGRectMake(0, 0, 260,210);
    _anchorDetailView.center = self.view.center;
    _anchorDetailView.layer.cornerRadius = 8.f;
    _anchorDetailView.layer.masksToBounds = YES;
    _anchorDetailView.backgroundColor = [UIColor whiteColor];
    _anchorDetailView.nickNameLabel.text = self.hostUser[@"usernick"];
    NSString *imgStr = [NSString stringWithFormat:@"%@",_hostUser[@"avatar_img"]];
    if (imgStr.length < 50) {
        imgStr = [MyUtil getQiniuUrl:_hostUser[@"avatar_img"] width:0 andHeight:0];
    }
    [_anchorDetailView.anchorIcon sd_setImageWithURL:[NSURL URLWithString:imgStr]];
    if ([_hostUser[@"gender"] isEqualToString:@"0"]) {
        _anchorDetailView.genderIamge.image=[UIImage imageNamed:@"woman"];
    }else{
        _anchorDetailView.genderIamge.image=[UIImage imageNamed:@"manIcon"];
    }
    [self.view addSubview:_anchorDetailView];
    [self.view bringSubviewToFront:_anchorDetailView];
    
    NSInteger status = [_hostUser[@"friendStatus"] integerValue];
    if (status == 2 || status == 0) {//0 没有关系   1 关注   2 粉丝   3 好友
        _anchorDetailView.focusButton.tag = 2;
        [_anchorDetailView.focusButton setTitle:@"关注" forState:(UIControlStateNormal)];
    } else if (status == 1 || status == 3) {
        _anchorDetailView.focusButton.tag = 1;
        [_anchorDetailView.focusButton setTitle:@"已关注" forState:(UIControlStateNormal)];
        _anchorDetailView.focusButton.userInteractionEnabled = NO;
    }
    [_anchorDetailView.focusButton addTarget:self action:@selector(anchorFocusButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [_anchorDetailView.mainViewButton addTarget:self action:@selector(mainViewButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    _anchorDetailView.mainViewButton.tag = [self.hostUser[@"userid"] integerValue];
}

-(void)showWatchDetailWith:(ChatUseres *) chatuser{
    _anchorDetailView = [[[NSBundle mainBundle] loadNibNamed:@"AnchorDetailView" owner:self options:nil] lastObject];
    _anchorDetailView.frame = CGRectMake(0, 0, SCREEN_WIDTH/5 * 3,SCREEN_HEIGHT / 4);
    _anchorDetailView.center = self.view.center;
    [_anchorDetailView.anchorIcon sd_setImageWithURL:[NSURL URLWithString:chatuser.avatar_img]];
    _anchorDetailView.nickNameLabel.text = chatuser.usernick;
    _chatuserid = chatuser.id;
    [_anchorDetailView.focusButton addTarget:self action:@selector(anchorFocusButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [_anchorDetailView.mainViewButton addTarget:self action:@selector(mainViewButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    _anchorDetailView.layer.cornerRadius = 10.f;
    _anchorDetailView.layer.masksToBounds = YES;
    _anchorDetailView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_anchorDetailView];
    [self.view bringSubviewToFront:_anchorDetailView];
}


-(void)anchorFocusButtonAction:(UIButton *) sender{
    NSInteger userid = [_hostUser[@"id"] integerValue];
    NSDictionary *dict = @{@"followid":[NSString stringWithFormat:@"%ld",userid]};
    if (sender.tag == 1) {//不能取消关注
        [LYFriendsHttpTool unFollowFriendWithParms:dict complete:^(NSDictionary *dict) {
            sender.titleLabel.text = @"关注";
        }];
    } else {
        [LYFriendsHttpTool followFriendWithParms:dict complete:^(NSDictionary *dict) {
            sender.titleLabel.text = @"已关注";
            sender.userInteractionEnabled = NO;
        }];
    }
}

-(void)mainViewButtonAction:(UIButton *) sender{
//    if ([MyUtil isEmptyString:_hostUser[@"id"]]) {
//        return;
//    }
    LYMyFriendDetailViewController *myFriendVC = [[LYMyFriendDetailViewController  alloc]initWithNibName:@"LYMyFriendDetailViewController" bundle:nil];
    myFriendVC.userID = [NSString stringWithFormat:@"%@", _hostUser[@"id"]];
    [self.navigationController pushViewController:myFriendVC animated:YES];
}

#pragma mark --UICollectionViewDataSource

//定义展示的UICollectionViewCell的个数

-( NSInteger )collectionView:( UICollectionView *)collectionView numberOfItemsInSection:( NSInteger )section
{
    if (collectionView.tag == 188) {//观众列表
        return _dataArray.count;
    } else {//信息
        return self.conversationDataRepository.count;
    }
    return 31;
}
//定义展示的Section的个数
-( NSInteger )numberOfSectionsInCollectionView:( UICollectionView *)collectionView
{
    return 1;
}

//每个UICollectionView展示的内容
-( UICollectionViewCell *)collectionView:( UICollectionView *)collectionView cellForItemAtIndexPath:( NSIndexPath *)indexPath
{
    if (collectionView.tag == 188) {
        AudienceCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier : _CELL forIndexPath :indexPath];
        ChatUseres *user = [[ChatUseres alloc] init];
        user = _dataArray[indexPath.row];
        NSString *imgStr = user.avatar_img;
        if (imgStr.length < 50) {
            imgStr = [MyUtil getQiniuUrl:user.avatar_img width:0 andHeight:0];
        }
        [cell.iconButton sd_setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:[UIImage imageNamed:@"empyImage120"]];
        
        return cell;
    } else {
        RCMessageModel *model =
        [self.conversationDataRepository objectAtIndex:indexPath.row];
        RCMessageContent *messageContent = model.content;
        RCMessageBaseCell *cell = nil;
        if ([messageContent isMemberOfClass:[RCTextMessage class]]) {
            LYTextMessageCell *__cell = [collectionView dequeueReusableCellWithReuseIdentifier:rctextCellIndentifier forIndexPath:indexPath];
            //            __cell.isFullScreenMode = YES;
            [__cell setDataModel:model];
            [__cell setDelegate:self];
            cell = __cell;
        } else if ([messageContent isMemberOfClass:[RCInformationNotificationMessage class]]){
            LYTipMessageCell *__cell = [collectionView dequeueReusableCellWithReuseIdentifier:rcTipMessageCellIndentifier forIndexPath:indexPath];
            //            __cell.isFullScreenMode = YES;
            [__cell setDataModel:model];
            [__cell setDelegate:self];
            cell = __cell;
        }
        else if ([messageContent isMemberOfClass:[LYGiftMessage class]]){
            LYGiftMessageCell *__cell = [collectionView dequeueReusableCellWithReuseIdentifier:rcGiftMessageCellIndentifier forIndexPath:indexPath];
            //            __cell.isFullScreenMode = YES;
            [__cell setDataModel:model];
            [__cell setDelegate:self];
            cell = __cell;
        }
        else if ([messageContent isMemberOfClass:[LYStystemMessage class]]) {
            LYSystemTextMessageCell *__cell = [collectionView dequeueReusableCellWithReuseIdentifier:rcStystemMessageCellIndentifier forIndexPath:indexPath];
            [__cell setDelegate:self];
            [__cell setDataModel:model];
            cell = __cell;
        }

        return cell;
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (touch.view != self.audienceCollectionView || touch.view != _daShangView.giftCollectionView) {
        return NO;
    }
    return YES;
}

-(void)showTheLove{
    DMHeartFlyView* heart = [[DMHeartFlyView alloc]initWithFrame:CGRectMake(0, 0, _heartSize, _heartSize)];
    [self.view addSubview:heart];
    CGPoint fountainSource = CGPointMake(SCREEN_WIDTH - 20 - _heartSize/2.0, SCREEN_HEIGHT - 60);
    heart.center = fountainSource;
    [heart animateInView:self.view];
}

#pragma mark -- 点击聊天室成员
-(void)watchAudienceAction:(UIButton *)sender{
    LYMyFriendDetailViewController *myFriendVC = [[LYMyFriendDetailViewController alloc]init];
    myFriendVC.isChatroom = 4;
    myFriendVC.imUserId = [NSString stringWithFormat:@"%ld",sender.tag];
//    [self.navigationController pushViewController:myFriendVC animated:YES];
}

/* 定义每个UICollectionView 的大小 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag == 188) {
        CGFloat width = 50;
        return CGSizeMake(width, width);
    } else {
        RCMessageModel *model =
        [self.conversationDataRepository objectAtIndex:indexPath.row];
        if (model.cellSize.height > 0) {
            return model.cellSize;
        }
        RCMessageContent *messageContent = model.content;
        if ([messageContent isMemberOfClass:[RCTextMessage class]] || [messageContent isMemberOfClass:[RCInformationNotificationMessage class]] || [messageContent isMemberOfClass:[LYGiftMessage class]] || [messageContent isMemberOfClass:[LYStystemMessage class]]) {
            model.cellSize = [self sizeForItem:collectionView atIndexPath:indexPath];
        } else {
            return CGSizeZero;
        }
        return model.cellSize;
    }
}
/**
 *  计算不同消息的具体尺寸
 *
 *  @return
 */
- (CGSize)sizeForItem:(UICollectionView *)collectionView
          atIndexPath:(NSIndexPath *)indexPath {
    CGFloat __width = CGRectGetWidth(collectionView.frame);
    RCMessageModel *model =
    [self.conversationDataRepository objectAtIndex:indexPath.row];
    RCMessageContent *messageContent = model.content;
    CGFloat __height = 0.0f;
    if ([messageContent
         isMemberOfClass:[RCInformationNotificationMessage class]]) {
        RCInformationNotificationMessage *notification = (RCInformationNotificationMessage *)messageContent;
        NSString *localizedMessage = [RCKitUtility formatMessage:notification];
        CGSize __labelSize = [LYTipMessageCell getTipMessageCellSize:localizedMessage];
        __height = __height + __labelSize.height;
    } else if ([messageContent isMemberOfClass:[RCTextMessage class]]) {
        RCTextMessage *_textMessage = (RCTextMessage *)messageContent;
        CGSize _textMessageSize = [LYTextMessageCell getMessageCellSize:_textMessage.content withWidth:__width];
        __height = _textMessageSize.height ;
    }else if([messageContent isMemberOfClass:[LYGiftMessage class]]){
        LYGiftMessage *likeMessage = (LYGiftMessage *)messageContent;
        NSString *txt = @"";
        if (likeMessage) {
            if(likeMessage.senderUserInfo){
                if ([likeMessage.senderUserInfo.userId isEqualToString:[RCIM sharedRCIM].currentUserInfo.userId]) {
                    txt = @"你送出一个";
                } else {
                    txt = [NSString stringWithFormat:@"%@送出一个",likeMessage.senderUserInfo.name];
                }
            } else {
                txt = @"神秘人送出一个";
            }
        }
        CGSize _textMessageSize = [LYGiftMessageCell getMessageCellSize:txt withWidth:__width];
        __height = _textMessageSize.height ;
    } else if ([messageContent isMemberOfClass:[LYStystemMessage class]]) {
        NSString *text = @"直播消息：\n我们提倡绿色直播，封面和直播内容含吸烟、低俗、诱导、违规等内容都将会被封停帐号，网警24小时在线巡查呦。";
        CGSize _textMessageSize = [LYSystemTextMessageCell getMessageCellSize:text withWidth:__width];
        __height = _textMessageSize.height + 10;
    }
    return CGSizeMake(__width, __height);
}

/* 定义每个UICollectionView 的边缘 */
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (collectionView.tag == 188) {
        return UIEdgeInsetsMake(0, 3, 0, 3);//上 左 下 右
    }else{
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
}

#pragma mark --- UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld",indexPath.row);
    if (collectionView.tag == 188) {
        ChatUseres *user = _dataArray[indexPath.row];
        [self showWatchDetailWith:user];
    } else {
        
    }
}

#pragma mark -- 初始化聊天室
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self rcinit];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self rcinit];
    }
    return self;
}

- (void)rcinit {
    self.conversationDataRepository = [[NSMutableArray alloc] init];
    self.conversationMessageCollectionView = nil;
    [self registerNotification];
    self.defaultHistoryMessageCountOfChatRoom = 10;
    //    [[RCIMClient sharedRCIMClient]setRCConnectionStatusChangeDelegate:self];
    [[RCIM sharedRCIM] setConnectionStatusDelegate:self];
    
}
/**
 *  注册监听Notification
 */
- (void)registerNotification {
    //注册接收消息
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(didHaveReceiveMessageNotification:)
     name:RCKitDispatchMessageNotification
     object:nil];
}

- (void)registerClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier {
    [self.conversationMessageCollectionView registerClass:cellClass
                               forCellWithReuseIdentifier:identifier];
}

#pragma mark --- 初始化聊天室界面
-(void)joinChatRoom{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    RCUserInfo *user = [[RCUserInfo alloc]init];
    user.userId = app.userModel.imuserId;
    user.name = app.userModel.usernick;
    [RCIM sharedRCIM].currentUserInfo = user;
    
    //初始化UI
    [self initializedSubViews];
    __weak WatchLiveShowViewController *weakSelf = self;
    self.isFullScreen = YES;
    self.conversationType = ConversationType_CHATROOM;
    //聊天室类型进入时需要调用加入聊天室接口，退出时需要调用退出聊天室接口
    if (ConversationType_CHATROOM == self.conversationType) {
        [[RCIMClient sharedRCIMClient]
         joinChatRoom:_chatRoomId
         messageCount:-1
         success:^{
             dispatch_async(dispatch_get_main_queue(), ^{
                 RCInformationNotificationMessage *joinChatroomMessage = [[RCInformationNotificationMessage alloc]init];
                 joinChatroomMessage.message = [NSString stringWithFormat: @"%@进入了直播间",[RCIM sharedRCIM].currentUserInfo.name];
                 LYStystemMessage *lyStystem = [[LYStystemMessage alloc] init];
                 [weakSelf sendMessage:lyStystem pushContent:nil];
                 [weakSelf sendMessage:joinChatroomMessage pushContent:nil];
             });
         }
         error:^(RCErrorCode status) {
             dispatch_async(dispatch_get_main_queue(), ^{
                 if (status == KICKED_FROM_CHATROOM) {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [MyUtil showCleanMessage:@"已被踢出"];
                     });
                 }else if(status == RC_CHATROOM_NOT_EXIST){
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [MyUtil showCleanMessage:@"不存在！"];
                     });
                 }else if(status == 30003){
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [MyUtil showCleanMessage:@"连接超时"];
                     });
                 }else if(status == RC_NETWORK_UNAVAILABLE){
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [MyUtil showCleanMessage:@"当前连接不可用"];
                     });
                 }else{
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [MyUtil showCleanMessage:@"未知错误"];
                     });
                 }
                 
             });
         }];
    }
}

/**
 *  初始化页面控件
 */
- (void)initializedSubViews {
    //聊天区
    if(self.contentView == nil){
        CGRect contentViewFrame = CGRectMake(0, SCREEN_HEIGHT / 8 *5 - 20,SCREEN_WIDTH - SCREEN_WIDTH / 8 , distanceOfBottom - SCREEN_HEIGHT /8 * 5 - SCREEN_WIDTH / 8);
        self.contentView.backgroundColor = RGBCOLOR(235, 235, 235);
        self.contentView = [[UIView alloc]initWithFrame:contentViewFrame];
        [self.view addSubview:self.contentView];
    }
    //聊天消息区
    UICollectionViewFlowLayout *customFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    customFlowLayout.minimumLineSpacing = 4;
    customFlowLayout.sectionInset = UIEdgeInsetsMake(10.0f, 0.0f, 10.0f, 0.0f);
    customFlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    CGRect _conversationViewFrame = self.contentView.bounds;
    //    CGRect _conversationViewFrame = CGRectMake(0, distanceOfBottom - MinHeight_InputView - SCREEN_HEIGHT / 8 * 3, SCREEN_WIDTH, SCREEN_HEIGHT /8 * 3);
    self.conversationMessageCollectionView =
    [[UICollectionView alloc] initWithFrame:_conversationViewFrame
                       collectionViewLayout:customFlowLayout];
    [self.conversationMessageCollectionView
     setBackgroundColor:RGBCOLOR(235, 235, 235)];
    self.conversationMessageCollectionView.showsVerticalScrollIndicator = NO;
    self.conversationMessageCollectionView.alwaysBounceVertical = YES;
    self.conversationMessageCollectionView.dataSource = self;
    self.conversationMessageCollectionView.delegate = self;
    [self.contentView addSubview:self.conversationMessageCollectionView];

    _commentView = [[[NSBundle mainBundle]loadNibNamed:@"LYFriendsCommentView" owner:nil options:nil] firstObject];
    _commentView.frame = CGRectMake(SCREEN_WIDTH / 6, distanceOfBottom - SCREEN_WIDTH / 8,SCREEN_WIDTH / 3 * 2 , MinHeight_InputView);
    _commentView.backgroundColor = [UIColor clearColor];
    _commentView.bgView.backgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:.5f];
    _commentView.bgView.layer.borderColor = RGBA(68,64,67, .2).CGColor;
    _commentView.bgView.layer.borderWidth = 0.5;
    _commentView.layer.cornerRadius = _commentView.frame.size.height / 2;
    _commentView.layer.masksToBounds = YES;
    _commentView.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"说点什么吧" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    _commentView.textField.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0];
    _commentView.textField.alpha = .5f;
    _commentView.textField.layer.borderColor = RGB(68, 64, 67).CGColor;
    _commentView.textField.borderStyle = UITextBorderStyleNone;
    [self.view addSubview:_commentView];
    _commentView.textField.delegate = self;
    [_commentView.btn_emotion addTarget:self action:@selector(emotionClick:) forControlEvents:UIControlEventTouchUpInside];
    _commentView.btn_emotion.hidden = YES;
    _commentView.textField.center = _commentView.center;
    [_commentView layoutIfNeeded];
    _bigView = [[UIView alloc]init];
    _bigView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(watchBigViewGes)];
    [_bigView addGestureRecognizer:tapGes];
    [self.view addSubview:_bigView];
    [self.view insertSubview:_bigView belowSubview:_commentView];
    _bigView.hidden = YES;
    
    
    [self registerClass:[LYTextMessageCell class]forCellWithReuseIdentifier:rctextCellIndentifier];
    [self registerClass:[LYTipMessageCell class]forCellWithReuseIdentifier:rcTipMessageCellIndentifier];
    [self registerClass:[LYGiftMessageCell class]forCellWithReuseIdentifier:rcGiftMessageCellIndentifier];
    [self registerClass:[LYSystemTextMessageCell class] forCellWithReuseIdentifier:rcStystemMessageCellIndentifier];

    [self changeModel:self.isFullScreen];
    _resetBottomTapGesture =[[UITapGestureRecognizer alloc]
                             initWithTarget:self
                             action:@selector(tap4ResetDefaultBottomBarStatus:)];
    [_resetBottomTapGesture setDelegate:self];
    [self.view addGestureRecognizer:_resetBottomTapGesture];
    
}

#pragma mark --- 键盘监听事件
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBorderApearce:) name:UIKeyboardWillChangeFrameNotification object:nil];
    _bigView.hidden = NO;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication ].delegate;
    if (![textField.text isEqualToString:@""]) {
        NSString *text = [NSString stringWithFormat:@"%@: %@",app.userModel.usernick, _commentView.textField.text];
        RCTextMessage *rcTextMessage = [RCTextMessage messageWithContent:text];
        [self sendMessage:rcTextMessage pushContent:nil];
        textField.text = @"";
    }
    [textField endEditing:YES];
    _commentView.frame = CGRectMake(SCREEN_WIDTH / 6, distanceOfBottom - SCREEN_WIDTH / 8,SCREEN_WIDTH / 3 * 2 , MinHeight_InputView);
    _commentView.backgroundColor = [UIColor clearColor];
    _commentView.bgView.backgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:.5f];
    _commentView.bgView.layer.borderColor = RGBA(68,64,67, .2).CGColor;
    _commentView.bgView.layer.borderWidth = 0.5;
    _commentView.layer.cornerRadius = _commentView.frame.size.height / 2;
    _commentView.layer.masksToBounds = YES;
    _commentView.layer.cornerRadius = _commentView.frame.size.height / 2;
    _commentView.layer.masksToBounds = YES;
    _commentView.textField.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0];    _commentView.textField.borderStyle = UITextBorderStyleNone;
    _commentView.btn_emotion.hidden = YES;
    _commentView.textField.center = _commentView.center;
    _contentView.frame = CGRectMake(0, SCREEN_HEIGHT / 8 *5 - 20,SCREEN_WIDTH - SCREEN_WIDTH / 8 , distanceOfBottom - SCREEN_HEIGHT /8 * 5 - SCREEN_WIDTH / 8);
    _bigView.hidden = YES;
    
    return YES;
}

//kvo监听评论输入框的字符 有字符就改变键盘的发送按钮为蓝色
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    //    NSLog(@"-->%@",change[@"new"]);
    NSString *newStr =change[@"new"];
    if (newStr.length) {
        [_emojiView.sendBtn setBackgroundColor:RGBA(10, 96, 255, 1)];
        [_emojiView.sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else {
        [_emojiView.sendBtn setTitleColor:RGBA(114, 114, 114, 1) forState:UIControlStateNormal];
        [_emojiView.sendBtn setBackgroundColor:[UIColor whiteColor]];
    }
}

//键盘弹出
- (void)keyBorderApearce:(NSNotification *)note{
    _bigView.hidden = NO;

    CGRect rect = [note.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    [UIView animateWithDuration:.25 animations:^{
        _commentView.frame = CGRectMake(0, SCREEN_HEIGHT - rect.size.height - 49, SCREEN_WIDTH, 49);
        _commentView.layer.cornerRadius = 0;
        _commentView.bgView.layer.borderColor = RGBA(200,200,200, .2).CGColor;
        _commentView.bgView.layer.borderWidth = 0.5;
        _commentView.backgroundColor = [UIColor whiteColor];
        _commentView.bgView.backgroundColor = [UIColor whiteColor];
        _commentView.textField.backgroundColor = [UIColor whiteColor];
        _commentView.btn_emotion.hidden = NO;
        _commentView.textField.borderStyle = UITextBorderStyleRoundedRect;
        
        _contentView.frame = CGRectMake(0, SCREEN_HEIGHT / 8 *5 - 20 - rect.size.height, SCREEN_WIDTH - SCREEN_WIDTH / 8 ,distanceOfBottom - SCREEN_HEIGHT /8 * 5 - SCREEN_WIDTH / 8);
    }];
}

//评论视图背景view 的手势去除评论view
- (void)watchBigViewGes{
    //    if (_commentView.textField.text.length) {
    defaultComment = _commentView.textField.text;
    //    }
    [_commentView.textField endEditing:YES];
    [UIView animateWithDuration:.25 animations:^{
        _commentView.frame = CGRectMake(SCREEN_WIDTH / 6, distanceOfBottom - SCREEN_WIDTH / 8,SCREEN_WIDTH / 3 * 2 , MinHeight_InputView);
        _commentView.backgroundColor = [UIColor clearColor];
        _commentView.bgView.backgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:.5f];
        _commentView.bgView.layer.borderColor = RGBA(68,64,67, .2).CGColor;
        _commentView.bgView.layer.borderWidth = 0.5;
        _commentView.layer.cornerRadius = _commentView.frame.size.height / 2;
        _commentView.layer.masksToBounds = YES;
        _commentView.layer.cornerRadius = _commentView.frame.size.height / 2;
        _commentView.layer.masksToBounds = YES;
        _commentView.textField.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0];
        _commentView.textField.borderStyle = UITextBorderStyleNone;
        _commentView.btn_emotion.hidden = YES;
        _commentView.textField.center = _commentView.center;
        
        _contentView.frame = CGRectMake(0, SCREEN_HEIGHT / 8 *5 - 20,SCREEN_WIDTH - SCREEN_WIDTH / 8 , distanceOfBottom - SCREEN_HEIGHT /8 * 5 - SCREEN_WIDTH / 8);
    }];
    _bigView.hidden = YES;
}

- (void)emotionClick:(UIButton *)button{
    button.selected = !button.selected;
    if(button.selected){//评论框右侧按钮切换为表情
        [button setImage:[UIImage imageNamed:@"biaoqing_icon_keybo"] forState:UIControlStateNormal];
        _commentView.btn_send_cont_width.constant = 60;
        [_commentView.btn_send setTitle:@"发送" forState:UIControlStateNormal];
        [_commentView.btn_send addTarget:self action:@selector(sendMessageClick:) forControlEvents:UIControlEventTouchUpInside];
        [self updateViewConstraints];
        [_commentView.textField endEditing:YES];
        _emojiView = [[ISEmojiView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 216)];
        _emojiView.delegate = self;
        _emojiView.backgroundColor = RGBA(244, 244, 246, 1);
        _emojiView.inputView = _commentView.textField;
        _commentView.textField.inputView = _emojiView;
        [_commentView.textField becomeFirstResponder];
        [UIView animateWithDuration:.1 animations:^{
            CGFloat y = SCREEN_HEIGHT - CGRectGetHeight(_commentView.frame) - CGRectGetHeight(_emojiView.frame);
            _commentView.frame = CGRectMake(0,y , CGRectGetWidth(_commentView.frame), CGRectGetHeight(_commentView.frame));
        }];
        if (_commentView.textField.text.length) {
            [_emojiView.sendBtn setBackgroundColor:RGBA(10, 96, 255, 1)];
            [_emojiView.sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }else{//评论框右侧按钮切换为键盘
        [button setImage:[UIImage imageNamed:@"biaoqing_icon"] forState:UIControlStateNormal];
        [_commentView.textField endEditing:YES];
        _commentView.textField.inputView = UIKeyboardAppearanceDefault;
        _commentView.btn_send_cont_width.constant = 0;
        [_commentView.btn_send setTitle:@"" forState:UIControlStateNormal];
        [self updateViewConstraints];
        [_commentView.textField becomeFirstResponder];
    }
    
}

#pragma mark - 表情键盘的代理方法
#pragma mark - WTT
- (void)sendMessageClick:(UIButton *)button{
    [self textFieldShouldReturn:_commentView.textField];
}

#pragma mark - 表情键盘的发送按钮
- (void)emojiView:(ISEmojiView *)emojiView didPressSendButton:(UIButton *)sendbutton{
    [self textFieldShouldReturn:_commentView.textField];
}
#pragma mark - 表情键盘的表情点击按钮
-(void)emojiView:(ISEmojiView *)emojiView didSelectEmoji:(NSString *)emoji{
    _commentView.textField.text = [_commentView.textField.text stringByAppendingString:emoji];
}
#pragma mark - 表情键盘的表情删除按钮
- (void)emojiView:(ISEmojiView *)emojiView didPressDeleteButton:(UIButton *)deletebutton{
    if (_commentView.textField.text.length > 0) {
        NSRange lastRange = [_commentView.textField.text rangeOfComposedCharacterSequenceAtIndex:_commentView.textField.text.length-1];
        _commentView.textField.text = [_commentView.textField.text substringToIndex:lastRange.location];
    }
}

/**
 *  全屏和半屏模式切换
 *
 *  @param isFullScreen 全屏或者半屏
 */
- (void)changeModel:(BOOL)isFullScreen {
    _isFullScreen = YES;
    self.conversationMessageCollectionView.backgroundColor = [UIColor clearColor];
    //修改会话列表和输入框位置
    CGRect _conversationViewFrame = self.contentView.bounds;
    _conversationViewFrame.size.height = self.contentView.bounds.size.height ;
    _conversationViewFrame.origin.y = 0;
    //     CGRect _conversationViewFrame = CGRectMake(0, distanceOfBottom - MinHeight_InputView - SCREEN_HEIGHT / 8 * 3, SCREEN_WIDTH, SCREEN_HEIGHT /8 * 3);
    [self.conversationMessageCollectionView setFrame:_conversationViewFrame];
//    float inputBarOriginY = distanceOfBottom - SCREEN_WIDTH / 8;
//    float inputBarOriginX = SCREEN_WIDTH / 6 ;
//    float inputBarSizeWidth = SCREEN_WIDTH / 3 *2 ;
//    float inputBarSizeHeight = MinHeight_InputView;
//    //添加输入框
//    self.inputBar.layer.cornerRadius = 8.f;
//    self.inputBar.layer.masksToBounds = YES;
//    self.inputBar.backgroundColor = [UIColor redColor];
//    [self.inputBar changeInputBarFrame:CGRectMake(inputBarOriginX, inputBarOriginY,inputBarSizeWidth,inputBarSizeHeight)];
    [self.conversationMessageCollectionView reloadData];
    [self.unreadButtonView setFrame:CGRectMake((self.view.frame.size.width - 80)/2, self.view.frame.size.height - MinHeight_InputView - 30, 80, 30)];
}

- (void)pushOldMessageModel:(RCMessageModel *)model {
    if (!(!model.content && model.messageId > 0)
        && !([[model.content class] persistentFlag] & MessagePersistent_ISPERSISTED)) {
        return;
    }
    long ne_wId = model.messageId;
    for (RCMessageModel *__item in self.conversationDataRepository) {
        if (ne_wId == __item.messageId) {
            return;
        }
    }
    [self.conversationDataRepository insertObject:model atIndex:0];
}

/**
 *  加载历史消息(暂时没有保存聊天室消息)
 */
- (void)loadMoreHistoryMessage {
    long lastMessageId = -1;
    if (self.conversationDataRepository.count > 0) {
        RCMessageModel *model = [self.conversationDataRepository objectAtIndex:0];
        lastMessageId = model.messageId;
    }
    
    NSArray *__messageArray =
    [[RCIMClient sharedRCIMClient] getHistoryMessages:_conversationType
                                             targetId:_chatRoomId
                                      oldestMessageId:lastMessageId
                                                count:10];
    for (int i = 0; i < __messageArray.count; i++) {
        RCMessage *rcMsg = [__messageArray objectAtIndex:i];
        RCMessageModel *model = [[RCMessageModel alloc] initWithMessage:rcMsg];
        [self pushOldMessageModel:model];
    }
    [self.conversationMessageCollectionView reloadData];
    if (_conversationDataRepository != nil &&
        _conversationDataRepository.count > 0 &&
        [self.conversationMessageCollectionView numberOfItemsInSection:0] >=
        __messageArray.count - 1) {
        NSIndexPath *indexPath =
        [NSIndexPath indexPathForRow:__messageArray.count - 1 inSection:0];
        [self.conversationMessageCollectionView scrollToItemAtIndexPath:indexPath
                                                       atScrollPosition:UICollectionViewScrollPositionTop
                                                               animated:NO];
    }
}


#pragma mark <UIScrollViewDelegate>
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
}

/**
 *  滚动条滚动时显示正在加载loading
 *
 *  @param scrollView
 // */
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    self.conversationMessageCollectionView
//    // 是否显示右下未读icon
////    if (self.unreadNewMsgCount != 0) {
////        [self checkVisiableCell];
////    }
////
//    if (scrollView.contentOffset.y < -5.0f) {
//        [self.collectionViewHeader startAnimating];
//    } else {
//        [self.collectionViewHeader stopAnimating];
//        _isLoading = NO;
//    }
//}

/**
 *  滚动结束加载消息 （聊天室消息还没存储，所以暂时还没有此功能）
 *
 *  @param scrollView scrollView description
 *  @param decelerate decelerate description
 */
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
//                  willDecelerate:(BOOL)decelerate {
//    if (scrollView.contentOffset.y < -15.0f && !_isLoading) {
//        _isLoading = YES;
//        //        [self performSelector:@selector(loadMoreHistoryMessage)
//        //                   withObject:nil
//        //                   afterDelay:0.4f];
//    }
//}

- (void)scrollToBottomAnimated:(BOOL)animated {
    if ([self.conversationMessageCollectionView numberOfSections] == 0) {
        return;
    }
    NSUInteger finalRow = MAX(0, [self.conversationMessageCollectionView numberOfItemsInSection:0] - 1);
    if (0 == finalRow) {
        return;
    }
    NSIndexPath *finalIndexPath =
    [NSIndexPath indexPathForItem:finalRow inSection:0];
    [self.conversationMessageCollectionView scrollToItemAtIndexPath:finalIndexPath
                                                   atScrollPosition:UICollectionViewScrollPositionTop
                                                           animated:animated];
}

/**
 *  将消息加入本地数组
 *
 *  @return
 */
- (void)appendAndDisplayMessage:(RCMessage *)rcMessage {
    if (!rcMessage) {
        return;
    }
    RCMessageModel *model = [[RCMessageModel alloc] initWithMessage:rcMessage];
    if([rcMessage.content isMemberOfClass:[LYGiftMessage class]]){
        model.messageId = -1;
    }
    if ([self appendMessageModel:model]) {
        NSIndexPath *indexPath =
        [NSIndexPath indexPathForItem:self.conversationDataRepository.count - 1
                            inSection:0];
        if ([self.conversationMessageCollectionView numberOfItemsInSection:0] !=
            self.conversationDataRepository.count - 1) {
            return;
        }
        [self.conversationMessageCollectionView
         insertItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
        if ([self isAtTheBottomOfTableView] || self.isNeedScrollToButtom) {
            [self scrollToBottomAnimated:YES];
            self.isNeedScrollToButtom=NO;
        }
    }
}

/**
 *  如果当前会话没有这个消息id，把消息加入本地数组
 *
 *  @return
 */
- (BOOL)appendMessageModel:(RCMessageModel *)model {
    long newId = model.messageId;
    for (RCMessageModel *__item in self.conversationDataRepository) {
        /*
         * 当id为－1时，不检查是否重复，直接插入
         * 该场景用于插入临时提示。
         */
        if (newId == -1) {
            [self showTheLove];
            break;
        }
        if (newId == __item.messageId) {
            return NO;
        }
    }
//    if (!model.content) {
//        return NO;
//    }
    //这里可以根据消息类型来决定是否显示，如果不希望显示直接return NO
    
    //数量不可能无限制的大，这里限制收到消息过多时，就对显示消息数量进行限制。
    //用户可以手动下拉更多消息，查看更多历史消息。
    if (self.conversationDataRepository.count>100) {
        //                NSRange range = NSMakeRange(0, 1);
        RCMessageModel *message = self.conversationDataRepository[0];
        [[RCIMClient sharedRCIMClient]deleteMessages:@[@(message.messageId)]];
        [self.conversationDataRepository removeObjectAtIndex:0];
        [self.conversationMessageCollectionView reloadData];
    }
    
    [self.conversationDataRepository addObject:model];
    return YES;
}

/**
 *  UIResponder
 *
 *  @return
 */
- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    return [super canPerformAction:action withSender:sender];
}

/**
 *  找出消息的位置
 *
 *  @return
 */
- (NSInteger)findDataIndexFromMessageList:(RCMessageModel *)model {
    NSInteger index = 0;
    for (int i = 0; i < self.conversationDataRepository.count; i++) {
        RCMessageModel *msg = (self.conversationDataRepository)[i];
        if (msg.messageId == model.messageId) {
            index = i;
            break;
        }
    }
    return index;
}


/**
 *  打开大图。开发者可以重写，自己下载并且展示图片。默认使用内置controller
 *
 *  @param imageMessageContent 图片消息内容
 */
- (void)presentImagePreviewController:(RCMessageModel *)model;
{
}

/**
 *  打开地理位置。开发者可以重写，自己根据经纬度打开地图显示位置。默认使用内置地图
 *
 *  @param locationMessageCotent 位置消息
 */
- (void)presentLocationViewController:
(RCLocationMessage *)locationMessageContent {
    
}

/**
 *  关闭提示框
 *
 *  @param theTimer theTimer description
 */
- (void)timerForHideHUD:(NSTimer*)theTimer//弹出框
{
    __weak __typeof(&*self)weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
    });
    [theTimer invalidate];
    theTimer = nil;
}

- (void)sendMessage:(RCMessageContent *)messageContent
        pushContent:(NSString *)pushContent {
    
    if(self.currentConnectionStatus != ConnectionStatus_Connected){
        [NSTimer scheduledTimerWithTimeInterval:1.0f
                                         target:self
                                       selector:@selector(timerForHideHUD:)
                                       userInfo:nil
                                        repeats:YES];
        MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:NO];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"与服务器断开，请检查网络";
        return;
    }
    messageContent.senderUserInfo = [RCIM sharedRCIM].currentUserInfo;
    if (messageContent == nil) {
        return;
    }
    
    [[RCIM sharedRCIM] sendMessage:self.conversationType
                          targetId:_chatRoomId
                           content:messageContent
                       pushContent:pushContent
                          pushData:nil
                           success:^(long messageId) {
                               __weak typeof(&*self) __weakself = self;
                               dispatch_async(dispatch_get_main_queue(), ^{
                                   RCMessage *message = [[RCMessage alloc] initWithType:__weakself.conversationType
                                                                               targetId:__weakself.chatRoomId
                                                                              direction:MessageDirection_SEND
                                                                              messageId:messageId
                                                                                content:messageContent];
                                   if ([message.content isMemberOfClass:[LYGiftMessage class]] ) {
                                       message.messageId = -1;//插入消息时如果id是-1不判断是否存在
                                   }
                                   [__weakself appendAndDisplayMessage:message];
                               });
                           } error:^(RCErrorCode nErrorCode, long messageId) {
                               [[RCIMClient sharedRCIMClient]deleteMessages:@[ @(messageId) ]];
                           }];
}

/**
 *  接收到消息的回调
 *
 *  @param notification
 */
- (void)didHaveReceiveMessageNotification:(NSNotification *)notification {
    __block RCMessage *rcMessage = notification.object;
    RCMessageModel *model = [[RCMessageModel alloc] initWithMessage:rcMessage];
    NSDictionary *leftDic = notification.userInfo;
    if (leftDic && [leftDic[@"left"] isEqual:@(0)]) {
        self.isNeedScrollToButtom = YES;
    }
    if (model.conversationType == self.conversationType &&
        [model.targetId isEqual:self.chatRoomId]) {
        __weak typeof(&*self) __blockSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (rcMessage) {
                [__blockSelf appendAndDisplayMessage:rcMessage];
                UIMenuController *menu = [UIMenuController sharedMenuController];
                menu.menuVisible=NO;
                //如果消息不在最底部，收到消息之后不滚动到底部，加到列表中只记录未读数
                if (![self isAtTheBottomOfTableView]) {
                    self.unreadNewMsgCount ++ ;
                    [self updateUnreadMsgCountLabel];
                }
            }
        });
    }
}
/**
 *  更新底部新消息提示显示状态
 */
- (void)updateUnreadMsgCountLabel{
    if (self.unreadNewMsgCount == 0) {
        self.unreadButtonView.hidden = YES;
    }
    else{
        self.unreadButtonView.hidden = NO;
        self.unReadNewMessageLabel.text = @"底部有新消息";
    }
}
/**
 *  定义展示的UICollectionViewCell的个数
 *
 *  @return
 */
- (void)tap4ResetDefaultBottomBarStatus:
(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        CGRect collectionViewRect = self.conversationMessageCollectionView.frame;
        collectionViewRect.size.height = self.contentView.bounds.size.height - self.inputBar.frame.size.height -30;
        [self.conversationMessageCollectionView setFrame:collectionViewRect];
    }
}

/**
 *  判断消息是否在collectionView的底部
 *
 *  @return 是否在底部
 */
- (BOOL)isAtTheBottomOfTableView {
    if (self.conversationMessageCollectionView.contentSize.height <= self.conversationMessageCollectionView.frame.size.height) {
        return YES;
    }
    if(self.conversationMessageCollectionView.contentOffset.y +200 >= (self.conversationMessageCollectionView.contentSize.height - self.conversationMessageCollectionView.frame.size.height)) {
        return YES;
    }else{
        return NO;
    }
}

#pragma mark - 输入框事件
/**
 *  点击键盘回车或者emoji表情面板的发送按钮执行的方法
 *
 *  @param text  输入框的内容
 */
- (void)onTouchSendButton:(NSString *)text{
    RCTextMessage *rcTextMessage = [RCTextMessage messageWithContent:text];
    [self sendMessage:rcTextMessage pushContent:nil];
    //    [self.inputBar setInputBarStatus:KBottomBarDefaultStatus];
    //    [self.inputBar setHidden:YES];
}

//修复ios7下不断下拉加载历史消息偶尔崩溃的bug
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

#pragma mark RCInputBarControlDelegate

/**
 *  根据inputBar 回调来修改页面布局，inputBar frame 变化会触发这个方法
 *
 *  @param frame    输入框即将占用的大小
 *  @param duration 时间
 *  @param curve
 */
- (void)onInputBarControlContentSizeChanged:(CGRect)frame withAnimationDuration:(CGFloat)duration andAnimationCurve:(UIViewAnimationCurve)curve{
    CGRect collectionViewRect = self.conversationMessageCollectionView.frame;
    self.contentView.backgroundColor = [UIColor clearColor];
    collectionViewRect.origin.y = 0 - frame.size.height + 80;
    
    [UIView animateWithDuration:duration animations:^{
        [UIView setAnimationCurve:curve];
        [self.conversationMessageCollectionView setFrame:collectionViewRect];
        [UIView commitAnimations];
    }];
    [self scrollToBottomAnimated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"kobe24" object:nil];
}

- (void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status {
    self.currentConnectionStatus = status;
}

@end
