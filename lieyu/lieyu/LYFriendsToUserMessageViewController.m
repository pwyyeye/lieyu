//
//  LYFriendsToUserMessageViewController.m
//  lieyu
//
//  Created by 狼族 on 15/12/28.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYFriendsToUserMessageViewController.h"
#import "LYFriendsNameTableViewCell.h"
#import "LYFriendsAddressTableViewCell.h"
#import "LYFriendsLikeTableViewCell.h"
#import "LYFriendsCommentTableViewCell.h"
#import "LYFriendsAllCommentTableViewCell.h"
#import "LYFriendsHttpTool.h"
#import "FriendsRecentModel.h"
#import "LYFriendsUserHeaderView.h"
#import "UIButton+WebCache.h"
#import "LYUserHttpTool.h"
#import "CustomerModel.h"
#import "LYFriendsImgTableViewCell.h"
#import "FriendsCommentModel.h"
#import "LYPictiureView.h"
#import "LYFriendsCommentView.h"
#import "IQKeyboardManager.h"
#import "LYFriendsMessageDetailViewController.h"
#import "LYMyFriendDetailViewController.h"
#import "FriendsLikeModel.h"
#import "FriendsPicAndVideoModel.h"
#import "FriendsUserInfoModel.h"
#import "ISEmojiView.h"
#import "LYFriendsVideoTableViewCell.h"
#import <MediaPlayer/MediaPlayer.h>
#import "LYUserHttpTool.h"


#define LYFriendsNameCellID @"LYFriendsNameTableViewCell"
#define LYFriendsAddressCellID @"LYFriendsAddressTableViewCell"
#define LYFriendsLikeCellID @"LYFriendsLikeTableViewCell"
#define LYFriendsCommentCellID @"LYFriendsCommentTableViewCell"
#define LYFriendsAllCommentCellID @"LYFriendsAllCommentTableViewCell"
#define LYFriendsImgCellID @"LYFriendsImgTableViewCell"
#define LYFriendsVideoCellID @"LYFriendsVideoTableViewCell"

#define LYFriendsCellID @"cell"

@interface LYFriendsToUserMessageViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIActionSheetDelegate,ISEmojiViewDelegate>{
   
    
     LYFriendsUserHeaderView *_headerView;
    NSInteger _pageStartCount;//开始的数量
    NSInteger _pageCount;//每页数
    NSString *_likeStr;
    UIView *_bigView;
    NSInteger _commentBtnTag;
    NSInteger _section;//点击的section
    LYFriendsCommentView *_commentView;
    BOOL _isCommentToUser;
    NSInteger _indexRow;
    FriendsUserInfoModel *_userInfo;
    NSString *defaultComment;//未发送的评论
    
    NSString *juBaoMomentID;//要举报的动态ID
    NSString *pingBiUserID;//要屏蔽的用户ID
    LYMyFriendDetailViewController *_friendDetailVC ;
    ISEmojiView *_emojiView;
    
    EmojisView *emojisView;
    UIVisualEffectView *emojiEffectView;
    BOOL isExidtEffectView;
    UIButton *emoji_angry;
    UIButton *emoji_sad;
    UIButton *emoji_wow;
    UIButton *emoji_kawayi;
    UIButton *emoji_happy;
    UIButton *emoji_zan;
    
    int gestureViewTag;
}



@end

@implementation LYFriendsToUserMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupAllProperty];//设置全局属性
    [self setupTableView];
    [self setupTableViewFresh];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //[IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].isAdd = YES;
    self.navigationController.navigationBarHidden =NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].isAdd = NO;
}
-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.navigationController.navigationBarHidden =NO;
}

- (void)setupAllProperty{
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _dataArray = [[NSMutableArray alloc]initWithCapacity:0];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    _useridStr = app.userModel==nil?@"0":[NSString stringWithFormat:@"%d",app.userModel.userid];
    _pageStartCount = 0;
    _pageCount = 10;
    [self getData];
    self.title = @"好友动态";
    self.tableView.tableFooterView = [[UIView alloc]init];
}


- (void)setupTableView{
    NSArray *array = @[LYFriendsNameCellID,LYFriendsAddressCellID,LYFriendsLikeCellID,LYFriendsCommentCellID,LYFriendsAllCommentCellID,LYFriendsVideoCellID];
    for (NSString *cellIdentifer in array) {
        [self.tableView registerNib:[UINib nibWithNibName:cellIdentifer bundle:nil] forCellReuseIdentifier:cellIdentifer];
    }
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:LYFriendsCellID];
    [self.tableView registerClass:[LYFriendsImgTableViewCell class] forCellReuseIdentifier:LYFriendsImgCellID];
}

#pragma mark - 查看图片
- (void)checkImageClick:(UIButton *)button{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSLog(@"--->%ld",button.tag);
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
            NSLog(@"-->%ld",(button.tag + 2) /4);
            section = (button.tag + 2) /4  - 1;
            NSLog(@"---->%ld",section);
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
    urlArray = [((FriendsPicAndVideoModel *)((FriendsRecentModel *)_dataArray[section]).lyMomentsAttachList[0]).imageLink componentsSeparatedByString:@","];
    LYFriendsImgTableViewCell *imgCell = (LYFriendsImgTableViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:section]];
    for (UIButton *btn in imgCell.btnArray) {
        CGRect rect = [imgCell convertRect:btn.frame toView:app.window];
        [oldFrameArray addObject:NSStringFromCGRect(rect)];
    }
    
    
    LYPictiureView *picView = [[LYPictiureView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) urlArray:urlArray oldFrame:oldFrameArray with:index];
    picView.backgroundColor = [UIColor blackColor];
    
    [app.window addSubview:picView];
}

- (void)setupTableViewFresh{
    self.tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        _pageStartCount = 0;
        [self getData];
    }];
    
    MJRefreshGifHeader *header = (MJRefreshGifHeader *)self.tableView.mj_header;
    [self initMJRefeshHeaderForGif:header];
    
    self.tableView.mj_footer = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
        [self getData];
    }];
    
}

#pragma mark - 获取指定用户数据
- (void)getData{
    NSString *startStr = [NSString stringWithFormat:@"%ld",_pageStartCount * _pageCount];
    NSString *pageCountStr = [NSString stringWithFormat:@"%ld",_pageCount];
    NSDictionary *paraDic = @{@"userId":_useridStr,@"start":startStr,@"limit":pageCountStr,@"frientId":_friendsId};
    NSLog(@"----->%@",paraDic);
    __weak LYFriendsToUserMessageViewController *weakSelf = self;
    [LYFriendsHttpTool friendsGetUserInfoWithParams:paraDic compelte:^(FriendsUserInfoModel *userInfo, NSMutableArray *dataArray) {
        _userInfo = userInfo;
        if(dataArray.count){
        if(_pageStartCount == 0) {
            _dataArray = dataArray;
        }else{
            [_dataArray addObjectsFromArray:dataArray];
        }
        [weakSelf reloadTableViewAndSetUpProperty];
        _pageStartCount ++;
            [weakSelf.tableView.mj_footer endRefreshing];
        }else {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        [weakSelf addTableViewHeader];
    }];
}

#pragma mark － 评论点击头像跳转到指定用户界面
- (void)pushUserPage:(LYFriendsCommentButton *)button{
    FriendsRecentModel *recentM = _dataArray[button.tag];
    FriendsCommentModel *commentModel = recentM.commentList[button.indexTag - 4];
    if([commentModel.userId isEqualToString:_useridStr]) return;
    LYFriendsToUserMessageViewController *friendsUserMegVC = [[LYFriendsToUserMessageViewController alloc]init];
    friendsUserMegVC.friendsId = commentModel.userId;
    [self.navigationController pushViewController:friendsUserMegVC animated:YES];
}

#pragma mark － 刷新表
- (void)reloadTableViewAndSetUpProperty{
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
}

#pragma mark - 添加表头
- (void)addTableViewHeader{
    
    _headerView = [[[NSBundle mainBundle]loadNibNamed:@"LYFriendsUserHeaderView" owner:nil options:nil]firstObject];
    _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 339 - 54);
    [_headerView.btn_header sd_setBackgroundImageWithURL:[NSURL URLWithString:_userInfo.avatar_img] forState:UIControlStateNormal];
    _headerView.label_name.text = _userInfo.usernick;
    _headerView.btn_newMessage.hidden = YES;
    [_headerView.ImageView_bg sd_setImageWithURL:[NSURL URLWithString:_userInfo.friends_img] placeholderImage:[UIImage imageNamed:@"friendPresentBG.jpg"]];
    _headerView.ImageView_bg.clipsToBounds = YES;
    self.tableView.tableHeaderView = _headerView;
    [_headerView.btn_header addTarget:self action:@selector(headerImgClick:) forControlEvents:UIControlEventTouchUpInside];
    [self updateViewConstraints];
}

- (void)headerImgClick:(UIButton *)button{
     CustomerModel *customerM = [[CustomerModel alloc]init];
    customerM.avatar_img = _userInfo.avatar_img;
    customerM.icon = _userInfo.avatar_img;
    customerM.sex = [_userInfo.gender isEqualToString:@"0"] ? @"0" : @"1";
//    customerM.sex = _userInfo.gender;
    customerM.usernick = _userInfo.usernick;
    customerM.message = _userInfo.introduction;
    customerM.imUserId= _userInfo.imUserId;
    customerM.friendName=_userInfo.usernick;
    customerM.friend = _userInfo.userId.intValue;
    customerM.age = [MyUtil getAgefromDate:_userInfo.birthday];
    customerM.birthday=_userInfo.birthday;
    customerM.userid = _userInfo.userId.intValue;
    customerM.tag=_userInfo.tags;
    
    __weak __typeof(self)weakSelf = self;
    _friendDetailVC = [[LYMyFriendDetailViewController alloc]init];
    _friendDetailVC.customerModel = customerM;
    _friendDetailVC.userID = _userInfo.userId;
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSDictionary *dic=@{@"userid":[NSString stringWithFormat:@"%d",app.userModel.userid]};
    [[LYUserHttpTool shareInstance] getFriendsList:dic block:^(NSMutableArray *result) {
        for (CustomerModel *cusM in result) {
            if (_userInfo.userId.intValue == cusM.friend) {
                _friendDetailVC.type = @"0";
            }else{
                _friendDetailVC.type = @"4";
            }
        }
        [weakSelf.navigationController pushViewController:_friendDetailVC animated:YES];
    }];
   
}

- (void)likeFriendsClickEmoji:(NSString *)likeType{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if(![MyUtil isUserLogin]){
        [MyUtil showCleanMessage:@"请先登录！"];
        [MyUtil gotoLogin];
        return;
    }
    LYFriendsAddressTableViewCell *cell = (LYFriendsAddressTableViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:gestureViewTag]];
    cell.btn_like.enabled = NO;
    FriendsRecentModel *recentM = _dataArray[gestureViewTag];
    NSDictionary *paraDic = @{@"userId":_useridStr,@"messageId":recentM.id,@"type":@"1",@"likeType":likeType};
    __weak LYFriendsToUserMessageViewController *weakSelf = self;
    [LYFriendsHttpTool friendsLikeMessageWithParams:paraDic compelte:^(bool result) {
        if (result) {//点赞成功
            if ([recentM.liked isEqualToString:@"1"]) {
                for (int i = 0; i< recentM.likeList.count;i ++) {
                    FriendsLikeModel *likeM = recentM.likeList[i];
                    if ([likeM.userId isEqualToString:_useridStr]) {
                        [recentM.likeList removeObject:likeM];
                        break;
                    }
                }
            }
            FriendsLikeModel *likeModel = [[FriendsLikeModel alloc]init];
            likeModel.icon = app.userModel.avatar_img;
            likeModel.userId = _useridStr;
            likeModel.likeType = likeType;
            [recentM.likeList insertObject:likeModel atIndex:0];
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
        [weakSelf.tableView reloadData];
                cell.btn_like.enabled = YES;
    }];
}

#pragma mark - 表白action
- (void)likeFriendsClick:(UIButton *)button{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if(![MyUtil isUserLogin]){
        [MyUtil showCleanMessage:@"请先登录！"];
        [MyUtil gotoLogin];
        return;
    }
    LYFriendsAddressTableViewCell *cell = (LYFriendsAddressTableViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:button.tag]];
    cell.btn_like.enabled = NO;
  
    FriendsRecentModel *recentM = _dataArray[button.tag];
    NSString *likeStr = nil;
    NSLog(@"---->%@",recentM.liked);
    if ([[NSString stringWithFormat:@"%@",recentM.liked] isEqual:@"0"]) {//未表白过
        likeStr = @"1";
    }else{
        likeStr = @"0";
    }
    NSDictionary *paraDic = @{@"userId":_useridStr,@"messageId":recentM.id,@"type":likeStr};
    __weak LYFriendsToUserMessageViewController *weakSelf = self;
    [LYFriendsHttpTool friendsLikeMessageWithParams:paraDic compelte:^(bool result) {
        if (result) {//点赞成功
            FriendsLikeModel *likeModel = [[FriendsLikeModel alloc]init];
            likeModel.icon = app.userModel.avatar_img;
            likeModel.userId = _useridStr;
            [recentM.likeList insertObject:likeModel atIndex:0];
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
        [weakSelf.tableView reloadData];
        cell.btn_like.enabled = YES;
    }];
}

#pragma mark - 长按表白
- (void)likeLongPressClick:(UILongPressGestureRecognizer *)gesture{
    isExidtEffectView = YES;
//    NSLog(@"%@",gesture.view);
    gestureViewTag = (int)gesture.view.tag;
    //    [UIView animateWithDuration:3
    //                     animations:^{
    //        [self.view addSubview:emojiEffectView];
    //    }];
    //    self.tableView.userInteractionEnabled = !isExidtEffectView;
    //    self.tableView.scrollEnabled = YES;
    if (!emojiEffectView) {
        emojisView = [EmojisView shareInstanse];
        emojisView.delegate = self;
        NSDictionary *dict = [emojisView getEmojisView];
        emojiEffectView = [dict objectForKey:@"emojiEffectView"];
        emoji_angry = [[dict objectForKey:@"emojiButtons"]objectAtIndex:0];
        emoji_sad = [[dict objectForKey:@"emojiButtons"]objectAtIndex:1];
        emoji_wow = [[dict objectForKey:@"emojiButtons"]objectAtIndex:2];
        emoji_kawayi = [[dict objectForKey:@"emojiButtons"]objectAtIndex:3];
        emoji_happy = [[dict objectForKey:@"emojiButtons"]objectAtIndex:4];
        emoji_zan = [[dict objectForKey:@"emojiButtons"]objectAtIndex:5];
    }
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

#pragma mark - 评论action
- (void)commentClick:(UIButton *)button{
    if(![MyUtil isUserLogin]){
        [MyUtil showCleanMessage:@"请先登录！"];
        [MyUtil gotoLogin];
        return;
    }
    _commentBtnTag = button.tag;
    _isCommentToUser = NO;
    [self createCommentView];
}

- (void)keyBorderApearce:(NSNotification *)note{
    
    //    NSString *keybordHeight = note.userInfo[@"UIKeyboardFrameEndUserInfoKey"];
    CGRect rect = [note.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    [UIView animateWithDuration:.25 animations:^{
       // _commentView.frame = CGRectMake(0, SCREEN_HEIGHT - rect.size.height - 49, SCREEN_WIDTH, 49);
    }];
}


#pragma mark - 赞的人头像
- (void)zangBtnClick:(UIButton *)button{
    NSInteger i = button.tag % 8;
    NSInteger section = button.tag / 8 ;
 
    if(section >=0 && i>=0){
        FriendsRecentModel *recentM = _dataArray[section];
        if(i >= recentM.likeList.count) return;
        FriendsLikeModel *likeM = recentM.likeList[i];
        if([likeM.userId isEqualToString:_useridStr]) return;
        LYFriendsToUserMessageViewController *messageVC = [[LYFriendsToUserMessageViewController alloc]init];
        messageVC.friendsId = likeM.userId;
        [self.navigationController pushViewController:messageVC animated:YES];
    }
}

#pragma mark - 更多赞
- (void)likeMoreClick:(UIButton *)button{
    FriendsRecentModel *recentM = _dataArray[button.tag];
    LYFriendsMessageDetailViewController *messageDetailVC = [[LYFriendsMessageDetailViewController alloc]init];
    messageDetailVC.recentM = recentM;
    [self.navigationController pushViewController:messageDetailVC animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    FriendsRecentModel *recentM = _dataArray[section];
    if (recentM.commentNum.integerValue >= 1) {
        return 5 + recentM.commentList.count;
    }else{
        if(!recentM.commentList.count) return 5;
        return 4 + recentM.commentList.count;
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count;
}

- (void)jubaoDT{
//    FriendsRecentModel *recentM = _dataArray[button.tag];
//    juBaoMomentID = recentM.id;
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"选择举报原因" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"污秽色情",@"垃圾广告",@"其他原因", nil];
    actionSheet.tag = 100;
    [actionSheet showInView:self.view];
}

- (void)warningSheet:(UIButton *)button{
    FriendsRecentModel *recentM = _dataArray[button.tag];
    juBaoMomentID = recentM.id;
    pingBiUserID = recentM.userId;
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"屏蔽此人",@"举报动态", nil];
    actionSheet.tag = 131;
    [actionSheet showInView:self.view];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FriendsRecentModel *recentM = _dataArray[indexPath.section];
    switch (indexPath.row) {
        case 0:
        {
            LYFriendsNameTableViewCell *nameCell = [tableView dequeueReusableCellWithIdentifier:LYFriendsNameCellID forIndexPath:indexPath];
            nameCell.recentM = recentM;
//                nameCell.btn_delete.hidden = YES;
            [nameCell.btn_delete setTitle:@"" forState:UIControlStateNormal];
            [nameCell.btn_delete setImage:[[UIImage imageNamed:@"downArrow"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
            nameCell.btn_delete.tag = indexPath.section;
            [nameCell.btn_delete addTarget:self action:@selector(warningSheet:) forControlEvents:UIControlEventTouchUpInside];
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
                if(recentM.likeList.count <= 8) likeCell.btn_more.hidden = YES;
                for (int i = 0; i< likeCell.btnArray.count; i ++) {
                    UIButton *btn = likeCell.btnArray[i];
                    btn.tag = likeCell.btnArray.count * indexPath.section + i;
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
            
        case 9:
        {
            if (recentM.commentNum.integerValue >= 1) {
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
            
        default:{ //评论 4-9
            if(!recentM.commentList.count){
                LYFriendsAllCommentTableViewCell *allCommentCell = [tableView dequeueReusableCellWithIdentifier:LYFriendsAllCommentCellID forIndexPath:indexPath];
                allCommentCell.label_commentCount.text = @"暂无评论";
                //                        allCommentCell.label_commentCount.textAlignment = NSTextAlignmentCenter;
                return allCommentCell;
            }
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
            commentCell.commentM = commentModel;
            commentCell.btn_headerImg.tag = indexPath.section;
            commentCell.btn_headerImg.indexTag = indexPath.row;
            [commentCell.btn_headerImg addTarget:self action:@selector(pushUserPage:) forControlEvents:UIControlEventTouchUpInside];
            return commentCell;
        }
            break;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (isExidtEffectView) {
        [emojisView hideEmojiEffectView];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    FriendsRecentModel *recentM = _dataArray[indexPath.section];
    switch (indexPath.row) {
        case 0://头像和动态
        {
            CGSize size = [recentM.message boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 14, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
            if(![MyUtil isEmptyString:recentM.message]) {
                if(size.height >= 47 ) size.height = 47;
                size.height = 14 + size.height;
            }else{
                size.height = 10;
                if(![MyUtil isEmptyString:recentM.topicTypeName]){
                    size.height = 25;
                }
            }
            return 50 + size.height;
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
        case 3://评论
        {
            NSInteger count = recentM.likeList.count;
            return count == 0 ? 0 : (SCREEN_WIDTH - 114)/8.f + 20;
        }
            break;
        case 9:{
            return 36;
        }
            
        default:
        {
            if(!recentM.commentList.count) return 36;
            if(indexPath.row - 4 > recentM.commentList.count - 1) return 36;
            FriendsCommentModel *commentM = recentM.commentList[indexPath.row - 4];
            NSString *str = [NSString stringWithFormat:@"%@:%@",commentM.nickName,commentM.comment];
            CGSize size = [str boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 81, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
            CGFloat height;
            if (size.height + 20 < 36) {
                height = 36;
            }else {
                height = size.height + 20 + 5;
            }
            return height;
        }
            break;
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _section = indexPath.section;
    FriendsRecentModel *recentM = _dataArray[indexPath.section];
    _section = indexPath.section;
    if (indexPath.row >= 4 && indexPath.row <= 8) {
        if(!recentM.commentList.count) {
            [self pushFriendsMessageDetailVCWithIndex:indexPath.section];
            return;
        }
        
        _indexRow = indexPath.row;
        if(indexPath.row - 4 == recentM.commentList.count) {
            [self pushFriendsMessageDetailVCWithIndex:indexPath.section];
             return;
        }
        FriendsCommentModel *commetnM = recentM.commentList[indexPath.row - 4];
        if ([commetnM.userId isEqualToString:_useridStr]) {//我发的评论
            UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:nil, nil];
            [actionSheet showInView:self.view];
        }else{//别人发的评论
            _isCommentToUser = YES;
            [self createCommentView];
        }
    }else if(indexPath.row == 9){
        [self pushFriendsMessageDetailVCWithIndex:indexPath.section];
    }else if(indexPath.row == 0){
        if([MyUtil isEmptyString:recentM.id]) return;
        [self pushFriendsMessageDetailVCWithIndex:indexPath.section];
    }
}
#pragma mark － 跳转消息详情页面
- (void)pushFriendsMessageDetailVCWithIndex:(NSInteger)index{
    FriendsRecentModel *recentM = _dataArray[index];
    LYFriendsMessageDetailViewController *messageDetailVC = [[LYFriendsMessageDetailViewController alloc]init];
    messageDetailVC.recentM = recentM;
    [self.navigationController pushViewController:messageDetailVC animated:YES];
}
#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(![MyUtil isUserLogin]){
        [MyUtil showCleanMessage:@"请先登录！"];
        [MyUtil gotoLogin];
        return;
    }
    if(actionSheet.tag == 100){
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
            
            NSDictionary *dict = @{@"reportedUserid":_friendsId,
                                   @"momentId":juBaoMomentID,
                                   @"message":message,
                                   @"userid":[NSString stringWithFormat:@"%d",app.userModel.userid]};
            [LYFriendsHttpTool friendsJuBaoWithParams:dict complete:^(NSString *message) {
//                [MyUtil showCleanMessage:message];
                [MyUtil showPlaceMessage:message];
            }];
        }
    }else if(actionSheet.tag == 131){
        if (buttonIndex == 0) {
            NSDictionary *dict = @{@"shieldUserid":pingBiUserID};
            [LYFriendsHttpTool friendsPingBiUserWithParams:dict complete:^(NSString *message) {
                [MyUtil showLikePlaceMessage:message];
            }];
        }else if (buttonIndex == 1){
            [self jubaoDT];
        }
    }else{
        if(!buttonIndex){
            FriendsRecentModel *recetnM = _dataArray[_section];
            FriendsCommentModel *commentM = recetnM.commentList[_indexRow - 4];
            NSDictionary *paraDic = @{@"userId":_useridStr,@"commentId":commentM.commentId};
            __weak LYFriendsToUserMessageViewController *weakSelf = self;
            [LYFriendsHttpTool friendsDeleteMyCommentWithParams:paraDic compelte:^(bool result) {
                if(result){
                    NSMutableArray *commentArr = ((FriendsRecentModel *)_dataArray[_section]).commentList;
                    [commentArr removeObjectAtIndex:_indexRow - 4];
                    recetnM.commentNum = [NSString stringWithFormat:@"%ld",recetnM.commentNum.integerValue - 1];
                    [weakSelf.tableView reloadData];
                }
            }];
        }
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
//        case 0:
//        {
//            cell.separatorInset = UIEdgeInsetsMake(0, 1000, 0, 0);
//        }
//            break;
//        case 1:
//        {
//            cell.separatorInset = UIEdgeInsetsMake(0, 1000, 0, 0);
//        }
//            break;
        case 2:
        {
            cell.separatorInset = UIEdgeInsetsMake(0, 1000, 0, 0);
        }
            break;
        case 3:
        {
            cell.separatorInset = UIEdgeInsetsMake(0, 1000, 0, 0);
        }
            break;
        default:
        {
            cell.separatorInset = UIEdgeInsetsMake(0, 1000, 0, 0);
        }
            break;
    }
}


#pragma mark － 创建commentView
- (void)createCommentView{
   
   //   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBorderApearce:) name:UIKeyboardWillChangeFrameNotification object:nil];
//    UIWindow *window = [UIApplication]
    _bigView = [[UIView alloc]init];
    _bigView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bigViewGes)];
    [_bigView addGestureRecognizer:tapGes];
    [self.view addSubview:_bigView];
    
    _commentView = [[[NSBundle mainBundle]loadNibNamed:@"LYFriendsCommentView" owner:nil options:nil] firstObject];
    _commentView.frame = CGRectMake(0, SCREEN_HEIGHT - 110, SCREEN_WIDTH, 48);
    [_bigView addSubview:_commentView];
    if(defaultComment && ![defaultComment isEqualToString:@""]){
        _commentView.textField.text = defaultComment;
    }
    [_commentView.textField becomeFirstResponder];
    _commentView.textField.delegate = self;
    [_commentView.btn_emotion addTarget:self action:@selector(emotionClick:) forControlEvents:UIControlEventTouchUpInside];
//    SCREEN_HEIGHT - 249- 100 - 129
    
    if(_isCommentToUser){
        FriendsRecentModel *recentM = _dataArray[_section];
        FriendsCommentModel *commentM = recentM.commentList[_indexRow - 4];
        _commentView.textField.placeholder = [NSString stringWithFormat:@"回复%@",commentM.nickName];
    }
    
    [UIView animateWithDuration:.25 animations:^{
      //  _commentView.frame = CGRectMake(0,  SCREEN_HEIGHT - 249 - 72 - 52, SCREEN_WIDTH, 49);
    } completion:^(BOOL finished) {
        
    }];
    
    [_commentView.textField addObserver:self forKeyPath:@"text" options:(NSKeyValueObservingOptionNew) context:nil];
}

- (void)sendMessageClick:(UIButton *)button{
    [self textFieldShouldReturn:_commentView.textField];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    NSLog(@"-->%@",change[@"new"]);
    NSString *newStr =change[@"new"];
    if (newStr.length) {
        [_emojiView.sendBtn setBackgroundColor:RGBA(10, 96, 255, 1)];
        [_emojiView.sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else {
        [_emojiView.sendBtn setTitleColor:RGBA(114, 114, 114, 1) forState:UIControlStateNormal];
        [_emojiView.sendBtn setBackgroundColor:[UIColor whiteColor]];
    }
}


-(void)emojiView:(ISEmojiView *)emojiView didSelectEmoji:(NSString *)emoji{
    _commentView.textField.text = [_commentView.textField.text stringByAppendingString:emoji];
    
}

- (void)emojiView:(ISEmojiView *)emojiView didPressDeleteButton:(UIButton *)deletebutton{
    if (_commentView.textField.text.length > 0) {
        NSRange lastRange = [_commentView.textField.text rangeOfComposedCharacterSequenceAtIndex:_commentView.textField.text.length-1];
        _commentView.textField.text = [_commentView.textField.text substringToIndex:lastRange.location];
    }
}
- (void)emotionClick:(UIButton *)button{
    button.selected = !button.selected;
    if(button.selected){
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
          //  _commentView.frame = CGRectMake(0,y - 60 , CGRectGetWidth(_commentView.frame), CGRectGetHeight(_commentView.frame));
            NSLog(@"----->%@",NSStringFromCGRect(_commentView.frame));
        }];
        if (_commentView.textField.text.length) {
            [_emojiView.sendBtn setBackgroundColor:RGBA(10, 96, 255, 1)];
            [_emojiView.sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }else{
         [button setImage:[UIImage imageNamed:@"biaoqing_icon"] forState:UIControlStateNormal];
        _commentView.btn_send_cont_width.constant = 0;
        [_commentView.btn_send setTitle:@"" forState:UIControlStateNormal];
        [self updateViewConstraints];
        [_commentView.textField endEditing:YES];
        _commentView.textField.inputView = UIKeyboardAppearanceDefault;
        [_commentView.textField becomeFirstResponder];
        [UIView animateWithDuration:.1 animations:^{
            // _commentView.frame = CGRectMake(0,SCREEN_HEIGHT - 216 - CGRectGetHeight(_commentView.frame) , CGRectGetWidth(_commentView.frame), CGRectGetHeight(_commentView.frame));
           // _commentView.frame = CGRectMake(0, SCREEN_HEIGHT - 249 - 72 - 52, SCREEN_WIDTH, CGRectGetHeight(_commentView.frame));
        }];
    }
}
- (void)emojiView:(ISEmojiView *)emojiView didPressSendButton:(UIButton *)sendbutton{
    [self textFieldShouldReturn:_commentView.textField];
}

- (void)bigViewGes{
//    if (_commentView.textField.text.length) {
        defaultComment = _commentView.textField.text;
//    }
    [_commentView.textField removeObserver:self forKeyPath:@"text"];

    [_bigView removeFromSuperview];
    
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_commentView.textField removeObserver:self forKeyPath:@"text"];

    [_bigView removeFromSuperview];
    [textField endEditing:YES];
    if(!_commentView.textField.text.length) return NO;
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if(![MyUtil isUserLogin]){
        [MyUtil showCleanMessage:@"请先登录！"];
        [MyUtil gotoLogin];
        return NO;
    }
    
    FriendsRecentModel *recentM = nil;
    NSString *toUserId = nil;
    NSString *toUserNickName = nil;
    if (_isCommentToUser) {
        recentM = _dataArray[_section];
        FriendsCommentModel *commentModel = recentM.commentList[_indexRow - 4];
        toUserId = commentModel.userId;
        toUserNickName = commentModel.nickName;
    }else{
        recentM = _dataArray[_commentBtnTag];
        toUserId = @"";
        toUserNickName = @"";
    }
    if(_commentView.textField.text.length > 200) {
        [MyUtil showCleanMessage:@"内容太多，200字以内"];
        return NO;
    }
    NSDictionary *paraDic = @{@"userId":_useridStr,@"messageId":recentM.id,@"toUserId":toUserId,@"comment":_commentView.textField.text};
    __weak LYFriendsToUserMessageViewController *weakSelf = self;
    [LYFriendsHttpTool friendsCommentWithParams:paraDic compelte:^(bool resutl,NSString *commentId) {
        if (resutl) {
            defaultComment = nil;
            FriendsCommentModel *commentModel = [[FriendsCommentModel alloc]init];
            commentModel.comment = _commentView.textField.text;
            commentModel.icon = app.userModel.avatar_img;
            commentModel.commentId = commentId;
            commentModel.nickName = app.userModel.usernick;
            commentModel.userId = _useridStr;
            if(toUserId.length){ commentModel.toUserId = toUserId;
                commentModel.toUserNickName = toUserNickName;
            }
            else commentModel.toUserId = @"0";
            
            if(recentM.commentList.count == 5) [recentM.commentList removeObjectAtIndex:0];
            [recentM.commentList addObject:commentModel];
            recentM.commentNum = [NSString stringWithFormat:@"%ld",recentM.commentNum.integerValue + 1];
            //  [weakSelf.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:4 + recentM.commentList.count inSection:_commentBtnTag]] withRowAnimation:UITableViewRowAnimationTop];
            [weakSelf.tableView reloadData];
        }
    }];
    return YES;
}

#pragma mark - 视频播放
- (void)playVideo:(UIButton *)button{
    FriendsRecentModel *recentM = _dataArray[button.tag];
    FriendsPicAndVideoModel *pvM = (FriendsPicAndVideoModel *)recentM.lyMomentsAttachList[0];
    //    NSString *urlString = [MyUtil configureNetworkConnect] == 1 ?[MyUtil getQiniuUrl:pvM.imageLink mediaType:QiNiuUploadTpyeSmallMedia width:0 andHeight:0] : [MyUtil getQiniuUrl:pvM.imageLink mediaType:QiNiuUploadTpyeMedia width:0 andHeight:0];
    QiNiuUploadTpye quType = [MyUtil configureNetworkConnect] == 1 ? QiNiuUploadTpyeSmallMedia : QiNiuUploadTpyeMedia;
    NSLog(@"--->%@",[MyUtil getQiniuUrl:pvM.imageLink mediaType:quType width:0 andHeight:0]);
    NSURL *url = [NSURL URLWithString:[[MyUtil getQiniuUrl:pvM.imageLink mediaType:quType width:0 andHeight:0] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] ;
    if (recentM.isMeSendMessage){
        url = [[NSURL alloc] initFileURLWithPath:pvM.imageLink];
        
    }
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

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

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
