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
#import "WatchPlayerClient.h"

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

#import "LYUserHttpTool.h"
#import "LYFriendsHttpTool.h"
#import "LYYUHttpTool.h"
#import "LYMyFriendDetailViewController.h"
#import "MineYubiViewController.h"

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

#import "PresentView.h"
#import "PresentModel.h"
#import "CustonCell.h"
#import "DaShangGiftModel.h"


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

@interface WatchLiveShowViewController () <PLPlayerDelegate,ISEmojiViewDelegate,UMSocialUIDelegate,PresentViewDelegate>

{
    NSTimer *_timer;//定时器
    int _takeNum;//聊天数
    NSInteger _likeNum;//点赞数
    LYFriendsCommentView *_commentView;//弹出的评论框
    UILabel *_textLabel;//输入框
    NSString *defaultComment;//残留评论
    ISEmojiView *_emojiView;//表情键盘
    UIView *_bigView;//评论的背景view
    UIButton *_iconButton, *_giftButton;
    CGFloat _heartSize;//红心的大小
    UILabel *_likeLabel;//
    NSTimer *_burstTimer;//延时
    int _giftNumber;//礼物数量
    NSString *_giftId;//礼物id
    NSString *_giftValue;//礼物价值
    NSString *_giftImg;
    NSString *_gifType;//动画类型
    NSString *_giftName;
    UIView *_backgroudView;//背景
    NSInteger _chatuserid;
    BOOL _isActiveNow;//是否是前台
    LiveStates _isLiveing;//直播状态
    UILabel *pauseLable;//暂停视图
    BOOL _isfirstPlay;//回放时加载进度条判断
    UISlider *_slider;//进度条
    LYGiftMessage *_presentModel;//收到的礼物
    NSTimer *_daShangTimer;
    
    AnimationGift_watch _animation;
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

@property (strong, nonatomic)  PresentView *presentView;
@property (strong, nonatomic) NSMutableArray *presentDataArray;
@property (strong, nonatomic)NSTimer *giftTimer;//礼物定时检测
@property (strong, nonatomic) UIImageView *animationImageView;
@property (nonatomic, strong) UIImageView *firework_left_ImageView;
@property (nonatomic, strong) UIImageView *firework_right_ImageView;
@property (nonatomic, strong) UIImageView *firework_middle_ImageView;


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

-(NSMutableArray *)presentDataArray
{
    if (!_presentDataArray) {
        _presentDataArray = [NSMutableArray array];
    }
    return _presentDataArray;
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    _dataArray = [NSMutableArray arrayWithCapacity:123];
    [RCIM sharedRCIM].disableMessageAlertSound = YES;//关闭融云的提示音
    if (_chatRoomId != nil) {
        [self timerUpdataAction];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [RCIM sharedRCIM].disableMessageAlertSound = NO;//打开提示音
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].isAdd = NO;
    self.navigationController.navigationBarHidden = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"sendGift" object:nil];
    [_timer invalidate];
    _timer = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.emitterLayer setHidden:NO];
    if (_contentURL) {
        [self initPLplayer];
    }
    [self initUI];
    if (_chatRoomId != nil) {
        [self joinChatRoom];
        _timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(timerUpdataAction) userInfo:nil repeats:YES];
        [_timer fire];
        [self timerUpdataAction];
        _isfirstPlay = NO;
    } else {
        _isfirstPlay = YES;
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
            [self.player resume];
        } else if (sender.name == UIApplicationWillResignActiveNotification) {
            [self.player pause];
        }
}


#pragma mark -- 定时获取直播室人员和点赞数 或者回放时的播放进度
-(void)timerUpdataAction {
    NSDictionary *dictionary = @{@"chatNum":[NSString stringWithFormat:@"0"],@"liveChatId":_chatRoomId};
    [LYFriendsHttpTool requestListWithParms:dictionary complete:^(NSDictionary *dict) {
        _likeLabel.text = [NSString stringWithFormat:@"%@",dict[@"likeNum"]];
        if ([dict valueForKey:@"total"]) {
            _userView.numberLabel.text = [NSString stringWithFormat:@"%@",dict[@"total"]];
        } else {
            _userView.numberLabel.text = @"";
        }
//        if ([dict valueForKey:@"users"]) {
        [self.dataArray removeAllObjects];
        self.dataArray = dict[@"users"];
//            for (ChatUseres *model  in _dataArray) {
//                NSString *tempID = [NSString stringWithFormat:@"%@", _hostUser[@"id"]];
//                if (model.id == tempID.integerValue) {
//                    [_dataArray removeObject:model];
//                    break;
//                }
//            }
//        }
        [_audienceCollectionView reloadData];
    }];
    NSDictionary *watchDict = @{@"liveChatId":_chatRoomId};
    [LYFriendsHttpTool getLiveStatusWithParms:watchDict complete:^(NSDictionary *dict) {
        NSInteger num = [NSString stringWithFormat:@"%@",dict[@"livestatus"]].integerValue;
        
        switch (num) {
            case 200:
            {
                if (_isLiveing == LiveStatePause && pauseLable) {
                        self.player = [[WatchPlayerClient sharedPlayerClient] playWithUrl:_contentURL];
                        [pauseLable removeFromSuperview];
                        pauseLable = nil;
                }
                _isLiveing = LiveStateLiveing;
            }
                break;
            case 800:
                _isLiveing = LiveStatePause;
                break;
            default:
                _isLiveing = LiveStateUnkown;
                break;
        }
    }];
}

//定时获取礼物动画
-(void)watchGiftTimerUpdataAction{
    if (self.presentDataArray.count && _animation == AnimationNone_watch) {
        DaShangGiftModel *model = self.presentDataArray[0];
        [self showGiftIamgeAnmiationWith:model.rewardImg With:model.rewordType];
        [self.presentDataArray removeObjectAtIndex:0];
    }
}

-(void) updateProgress{
    float value = CMTimeGetSeconds(_player.currentTime);
    [_slider setValue:value animated:YES];
}

#pragma mark --- 初始化页面
-(void)initUI {
    //粒子动画
    _CAEmitterView = [[UIView alloc] initWithFrame:self.view.bounds];
    _CAEmitterView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_CAEmitterView];
    _heartSize = 46;
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
    _userView.numberLabel.text = _joinNum;
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
    
    //礼物区域
    self.presentView = [[PresentView alloc] initWithFrame:(CGRectMake(0, 140, 230 , 150))];
    self.presentView.backgroundColor = [UIColor clearColor];
    self.presentView.delegate = self;
    [_CAEmitterView addSubview:_presentView];
    
    //礼物按钮
    if (_isCoin) {
        UIButton *giftButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        giftButton.frame = CGRectMake(SCREEN_WIDTH / 49, distanceOfBottom - SCREEN_WIDTH / 8, SCREEN_WIDTH / 8 , SCREEN_WIDTH / 8);
        [giftButton setImage:[UIImage imageNamed:@"live_gift.png"] forState:(UIControlStateNormal)];
        [giftButton addTarget:self action:@selector(giftButtonAction) forControlEvents:(UIControlEventTouchUpInside)];
        _giftButton = giftButton;
        [self.view addSubview:_giftButton];
        
        _giftTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(watchGiftTimerUpdataAction) userInfo:nil repeats:YES];
        [_giftTimer fire];
        _animation = AnimationNone_watch;
        
    }
    
    //分享按钮
    UIButton *shareButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    shareButton.size = CGSizeMake(MinHeight_InputView, MinHeight_InputView);
    shareButton.center = CGPointMake(self.view.frame.size.width - SCREEN_WIDTH / 10,distanceOfBottom - MinHeight_InputView / 2);
    [shareButton setImage:[UIImage imageNamed:@"live_watchShare.png"] forState:(UIControlStateNormal)];
    [shareButton addTarget:self action:@selector(liveShareButtonAction) forControlEvents:(UIControlEventTouchUpInside)];
    _shareButton = shareButton;
    [self.view addSubview:_shareButton];
    
    if (_chatRoomId) {//有chatroomid就是直播间否则为回放
        //观众列表
        UICollectionViewFlowLayout *layout=[[ UICollectionViewFlowLayout alloc ] init ];
        [layout setScrollDirection:(UICollectionViewScrollDirectionHorizontal)];
        _audienceCollectionView = [[ UICollectionView alloc ] initWithFrame : CGRectMake(SCREEN_WIDTH / 50, 70 + 10, SCREEN_WIDTH - 20, 50) collectionViewLayout :layout];
        [_audienceCollectionView registerClass:[AudienceCell class] forCellWithReuseIdentifier:_CELL];
        _audienceCollectionView.showsHorizontalScrollIndicator = NO;
        _audienceCollectionView. backgroundColor =[ UIColor clearColor];
        _audienceCollectionView. delegate = self;
        _audienceCollectionView. dataSource = self;
        _audienceCollectionView.tag = 188;
        [_CAEmitterView addSubview:_audienceCollectionView];
        

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
        _likeLabel.font = [UIFont systemFontOfSize:9];
        _likeLabel.textColor = [UIColor whiteColor];
        [_likeButton addSubview:_likeLabel];
        
        if ([_livestatusNow isEqualToString:@"800"]) {
            pauseLable = [[UILabel alloc] init];
            pauseLable.size = CGSizeMake(230, 30);
            pauseLable.center = CGPointMake(SCREEN_WIDTH / 2, self.view.center.y);
            pauseLable.backgroundColor = [UIColor blackColor];
            pauseLable.text = @"主播离开，直播暂停中...";
            pauseLable.textAlignment =  NSTextAlignmentCenter;
            pauseLable.textColor = [UIColor whiteColor];
            [self.view addSubview:pauseLable];
            [self.view bringSubviewToFront:pauseLable];
        }
    }
}

#pragma mark --- 礼物、点赞等事件
-(void) giftButtonAction{
    _backgroudView = [[UIView alloc] initWithFrame:self.view.bounds];
    _backgroudView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.01f];
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchBackgroud)];
    [_backgroudView addGestureRecognizer:tapGes];
    [self.view addSubview:_backgroudView];
    [self.view bringSubviewToFront:_backgroudView];
    
    _daShangView = [[DaShangView alloc] init];
    _daShangView.frame = CGRectMake(0, SCREEN_HEIGHT- 300, SCREEN_WIDTH, 300);
    _daShangView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.5f];
    _daShangView.type = textType_Live;
    _daShangView.sendGiftButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    _daShangView.sendGiftButton.backgroundColor = COMMON_PURPLE;
    [_daShangView.sendGiftButton addTarget:self action:@selector(sendGiftButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:_daShangView];
    
    self.contentView.hidden = YES;
    //倒计时按钮
    _daShangView.timeButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    _daShangView.timeButton.backgroundColor = COMMON_PURPLE;
    [_daShangView.timeButton addTarget:self action:@selector(sendGiftTimeButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    //隐藏背后按钮
    _shareButton.alpha = 0.0f;
    _likeButton.alpha = 0.0f;
    _commentView.alpha = 0.0f;
    _giftButton.alpha = 0.0f;
    _giftNumber = 0;
}

//打赏定时方法
-(void)changeTimebuttonTitle
{
    
    NSInteger number = [_daShangView.timeButton.titleLabel.text integerValue];
    number--;
    _daShangView.timeButton.titleLabel.text = [NSString stringWithFormat:@"%ld",(long)number];
    [_daShangView.timeButton setTitle:[NSString stringWithFormat:@"%ld",(long)number] forState:(UIControlStateNormal)];
    [_daShangView.timeButton setTitle:[NSString stringWithFormat:@"%ld",(long)number] forState:(UIControlStateDisabled)];
    if (number == 0) {
        [_daShangTimer invalidate];
        _timer = nil;
        _daShangView.timeButton.hidden = YES;
        _daShangView.sendGiftButton.hidden = NO;
        _daShangView.timeButton.titleLabel.text = @"30";
        [_daShangView.timeButton setTitle:@"30" forState:(UIControlStateNormal)];
        [_daShangView.timeButton setTitle:@"30" forState:(UIControlStateDisabled)];
    }
}

//点击打赏按钮--(直接加 1 )
-(void)sendGiftButtonAction:(UIButton *)sender{
    _giftNumber = 1;
    if ([_gifType isEqualToString:@"1"]) {
        if (_daShangView.timeButton.hidden) {
            _daShangView.timeButton.hidden = NO;
            [_daShangView.timeButton setTitle:@"30" forState:(UIControlStateNormal)];
            [_daShangView bringSubviewToFront:_daShangView.timeButton];
            _daShangView.sendGiftButton.hidden = YES;
            
            //计时器
            _daShangTimer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(changeTimebuttonTitle) userInfo:nil repeats:YES];
            [_daShangTimer fire];
        }
    } else {
        [self sendGiftWith:1];
    }
}

//点击连乘打赏--(当前的数字)
-(void)sendGiftTimeButtonAction:(UIButton *) sender{
    int number = (int)sender.titleLabel.text.integerValue;
    _giftNumber = number;
    [self sendGiftWith:_giftNumber];
    [self watchdashangCloseViewAction];
}

-(void)sendGiftWith:(int)giftNumber{
    if (![MyUtil isUserLogin]) {
        [MyUtil showCleanMessage:@"您还未登录"];
        return;
    }
    NSInteger temp = _giftValue.integerValue * giftNumber;
    NSString *totalValue = [NSString stringWithFormat:@"%ld",(long)temp];
    NSString *tempID = [NSString stringWithFormat:@"%@", _hostUser[@"id"]];
    NSString *roomid = _chatRoomId == nil ? _playbackRoomId : _chatRoomId;
    NSDictionary *dictGift = @{@"amount":totalValue,
                               @"toUserid":tempID,
                               @"rid":@"2",
                               @"businessid":roomid};
    [LYUserHttpTool getMyMoneyBagBalanceAndCoinWithParams:nil complete:^(ZSBalance *balance) {
        NSInteger coin = balance.coin.integerValue;
        if (coin >= temp) {//娱币足够
            [LYFriendsHttpTool daShangWithParms:dictGift complete:^(NSDictionary *dic) {
                NSInteger temp = [dic[@"errorcode"] integerValue];
                switch (temp) {
                    case 0:
                        [MyUtil showMessage:@"服务器异常"];
                        break;
                    case 1://成功
                    {
                        if (_chatRoomId) {
                            /*直播发消息*/
                            LYGiftMessage *giftMessage = [[LYGiftMessage alloc]init];
                            giftMessage.type = @"1";
                            giftMessage.content = [NSString stringWithFormat:@"赠送了%d个%@",giftNumber ,_giftName];
                            GiftContent *giftContent = [[GiftContent alloc] init];
                            giftContent.giftId = _giftId;
                            giftContent.giftUrl = _giftImg;
                            giftContent.giftAnnimType = _gifType;
                            giftContent.giftNumber = [NSString stringWithFormat:@"%d",giftNumber];
                            giftMessage.gift = giftContent;
                            [self sendMessage:giftMessage pushContent:@""];
                        } else {
                            /*回放时直接显示动画*/
                            NSInteger numbertype = [_gifType integerValue];
                            if (2 <= numbertype && numbertype <= 5) {
                                DaShangGiftModel *model = [[DaShangGiftModel alloc] modelWithrewardName:nil rewardImg:_giftImg rewardValue:0 rewardType:_gifType];
                                [self.presentDataArray addObject:model];
                            } else {
                                AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
                                NSMutableArray *presentArr = [NSMutableArray array];
                                NSString *content = [NSString stringWithFormat:@"赠送了%d个%@",giftNumber ,_giftName];
                                LYGiftMessage *giftMessage = [[LYGiftMessage alloc] init];
                                
                                RCUserInfo *senderInfo = [[RCUserInfo alloc] initWithUserId:nil name:app.userModel.usernick portrait:app.userModel.avatar_img];
                                giftMessage.senderUserInfo = senderInfo;
                               
                                GiftContent *giftContent = [[GiftContent alloc] init];
                                giftContent.giftId = _giftId;
                                giftContent.giftUrl = _giftImg;
                                giftContent.giftAnnimType = _gifType;
                                giftContent.giftNumber = [NSString stringWithFormat:@"%d",giftNumber];
                                giftMessage.gift = giftContent;
                                
                                giftMessage.content = content;
                                for (int i = 0; i < giftNumber; i++) {
                                PresentModel *present = [PresentModel modelWithSender:giftMessage.senderUserInfo.name giftName:giftMessage.content icon:giftMessage.senderUserInfo.portraitUri giftImageName:giftMessage.gift.giftUrl];
                                    [presentArr addObject:present];
                                }
                                _presentModel = giftMessage;
                                [self.presentView insertPresentMessages:presentArr showShakeAnimation:YES];
                            }
                        }
                    }
                        break;
                    case 11:
                        [MyUtil showMessage:@"请指定礼物"];
                        break;
                    case 12:
                        [MyUtil showMessage:@"请指定对象"];
                        break;
                    case 14:
                        [MyUtil showMessage:@"娱币金额不能为空"];
                        break;
                    case 15:
                        [MyUtil showMessage:@"娱币金额不能小于1"];
                        break;
                    case 16:
                        [MyUtil showMessage:@"无此用户"];
                        break;
                    case 17:
                        [self vaconeyAmount];//娱币不足
                        break;
                    default:
                        
                        break;
                }
            }];
        } else {
            [self vaconeyAmount];//娱币不足
        }
        _giftNumber = 0;
        [self watchdashangCloseViewAction];
    }];
    
}

#pragma mark -- 娱币不足是否充值
-(void) vaconeyAmount{
    UIAlertController *alterVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"娱币不足是否充值？" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    __weak typeof (self) WeakSelf = self;
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        MineYubiViewController *minrYUbIVC  = [[MineYubiViewController alloc] init];
        [WeakSelf.navigationController pushViewController:minrYUbIVC animated:YES];
    }];
    [alterVC addAction:cancelAction];
    [alterVC addAction:sureAction];
    [self presentViewController:alterVC animated:YES completion:nil];
}

#pragma mark -- 礼物动画
-(void)showGiftIamgeAnmiationWith:(NSString *)giftImg With:(NSString *) type{
    switch (type.integerValue) {
        case 2://飞机
        {
            _animation = AnimationShowing_watch;
            _animationImageView = [[UIImageView alloc] init];
            _animationImageView.backgroundColor = [UIColor clearColor];
            [_animationImageView sd_setImageWithURL:[NSURL URLWithString:giftImg]];
            _animationImageView.frame = CGRectMake(SCREEN_WIDTH / 2 *3, 150, SCREEN_WIDTH/2, 300);
            [self.view addSubview:_animationImageView];
            [UIView animateWithDuration:3 animations:^{
                _animationImageView.frame = CGRectMake(-SCREEN_WIDTH /2, 230, SCREEN_WIDTH /2, 300);
            } completion:^(BOOL finished) {
                [_animationImageView removeFromSuperview];
                _animationImageView = nil;
                _animation = AnimationNone_watch;
            }];
        }
            break;
        case 3://跑车
        {
            _animation = AnimationShowing_watch;
            _animationImageView = [[UIImageView alloc] init];
            _animationImageView.backgroundColor = [UIColor clearColor];
            [_animationImageView sd_setImageWithURL:[NSURL URLWithString:giftImg]];
            _animationImageView.frame = CGRectMake(SCREEN_WIDTH - 30, 70, 5, 5);
            [self.view addSubview:_animationImageView];
            [UIView animateWithDuration:3 animations:^{
                _animationImageView.frame = CGRectMake(5, SCREEN_HEIGHT / 2, 220, 220);
            } completion:^(BOOL finished) {
                [_animationImageView removeFromSuperview];
                _animationImageView = nil;
                _animation = AnimationNone_watch;
            }];
        }
            break;
        case 4://游艇
        {
            _animation = AnimationShowing_watch;
            _animationImageView = [[UIImageView alloc] init];
            _animationImageView.backgroundColor = [UIColor clearColor];
            [_animationImageView sd_setImageWithURL:[NSURL URLWithString:giftImg]];
            _animationImageView.frame = CGRectMake(-SCREEN_WIDTH/2, 170, SCREEN_WIDTH/2, 300);
            [self.view addSubview:_animationImageView];
            [UIView animateWithDuration:4 animations:^{
                _animationImageView.frame = CGRectMake(SCREEN_WIDTH /2 * 3, 170, SCREEN_WIDTH/ 2, 300);
            } completion:^(BOOL finished) {
                [_animationImageView removeFromSuperview];
                _animationImageView = nil;
                _animation = AnimationNone_watch;
            }];
        }
            break;
        case 5://别墅
        {
            _animation = AnimationShowing_watch;
            
            _firework_left_ImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"left_firework"]];
            _firework_left_ImageView.backgroundColor = [UIColor clearColor];
            _firework_left_ImageView.frame = CGRectMake(100, 100, 40,130 );
            CGFloat y_left = self.view.center.y - 40;
            _firework_left_ImageView.center = CGPointMake(self.view.center.x, y_left);
            _firework_left_ImageView.alpha = 0.f;
            [self.view addSubview:_firework_left_ImageView];
            
            _firework_right_ImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right_firework"]];
            _firework_right_ImageView.backgroundColor = [UIColor clearColor];
            _firework_right_ImageView.frame = CGRectMake(100, 100, 60,200 );
            CGFloat y_right = self.view.center.y + 40;
            _firework_right_ImageView.center = CGPointMake(self.view.center.x, y_right);
            _firework_right_ImageView.alpha = 0.f;
            [self.view addSubview:_firework_right_ImageView];
            
            _firework_middle_ImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right_firework"]];
            _firework_middle_ImageView.backgroundColor = [UIColor clearColor];
            _firework_middle_ImageView.frame = CGRectMake(100, 100, 40,170 );
            _firework_middle_ImageView.center = self.view.center;
            _firework_middle_ImageView.alpha = 0.f;
            [self.view addSubview:_firework_middle_ImageView];
            
            _animationImageView = [[UIImageView alloc] init];
            _animationImageView.backgroundColor = [UIColor clearColor];
            [_animationImageView sd_setImageWithURL:[NSURL URLWithString:giftImg]];
            _animationImageView.frame = CGRectMake(100, 100, SCREEN_WIDTH / 50, SCREEN_WIDTH / 50);
            _animationImageView.center = self.view.center;
            [self.view addSubview:_animationImageView];
            [UIView animateWithDuration:10 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                _animationImageView.transform = CGAffineTransformMakeScale(45, 45);
                [UIView animateWithDuration:5 delay:5 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionCurveLinear animations:^{
                    
                    _firework_left_ImageView.alpha = 1.f;
                    _firework_left_ImageView.frame = CGRectMake(100, 100, 40,130 );
                    CGFloat x_1 = self.view.center.x - 50;
                    CGFloat y_1 = self.view.center.y - 150;
                    _firework_left_ImageView.center = CGPointMake(x_1, y_1);
                    
                    _firework_right_ImageView.alpha = 1.f;
                    _firework_right_ImageView.frame = CGRectMake(100, 100, 60,200 );
                    CGFloat x_2 = self.view.center.x + 70;
                    CGFloat y_2 = self.view.center.y - 70;
                    _firework_right_ImageView.center = CGPointMake(x_2, y_2);
                    
                    _firework_middle_ImageView.alpha = 1.f;
                    _firework_middle_ImageView.frame = CGRectMake(100, 100, 40,170 );
                    CGFloat x_3 = self.view.center.x;
                    CGFloat y_3 = self.view.center.y - 70;
                    _firework_middle_ImageView.center = CGPointMake(x_3, y_3);
                } completion:^(BOOL finished) {
                    
                }];
            } completion:^(BOOL finished) {
                [_firework_middle_ImageView removeFromSuperview];
                _firework_middle_ImageView = nil;
                [_firework_right_ImageView removeFromSuperview];
                _firework_right_ImageView = nil;
                [_firework_left_ImageView removeFromSuperview];
                _firework_left_ImageView = nil;
                [_animationImageView removeFromSuperview];
                _animationImageView = nil;
                _animation = AnimationNone_watch;
            }];
        }
            break;
        default:
        {
            
        }
            break;
    }
}


#pragma mark - PresentViewDelegate
- (PresentViewCell *)presentView:(PresentView *)presentView cellOfRow:(NSInteger)row
{
    return [[CustonCell alloc] initWithRow:row];
}

- (void)presentView:(PresentView *)presentView configCell:(PresentViewCell *)cell sender:(NSString *)sender giftName:(NSString *)name
{
    CustonCell *customCell = (CustonCell *)cell;
        PresentModel *present = [PresentModel modelWithSender:_presentModel.senderUserInfo.name giftName:_presentModel.content icon:_presentModel.senderUserInfo.portraitUri giftImageName:_presentModel.gift.giftUrl];
        customCell.model = present;
}


-(void)notice:(NSNotification *)notification{
    _giftId = notification.userInfo[@"id"];
    _giftValue = notification.userInfo[@"value"];
    _giftImg = notification.userInfo[@"image"];
    _giftName = notification.userInfo[@"giftName"];
    NSString *typeNum = notification.userInfo[@"gifType"];
    _gifType = typeNum;
//    if ([typeNum isEqualToString:@"14"]) {//跑车
//        _gifType = @"3";
//    } else if ([typeNum isEqualToString:@"15"]) {//游艇
//        _gifType = @"4";
//    } else if ([typeNum isEqualToString:@"12"]) {//私人飞机
//        _gifType = @"2";
//    } else if ([typeNum isEqualToString:@"16"])  {//别墅
//        _gifType = @"5";
//    } else {//默认类型
//        _gifType = @"1";
//    }
}

-(void)touchBackgroud{
    if (_giftNumber == 1) {
        [self sendGiftWith:1];
    }
    [self watchdashangCloseViewAction];
}

-(void)watchdashangCloseViewAction{
    _shareButton.alpha = 1.0f;
    _likeButton.alpha = 1.0f;
    _commentView.alpha = 1.0f;
    _giftButton.alpha = 1.0f;
    
    [_daShangView removeFromSuperview];
    _daShangView = nil;
    [_backgroudView removeFromSuperview];
    _backgroudView = nil;
    [_daShangTimer invalidate];
    _daShangTimer = nil;
    if (_contentView.hidden) {
        _contentView.hidden = NO;
    }
}


-(void)watchlikeButtonAction{
    NSDictionary *dic = @{@"liveChatId":_chatRoomId};
    [LYFriendsHttpTool watchLikeWithParms:dic complete:^(NSDictionary *dict) {
        
    }];
    NSInteger temp = [_likeLabel.text integerValue];
    temp +=1;
    [_likeLabel setText:[NSString stringWithFormat:@"%ld", (long)temp]];
    LYGiftMessage *giftMessage = [[LYGiftMessage alloc]init];
    giftMessage.type = @"2";
    giftMessage.content = @"给你点赞";
    [self sendMessage:giftMessage pushContent:@""];
}


#pragma mark -- 分享
-(void)liveShareButtonAction{
    NSString *roomid = _chatRoomId == nil ? _playbackRoomId : _chatRoomId;
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = [NSString stringWithFormat:@"%@%@%@",LY_SERVER,LY_LIVE_share,roomid];
    [UMSocialData defaultData].extConfig.wechatSessionData.url = [NSString stringWithFormat:@"%@%@%@",LY_SERVER,LY_LIVE_share,roomid];
    [UMSocialData defaultData].extConfig.qqData.url = [NSString stringWithFormat:@"%@%@%@",LY_SERVER,LY_LIVE_share,roomid];
    [UMSocialSnsService presentSnsIconSheetView:self appKey:UmengAppkey shareText:_shareText shareImage:_shareIamge shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina,UMShareToSms,nil] delegate:self];
}

- (void)didSelectSocialPlatform:(NSString *)platformName withSocialData:(UMSocialData *)socialData{
    if (platformName == UMShareToSina || platformName == UMShareToSms) {
        socialData.shareText = [NSString stringWithFormat:@"【前方高能，直播来袭】%@正在赤裸裸地直播~%@%@%@",_hostUser[@"usernick"],LY_SERVER,LY_LIVE_share,self.chatRoomId];
    }
}

#pragma mark --- 初始化播放器
-(void) initPLplayer{
    
//    PLPlayerOption *option = [PLPlayerOption defaultOption];
//    [option setOptionValue:@15 forKey:PLPlayerOptionKeyTimeoutIntervalForMediaPackets];
//    NSURL *url = [NSURL URLWithString:_contentURL];
//    self.player = [PLPlayer playerWithURL:url option:option];
//    self.player.delegate = self;
//    [self.view addSubview:self.player.playerView];
//    [self.view sendSubviewToBack:self.player.playerView];
//    [self.player play];
    
    self.player = [[WatchPlayerClient sharedPlayerClient] playWithUrl:_contentURL];
    self.player.delegate = self;
    [self.view addSubview:self.player.playerView];
    [self.view sendSubviewToBack:self.player.playerView];
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
}

#pragma mark ---- 开始直播时才能添加进度条
-(void) setProgressSlider{
    _slider = [[UISlider alloc] initWithFrame:(CGRectMake(SCREEN_WIDTH / 6, distanceOfBottom - SCREEN_WIDTH / 8, SCREEN_WIDTH / 3 * 2 , 40))];
    _slider.value = 0;
    CMTime time = _player.totalDuration;
    float seconds = CMTimeGetSeconds(time);
    _slider.maximumValue = seconds;
    _slider.minimumTrackTintColor = COMMON_PURPLE;
    _slider.maximumTrackTintColor = [UIColor whiteColor];
    _slider.thumbTintColor = COMMON_PURPLE;
    [_slider addTarget:self action:@selector(playProgressChangeAction:) forControlEvents:(UIControlEventValueChanged)];
    [self.view addSubview:_slider];
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
    [_timer fire];
}

-(void)playProgressChangeAction:(UISlider *) sender{
    CMTime temp1 = CMTimeMakeWithSeconds(sender.value, _player.totalDuration.timescale);
    [_player seekTo:temp1];
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
            if (_isfirstPlay) {
                [self setProgressSlider];
                _isfirstPlay = NO;
            }
            NSLog(@"4");
            break;
        case PLPlayerStatusPaused:
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
    if (_chatRoomId == nil) {
        
    }
    NSDictionary *watchDict = @{@"liveChatId":_chatRoomId};
    [LYFriendsHttpTool getLiveStatusWithParms:watchDict complete:^(NSDictionary *dict) {
        NSInteger num = [NSString stringWithFormat:@"%@",dict[@"livestatus"]].integerValue;
        switch (num) {
            case 200:
            {
                if (_isLiveing == LiveStatePause && pauseLable) {
                    self.player = [[WatchPlayerClient sharedPlayerClient] playWithUrl:_contentURL];
                    [pauseLable removeFromSuperview];
                    pauseLable = nil;
                }
            }
                break;
            case 800:
            {
                if (!pauseLable) {
                    pauseLable = [[UILabel alloc] init];
                    pauseLable.size = CGSizeMake(230, 30);
                    pauseLable.center = CGPointMake(SCREEN_WIDTH / 2, self.view.center.y);
                    pauseLable.backgroundColor = [UIColor blackColor];
                    pauseLable.text = @"主播离开，直播暂停中...";
                    pauseLable.textAlignment =  NSTextAlignmentCenter;
                    pauseLable.textColor = [UIColor whiteColor];
                    [self.view addSubview:pauseLable];
                    [self.view bringSubviewToFront:pauseLable];
                }
            }
                break;
            default:
            {
                if (![_contentURL isEqual: [NSNull null]] || _contentURL != nil) {
                    [MyUtil showPlaceMessage:@"直播结束！"];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
                break;
        }
    }];

//    switch (_isLiveing) {
//        case LiveStateLiveing:
//        {
//            if (![_contentURL isEqual: [NSNull null]] || _contentURL != nil) {
//                [MyUtil showMessage:@"链接失败！"];
//                [self.navigationController popViewControllerAnimated:YES];
//            }
//        }
//            break;
//        case LiveStatePause:
//        {
//            if (!pauseLable) {
//                pauseLable = [[UILabel alloc] init];
//                pauseLable.size = CGSizeMake(230, 30);
//                pauseLable.center = CGPointMake(SCREEN_WIDTH / 2, self.view.center.y);
//                pauseLable.backgroundColor = [UIColor blackColor];
//                pauseLable.text = @"主播离开，直播暂停中...";
//                pauseLable.textAlignment =  NSTextAlignmentCenter;
//                pauseLable.textColor = [UIColor whiteColor];
//                [self.view addSubview:pauseLable];
//                [self.view bringSubviewToFront:pauseLable];
//            }
//        }
//            break;
//        case LiveStateUnkown:
//        {
//            [[WatchPlayerClient sharedPlayerClient] stopPlayWithUrl:_contentURL];
//            [MyUtil showMessage:@"直播结束"];
//            [self.navigationController popViewControllerAnimated:YES];
//        }
//            break;
//        
//        default:
//            break;
//    }
//    if (_isLiveing) {//有直播但是获取失败
//        if (![_contentURL isEqual: [NSNull null]] || _contentURL != nil) {
//            [MyUtil showMessage:@"链接失败！"];
//            [self.navigationController popViewControllerAnimated:YES];
//        }
//    } else {
//        [[WatchPlayerClient sharedPlayerClient] stopPlayWithUrl:_contentURL];
//        [MyUtil showMessage:@"直播结束"];
//        [self.navigationController popViewControllerAnimated:YES];
//    }
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
    _closeView.chatRoomID = _playbackRoomId;
    _closeView.shareText = _shareText;
    _closeView.shareName = _hostUser[@"usernick"];
    [_closeView.backButton addTarget:self action:@selector(closebackButtonAction) forControlEvents:(UIControlEventTouchUpInside)];
    [_closeView.focusButton addTarget:self action:@selector(closeFocusButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
}

-(void)closebackButtonAction{
//    [self.player stop];//关闭播放器
    [[WatchPlayerClient sharedPlayerClient] stopPlayWithUrl:_contentURL];
    [self quitChatroom];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)closeFocusButtonAction:(UIButton *)sender{
    NSInteger userid = [_hostUser[@"id"] integerValue];
    NSDictionary *dict = @{@"followid":[NSString stringWithFormat:@"%ld",(long)userid]};
    [LYFriendsHttpTool followFriendWithParms:dict complete:^(NSDictionary *dict) {
        [sender setTitle:@"已关注" forState:(UIControlStateNormal)];
        sender.userInteractionEnabled = NO;
       
    }];
//    [self.player stop];//关闭播放器
    [[WatchPlayerClient sharedPlayerClient] stopPlayWithUrl:_contentURL];

    [self quitChatroom];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- 关注
-(void)foucsButtonAction: (UIButton *) sender {
    NSInteger userid = [_hostUser[@"id"] integerValue];
    NSDictionary *dict = @{@"followid":[NSString stringWithFormat:@"%ld",(long)userid]};
//    if (sender.tag == 1) {//不能取消关注
//        [LYFriendsHttpTool unFollowFriendWithParms:dict complete:^(NSDictionary *dict) {
//            sender.titleLabel.text = @"关注";
//        }];
//    } else {
        [LYFriendsHttpTool followFriendWithParms:dict complete:^(NSDictionary *dict) {
            [sender setTitle:@"已关注" forState:(UIControlStateNormal)];
            sender.userInteractionEnabled = NO;
        }];
//    }
}

#pragma mark -- 点击主播头像事件
-(void)anchorDetail{
    if (_anchorDetailView.hidden == NO) {
        [_anchorDetailView removeFromSuperview];
        _anchorDetailView = nil;
    }
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
    [_anchorDetailView.anchorIcon sd_setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:[UIImage imageNamed:@"lieyu_default_head"]];
    if ([_hostUser[@"gender"] isEqualToString:@"0"]) {
        _anchorDetailView.genderIamge.image=[UIImage imageNamed:@"woman"];
    }else{
        _anchorDetailView.genderIamge.image=[UIImage imageNamed:@"manIcon"];
    }
    [self.view addSubview:_anchorDetailView];
    [self.view bringSubviewToFront:_anchorDetailView];
    
    UIButton *jubaoButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    jubaoButton.frame = CGRectMake(20, 15, 40, 23);
    [jubaoButton setTitle:@"举报" forState:(UIControlStateNormal)];
    [jubaoButton setTitleColor:COMMON_PURPLE forState:(UIControlStateNormal)];
    [jubaoButton addTarget:self action:@selector(jubaoButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [_anchorDetailView addSubview:jubaoButton];
    
    _anchorDetailView.starlabel.hidden = YES;
    _anchorDetailView.tagLabel.hidden = YES;
    
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
    _anchorDetailView.focusButton.tag = [self.hostUser[@"id"] integerValue];
    [_anchorDetailView.mainViewButton addTarget:self action:@selector(mainViewButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    _anchorDetailView.mainViewButton.tag = [self.hostUser[@"id"] integerValue];
}

//点击聊天室的观众
-(void)showWatchDetailWith:(ChatUseres *) chatuser{
    _anchorDetailView = [[[NSBundle mainBundle] loadNibNamed:@"AnchorDetailView" owner:self options:nil] lastObject];
    _anchorDetailView.frame = CGRectMake(0, 0, 260,210);
    _anchorDetailView.center = self.view.center;
    _anchorDetailView.layer.cornerRadius = 8.f;
    _anchorDetailView.layer.masksToBounds = YES;
    _anchorDetailView.backgroundColor = [UIColor whiteColor];
    _anchorDetailView.nickNameLabel.text = chatuser.usernick;
    NSString *imgStr = chatuser.avatar_img;
    if (imgStr.length < 50) {
        imgStr = [MyUtil getQiniuUrl:chatuser.avatar_img width:0 andHeight:0];
    }
    [_anchorDetailView.anchorIcon sd_setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:[UIImage imageNamed:@"lieyu_default_head"]];
    if (chatuser.gender == 0) {
        _anchorDetailView.genderIamge.image = [UIImage imageNamed:@"woman"];
    }else{
        _anchorDetailView.genderIamge.image = [UIImage imageNamed:@"manIcon"];
    }
    
    NSString *astro = [MyUtil getAstroWithBirthday:chatuser.birthday];
    [_anchorDetailView.starlabel setText:astro];
    
    NSString *tagText = chatuser.tag;
    if ([tagText isEqualToString:@""]) {
        tagText = @"其他";
    }
    [_anchorDetailView.tagLabel setText:tagText];
    
    
    [self.view addSubview:_anchorDetailView];
    [self.view bringSubviewToFront:_anchorDetailView];
    
//    NSInteger status = [_hostUser[@"friendStatus"] integerValue];
//    if (status == 2 || status == 0) {//0 没有关系   1 关注   2 粉丝   3 好友
//        _anchorDetailView.focusButton.tag = 2;
//        [_anchorDetailView.focusButton setTitle:@"关注" forState:(UIControlStateNormal)];
//    } else if (status == 1 || status == 3) {
//        _anchorDetailView.focusButton.tag = 1;
//        [_anchorDetailView.focusButton setTitle:@"已关注" forState:(UIControlStateNormal)];
//        _anchorDetailView.focusButton.userInteractionEnabled = NO;
//    }
    [_anchorDetailView.focusButton addTarget:self action:@selector(anchorFocusButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    _anchorDetailView.focusButton.tag = chatuser.id;
    [_anchorDetailView.mainViewButton addTarget:self action:@selector(mainViewButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    _anchorDetailView.mainViewButton.tag = chatuser.id;
}

-(void)anchorFocusButtonAction:(UIButton *) sender{
    NSDictionary *dict = @{@"followid":[NSString stringWithFormat:@"%ld",(long)sender.tag]};
    if (sender.tag == 1) {//不能取消关注
        [LYFriendsHttpTool unFollowFriendWithParms:dict complete:^(NSDictionary *dict) {
            [sender setTitle:@"关注" forState:(UIControlStateNormal)];
        }];
    } else {
        [LYFriendsHttpTool followFriendWithParms:dict complete:^(NSDictionary *dict) {
            [sender setTitle:@"已关注" forState:(UIControlStateNormal)];
            sender.userInteractionEnabled = NO;
            [_userView.isFoucsButton setTitle:@"已关注" forState:(UIControlStateNormal)];
            _userView.isFoucsButton.userInteractionEnabled = NO;
        }];
    }
}

-(void)jubaoButtonAction:(UIButton *)sender{
     UIActionSheet *reportAction = [[UIActionSheet alloc]initWithTitle:@"选择举报原因" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"污秽色情",@"垃圾广告",@"其他原因", nil];
    [reportAction showInView:_anchorDetailView];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *message;
    if (buttonIndex == 0) {
        message = @"污秽色情";
    }else if (buttonIndex == 1){
        message = @"垃圾广告";
    }else if (buttonIndex == 2){
        message = @"其他原因";
    }
    if (buttonIndex != 3) {
        UserModel *userModel = ((AppDelegate *)[UIApplication sharedApplication].delegate).userModel;
        NSDictionary *dict = @{
                               @"reportedUserid":self.hostUser[@"userid"],
                               @"momentId":@"13648257340",
                               @"message":message,
                               @"userid":[NSNumber numberWithInt:userModel.userid]};
        [LYFriendsHttpTool friendsJuBaoWithParams:dict complete:^(NSString *message) {
            [MyUtil showPlaceMessage:@"举报成功"];
        }];
    }
}

-(void)mainViewButtonAction:(UIButton *) sender{
    LYMyFriendDetailViewController *myFriendVC = [[LYMyFriendDetailViewController  alloc] init];
    myFriendVC.userID = [NSString stringWithFormat:@"%ld", (long)sender.tag];
    [self.navigationController pushViewController:myFriendVC animated:YES];
//    [self quitChatroom];
}

#pragma mark -- UICollectionViewDataSource

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
            user = _dataArray[indexPath.item];
            NSString *imgStr = user.avatar_img;
            if (imgStr.length < 50) {
                imgStr = [MyUtil getQiniuUrl:user.avatar_img width:0 andHeight:0];
            }
        cell.imageUrl = imgStr;
        [cell.detailButton addTarget:self action:@selector(detailViewShow:) forControlEvents:(UIControlEventTouchUpInside)];
        cell.detailButton.tag = indexPath.item;
        return cell;
    } else {
        RCMessageModel *model =
        [self.conversationDataRepository objectAtIndex:indexPath.row];
        RCMessageContent *messageContent = model.content;
        RCMessageBaseCell *cell = nil;
        if ([messageContent isMemberOfClass:[RCTextMessage class]]) {
            LYTextMessageCell *__cell = [collectionView dequeueReusableCellWithReuseIdentifier:rctextCellIndentifier forIndexPath:indexPath];
            [__cell setDataModel:model];
            [__cell setDelegate:self];
            cell = __cell;
        } else if ([messageContent isMemberOfClass:[RCInformationNotificationMessage class]]){
            LYTipMessageCell *__cell = [collectionView dequeueReusableCellWithReuseIdentifier:rcTipMessageCellIndentifier forIndexPath:indexPath];
            [__cell setDataModel:model];
            [__cell setDelegate:self];
            cell = __cell;
        }
        else if ([messageContent isMemberOfClass:[LYGiftMessage class]]){
            LYGiftMessageCell *__cell = [collectionView dequeueReusableCellWithReuseIdentifier:rcGiftMessageCellIndentifier forIndexPath:indexPath];
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
    CGPoint fountainSource = CGPointMake(SCREEN_WIDTH - 20 - _heartSize/2.0, SCREEN_HEIGHT - SCREEN_WIDTH / 4 - 35 );
    heart.center = fountainSource;
    [heart animateInView:self.view];
}

#pragma mark -- 点击聊天室成员
-(void)detailViewShow:(UIButton *)sender{
    ChatUseres *user = _dataArray[sender.tag];
    NSDictionary *dictID = @{@"userid":[NSString stringWithFormat:@"%ld",(long)user.id]};
    __weak typeof(self) weakSlef = self;
    [LYUserHttpTool GetUserInfomationWithID:dictID complete:^(find_userInfoModel *model) {
        user.gender = model.gender;
        user.birthday = model.birthday;
        NSDictionary *tempDic = [model.tags lastObject];
        user.tag = [NSString stringWithFormat:@"%@",tempDic[@"tagname"]];
        if (_anchorDetailView.hidden == NO) {
            [_anchorDetailView removeFromSuperview];
            _anchorDetailView = nil;
        }
        [weakSlef showWatchDetailWith:user];
    }];
}

/* 定义每个UICollectionView 的大小 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag == 188) {
        CGFloat width = 39;
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
        NSString *userName = nil;
        if (_textMessage.senderUserInfo) {
            userName = _textMessage.senderUserInfo.name;
        } else {
            userName = @"神秘人";
        }
        NSMutableString *text = [NSMutableString stringWithFormat:@"%@：%@",userName, _textMessage.content];
        CGSize _textMessageSize = [LYTextMessageCell getMessageCellSize:text withWidth:__width];
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
        __height = _textMessageSize.height + 1;
    }
    return CGSizeMake(__width, __height);
}

/* 定义每个UICollectionView 的边缘 */
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (collectionView.tag == 188) {
        return UIEdgeInsetsMake(0, 1, 0, 1);//上 左 下 右
    }else{
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
}

#pragma mark --- UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView.tag == 188) {
//        ChatUseres *user = _dataArray[indexPath.row];
//        [self showWatchDetailWith:user];
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
    user.portraitUri = app.userModel.avatar_img;
    [RCIM sharedRCIM].currentUserInfo = user;
    //初始化UI
    [self initializedSubViews];
    __weak WatchLiveShowViewController *weakSelf = self;
    self.isFullScreen = YES;
    self.conversationType = ConversationType_CHATROOM;
    //设置免打扰模式
    [[RCIMClient sharedRCIMClient] setConversationNotificationStatus:self.conversationType targetId:self.chatRoomId isBlocked:YES success:^(RCConversationNotificationStatus nStatus) {
    } error:^(RCErrorCode status) {
    }];
    //聊天室类型进入时需要调用加入聊天室接口，退出时需要调用退出聊天室接口
    if (ConversationType_CHATROOM == self.conversationType) {
        [[RCIMClient sharedRCIMClient]
         joinChatRoom:_chatRoomId
         messageCount:-1
         success:^{
             dispatch_async(dispatch_get_main_queue(), ^{
                 RCInformationNotificationMessage *joinChatroomMessage = [[RCInformationNotificationMessage alloc]init];
                 joinChatroomMessage.message = [NSString stringWithFormat: @"进入直播室"];
                 LYStystemMessage *lyStystem = [[LYStystemMessage alloc] init];
                 RCMessage *message = [[RCMessage alloc] initWithType:weakSelf.conversationType
                                                             targetId:weakSelf.chatRoomId
                                                            direction:MessageDirection_SEND
                                                            messageId:-1
                                                              content:lyStystem];
                 [weakSelf appendAndDisplayMessage:message];
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
                         if (!app.im_token) {
                             [MyUtil gotoLogin];
                         } else {
                             [MyUtil showCleanMessage:@"聊天会话错误!"];
                         }
                     });
                 }
             });
         }];
    }
}
//退出聊天室
-(void)quitChatroom{
    [[RCIMClient sharedRCIMClient] quitChatRoom:_chatRoomId success:^{
        NSLog(@"我退出了聊天室");
    } error:^(RCErrorCode status) {
        
    }];
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
    if (![textField.text isEqualToString:@""]) {
        NSString *text = [NSString stringWithFormat:@"%@", _commentView.textField.text];
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
    if ([rcMessage.objectName isEqualToString:@"LY:StystemMsg"]) {//收到的是系统消息直接忽略
        return;
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
            LYGiftMessage *giftMessage =(LYGiftMessage *) model.content;
            if ([giftMessage.type isEqualToString:@"2"]) {//点赞
                [self showTheLove];//接受到消息
            } else {// 礼物
                NSInteger numbertype = [giftMessage.gift.giftAnnimType integerValue];
                if (2 <= numbertype && numbertype <= 5) {
                    DaShangGiftModel *model = [[DaShangGiftModel alloc] modelWithrewardName:nil rewardImg:giftMessage.gift.giftUrl rewardValue:0 rewardType:giftMessage.gift.giftAnnimType];
                    [self.presentDataArray addObject:model];
                } else {
                    NSMutableArray *presentArr = [NSMutableArray array];
                    NSInteger number = [giftMessage.gift.giftNumber integerValue];
                    for (int i = 0; i < number; i++) {
                        PresentModel *present = [PresentModel modelWithSender:giftMessage.senderUserInfo.name giftName:giftMessage.content icon:giftMessage.senderUserInfo.portraitUri giftImageName:giftMessage.gift.giftUrl];
                        [presentArr addObject:present];
                    }
                    _presentModel = giftMessage;
                    [self.presentView insertPresentMessages:presentArr showShakeAnimation:YES];
                }
//                [self showGiftIamgeAnmiationWith:giftMessage.gift.giftUrl With:giftMessage.gift.giftAnnimType];
            }
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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"sendGift" object:nil];
}

- (void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status {
    self.currentConnectionStatus = status;
}

@end
