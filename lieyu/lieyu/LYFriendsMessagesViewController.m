//
//  LYFriendsMessagesViewController.m
//  lieyu
//
//  Created by 狼族 on 16/4/22.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYFriendsMessagesViewController.h"
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

#define LYFriendsAllCommentCellID @"LYFriendsAllCommentTableViewCell"
#define LYFriendsLikeCellID @"LYFriendsLikeTableViewCell"

@interface LYFriendsMessagesViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,emojiClickDelegate,ImagePickerFinish,UIImagePickerControllerDelegate,UINavigationControllerDelegate,sendBackVedioAndImage,ISEmojiViewDelegate,UITextFieldDelegate>
{
    BOOL _friendsBtnSelect;//朋友圈按钮选择状态
    HotMenuButton *_friendsBtn,*_myBtn;//朋友圈按钮 我的按钮
    UILabel *_myBadge;//我的角标
    UIView *_lineView;//导航按钮下划线
    NSInteger _saveImageAndVideoIndex;
    UIScrollView *_scrollViewForTableView;//表的基成视图
    NSString *_results;//新消息条数
    NSString *_icon;//新消息头像
    NSArray *_topicArray;//话题数组
    NSString *jubaoMomentID;//要删除的动态ID
    UIView *_bigView;//评论的背景view
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
    
    NSTimer *_timer;//定时获取我的新消息
}
@property (nonatomic, assign) int pagesCount;
@property (nonatomic, strong) NSString *typeOfImagePicker;
@property (nonatomic, strong) UIImagePickerController *imagePicker;


@end

@implementation LYFriendsMessagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if(app.userModel) _useridStr = [NSString stringWithFormat:@"%d",app.userModel.userid];

//    [self setupAllProperty];//配置初始化
    self.pagesCount = 4;
    _notificationDict = [[NSMutableDictionary alloc]init];
    if(!_isFriendToUserMessage) self.pageNum = 2;
    [self addTableViewHeaderViewForTopic];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if(app.userModel.userid != _useridStr.intValue){
        _useridStr = [NSString stringWithFormat:@"%d",app.userModel.userid];
        if(_pageNum == 2){
            UITableView *tableView = _tableViewArray[_index];
            [tableView.mj_header beginRefreshing];
        }
    }
    
    [self setupCarmerBtn];
    
    [self setupMenuView];//配置导航
    
    UITableView *tableView = _tableViewArray[_index];
    [tableView reloadData];
   
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].isAdd = YES;
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(getFriendsNewMessage) userInfo:nil repeats:YES];//定时器获取新消息数
    [_timer fire];
}

- (void)viewWillDisappear:(BOOL)animated{
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].isAdd = NO;
    
    [_timer invalidate];
    _timer = nil;
    
    
    if(_friendsBtn.isFriendsMenuViewSelected) _friendsBtnSelect = YES;
    else _friendsBtnSelect = NO;
    if (isExidtEffectView) {
        isExidtEffectView = NO;
        [emojisView hideEmojiEffectView];
    }
    
    
    [effectView removeFromSuperview];//移除发布按钮
    [self removeNavMenuView];//移除导航菜单
}

- (void)setupAllProperty{
    _dataArray = [[NSMutableArray alloc]initWithCapacity:_pageNum];
    for (int i = 0; i < _pageNum; i ++) {
        [_dataArray addObject:[[NSMutableArray alloc]init]];
    }
    _tableViewArray = [[NSMutableArray alloc]initWithCapacity:_pageNum];
    _pageStartCountArray[0] = 0;
    _pageStartCountArray[1] = 0;
    _pageCount = 10;
    _friendsBtnSelect = YES;

}

- (void)setPageNum:(NSInteger)pageNum{
    _pageNum = pageNum;
    [self setupAllProperty];
     [self setupTableView];//配置表
}

#pragma mark - 获取最新玩友圈数据
- (void)getDataWithType:(dataType)type needLoad:(BOOL)need{
    UITableView *tableView = nil;
    __block int pageStartCount;
    if (type == dataForFriendsMessage) {
        pageStartCount = _pageStartCountArray[0];
        tableView = _tableViewArray.firstObject;
    }else if(type == dataForMine){
        pageStartCount = _pageStartCountArray[1];
        tableView = [_tableViewArray objectAtIndex:1];
    }
    NSString *startStr = [NSString stringWithFormat:@"%d",pageStartCount * _pageCount];
    NSString *pageCountStr = [NSString stringWithFormat:@"%d",_pageCount];
    NSDictionary *paraDic = nil;
    __weak __typeof(self) weakSelf = self;
    if (type == dataForFriendsMessage) {//玩友圈数据
        paraDic = @{@"start":startStr,@"limit":pageCountStr};
        [LYFriendsHttpTool friendsGetRecentInfoWithParams:paraDic compelte:^(NSMutableArray *dataArray) {
            [weakSelf loadDataWith:tableView dataArray:dataArray pageStartCount:pageStartCount type:type];
        }];

    }else if(type == dataForMine){//我的玩友圈数据
        paraDic = @{@"userId":_useridStr,@"start":startStr,@"limit":pageCountStr,@"frientId":_useridStr};
        [LYFriendsHttpTool friendsGetUserInfoWithParams:paraDic needLoading:need compelte:^(FriendsUserInfoModel*userInfo, NSMutableArray *dataArray) {
            _userBgImageUrl = userInfo.friends_img;
            [weakSelf loadDataWith:tableView dataArray:dataArray pageStartCount:pageStartCount type:type];
            [weakSelf addTableViewHeader];
        }];
    }
}

- (void)loadDataWith:(UITableView *)tableView dataArray:(NSMutableArray *)dataArray pageStartCount:(int)pageStartCount type:(dataType)type{
    if(dataArray.count){
        NSString *str = dataArray.firstObject;
        if (dataArray.count == 1 && [str isKindOfClass:[NSString class]]) {
            [tableView.mj_footer endRefreshing];
        }else{
            if(pageStartCount == 0){//下啦刷新时
                [_dataArray replaceObjectAtIndex:tableView.tag withObject:dataArray];
            }else {//上拉加载时
                NSMutableArray *muArr = _dataArray[tableView.tag];
                [muArr addObjectsFromArray:dataArray];
            }
            pageStartCount ++;
            if (type == dataForFriendsMessage) {
                _pageStartCountArray[0] = pageStartCount;
            }else if(type == dataForMine){
                _pageStartCountArray[1] = pageStartCount;
            }
            [tableView.mj_footer endRefreshing];
            
        }
    }else{
         [tableView.mj_footer endRefreshingWithNoMoreData];
    }
    
    [tableView reloadData];
    [tableView.mj_header endRefreshing];
}

#pragma mark - 配置导航
- (void)setupMenuView{
    CGFloat friendsBtn_Width = 42;
    //导航菜单
    UIView *navMenuView = [[UIView alloc]initWithFrame:CGRectMake( (SCREEN_WIDTH - friendsBtn_Width * 2 - 16)/2.f, 0, friendsBtn_Width * 2 + 16, 44)];
    [self.navigationController.navigationBar addSubview:navMenuView];
    
    //    朋友圈按钮
    _friendsBtn = [[HotMenuButton alloc]initWithFrame:CGRectMake(0, 12, friendsBtn_Width, 20)];
    [_friendsBtn setTitle:@"玩友圈" forState:UIControlStateNormal];
    _friendsBtn.titleLabel.textColor = RGBA(255, 255, 255, 1);
    [_friendsBtn addTarget:self action:@selector(friendsClick:) forControlEvents:UIControlEventTouchUpInside];
    [navMenuView addSubview:_friendsBtn];
    
    //    我的按钮
    _myBtn = [[HotMenuButton alloc]initWithFrame:CGRectMake(friendsBtn_Width + 16, 12, friendsBtn_Width, 20)];
    [_myBtn setTitle:@"我的" forState:UIControlStateNormal];
    
    if(_friendsBtnSelect) {//朋友圈按钮选择状态
        _myBtn.isFriendsMenuViewSelected = NO;
        _friendsBtn.isFriendsMenuViewSelected = YES;
    }else{
        _myBtn.isFriendsMenuViewSelected = YES;
        _friendsBtn.isFriendsMenuViewSelected = NO;
    }
    
    [_myBtn addTarget:self action:@selector(myClick:) forControlEvents:UIControlEventTouchUpInside];
    [navMenuView addSubview:_myBtn];
    
    //我的角标
//    _myBadge = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 2.f + 16 + 30 + 5, 10, 5, 5)];
    _myBadge = [[UILabel alloc]initWithFrame:CGRectMake(navMenuView.frame.size.width - 5, 10, 5, 5)];
    _myBadge.backgroundColor = [UIColor redColor];
    _myBadge.layer.cornerRadius = CGRectGetWidth(_myBadge.frame) / 2.f;
    _myBadge.layer.masksToBounds = YES;
    _myBadge.hidden = YES;
    [navMenuView addSubview:_myBadge];
    
    _lineView = [[UIView alloc]init];
    _lineView.bounds = CGRectMake(0,0,42, 2);
    if (_friendsBtnSelect) {
        _lineView.center = CGPointMake(_friendsBtn.center.x, navMenuView.frame.size.height - 1);
    }else{
        _lineView.center = CGPointMake(_myBtn.center.x, navMenuView.frame.size.height - 1);
    }
    _lineView.backgroundColor = RGBA(186, 40, 227, 1);
    [navMenuView addSubview:_lineView];
}

#pragma mark - 移除导航栏的按钮
- (void)removeNavMenuView{
    [_friendsBtn removeFromSuperview];
    [_myBadge removeFromSuperview];
    [_myBtn removeFromSuperview];
    [_carmerBtn removeFromSuperview];
    [_lineView removeFromSuperview];
    [effectView removeFromSuperview];
    
    _myBtn = nil;
    _friendsBtn = nil;
}

#pragma mark - 配置发布按钮
- (void)setupCarmerBtn{
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    effectView = [[UIVisualEffectView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2.f - 30, SCREEN_HEIGHT - 60, 60, 60)];
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
    CGFloat offset = 120;
    if(_isTopic)offset = 130;
    [UIView animateWithDuration:.4 animations:^{
        effectView.frame = CGRectMake((SCREEN_WIDTH - 60)/2.f, SCREEN_HEIGHT - offset - 3, 60, 60);
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            effectView.frame = CGRectMake((SCREEN_WIDTH - 60)/2.f, SCREEN_HEIGHT - offset, 60, 60);
        }];
    }];
    
    
}

#pragma mark - 玩友圈action
- (void)friendsClick:(UIButton *)friendsBtn{
    if (isExidtEffectView) [emojisView hideEmojiEffectView];
    _friendsBtnSelect = YES;
    [_scrollViewForTableView setContentOffset:CGPointZero];
//    _pageStartCountArray[0] = 0;
    if(((NSArray *)_dataArray[0]).count == 0) [self getDataWithType:0 needLoad:NO];
    _index = 0;
    _friendsBtn.isFriendsMenuViewSelected = YES;
    _myBtn.isFriendsMenuViewSelected = NO;
    [UIView animateWithDuration:0.1 animations:^{
        _lineView.center = CGPointMake(friendsBtn.center.x, _lineView.center.y);
    }];
}

#pragma mark - 我的action
- (void)myClick:(UIButton *)myBtn{
    [_scrollViewForTableView setContentOffset:CGPointMake(SCREEN_WIDTH, 0)];
    if(![MyUtil isUserLogin]){
        [MyUtil showCleanMessage:@"请先登录！"];
        [MyUtil gotoLogin];
        return;
    }
    if (isExidtEffectView) [emojisView hideEmojiEffectView];
    _index = 1;
    _friendsBtnSelect = NO;
//    _pageStartCountArray[1] = 0;
    _friendsBtn.isFriendsMenuViewSelected = NO;
    _myBtn.isFriendsMenuViewSelected = YES;
    if(((NSArray *)_dataArray[1]).count == 0) [self getDataWithType:1 needLoad:YES];//没有数据去加载数据
    [UIView animateWithDuration:0.1 animations:^{
        _lineView.center = CGPointMake(myBtn.center.x, _lineView.center.y);
    }];
}

#pragma mark - 配置表的cell
- (void)setupTableView{
    _scrollViewForTableView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    if(_isFriendToUserMessage) _scrollViewForTableView.frame = CGRectMake(0, -64, SCREEN_WIDTH, SCREEN_HEIGHT);
    _scrollViewForTableView.contentSize = CGSizeMake(SCREEN_WIDTH * _pageNum, SCREEN_HEIGHT);
    _scrollViewForTableView.pagingEnabled = YES;
    _scrollViewForTableView.delegate = self;
    _scrollViewForTableView.scrollsToTop = NO;
    [self.view addSubview:_scrollViewForTableView];
    
    for (int i = 0; i < _pageNum; i ++) {
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(i * SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        tableView.tag = i;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.contentInset = UIEdgeInsetsMake(64, 0, 49, 0);//玩友圈的表的内边距调整
        if(i == 1) tableView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);//我的表的内边距调整
        if(_isFriendToUserMessage) tableView.contentInset = UIEdgeInsetsZero;//好友动态表的内边距调整
        if(_isTopic || _isMessageDetail) tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);//详情和话题表的内边距调整
        [_tableViewArray addObject:tableView];
        if(i == 1) tableView.scrollsToTop = NO;
        [_scrollViewForTableView addSubview:tableView];
        [self setupMJRefreshForTableView:tableView i:i];//为表配置上下刷新控件
        }
    
    NSArray *array = @[LYFriendsNameCellID,LYFriendsAddressCellID,LYFriendsLikeCellID,LYFriendsCommentCellID,LYFriendsAllCommentCellID,LYFriendsVideoCellID,LYFriendsAllLikeCellID];
    for (NSString *cellIdentifer in array) {//注册单元格
        [_tableViewArray enumerateObjectsUsingBlock:^(UITableView *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj registerNib:[UINib nibWithNibName:cellIdentifer bundle:nil] forCellReuseIdentifier:cellIdentifer];
            [obj registerClass:[UITableViewCell class] forCellReuseIdentifier:LYFriendsCellID];
            [obj registerClass:[LYFriendsImgTableViewCell class] forCellReuseIdentifier:LYFriendsImgCellID];
        }];
    }
    
    //表设置代理
    [_tableViewArray enumerateObjectsUsingBlock:^(UITableView *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.dataSource = self;
        obj.delegate = self;
    }];
    
    [self startGetData];//开始获取数据
    
}

#pragma mark - 获取数据
- (void)startGetData{
    UITableView *tableView = _tableViewArray.firstObject;
    [tableView.mj_header beginRefreshing];
}

#pragma mark - 为表配置上下刷新控件
- (void)setupMJRefreshForTableView:(UITableView *)tableView i:(NSInteger)i{
    __weak __typeof(self) weakSelf = self;
    tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        _pageStartCountArray[i] = 0;
        [weakSelf getDataWithType:i needLoad:NO];
    }];
    MJRefreshGifHeader *header = (MJRefreshGifHeader *)tableView.mj_header;
    [self initMJRefeshHeaderForGif:header];
    
    tableView.mj_footer = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
        [weakSelf getDataWithType:i needLoad:NO];
    }];

}


#pragma mark - 获取我的未读消息数
- (void)getFriendsNewMessage{
    _results = @"";
    _icon = @"";
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if(app.userModel == nil)return;
    
    NSDictionary *paraDic = @{@"userId":_useridStr};
    __weak __typeof(self) weakSelf = self;
    [LYFriendsHttpTool friendsGetFriendsMessageNotificationWithParams:paraDic compelte:^(NSString * reslults, NSString *icon) {
        _results = reslults;
        _icon = icon;
        if(_results) _myBadge.hidden = NO;
        else _myBadge.hidden = YES;
        if(_results.integerValue){
            _myBadge.hidden = NO;
            if(_pageNum <= 1) return;
            UITableView *tableView = [_tableViewArray objectAtIndex:1];
            tableView.tableHeaderView = nil;
            [weakSelf addTableViewHeader];
        }
    }];
}

#pragma mark - 添加表头
- (void)addTableViewHeader{
    _headerView = [[[NSBundle mainBundle]loadNibNamed:@"LYFriendsUserHeaderView" owner:nil options:nil]firstObject];
    _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 240);
    if(_results.integerValue){//有新消息
        _headerView.btn_newMessage.hidden = NO;
        _myBadge.hidden = NO;
    }else{
        _headerView.btn_newMessage.hidden = YES;
        _headerView.imageView_NewMessageIcon.hidden = YES;
        _myBadge.hidden = YES;
    }
    
//    if(_pageNum <= 1) return;
    [self setupTableForHeaderForMinPage];//为我的界面添加表头
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesChooseBgImage)];
    [_headerView.ImageView_bg addGestureRecognizer:tapGes];
}

- (void)setUserM:(FriendsUserInfoModel *)userM{
    _userM = userM;
}

- (void)setupTableForHeaderForMinPage{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UITableView *tableView = nil;
    UserModel *userM = [[UserModel alloc]init];
    if(_tableViewArray.count >= 2){
        tableView = [_tableViewArray objectAtIndex:1];
        userM = app.userModel;
    }else{
        tableView = [_tableViewArray objectAtIndex:0];
        userM.avatar_img = _userM.avatar_img;
        userM.usernick = _userM.usernick;
    }
    [_headerView.imageView_NewMessageIcon sd_setImageWithURL:[NSURL URLWithString:_icon]  placeholderImage:[UIImage imageNamed:@"empyImage120"]];
    _headerView.imageView_NewMessageIcon.clipsToBounds = YES;
    [_headerView.btn_newMessage setTitle:[NSString stringWithFormat:@"%@条新消息",_results] forState:UIControlStateNormal];
    [_headerView.btn_header sd_setBackgroundImageWithURL:[NSURL URLWithString:userM.avatar_img?userM.avatar_img:@""] forState:UIControlStateNormal ];
    
    if(_isFriendToUserMessage)  [_headerView.btn_header addTarget:self action:@selector(headerImgClick:) forControlEvents:UIControlEventTouchUpInside];
    _headerView.label_name.text = userM.usernick;
    tableView.tableHeaderView = _headerView;
    [_headerView.btn_newMessage addTarget:self action:@selector(newClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self updateViewConstraints];
    
    if(_isFriendToUserMessage){
        [_headerView.ImageView_bg sd_setImageWithURL:[NSURL URLWithString:_userM.friends_img] placeholderImage:[UIImage imageNamed:@"friendPresentBG.jpg"]];
        
    }else{
        NSData *imageData = [[NSUserDefaults standardUserDefaults] objectForKey:@"FriendUserBgImage"];
        if(!_userBgImageUrl){
            _headerView.ImageView_bg.image = [[UIImage alloc]initWithData:imageData];
        }else{
            if(imageData){
//                [_headerView.ImageView_bg sd_setImageWithURL:[NSURL URLWithString:_userBgImageUrl] placeholderImage:[[UIImage alloc]initWithData:imageData]];
                [_headerView.ImageView_bg setImage:[UIImage imageWithData:imageData]];
            }else{
                [_headerView.ImageView_bg sd_setImageWithURL:[NSURL URLWithString:_userBgImageUrl] placeholderImage:[UIImage imageNamed:@"friendPresentBG.jpg"]];
            }
        }
        if(imageData == nil && [MyUtil isEmptyString:_userBgImageUrl]){
            _headerView.ImageView_bg.image = [UIImage imageNamed:@"friendPresentBG.jpg"];
        }
        _headerView.ImageView_bg.userInteractionEnabled = YES;
    }
    _headerView.ImageView_bg.clipsToBounds = YES;
}

- (void)headerImgClick:(UIButton *)button{
    
    LYMyFriendDetailViewController *myFriendVC = [[LYMyFriendDetailViewController  alloc]initWithNibName:@"LYMyFriendDetailViewController" bundle:nil];
    myFriendVC.userID = _userM.userId;
    [self.navigationController pushViewController:myFriendVC animated:YES];
    
}

#pragma mark - 表头选择背景action
- (void)tapGesChooseBgImage{
    UIActionSheet *menuSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"更改相册封面", nil];
    menuSheet.tag = 200;
    [menuSheet showInView:self.view];
}

#pragma mark - 话题的表头
- (void)addTableViewHeaderViewForTopic{
    UITableView *tableView = _tableViewArray.firstObject;
    UIScrollView *topicScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 86)];
    topicScrollView.scrollsToTop = NO;
    topicScrollView.backgroundColor  = RGB(237, 237, 237);
    topicScrollView.showsHorizontalScrollIndicator = NO;
    topicScrollView.showsVerticalScrollIndicator = NO;
    
    tableView.tableHeaderView = topicScrollView;
    
    
    NSDictionary *dic = @{@"type":@"2"};
    [LYUserHttpTool getTopicList:dic complete:^(NSArray *dataList) {
        _topicArray = dataList;
        CGFloat btnWidth = 128;
        for (int i = 0; i < dataList.count; i ++) {
            
            UIButton *topicBtn = [[UIButton alloc]initWithFrame:CGRectMake(i *(btnWidth  + 8) + 8, 8, btnWidth, 70)];
            TopicModel *topicM = dataList[i];
            [topicBtn setTitle:topicM.name forState:UIControlStateNormal];
            topicBtn.titleLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightMedium];
            topicBtn.titleLabel.layer.shadowColor = RGBA(0, 0, 0, .5).CGColor;
            topicBtn.titleLabel.layer.shadowOffset = CGSizeMake(0, 1);
            topicBtn.titleLabel.layer.shadowOpacity = 1;
            topicBtn.titleLabel.layer.shadowRadius = 2;
            topicBtn.layer.cornerRadius = 4;
            topicBtn.clipsToBounds = YES;
            [topicBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?imageView2/0/w/256/h/140",topicM.linkurl] ] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"empyImage16_9"]];
            [topicScrollView addSubview:topicBtn];
            topicBtn.tag = i;
            [topicBtn addTarget:self action:@selector(topicClick:) forControlEvents:UIControlEventTouchUpInside];
            if(i == dataList.count - 1){
                topicScrollView.contentSize = CGSizeMake(CGRectGetMaxX(topicBtn.frame) + 8, topicScrollView.contentSize.height);
            }
        }
    }];
    
}
#pragma mark - 话题action
- (void)topicClick:(UIButton *)button{
    
    TopicModel *topicM = _topicArray[button.tag];
    LYFriendsTopicsViewController *fridendTopicVC = [[LYFriendsTopicsViewController alloc]init];
    fridendTopicVC.topicTypeId = topicM.id;
    fridendTopicVC.topicName = topicM.name;
    fridendTopicVC.isFriendsTopic = YES;
    fridendTopicVC.isFriendToUserMessage = YES;
    fridendTopicVC.isTopic = YES;
    fridendTopicVC.headerViewImgLink = topicM.linkurl;
    [self.navigationController pushViewController:fridendTopicVC animated:YES];
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (isExidtEffectView) {
        isExidtEffectView = NO;
        [emojisView hideEmojiEffectView];
    }
    
    if(_scrollViewForTableView != scrollView){
        CGFloat offset;
        if(_isTopic){//话题
            offset = 10;
        }else{
            offset = 0;
        }
        
        if (scrollView.contentOffset.y > _contentOffSetY) {
            if (scrollView.contentOffset.y <= 0.f) {//发布按钮弹出
                effectView.frame = CGRectMake((SCREEN_WIDTH - 60)/2.f, SCREEN_HEIGHT - 120 + offset, 60, 60);
            }else{
                [UIView animateWithDuration:0.4 animations:^{
                    effectView.frame = CGRectMake((SCREEN_WIDTH - 60)/2.f, SCREEN_HEIGHT, 60, 60);
                }];
            }
        }else{
            if(CGRectGetMaxY(effectView.frame) > SCREEN_HEIGHT - 5){//发布按钮下移
                [UIView animateWithDuration:.4 animations:^{
                    effectView.frame = CGRectMake((SCREEN_WIDTH - 60)/2.f, SCREEN_HEIGHT - 123 + offset, 60, 60);
                }completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.2 animations:^{
                        effectView.frame = CGRectMake((SCREEN_WIDTH - 60)/2.f, SCREEN_HEIGHT - 120 +offset, 60, 60);
                    }];
                }];
            }
        }
    }else{
        if (!_index) {//玩友圈
            _friendsBtn.isFriendsMenuViewSelected = YES;
        }else{
            _friendsBtn.isFriendsMenuViewSelected = NO;
        }
        _myBtn.isFriendsMenuViewSelected = !_friendsBtn.isFriendsMenuViewSelected;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if(_scrollViewForTableView  != scrollView){
    _contentOffSetY = scrollView.contentOffset.y;//拖拽结束获取偏移量
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if(scrollView == _scrollViewForTableView){
        _index = scrollView.contentOffset.x / SCREEN_WIDTH;
        
        [_tableViewArray enumerateObjectsUsingBlock:^(UITableView *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.scrollsToTop = NO;
        }];
        UITableView *tableView = _tableViewArray[_index];
        tableView.scrollsToTop = YES;
        
        if (_index == 1) {
            _myBtn.isFriendsMenuViewSelected = YES;
            _friendsBtn.isFriendsMenuViewSelected = NO;
            [UIView animateWithDuration:0.1 animations:^{
                _lineView.center = CGPointMake(_myBtn.center.x, _lineView.center.y);
            }];
            NSArray *array = _dataArray[_index];
            if(array.count) return;
            [self getDataWithType:dataForMine needLoad:YES];//获取我的玩友圈数据
        }else{
            _myBtn.isFriendsMenuViewSelected = NO;
            _friendsBtn.isFriendsMenuViewSelected = YES;
            [UIView animateWithDuration:0.1 animations:^{
                _lineView.center = CGPointMake(_friendsBtn.center.x, _lineView.center.y);
            }];
        }
    }
}

#pragma mark - UITableViewDelegate&UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSArray *array = ((NSArray *)_dataArray[tableView.tag]);
    return array.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *array = (NSArray *)_dataArray[tableView.tag];
    FriendsRecentModel *recentM = array[section];
    if (recentM.commentNum.integerValue >= 1) {
        return 5  + recentM.commentList.count;
    }else{
        if(!recentM.commentList.count) return 5;
        return 4 + recentM.commentList.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *dataArr = _dataArray[tableView.tag];
    FriendsRecentModel *recentM = dataArr[indexPath.section];
    switch (indexPath.row) {
        case 0://昵称 头像 动态文本的cell
        {
            LYFriendsNameTableViewCell *nameCell = [tableView dequeueReusableCellWithIdentifier:LYFriendsNameCellID forIndexPath:indexPath];
            nameCell.recentM = recentM;
            nameCell.btn_delete.tag = indexPath.section;
            nameCell.btn_topic.tag = indexPath.section;
            [nameCell.btn_topic addTarget:self action:@selector(topicNameClick:) forControlEvents:UIControlEventTouchUpInside];
            if (!tableView.tag) {
                [nameCell.btn_delete setTitle:@"" forState:UIControlStateNormal];
                [nameCell.btn_delete setImage:[[UIImage imageNamed:@"downArrow"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
                [nameCell.btn_delete addTarget:self action:@selector(warningSheet:) forControlEvents:UIControlEventTouchUpInside];
                if ([recentM.userId isEqualToString:[NSString stringWithFormat:@"%d",self.userModel.userid]]) {
                    nameCell.btn_delete.hidden = YES;
                    nameCell.btn_delete.enabled = NO;
                }else{
                    nameCell.btn_delete.hidden = NO;
                    nameCell.btn_delete.enabled = YES;
                }
                nameCell.btn_headerImg.tag = indexPath.section;
                [nameCell.btn_headerImg addTarget:self action:@selector(pushUserMessagePage:) forControlEvents:UIControlEventTouchUpInside];
            }else{
                [nameCell.btn_delete setTitle:@"删除" forState:UIControlStateNormal];
                [nameCell.btn_delete setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                [nameCell.btn_delete addTarget:self action:@selector(deleteClick:) forControlEvents:UIControlEventTouchUpInside];
                nameCell.btn_delete.hidden = NO;
                nameCell.btn_delete.enabled = YES;
            }
            
            if(_isFriendToUserMessage) {//好友动态隐藏删除按钮
                nameCell.btn_delete.hidden = YES;
                if(_isTopic){
                    nameCell.btn_delete.hidden = NO;
                    if([recentM.userId isEqualToString:_useridStr]) nameCell.btn_delete.hidden = YES;//话题中我的话题隐藏删除按钮
                }
            }
            
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
            LYFriendsAddressTableViewCell *addressCell = [tableView dequeueReusableCellWithIdentifier:LYFriendsAddressCellID forIndexPath:indexPath];
            addressCell.recentM = recentM;
            addressCell.btn_like.tag = indexPath.section;
            addressCell.btn_comment.tag = indexPath.section;
            [addressCell.btn_like addTarget:self action:@selector(likeFriendsClick:) forControlEvents:UIControlEventTouchUpInside];
            
            UILongPressGestureRecognizer *likeLongPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(likeLongPressClick:)];
            [addressCell.btn_like addGestureRecognizer:likeLongPress];
            
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
            int commentCount = 0;
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
    NSArray *arr = _dataArray[tableView.tag];
    NSLog(@"--->%ld",indexPath.section);
    
    FriendsRecentModel *recentM = arr[indexPath.section];
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
            return 70 + size.height ;
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
            
        default://评论
        {
            if(!recentM.commentList.count) return 36;
            if(indexPath.row - 4 > recentM.commentList.count - 1) return 36;
            
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
    FriendsRecentModel *recentM = _dataArray[_index][indexPath.section];
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
    FriendsRecentModel *friendRecentM = _dataArray[_index][button.tag];
    if ([friendRecentM.isBarTopicType isEqualToString:@"0"]) {
        if (friendRecentM.topicTypeName.length && friendRecentM.topicTypeId.length) {
            if(_isTopic) return;
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
        NSArray *dataArr = _dataArray[_index];
        FriendsRecentModel *recentM = dataArr[button.tag];
        jubaoMomentID = recentM.id;
        jubaoUserID = recentM.userId;
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"屏蔽此人",@"举报内容", nil];
        actionSheet.tag = 131;
        [actionSheet showInView:self.view];
    }
}

#pragma mark - 点击头像跳转到指定用户界面
- (void)pushUserMessagePage:(UIButton *)button{
    FriendsRecentModel *recentM = _dataArray[_index][button.tag];
    //    if([recentM.userId isEqualToString:_useridStr]) return;
    if([recentM.userId isEqualToString:_useridStr] || [MyUtil isEmptyString:recentM.userId]) {
        return;
    }
    
    LYMyFriendDetailViewController *myFriendVC = [[LYMyFriendDetailViewController  alloc]initWithNibName:@"LYMyFriendDetailViewController" bundle:nil];
    myFriendVC.userID = recentM.userId;
    [self.navigationController pushViewController:myFriendVC animated:YES];
}

#pragma mark － 删除我的动态
- (void)deleteClick:(UIButton *)button{
    if (isExidtEffectView) [emojisView hideEmojiEffectView];
    if(_index){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"确定删除这条动态" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
        _deleteMessageTag = button.tag;
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex) {//删除我的动态
        NSMutableArray *array = _dataArray[_index];
        FriendsRecentModel *recentM = array[_deleteMessageTag];
        if(![MyUtil isUserLogin]){
            [MyUtil showCleanMessage:@"请先登录！"];
            [MyUtil gotoLogin];
            return;
        }
        NSDictionary *paraDic = @{@"userId":_useridStr,@"messageId":recentM.id};
        [LYFriendsHttpTool friendsDeleteMyMessageWithParams:paraDic compelte:^(bool result) {
            if (result) {
                [array removeObjectAtIndex:_deleteMessageTag];
                UITableView *tableView = [_tableViewArray objectAtIndex:_index];
//                [tableView reloadData];
                
                [tableView deleteSections:[NSIndexSet indexSetWithIndex:_deleteMessageTag] withRowAnimation:UITableViewRowAnimationTop];
            }
        }];
    }
}
#pragma mark - 表白action
- (void)likeFriendsClick:(UIButton *)button{
    if(![MyUtil isUserLogin]){
        [MyUtil showCleanMessage:@"请先登录！"];
        [MyUtil gotoLogin];
        return;
    }
    if (isExidtEffectView) [emojisView hideEmojiEffectView];
    UITableView *tableView = [_tableViewArray objectAtIndex:_index];
    LYFriendsAddressTableViewCell *cell = (LYFriendsAddressTableViewCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:button.tag]];
    cell.btn_like.enabled = NO;
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    FriendsRecentModel *recentModel = _dataArray[_index][button.tag];
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
            float distance = button.superview.superview.frame.origin.y - tableView.contentOffset.y;
            imageSubview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            //            imageSubview.backgroundColor = RGBA(0, 0, 0, 0.1);
            imageSubview.backgroundColor = [UIColor clearColor];
            //            imageSubview.tag = 541127;
            UITapGestureRecognizer *tapImageSubview = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideDefaultPage:)];
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
        [tableView reloadData];
        cell.btn_like.enabled = YES;
    }];
}
#pragma mark － 长按表白
- (void)likeLongPressClick:(UILongPressGestureRecognizer *)gesture{
    //    if (!emojiEffectView) {
    //        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    //        emojiEffectView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
    //        emojiEffectView.tag = 577;
    //        [emojiEffectView setFrame:CGRectMake(-80, 0, 80, SCREEN_HEIGHT)];
    //        [emojiEffectView setAlpha:1];
    //        emojiEffectView.layer.shadowColor = [RGBA(0, 0, 0, 1) CGColor];
    //        emojiEffectView.layer.shadowOffset = CGSizeMake(0.5, 0);
    //        emojiEffectView.layer.shadowRadius = 1;
    //        emojiEffectView.layer.shadowOpacity = 0.3;
    ////        [self.view bringSubviewToFront:emojiEffectView];
    //
    //
    //        int margin = ( SCREEN_HEIGHT - 240 ) / 7;
    //
    //        emoji_angry = [[UIButton alloc]initWithFrame:CGRectMake(-80, margin, 80, 40)];
    //        [emoji_angry setImage:[UIImage imageNamed:@"angry0"] forState:UIControlStateNormal];
    //        [emoji_angry.imageView setContentMode:UIViewContentModeScaleAspectFit];
    //        emoji_angry.tag = 201;
    //        [emoji_angry addTarget:self action:@selector(clickEmojiBtn:) forControlEvents:UIControlEventTouchUpInside];
    //
    //        emoji_sad = [[UIButton alloc]initWithFrame:CGRectMake(-80, margin * 2 + 40, 80, 40)];
    //        [emoji_sad setImage:[UIImage imageNamed:@"sad0"] forState:UIControlStateNormal];
    //        [emoji_sad.imageView setContentMode:UIViewContentModeScaleAspectFit];
    //        emoji_sad.tag = 202;
    //        [emoji_sad addTarget:self action:@selector(clickEmojiBtn:) forControlEvents:UIControlEventTouchUpInside];
    //
    //        emoji_wow = [[UIButton alloc]initWithFrame:CGRectMake(-80, margin * 3 + 80, 80, 40)];
    //        [emoji_wow setImage:[UIImage imageNamed:@"wow0"] forState:UIControlStateNormal];
    //        [emoji_wow.imageView setContentMode:UIViewContentModeScaleAspectFit];
    //        emoji_wow.tag = 203;
    //        [emoji_wow addTarget:self action:@selector(clickEmojiBtn:) forControlEvents:UIControlEventTouchUpInside];
    //
    //        emoji_kawayi = [[UIButton alloc]initWithFrame:CGRectMake(-80, margin * 4 + 120, 80, 40)];
    //        [emoji_kawayi setImage:[UIImage imageNamed:@"kawayi0"] forState:UIControlStateNormal];
    //        [emoji_kawayi.imageView setContentMode:UIViewContentModeScaleAspectFit];
    //        emoji_kawayi.tag = 204;
    //        [emoji_kawayi addTarget:self action:@selector(clickEmojiBtn:) forControlEvents:UIControlEventTouchUpInside];
    //
    //        emoji_happy = [[UIButton alloc]initWithFrame:CGRectMake(-80, margin * 5 + 160, 80, 40)];
    //        [emoji_happy setImage:[UIImage imageNamed:@"happy0"] forState:UIControlStateNormal];
    //        [emoji_happy.imageView setContentMode:UIViewContentModeScaleAspectFit];
    //        emoji_happy.tag = 205;
    //        [emoji_happy addTarget:self action:@selector(clickEmojiBtn:) forControlEvents:UIControlEventTouchUpInside];
    //
    //        emoji_zan = [[UIButton alloc]initWithFrame:CGRectMake(-80, margin * 6 + 200, 80, 40)];
    //        [emoji_zan setImage:[UIImage imageNamed:@"dianzan0"] forState:UIControlStateNormal];
    //        [emoji_zan.imageView setContentMode:UIViewContentModeScaleAspectFit];
    //        emoji_zan.tag = 206;
    //        [emoji_zan addTarget:self action:@selector(clickEmojiBtn:) forControlEvents:UIControlEventTouchUpInside];
    //
    //        [_mainWindow addSubview:emojiEffectView];
    //        [_mainWindow addSubview:emoji_zan];
    //        [_mainWindow addSubview:emoji_happy];
    //        [_mainWindow addSubview:emoji_kawayi];
    //        [_mainWindow addSubview:emoji_wow];
    //        [_mainWindow addSubview:emoji_angry];
    //        [_mainWindow addSubview:emoji_sad];
    //
    //    }
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
    UITableView *tableView = [_tableViewArray objectAtIndex:_index];
    LYFriendsAddressTableViewCell *cell = (LYFriendsAddressTableViewCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:gestureViewTag]];
    cell.btn_like.enabled = NO;
    FriendsRecentModel *recentM = _dataArray[_index][gestureViewTag];
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
        [tableView reloadData];
        //        cell.btn_like.enabled = YES;
    }];
}

#pragma mark - 更多赞
- (void)likeMoreClick:(UIButton *)button{
    [self pushFriendsMessageDetailVCWithIndex:button.tag];
}

#pragma mark － 跳转消息详情页面
- (void)pushFriendsMessageDetailVCWithIndex:(NSInteger)index{
    FriendsRecentModel *recentM = _dataArray[_index][index];
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
        FriendsRecentModel *recentM = _dataArray[_index][section];
        if(i >= recentM.likeList.count) return;
        
        FriendsLikeModel *likeM = recentM.likeList[i];
        if ([likeM.userId isEqualToString:_useridStr]) {//如果头像是自己return
            return;
        }
        //    LYFriendsToUserMessageViewController *messageVC = [[LYFriendsToUserMessageViewController alloc]init];
        //    messageVC.friendsId = likeM.userId;
        //    [self.navigationController pushViewController:messageVC animated:YES];
        //跳转到朋友详情页面
        LYMyFriendDetailViewController *myFriendVC = [[LYMyFriendDetailViewController  alloc]initWithNibName:@"LYMyFriendDetailViewController" bundle:nil];
        myFriendVC.userID = likeM.userId;
        [self.navigationController pushViewController:myFriendVC animated:YES];
    }
}

#pragma mark － 评论点击头像跳转到指定用户界面
- (void)pushUserPage:(LYFriendsCommentButton *)button{
    FriendsRecentModel *recentM = _dataArray[_index][button.tag];
    if(button.indexTag - 4 >= recentM.commentList.count) return;
    FriendsCommentModel *commentModel = recentM.commentList[button.indexTag - 4];
    
    NSString *idStr = nil;
    if (button.isFirst) {//fist
        idStr = commentModel.userId;
    }else{
        idStr = commentModel.toUserId;
    }
    
    
    if([idStr isEqualToString:_useridStr]) return;
    //    LYFriendsToUserMessageViewController *friendsUserMegVC = [[LYFriendsToUserMessageViewController alloc]init];
    //    friendsUserMegVC.friendsId = commentModel.userId;
    //    [self.navigationController pushViewController:friendsUserMegVC animated:YES];
    
    LYMyFriendDetailViewController *myFriendVC = [[LYMyFriendDetailViewController  alloc]initWithNibName:@"LYMyFriendDetailViewController" bundle:nil];
    myFriendVC.userID = idStr;
    [self.navigationController pushViewController:myFriendVC animated:YES];
}

#pragma mark - 视频播放
- (void)playVideo:(UIButton *)button{
    playerSection = button.tag;
    NSArray *array = _dataArray[_index];
    UITableView *tableView = [_tableViewArray objectAtIndex:_index];
    FriendsRecentModel *recentM = (FriendsRecentModel *)array[button.tag];
    FriendsPicAndVideoModel *pvM = (FriendsPicAndVideoModel *)recentM.lyMomentsAttachList[0];
    //    NSString *urlString = [MyUtil configureNetworkConnect] == 1 ?[MyUtil getQiniuUrl:pvM.imageLink mediaType:QiNiuUploadTpyeSmallMedia width:0 andHeight:0] : [MyUtil getQiniuUrl:pvM.imageLink mediaType:QiNiuUploadTpyeMedia width:0 andHeight:0];
    QiNiuUploadTpye quType = [MyUtil configureNetworkConnect] == 1 ? QiNiuUploadTpyeSmallMedia : QiNiuUploadTpyeMedia;
    
    NSURL *url;
    if ([LYDateUtil isMoreThanFiveMinutes:recentM.date]) {
        url = [NSURL URLWithString:[MyUtil getQiniuUrl:pvM.imageLink mediaType:quType width:0 andHeight:0]] ;
    }else{
        url = [NSURL URLWithString:[MyUtil getQiniuUrl:pvM.imageLink mediaType:QiNiuUploadTpyeBigMedia width:0 andHeight:0]];
    }
    //    NSLog(@"--->%@",[MyUtil getQiniuUrl:pvM.imageLink mediaType:quType width:0 andHeight:0]);
//    NSURL *url = [NSURL URLWithString:[[MyUtil getQiniuUrl:pvM.imageLink mediaType:quType width:0 andHeight:0] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] ;
    if (recentM.isMeSendMessage){
        url = [[NSURL alloc] initFileURLWithPath:pvM.imageLink];
        
    }
    
    
    if (player.moviePlayer.playbackState != MPMoviePlaybackStateStopped) {
        //               [player removeFromParentViewController];
        //不是正常停止
        isDisturb = YES;
    }
    
    [player.view removeFromSuperview];
    
    friendsVedioCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:button.tag]];
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
    UITableView *tableView = [_tableViewArray objectAtIndex:_index];
    NSDictionary *dic = @{@"attachType":@"1",@"content":content,@"location":location,@"topicID":topicID,@"topicName":topicName};
    FriendsRecentModel *recentM = [self createModelForISendAMessageWithDicForMessage:dic];
    recentM.thunbImage = image;
    FriendsPicAndVideoModel *pvModel = [[FriendsPicAndVideoModel alloc]init];
    pvModel.imageLink = mediaUrl;
    [[SDWebImageManager sharedManager] saveImageToCache:image forURL:[NSURL URLWithString:[MyUtil  getQiniuUrl:mediaUrl mediaType:QiNiuUploadTpyeDefault width:0 andHeight:0]]];//利用sdwebImage把自己发的动态图片缓存道本地（下面同理）
    _saveImageAndVideoIndex ++;
    recentM.lyMomentsAttachList = @[pvModel];
    
    NSMutableArray *arr1 = _dataArray[0];
    [arr1 insertObject:recentM atIndex:0];
     if(_dataArray.count == 2){
        NSMutableArray *arr2 = _dataArray[1];
         if(arr2.count) [arr2 insertObject:recentM atIndex:0];
    }
    [tableView reloadData];
    
}

#pragma mark - 作为代理接受返回的图片
- (void)sendImagesArray:(NSArray *)imagesArray andContent:(NSString *)content andLocation:(NSString *)location andTopicID:(NSString *)topicID andTopicName:(NSString *)topicName{
    UITableView *tableView = [_tableViewArray objectAtIndex:_index];
    NSDictionary *dic = @{@"attachType":@"0",@"content":content,@"location":location,@"topicID":topicID,@"topicName":topicName};
    FriendsRecentModel *recentM = [self createModelForISendAMessageWithDicForMessage:dic];
    
    FriendsPicAndVideoModel *pvModel = [[FriendsPicAndVideoModel alloc]init];
    NSString *imageLink = nil;
    NSString *appendLink = nil;
    CGFloat picWidth = 0;
    for (int i = 0;i < imagesArray.count;i ++) {
        UIImage *image = imagesArray[i];
        pvModel.imageLink = [pvModel.imageLink stringByAppendingString:[[NSString stringWithFormat:@"myPicture%d%d",_saveImageAndVideoIndex,i] stringByAppendingString:@","]];
        
        appendLink = [NSString stringWithFormat:@"myPicture%d%d,",_saveImageAndVideoIndex,i];
        if(i == imagesArray.count - 1) appendLink = [NSString stringWithFormat:@"myPicture%d%d",_saveImageAndVideoIndex,i];
        
        if(!i) imageLink = appendLink;
        else imageLink = [imageLink stringByAppendingString:appendLink];
        
        picWidth = imagesArray.count == 1 ? 0 : 450;
        
        [[SDWebImageManager sharedManager] saveImageToCache:image forURL:[NSURL URLWithString:[MyUtil getQiniuUrl:[NSString stringWithFormat:@"myPicture%d%d",_saveImageAndVideoIndex,i] width:0 andHeight:0]]];
        _saveImageAndVideoIndex ++;
        
    }
    pvModel.imageLink = imageLink;
    recentM.lyMomentsAttachList = @[pvModel];
    
    
        NSMutableArray *arr1 = _dataArray[0];
        [arr1 insertObject:recentM atIndex:0];
     if(_dataArray.count == 2){
        NSMutableArray *arr2 = _dataArray[1];
        if(arr2.count) [arr2 insertObject:recentM atIndex:0];
    }
    [tableView reloadData];
    
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
    for (int i = 0; i < _dataArray.count; i ++) {
        NSMutableArray *arr = _dataArray[i];
        if(arr.count){
            FriendsRecentModel *recentM = arr[0];
            recentM.id = [NSString stringWithFormat:@"%@",messageId];
        }
    }
    
//    NSMutableArray *arr = _dataArray.firstObject;
//    FriendsRecentModel *recentM = arr.firstObject;
//    recentM.id = [NSString stringWithFormat:@"%@",messageId];
    
//    [self reloadTableViewAndSetUpPropertyneedSetContentOffset:YES];
    [_tableViewArray enumerateObjectsUsingBlock:^(UITableView *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj reloadData];
    }];
}

#pragma mark - 隐藏引导页
- (void)hideDefaultPage:(UITapGestureRecognizer *)gesture{
    //    if (gesture.view.tag == 541128) {
    //
    //        [USER_DEFAULT setObject:@"NO" forKey:@"firstUseFriendLike"];
    //        [imageSubview removeFromSuperview];
    //        [imageView removeFromSuperview];
    //    }else if (gesture.view.tag == 541127){
    //
    [imageSubview removeFromSuperview];
    [imageView removeFromSuperview];
    //    }
}

- (void)hideImageTip:(UIGestureRecognizer *)gesture{
    [USER_DEFAULT setObject:@"NO" forKey:@"firstUseFriendLike"];
    [imageSubview removeFromSuperview];
    [imageView removeFromSuperview];
}

#pragma mark - 新消息action
- (void)newClick{
    _results = @"";
    _icon = @"";
    LYFriendsMessageViewController *messageVC = [[LYFriendsMessageViewController alloc]init];
    [self.navigationController pushViewController:messageVC animated:YES];
    
//    [self removeTableViewHeader];
    UITableView *tableView = [_tableViewArray objectAtIndex:1];
    tableView.tableHeaderView = nil;
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
            
            FriendsRecentModel *recetnM = _dataArray[_index][_section];
            FriendsCommentModel *commentM = recetnM.commentList[_indexRow - 4];
            if(![MyUtil isUserLogin]){
                [MyUtil showCleanMessage:@"请先登录！"];
                [MyUtil gotoLogin];
                return;
            }
            NSDictionary *paraDic = @{@"userId":_useridStr,@"commentId":commentM.commentId};
            [LYFriendsHttpTool friendsDeleteMyCommentWithParams:paraDic compelte:^(bool result) {
                if(result){
                    NSMutableArray *commentArr = ((FriendsRecentModel *)_dataArray[_index][_section]).commentList;
                    [commentArr removeObjectAtIndex:_indexRow - 4];
                    recetnM.commentNum = [NSString stringWithFormat:@"%d",recetnM.commentNum.intValue - 1];
                    UITableView *tableView = _tableViewArray[_index];
                    [tableView reloadData];
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
//                _pageStartCountFriends = 0;
//                [weakSelf getDataFriendsWithSetContentOffSet:NO needLoading:YES];
                UITableView *tableView = _tableViewArray.firstObject;
                [tableView.mj_header beginRefreshing];
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
    //NSLog(@"---->%@",NSStringFromCGRect(_bigView.frame));
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
        FriendsRecentModel *recentM = (FriendsRecentModel *)_dataArray[_index][_section];
        if(!recentM.commentList.count) return;
        FriendsCommentModel *commentM = recentM.commentList[_indexRow - 4];
        _commentView.textField.placeholder = [NSString stringWithFormat:@"回复%@",commentM.nickName];
    }
    //  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBorderApearce:) name:UIKeyboardAnimation object:nil];
    
    //    [UIView animateWithDuration:.25 animations:^{
    //        _commentView.frame = CGRectMake(0, SCREEN_HEIGHT - 244 - 59, SCREEN_WIDTH, 49);
    //    } completion:^(BOOL finished) {
    //
    //    }];
    
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
            //        NSLog(@"----->%@",NSStringFromCGRect(_commentView.frame));
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
    
    //    defaultComment = _commentView.textField.text;
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    FriendsRecentModel *recentM = nil;
    NSString *toUserId = nil;
    NSString *toUserNickName = nil;
    if (_isCommentToUser) {//对其他人回复
        recentM = _dataArray[_index][_section];
        FriendsCommentModel *commentModel = recentM.commentList[_indexRow - 4];
        toUserId = commentModel.userId;
        toUserNickName = commentModel.nickName;
    }else{//自己对动态评论
        recentM = _dataArray[_index][_commentBtnTag];
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
            //           [weakSelf.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:4 + recentM.commentList.count inSection:_commentBtnTag]] withRowAnimation:UITableViewRowAnimationTop];
            //            weakSelf.tableView reloadRowsAtIndexPaths:<#(nonnull NSArray<NSIndexPath *> *)#> withRowAnimation:<#(UITableViewRowAnimation)#>
            UITableView *tableView = [_tableViewArray objectAtIndex:_index];
            [tableView reloadData];
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
    
    NSArray *urlArray = [((FriendsPicAndVideoModel *)((FriendsRecentModel *)_dataArray[_index][section]).lyMomentsAttachList[0]).imageLink componentsSeparatedByString:@","];
    UITableView *tableView = [_tableViewArray objectAtIndex:_index];
    LYFriendsImgTableViewCell *imgCell = (LYFriendsImgTableViewCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:section]];
    for (UIButton *btn in imgCell.btnArray) {
        CGRect rect = [imgCell convertRect:btn.frame toView:app.window];
        [oldFrameArray addObject:NSStringFromCGRect(rect)];
    }
    //查看图片的视图
    LYPictiureView *picView = [[LYPictiureView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) urlArray:urlArray oldFrame:oldFrameArray with:index];
    picView.backgroundColor = [UIColor blackColor];
    
    [app.window addSubview:picView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
