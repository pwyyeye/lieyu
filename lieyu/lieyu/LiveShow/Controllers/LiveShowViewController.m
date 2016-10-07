//
//  LiveShowViewController.m
//  lieyu
//
//  Created by 狼族 on 16/8/16.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LiveShowViewController.h"

#import "Reachability.h"
#import <asl.h>
#import <PLCameraStreamingKit/PLCameraStreamingKit.h>
#import "UMSocial.h"
#import "IQKeyboardManager.h"
#import "ISEmojiView.h"
#import "LYFriendsCommentView.h"

#import "RegisterLiveShowView.h"
#import "CloseLiveShowView.h"
#import "AnchorDetailView.h"
#import "UserHeader.h"
#import "LiveSetView.h"
#import "InputTextFieldView.h"
#import "ChatUseres.h"
#import "DMHeartFlyView.h"
#import "AudienceCell.h"

#import "LYUserHttpTool.h"
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
#import <objc/runtime.h>
#import "MBProgressHUD.h"
#import <RongIMToolKit/RongIMToolKit.h>
#import <RongIMToolKit/RCInputBarControl.h>
#import <RongIMToolKit/RCInputBarTheme.h>


const char *stateNames[] = {
    "Unknow",
    "Connecting",
    "Connected",
    "Disconnecting",
    "Disconnected",
    "Error"
};

const char *networkStatus[] = {
    "Not Reachable",
    "Reachable via WiFi",
    "Reachable via CELL"
};

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

@interface LiveShowViewController () <PLCameraStreamingSessionDelegate,
PLStreamingSendingBufferDelegate,UICollectionViewDataSource, UICollectionViewDelegate ,UICollectionViewDelegateFlowLayout,UITextFieldDelegate,ISEmojiViewDelegate,AVAudioPlayerDelegate>

{
    CGFloat _beautify;//美颜值
    UISlider *_beaSlider;
    UIView *_blackView;
    NSTimer *_timer;//定时器
    int _takeNum;//聊天数
    long _likeNum;//点赞数
    NSString *_lookNum;//观看人数
    UIImage *_begainImage;
    NSInteger _commentBtnTag;
    LYFriendsCommentView *_commentView;//弹出的评论框
    UILabel *_textLabel;//输入框
    NSString *defaultComment;//残留评论
    ISEmojiView *_emojiView;//表情键盘
    UIView *_bigView;//评论的背景view
    CGFloat _heartSize;//红心的大小
    NSTimer *_burstTimer;//延时
    NSInteger _chatuserid;
}

//配置信息
@property (nonatomic, strong) PLCameraStreamingSession  *session;
@property (nonatomic, strong) Reachability *internetReachability;
@property (nonatomic, strong) dispatch_queue_t sessionQueue;
@property (nonatomic, strong) NSArray<PLVideoCaptureConfiguration *>   *videoCaptureConfigurations;
@property (nonatomic, strong) NSArray<PLVideoStreamingConfiguration *>   *videoStreamingConfigurations;
@property (nonatomic, strong) NSDate    *keyTime;

//上方主播View
@property (nonatomic, strong) UserHeader *userView;
@property (nonatomic, strong) UIImageView *userIcon;
@property (nonatomic, strong) UILabel *userNickname;
@property (nonatomic, strong) UILabel *unKnowNumber;
@property (nonatomic, strong) UIButton *isFoucsButton;

//注册/退出/详情/设置View
@property (nonatomic, strong) RegisterLiveShowView *registerView;
@property (nonatomic, strong) CloseLiveShowView *closeView;
@property (nonatomic, strong) UIImageView *backImage;
@property (nonatomic, strong) AnchorDetailView *anchorDetailView;

@property (nonatomic, strong) InputTextFieldView *inputTextFieldView;
@property (nonatomic, strong) LiveSetView *livesetView;
@property (nonatomic, strong) UIView *backgroudView;
//退出
@property (nonatomic, strong) UIButton *backButton;

//观众列表
@property (nonatomic, strong) UICollectionView *audienceCollectionView;
@property(nonatomic, strong) NSMutableArray *dataArray;//聊天室


@property(nonatomic, strong)RCCollectionViewHeader *collectionViewHeader;


/**
 *  是否需要滚动到底部
 */
@property(nonatomic, assign) BOOL isNeedScrollToButtom;

/**
 *  底部显示未读消息view
 */
@property (nonatomic, strong) UIView *unreadButtonView;
@property(nonatomic, strong) UILabel *unReadNewMessageLabel;

/**
 *  滚动条不在底部的时候，接收到消息不滚动到底部，记录未读消息数
 */
@property (nonatomic, assign) NSInteger unreadNewMsgCount;

@property(nonatomic, strong) UIButton *giftButton;
@property(nonatomic, strong) UIButton *likeButton;

@property(nonatomic, strong) UIButton *setButton;
@property(nonatomic, assign) BOOL isShowSetView;


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

@implementation LiveShowViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [self.conversationMessageCollectionView reloadData];
    _takeNum = 0;
    
    [RCIM sharedRCIM].disableMessageAlertSound = YES;//关闭融云的提示音
}

-(void)viewWillDisappear:(BOOL)animated
{
    [RCIM sharedRCIM].disableMessageAlertSound = NO;//打开提示音
    
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:@"kRCPlayVoiceFinishNotification"
     object:nil];
    
    [_timer invalidate];
    _timer = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.dataArray = [NSMutableArray array];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSDate* dat = [NSDate date];
    NSTimeInterval a=[dat timeIntervalSince1970]*1000;
    NSString *time13 = [NSString stringWithFormat:@"%f",a];
    NSString *times = [time13 substringToIndex:13];
    _roomid =  [NSString stringWithFormat:@"%d%@", app.userModel.userid,times];
    __weak typeof(self) weakSelf = self;
    NSDictionary *roomDict = @{@"liveChatId":_roomid,@"1":@"1"};
    //获取直播的stream配置摄像头,请求stream之后将创建开始界面，所以必须传递roomid,此处已经开始配置好了音频和视频，当点击开始直播请求结束后，收到通知才开始推流。
    [LYFriendsHttpTool getStreamWithParms:roomDict complete:^(NSDictionary *dict) {
        _stream = dict[@"stream"];
        NSString *jsonString = _stream;
        NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *streamJSON = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:NSJSONReadingMutableContainers
                                                                     error:&err];
        _streamId = streamJSON[@"id"];
        [weakSelf initPLplayer];//初始化摄像头
        
        _registerView = [[[NSBundle mainBundle] loadNibNamed:@"RegisterLiveShowView" owner:weakSelf options:nil] lastObject];
        _registerView.frame = self.view.bounds;
       _registerView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.5f];
        [weakSelf.view addSubview:_registerView];
        [weakSelf.view bringSubviewToFront:_registerView];
        _registerView.streamID = _streamId;//将streamid和roomid配置给开始界面
        _registerView.roomId = _roomid;
        [_registerView.backButton addTarget:weakSelf action:@selector(registerbackButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [_registerView.shiftCamreButton addTarget:weakSelf action:@selector(shiftButtonAction) forControlEvents:(UIControlEventTouchUpInside)];
        [_registerView setBegainImage:^(UIImage *img) {
            _begainImage = img;
        }];
    } failure:^(NSString *error) {
        [self dismissViewControllerAnimated:YES completion:NULL];
    }];
//    [self initPLplayer];//初始化摄像头
//    _registerView = [[[NSBundle mainBundle] loadNibNamed:@"RegisterLiveShowView" owner:self options:nil] lastObject];
//    _registerView.frame = self.view.bounds;
//    _registerView.alpha = 0.5f;
//    _registerView.backgroundColor = [UIColor blackColor];
//    [self.view addSubview:_registerView];
//    [self.view bringSubviewToFront:_registerView];
//    [_registerView.backButton addTarget:self action:@selector(registerbackButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
//    [_registerView setBegainImage:^(UIImage *img) {
//        _begainImage = img;
//    }];
    _beautify = .5f;
    [self.session setBeautifyModeOn:YES];
    [self.session setBeautify:_beautify];
    //获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(notice:) name:@"kobe24" object:nil];
    
    [center addObserver:self selector:@selector(stopLiveNow) name:UIApplicationWillResignActiveNotification object:nil];
    [center addObserver:self selector:@selector(startLiveNow) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].isAdd = YES;
    
}

-(void)stopLiveNow{
//    dispatch_sync(self.sessionQueue, ^{
//        [self.session destroy];
//    });
//    self.session = nil;
//    self.sessionQueue = nil;
}

-(void)startLiveNow{
//    [self initPLplayer];
//    [self beginLiveShow];
}

-(void)notice:(NSNotification *)sender{
//    __weak typeof(self) weakSelf = self;
    _stream = sender.userInfo[@"stream"];
    
//    NSString *jsonString = _stream;
//    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
//    NSError *err;
//    NSDictionary *streamJSON = [NSJSONSerialization JSONObjectWithData:jsonData
//                                                               options:NSJSONReadingMutableContainers
//                                                                 error:&err];
//    NSDictionary *hosts = streamJSON[@"hosts"];
//    NSString *rtmp = [NSString stringWithFormat:@"%@",hosts[@"publish"][@"rtmp"]];
//    NSString *hub = streamJSON[@"hub"];
//    NSString *idStr = streamJSON[@"title"];
//    NSString *key = streamJSON[@"publishKey"];
//    _contentURL = [NSString stringWithFormat:@"rtmp://%@/%@/%@?key=%@",rtmp,hub,idStr,key];
    _chatRoomId = sender.userInfo[@"chatroomid"];
    _roomid = sender.userInfo[@"roomid"];
//    [self initPLplayer];//初始化摄像头
    [_registerView  removeFromSuperview];
    _registerView = nil;
    [self initUI];
    [self beginLiveShow];
    [self joinChatRoom];
    _timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(livetimerUpdataAction) userInfo:nil repeats:YES];
    [_timer fire];
    [self livetimerUpdataAction];
}

#pragma mark -- 定时获取直播室人员和点赞数
-(void)livetimerUpdataAction{
    NSDictionary *dictionary = @{@"chatNum":[NSString stringWithFormat:@"%d",_takeNum],@"liveChatId":_chatRoomId};
    [self.dataArray removeAllObjects];
    [LYFriendsHttpTool requestListWithParms:dictionary complete:^(NSDictionary *dict) {
        if ([dict valueForKey:@"total"]) {
            _userView.numberLabel.text = [NSString stringWithFormat:@"%@",dict[@"total"]];
            _lookNum = [NSString stringWithFormat:@"%@",dict[@"total"]];
        } else {
            _userView.numberLabel.text = @"";
        }
        if ([dict valueForKey:@"users"]) {
            self.dataArray = dict[@"users"];
        }
        [_audienceCollectionView reloadData];
    }];
    
}

#pragma mark --- 初始化页面
-(void)initUI {
    _userView.numberLabel.text = @"0";
    //粒子动画
    UIView *CAEmitterView = [[UIView alloc] initWithFrame:self.view.bounds];
    CAEmitterView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:CAEmitterView];
    _heartSize = 36;

    //返回按钮
    _backButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _backButton.frame = CGRectMake(SCREEN_WIDTH - 50, 30, 40, 40);
    [_backButton setImage:[UIImage imageNamed:@"live_close.png"] forState:(UIControlStateNormal)];
    [_backButton addTarget:self action:@selector(closeButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [CAEmitterView addSubview:_backButton];
    
    //顶部用户信息
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"UserHeader" owner:self options:nil];
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    _userView = [nib objectAtIndex:0];
    CGSize textSize = CGSizeZero;
    textSize = [LYTextMessageCell getContentSize:app.userModel.usernick withFrontSize:16 withWidth:100];
    _userView.frame = CGRectMake(SCREEN_WIDTH / 50, 30, textSize.width + 60 , 40);
    _userView.layer.cornerRadius = 20;
    _userView.layer.masksToBounds = YES;
    _userView.backgroundColor = RGBA(68, 64, 67, 0.5);
    [_userView.iconIamgeView sd_setImageWithURL:[NSURL URLWithString:app.userModel.avatar_img] placeholderImage:[UIImage imageNamed:@"empyImage120"]];
    _userView.userNameLabel.text = [NSString stringWithFormat:@"%@",app.userModel.usernick];
    _userView.isFoucsButton.hidden = YES;
    [CAEmitterView addSubview:_userView];
    
    
    //观众列表
    UICollectionViewFlowLayout *layout=[[ UICollectionViewFlowLayout alloc ] init ];
    [layout setScrollDirection:(UICollectionViewScrollDirectionHorizontal)];
    _audienceCollectionView = [[ UICollectionView alloc ] initWithFrame : CGRectMake(SCREEN_WIDTH / 50, 70 + 10, SCREEN_WIDTH - 20, 50) collectionViewLayout :layout];
    [_audienceCollectionView registerClass :[AudienceCell class ] forCellWithReuseIdentifier : _CELL ];
    _audienceCollectionView.tag = 199;
    _audienceCollectionView.showsHorizontalScrollIndicator = NO;
    _audienceCollectionView.backgroundColor =[UIColor clearColor];
    _audienceCollectionView.delegate = self;
    _audienceCollectionView.dataSource = self;
    [CAEmitterView addSubview:_audienceCollectionView];
    
    //设置按钮
    UIButton *setButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    setButton.size = CGSizeMake(MinHeight_InputView, MinHeight_InputView);
    setButton.center = CGPointMake(SCREEN_WIDTH / 10 * 9,distanceOfBottom - MinHeight_InputView / 2);
    [setButton setImage:[UIImage imageNamed:@"live_set.png"] forState:(UIControlStateNormal)];
    [setButton addTarget:self action:@selector(setButtonAction) forControlEvents:(UIControlEventTouchUpInside)];
    _setButton = setButton;
    [self.view addSubview:_setButton];
    
    _livesetView = [[[NSBundle mainBundle] loadNibNamed:@"LiveSetView" owner:self options:nil] lastObject];
    _livesetView.frame = (CGRectMake(SCREEN_WIDTH / 10 * 9 + MinHeight_InputView/2 - 100, distanceOfBottom - 140 -SCREEN_WIDTH / 8 - 20 , 100, 160));
    _livesetView.backgroundColor = [UIColor clearColor];
    _livesetView.layer.cornerRadius = 5.f;
    _livesetView.layer.masksToBounds = YES;
    _backgroudView = [[UIView alloc] init];
    _backgroudView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.1f];
    _backgroudView.frame = self.setButton.frame;
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backgroudViewGes)];
    [_backgroudView addGestureRecognizer:tapGes];
    [self.view addSubview:_backgroudView];
    [_backgroudView addSubview:_livesetView];
    _backgroudView.hidden = YES;
    
    [_livesetView.shareButton addTarget:self action:@selector(shareButtonAction) forControlEvents:(UIControlEventTouchUpInside)];
    [_livesetView.shiftButton addTarget:self action:@selector(shiftButtonAction) forControlEvents:(UIControlEventTouchUpInside)];
    [_livesetView.beautifulButton addTarget:self action:@selector(beautifulButtonAction) forControlEvents:(UIControlEventTouchUpInside)];
    
    _beaSlider = [[UISlider alloc] initWithFrame:(CGRectMake(SCREEN_WIDTH / 8 , 17, SCREEN_WIDTH / 4 * 3, 40))];
    _beaSlider.value = _beautify;
    _beaSlider.minimumTrackTintColor = RGB(178, 38, 217);
    _beaSlider.maximumTrackTintColor = [UIColor whiteColor];
    _beaSlider.thumbTintColor = RGB(178, 38, 217);
    [_beaSlider addTarget:self action:@selector(beattifyValueChangeAction:) forControlEvents:(UIControlEventValueChanged)];
    _blackView = [[UIView alloc] initWithFrame:(CGRectMake(0, distanceOfBottom - SCREEN_WIDTH / 8 , SCREEN_WIDTH, SCREEN_WIDTH / 8 + 20))];
    _blackView.backgroundColor = [UIColor blackColor];
    _blackView.alpha = .6f;
    _blackView.hidden = YES;
    [_blackView addSubview:_beaSlider];
    [_backgroudView addSubview:_blackView];
}

#pragma mark --- 设置等事件
-(void)setButtonAction{
    if (_backgroudView.hidden) {
        _backgroudView.hidden = NO;
        if (_livesetView.hidden) {
            _livesetView.hidden = NO;
        }
        _backgroudView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        [self.view insertSubview:_backgroudView aboveSubview:_conversationMessageCollectionView];
    } else {
        _backgroudView.hidden = YES;
        _backgroudView.frame = self.setButton.frame;
    }
}

-(void)backgroudViewGes{
    _backgroudView.hidden = YES;
    _backgroudView.frame = self.setButton.frame;
    _blackView.hidden = YES;
}

-(void)shareButtonAction{
    NSString *string= [NSString stringWithFormat:@"猎娱直播间"];
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = [NSString stringWithFormat:@"%@%@%@",LY_SERVER,LY_LIVE_share,self.chatRoomId];
    [UMSocialData defaultData].extConfig.wechatSessionData.url = [NSString stringWithFormat:@"%@%@%@",LY_SERVER,LY_LIVE_share,self.chatRoomId];
    [UMSocialData defaultData].extConfig.qqData.url = [NSString stringWithFormat:@"%@%@%@",LY_SERVER,LY_LIVE_share,self.chatRoomId];
    [UMSocialSnsService presentSnsIconSheetView:self appKey:UmengAppkey shareText:string shareImage:_begainImage shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina,UMShareToQQ,nil] delegate:nil];
    _backgroudView.hidden = YES;
    _backgroudView.frame = self.setButton.frame;
}

-(void)shiftButtonAction{
    dispatch_async(self.sessionQueue, ^{
        [self.session toggleCamera];
    });
}

-(void)beautifulButtonAction{
    _livesetView.hidden = YES;
    if (_blackView.hidden) {
        _blackView.hidden = NO;
    } else {
        _blackView.hidden = YES;
    }
}

-(void)beattifyValueChangeAction:(UISlider *)sender{
    dispatch_async(self.sessionQueue, ^{
        [self.session setBeautify:sender.value];
    });
}


#pragma mark --- 初始化播放器
-(void) initPLplayer{
    // 预先设定几组编码质量，之后可以切换
    CGSize videoSize = CGSizeMake(720 , 1280);
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    if (orientation <= AVCaptureVideoOrientationLandscapeLeft) {
        if (orientation > AVCaptureVideoOrientationPortraitUpsideDown) {
            videoSize = CGSizeMake(1280 , 720);
        }
    }
    self.videoStreamingConfigurations = @[
                                          [[PLVideoStreamingConfiguration alloc] initWithVideoSize:videoSize expectedSourceVideoFrameRate:15 videoMaxKeyframeInterval:45 averageVideoBitRate:800 * 1000 videoProfileLevel:AVVideoProfileLevelH264Baseline31],
                                          [[PLVideoStreamingConfiguration alloc] initWithVideoSize:CGSizeMake(800 , 480) expectedSourceVideoFrameRate:24 videoMaxKeyframeInterval:72 averageVideoBitRate:800 * 1000 videoProfileLevel:AVVideoProfileLevelH264Baseline31],
                                          [[PLVideoStreamingConfiguration alloc] initWithVideoSize:videoSize expectedSourceVideoFrameRate:30 videoMaxKeyframeInterval:90 averageVideoBitRate:800 * 1000 videoProfileLevel:AVVideoProfileLevelH264Baseline31],
                                          ];
    self.videoCaptureConfigurations = @[
                                        [[PLVideoCaptureConfiguration alloc] initWithVideoFrameRate:15 sessionPreset:AVCaptureSessionPresetiFrame960x540 previewMirrorFrontFacing:YES previewMirrorRearFacing:NO streamMirrorFrontFacing:YES streamMirrorRearFacing:NO cameraPosition:AVCaptureDevicePositionFront videoOrientation:AVCaptureVideoOrientationPortrait],
                                        [[PLVideoCaptureConfiguration alloc] initWithVideoFrameRate:24 sessionPreset:AVCaptureSessionPresetiFrame960x540 previewMirrorFrontFacing:YES previewMirrorRearFacing:NO streamMirrorFrontFacing:YES streamMirrorRearFacing:NO cameraPosition:AVCaptureDevicePositionFront videoOrientation:AVCaptureVideoOrientationPortrait],
                                        [[PLVideoCaptureConfiguration alloc] initWithVideoFrameRate:30 sessionPreset:AVCaptureSessionPresetiFrame960x540 previewMirrorFrontFacing:YES previewMirrorRearFacing:NO streamMirrorFrontFacing:YES streamMirrorRearFacing:NO cameraPosition:AVCaptureDevicePositionFront videoOrientation:AVCaptureVideoOrientationPortrait]
                                        ];
    self.sessionQueue = dispatch_queue_create("pili.queue.streaming", DISPATCH_QUEUE_SERIAL);
    
    // 网络状态监控
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    self.internetReachability = [Reachability reachabilityForInternetConnection];
    [self.internetReachability startNotifier];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleLiveShowInterruption:)
                                                 name:AVAudioSessionInterruptionNotification
                                               object:[AVAudioSession sharedInstance]];
    
        NSString *jsonString = _stream;
        NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *streamJSON = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:NSJSONReadingMutableContainers
                                                                     error:&err];
    
        PLStream *stream = [PLStream streamWithJSON:streamJSON];
        void (^permissionBlock)(void) = ^{
            dispatch_async(self.sessionQueue, ^{
                PLVideoCaptureConfiguration *videoCaptureConfiguration = [self.videoCaptureConfigurations lastObject];
                PLAudioCaptureConfiguration *audioCaptureConfiguration = [PLAudioCaptureConfiguration defaultConfiguration];
                // 视频编码配置
                PLVideoStreamingConfiguration *videoStreamingConfiguration = [self.videoStreamingConfigurations lastObject];
                // 音频编码配置
                PLAudioStreamingConfiguration *audioStreamingConfiguration = [PLAudioStreamingConfiguration defaultConfiguration];
                AVCaptureVideoOrientation orientation = (AVCaptureVideoOrientation)(([[UIDevice currentDevice] orientation] <= UIDeviceOrientationLandscapeRight && [[UIDevice currentDevice] orientation] != UIDeviceOrientationUnknown) ? [[UIDevice currentDevice] orientation]: UIDeviceOrientationPortrait);
                // 推流 session
                self.session = [[PLCameraStreamingSession alloc] initWithVideoCaptureConfiguration:videoCaptureConfiguration audioCaptureConfiguration:audioCaptureConfiguration videoStreamingConfiguration:videoStreamingConfiguration audioStreamingConfiguration:audioStreamingConfiguration stream:stream videoOrientation:orientation];
                self.session.captureDevicePosition = AVCaptureDevicePositionFront;
                self.session.delegate = self;
                self.session.bufferDelegate = self;
                __weak typeof(self) weakSelf = self;
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIView *previewView = [[UIView alloc] init];
                    if ([_stream isEqualToString:@"ceshi"]) {
                        previewView = self.session.previewView;
                        previewView.autoresizingMask = UIViewAutoresizingFlexibleHeight| UIViewAutoresizingFlexibleWidth;
                        [self.view insertSubview:previewView atIndex:0];
                        [self.registerView setBeginLive:^(CGFloat value) {
                            [weakSelf.session setBeautify:value];
                            _beautify = value;
                        }];
                    } else {
                        //                        previewView.alpha = 0;
                        //                        [previewView removeFromSuperview];
                        //                        previewView = nil;
                        UIView *previewViewNew = self.session.previewView;
                        previewViewNew.autoresizingMask = UIViewAutoresizingFlexibleHeight| UIViewAutoresizingFlexibleWidth;
                        [self.view insertSubview:previewViewNew atIndex:0];
                        [weakSelf.registerView setBeginLive:^(CGFloat value) {
                            [weakSelf.session setBeautify:value];
                            _beautify = value;
                        }];
                    }
                });
            });
        };
        void (^noAccessBlock)(void) = ^{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"No Access", nil)
                                                                message:NSLocalizedString(@"!", nil)
                                                               delegate:nil
                                                      cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                                      otherButtonTitles:nil];
            [alertView show];
        };
        switch ([PLCameraStreamingSession cameraAuthorizationStatus]) {
            case PLAuthorizationStatusAuthorized:
                permissionBlock();
                break;
            case PLAuthorizationStatusNotDetermined: {
                [PLCameraStreamingSession requestCameraAccessWithCompletionHandler:^(BOOL granted) {
                    granted ? permissionBlock() : noAccessBlock();
                }];
            }
                break;
            default:
                noAccessBlock();
                break;
        }
}

#pragma mark - Notification Handler

- (void)reachabilityChanged:(NSNotification *)notif{
    Reachability *curReach = [notif object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    NetworkStatus status = [curReach currentReachabilityStatus];
    
    if (NotReachable == status) {
        // 对断网情况做处理
        [self stopSession];
        [MyUtil showMessage:@"无法连接网络,请检查网络设置"];
    }
    NSString *log = [NSString stringWithFormat:@"Networkt Status: %s", networkStatus[status]];
    NSLog(@"%@", log);
}

- (void)handleLiveShowInterruption:(NSNotification *)notification {
    if ([notification.name isEqualToString:AVAudioSessionInterruptionNotification] ) {
        NSLog(@"Interruption notification");
        if ([[notification.userInfo valueForKey:AVAudioSessionInterruptionTypeKey] isEqualToNumber:[NSNumber numberWithInt:AVAudioSessionInterruptionTypeBegan]]) {
            NSLog(@"InterruptionTypeBegan");
        } else {
            // the facetime iOS 9 has a bug: 1 does not send interrupt end 2 you can use application become active, and repeat set audio session acitve until success.  ref http://blog.corywiles.com/broken-facetime-audio-interruptions-in-ios-9
            NSLog(@"InterruptionTypeEnded");
            AVAudioSession *session = [AVAudioSession sharedInstance];
            
            [session setActive:YES error:nil];
        }
    }
}



#pragma mark - <PLStreamingSendingBufferDelegate>

- (void)streamingSession:(id)session sendingBufferCurrentDurationDidChange:(NSTimeInterval)currentDuration
{
    NSString *log = @"Buffer did change";
    NSLog(@"%@",log);
}

- (void)streamingSessionSendingBufferDidFull:(id)session {
    NSString *log = @"Buffer is full";
    NSLog(@"%@", log);
}

- (void)streamingSessionSendingBufferFillDidLowerThanLowThreshold:(id)session
{
    NSString *log = @"Buffer is lower";
    NSLog(@"%@", log);
}
- (void)streamingSession:(id)session sendingBufferDidDropItems:(NSArray *)items {
    NSString *log = @"Frame dropped";
    NSLog(@"%@", log);
}

#pragma mark - <PLCameraStreamingSessionDelegate>

- (void)cameraStreamingSession:(PLCameraStreamingSession *)session streamStateDidChange:(PLStreamState)state {
    NSString *log = [NSString stringWithFormat:@"Stream State: %s", stateNames[state]];
    NSLog(@"%@", log);
    // 除 PLStreamStateError 外的其余状态会回调在这个方法
    // 这个回调会确保在主线程，所以可以直接对 UI 做操作
}

- (void)cameraStreamingSession:(PLCameraStreamingSession *)session didDisconnectWithError:(NSError *)error {
    NSString *log = [NSString stringWithFormat:@"Stream State: Error. %@", error];
    NSLog(@"%@", log);
    // PLStreamStateError 都会回调在这个方法
    // 尝试重连，注意这里需要你自己来处理重连尝试的次数以及重连的时间间隔
    [self startSession];
}

- (void)cameraStreamingSession:(PLCameraStreamingSession *)session streamStatusDidUpdate:(PLStreamStatus *)status {
    
    NSString *log = [NSString stringWithFormat:@"%@", status];
    NSLog(@"%@", log);
    BOOL isrunning = [session isRunning];
    NSLog(@"%d", isrunning);
   
#if kReloadConfigurationEnable
    NSDate *now = [NSDate date];
    if (!self.keyTime) {
        self.keyTime = now;
    }
    double expectedVideoFPS = (double)self.session.videoCaptureConfiguration.videoFrameRate;
    double realtimeVideoFPS = status.videoFPS;
    if (realtimeVideoFPS < expectedVideoFPS * (1 - kMaxVideoFPSPercent)) {
        // 当得到的 status 中 video fps 比设定的 fps 的 50% 还小时，触发降低推流质量的操作
        self.keyTime = now;
        
        [self lowerQuality];
    } else if (realtimeVideoFPS >= expectedVideoFPS * (1 - kMinVideoFPSPercent)) {
        if (-[self.keyTime timeIntervalSinceNow] > kHigherQualityTimeInterval) {
            self.keyTime = now;
            
            [self higherQuality];
        }
    }
#endif  // #if kReloadConfigurationEnable
}
/// @abstract 获取到摄像头原数据时的回调, 便于开发者做滤镜等处理，需要注意的是这个回调在 camera 数据的输出线程，请不要做过于耗时的操作，否则可能会导致推流帧率下降


#pragma mark -

- (void)higherQuality {
    NSUInteger idx = [self.videoStreamingConfigurations indexOfObject:self.session.videoStreamingConfiguration];
    NSAssert(idx != NSNotFound, @"Oops");
    
    if (idx >= self.videoStreamingConfigurations.count - 1) {
        return;
    }
    PLVideoStreamingConfiguration *newStreamingConfiguration = self.videoStreamingConfigurations[idx + 1];
    PLVideoCaptureConfiguration *newCaptureConfiguration = self.videoCaptureConfigurations[idx + 1];
    [self.session reloadVideoStreamingConfiguration:newStreamingConfiguration videoCaptureConfiguration:newCaptureConfiguration];
}

- (void)lowerQuality {
    NSUInteger idx = [self.videoStreamingConfigurations indexOfObject:self.session.videoStreamingConfiguration];
    NSAssert(idx != NSNotFound, @"Oops");
    
    if (0 == idx) {
        return;
    }
    PLVideoStreamingConfiguration *newStreamingConfiguration = self.videoStreamingConfigurations[idx - 1];
    PLVideoCaptureConfiguration *newCaptureConfiguration = self.videoCaptureConfigurations[idx - 1];
    [self.session reloadVideoStreamingConfiguration:newStreamingConfiguration videoCaptureConfiguration:newCaptureConfiguration];
}

#pragma mark --- 开始直播
-(void) beginLiveShow {
    if (PLStreamStateConnected == self.session.streamState) {
        [self stopSession];
    } else {
        [self startSession];
    }
}

- (void)stopSession {
    dispatch_async(self.sessionQueue, ^{
        self.keyTime = nil;
        [self.session stop];
    });
}

- (void)startSession {
    self.keyTime = nil;
    
    dispatch_async(self.sessionQueue, ^{
        [self.session startWithCompleted:^(BOOL success) {
            if (success) {
                NSLog(@"Streaming started.");
            } else {
                NSLog(@"Oops.");
            }
        }];
    });
    
    
    
}

#pragma mark --- 展示用户详情以及交互
//点击聊天室
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
    [_anchorDetailView.anchorIcon sd_setImageWithURL:[NSURL URLWithString:imgStr]];
    if (chatuser.gender == 0) {
        _anchorDetailView.genderIamge.image=[UIImage imageNamed:@"woman"];
    }else{
        _anchorDetailView.genderIamge.image=[UIImage imageNamed:@"manIcon"];
    }
    
    NSString *astro = [MyUtil getAstroWithBirthday:chatuser.birthday];
    [_anchorDetailView.starlabel setText:astro];
    
    NSString *tagText = chatuser.tag;
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
            sender.titleLabel.text = @"关注";
        }];
    } else {
        [LYFriendsHttpTool followFriendWithParms:dict complete:^(NSDictionary *dict) {
            [sender.titleLabel setText:@"已关注"];
            sender.userInteractionEnabled = NO;
        }];
    }
}

-(void)mainViewButtonAction:(UIButton *) sender{
//    LYMyFriendDetailViewController *myFriendVC = [[LYMyFriendDetailViewController  alloc] init];
//    myFriendVC.isChatroom = 4;
//    myFriendVC.userID = [NSString stringWithFormat:@"%ld", sender.tag];
//    [self.navigationController pushViewController:myFriendVC animated:YES];
}


#pragma mark -- 返回（结束播放）
//结束直播弹出结束画面
-(void)closeButtonAction:(UIButton *) sender{
    UIAlertController *alertCloseView = [UIAlertController alertControllerWithTitle:@"确定要退出吗？" message:@"" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        _backImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BackImage.png"]];
        _backImage.frame = self.view.bounds;
        [self.view addSubview:_backImage];
        [self.view bringSubviewToFront:_backImage];
        _backImage.userInteractionEnabled = YES;
        _closeView = [[[NSBundle mainBundle] loadNibNamed:@"CloseLiveShowView" owner:self options:nil] lastObject];
        _closeView.frame = self.view.bounds;
        [self.view addSubview:_closeView];
        [self.view bringSubviewToFront:_closeView];
        [_closeView.backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [_closeView.notSaveButton addTarget:self action:@selector(notSaveBackButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
        _closeView.lookNumLabel.text = _lookNum;
        _closeView.begainImage = _begainImage;
        _closeView.chatRoomID = _chatRoomId;
        dispatch_sync(self.sessionQueue, ^{
            [self.session destroy];
        });
        self.session = nil;
        self.sessionQueue = nil;
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    [alertCloseView addAction:cancelAction];
    [alertCloseView addAction:sureAction];
    [self presentViewController:alertCloseView animated:YES completion:nil];
}

//结束画面返回
-(void)backButtonAction:(UIButton *)sender{
    NSDictionary *dict = @{@"roomid":_roomid,@"closeType":@"save"};
    [LYFriendsHttpTool closeLiveShowWithParams:dict complete:^(NSDictionary *dict) {
    }];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}


-(void)notSaveBackButtonAction:(UIButton *) sender{
    NSDictionary *dict = @{@"roomid":_roomid,@"closeType":@"delete"};
    [LYFriendsHttpTool closeLiveShowWithParams:dict complete:^(NSDictionary *dict) {
    }];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}


//开始画面返回
-(void)registerbackButtonAction:(UIButton *) sender{
    [self dismissViewControllerAnimated:YES completion:NULL];
}


#pragma mark --UICollectionViewDataSource

//定义展示的UICollectionViewCell的个数

-( NSInteger )collectionView:( UICollectionView *)collectionView numberOfItemsInSection:( NSInteger )section
{
    if (collectionView.tag == 199) {//观众列表
        return _dataArray.count;
    } else {//信息
        return self.conversationDataRepository.count;
    }
}
//定义展示的Section的个数
-( NSInteger )numberOfSectionsInCollectionView:( UICollectionView *)collectionView
{
    return 1;
}
//每个UICollectionView展示的内容
-( UICollectionViewCell *)collectionView:( UICollectionView *)collectionView cellForItemAtIndexPath:( NSIndexPath *)indexPath
{
    if (collectionView.tag == 199) {
        AudienceCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier : _CELL forIndexPath :indexPath];
        ChatUseres *user = _dataArray[indexPath.row];
        NSString *imgStr = user.avatar_img;
        if (imgStr.length < 50) {
            imgStr = [MyUtil getQiniuUrl:user.avatar_img width:0 andHeight:0];
        }
        [cell.iconButton sd_setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:[UIImage imageNamed:@"empyImage120"]];
        [cell.detailButton addTarget:self action:@selector(detailViewShow:) forControlEvents:(UIControlEventTouchUpInside)];
        cell.detailButton.tag = indexPath.row;
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
    if (touch.view != self.conversationMessageCollectionView ) {
        return NO;
    }
    return YES;
}

//显示点赞
-(void)showTheLove{
    DMHeartFlyView* heart = [[DMHeartFlyView alloc]initWithFrame:CGRectMake(0, 0, _heartSize, _heartSize)];
    [self.view addSubview:heart];
    CGPoint fountainSource = CGPointMake(SCREEN_WIDTH - 20 - _heartSize/2.0, CGRectGetMaxY(self.view.bounds) - SCREEN_WIDTH / 4 - 15);
    heart.center = fountainSource;
    [heart animateInView:self.view];
}

#pragma mark -- 点击聊天室成员
-(void)detailViewShow:(UIButton *)sender{
    ChatUseres *user = _dataArray[sender.tag];
    NSDictionary *dictID = @{@"userid":[NSString stringWithFormat:@"%ld",user.id]};
    __weak typeof(self) weakSlef = self;
    [LYUserHttpTool GetUserInfomationWithID:dictID complete:^(find_userInfoModel *model) {
        user.gender = model.gender;
        user.birthday = model.birthday;
        user.tag = model.tag;
        [weakSlef showWatchDetailWith:user];
    }];
    
}


//cell消失时
-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag == 199) {
//        AudienceCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier : _CELL forIndexPath :indexPath];
//        cell.iconButton.imageView.image = nil;
//        [cell.iconButton removeTarget:self action:@selector(ceshiAction:) forControlEvents:(UIControlEventTouchUpInside)];
    } else {
        
    }
}

/* 定义每个UICollectionView 的大小 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag == 199) {
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
        __height = _textMessageSize.height;
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
    } else if ([messageContent isMemberOfClass:[LYStystemMessage class]]) {
        NSString *text = @"直播消息：我们提倡绿色直播，封面和直播内容含吸烟、低俗、诱导、违规等内容都将会被封停帐号，网警24小时在线巡查呦。";
        CGSize _textMessageSize = [LYSystemTextMessageCell getMessageCellSize:text withWidth:300];
        __height = _textMessageSize.height + 10;
    }
    return CGSizeMake(__width, __height);
}


/* 定义每个UICollectionView 的边缘 */
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (collectionView.tag == 199) {
        return UIEdgeInsetsMake(0, 1, 0, 1);//上 左 下 右
    } else {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
}

#pragma mark --- UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld",indexPath.row);
    if (collectionView.tag == 199) {
       
    } else {
        
    }
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"kobe24" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"stopNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"startNotification" object:nil];
}

#pragma mark --- 聊天室
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
     selector:@selector(didReceiveMessageNotification:)
     name:RCKitDispatchMessageNotification
     object:nil];
}

- (void)registerClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier {
    [self.conversationMessageCollectionView registerClass:cellClass
                               forCellWithReuseIdentifier:identifier];
}

#pragma mark --- 初始化界面
-(void)joinChatRoom{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    RCUserInfo *user = [[RCUserInfo alloc]init];
    user.userId = app.userModel.imuserId;
    user.name = app.userModel.usernick;
    [RCIM sharedRCIM].currentUserInfo = user;
    
    

    //初始化UI
    [self initializedSubViews];
    __weak LiveShowViewController *weakSelf = self;
    self.isFullScreen = YES;
    self.conversationType = ConversationType_CHATROOM;
    //聊天室类型进入时需要调用加入聊天室接口，退出时需要调用退出聊天室接口
    if (ConversationType_CHATROOM == self.conversationType) {
        [[RCIMClient sharedRCIMClient]
         joinChatRoom:_chatRoomId
         messageCount:-1
         success:^{
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                 LYStystemMessage *lyStystem = [[LYStystemMessage alloc] init];
                 [weakSelf sendMessage:lyStystem pushContent:nil];
//                 [weakSelf sendMessage:joinChatroomMessage pushContent:nil];
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
 *  初始化聊天页面控件
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
    _conversationViewFrame.origin.y = 0;
    _conversationViewFrame.size.height = self.contentView.bounds.size.height;
//        CGRect _conversationViewFrame = CGRectMake(0, 0, SCREEN_WIDTH - SCREEN_WIDTH / 8 , distanceOfBottom - SCREEN_HEIGHT /8 * 5 - SCREEN_WIDTH / 8);
    self.conversationMessageCollectionView =
    [[UICollectionView alloc] initWithFrame:_conversationViewFrame
                       collectionViewLayout:customFlowLayout];
        [self.conversationMessageCollectionView setBackgroundColor:[UIColor clearColor]];
        self.conversationMessageCollectionView.showsVerticalScrollIndicator = NO;
        self.conversationMessageCollectionView.alwaysBounceVertical = YES;
        self.conversationMessageCollectionView.dataSource = self;
        self.conversationMessageCollectionView.delegate = self;
        [self.contentView addSubview:self.conversationMessageCollectionView];
    _commentView = [[[NSBundle mainBundle]loadNibNamed:@"LYFriendsCommentView" owner:nil options:nil] firstObject];
    _commentView.frame = CGRectMake(SCREEN_WIDTH / 50, distanceOfBottom - SCREEN_WIDTH / 8,SCREEN_WIDTH - MinHeight_InputView - 40, MinHeight_InputView);
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
    _bigView = [[UIView alloc]init];
    _bigView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(LiveBigViewGes)];
    [_bigView addGestureRecognizer:tapGes];
    [self.view addSubview:_bigView];
    [self.view insertSubview:_bigView belowSubview:_commentView];
    _bigView.hidden = YES;
    
    [self registerClass:[LYTextMessageCell class]forCellWithReuseIdentifier:rctextCellIndentifier];
    [self registerClass:[LYTipMessageCell class]forCellWithReuseIdentifier:rcTipMessageCellIndentifier];
    [self registerClass:[LYGiftMessageCell class]forCellWithReuseIdentifier:rcGiftMessageCellIndentifier];
    [self registerClass:[LYSystemTextMessageCell class] forCellWithReuseIdentifier:rcStystemMessageCellIndentifier];
    
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
    _commentView.frame = CGRectMake(SCREEN_WIDTH / 50, distanceOfBottom - SCREEN_WIDTH / 8,SCREEN_WIDTH - MinHeight_InputView - 40, MinHeight_InputView);
    _commentView.backgroundColor = [UIColor clearColor];
    _commentView.bgView.backgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:.5f];
    _commentView.layer.cornerRadius = _commentView.frame.size.height / 2;
    _commentView.layer.masksToBounds = YES;
    _commentView.bgView.layer.borderColor = RGBA(68,64,67, .2).CGColor;
    _commentView.bgView.layer.borderWidth = 0.5;
    _commentView.layer.cornerRadius = _commentView.frame.size.height / 2;
    _commentView.layer.masksToBounds = YES;
    _commentView.textField.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0];
    _commentView.textField.borderStyle = UITextBorderStyleNone;
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
- (void)LiveBigViewGes{
    //    if (_commentView.textField.text.length) {
    defaultComment = _commentView.textField.text;
    //    }
    [_commentView.textField endEditing:YES];
    [UIView animateWithDuration:.25 animations:^{
        _commentView.frame = CGRectMake(SCREEN_WIDTH / 50, distanceOfBottom - SCREEN_WIDTH / 8,SCREEN_WIDTH - MinHeight_InputView - 40, MinHeight_InputView);
        _commentView.backgroundColor = [UIColor clearColor];
        _commentView.bgView.backgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:.5f];
        _commentView.layer.cornerRadius = _commentView.frame.size.height / 2;
        _commentView.layer.masksToBounds = YES;
        _commentView.bgView.layer.borderColor = RGBA(68,64,67, .2).CGColor;
        _commentView.bgView.layer.borderWidth = 0.5;
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


-(void)changeModel:(BOOL)isFullScreen {
    _isFullScreen = YES;
    self.conversationMessageCollectionView.backgroundColor = [UIColor clearColor];
    //修改会话列表和输入框位置
    CGRect _conversationViewFrame = self.contentView.bounds;
    _conversationViewFrame.size.height = self.contentView.bounds.size.height;
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
    self.inputTextFieldView = [[InputTextFieldView alloc] initWithFrame:(CGRectMake(SCREEN_WIDTH / 6 - 5, distanceOfBottom - SCREEN_WIDTH / 8, SCREEN_WIDTH / 3 * 2, MinHeight_InputView))];
    self.inputTextFieldView.backgroundColor = [UIColor grayColor];
    self.inputTextFieldView.alpha = .5f;
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
            [self showTheLove];//接受到消息
            break;
        }
        if (newId == __item.messageId) {
            return NO;
        }
    }
    if (!model.content) {
        return YES;
    }
    //这里可以根据消息类型来决定是否显示，如果不希望显示直接return NO
    
    //数量不可能无限制的大，这里限制收到消息过多时，就对显示消息数量进行限制。
    //用户可以手动下拉更多消息，查看更多历史消息。
    if (self.conversationDataRepository.count>100) {
        //NSRange range = NSMakeRange(0, 1);
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
- (void)didReceiveMessageNotification:(NSNotification *)notification {
    ++_takeNum ;//记录聊天数

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

- (void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status {
    self.currentConnectionStatus = status;
}



@end
