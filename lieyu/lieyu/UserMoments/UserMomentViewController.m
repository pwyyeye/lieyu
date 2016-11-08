//
//  UserMomentViewController.m
//  lieyu
//
//  Created by 狼族 on 16/9/8.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "UserMomentViewController.h"
#import "HotMenuButton.h"
#import "IQKeyboardManager.h"
#import "TopicModel.h"
#import "LYUserHttpTool.h"
#import "LYChangeImageViewController.h"
#import "LYFriendsAllCommentTableViewCell.h"
#import "UIButton+WebCache.h"
#import "LYFriendsLikeTableViewCell.h"
#import "LYFriendsTopicsViewController.h"
#import "BeerNewBarViewController.h"
#import "ISEmojiView.h"
#import "LYFriendsAMessageDetailViewController.h"
#import "LYFriendsMessageViewController.h"
#import "ImagePickerViewController.h"
#import "LYFriendsCommentView.h"
#import "LYPictiureView.h"
#import "LYDateUtil.h"
#import "DaShangView.h"

#import "LiveListViewController.h"

#define LYFriendsAllCommentCellID @"LYFriendsAllCommentTableViewCell"
#define LYFriendsLikeCellID @"LYFriendsLikeTableViewCell"
@interface UserMomentViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,emojiClickDelegate,ImagePickerFinish,UIImagePickerControllerDelegate,UINavigationControllerDelegate,sendBackVedioAndImage,ISEmojiViewDelegate,UITextFieldDelegate,CAAnimationDelegate>
{
    UIButton *_liveShow;//直播按钮
    UILabel *_myBadge;//我的角标
    NSInteger _saveImageAndVideoIndex;
    //    UIScrollView *_scrollViewForTableView;//表的基成视图
    NSString *_results;//新消息条数
    NSString *_icon;//新消息头像
    NSArray *_topicArray;//话题数组
    NSString *jubaoMomentID;//要删除的动态ID
    UIView *_bigView;//评论的背景view
    BOOL _isShow;//是否显示操作按钮
    DaShangView *_daShangView;//打赏View
    NSString *jubaoUserID;//被举报人的ID
    ISEmojiView *_emojiView;//表情键盘
    NSInteger _deleteMessageTag;//删除动态的btn的tag
    NSInteger _commentBtnTag;
    LYFriendsCommentView *_commentView;//弹出的评论框
    NSString *defaultComment;//残留评论
    UIVisualEffectView *emojiEffectView;
    UIButton *emoji_angry;
    UIButton *emoji_sad;
    UIButton *emoji_wow;
    UIButton *emoji_kawayi;
    UIButton *emoji_happy;
    UIButton *emoji_zan;
    
    int gestureViewTag;
    __block UIImageView *imageView;//引导页
    __block UIView *imageSubview;
    
    BOOL isDisturb;
    LYFriendsVideoTableViewCell *friendsVedioCell;
    
    UIImageView *bgImage;//背景图
    UIImageView *_iconIamge;//头像
    UILabel *_nameLabel;//姓名
    NSInteger _giftNumber;//礼物数量
    NSInteger _giftValue;//礼物价值
    
    UIImageView *_animationImageview;//刷新动画
    CAKeyframeAnimation *_CAkeyAnimation;
}
@property (nonatomic, assign) int pagesCount;
@property (nonatomic, strong) NSString *typeOfImagePicker;
@property (nonatomic, strong) UIImagePickerController *imagePicker;

@end

#define headerHeight SCREEN_WIDTH * 9 / 16

#define iconWidth SCREEN_WIDTH / 5

@implementation UserMomentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if(app.userModel) _useridStr = [NSString stringWithFormat:@"%d",app.userModel.userid];
    //    [self setupAllProperty];//配置初始化
    self.pagesCount = 4;
    _dataArray = [NSMutableArray new];
    _notificationDict = [[NSMutableDictionary alloc]init];
    [self setupTableView];//配置表
    _pageCount = 10;
    _pageStartCount = 0;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = @"我的玩友圈";

    [self setupCarmerBtn];
    
    [self setupMenuView];//配置导航
    
    [_userTablewView reloadData];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].isAdd = YES;
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].isAdd = NO;
    
    if (isExidtEffectView) {
        isExidtEffectView = NO;
        [emojisView hideEmojiEffectView];
    }
    
    [_liveShow removeFromSuperview];
    _liveShow = nil;
    
    [effectView removeFromSuperview];//移除发布按钮
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"sendGift" object:nil];
    
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackStateDidChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerLoadStateDidChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerScalingModeDidChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerDidExitFullscreenNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"FriendSendViewDidLoad" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    
}


#pragma mark - 获取最新玩友圈数据
- (void)getDataWithType:(dataType)type needLoad:(BOOL)need{

    NSString *startStr = [NSString stringWithFormat:@"%ld",(long) _pageStartCount];
    NSString *pageCountStr = @"10";
    NSDictionary *paraDic = nil;
    __weak __typeof(self) weakSelf = self;
    if(type == dataForMine){//我的玩友圈数据
        paraDic = @{@"userId":_useridStr,@"start":startStr,@"limit":pageCountStr,@"frientId":_useridStr};
        [LYFriendsHttpTool friendsGetUserInfoWithParams:paraDic needLoading:need compelte:^(FriendsUserInfoModel*userInfo, NSMutableArray *dataArray) {
            if (_pageStartCount == 0) {
                [weakSelf stopLoadingAnimating];
            }
            _userBgImageUrl = userInfo.friends_img;
            [weakSelf loadDataWith:_userTablewView dataArray:dataArray pageStartCount:_pageStartCount type:type];
//            [weakSelf setupTableForHeaderForUserMomentPage];
          
        }];
    } else {
        
    }
}

- (void)loadDataWith:(UITableView *)tableView dataArray:(NSMutableArray *)dataArray pageStartCount:(int)pageStartCount type:(dataType)type{
    if(dataArray.count){
        NSString *str = dataArray.firstObject;
        if (dataArray.count == 1 && [str isKindOfClass:[NSString class]]) {
            [_userTablewView.mj_footer endRefreshing];
        }else{
            if(_pageStartCount == 0){//下啦刷新时
                [_dataArray removeAllObjects];
                [_dataArray addObjectsFromArray:dataArray];
            }else {//上拉加载时
                [_dataArray addObjectsFromArray:dataArray];
                [_userTablewView.mj_footer endRefreshing];
            }
        }
    }else{
        [_userTablewView.mj_footer endRefreshingWithNoMoreData];
    }
    [_userTablewView reloadData];
    [_userTablewView.mj_header endRefreshing];
}

#pragma mark - 添加表头
- (void)setupTableForHeaderForUserMomentPage{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor whiteColor];
    headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, headerHeight + 30);
    //背景图
    bgImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, headerHeight)];
    [bgImage setImage:[UIImage imageNamed:@"empyImage16_9"]];
    //    [imgView sd_setImageWithURL:[NSURL URLWithString:_headerViewImgLink] placeholderImage:[UIImage imageNamed:@"empyImage16_9"]];
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesChooseImage)];
    [bgImage addGestureRecognizer:tapGes];
    bgImage.userInteractionEnabled = YES;
    [self setupBackIamgeView];
    [headerView addSubview:bgImage];
    
    //刷新动画
    NSMutableArray *imgsArray = [[NSMutableArray alloc] init];
    for (int i = 1; i < 10; i++) {
        UIImage *img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"loading%d@2x",i] ofType:@"png"]];
        [imgsArray addObject:(__bridge UIImage *)img.CGImage];
    }
    _CAkeyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
    _CAkeyAnimation.duration = imgsArray.count * 0.1;
    _CAkeyAnimation.delegate = self;
    _CAkeyAnimation.values = imgsArray;
    _CAkeyAnimation.repeatCount = 100;
    _animationImageview = [[UIImageView alloc] initWithFrame:(CGRectMake(14, 14, 25,25))];
    [self.view addSubview:_animationImageview];
    [self.view bringSubviewToFront:_animationImageview];
    
    //头像和姓名
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    _iconIamge = [[UIImageView alloc] init];
    [_iconIamge sd_setImageWithURL:[NSURL URLWithString:app.userModel.avatar_img]];
    _iconIamge.frame = CGRectMake(SCREEN_WIDTH - 10 - iconWidth, headerHeight - iconWidth / 4 * 3, iconWidth, iconWidth);
    _iconIamge.userInteractionEnabled = YES;
    _iconIamge.layer.cornerRadius = _iconIamge.frame.size.height / 2;
    _iconIamge.layer.masksToBounds = YES;
    UIGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconIamgeAction)];
    [_iconIamge addGestureRecognizer:tapGesture];
    [headerView addSubview:_iconIamge];
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.textColor = [UIColor whiteColor];
    [_nameLabel setText:app.userModel.usernick];
    [_nameLabel setTextAlignment:NSTextAlignmentRight];
    _nameLabel.frame =CGRectMake(SCREEN_WIDTH - iconWidth - 10 - 7 - 90, headerHeight - 30, 90, 30);
    _nameLabel.backgroundColor = [UIColor clearColor];
    [headerView addSubview:_nameLabel];
    _userTablewView.tableHeaderView = headerView;
}

- (void)iconIamgeAction{
    LYMyFriendDetailViewController *myFriendVC = [[LYMyFriendDetailViewController  alloc]initWithNibName:@"LYMyFriendDetailViewController" bundle:nil];
    myFriendVC.userID = [NSString stringWithFormat:@"%d",self.userModel.userid];
    [self.navigationController pushViewController:myFriendVC animated:YES];
}

- (void)startLoadingAnimating{
    [_animationImageview.layer addAnimation:_CAkeyAnimation forKey:@"loadAnimation"];
}

- (void)stopLoadingAnimating{
    [_animationImageview.layer removeAnimationForKey:@"loadAnimation"];
}

#pragma mark --设置背景图
-(void)setupBackIamgeView{
    
    NSData *imageData = [[NSUserDefaults standardUserDefaults] objectForKey:@"FriendUserBgImage"];
    if(!_userBgImageUrl){
        bgImage.image = [[UIImage alloc]initWithData:imageData];
    }else{
        if(imageData){
            //                [_headerView.ImageView_bg sd_setImageWithURL:[NSURL URLWithString:_userBgImageUrl] placeholderImage:[[UIImage alloc]initWithData:imageData]];
            [bgImage setImage:[UIImage imageWithData:imageData]];
        }else{
            [bgImage sd_setImageWithURL:[NSURL URLWithString:_userBgImageUrl] placeholderImage:[UIImage imageNamed:@"friendPresentBG.jpg"]];
        }
    }
    if(imageData == nil && [MyUtil isEmptyString:_userBgImageUrl]){
        bgImage.image = [UIImage imageNamed:@"friendPresentBG.jpg"];
    }
    bgImage.userInteractionEnabled = YES;
    bgImage.clipsToBounds = YES;
}
#pragma mark - 表头选择背景action
- (void)tapGesChooseImage{
    
    LYChangeImageViewController *changeImageVC = [[LYChangeImageViewController alloc]init];
    __weak typeof(self) weakSelf = self;
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    UIAlertAction *imageAction = [UIAlertAction actionWithTitle:@"选一张美图" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf.navigationController pushViewController:changeImageVC animated:YES];
    }];
    [alertVC addAction:cancelAction];
    [alertVC addAction:imageAction];
    [self presentViewController:alertVC animated:YES completion:^{
        
    }];
    [changeImageVC setPassImage:^(NSString *imageurl,UIImage *image) {
        bgImage.image = image;
        _headerView.ImageView_bg.image = image;
        _userBgImageUrl = [MyUtil getQiniuUrl:imageurl width:0 andHeight:0];
        NSData *imageData = UIImagePNGRepresentation(image);
        [[NSUserDefaults standardUserDefaults] setObject:imageData forKey:@"FriendUserBgImage"];
    }];
}

#pragma mark - 配置导航
- (void)setupMenuView{
    //配置直播按钮
    _liveShow = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 50, 0, 40, 44)];
    [_liveShow setTitle:@"直播" forState:UIControlStateNormal];
    [_liveShow setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_liveShow.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [_liveShow addTarget:self action:@selector(recentConnect) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:_liveShow];
    
}

#pragma mark --- 进入直播列表
-(void) recentConnect{
    LiveListViewController *liveVC = [[LiveListViewController alloc] init];
    liveVC.index = 1;
    [self.navigationController pushViewController:liveVC animated:YES];
}



#pragma mark - 配置发布按钮
- (void)setupCarmerBtn{
    
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    effectView = [[UIVisualEffectView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2.f - 30, SCREEN_HEIGHT - 120, 60, 60)];
    effectView.layer.cornerRadius = effectView.frame.size.width/2.f;
    effectView.layer.masksToBounds = YES;
    effectView.effect = effect;
    [self.view addSubview:effectView];
    effectView.layer.zPosition = 5;
    //发布按钮
    _carmerBtn = [[UIButton alloc]initWithFrame:CGRectMake((effectView.frame.size.width - 35)/2.f,(effectView.frame.size.height - 30)/2.f , 35, 30)];
    [_carmerBtn addTarget:self action:@selector(carmerClick:) forControlEvents:UIControlEventTouchUpInside];
    [_carmerBtn setBackgroundImage:[UIImage imageNamed:@"daohang_xiangji"] forState:UIControlStateNormal];
    [effectView addSubview:_carmerBtn];
    
    //发布按钮出来动画
    CGFloat offset = 150;
    [UIView animateWithDuration:.4 animations:^{
        effectView.frame = CGRectMake((SCREEN_WIDTH - 60)/2.f, SCREEN_HEIGHT - offset - 3, 60, 60);
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            effectView.frame = CGRectMake((SCREEN_WIDTH - 60)/2.f, SCREEN_HEIGHT - offset, 60, 60);
        }];
    }];
}


#pragma mark - 配置表的cell
- (void)setupTableView{
    _userTablewView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    _userTablewView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _userTablewView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);//我的表的内边距调整
    _userTablewView.scrollsToTop = NO;
    _userTablewView.tag = 1;
    [self.view addSubview:_userTablewView];
    [self setupTableForHeaderForUserMomentPage];
    [self setupMJRefreshForTableView:_userTablewView i:1];//为表配置上下刷新控件
    NSArray *array = @[LYFriendsNameCellID,LYFriendsAddressCellID,LYFriendsLikeCellID,LYFriendsCommentCellID,LYFriendsAllCommentCellID,LYFriendsVideoCellID,LYFriendsAllLikeCellID];
    for (NSString *cellIdentifer in array) {//注册单元格
            [_userTablewView registerNib:[UINib nibWithNibName:cellIdentifer bundle:nil] forCellReuseIdentifier:cellIdentifer];
            [_userTablewView registerClass:[UITableViewCell class] forCellReuseIdentifier:LYFriendsCellID];
            [_userTablewView registerClass:[LYFriendsImgTableViewCell class] forCellReuseIdentifier:LYFriendsImgCellID];
    }
    
    //表设置代理
        _userTablewView.dataSource = self;
        _userTablewView.delegate = self;
//    [_userTablewView.mj_header beginRefreshing];

}


#pragma mark - 为表配置上下刷新控件
- (void)setupMJRefreshForTableView:(UITableView *)tableView i:(NSInteger)i{
    __weak __typeof(self) weakSelf = self;
//    tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
//        
//    }];
    _pageStartCount = 0;
    [self getDataWithType:i needLoad:NO];
    [self startLoadingAnimating];
//    MJRefreshGifHeader *header = (MJRefreshGifHeader *)tableView.mj_header;
//    [self initMJRefeshHeaderForGif:header];
    
    tableView.mj_footer = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
        _pageStartCount +=10;
        [weakSelf getDataWithType:i needLoad:NO];
    }];
}



- (void)setUserM:(FriendsUserInfoModel *)userM{
    _userM = userM;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (isExidtEffectView) {
        isExidtEffectView = NO;
        [emojisView hideEmojiEffectView];
    }
    
    CGFloat offset = 0;
        if (scrollView.contentOffset.y > _contentOffSetY) {
            if (scrollView.contentOffset.y <= 0.f) {//发布按钮弹出
                effectView.frame = CGRectMake((SCREEN_WIDTH - 60)/2.f, SCREEN_HEIGHT - 150 + offset, 60, 60);
            }else{
                [UIView animateWithDuration:0.4 animations:^{
                    effectView.frame = CGRectMake((SCREEN_WIDTH - 60)/2.f, SCREEN_HEIGHT, 60, 60);
                }];
            }
        }else{
            if(CGRectGetMaxY(effectView.frame) > SCREEN_HEIGHT - 5){//发布按钮下移
                [UIView animateWithDuration:.4 animations:^{
                    effectView.frame = CGRectMake((SCREEN_WIDTH - 60)/2.f, SCREEN_HEIGHT - 153 + offset, 60, 60);
                }completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.2 animations:^{
                        effectView.frame = CGRectMake((SCREEN_WIDTH - 60)/2.f, SCREEN_HEIGHT - 150 +offset, 60, 60);
                    }];
                }];
            }
        }
    
    if (_userTablewView.contentOffset.y < 0) {
        CGFloat y = scrollView.contentOffset.y;
        CGFloat hegiht = headerHeight;
        bgImage.frame = CGRectMake(- ((hegiht - y) * 16 / 9.f - SCREEN_WIDTH ) /2.f, y, (hegiht - y) * 16 / 9.f, hegiht -y);
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
        _contentOffSetY = scrollView.contentOffset.y;//拖拽结束获取偏移量
    if (_userTablewView.contentOffset.y < 0) {
        _pageStartCount = 0;
        [self getDataWithType:dataForMine needLoad:NO];
        [self startLoadingAnimating];
    }
}



#pragma mark - UITableViewDelegate&UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    FriendsRecentModel *recentM = _dataArray[section];
    if (recentM.commentNum.integerValue >= 1) {
        return 5  + recentM.commentList.count;
    }else{
        if(!recentM.commentList.count) return 5;
        return 4 + recentM.commentList.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    FriendsRecentModel *recentM = _dataArray[indexPath.section];
    switch (indexPath.row) {
        case 0://昵称 头像 动态文本的cell
        {
            LYFriendsNameTableViewCell *nameCell = [tableView dequeueReusableCellWithIdentifier:LYFriendsNameCellID forIndexPath:indexPath];
            nameCell.recentM = recentM;
            nameCell.btn_delete.tag = indexPath.section;
            nameCell.btn_topic.tag = indexPath.section;
            [nameCell.btn_topic addTarget:self action:@selector(topicNameClick:) forControlEvents:UIControlEventTouchUpInside];
//            if (!tableView.tag) {
//                [nameCell.btn_delete setTitle:@"" forState:UIControlStateNormal];
//                [nameCell.btn_delete setImage:[[UIImage imageNamed:@"downArrow"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
//                [nameCell.btn_delete addTarget:self action:@selector(warningSheet:) forControlEvents:UIControlEventTouchUpInside];
//                if ([recentM.userId isEqualToString:[NSString stringWithFormat:@"%d",self.userModel.userid]]) {
//                    nameCell.btn_delete.hidden = YES;
//                    nameCell.btn_delete.enabled = NO;
//                }else{
//                    nameCell.btn_delete.hidden = NO;
//                    nameCell.btn_delete.enabled = YES;
//                }
//                nameCell.btn_headerImg.tag = indexPath.section;
//                [nameCell.btn_headerImg addTarget:self action:@selector(pushUserMessagePage:) forControlEvents:UIControlEventTouchUpInside];
//            }else{
                [nameCell.btn_delete setTitle:@"删除" forState:UIControlStateNormal];
                [nameCell.btn_delete setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                [nameCell.btn_delete addTarget:self action:@selector(deleteMonmentClick:) forControlEvents:UIControlEventTouchUpInside];
                nameCell.btn_delete.hidden = NO;
                nameCell.btn_delete.enabled = YES;
//            }
            
            if([MyUtil isEmptyString:[NSString stringWithFormat:@"%@",recentM.id]]){
                nameCell.btn_delete.enabled = NO;
            }
            return nameCell;
            
        }
            break;
        case 1://附近的cell 图片或者视频
        {
            if([recentM.attachType isEqualToString:@"0"]){//图片cell
                LYFriendsImgTableViewCell *imgCell = [tableView dequeueReusableCellWithIdentifier:LYFriendsImgCellID forIndexPath:indexPath];
                imgCell.recentModel = recentM;
                if (imgCell.btnArray.count) {
                    for (int i = 0;i < imgCell.btnArray.count; i ++) {
                        UIButton *btn = imgCell.btnArray[i];
                        btn.tag = 4 * indexPath.section + i + 1;
                        [btn addTarget:self action:@selector(checkImageClick:) forControlEvents:UIControlEventTouchUpInside];
                    }
                }
                return imgCell;
            }else{//视频cell
                LYFriendsVideoTableViewCell *videoCell = [tableView dequeueReusableCellWithIdentifier:LYFriendsVideoCellID forIndexPath:indexPath];
                NSString *urlStr = ((FriendsPicAndVideoModel *)recentM.lyMomentsAttachList[0]).imageLink;
                NSString *imageStr = ((FriendsPicAndVideoModel *)recentM.lyMomentsAttachList[0]).thumbnailUrl;
                videoCell.btn_play.tag = indexPath.section;
                if (![MyUtil isEmptyString:imageStr]) {
                    [videoCell.imgView_video sd_setImageWithURL:[NSURL URLWithString:[MyUtil getQiniuUrl:imageStr width:0 andHeight:0]] placeholderImage:[UIImage imageNamed:@"empyImage300"]];
                }else{
                    [videoCell.imgView_video sd_setImageWithURL:[NSURL URLWithString:[MyUtil getQiniuUrl:urlStr mediaType:QiNiuUploadTpyeDefault width:0 andHeight:0]] placeholderImage:[UIImage imageNamed:@"empyImage300"]];
                }
                
                [videoCell.btn_play addTarget:self action:@selector(playVideo:) forControlEvents:UIControlEventTouchUpInside];
                UIView *view = [videoCell viewWithTag:6611];
                if (indexPath.section != playerSection && view) {
                    [player.view removeFromSuperview];
                    [player removeFromParentViewController];
                }
                return videoCell;
            }
        }
            break;
            
        case 2://地址
        {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LYFriendsCellID forIndexPath:indexPath];
                return cell;
        }
            break;
            
        case 3://好友的赞
        {
            if(recentM.likeList.count){
                LYFriendsLikeTableViewCell *likeCell = [tableView dequeueReusableCellWithIdentifier:LYFriendsLikeCellID forIndexPath:indexPath];
                likeCell.btn_more.tag = indexPath.section;
                [likeCell.btn_more addTarget:self action:@selector(likeMoreClick:) forControlEvents:UIControlEventTouchUpInside];
                likeCell.recentM = recentM;
                for (int i = 0; i< likeCell.btnArray.count; i ++) {
                    UIButton *btn = likeCell.btnArray[i];
                    btn.tag = 7 * indexPath.section + i;
                    [btn addTarget:self action:@selector(zangBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                }
                return likeCell;
            }
            else{
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LYFriendsCellID forIndexPath:indexPath];
                return cell;
            }
        }
            break;
        default:{ //评论 4-8
            if(!recentM.commentList.count){//没有评论
                LYFriendsAllCommentTableViewCell *allCommentCell = [tableView dequeueReusableCellWithIdentifier:LYFriendsAllCommentCellID forIndexPath:indexPath];
                allCommentCell.label_commentCount.text = @"暂无评论";
                return allCommentCell;
            }
            NSInteger commentCount = 0;
            commentCount = recentM.commentList.count;
            if(recentM.commentList.count >= 5) commentCount = 5;
            if(indexPath.row == commentCount + 4) {//所有评论
                LYFriendsAllCommentTableViewCell *allCommentCell = [tableView dequeueReusableCellWithIdentifier:LYFriendsAllCommentCellID forIndexPath:indexPath];
                allCommentCell.recentM = recentM;
                return allCommentCell;
            }
            //评论
            FriendsCommentModel *commentModel = recentM.commentList[indexPath.row - 4];
            LYFriendsCommentTableViewCell *commentCell = [tableView dequeueReusableCellWithIdentifier:LYFriendsCommentCellID forIndexPath:indexPath];
            
            [self addTargetForBtn:commentCell.btn_firstName tag:indexPath.section indexTag:indexPath.row];
            [self addTargetForBtn:commentCell.btn_secondName tag:indexPath.section indexTag:indexPath.row];
            
            commentCell.btn_firstName.isFirst = YES;
            
            commentCell.commentM = commentModel;
            return commentCell;
        }
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FriendsRecentModel *recentM = _dataArray[indexPath.section];
    switch (indexPath.row) {
        case 0://头像和动态
        {
            
            NSString *topicNameStr = nil;
            if(recentM.topicTypeName.length) topicNameStr = [NSString stringWithFormat:@"#%@#",recentM.topicTypeName];
            NSMutableAttributedString *attributeStr = nil;
            if(recentM.topicTypeName.length){
                attributeStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@%@",topicNameStr,recentM.message]];
            }else{
                attributeStr = [[NSMutableAttributedString alloc]initWithString:recentM.message];
            }
            
            [attributeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, attributeStr.length )];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
            //            if(topicNameStr.length) paragraphStyle.firstLineHeadIndent = topicSize.width+3;
            [paragraphStyle setLineSpacing:3];
            [attributeStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attributeStr length])];
            CGSize size =  [attributeStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 70, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading context:nil].size;//计算富文本的高度
            if(![MyUtil isEmptyString:recentM.message]) {
                if(size.height >= 56) size.height = 56;
                size.height = size.height;
            }else{
                size.height = 0;
                if(![MyUtil isEmptyString:recentM.topicTypeName]){
                    size.height = 20;
                }
            }
            CGFloat height = size.height >= 10 ? size.height: 10;//打赏的高度
            return 60 + height ;
        }
            break;
            
        case 1://图片
        {
            NSArray *urlArray = [((FriendsPicAndVideoModel *)recentM.lyMomentsAttachList[0]).imageLink componentsSeparatedByString:@","];
            switch (urlArray.count) {
                case 1://一张图片
                {
                    return SCREEN_WIDTH - 70;
                }
                    break;
                case 2://2张图片
                {
                    return (SCREEN_WIDTH - 75)/2.f;
                }
                    break;
                case 3:{//3张图片
                    return (SCREEN_WIDTH - 75)/2.f + 5 + SCREEN_WIDTH - 70;
                }
                    break;
                    
                default://4张图片
                    return (SCREEN_WIDTH - 75) + 5;
                    break;
            }
            
        }
            break;
        case 2://地址
        {
            return 40;
        }
            break;
        case 3:
        {
            //有点赞的用户返回(SCREEN_WIDTH - 114)/8.f + 20;
            NSInteger count = recentM.likeList.count;
            return count == 0 ? 0 : (SCREEN_WIDTH - 114)/8.f + 20;
        }
            break;
        case 9:
        {
            return 36;
        }
            break;
            
            break;
        default://评论
        {
            if(!recentM.commentList.count) return 26;
            if(indexPath.row - 4 > recentM.commentList.count - 1) return 26;
            
            FriendsCommentModel *commentM = recentM.commentList[indexPath.row - 4];
            NSString *str = nil;
            if([commentM.toUserId isEqualToString:@"0"]) {
                str = [NSString stringWithFormat:@"%@：%@",commentM.nickName,commentM.comment];
            }else{
                str = [NSString stringWithFormat:@"%@ 回复 %@：%@d",commentM.nickName,commentM.toUserNickName,commentM.comment];
            }
            
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init
                                                       ];
            paragraphStyle.lineSpacing = 5;
            
            NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14], NSParagraphStyleAttributeName:paragraphStyle};
            
            
            
            NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:str];
            [attributedStr addAttributes:attributes range:NSMakeRange(0, attributedStr.length)];
            CGSize size = [attributedStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 70, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
            return size.height + 10;
        }
            break;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (isExidtEffectView) [emojisView hideEmojiEffectView];
    _section = indexPath.section;
    FriendsRecentModel *recentM = _dataArray[indexPath.section];
    if(indexPath.row == 0){//进去详情
        if([MyUtil isEmptyString:recentM.id]) return;
        [self pushFriendsMessageDetailVCWithIndex:indexPath.section];
    }
    if (indexPath.row >= 4 && indexPath.row <= 8) {
        if(!recentM.commentList.count) {//进入详情
            [self pushFriendsMessageDetailVCWithIndex:indexPath.section];
            return;
        }
        _indexRow = indexPath.row;
        if(indexPath.row - 4 == recentM.commentList.count)
        {
            [self pushFriendsMessageDetailVCWithIndex:indexPath.section];
            return;
        }
        FriendsCommentModel *commetnM = recentM.commentList[indexPath.row - 4];
        if ([commetnM.userId isEqualToString:_useridStr]) {//我发的评论
            UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:nil, nil];
            actionSheet.tag = 300;
            [actionSheet showInView:self.view];
        }else{//别人发的评论
            _isCommentToUser = YES;
            [self createCommentView];
        }
    }else if(indexPath.row == 9){
        [self pushFriendsMessageDetailVCWithIndex:indexPath.section];
    }
}

#pragma mark - 为cell 中评论的按钮绑定方法
- (void)addTargetForBtn:(LYFriendsCommentButton *)button tag:(NSInteger)tag indexTag:(NSInteger)indexTag{
    button.tag = tag;
    button.indexTag = indexTag;
    [button addTarget:self action:@selector(pushUserPage:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 点击动态中话题文字
- (void)topicNameClick:(UIButton *)button{
    FriendsRecentModel *friendRecentM = _dataArray[button.tag];
    if ([friendRecentM.isBarTopicType isEqualToString:@"0"]) {
        if (friendRecentM.topicTypeName.length && friendRecentM.topicTypeId.length) {
            LYFriendsTopicsViewController *friendsTopicVC = [[LYFriendsTopicsViewController alloc]init];
            friendsTopicVC.topicTypeId = friendRecentM.topicTypeId;
            friendsTopicVC.topicName = friendRecentM.topicTypeName;
            friendsTopicVC.isFriendToUserMessage = YES;
            friendsTopicVC.isFriendsTopic = YES;
            NSString *imageUrl = [MyUtil getQiniuUrl:friendRecentM.topicTypeBgUrl width:0 andHeight:0];
            friendsTopicVC.headerViewImgLink = imageUrl;
            
            friendsTopicVC.isTopic = YES;
            if([friendRecentM.isBarTopicType isEqualToString:@"0"]) friendsTopicVC.isFriendsTopic = YES;
            [self.navigationController pushViewController:friendsTopicVC animated:YES];
        }
    }else if(friendRecentM.isBarTopicType.length <= 0){
        return;
    }else{
        BeerNewBarViewController * controller = [[BeerNewBarViewController alloc] initWithNibName:@"BeerNewBarViewController" bundle:nil];
        
        controller.beerBarId = [NSNumber numberWithInt:[friendRecentM.isBarTopicType intValue]];
        [self.navigationController pushViewController:controller animated:YES];
        //        [MTA trackCustomKeyValueEvent:LYCLICK_MTA props:[self createMTADctionaryWithActionName:@"跳转" pageName:@"" titleName:jiuBaM.barname]];
    }
}

#pragma mark - 举报弹框
- (void)jubaoDT{
    
    //    if(!_index){
    //        NSArray *dataArr = _dataArray[_index];
    //        FriendsRecentModel *recentM = dataArr[button.tag];
    //        jubaoMomentID = recentM.id;
    //        jubaoUserID = recentM.userId;
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"选择举报原因" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"污秽色情",@"垃圾广告",@"其他原因", nil];
    actionSheet.tag = 400;
    [actionSheet showInView:self.view];
    //    }
}

- (void)warningSheet:(UIButton *)button{
    if(!_index){
        FriendsRecentModel *recentM = _dataArray[button.tag];
        jubaoMomentID = recentM.id;
        jubaoUserID = recentM.userId;
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"屏蔽此人",@"举报内容", nil];
        actionSheet.tag = 131;
        [actionSheet showInView:self.view];
    }
}

#pragma mark - 点击头像跳转到指定用户界面
- (void)pushUserMessagePage:(UIButton *)button{
    FriendsRecentModel *recentM = _dataArray[button.tag];
    //    if([recentM.userId isEqualToString:_useridStr]) return;
    if([recentM.userId isEqualToString:_useridStr] || [MyUtil isEmptyString:recentM.userId]) {
        return;
    }
    
    LYMyFriendDetailViewController *myFriendVC = [[LYMyFriendDetailViewController  alloc]initWithNibName:@"LYMyFriendDetailViewController" bundle:nil];
    myFriendVC.userID = recentM.userId;
    [self.navigationController pushViewController:myFriendVC animated:YES];
}

#pragma mark － 删除我的动态
- (void)deleteMonmentClick:(UIButton *)button{
    if (isExidtEffectView) [emojisView hideEmojiEffectView];
    
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"确定删除这条动态" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
        _deleteMessageTag = button.tag;
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex) {//删除我的动态
        FriendsRecentModel *recentM = _dataArray[_deleteMessageTag];
        if(![MyUtil isUserLogin]){
            [MyUtil showCleanMessage:@"请先登录！"];
            [MyUtil gotoLogin];
            return;
        }
        NSDictionary *paraDic = @{@"userId":_useridStr,@"messageId":recentM.id};
        [LYFriendsHttpTool friendsDeleteMyMessageWithParams:paraDic compelte:^(bool result) {
            if (result) {
                [_dataArray removeObjectAtIndex:_deleteMessageTag];
                //                [tableView reloadData];
                
                [_userTablewView deleteSections:[NSIndexSet indexSetWithIndex:_deleteMessageTag] withRowAnimation:UITableViewRowAnimationTop];
            }
        }];
    }
}

#pragma mark - 打赏
-(void)dashangAction{
    _daShangView = [[DaShangView alloc] init];

    _daShangView.frame = CGRectMake(10, SCREEN_HEIGHT / 4, SCREEN_WIDTH - 20, 300);
    _daShangView.backgroundColor = [UIColor whiteColor];
    _daShangView.layer.cornerRadius = 3.f;
    _daShangView.layer.masksToBounds = YES;
    //    _daShangView.giftCollectionView.delegate = self;
    _daShangView.giftCollectionView.tag = 888;
    [self.view addSubview:_daShangView];
    [self.view bringSubviewToFront:_daShangView];
    _daShangView.sendGiftButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    _daShangView.sendGiftButton.backgroundColor = COMMON_PURPLE;
    [_daShangView.sendGiftButton addTarget:self action:@selector(sendGiftButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    //获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(notice:) name:@"sendGift" object:nil];
}

-(void)sendGiftButtonAction:(UIButton *)sender{
    switch (_giftNumber) {
        case 0:
            break;
        case 1://单个送
            [MyUtil showMessage:[NSString stringWithFormat:@"%ld",_giftValue]];
            break;
            
        default:
            [MyUtil showMessage:@"壕！一次送一个呦"];
            return;
            break;
    }
    [_daShangView removeFromSuperview];
    _daShangView = nil;
}

-(void)notice:(NSNotification *)notification{
    _giftValue = [notification.userInfo[@"value"] integerValue];
    _giftNumber = [notification.userInfo[@"number"] integerValue];
}



#pragma mark - 表白action
- (void)likeFriendsClick:(UIButton *)button{
    if(![MyUtil isUserLogin]){
        [MyUtil showCleanMessage:@"请先登录！"];
        [MyUtil gotoLogin];
        return;
    }
    if (isExidtEffectView) [emojisView hideEmojiEffectView];
    LYFriendsAddressTableViewCell *cell = (LYFriendsAddressTableViewCell *)[_userTablewView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:button.tag]];
    cell.btn_like.enabled = NO;
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    FriendsRecentModel *recentModel = _dataArray[button.tag];
    NSString *likeStr = nil;
    if ([[NSString stringWithFormat:@"%@",recentModel.liked] isEqual:@"0"]) {//未表白过
        likeStr = @"1";
    }else{
        likeStr = @"0";
    }
    NSDictionary *paraDic = @{@"userId":_useridStr,@"messageId":recentModel.id,@"type":likeStr};
    if ([likeStr isEqualToString:@"1"]) {
        if (!emojiEffectView) {
            emojisView = [EmojisView shareInstanse];
        }
        [emojisView windowShowEmoji:@{@"emojiName":@"dianzan",
                                      @"emojiNumber":@"24"}];
    }
    
    [LYFriendsHttpTool friendsLikeMessageWithParams:paraDic compelte:^(bool result) {
        if (![USER_DEFAULT objectForKey:@"firstUseFriendLike"]) {
            float distance = button.superview.superview.frame.origin.y - _userTablewView.contentOffset.y;
            imageSubview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            //            imageSubview.backgroundColor = RGBA(0, 0, 0, 0.1);
            imageSubview.backgroundColor = [UIColor clearColor];
            //            imageSubview.tag = 541127;
            UITapGestureRecognizer *tapImageSubview = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideDefaultPage)];
            [imageSubview addGestureRecognizer:tapImageSubview];
            
            imageView = [[UIImageView alloc]init];
            //            imageView.tag = 541128;
            imageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tapImageTip = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImageTip:)];
            [imageView addGestureRecognizer:tapImageTip];
            
            
            
            //            [weakSelf.view addSubview:imageSubview];
            [((AppDelegate *)[UIApplication sharedApplication].delegate).window addSubview:imageSubview];
            if (distance < SCREEN_HEIGHT / 2) {
                //                imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"emojiTIpBottom"]];
                [imageView setImage:[UIImage imageNamed:@"emojiTIpBottom"]];
                [imageView setFrame:CGRectMake(SCREEN_WIDTH - 260, distance + 20, 206, 93)];
            }else{
                //                imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"emojiTIpTop"]];
                [imageView setImage:[UIImage imageNamed:@"emojiTIpTop"]];
                [imageView setFrame:CGRectMake(SCREEN_WIDTH - 260, distance - 68, 206, 93)];
            }
            [imageSubview addSubview:imageView];
        }
        if (result) {//点赞成功
            FriendsLikeModel *likeModel = [[FriendsLikeModel alloc]init];
            likeModel.icon = app.userModel.avatar_img;
            likeModel.userId = _useridStr;
            //            NSMutableArray *array = recentM.likeList;
            [recentModel.likeList insertObject:likeModel atIndex:0];
            recentModel.liked = @"1";
        }else{
            //            NSMutableArray *array = recentModel.
            for (int i = 0;i < recentModel.likeList.count ; i++) {
                FriendsLikeModel *likeM = recentModel.likeList[i];
                if ([likeM.userId isEqualToString:_useridStr]) {
                    [recentModel.likeList removeObject:likeM];
                }
            }
            recentModel.liked = @"0";
        }
//        if ([_delegate respondsToSelector:@selector(lyRecentMessageLikeChange:)]) {
//            [_delegate lyRecentMessageLikeChange:recentModel.liked];
//        }
        [_userTablewView reloadData];
        cell.btn_like.enabled = YES;
    }];
}
#pragma mark － 长按表白
- (void)likeLongPressClick:(UILongPressGestureRecognizer *)gesture{
   
    isExidtEffectView = YES;
    gestureViewTag = (int)gesture.view.tag;
    if (!emojiEffectView) {
        emojisView = [EmojisView shareInstanse];
        //        emojisView.delegate = self;
        NSDictionary *dict = [emojisView getEmojisView];
        emojiEffectView = [dict objectForKey:@"emojiEffectView"];
        emoji_angry = [[dict objectForKey:@"emojiButtons"]objectAtIndex:0];
        emoji_sad = [[dict objectForKey:@"emojiButtons"]objectAtIndex:1];
        emoji_wow = [[dict objectForKey:@"emojiButtons"]objectAtIndex:2];
        emoji_kawayi = [[dict objectForKey:@"emojiButtons"]objectAtIndex:3];
        emoji_happy = [[dict objectForKey:@"emojiButtons"]objectAtIndex:4];
        emoji_zan = [[dict objectForKey:@"emojiButtons"]objectAtIndex:5];
    }
    emojisView.delegate = self;
    
    [[UIApplication sharedApplication].delegate.window bringSubviewToFront:emojiEffectView];
    [[UIApplication sharedApplication].delegate.window bringSubviewToFront:emoji_angry];
    [[UIApplication sharedApplication].delegate.window bringSubviewToFront:emoji_sad];
    [[UIApplication sharedApplication].delegate.window bringSubviewToFront:emoji_wow];
    [[UIApplication sharedApplication].delegate.window bringSubviewToFront:emoji_kawayi];
    [[UIApplication sharedApplication].delegate.window bringSubviewToFront:emoji_happy];
    [[UIApplication sharedApplication].delegate.window bringSubviewToFront:emoji_zan];
    
    [[UIApplication sharedApplication].delegate.window addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:emojisView action:@selector(hideEmojiEffectView)]];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
        [emojiEffectView setFrame:CGRectMake(0, 0, 80, SCREEN_HEIGHT)];
    } completion:^(BOOL finished) {
        //
    }];
    
    NSArray *emojiArr = @[emoji_angry,emoji_sad,emoji_wow,emoji_kawayi,emoji_happy,emoji_zan];
    for (int i = 0 ; i < emojiArr.count; i ++) {
        UIButton *emojiBtn = [emojiArr objectAtIndex:i];
        double y = emojiBtn.frame.origin.y;
        [UIView animateWithDuration:0.8 delay:i * 0.1 usingSpringWithDamping:0.3 initialSpringVelocity:0.3 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            [emojiBtn setFrame:CGRectMake(0, y, 80, 40)];
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)likeFriendsClickEmoji:(NSString *)likeType{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if(![MyUtil isUserLogin]){
        [MyUtil showCleanMessage:@"请先登录！"];
        [MyUtil gotoLogin];
        return;
    }
    LYFriendsAddressTableViewCell *cell = (LYFriendsAddressTableViewCell *)[_userTablewView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:gestureViewTag]];
    cell.btn_like.enabled = NO;
    FriendsRecentModel *recentM = _dataArray[gestureViewTag];
    NSDictionary *paraDic = @{@"userId":_useridStr,
                              @"messageId":recentM.id,
                              @"type":@"1",
                              @"likeType":likeType};
    [LYFriendsHttpTool friendsLikeMessageWithParams:paraDic compelte:^(bool result) {
        if (result) {//点赞成功
            if ([recentM.liked isEqualToString:@"1"]) {
                //之前已经点赞过
                for (int i = 0; i< recentM.likeList.count;i ++) {
                    FriendsLikeModel *likeM = recentM.likeList[i];
                    if ([likeM.userId isEqualToString:_useridStr]) {
                        [recentM.likeList removeObject:likeM];
                        break;
                    }
                }
                //删除点赞［前记录］
            }
            //增加点赞［］
            FriendsLikeModel *likeModel = [[FriendsLikeModel alloc]init];
            likeModel.icon = app.userModel.avatar_img;
            likeModel.userId = _useridStr;
            [recentM.likeList insertObject:likeModel atIndex:0];
            likeModel.likeType = likeType;
            recentM.liked = @"1";
        }else{
            for (int i = 0; i< recentM.likeList.count;i ++) {
                FriendsLikeModel *likeM = recentM.likeList[i];
                if ([likeM.userId isEqualToString:_useridStr]) {
                    [recentM.likeList removeObject:likeM];
                }
            }
            recentM.liked = @"0";
        }
        [_userTablewView reloadData];
    }];
}

#pragma mark - 更多赞
- (void)likeMoreClick:(UIButton *)button{
    [self pushFriendsMessageDetailVCWithIndex:button.tag];
}

#pragma mark － 跳转消息详情页面
- (void)pushFriendsMessageDetailVCWithIndex:(NSInteger)index{
    FriendsRecentModel *recentM = _dataArray[index];
    LYFriendsAMessageDetailViewController *messageDetailVC = [[LYFriendsAMessageDetailViewController alloc]init];
    //    messageDetailVC.recentM = recentM;
    messageDetailVC.recentM = recentM;
    messageDetailVC.isFriendToUserMessage = YES;
    messageDetailVC.isMessageDetail = YES;
    [self.navigationController pushViewController:messageDetailVC animated:YES];
}

#pragma mark - 赞的人头像
- (void)zangBtnClick:(UIButton *)button{
    if (isExidtEffectView) [emojisView hideEmojiEffectView];
    NSInteger i = button.tag % 7;
    NSInteger section = button.tag / 7 ;
    if(section >=0 && i>=0){
        FriendsRecentModel *recentM = _dataArray[section];
        if(i >= recentM.likeList.count) return;
        
        FriendsLikeModel *likeM = recentM.likeList[i];
        if ([likeM.userId isEqualToString:_useridStr]) {//如果头像是自己return
            return;
        }
        
        //跳转到朋友详情页面
        LYMyFriendDetailViewController *myFriendVC = [[LYMyFriendDetailViewController  alloc]initWithNibName:@"LYMyFriendDetailViewController" bundle:nil];
        myFriendVC.userID = likeM.userId;
        [self.navigationController pushViewController:myFriendVC animated:YES];
    }
}

#pragma mark － 评论点击头像跳转到指定用户界面
- (void)pushUserPage:(LYFriendsCommentButton *)button{
    FriendsRecentModel *recentM = _dataArray[button.tag];
    if(button.indexTag - 4 >= recentM.commentList.count) return;
    FriendsCommentModel *commentModel = recentM.commentList[button.indexTag - 4];
    
    NSString *idStr = nil;
    if (button.isFirst) {//fist
        idStr = commentModel.userId;
    }else{
        idStr = commentModel.toUserId;
    }
    
    if([idStr isEqualToString:_useridStr]) return;
    
    LYMyFriendDetailViewController *myFriendVC = [[LYMyFriendDetailViewController  alloc]initWithNibName:@"LYMyFriendDetailViewController" bundle:nil];
    myFriendVC.userID = idStr;
    [self.navigationController pushViewController:myFriendVC animated:YES];
}

#pragma mark - 视频播放
- (void)playVideo:(UIButton *)button{
    playerSection = button.tag;
    FriendsRecentModel *recentM = (FriendsRecentModel *)_dataArray[button.tag];
    FriendsPicAndVideoModel *pvM = (FriendsPicAndVideoModel *)recentM.lyMomentsAttachList[0];
    
    QiNiuUploadTpye quType = [MyUtil configureNetworkConnect] == 1 ? QiNiuUploadTpyeSmallMedia : QiNiuUploadTpyeMedia;
    
    NSURL *url;
    if ([LYDateUtil isMoreThanFiveMinutes:recentM.date]) {
        url = [NSURL URLWithString:[MyUtil getQiniuUrl:pvM.imageLink mediaType:quType width:0 andHeight:0]] ;
    }else{
        url = [NSURL URLWithString:[MyUtil getQiniuUrl:pvM.imageLink mediaType:QiNiuUploadTpyeBigMedia width:0 andHeight:0]];
    }
    
    if (recentM.isMeSendMessage){
        url = [[NSURL alloc] initFileURLWithPath:pvM.imageLink];
        
    }
    
    
    if (player.moviePlayer.playbackState != MPMoviePlaybackStateStopped) {
        //不是正常停止
        isDisturb = YES;
    }
    
    [player.view removeFromSuperview];
    
    friendsVedioCell = [_userTablewView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:button.tag]];
    player = [[MPMoviePlayerViewController alloc]initWithContentURL:url];
    player.moviePlayer.scalingMode = MPMovieScalingModeAspectFill;
    player.view.frame = friendsVedioCell.imgView_video.frame;
    player.view.tag = 6611;
    player.moviePlayer.controlStyle = MPMovieControlStyleDefault;
    [friendsVedioCell addSubview:player.view];
    
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playerWillPlay) name:MPMoviePlayerPlaybackStateDidChangeNotification object:player.moviePlayer];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playerWillPlay) name:MPMoviePlayerLoadStateDidChangeNotification object:player.moviePlayer];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playerWillPlay) name:MPMoviePlayerScalingModeDidChangeNotification object:player.moviePlayer];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playerDidFinishPlay) name:MPMoviePlayerPlaybackDidFinishNotification object:player.moviePlayer];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playerDidPlay) name:MPMoviePlayerDidExitFullscreenNotification object:player.moviePlayer];
    
    isDisturb = NO;
    
}

- (void)playerDidFinishPlay{
    player.moviePlayer.scalingMode = MPMovieScalingModeFill;
    if (isDisturb == NO) {
        [UIView animateWithDuration:0.5 animations:^{
            player.view.alpha = 0 ;
        } completion:^(BOOL finished) {
            [player.view removeFromSuperview];
            [[UIApplication sharedApplication] setStatusBarHidden:NO];
        }];
    }
}
- (void)playerWillPlay{
    player.moviePlayer.scalingMode = MPMovieScalingModeAspectFill;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)playerDidPlay{
    player.moviePlayer.scalingMode = MPMovieScalingModeFill;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (BOOL)shouldAutorotate{
    return YES;
}


#pragma mark - 作为代理收取视频路径地址与截图
- (void)sendVedio:(NSString *)mediaUrl andImage:(UIImage *)image andContent:(NSString *)content andLocation:(NSString *)location andTopicID:(NSString *)topicID andTopicName:(NSString *)topicName{
    NSDictionary *dic = @{@"attachType":@"1",@"content":content,@"location":location,@"topicID":topicID,@"topicName":topicName};
    FriendsRecentModel *recentM = [self createModelForISendAMessageWithDicForMessage:dic];
    recentM.thunbImage = image;
    FriendsPicAndVideoModel *pvModel = [[FriendsPicAndVideoModel alloc]init];
    pvModel.imageLink = mediaUrl;
    [[SDWebImageManager sharedManager] saveImageToCache:image forURL:[NSURL URLWithString:[MyUtil  getQiniuUrl:mediaUrl mediaType:QiNiuUploadTpyeDefault width:0 andHeight:0]]];//利用sdwebImage把自己发的动态图片缓存道本地（下面同理）
    _saveImageAndVideoIndex ++;
    recentM.lyMomentsAttachList = @[pvModel];
    
    if(_dataArray.count) [_dataArray insertObject:recentM atIndex:0];
    [_userTablewView reloadData];
}

#pragma mark - 作为代理接受返回的图片
- (void)sendImagesArray:(NSArray *)imagesArray andContent:(NSString *)content andLocation:(NSString *)location andTopicID:(NSString *)topicID andTopicName:(NSString *)topicName{
    NSDictionary *dic = @{@"attachType":@"0",@"content":content,@"location":location,@"topicID":topicID,@"topicName":topicName};
    FriendsRecentModel *recentM = [self createModelForISendAMessageWithDicForMessage:dic];
    
    FriendsPicAndVideoModel *pvModel = [[FriendsPicAndVideoModel alloc]init];
    NSString *imageLink = nil;
    NSString *appendLink = nil;
    CGFloat picWidth = 0;
    for (int i = 0;i < imagesArray.count;i ++) {
        UIImage *image = imagesArray[i];
        pvModel.imageLink = [pvModel.imageLink stringByAppendingString:[[NSString stringWithFormat:@"myPicture%ld%d",(long)_saveImageAndVideoIndex,i] stringByAppendingString:@","]];
        
        appendLink = [NSString stringWithFormat:@"myPicture%ld%d,",(long)_saveImageAndVideoIndex,i];
        if(i == imagesArray.count - 1) appendLink = [NSString stringWithFormat:@"myPicture%ld%d",(long)_saveImageAndVideoIndex,i];
        
        if(!i) imageLink = appendLink;
        else imageLink = [imageLink stringByAppendingString:appendLink];
        
        picWidth = imagesArray.count == 1 ? 0 : 450;
        
        [[SDWebImageManager sharedManager] saveImageToCache:image forURL:[NSURL URLWithString:[MyUtil getQiniuUrl:[NSString stringWithFormat:@"myPicture%ld%d",(long)_saveImageAndVideoIndex,i] width:0 andHeight:0]]];
        _saveImageAndVideoIndex ++;
        
    }
    pvModel.imageLink = imageLink;
    recentM.lyMomentsAttachList = @[pvModel];
    
    if(_dataArray.count) [_dataArray insertObject:recentM atIndex:0];
    
    [_userTablewView reloadData];
    
}

#pragma mark - 创建自己发布动态的Model
- (FriendsRecentModel *)createModelForISendAMessageWithDicForMessage:(NSDictionary *)messageDic{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    FriendsRecentModel *recentM = [[FriendsRecentModel alloc]init];
    recentM.attachType = [messageDic objectForKey:@"attachType"];
    recentM.username = app.userModel.username;
    recentM.userId = [NSString stringWithFormat:@"%d",app.userModel.userid];
    recentM.usernick = app.userModel.usernick;
    recentM.avatar_img = app.userModel.avatar_img;
    NSDateFormatter *dateFmt = [[NSDateFormatter alloc]init];
    [dateFmt setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    recentM.date = [dateFmt stringFromDate:[NSDate date]];
    recentM.tags = app.userModel.tags;
    recentM.birthday = app.userModel.birthday;
    recentM.message = [messageDic objectForKey:@"content"];
    recentM.liked = @"0";
    recentM.isMeSendMessage = YES;
    recentM.commentList = [[NSMutableArray alloc]init];
    recentM.likeList = [[NSMutableArray alloc]init];
    recentM.location = [messageDic objectForKey:@"location"];
    
    NSString *topicID = [messageDic objectForKey:@"topicID"];
    NSString *topicName = [messageDic objectForKey:@"topicName"];
    if (topicID.length && topicName.length) {
        recentM.topicTypeId = topicID;
        NSArray *strArray = [topicName componentsSeparatedByString:@"#"];
        if(strArray.count >= 2) recentM.topicTypeName = strArray[1];
    }else{
        recentM.topicTypeId = @"";
        recentM.topicTypeName = @"";
    }
    return recentM;
}

#pragma mark - sendSuccess
- (void)sendSucceed:(NSString *)messageId{//发布成功件欧重新刷新表
    
        if(_dataArray.count){
            FriendsRecentModel *recentM = _dataArray[0];
            recentM.id = [NSString stringWithFormat:@"%@",messageId];
        }
        [_userTablewView reloadData];
}

#pragma mark - 隐藏引导页
- (void)hideDefaultPage{
  
    [imageSubview removeFromSuperview];
    [imageView removeFromSuperview];

}

- (void)hideImageTip:(UIGestureRecognizer *)gesture{
    [USER_DEFAULT setObject:@"NO" forKey:@"firstUseFriendLike"];
    [imageSubview removeFromSuperview];
    [imageView removeFromSuperview];
}

#pragma mark - 拍照action

- (void)willPresentActionSheet:(UIActionSheet *)actionSheet{
    NSArray *subviews = actionSheet.subviews;
    for (UIView *view in subviews) {
        //        if ([view isKindOfClass:[UIButton class]]) {
        UIButton *btn = (UIButton *)view;
        [btn setTitleColor:RGBA(143, 2, 195, 1) forState:UIControlStateNormal];
        //        }
    }
}

#pragma mark 发布动态
- (void)carmerClick:(UIButton *)carmerClick{
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册",@"短视频", nil];
    actionSheet.tag = 100;
    [actionSheet showInView:self.view];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(FriendSendViewDidLoad) name:@"FriendSendViewDidLoad" object:nil];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(actionSheet.tag == 200){
        switch (buttonIndex) {
            case 0://更该相册封面
            {
                LYChangeImageViewController *changeImageVC = [[LYChangeImageViewController alloc]init];
                [self.navigationController pushViewController:changeImageVC animated:YES];
                [changeImageVC setPassImage:^(NSString *imageurl,UIImage *image) {
                    _headerView.ImageView_bg.image = image;
                    _userBgImageUrl = [MyUtil getQiniuUrl:imageurl width:0 andHeight:0];
                    NSData *imageData = UIImagePNGRepresentation(image);
                    [[NSUserDefaults standardUserDefaults] setObject:imageData forKey:@"FriendUserBgImage"];
                }];
            }
                break;
                
            default:
                break;
        }
    }else if(actionSheet.tag == 100){
        switch (buttonIndex) {
            case 0://拍照
            {
                [self takePhotoActionClick];
            }
                break;
            case 1://相册
            {
                [self photosActionClick];
                
            }
                break;
            case 2://短视频
            {
                [self filmingActionClick];
            }
                break;
            default:
                break;
        }
    }else if(actionSheet.tag == 300){
        if (!buttonIndex) {//删除我的评论
            
            FriendsRecentModel *recetnM = _dataArray[_section];
            FriendsCommentModel *commentM = recetnM.commentList[_indexRow - 4];
            if(![MyUtil isUserLogin]){
                [MyUtil showCleanMessage:@"请先登录！"];
                [MyUtil gotoLogin];
                return;
            }
            NSDictionary *paraDic = @{@"userId":_useridStr,@"commentId":commentM.commentId};
            [LYFriendsHttpTool friendsDeleteMyCommentWithParams:paraDic compelte:^(bool result) {
                if(result){
                    NSMutableArray *commentArr = ((FriendsRecentModel *)_dataArray[_section]).commentList;
                    [commentArr removeObjectAtIndex:_indexRow - 4];
                    recetnM.commentNum = [NSString stringWithFormat:@"%d",recetnM.commentNum.intValue - 1];
                    [_userTablewView reloadData];
                }
            }];
        }
    }else if (actionSheet.tag == 400){
        NSString *message;
        if (buttonIndex == 0) {
            message = @"污秽色情";
        }else if (buttonIndex == 1){
            message = @"垃圾广告";
        }else if (buttonIndex == 2){
            message = @"其他原因";
        }
        if (buttonIndex != 3) {
            AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
            
            NSDictionary *dict = @{@"reportedUserid":jubaoUserID,
                                   @"momentId":jubaoMomentID,
                                   @"message":message,
                                   @"userid":[NSString stringWithFormat:@"%d",app.userModel.userid]};
            [LYFriendsHttpTool friendsJuBaoWithParams:dict complete:^(NSString *message) {
                //                [MyUtil showCleanMessage:message];
                [MyUtil showPlaceMessage:message];
            }];
        }
    }else if (actionSheet.tag == 131){
        if (buttonIndex == 0) {
            NSDictionary *dict = @{@"shieldUserid":jubaoUserID};
            [LYFriendsHttpTool friendsPingBiUserWithParams:dict complete:^(NSString *message) {
                [MyUtil showLikePlaceMessage:message];
                [_userTablewView.mj_header beginRefreshing];
            }];
        }else if (buttonIndex == 1){
            [self jubaoDT];
        }
    }
}


#pragma mark 选择完后根据点击的按钮进行操作
- (void)photosActionClick{
    if(self.pagesCount <= 0){
        return;//给出提示
    }
    _typeOfImagePicker = @"photos";
    ImagePickerViewController *imagePicker = [[ImagePickerViewController alloc]init];
    imagePicker.imagesCount = self.pagesCount;
    imagePicker.delegate = self;
    imagePicker.title = @"相册";
    [self.navigationController pushViewController:imagePicker animated:YES];
    
    //    YBImgPickerViewController *ybImagePicker = [[YBImgPickerViewController alloc]init];
    //    ybImagePicker.photoCount = self.pagesCount;
    //    [ybImagePicker showInViewContrller:self choosenNum:0 delegate:self];
}

- (void)takePhotoActionClick{
    if(self.pagesCount <= 0){
        return;//给出提示
    }
    _typeOfImagePicker = @"takePhoto";
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}

- (void)filmingActionClick{
    if(self.pagesCount < 4){
        return;//给出提示
    }
    _typeOfImagePicker = @"filming";
    [self presentViewController:self.imagePicker animated:YES completion:nil];
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mediaPlayerThumbnailRequestFinished:) name:MPMoviePlayerThumbnailImageRequestDidFinishNotification object:self.player];
}

#pragma mark 选择拍照或拍摄后的操作
- (UIImagePickerController *)imagePicker{
    _imagePicker = [[UIImagePickerController alloc]init];
    if([_typeOfImagePicker isEqualToString:@"takePhoto"]){//拍照
        _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;//拍照
        _imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;//后置摄像头
        _imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
    }else if([_typeOfImagePicker isEqualToString:@"filming"]){//小视频
        _imagePicker.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeMovie];
        _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;//摄影
        _imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;//后置摄像头
        _imagePicker.videoQuality = UIImagePickerControllerQualityTypeIFrame1280x720;
        _imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;//设置摄像头模式
        _imagePicker.videoMaximumDuration = 10;
    }
    _imagePicker.editing = YES;
    _imagePicker.delegate = self;
    return _imagePicker;
}

#pragma mark 选择玩照片后的操作
- (void)ImagePickerDidFinishWithImages:(NSArray *)imageArray{
    friendsSendVC = [[LYFriendsSendViewController alloc]initWithNibName:@"LYFriendsSendViewController" bundle:[NSBundle mainBundle]];
    friendsSendVC.delegate = self;
    [self.navigationController pushViewController:friendsSendVC animated:YES];
    /**
     */
    //        [self YBImagePickerDidFinishWithImages:imageArray];
    [_notificationDict setObject:imageArray forKey:@"info"];
}

- (void)YBImagePickerDidFinishWithImages:(NSArray *)imageArray{
    friendsSendVC = [[LYFriendsSendViewController alloc]initWithNibName:@"LYFriendsSendViewController" bundle:[NSBundle mainBundle]];
    friendsSendVC.delegate = self;
    [self.navigationController pushViewController:friendsSendVC animated:YES];
    /**
     */
    //        [self YBImagePickerDidFinishWithImages:imageArray];
    [_notificationDict setObject:imageArray forKey:@"info"];
}

#pragma mark imagepicker的代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [self dismissViewControllerAnimated:YES completion:nil];
    friendsSendVC = [[LYFriendsSendViewController alloc]initWithNibName:@"LYFriendsSendViewController" bundle:[NSBundle mainBundle]];
    friendsSendVC.delegate = self;
    [self.navigationController pushViewController:friendsSendVC animated:YES];
    /**
     */
    //    self.friendsSendVC.typeOfImagePicker = self.typeOfImagePicker;
    //    [self.friendsSendVC imagePickerSpecificOperation:info];
    //    _notificationDict = [[NSMutableDictionary alloc]init];
    [_notificationDict setObject:info forKey:@"info"];
}


#pragma mark 等待下一个页面load以后再进行操作
- (void)FriendSendViewDidLoad{
    if([_typeOfImagePicker isEqualToString:@"photos"]){
        [friendsSendVC YBImagePickerDidFinishWithImages:[_notificationDict objectForKey:@"info"]];
    }else if ([_typeOfImagePicker isEqualToString:@"takePhoto"] || [_typeOfImagePicker isEqualToString:@"filming"]){
        friendsSendVC.typeOfImagePicker = self.typeOfImagePicker;
        [friendsSendVC imagePickerSpecificOperation:[_notificationDict objectForKey:@"info"]];
    }
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
#pragma mark - 评论action
- (void)commentClick:(UIButton *)button{
    _commentBtnTag = button.tag;
    _isCommentToUser = NO;//不对他人评论
    if (isExidtEffectView) [emojisView hideEmojiEffectView];
    [self createCommentView];//创建评论视图
}

#pragma mark － 创建commentView
- (void)createCommentView{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBorderApearce:) name:UIKeyboardWillChangeFrameNotification object:nil];
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    
    _bigView = [[UIView alloc]init];
    _bigView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bigViewGes)];
    [_bigView addGestureRecognizer:tapGes];
    [window addSubview:_bigView];
    
    _commentView = [[[NSBundle mainBundle]loadNibNamed:@"LYFriendsCommentView" owner:nil options:nil] firstObject];
    _commentView.frame = CGRectMake(0, SCREEN_HEIGHT , SCREEN_WIDTH, 58);
    _commentView.bgView.layer.borderColor = RGBA(200,200,200, .2).CGColor;
    _commentView.bgView.layer.borderWidth = 0.5;
    [_bigView addSubview:_commentView];
    
    [_commentView.textField becomeFirstResponder];
    _commentView.textField.delegate = self;
    /**
     WTT
     */
    if (defaultComment && ![defaultComment isEqualToString:@""]) {
        _commentView.textField.text = defaultComment;
    }
    
    [_commentView.btn_emotion addTarget:self action:@selector(emotionClick:) forControlEvents:UIControlEventTouchUpInside];
    if(_isCommentToUser){
        FriendsRecentModel *recentM = (FriendsRecentModel *)_dataArray[_section];
        if(!recentM.commentList.count) return;
        FriendsCommentModel *commentM = recentM.commentList[_indexRow - 4];
        _commentView.textField.placeholder = [NSString stringWithFormat:@"回复%@",commentM.nickName];
    }
    
    [_commentView.textField addObserver:self forKeyPath:@"text" options:(NSKeyValueObservingOptionNew) context:nil];
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
    //    NSString *keybordHeight = note.userInfo[@"UIKeyboardFrameEndUserInfoKey"];
    CGRect rect = [note.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    [UIView animateWithDuration:.25 animations:^{
        _commentView.frame = CGRectMake(0, SCREEN_HEIGHT - rect.size.height - 49, SCREEN_WIDTH, 49);
    }];
}

//评论视图背景view 的手势去除评论view
- (void)bigViewGes{
    //    if (_commentView.textField.text.length) {
    defaultComment = _commentView.textField.text;
    //    }
    [_commentView.textField removeObserver:self forKeyPath:@"text"];
    [_bigView removeFromSuperview];
    
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

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_commentView.textField removeObserver:self forKeyPath:@"text"];
    [_bigView removeFromSuperview];
    [textField endEditing:YES];
    if(!_commentView.textField.text.length) return NO;
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    FriendsRecentModel *recentM = nil;
    NSString *toUserId = nil;
    NSString *toUserNickName = nil;
    if (_isCommentToUser) {//对其他人回复
        recentM = _dataArray[_section];
        FriendsCommentModel *commentModel = recentM.commentList[_indexRow - 4];
        toUserId = commentModel.userId;
        toUserNickName = commentModel.nickName;
    }else{//自己对动态评论
        recentM = _dataArray[_commentBtnTag];
        toUserId = @"";
        toUserNickName = @"";
    }
    if(_commentView.textField.text.length > 200) {
        [MyUtil showCleanMessage:@"内容太多，200字以内"];
        return NO;
    }
    if(![MyUtil isUserLogin]){
        [MyUtil showCleanMessage:@"请先登录！"];
        [MyUtil gotoLogin];
        return NO;
    }
    NSDictionary *paraDic = @{@"userId":_useridStr,@"messageId":recentM.id,@"toUserId":toUserId,@"comment":_commentView.textField.text};
    [LYFriendsHttpTool friendsCommentWithParams:paraDic compelte:^(bool resutl,NSString *commentId) {
        if (resutl) {//评论成功后本地创建评论Model
            defaultComment = nil;
            FriendsCommentModel *commentModel = [[FriendsCommentModel alloc]init];
            commentModel.comment = _commentView.textField.text;
            commentModel.icon = app.userModel.avatar_img;
            commentModel.nickName = app.userModel.usernick;
            commentModel.userId = _useridStr;
            commentModel.commentId = commentId;
            if(toUserId.length) {
                commentModel.toUserId = toUserId;
                commentModel.toUserNickName = toUserNickName;
            }
            else {
                commentModel.toUserId = @"0";
                commentModel.toUserNickName = @"";
            }
            if(!_isMessageDetail){
                if(recentM.commentList.count == 5) [recentM.commentList removeObjectAtIndex:0];
            }
            [recentM.commentList addObject:commentModel];
            recentM.commentNum = [NSString stringWithFormat:@"%d",recentM.commentNum.intValue + 1];
            [_userTablewView reloadData];
        }
    }];
    return YES;
}

#pragma mark - 查看图片
- (void)checkImageClick:(UIButton *)button{
    if (isExidtEffectView) [emojisView hideEmojiEffectView];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSMutableArray *oldFrameArray = [[NSMutableArray alloc]init];
    [oldFrameArray removeAllObjects];
    
    //这里需要注意 一个cell中如果有多个连续按钮 设置tag的公式在cellforindexpath中
    //这里反向解析出按钮对应动态的section 和 对应按钮数组的第几个按钮 （index）
    NSInteger index =  button.tag%4 - 1;
    if(button.tag % 4 == 0) index = 3;
    NSInteger section = button.tag / 4 - (button.tag % 4)/4;
    if(button.tag % 4 == 0) section = button.tag / 4 - 1;
    //        case 3:
    //        {
    //            section = (button.tag + 1) /4  - 1;
    //            index = 2;
    //        }
    //            break;
    //        case 0:
    //        {
    //            section = button.tag /4  - 1;
    //            index = 3;
    //        }
    
    NSArray *urlArray = [((FriendsPicAndVideoModel *)((FriendsRecentModel *)_dataArray[section]).lyMomentsAttachList[0]).imageLink componentsSeparatedByString:@","];
    LYFriendsImgTableViewCell *imgCell = (LYFriendsImgTableViewCell *)[_userTablewView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:section]];
    for (UIButton *btn in imgCell.btnArray) {
        CGRect rect = [imgCell convertRect:btn.frame toView:app.window];
        [oldFrameArray addObject:NSStringFromCGRect(rect)];
    }
    //查看图片的视图
    LYPictiureView *picView = [[LYPictiureView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) urlArray:urlArray oldFrame:oldFrameArray with:index];
    picView.backgroundColor = [UIColor blackColor];
    
    [app.window addSubview:picView];
}


@end
