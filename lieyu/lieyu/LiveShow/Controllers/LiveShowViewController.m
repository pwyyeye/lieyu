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

#import "RegisterLiveShowView.h"
#import "CloseLiveShowView.h"
#import "AnchorDetailView.h"
#import "UserHeader.h"
#import "LiveSetView.h"
#import "InputTextFieldView.h"

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
PLStreamingSendingBufferDelegate,UICollectionViewDataSource, UICollectionViewDelegate ,UICollectionViewDelegateFlowLayout,UITextFieldDelegate>

{
    NSDictionary *dic;
    CGFloat _beautify;//美颜值
    UISlider *_beaSlider;
    NSTimer *_timer;//定时器
    int _takeNum;//聊天数
    int _likeNum;//点赞数
    UIImage *_begainImage;
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
@property (nonatomic, strong) AnchorDetailView *anchorDetailView;

@property (nonatomic, strong) InputTextFieldView *inputTextFieldView;
@property (nonatomic, strong) LiveSetView *livesetView;
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
 *  是否需要滚动到底部
 */
@property(nonatomic, assign) BOOL isNeedScrollToButtom;


/**
 *  点击空白区域事件
 */
@property(nonatomic, strong) UITapGestureRecognizer *resetBottomTapGesture;

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
#define _CELL @ "acell"


@implementation LiveShowViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [self.conversationMessageCollectionView reloadData];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:@"kRCPlayVoiceFinishNotification"
     object:nil];
    
    [self.conversationMessageCollectionView removeGestureRecognizer:_resetBottomTapGesture];
    [self.conversationMessageCollectionView
     addGestureRecognizer:_resetBottomTapGesture];
    
    [_timer invalidate];
    _timer = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _registerView = [[[NSBundle mainBundle] loadNibNamed:@"RegisterLiveShowView" owner:self options:nil] lastObject];
    _registerView.frame = self.view.bounds;
    _registerView.alpha = 0.5f;
    _registerView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_registerView];
    [self.view bringSubviewToFront:_registerView];
    [_registerView.backButton addTarget:self action:@selector(registerbackButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.session setBeautifyModeOn:YES];
    [_registerView setBegainImage:^(UIImage *img) {
        _begainImage = img;
    }];
    _stream= @"ceshi";
    [self initPLplayer];//初始化摄像头
//    [self beginLiveShow];
    //获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(notice:) name:@"kobe24" object:nil];
    
    
    
}

-(void)notice:(NSNotification *)sender{
//    __weak typeof(self) weakSelf = self;
    _stream = sender.userInfo[@"stream"];
    _chatRoomId = sender.userInfo[@"chatroomid"];
    _roomid = sender.userInfo[@"roomid"];
    [self initPLplayer];//初始化摄像头
    [self.registerView setHidden:YES];
    [self.emitterLayer setHidden:NO];
    [self initUI];
    [self beginLiveShow];
    
    [self joinChatRoom];
    _timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(timerUpdataAction) userInfo:nil repeats:YES];
    [_timer fire];
}


-(void)timerUpdataAction{
    NSDictionary *dictionary = @{@"chatNum":[NSString stringWithFormat:@"%d",_takeNum],@"liveChatId":_chatRoomId};
    [LYFriendsHttpTool requestListWithParms:dictionary complete:^(NSDictionary *dict) {
        _likeNum = (int)dict[@"likeNum"];
        _userView.numberLabel.text = [NSString stringWithFormat:@"%d",_likeNum];
        
        [_audienceCollectionView reloadData];
    }];
}

#pragma mark --- 初始化页面
-(void)initUI {
    
    //粒子动画
    UIView *CAEmitterView = [[UIView alloc] initWithFrame:self.view.bounds];
    CAEmitterView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:CAEmitterView];
    [CAEmitterView.layer addSublayer:self.emitterLayer];

    //返回按钮
    _backButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _backButton.frame = CGRectMake(SCREEN_WIDTH - (SCREEN_WIDTH / 7) - 10, 30, SCREEN_WIDTH / 7, SCREEN_HEIGHT / 12);
    [_backButton setImage:[UIImage imageNamed:@"live_close.png"] forState:(UIControlStateNormal)];
    [_backButton addTarget:self action:@selector(closeButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [CAEmitterView addSubview:_backButton];
    
    //顶部用户信息
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"UserHeader" owner:self options:nil];
    //得到第一个UIView
    _userView = [nib objectAtIndex:0];
    _userView.frame = CGRectMake(20, 30, SCREEN_WIDTH / 2, SCREEN_HEIGHT / 15);
    _userView.layer.cornerRadius = SCREEN_HEIGHT / 30;
    _userView.layer.masksToBounds = YES;
    _userView.backgroundColor = RGBA(33, 33, 33, 0.5);
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [_userView.iconIamgeView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",app.userModel.avatar_img]]];
    _userView.iconIamgeView.layer.cornerRadius = _userView.iconIamgeView.frame.size.height/2;
    _userView.iconIamgeView.layer.masksToBounds = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showDetail)];
    [_userView.iconIamgeView addGestureRecognizer:tapGesture];
    _userView.iconIamgeView.userInteractionEnabled = YES;
    _userView.userNameLabel.text = [NSString stringWithFormat:@"%@",app.userModel.usernick];
    
    [_userView.isFoucsButton addTarget:self action:@selector(foucsButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [CAEmitterView addSubview:_userView];
    
    //观众列表
    UICollectionViewFlowLayout *layout=[[ UICollectionViewFlowLayout alloc ] init ];
    [layout setScrollDirection:(UICollectionViewScrollDirectionHorizontal)];
    _audienceCollectionView = [[ UICollectionView alloc ] initWithFrame : CGRectMake(10, SCREEN_HEIGHT / 12 + 30 +10, SCREEN_WIDTH - 20, SCREEN_HEIGHT / 13) collectionViewLayout :layout];
    [_audienceCollectionView registerClass :[ UICollectionViewCell class ] forCellWithReuseIdentifier : _CELL ];
    _audienceCollectionView.tag = 199;
    _audienceCollectionView.showsHorizontalScrollIndicator = NO;
    _audienceCollectionView. backgroundColor =[UIColor clearColor];
    _audienceCollectionView. delegate = self ;
    _audienceCollectionView. dataSource = self ;
    [CAEmitterView addSubview:_audienceCollectionView];
    
    //设置按钮
    UIButton *setButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    setButton.size = CGSizeMake(MinHeight_InputView, MinHeight_InputView);
    setButton.center = CGPointMake(self.view.frame.size.width - SCREEN_WIDTH / 10,distanceOfBottom - MinHeight_InputView / 2);
    [setButton setImage:[UIImage imageNamed:@"live_set.png"] forState:(UIControlStateNormal)];
    [setButton addTarget:self action:@selector(setButtonAction) forControlEvents:(UIControlEventTouchUpInside)];
    _setButton = setButton;
    [self.view addSubview:_setButton];
    
    _livesetView = [[[NSBundle mainBundle] loadNibNamed:@"LiveSetView" owner:self options:nil] lastObject];
    _livesetView.frame = (CGRectMake(SCREEN_WIDTH / 5 * 3 , distanceOfBottom - 140 -SCREEN_WIDTH / 8 , 120, 140));
    _livesetView.backgroundColor = [UIColor whiteColor];
    _livesetView.alpha = 0.9f;
    _livesetView.layer.cornerRadius = 5.f;
    _livesetView.layer.masksToBounds = YES;
    _livesetView.hidden = YES;
    [self.view addSubview: _livesetView];
    
    [_livesetView.shareButton addTarget:self action:@selector(shareButtonAction) forControlEvents:(UIControlEventTouchUpInside)];
    [_livesetView.shiftButton addTarget:self action:@selector(shiftButtonAction) forControlEvents:(UIControlEventTouchUpInside)];
    [_livesetView.beautifulButton addTarget:self action:@selector(beautifulButtonAction) forControlEvents:(UIControlEventTouchUpInside)];
    
    _beaSlider = [[UISlider alloc] initWithFrame:(CGRectMake(SCREEN_WIDTH / 8 , SCREEN_HEIGHT / 3 , SCREEN_WIDTH / 4 * 3, 40))];
    _beaSlider.value = self.registerView.beautifySlider.value;
    _beaSlider.minimumTrackTintColor = self.registerView.beautifySlider.minimumTrackTintColor;
    _beaSlider.maximumTrackTintColor = self.registerView.beautifySlider.maximumTrackTintColor;
    _beaSlider.thumbTintColor = self.registerView.beautifySlider.thumbTintColor;
    _beaSlider.hidden = YES;
    [_beaSlider addTarget:self action:@selector(beattifyValueChangeAction:) forControlEvents:(UIControlEventValueChanged)];
    [self.view addSubview:_beaSlider];
    
}

#pragma mark --- 设置等事件
-(void)setButtonAction{
    if (_livesetView.hidden) {
        _livesetView.hidden = NO;
    } else {
        _livesetView.hidden = YES;
    }
}

-(void)shareButtonAction{
    NSString *string= [NSString stringWithFormat:@"下载猎娱App猎寻更多特色酒吧。http://10.17.30.44:8080/liveroom/live?liveChatId=%@",self.chatRoomId];
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = [NSString stringWithFormat:@"http://10.17.30.44:8080/liveroom/live?liveChatId=%@",self.chatRoomId];
    [UMSocialData defaultData].extConfig.wechatSessionData.url = [NSString stringWithFormat:@"http://10.17.30.44:8080/liveroom/live?liveChatId=%@",self.chatRoomId];
    [UMSocialData defaultData].extConfig.qqData.url = [NSString stringWithFormat:@"http://10.17.30.44:8080/liveroom/live?liveChatId=%@",self.chatRoomId];
    [UMSocialSnsService presentSnsIconSheetView:self appKey:UmengAppkey shareText:string shareImage:nil shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina,UMShareToQQ,nil] delegate:nil];
}

-(void)shiftButtonAction{
    dispatch_async(self.sessionQueue, ^{
        [self.session toggleCamera];
    });
}

-(void)beautifulButtonAction{
    if (_beaSlider.hidden) {
        _beaSlider.hidden = NO;
    } else {
        _beaSlider.hidden = YES;
    }
}

-(void)beattifyValueChangeAction:(UISlider *)sender{
    [self.session setBeautify:sender.value];
}

#pragma mark -- 粒子动画
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
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"paopao@2x"]];
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
        [self.view.layer addSublayer:emitterLayer];
        _emitterLayer = emitterLayer;
    }
    return _emitterLayer;
}

#pragma mark --- 初始化播放器
-(void) initPLplayer{
    // 预先设定几组编码质量，之后可以切换
    CGSize videoSize = CGSizeMake(480 , 640);
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    if (orientation <= AVCaptureVideoOrientationLandscapeLeft) {
        if (orientation > AVCaptureVideoOrientationPortraitUpsideDown) {
            videoSize = CGSizeMake(640 , 480);
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
                                             selector:@selector(handleInterruption:)
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
                self.session.captureDevicePosition = AVCaptureDevicePositionBack;
                self.session.delegate = self;
                self.session.bufferDelegate = self;
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIView *previewView = self.session.previewView;
                    previewView.autoresizingMask = UIViewAutoresizingFlexibleHeight| UIViewAutoresizingFlexibleWidth;
                    [self.view insertSubview:previewView atIndex:0];
                    [self.registerView setBeginLive:^(CGFloat value) {
                        [self.session setBeautify:value];
                        _beautify = value;
                    }];
                    if (![_stream isEqualToString:@"ceshi"]) {//正确stream的推流画面覆盖之前的
                        UIView *previewView = self.session.previewView;
                        previewView.autoresizingMask = UIViewAutoresizingFlexibleHeight| UIViewAutoresizingFlexibleWidth;
                        [self.view insertSubview:previewView atIndex:1];
                        [self.session setBeautify:_beautify];
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
    }
    
    NSString *log = [NSString stringWithFormat:@"Networkt Status: %s", networkStatus[status]];
    NSLog(@"%@", log);
}

- (void)handleInterruption:(NSNotification *)notification {
    if ([notification.name isEqualToString:AVAudioSessionInterruptionNotification]) {
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

- (void)streamingSessionSendingBufferDidFull:(id)session {
    NSString *log = @"Buffer is full";
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
#if kReloadConfigurationEnable
    NSDate *now = [NSDate date];
    if (!self.keyTime) {
        self.keyTime = now;
    }
    
    double expectedVideoFPS = (double)self.session.videoConfiguration.videoFrameRate;
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
-(void) beginLiveShow{
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
-(void)showDetail{
    _anchorDetailView = [[[NSBundle mainBundle] loadNibNamed:@"AnchorDetailView" owner:self options:nil] lastObject];
    _anchorDetailView.frame = CGRectMake(0, 0, SCREEN_WIDTH/5 *4,SCREEN_HEIGHT / 3);
    _anchorDetailView.center = self.view.center;
    _anchorDetailView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_anchorDetailView];
    [self.view bringSubviewToFront:_anchorDetailView];
}


#pragma mark -- 返回（结束播放）
//结束直播弹出结束画面
-(void)closeButtonAction:(UIButton *) sender{
    _closeView = [[[NSBundle mainBundle] loadNibNamed:@"CloseLiveShowView" owner:self options:nil] lastObject];
    _closeView.frame = self.view.bounds;
    _closeView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_closeView];
    [self.view bringSubviewToFront:_closeView];
    [_closeView.backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [_closeView.notSaveButton addTarget:self action:@selector(notSaveBackButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    dispatch_sync(self.sessionQueue, ^{
        [self.session destroy];
    });
    _closeView.begainImage = _begainImage;
    _closeView.chatRoomID = _chatRoomId;
    self.session = nil;
    self.sessionQueue = nil;
    
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

#pragma mark -- 关注
-(void)foucsButtonAction: (UIButton *) sender{
    NSLog(@"我关注了");
}

#pragma mark --UICollectionViewDataSource

//定义展示的UICollectionViewCell的个数

-( NSInteger )collectionView:( UICollectionView *)collectionView numberOfItemsInSection:( NSInteger )section
{
    if (collectionView.tag == 199) {//观众列表
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
    if (collectionView.tag == 199) {
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
    if (collectionView.tag == 199) {
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

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"kobe24" object:nil];
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
    user.name = app.userModel.username;
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
//    if(self.inputBar == nil){
//        float inputBarOriginY = distanceOfBottom - SCREEN_WIDTH / 8;
//        float inputBarOriginX = SCREEN_WIDTH / 6 ;
//        float inputBarSizeWidth = SCREEN_WIDTH / 3 *2 ;
//        float inputBarSizeHeight = MinHeight_InputView;
//        self.inputBar = [[RCInputBarControl alloc]initWithFrame:CGRectMake(inputBarOriginX, inputBarOriginY,inputBarSizeWidth,inputBarSizeHeight)
//                                                inViewConroller:self];
//        self.inputBar.delegate = self;
//        self.inputBar.backgroundColor = [UIColor clearColor];
//        [self.view addSubview:self.inputBar];
//    }
    if (self.inputTextFieldView == nil) {
        self.inputTextFieldView = [[InputTextFieldView alloc] initWithFrame:(CGRectMake(SCREEN_WIDTH / 6, distanceOfBottom - SCREEN_WIDTH / 8, SCREEN_WIDTH / 3 * 2, MinHeight_InputView))];
        self.inputTextFieldView.backgroundColor = [UIColor grayColor];
        self.inputTextFieldView.alpha = .5f;
        [self.view addSubview:self.inputTextFieldView];
        _inputTextFieldView.inputTextField.keyboardType = UIKeyboardTypeDefault;
        //监听键盘出现
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardAppearanceAction:) name:UIKeyboardWillShowNotification object:nil];
        //监听键盘隐藏
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHideAction:) name:UIKeyboardWillHideNotification object:nil];
        //点击空白回收键盘
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [self.view addGestureRecognizer:tapGes];
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


#pragma mark --- 键盘监听事件
-(void)keyboardAppearanceAction:(NSNotification *) sender{
    NSDictionary *dict = [sender userInfo];
    NSValue *value = [dict objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyBoardRect = [value CGRectValue];
    int height = keyBoardRect.size.height;
    if ((_inputTextFieldView.size.height + _inputTextFieldView.origin.y) > (self.view.frame.size.height - height)) {
        CGRect inputRect = _inputTextFieldView.frame;
        inputRect.origin.y = _inputTextFieldView.frame.origin.y + height;
        [_inputTextFieldView setFrame:inputRect];
    }
}

-(void)keyboardWillHideAction:(NSNotification *) sender{
    
    
}

#pragma mark --- 

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSString *text = [NSString stringWithFormat:@"%@", _inputTextFieldView.inputTextField.text];
    RCTextMessage *rcTextMessage = [RCTextMessage messageWithContent:text];
    [self sendMessage:rcTextMessage pushContent:nil];
    [_inputTextFieldView.inputTextField resignFirstResponder];
    return YES;
}


-(void)tapAction{
    
}

-(void)changeModel:(BOOL)isFullScreen {
    _isFullScreen = YES;
    self.conversationMessageCollectionView.backgroundColor = [UIColor clearColor];
    //修改会话列表和输入框位置
    CGRect _conversationViewFrame = self.contentView.bounds;
    _conversationViewFrame.size.height = self.contentView.bounds.size.height - 35;
    _conversationViewFrame.origin.y = 30;
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
    self.inputTextFieldView = [[InputTextFieldView alloc] initWithFrame:(CGRectMake(SCREEN_WIDTH / 6, distanceOfBottom - SCREEN_WIDTH / 8, SCREEN_WIDTH / 3 * 2, MinHeight_InputView))];
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
- (void)didReceiveMessageNotification:(NSNotification *)notification {
    
    _takeNum += 1;//记录聊天数
    
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
//        [self.inputBar setInputBarStatus:CHKBottomBarDefaultStatus];
//        self.inputBar.height = MinHeight_InputView;
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

- (void)onConnectionStatusChanged:(RCConnectionStatus)status {
    self.currentConnectionStatus = status;
}



@end
