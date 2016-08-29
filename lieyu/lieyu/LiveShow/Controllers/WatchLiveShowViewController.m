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
#import <asl.h>
#import "UMSocial.h"

#import "RegisterLiveShowView.h"
#import "CloseLiveShowView.h"
#import "AnchorDetailView.h"
#import "UserHeader.h"
#import "LiveSetView.h"
#import "LiveShowEndView.h"

#import "LYFriendsHttpTool.h"
#import "LYYUHttpTool.h"
#import "LYMyFriendDetailViewController.h"

#import "LYMessageCell.h"
#import "LYTextMessageCell.h"
#import "LYGiftMessageCell.h"
#import "LYGiftMessage.h"
#import "LYTipMessageCell.h"
#import "RCMessageModel.h"
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

@interface WatchLiveShowViewController () <PLPlayerDelegate,UICollectionViewDataSource, UICollectionViewDelegate ,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) PLPlayer  *player;

//上方主播View
@property (nonatomic, strong) UserHeader *userView;
@property (nonatomic, strong) UIImageView *userIcon;
@property (nonatomic, strong) UILabel *userNickname;
@property (nonatomic, strong) UILabel *unKnowNumber;
@property (nonatomic, strong) UIButton *isFoucsButton;


//注册/退出/详情/设置View
@property (nonatomic, strong) RegisterLiveShowView *registerView;
@property (nonatomic, strong) LiveShowEndView *closeView;
@property (nonatomic, strong) AnchorDetailView *anchorDetailView;

//退出
@property (nonatomic, strong) UIButton *backButton;

//观众列表
@property (nonatomic, strong) UICollectionView *audienceCollectionView;

/** 直播开始前的占位图片 */
@property(nonatomic, weak) UIImageView *placeHolderView;
/** 粒子动画 */
@property(nonatomic, weak) CAEmitterLayer *emitterLayer;

@property(nonatomic, strong) NSArray *_dataArray;//聊天室

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
#define _CELL @ "acell"
@implementation WatchLiveShowViewController


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.emitterLayer setHidden:NO];
    [self initPLplayer];
    [self initUI];
    [self joinChatRoom];
}

#pragma mark --- 初始化页面
-(void)initUI {
    //粒子动画
    _CAEmitterView = [[UIView alloc] initWithFrame:self.view.bounds];
    _CAEmitterView.backgroundColor = [UIColor clearColor];
    [_player.playerView addSubview:_CAEmitterView];
    
    //返回按钮
    _backButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    _backButton.frame = CGRectMake(SCREEN_WIDTH - (SCREEN_WIDTH / 7) - 10, 30, SCREEN_WIDTH / 7, SCREEN_HEIGHT / 12);
    [_backButton setImage:[UIImage imageNamed:@"live_close.png"] forState:(UIControlStateNormal)];
    [_backButton addTarget:self action:@selector(watchBackButtonAction) forControlEvents:(UIControlEventTouchUpInside)];
    [_CAEmitterView addSubview:_backButton];
    
    //顶部用户信息
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"UserHeader" owner:self options:nil];
    //得到第一个UIView
    _userView = [nib objectAtIndex:0];
    _userView.frame = CGRectMake(20, 30, SCREEN_WIDTH / 2, SCREEN_HEIGHT / 15);
    _userView.layer.cornerRadius = SCREEN_HEIGHT / 30;
    _userView.layer.masksToBounds = YES;
    _userView.backgroundColor = RGBA(33, 33, 33, 0.5);
    _userView.iconIamgeView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",_hostUser[@"avatar_img"]]];
    //    _userView.userNameLabel.text = @"";
    _userView.numberLabel.text = [NSString stringWithFormat:@"%@", _hostUser[@"usernick"]];
    _userView.iconIamgeView.layer.cornerRadius = _userView.iconIamgeView.frame.size.height/2;
    _userView.iconIamgeView.layer.masksToBounds = YES;
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(anchorDetail)];
    [_userView addGestureRecognizer:tapGes];
    
  
    [_userView.isFoucsButton addTarget:self action:@selector(foucsButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [_CAEmitterView addSubview:_userView];
    
    //观众列表
    UICollectionViewFlowLayout *layout=[[ UICollectionViewFlowLayout alloc ] init ];
    [layout setScrollDirection:(UICollectionViewScrollDirectionHorizontal)];
    _audienceCollectionView = [[ UICollectionView alloc ] initWithFrame : CGRectMake(10, SCREEN_HEIGHT / 12 + 30 +10, SCREEN_WIDTH - 20, SCREEN_HEIGHT / 13) collectionViewLayout :layout];
    [_audienceCollectionView registerClass :[ UICollectionViewCell class ] forCellWithReuseIdentifier : _CELL ];
    _audienceCollectionView.showsHorizontalScrollIndicator = NO;
    _audienceCollectionView. backgroundColor =[ UIColor clearColor];
    _audienceCollectionView. delegate = self ;
    _audienceCollectionView. dataSource = self ;
    _audienceCollectionView.tag = 188;
    [_CAEmitterView addSubview:_audienceCollectionView];
    
    //礼物按钮
    UIButton *giftButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    giftButton.frame = CGRectMake(15, distanceOfBottom - SCREEN_WIDTH / 8, SCREEN_WIDTH / 8 , SCREEN_WIDTH / 8);
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

    UIButton *shareButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    shareButton.size = CGSizeMake(MinHeight_InputView, MinHeight_InputView);
    shareButton.center = CGPointMake(self.view.frame.size.width - SCREEN_WIDTH / 10,distanceOfBottom - MinHeight_InputView / 2);
    [shareButton setImage:[UIImage imageNamed:@"live_watchShare.png"] forState:(UIControlStateNormal)];
    [shareButton addTarget:self action:@selector(liveShareButtonAction) forControlEvents:(UIControlEventTouchUpInside)];
    _shareButton = shareButton;
    [self.view addSubview:_shareButton];
}

#pragma mark --- 礼物、点赞等事件
-(void) giftButtonAction{
    
}

-(void)watchlikeButtonAction{
    NSDictionary *dic = @{@"liveChatId":_chatRoomId};
    [LYFriendsHttpTool watchLikeWithParms:dic complete:^(NSDictionary *dict) {
        
    }];
    [_CAEmitterView.layer addSublayer:self.emitterLayer];
    
    LYGiftMessage *giftMessage = [[LYGiftMessage alloc]init];
    giftMessage.type = @"0";
    [self sendMessage:giftMessage pushContent:@""];
}

-(void)liveShareButtonAction{
    NSString *string= [NSString stringWithFormat:@"下载猎娱App猎寻更多特色酒吧。http://10.17.30.44:8080/liveroom/live?liveChatId=%@",self.chatRoomId];
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = [NSString stringWithFormat:@"http://10.17.30.44:8080/liveroom/live?liveChatId=%@",self.chatRoomId];
    [UMSocialData defaultData].extConfig.wechatSessionData.url = [NSString stringWithFormat:@"http://10.17.30.44:8080/liveroom/live?liveChatId=%@",self.chatRoomId];
    [UMSocialData defaultData].extConfig.qqData.url = [NSString stringWithFormat:@"http://10.17.30.44:8080/liveroom/live?liveChatId=%@",self.chatRoomId];
    [UMSocialSnsService presentSnsIconSheetView:self appKey:UmengAppkey shareText:string shareImage:nil shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina,UMShareToQQ,nil] delegate:nil];
}

- (CAEmitterLayer *)emitterLayer
{
    if (!_emitterLayer) {
        CAEmitterLayer *emitterLayer = [CAEmitterLayer layer];
        // 发射器在xy平面的中心位置
        emitterLayer.emitterPosition = CGPointMake(self.view.frame.size.width-50,self.view.frame.size.height-50);
        // 发射器的尺寸大小
        emitterLayer.emitterSize = CGSizeMake(20, 20);
        // 渲染模式
        emitterLayer.renderMode = kCAEmitterLayerUnordered;
        // 开启三维效果
        //    _emitterLayer.preservesDepth = YES;
        NSMutableArray *array = [NSMutableArray array];
        // 创建粒子
            // 发射单元
            CAEmitterCell *stepCell = [CAEmitterCell emitterCell];
            // 粒子的创建速率，默认为1/s
            stepCell.birthRate = 1;
            // 粒子存活时间
            stepCell.lifetime = arc4random_uniform(4) + 1;
            // 粒子的生存时间容差
            stepCell.lifetimeRange = 1.5;
            // 颜色
            // fire.color=[[UIColor colorWithRed:0.8 green:0.4 blue:0.2 alpha:0.1]CGColor];
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"paopao"]];
            // 粒子显示的内容
            stepCell.contents = (id)[image CGImage];
            // 粒子的名字
            //            [fire setName:@"step%d", i];
            // 粒子的运动速度
            stepCell.velocity = arc4random_uniform(100) + 100;
            // 粒子速度的容差
            stepCell.velocityRange = 80;
            // 粒子在xy平面的发射角度
            stepCell.emissionLongitude = M_PI+M_PI_2;;
            // 粒子发射角度的容差
            stepCell.emissionRange = M_PI_2/6;
            // 缩放比例
            stepCell.scale = 0.3;
            [array addObject:stepCell];
        
        emitterLayer.emitterCells = array;
        [self.player.playerView.layer addSublayer:emitterLayer];
        _emitterLayer = emitterLayer;
    }
    return _emitterLayer;
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
//    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    switch (state) {
        case PLPlayerStatusUnknow:
            NSLog(@"0");
            break;
        case PLPlayerStatusPreparing:
            NSLog(@"1");
//            [app startLoading];
            break;
        case PLPlayerStatusReady:
            NSLog(@"2");
            break;
        case PLPlayerStatusCaching:
            NSLog(@"3");
            break;
        case PLPlayerStatusPlaying:
            NSLog(@"4");
//            [app stopLoading];
            break;
        case PLPlayerStatusPaused:
            NSLog(@"5");
            break;
        case PLPlayerStatusStopped:
            NSLog(@"6");
            break;
        case PLPlayerStatusError:
            NSLog(@"7");
            break;
        case PLPlayerStateAutoReconnecting:
            NSLog(@"8");
            break;
        default:
            break;
    }
    
}

- (void)player:(nonnull PLPlayer *)player stoppedWithError:(nullable NSError *)error{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app stopLoading];
    NSLog(@"%@", [error localizedDescription]);
    [self dismissViewControllerAnimated:YES completion:NULL];
}


#pragma mark -- 返回（结束播放）
-(void)watchBackButtonAction{
    
    _closeView = [[[NSBundle mainBundle] loadNibNamed:@"LiveShowEndView" owner:self options:nil] lastObject];
    _closeView.frame = self.view.bounds;
    _closeView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_closeView];
    [self.view bringSubviewToFront:_closeView];
    [_closeView.backButton addTarget:self action:@selector(closebackButtonAction) forControlEvents:(UIControlEventTouchUpInside)];
    [_closeView.focusButton addTarget:self action:@selector(closeFocusButtonAction) forControlEvents:(UIControlEventTouchUpInside)];
    
}

-(void)closebackButtonAction{
    [self dismissViewControllerAnimated:YES completion:NULL];
    [self.player stop];
}

-(void)closeFocusButtonAction{
    
}

#pragma mark -- 关注
-(void)foucsButtonAction: (UIButton *) sender{
    NSLog(@"我关注了");
}

#pragma mark -- 点击头像事件
-(void)anchorDetail{
    AnchorDetailView *anchorView = [[AnchorDetailView alloc] init];
    anchorView.frame = self.view.bounds;
}

#pragma mark --UICollectionViewDataSource

//定义展示的UICollectionViewCell的个数

-( NSInteger )collectionView:( UICollectionView *)collectionView numberOfItemsInSection:( NSInteger )section
{
    if (collectionView.tag == 188) {//观众列表
        return 31;
    }else {//信息
        return self.conversationDataRepository.count;
    }
    return 31 ;
}
//定义展示的Section的个数
-( NSInteger )numberOfSectionsInCollectionView:( UICollectionView *)collectionView
{
    return 1 ;
}
//每个UICollectionView展示的内容
-( UICollectionViewCell *)collectionView:( UICollectionView *)collectionView cellForItemAtIndexPath:( NSIndexPath *)indexPath
{
    if (collectionView.tag == 188) {
        UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier : _CELL forIndexPath :indexPath];
        cell.backgroundColor = [ UIColor colorWithRed :(( arc4random ()% 255 )/ 255.0 ) green :(( arc4random ()% 255 )/ 255.0 ) blue :(( arc4random ()% 255 )/ 255.0 ) alpha : 1.0f ];
        
        cell.layer.borderColor = RGB(187, 47, 217).CGColor;
        cell.layer.borderWidth = 2.f;
        cell.layer.cornerRadius = cell.frame.size.height /2;
        cell.layer.masksToBounds = YES;
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
        return cell;
    }

}
/* 定义每个UICollectionView 的大小 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag == 188) {
        CGFloat width = SCREEN_WIDTH / 8;
        return CGSizeMake(width, width);
    } else {
        RCMessageModel *model =
        [self.conversationDataRepository objectAtIndex:indexPath.row];
        if (model.cellSize.height > 0) {
            return model.cellSize;
        }
        RCMessageContent *messageContent = model.content;
        if ([messageContent isMemberOfClass:[RCTextMessage class]] || [messageContent isMemberOfClass:[RCInformationNotificationMessage class]] || [messageContent isMemberOfClass:[LYGiftMessage class]]) {
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
                }else{
                    txt = [NSString stringWithFormat:@"%@送出一个",likeMessage.senderUserInfo.name];
                }
            }else{
                txt = @"神秘人送出一个";
            }
        }
        CGSize _textMessageSize = [LYGiftMessageCell getMessageCellSize:txt withWidth:__width];
        __height = _textMessageSize.height ;
    }
    return CGSizeMake(__width, __height);
}



/* 定义每个UICollectionView 的边缘 */
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (collectionView.tag == 199) {
        return UIEdgeInsetsMake(15, 5, 15, 5);//上 左 下 右
    }else{
        return UIEdgeInsetsMake(5, 5, 5, 5);
    }
}

#pragma mark --- UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld",indexPath.row);
    //    LYMyFriendDetailViewController *LYMyFriendDetailVC = [[LYMyFriendDetailViewController alloc] init];
    //    LYMyFriendDetailVC.type = @"4";
    //    LYMyFriendDetailVC.imUserId = @"";
    //    [self.navigationController pushViewController:LYMyFriendDetailVC animated:NO];
}

#pragma mark --- 获取聊天室成员
-(void)getChatRoomPeople:(NSString *) chatRoomID{
    NSDictionary *dict = @{@"id":chatRoomID};
    [LYYUHttpTool yuGetChatRoomAllStaffWith:dict complete:^(NSArray *dataArray) {
        __dataArray = dataArray;
        [_audienceCollectionView reloadData];
    }];
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
    user.name = app.userModel.username;
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
                 joinChatroomMessage.message = [NSString stringWithFormat: @"%@加入了聊天室",[RCIM sharedRCIM].currentUserInfo.name];
                 [weakSelf sendMessage:joinChatroomMessage pushContent:nil];
             });
         }
         error:^(RCErrorCode status) {
             dispatch_async(dispatch_get_main_queue(), ^{
                 if (status == KICKED_FROM_CHATROOM) {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [MyUtil showCleanMessage:@"已被踢出聊天室"];
                     });
                 }else if(status == RC_CHATROOM_NOT_EXIST){
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [MyUtil showCleanMessage:@"聊天室不存在！"];
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
        CGRect contentViewFrame = CGRectMake(0, SCREEN_HEIGHT / 8 *3,SCREEN_WIDTH - SCREEN_WIDTH / 8 , distanceOfBottom - SCREEN_HEIGHT /8 * 3 - SCREEN_WIDTH / 8);
        self.contentView.backgroundColor = RGBCOLOR(235, 235, 235);
        self.contentView = [[UIView alloc]initWithFrame:contentViewFrame];
        [self.view addSubview:self.contentView];
    }
    //聊天消息区
    UICollectionViewFlowLayout *customFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    customFlowLayout.minimumLineSpacing = 20;
    customFlowLayout.sectionInset = UIEdgeInsetsMake(10.0f, 0.0f, 10.0f, 0.0f);
    customFlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    CGRect _conversationViewFrame = self.contentView.bounds;
    _conversationViewFrame.origin.y = 30;
    _conversationViewFrame.size.height = self.contentView.bounds.size.height - 40;
    //    CGRect _conversationViewFrame = CGRectMake(0, distanceOfBottom - MinHeight_InputView - SCREEN_HEIGHT / 8 * 3, SCREEN_WIDTH, SCREEN_HEIGHT /8 * 3);
    self.conversationMessageCollectionView =
    [[UICollectionView alloc] initWithFrame:_conversationViewFrame
                       collectionViewLayout:customFlowLayout];
    [self.conversationMessageCollectionView
     setBackgroundColor:RGBCOLOR(235, 235, 235)];
    self.conversationMessageCollectionView.showsHorizontalScrollIndicator = NO;
    self.conversationMessageCollectionView.alwaysBounceVertical = YES;
    self.conversationMessageCollectionView.dataSource = self;
    self.conversationMessageCollectionView.delegate = self;
    [self.contentView addSubview:self.conversationMessageCollectionView];
    //输入区
    if(self.inputBar == nil){
        float inputBarOriginY = distanceOfBottom - SCREEN_WIDTH / 8;
        float inputBarOriginX = SCREEN_WIDTH / 6 ;
        float inputBarSizeWidth = SCREEN_WIDTH / 3 *2 ;
        float inputBarSizeHeight = MinHeight_InputView;
        self.inputBar = [[RCInputBarControl alloc]initWithFrame:CGRectMake(inputBarOriginX, inputBarOriginY,inputBarSizeWidth,inputBarSizeHeight)
                                                inViewConroller:self];
        self.inputBar.delegate = self;
        self.inputBar.backgroundColor = [UIColor clearColor];
        [self.view addSubview:self.inputBar];
    }
    [self registerClass:[LYTextMessageCell class]forCellWithReuseIdentifier:rctextCellIndentifier];
    [self registerClass:[LYTipMessageCell class]forCellWithReuseIdentifier:rcTipMessageCellIndentifier];
    [self registerClass:[LYGiftMessageCell class]forCellWithReuseIdentifier:rcGiftMessageCellIndentifier];
    [self changeModel:self.isFullScreen];
    _resetBottomTapGesture =[[UITapGestureRecognizer alloc]
                             initWithTarget:self
                             action:@selector(tap4ResetDefaultBottomBarStatus:)];
    [_resetBottomTapGesture setDelegate:self];
    [self.view addGestureRecognizer:_resetBottomTapGesture];
    
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
    _conversationViewFrame.size.height = self.contentView.bounds.size.height - 35;
    _conversationViewFrame.origin.y = 30;
    //     CGRect _conversationViewFrame = CGRectMake(0, distanceOfBottom - MinHeight_InputView - SCREEN_HEIGHT / 8 * 3, SCREEN_WIDTH, SCREEN_HEIGHT /8 * 3);
    [self.conversationMessageCollectionView setFrame:_conversationViewFrame];
    float inputBarOriginY = distanceOfBottom - SCREEN_WIDTH / 8;
    float inputBarOriginX = SCREEN_WIDTH / 6 ;
    float inputBarSizeWidth = SCREEN_WIDTH / 3 *2 ;
    float inputBarSizeHeight = MinHeight_InputView;
    //添加输入框
    self.inputBar.layer.cornerRadius = 8.f;
    self.inputBar.layer.masksToBounds = YES;
    self.inputBar.backgroundColor = [UIColor redColor];
    [self.inputBar changeInputBarFrame:CGRectMake(inputBarOriginX, inputBarOriginY,inputBarSizeWidth,inputBarSizeHeight)];
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
            break;
        }
        if (newId == __item.messageId) {
            return NO;
        }
    }
    if (!model.content) {
        return NO;
    }
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
//                                   if ([message.content isMemberOfClass:[LYGiftMessage class]] ) {
//                                       message.messageId = -1;//插入消息时如果id是-1不判断是否存在
//                                   }
                                   [__weakself appendAndDisplayMessage:message];
                                   //                                   [__weakself.inputBar clearInputView];
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
        [self.inputBar setInputBarStatus:CHKBottomBarDefaultStatus];
        self.inputBar.height = MinHeight_InputView;
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

- (void)onConnectionStatusChanged:(RCConnectionStatus)status {
    self.currentConnectionStatus = status;
}

@end
