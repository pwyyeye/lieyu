//
//  LYFriendsViewController.m
//  lieyu
//
//  Created by 狼族 on 15/12/24.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYFriendsViewController.h"
#import "LYFriendsNameTableViewCell.h"
#import "LYFriendsAddressTableViewCell.h"
#import "LYFriendsLikeTableViewCell.h"
#import "LYFriendsCommentTableViewCell.h"
#import "LYFriendsVideoTableViewCell.h"
#import "LYFriendsHttpTool.h"
#import "FriendsRecentModel.h"
#import "FriendsUserMessageModel.h"
#import "LYFriendsAllCommentTableViewCell.h"
#import "FriendsCommentModel.h"
#import "LYFriendsUserHeaderView.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
#import "LYFriendsMessageViewController.h"
#import "LYPictiureView.h"
#import "LYFriendsCommentView.h"
#import "IQKeyboardManager.h"
#import "LYFriendsToUserMessageViewController.h"
#import "LYFriendsMessageDetailViewController.h"
#import "LYFriendsImgTableViewCell.h"
#import "LYFriendsChangeImageMenuView.h"
#import "LYChangeImageViewController.h"
#import "LYFriendsCommentButton.h"
#import "FriendsLikeModel.h"
#import "FriendsPicAndVideoModel.h"
#import "FriendsUserInfoModel.h"
#import "MJRefresh.h"
#import "ISEmojiView.h"

#import "YBImgPickerViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>


#define LYFriendsNameCellID @"LYFriendsNameTableViewCell"
#define LYFriendsAddressCellID @"LYFriendsAddressTableViewCell"
#define LYFriendsLikeCellID @"LYFriendsLikeTableViewCell"
#define LYFriendsCommentCellID @"LYFriendsCommentTableViewCell"
#define LYFriendsAllCommentCellID @"LYFriendsAllCommentTableViewCell"
#define LYFriendsImgCellID @"LYFriendsImgTableViewCell"
#define LYFriendsVideoCellID @"LYFriendsVideoTableViewCell"
#define LYFriendsCellID @"cell"

@interface LYFriendsViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UITextFieldDelegate,YBImgPickerViewControllerDelegate,
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate,ISEmojiViewDelegate,sendBackVedioAndImage>{
    UIButton *_friendsBtn;//导航栏朋友圈按钮
    UIButton *_myBtn;//导航栏我的按钮
    UILabel *_myBadge;//我的按钮小红圈
    UIButton *_carmerBtn;//发布动态按钮
    CGFloat _friendBtnAlpha,_myBtnAlpha;
    NSMutableArray *_dataArray;
    NSInteger _index;//0 表示玩友圈界面 1表示我的界面
    LYFriendsUserHeaderView *_headerView;
    UIView *_vLine;//导航栏竖线
    NSMutableArray *_oldFrameArray;//查看图片纪录原来的frame
    NSInteger _section;//点击的section
    NSInteger _imgIndex;//点击的第几个imgview
    NSString *_useridStr;//当前用户id
    NSString *_likeStr;//用户是否喜欢
    UIView *_bigView;
    LYFriendsCommentView *_commentView;//弹出的评论框
    NSInteger _commentBtnTag;
    BOOL _friendsBtnSelect;//是否选择了导航栏上玩友圈按钮
    NSInteger _pageStartCountFriends;//开始的数量
    NSInteger _pageStartCountMys;//开始的数量
    NSInteger _pageCount;//每页数
    BOOL _isFriendsPageUpLoad;//是否玩友圈上拉加载
    BOOL _isMysPageUpLoad;//是否我的圈上拉加载
    NSString *_userBgImageUrl;//用户上传的个人背景图
    NSInteger _indexRow;//表的那一行
    BOOL _isCommentToUser;//是否对用户评论
    LYFriendsSendViewController *friendsSendVC;
    NSString *_results;//新消息条数
    NSString *_icon;//新消息头像
    NSInteger _deleteMessageTag;//删除动态的btn的tag
        NSInteger _saveImageAndVideoIndex;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, assign) int pagesCount;
@property (nonatomic, strong) NSString *typeOfImagePicker;
@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (nonatomic, strong) NSMutableDictionary *notificationDict;

@end

@implementation LYFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.pagesCount = 4;
    
    _notificationDict = [[NSMutableDictionary alloc]init];
    [self setupAllProperty];//设置全局属性
    [self setupTableView];
    [self setupTableViewFresh];//配置表的刷新和加载
    [self getFriendsNewMessage];
}

#pragma mark - 获取我的未读消息数
- (void)getFriendsNewMessage{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if(app.userModel == nil)return;
    NSDictionary *paraDic = @{@"userId":_useridStr};
    //__weak LYFriendsViewController *weakSelf = self;
    [LYFriendsHttpTool friendsGetFriendsMessageNotificationWithParams:paraDic compelte:^(NSString * reslults, NSString *icon) {
//        _myBadge.text = [NSString stringWithFormat:@"%@",reslults];
        if(reslults.integerValue){
            _myBadge.hidden = NO;
            _headerView.btn_newMessage.hidden = NO;
        }
        [_headerView.btn_newMessage sd_setImageWithURL:[NSURL URLWithString:icon] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"empyImage120"]];
        [_headerView.btn_newMessage setTitle:[NSString stringWithFormat:@"%@条未读消息",reslults] forState:UIControlStateNormal];

        _headerView.btn_newMessage.hidden = NO;
        //[[NSNotificationCenter defaultCenter] postNotificationName:@"MyFriendsMessageCount" object:weakSelf userInfo:@{@"count":reslults,@"icon":icon}];
        _results = reslults;
        _icon = icon;
    }];
}

#pragma mark - 设置全局属性
- (void)setupAllProperty{
    _dataArray = [[NSMutableArray alloc]initWithCapacity:0];
    for (int i = 0; i < 2; i ++) {
        NSMutableArray *array = [[NSMutableArray alloc]init];
        [_dataArray addObject:array];
    }
    _oldFrameArray = [[NSMutableArray alloc]init];
     _index = 0;
    _friendsBtnSelect = YES;
    _pageStartCountFriends = 0;
    _pageStartCountMys = 0;
    _pageCount = 10;
    self.tableView.tableFooterView = [[UIView alloc]init];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginAndLoadData) name:@"loginAndLoadData" object:nil];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if(app.userModel)  _useridStr = [NSString stringWithFormat:@"%d",app.userModel.userid];
    else return;
    [self getDataFriendsWithSetContentOffSet:NO];
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageCountNotice:) name:@"MyFriendsMessageCount" object:nil];
}

#pragma mark - 登录后获取数据
- (void)loginAndLoadData{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if(app.userModel)  _useridStr = [NSString stringWithFormat:@"%d",app.userModel.userid];
    else return;
    [self getDataFriendsWithSetContentOffSet:NO];
    self.navigationController.navigationBarHidden = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"loginAndLoadData" object:nil];
}

//- (void)messageCountNotice:(NSNotification *)note{
//    UIView *view = _tableView.tableHeaderView;
//    CGRect frame = view.frame;
//    frame.size.height = frame.size.height + 54;
//    _tableView.tableHeaderView = view;
//}

//- (void)badgeValue:(NSNotification *)note{
//    NSString *resluts = note.userInfo[@"results"];
//    NSString *icon = note.userInfo[@"icon"];
//}

#pragma mark - 作为代理收取视频路径地址与截图
- (void)sendVedio:(NSString *)mediaUrl andImage:(UIImage *)image andContent:(NSString *)content{
  /*  self.mediaImage = image;
    self.mediaUrl = mediaUrl;
    self.content = content;
    
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    FriendsRecentModel *recentM = [[FriendsRecentModel alloc]init];
    recentM.attachType = @"1";
    recentM.username = app.userModel.username;
    recentM.avatar_img = app.userModel.avatar_img;
    NSDateFormatter *dateFmt = [[NSDateFormatter alloc]init];
    recentM.date = [dateFmt stringFromDate:[NSDate date]];
    recentM.tags = app.userModel.tags;
    recentM.birthday = app.userModel.birthday;
    recentM.message = content;
    recentM.liked = @"0";

    
    FriendsPicAndVideoModel *pvModel = [[FriendsPicAndVideoModel alloc]init];
    pvModel.imageLink = mediaUrl;
    [[SDWebImageManager sharedManager] saveImageToCache:image forURL:[NSURL URLWithString:[MyUtil  getQiniuUrl:[NSString stringWithFormat:@"myMediaPicture%ld",_saveImageAndVideoIndex] mediaType:QiNiuUploadTpyeDefault width:0 andHeight:0]]];
    _saveImageAndVideoIndex ++;
    recentM.lyMomentsAttachList = @[pvModel];
    
    NSMutableArray *arr1 = _dataArray[0];
    NSMutableArray *arr2 = _dataArray[1];
    [arr1 insertObject:recentM atIndex:0];
    [arr2 insertObject:recentM atIndex:0];
    [self.tableView reloadData];
   */
}

#pragma mark - 作为代理接受返回的图片
- (void)sendImagesArray:(NSArray *)imagesArray andContent:(NSString *)content{
   /* self.imageArray = imagesArray;
    self.content = content;
    
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    FriendsRecentModel *recentM = [[FriendsRecentModel alloc]init];
    recentM.attachType = @"0";
    recentM.usernick = app.userModel.usernick;
    recentM.avatar_img = app.userModel.avatar_img;
    recentM.id = @"-1";
    NSDateFormatter *dateFmt = [[NSDateFormatter alloc]init];
    recentM.date = [dateFmt stringFromDate:[NSDate date]];
    NSLog(@"---->%@",app.userModel.tags);
    recentM.tags = app.userModel.tags;
    
    recentM.birthday = app.userModel.birthday;
    recentM.message = content;
    
    FriendsPicAndVideoModel *pvModel = [[FriendsPicAndVideoModel alloc]init];
    NSString *imageLink = nil;
    NSString *appendLink = nil;
    CGFloat picWidth = 0;
    for (int i = 0;i < imagesArray.count;i ++) {
        UIImage *image = imagesArray[i];
     //   pvModel.imageLink = [pvModel.imageLink stringByAppendingString:[[NSString stringWithFormat:@"myPicture%ld%d",_saveImageAndVideoIndex,i] stringByAppendingString:@","]];
        
        appendLink = [NSString stringWithFormat:@"myPicture%ld%d,",_saveImageAndVideoIndex,i];
        if(i == imagesArray.count - 1) appendLink = [NSString stringWithFormat:@"myPicture%ld%d",_saveImageAndVideoIndex,i];
        NSLog(@"--->%@",imageLink);
        if(!i) imageLink = appendLink;
        else imageLink = [imageLink stringByAppendingString:appendLink];
        NSLog(@"--->%@",imageLink);
        
        switch (imagesArray.count) {
            case 1:
            {
                picWidth = 0;
            }
                break;
            case 2:
            {
                picWidth = 450;
            }
                break;
            default:{
                if(!i) picWidth = 0;
                else picWidth = 450;
            }
                break;
        }
        
         [[SDWebImageManager sharedManager] saveImageToCache:image forURL:[NSURL URLWithString:[MyUtil getQiniuUrl:[NSString stringWithFormat:@"myPicture%ld%d",_saveImageAndVideoIndex,i] width:picWidth andHeight:picWidth]]];
        _saveImageAndVideoIndex ++;
        
    }
    pvModel.imageLink = imageLink;
    NSLog(@"------>%@------%@",pvModel.imageLink,imageLink);
    recentM.lyMomentsAttachList = @[pvModel];
    
    NSMutableArray *arr1 = _dataArray[0];
    NSMutableArray *arr2 = _dataArray[1];
    [arr1 insertObject:recentM atIndex:0];
    [arr2 insertObject:recentM atIndex:0];
    [self.tableView reloadData];
    */
}

#pragma mark - 配置表的cell
- (void)setupTableView{
    NSArray *array = @[LYFriendsNameCellID,LYFriendsAddressCellID,LYFriendsLikeCellID,LYFriendsCommentCellID,LYFriendsAllCommentCellID,LYFriendsVideoCellID];
    for (NSString *cellIdentifer in array) {
        [self.tableView registerNib:[UINib nibWithNibName:cellIdentifer bundle:nil] forCellReuseIdentifier:cellIdentifer];
    }
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:LYFriendsCellID];
    [self.tableView registerClass:[LYFriendsImgTableViewCell class] forCellReuseIdentifier:LYFriendsImgCellID];
}

#pragma mark - 配置表的刷新控件
- (void)setupTableViewFresh{
    self.tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        switch (_index) {
            case 0:
            {
                _pageStartCountFriends = 0;
                [self getDataFriendsWithSetContentOffSet:NO];
            }
                break;
                
            default:
            {
                _pageStartCountMys = 0;
                [self getDataMysWithSetContentOffSet:NO];
            }
                break;
        }
    }];
    
    MJRefreshGifHeader *header = (MJRefreshGifHeader *)self.tableView.mj_header;
    [self initMJRefeshHeaderForGif:header];
    
    self.tableView.mj_footer = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
        switch (_index) {
            case 0:
            {
                _isFriendsPageUpLoad = YES;
                [self getDataFriendsWithSetContentOffSet:NO];
            }
                break;
                
            default:
            {
               _isMysPageUpLoad = YES;
                [self getDataMysWithSetContentOffSet:NO];
            }
                break;
        }
    }];
    
}

#pragma mark - 设置导航栏玩友圈和我的按钮及发布动态按钮
- (void)setupNavMenuView{
    _friendsBtn = [[UIButton alloc]initWithFrame:CGRectMake(101.5, 12, 42, 20)];
    [_friendsBtn setTitle:@"玩友圈" forState:UIControlStateNormal];
    _friendsBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    _friendsBtn.titleLabel.textColor = RGBA(255, 255, 255, 1);
    [_friendsBtn addTarget:self action:@selector(friendsClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:_friendsBtn];
    
    _myBtn = [[UIButton alloc]initWithFrame:CGRectMake(176, 12, 42, 20)];
    [_myBtn setTitle:@"我的" forState:UIControlStateNormal];
    _myBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    if(_friendsBtnSelect) {
        _myBtn.alpha = 0.5;
    }
    else{
        _friendsBtn.alpha = 0.5;
    }
    
    [_myBtn addTarget:self action:@selector(myClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:_myBtn];
    
    _vLine = [[UIView alloc]initWithFrame:CGRectMake(160, 16, 1, 12)];
    _vLine.backgroundColor = RGBA(255, 255, 255, 0.5);
    [self.navigationController.navigationBar addSubview:_vLine];

    _myBadge = [[UILabel alloc]initWithFrame:CGRectMake(209, 10, 10, 10)];
    _myBadge.backgroundColor = [UIColor redColor];
    _myBadge.layer.cornerRadius = CGRectGetWidth(_myBadge.frame) / 2.f;
    _myBadge.layer.masksToBounds = YES;
    _myBadge.hidden = YES;
    [self.navigationController.navigationBar addSubview:_myBadge];
    _carmerBtn = [[UIButton alloc]initWithFrame:CGRectMake(285.5, 10, 24, 24)];
    [_carmerBtn addTarget:self action:@selector(carmerClick:) forControlEvents:UIControlEventTouchUpInside];
    [_carmerBtn setBackgroundImage:[UIImage imageNamed:@"daohang_xiangji"] forState:UIControlStateNormal];
    [self.navigationController.navigationBar addSubview:_carmerBtn];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].isAdd = YES;
    [self setupNavMenuView];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if(app.userModel) _useridStr = [NSString stringWithFormat:@"%d",app.userModel.userid];
//    NSArray *array = _dataArray[0];
//    if(array.count){
//        [self getDataFriendsWithSetContentOffSet:NO];
//    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self removeNavMenuView];
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].isAdd = NO;
}

#pragma mark - 移除导航栏的按钮
- (void)removeNavMenuView{
//    _friendsBtn.alpha =
    [_friendsBtn removeFromSuperview];
    [_myBadge removeFromSuperview];
    [_myBtn removeFromSuperview];
    [_carmerBtn removeFromSuperview];
    [_vLine removeFromSuperview];
    _myBtn = nil;
    _friendsBtn = nil;
}

#pragma mark - 获取最新玩友圈数据
- (void)getDataFriendsWithSetContentOffSet:(BOOL)need{
       __weak LYFriendsViewController *weakSelf = self;
    NSString *startStr = [NSString stringWithFormat:@"%ld",_pageStartCountFriends * _pageCount];
    NSString *pageCountStr = [NSString stringWithFormat:@"%ld",_pageCount];
    NSDictionary *paraDic = @{@"userId":_useridStr,@"start":startStr,@"limit":pageCountStr};
    [LYFriendsHttpTool friendsGetRecentInfoWithParams:paraDic compelte:^(NSMutableArray *dataArray) {
        _index = 0;
        if(dataArray.count){
                if(_pageStartCountFriends == 0){
                    [_dataArray replaceObjectAtIndex:0 withObject:dataArray];
                }else {
                    NSMutableArray *muArr = _dataArray[_index];
                    [muArr addObjectsFromArray:dataArray];
                }
            _pageStartCountFriends ++;
            [self.tableView.mj_footer endRefreshing];
        }else{
            if(_isFriendsPageUpLoad)  [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            _isFriendsPageUpLoad = NO;
        }
        [weakSelf reloadTableViewAndSetUpPropertyneedSetContentOffset:need];
    }];
}

#pragma mark - 获取最新我的数据
- (void)getDataMysWithSetContentOffSet:(BOOL)need{
    NSString *startStr = [NSString stringWithFormat:@"%ld",_pageStartCountMys * _pageCount];
    NSString *pageCountStr = [NSString stringWithFormat:@"%ld",_pageCount];
    NSDictionary *paraDic = @{@"userId":_useridStr,@"start":startStr,@"limit":pageCountStr,@"frientId":_useridStr};
         __weak LYFriendsViewController *weakSelf = self;
    [LYFriendsHttpTool friendsGetUserInfoWithParams:paraDic compelte:^(FriendsUserInfoModel*userInfo, NSMutableArray *dataArray) {
        _userBgImageUrl = userInfo.friends_img;
        _index = 1;
        if(dataArray.count){
                    if(_pageStartCountMys == 0){
                        [_dataArray replaceObjectAtIndex:1 withObject:dataArray];
                    }else{
                        NSMutableArray *muArr = _dataArray[_index];
                        [muArr addObjectsFromArray:dataArray];
                    }
            _pageStartCountMys ++;
            [self.tableView.mj_footer endRefreshing];
        }else{
            if(_isMysPageUpLoad){
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            _isMysPageUpLoad = NO;
        }
        [weakSelf reloadTableViewAndSetUpPropertyneedSetContentOffset:need];
    }];
}

#pragma mark － 刷新表
- (void)reloadTableViewAndSetUpPropertyneedSetContentOffset:(BOOL)need{
    [self.tableView reloadData];
     if(need)  [self.tableView setContentOffset:CGPointZero animated:YES];
    if(_index) [self addTableViewHeader];
    else [self removeTableViewHeader];
    [self.tableView.mj_header endRefreshing];
    
    if(!((NSArray *)_dataArray[_index]).count){
        return;
    }
    FriendsRecentModel *recentM = _dataArray[_index][_section];
    if ([recentM.liked isEqualToString:@"0"]) {
        _likeStr = @"1";
    }else{
        _likeStr = @"0";
    }
}

#pragma mark - 玩友圈action
- (void)friendsClick:(UIButton *)friendsBtn{
//    _index = 0;
    _friendsBtn.alpha = 1;
    _myBtn.alpha = 0.5;
    _friendsBtnSelect = YES;
    _pageStartCountFriends = 0;
    [self getDataFriendsWithSetContentOffSet:YES];
//    [self removeTableViewHeader];
}

#pragma mark - 我的action
- (void)myClick:(UIButton *)myBtn{
    _friendsBtn.alpha = 0.5;
    _myBtn.alpha = 1;
    _friendsBtnSelect = NO;
    _pageStartCountMys = 0;
//    _index = 1;
    [self getDataMysWithSetContentOffSet:YES];
//    [self addTableViewHeader];
}

#pragma mark - 添加表头
- (void)addTableViewHeader{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    _headerView = [[[NSBundle mainBundle]loadNibNamed:@"LYFriendsUserHeaderView" owner:nil options:nil]firstObject];
    if(_results.integerValue){
        _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 339);
         _headerView.btn_newMessage.hidden = NO;
        _myBadge.hidden = NO;
    }else{
        _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 339 - 54);
         _headerView.btn_newMessage.hidden = YES;
        _headerView.imageView_NewMessageIcon.hidden = YES;
    }
    [_headerView.imageView_NewMessageIcon sd_setImageWithURL:[NSURL URLWithString:_icon]  placeholderImage:[UIImage imageNamed:@"empyImage120"]];
    [_headerView.btn_newMessage setTitle:[NSString stringWithFormat:@"%@条新消息",_results] forState:UIControlStateNormal];
    [_headerView.btn_header sd_setBackgroundImageWithURL:[NSURL URLWithString:app.userModel.avatar_img] forState:UIControlStateNormal ];
    _headerView.label_name.text = app.userModel.usernick;
    _headerView.ImageView_bg.backgroundColor = [UIColor redColor];
    self.tableView.tableHeaderView = _headerView;
    [_headerView.btn_newMessage addTarget:self action:@selector(newClick) forControlEvents:UIControlEventTouchUpInside];
    self.tableview_top.constant = -64;
    [self updateViewConstraints];
    
    NSData *imageData = [[NSUserDefaults standardUserDefaults] objectForKey:@"FriendUserBgImage"];
    if(imageData)    _headerView.ImageView_bg.image = [[UIImage alloc]initWithData:imageData];
    else [_headerView.ImageView_bg sd_setImageWithURL:[NSURL URLWithString:_userBgImageUrl] placeholderImage:[UIImage imageNamed:@"empyImage300"]];
    _headerView.ImageView_bg.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesChooseBgImage)];
    [_headerView.ImageView_bg addGestureRecognizer:tapGes];
}

#pragma mark - 表头选择背景action
- (void)tapGesChooseBgImage{
//    LYFriendsChangeImageMenuView *changeView = [[[NSBundle mainBundle] loadNibNamed:@"LYFriendsChangeImageMenuView" owner:nil options:nil] firstObject];
//    changeView.frame = self.view.bounds;
//    [self.view addSubview:changeView];
//    
//    [UIView animateWithDuration:1 animations:^{
//        
//    }];
    
    UIActionSheet *menuSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"更改相册封面", nil];
    menuSheet.tag = 200;
    [menuSheet showInView:self.view];
}

#pragma mark - 移除表头
- (void)removeTableViewHeader{
    self.tableView.tableHeaderView = nil;
    self.tableview_top.constant = 0;
    [self updateViewConstraints];
}

- (void)updateViewConstraints{
    [super updateViewConstraints];
}

#pragma mark - 新消息action
- (void)newClick{
    _results = @"";
    _icon = @"";
    LYFriendsMessageViewController *messageVC = [[LYFriendsMessageViewController alloc]init];
    [self.navigationController pushViewController:messageVC animated:YES];
    
    [self removeTableViewHeader];
    [self addTableViewHeader];
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

//#pragma mark actionsheet代理
//- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
//    if (buttonIndex == 0) {
//        [self takePhotoActionClick];
//    }else if(buttonIndex == 1){
//        [self photosActionClick];
//    }else{
//        [self filmingActionClick];
//    }
//}

#pragma mark 选择完后根据点击的按钮进行操作
- (void)photosActionClick{
    if(self.pagesCount <= 0){
        return;//给出提示
    }
    _typeOfImagePicker = @"photos";
    YBImgPickerViewController *ybImagePicker = [[YBImgPickerViewController alloc]init];
    ybImagePicker.photoCount = self.pagesCount;
    [ybImagePicker showInViewContrller:self choosenNum:0 delegate:self];
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

#pragma mark - 表白action
- (void)likeFriendsClick:(UIButton *)button{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
      FriendsRecentModel *recentM = _dataArray[_index][button.tag];
    NSDictionary *paraDic = @{@"userId":_useridStr,@"messageId":recentM.id,@"type":_likeStr};
    __weak LYFriendsViewController *weakSelf = self;
    [LYFriendsHttpTool friendsLikeMessageWithParams:paraDic compelte:^(bool result) {
        if([_likeStr isEqualToString:@"1"]){
            _likeStr = @"0";
        }else{
            _likeStr = @"1";
        }
        if (result) {//点赞成功
            FriendsLikeModel *likeModel = [[FriendsLikeModel alloc]init];
            likeModel.icon = app.userModel.avatar_img;
            likeModel.userId = _useridStr;
            [recentM.likeList insertObject:likeModel atIndex:0];
        }else{
            for (FriendsLikeModel *likeM in recentM.likeList) {
                if ([likeM.userId isEqualToString:_useridStr]) {
                    [recentM.likeList removeObject:likeM];
                }
            }
        }
        [weakSelf.tableView reloadData];
    }];
}

#pragma mark - 评论action
- (void)commentClick:(UIButton *)button{
    _commentBtnTag = button.tag;
    _isCommentToUser = NO;
    [self createCommentView];
}

#pragma mark － 创建commentView
- (void)createCommentView{
    _bigView = [[UIView alloc]init];
    _bigView.frame = self.view.bounds;
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bigViewGes)];
    [_bigView addGestureRecognizer:tapGes];
    [self.view addSubview:_bigView];
    
    _commentView = [[[NSBundle mainBundle]loadNibNamed:@"LYFriendsCommentView" owner:nil options:nil] firstObject];
    _commentView.frame = CGRectMake(0, SCREEN_HEIGHT , SCREEN_WIDTH, 49);
    _commentView.bgView.layer.borderColor = RGBA(143, 2, 195, 1).CGColor;
    _commentView.bgView.layer.borderWidth = 0.5;
    [_bigView addSubview:_commentView];
    
    [_commentView.textField becomeFirstResponder];
    _commentView.textField.delegate = self;
    [_commentView.btn_emotion addTarget:self action:@selector(emotionClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [UIView animateWithDuration:.25 animations:^{
        _commentView.frame = CGRectMake(0, SCREEN_HEIGHT - 249 - 59, SCREEN_WIDTH, 49);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)bigViewGes{
    [_bigView removeFromSuperview];
    
}

- (void)emotionClick:(UIButton *)button{
    button.selected = !button.selected;
    if(button.selected){
    [_commentView.textField endEditing:YES];
    ISEmojiView *emojiView = [[ISEmojiView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 216)];
    emojiView.delegate = self;
    emojiView.inputView = _commentView.textField;
    _commentView.textField.inputView = emojiView;
    [_commentView.textField becomeFirstResponder];
    [UIView animateWithDuration:.1 animations:^{
        CGFloat y = SCREEN_HEIGHT - CGRectGetHeight(_commentView.frame) - CGRectGetHeight(emojiView.frame);
        _commentView.frame = CGRectMake(0,y , CGRectGetWidth(_commentView.frame), CGRectGetHeight(_commentView.frame));
        NSLog(@"----->%@",NSStringFromCGRect(_commentView.frame));
    }];
    }else{
        [_commentView.textField endEditing:YES];
        _commentView.textField.inputView = UIKeyboardAppearanceDefault;
        [_commentView.textField becomeFirstResponder];
        [UIView animateWithDuration:.1 animations:^{
           // _commentView.frame = CGRectMake(0,SCREEN_HEIGHT - 216 - CGRectGetHeight(_commentView.frame) , CGRectGetWidth(_commentView.frame), CGRectGetHeight(_commentView.frame));
            _commentView.frame = CGRectMake(0, SCREEN_HEIGHT - 249 - 59, SCREEN_WIDTH, CGRectGetHeight(_commentView.frame));
        }];
    }
}

-(void)emojiView:(ISEmojiView *)emojiView didSelectEmoji:(NSString *)emoji{
    _commentView.textField.text = [_commentView.textField.text stringByAppendingString:emoji];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_bigView removeFromSuperview];
    [textField endEditing:YES];
    if(!_commentView.textField.text.length) return NO;
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    FriendsRecentModel *recentM = nil;
    NSString *toUserId = nil;
    NSString *toUserNickName = nil;
    if (_isCommentToUser) {
        recentM = _dataArray[_index][_section];
        FriendsCommentModel *commentModel = recentM.commentList[_indexRow - 4];
        toUserId = commentModel.userId;
        toUserNickName = commentModel.nickName;
    }else{
        recentM = _dataArray[_index][_commentBtnTag];
        toUserId = @"";
        toUserNickName = @"";
    }
    NSDictionary *paraDic = @{@"userId":_useridStr,@"messageId":recentM.id,@"toUserId":toUserId,@"comment":_commentView.textField.text};
    __weak LYFriendsViewController *weakSelf = self;
    [LYFriendsHttpTool friendsCommentWithParams:paraDic compelte:^(bool resutl,NSString *commentId) {
        if (resutl) {
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
            if(recentM.commentList.count == 5) [recentM.commentList removeObjectAtIndex:0];
            [recentM.commentList addObject:commentModel];
            recentM.commentNum = [NSString stringWithFormat:@"%ld",recentM.commentNum.intValue + 1];
          // [weakSelf.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:4 + recentM.commentList.count inSection:_commentBtnTag]] withRowAnimation:UITableViewRowAnimationTop];
            [weakSelf.tableView reloadData];
        }
    }];
    return YES;
}

#pragma mark - 查看图片
- (void)checkImageClick:(UIButton *)button{
     AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSMutableArray *oldFrameArray = [[NSMutableArray alloc]init];
    [oldFrameArray removeAllObjects];
    NSInteger index = 0;
    NSInteger section = 0;
    NSArray *urlArray = nil;
    switch (button.tag % 4) {
        case 1://点一个按钮
        {
            section = (button.tag + 3) /4  - 1;
            index = 0;
        }
            break;
        case 2:
        {
            section = (button.tag + 2) /4  - 1;
            index = 1;
        }
            break;
        case 3:
        {
            section = (button.tag + 1) /4  - 1;
            index = 2;
        }
            break;
        case 0:
        {
            section = button.tag /4  - 1;
            index = 3;
        }
            break;
        default:
            break;
    }
    urlArray = [((FriendsPicAndVideoModel *)((FriendsRecentModel *)_dataArray[_index][section]).lyMomentsAttachList[0]).imageLink componentsSeparatedByString:@","];
    LYFriendsImgTableViewCell *imgCell = (LYFriendsImgTableViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:section]];
    for (UIButton *btn in imgCell.btnArray) {
        CGRect rect = [imgCell convertRect:btn.frame toView:app.window];
        [oldFrameArray addObject:NSStringFromCGRect(rect)];
    }
    
    LYPictiureView *picView = [[LYPictiureView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) urlArray:urlArray oldFrame:oldFrameArray with:index];
    picView.backgroundColor = [UIColor blackColor];
   
    [app.window addSubview:picView];
}


#pragma mark － 删除我的动态
- (void)deleteClick:(UIButton *)button{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"确定删除这条动态" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
    _deleteMessageTag = button.tag;
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex) {
        NSMutableArray *array = _dataArray[_index];
        FriendsRecentModel *recentM = array[_deleteMessageTag];
        NSDictionary *paraDic = @{@"userId":_useridStr,@"messageId":recentM.id};
        __weak LYFriendsViewController *weakSelf = self;
        [LYFriendsHttpTool friendsDeleteMyMessageWithParams:paraDic compelte:^(bool result) {
            if (result) {
                [array removeObjectAtIndex:_deleteMessageTag];
                [weakSelf.tableView reloadData];
            }
        }];
    }
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
                    _userBgImageUrl = imageurl;
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
            FriendsRecentModel *recetnM = _dataArray[_index][_section];
            FriendsCommentModel *commentM = recetnM.commentList[_indexRow - 4];
            NSDictionary *paraDic = @{@"userId":_useridStr,@"commentId":commentM.commentId};
            __weak LYFriendsViewController *weakSelf = self;
            [LYFriendsHttpTool friendsDeleteMyCommentWithParams:paraDic compelte:^(bool result) {
                if(result){
                    NSMutableArray *commentArr = ((FriendsRecentModel *)_dataArray[_index][_section]).commentList;
                    [commentArr removeObjectAtIndex:_indexRow - 4];
                    recetnM.commentNum = [NSString stringWithFormat:@"%ld",recetnM.commentNum.integerValue - 1];
                    [weakSelf.tableView reloadData];
                }
            }];
        }
    }
}

#pragma mark - 赞的人头像
- (void)zangBtnClick:(UIButton *)button{
    NSInteger i = button.tag % 7;
    NSInteger section = (button.tag - i) / 7 ;
    if(section >=0 && i>=0){
    FriendsRecentModel *recentM = _dataArray[_index][section];
        if(i > recentM.likeList.count) return;
    FriendsLikeModel *likeM = recentM.likeList[i - 1];
    LYFriendsToUserMessageViewController *messageVC = [[LYFriendsToUserMessageViewController alloc]init];
    messageVC.friendsId = likeM.userId;
    [self.navigationController pushViewController:messageVC animated:YES];
    }
}

#pragma mark - 更多赞
- (void)likeMoreClick:(UIButton *)button{
    [self pushFriendsMessageDetailVCWithIndex:button.tag];
}

#pragma mark － 跳转消息详情页面
- (void)pushFriendsMessageDetailVCWithIndex:(NSInteger)index{
    FriendsRecentModel *recentM = _dataArray[_index][index];
    LYFriendsMessageDetailViewController *messageDetailVC = [[LYFriendsMessageDetailViewController alloc]init];
    messageDetailVC.recentM = recentM;
    [self.navigationController pushViewController:messageDetailVC animated:YES];
}

#pragma mark - UITableViewDelegate&UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *array = (NSArray *)_dataArray[_index];
    FriendsRecentModel *recentM = array[section];
    if (recentM.commentNum.integerValue >= 6) {
        return 5 + recentM.commentList.count;
    }else{
        return 4 + recentM.commentList.count;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(_dataArray.count){
        NSArray *array = ((NSArray *)_dataArray[_index]);
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        return array.count;
    }else{
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
            NSArray *dataArr = _dataArray[_index];
            FriendsRecentModel *recentM = dataArr[indexPath.section];
            switch (indexPath.row) {
                case 0:
                {
                    LYFriendsNameTableViewCell *nameCell = [tableView dequeueReusableCellWithIdentifier:LYFriendsNameCellID forIndexPath:indexPath];
                    nameCell.recentM = recentM;
                    nameCell.btn_delete.tag = indexPath.section;
                    [nameCell.btn_delete addTarget:self action:@selector(deleteClick:) forControlEvents:UIControlEventTouchUpInside];
                    nameCell.btn_headerImg.tag = indexPath.section;
                    [nameCell.btn_headerImg addTarget:self action:@selector(pushUserMessagePage:) forControlEvents:UIControlEventTouchUpInside];
                    if (!_index) {
                        nameCell.btn_delete.hidden = YES;
                    }else{
                        nameCell.btn_delete.hidden = NO;
                    }
                    return nameCell;
                    
                }
                    break;
                case 1:
                {
                if([recentM.attachType isEqualToString:@"0"]){
                    LYFriendsImgTableViewCell *imgCell = [tableView dequeueReusableCellWithIdentifier:LYFriendsImgCellID forIndexPath:indexPath];
                    if (imgCell.btnArray.count) {
                        for (UIButton *btn in imgCell.btnArray) {
                            [btn removeFromSuperview];
                        }
                    }
                    imgCell.recentModel = recentM;
                    if (imgCell.btnArray.count) {
                        for (int i = 0;i < imgCell.btnArray.count; i ++) {
                            UIButton *btn = imgCell.btnArray[i];
                            switch (i) {
                                case 0:
                                {
                                    btn.tag = 4 * (indexPath.section + 1) - 3;
                                }
                                    break;
                                case 1:
                                {
                                     btn.tag = 4 * (indexPath.section + 1) - 2;
                                }
                                    break;
                                case 2:
                                {
                                     btn.tag = 4 * (indexPath.section + 1) - 1;
                                }
                                    break;
                                case 3:
                                {
                                     btn.tag = 4 * (indexPath.section + 1);
                                }
                                    break;
                            }
                            [btn addTarget:self action:@selector(checkImageClick:) forControlEvents:UIControlEventTouchUpInside];
                        }
                    }
                    return imgCell;
                    }else{
                        LYFriendsVideoTableViewCell *videoCell = [tableView dequeueReusableCellWithIdentifier:LYFriendsVideoCellID forIndexPath:indexPath];
                        NSString *urlStr = ((FriendsPicAndVideoModel *)recentM.lyMomentsAttachList[0]).imageLink;
                        videoCell.btn_play.tag = indexPath.section;
                        [videoCell.imgView_video sd_setImageWithURL:[NSURL URLWithString:[MyUtil getQiniuUrl:urlStr mediaType:QiNiuUploadTpyeDefault width:0 andHeight:0]] placeholderImage:[UIImage imageNamed:@"empyImage300"]];
                        [videoCell.btn_play addTarget:self action:@selector(playVideo:) forControlEvents:UIControlEventTouchUpInside];
                        return videoCell;
                    }
                }
                    break;
              
                case 2://地址
                {
                    LYFriendsAddressTableViewCell *addressCell = [tableView dequeueReusableCellWithIdentifier:LYFriendsAddressCellID forIndexPath:indexPath];
                    addressCell.recentM = recentM;
                    addressCell.btn_like.tag = indexPath.section;
                    addressCell.btn_comment.tag = indexPath.section;
                    [addressCell.btn_like addTarget:self action:@selector(likeFriendsClick:) forControlEvents:UIControlEventTouchUpInside];
                    [addressCell.btn_comment addTarget:self action:@selector(commentClick:) forControlEvents:UIControlEventTouchUpInside];
                    return addressCell;
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
                            btn.tag = likeCell.btnArray.count * (indexPath.section + 1) - 7 + i +1;
                            [btn addTarget:self action:@selector(zangBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                        }
                        if(recentM.likeList.count <= 8) likeCell.btn_more.hidden = YES;
                        return likeCell;
                    }
                    else{
                        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LYFriendsCellID forIndexPath:indexPath];
                        return cell;
                    }
                }
                    break;
                case 9://无赞时为评论 有赞为赞
                {
                    if (recentM.commentNum.integerValue >= 6) {
                        LYFriendsAllCommentTableViewCell *allCommentCell = [tableView dequeueReusableCellWithIdentifier:LYFriendsAllCommentCellID forIndexPath:indexPath];
                        allCommentCell.recentM = recentM;
                        return allCommentCell;
                    }else{
                        FriendsCommentModel *commentModel = recentM.commentList[indexPath.row - 4];
                        LYFriendsCommentTableViewCell *commentCell = [tableView dequeueReusableCellWithIdentifier:LYFriendsCommentCellID forIndexPath:indexPath];
                        commentCell.imageV_comment.hidden = YES;
                        commentCell.commentM = commentModel;
                        return commentCell;
                    }
                }
                    
                default:{ //评论 4-8
                    if(indexPath.row - 4 > recentM.commentList.count - 1) {
                        LYFriendsAllCommentTableViewCell *allCommentCell = [tableView dequeueReusableCellWithIdentifier:LYFriendsAllCommentCellID forIndexPath:indexPath];
                        allCommentCell.recentM = recentM;
                        return allCommentCell;
                    }
                    FriendsCommentModel *commentModel = recentM.commentList[indexPath.row - 4];
                    LYFriendsCommentTableViewCell *commentCell = [tableView dequeueReusableCellWithIdentifier:LYFriendsCommentCellID forIndexPath:indexPath];
                    if (indexPath.row == 4) {
                        commentCell.imageV_comment.hidden = NO;
                    }else{
                        commentCell.imageV_comment.hidden = YES;
                    }
                    commentCell.btn_headerImg.tag = indexPath.section;
                    commentCell.btn_headerImg.indexTag = indexPath.row;
                    [commentCell.btn_headerImg addTarget:self action:@selector(pushUserPage:) forControlEvents:UIControlEventTouchUpInside];
                    commentCell.commentM = commentModel;
                    return commentCell;
                }
                    break;
            }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *arr = _dataArray[_index];
    FriendsRecentModel *recentM = arr[indexPath.section];
    switch (indexPath.row) {
        case 0://头像和动态
        {
            CGSize size = [recentM.message boundingRectWithSize:CGSizeMake(306, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
                                                                                                                                                     
             return 62 + 13;
        }
            break;
            
        case 1://图片
        {
            NSArray *urlArray = [((FriendsPicAndVideoModel *)recentM.lyMomentsAttachList[0]).imageLink componentsSeparatedByString:@","];
            switch (urlArray.count) {
                case 1:
                {
                    return SCREEN_WIDTH;
                }
                    break;
                case 2:
                {
                    return (SCREEN_WIDTH - 2)/2.f;
                }
                    break;
                case 3:{
                    return 3 * SCREEN_WIDTH / 2 + 2;
                }
                    
                default:
                    return SCREEN_WIDTH + (SCREEN_WIDTH - 6) / 3.f + 2;
                    break;
            }
            
        }
            break;
        case 2://地址
        {
            return 45;
        }
            break;
        case 3:
        {
             NSInteger count = recentM.likeList.count;
            return count == 0 ? 0 : 46;
        }
            break;
        case 9:
        {
            return 36;
        }
            break;
            
        default://评论
        {
            if(indexPath.row - 4 > recentM.commentList.count - 1) return 36;
            FriendsCommentModel *commentM = recentM.commentList[indexPath.row - 4];
            NSString *str = [NSString stringWithFormat:@"%@:%@",commentM.nickName,commentM.comment];
            CGSize size = [str boundingRectWithSize:CGSizeMake(239, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
            CGFloat height;
            if (size.height < 36) {
                height = 36;
            }else {
                height = size.height + 10;
            }
            return height;
        }
            break;
    }
   
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _section = indexPath.section;
    FriendsRecentModel *recentM = _dataArray[_index][indexPath.section];
    if(indexPath.row == 0){
        [self pushFriendsMessageDetailVCWithIndex:indexPath.section];
    }
    if (indexPath.row >= 4 && indexPath.row <= 8) {
        _indexRow = indexPath.row;
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

#pragma mark - 点击头像跳转到指定用户界面
- (void)pushUserMessagePage:(UIButton *)button{
    FriendsRecentModel *recentM = _dataArray[_index][button.tag];
//    if([recentM.userId isEqualToString:_useridStr]) return;
    LYFriendsToUserMessageViewController *friendsUserMegVC = [[LYFriendsToUserMessageViewController alloc]init];
    friendsUserMegVC.friendsId = recentM.userId;
    [self.navigationController pushViewController:friendsUserMegVC animated:YES];
}

#pragma mark － 评论点击头像跳转到指定用户界面
- (void)pushUserPage:(LYFriendsCommentButton *)button{
    FriendsRecentModel *recentM = _dataArray[_index][button.tag];
    FriendsCommentModel *commentModel = recentM.commentList[button.indexTag - 4];
    LYFriendsToUserMessageViewController *friendsUserMegVC = [[LYFriendsToUserMessageViewController alloc]init];
    friendsUserMegVC.friendsId = commentModel.userId;
    [self.navigationController pushViewController:friendsUserMegVC animated:YES];
}


- (NSString *)stringFromImageViewFrame:(CGRect)imgFrame{
    return NSStringFromCGRect(imgFrame);
}

#pragma mark - 设置表的分割线
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
//        case 0:
//        {
//             cell.separatorInset = UIEdgeInsetsMake(0, 1000, 0, 0);
//        }
//            break;
//        case 1:
//        {
//            cell.separatorInset = UIEdgeInsetsMake(0, 1000, 0, 0);
//        }
//            break;
        case 2:
        {
            cell.separatorInset = UIEdgeInsetsMake(0, 7, 0, 7);
        }
            break;
        case 3:
        {
            cell.separatorInset = UIEdgeInsetsMake(0, 35, 0, 7);
        }
            break;
        default:
        {
            cell.separatorInset = UIEdgeInsetsMake(0, 1000, 0, 0);
        }
            break;
    }
}

#pragma mark - 视频播放
- (void)playVideo:(UIButton *)button{
    NSArray *array = _dataArray[_index];
    FriendsPicAndVideoModel *pvM = (FriendsPicAndVideoModel *)((FriendsRecentModel *)array[button.tag]).lyMomentsAttachList[0];
//    NSString *urlString = [MyUtil configureNetworkConnect] == 1 ?[MyUtil getQiniuUrl:pvM.imageLink mediaType:QiNiuUploadTpyeSmallMedia width:0 andHeight:0] : [MyUtil getQiniuUrl:pvM.imageLink mediaType:QiNiuUploadTpyeMedia width:0 andHeight:0];
    QiNiuUploadTpye quType = [MyUtil configureNetworkConnect] == 1 ? QiNiuUploadTpyeSmallMedia : QiNiuUploadTpyeMedia;
    NSURL *url = [NSURL URLWithString:[[MyUtil getQiniuUrl:pvM.imageLink mediaType:quType width:0 andHeight:0] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] ;
    MPMoviePlayerViewController *player = [[MPMoviePlayerViewController alloc]initWithContentURL:url];
    player.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    player.moviePlayer.controlStyle = MPMovieControlStyleFullscreen;
    player.moviePlayer.scalingMode = MPMovieScalingModeNone;
    [self presentMoviePlayerViewControllerAnimated:player];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (BOOL)shouldAutorotate{
    return YES;
}

//- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
//    return UIInterfaceOrientationMaskLandscape;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
