//
//  LYFriendsViewController.m
//  lieyu
//
//  Created by 狼族 on 15/12/24.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYFriendsViewController.h"
#import "LYFriendsNameTableViewCell.h"
#import "LYFriendsImgOneTableViewCell.h"
#import "LYFriendsImgTwoTableViewCell.h"
#import "LYFriendsThreeTableViewCell.h"
#import "LYFriendsAddressTableViewCell.h"
#import "LYFriendsLikeTableViewCell.h"
#import "LYFriendsCommentTableViewCell.h"
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
#import "LYFriendsSendViewController.h"
#import "LYFriendsToUserMessageViewController.h"
#import "LYFriendsMessageDetailViewController.h"
#import "LYFriendsImgTableViewCell.h"
#import "LYFriendsChangeImageMenuView.h"
#import "LYChangeImageViewController.h"

#import "YBImgPickerViewController.h"
#import <MediaPlayer/MediaPlayer.h>


#define LYFriendsNameCellID @"LYFriendsNameTableViewCell"
#define LYFriendsImgOneCellID @"LYFriendsImgOneTableViewCell"
#define LYFriendsImgTwoCellID @"LYFriendsImgTwoTableViewCell"
#define LYFriendsImgThreeCellID @"LYFriendsThreeTableViewCell"
#define LYFriendsAddressCellID @"LYFriendsAddressTableViewCell"
#define LYFriendsLikeCellID @"LYFriendsLikeTableViewCell"
#define LYFriendsCommentCellID @"LYFriendsCommentTableViewCell"
#define LYFriendsAllCommentCellID @"LYFriendsAllCommentTableViewCell"
#define LYFriendsImgCellID @"LYFriendsImgTableViewCell"
#define LYFriendsCellID @"cell"

@interface LYFriendsViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,LYFriendsImgOneTableViewCellDelegate,UITextFieldDelegate,YBImgPickerViewControllerDelegate,
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate>{
    UIButton *_friendsBtn;
    UIButton *_myBtn;
    UILabel *_myBadge;
    UIButton *_carmerBtn;
    CGFloat _friendBtnAlpha,_myBtnAlpha;
    NSMutableArray *_dataArray;
    NSInteger _index;//0 表示玩友圈界面 1表示我的界面
    LYFriendsUserHeaderView *_headerView;
    UIView *_vLine;
    NSMutableArray *_oldFrameArray;
    NSInteger _section;//点击的section
    NSInteger _imgIndex;//点击的第几个imgview
    NSString *_useridStr;
    NSString *_likeStr;
    UIView *_bigView;
    LYFriendsCommentView *_commentView;//弹出的评论框
    NSInteger _commentBtnTag;
        LYFriendsSendViewController *friendsSendVC;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, assign) int pageCount;
@property (nonatomic, strong) NSString *typeOfImagePicker;
@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (nonatomic, strong) NSMutableDictionary *notificationDict;

@end

@implementation LYFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.pageCount = 4;
    
    _notificationDict = [[NSMutableDictionary alloc]init];
    
    [self setupAllProperty];//设置全局属性
    [self setupTableView];
}

- (void)setupAllProperty{
    _dataArray = [[NSMutableArray alloc]initWithCapacity:0];
    _oldFrameArray = [[NSMutableArray alloc]init];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    _useridStr = [NSString stringWithFormat:@"%d",app.userModel.userid];
     _index = 0;
    _friendsBtnSelect = YES;
    _pageStartCountFriends = 0;
    _pageStartCountMys = 0;
    _pageCount = 10;
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self getDataFriends];
}

- (void)setupTableView{
    NSArray *array = @[LYFriendsNameCellID,LYFriendsImgOneCellID,LYFriendsImgTwoCellID,LYFriendsImgThreeCellID,LYFriendsAddressCellID,LYFriendsLikeCellID,LYFriendsCommentCellID,LYFriendsAllCommentCellID];
    for (NSString *cellIdentifer in array) {
        [self.tableView registerNib:[UINib nibWithNibName:cellIdentifer bundle:nil] forCellReuseIdentifier:cellIdentifer];
    }
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:LYFriendsCellID];
    [self.tableView registerClass:[LYFriendsImgTableViewCell class] forCellReuseIdentifier:LYFriendsImgCellID];
}

- (void)setupTableViewFresh{
    self.tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        switch (_index) {
            case 0:
            {
                _pageStartCountFriends = 0;
                [self getDataFriends];
            }
                break;
                
            default:
            {
                _pageStartCountMys = 0;
                [self getDataMys];
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
                [self getDataFriends];
            }
                break;
                
            default:
            {
                [self getDataMys];
            }
                break;
        }
    }];
    
}

//设置导航栏玩友圈和我的按钮及发布动态按钮
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
    if(_friendsBtnSelect) _myBtn.alpha = 0.5;
    else _friendsBtn.alpha = 0.5;
    [_myBtn addTarget:self action:@selector(myClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:_myBtn];
    
    _vLine = [[UIView alloc]initWithFrame:CGRectMake(160, 16, 1, 12)];
    _vLine.backgroundColor = RGBA(255, 255, 255, 0.5);
    [self.navigationController.navigationBar addSubview:_vLine];

    _myBadge = [[UILabel alloc]initWithFrame:CGRectMake(209, 10, 13, 13)];
    _myBadge.backgroundColor = [UIColor redColor];
    _myBadge.layer.cornerRadius = CGRectGetWidth(_myBadge.frame) / 2.f;
    _myBadge.layer.masksToBounds = YES;
    [self.navigationController.navigationBar addSubview:_myBadge];
    
    _carmerBtn = [[UIButton alloc]initWithFrame:CGRectMake(285.5, 10, 24, 24)];
    [_carmerBtn addTarget:self action:@selector(carmerClick:) forControlEvents:UIControlEventTouchUpInside];
    [_carmerBtn setBackgroundImage:[UIImage imageNamed:@"daohang_xiangji"] forState:UIControlStateNormal];
    [self.navigationController.navigationBar addSubview:_carmerBtn];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _index = 0;
   [IQKeyboardManager sharedManager].enable = NO;
    [self setupNavMenuView];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self removeNavMenuView];
    [IQKeyboardManager sharedManager].enable = YES;
}



- (void)removeNavMenuView{
//    _friendsBtn.alpha =
    [_friendsBtn removeFromSuperview];
    [_myBadge removeFromSuperview];
    [_myBtn removeFromSuperview];
    [_carmerBtn removeFromSuperview];
    [_vLine removeFromSuperview];
}

#pragma mark - 获取最新玩友圈数据
- (void)getDataFriends{
       __block LYFriendsViewController *weakSelf = self;
    NSString *startStr = [NSString stringWithFormat:@"%ld",_pageStartCountFriends * _pageCount];
    NSString *pageCountStr = [NSString stringWithFormat:@"%ld",_pageCount];
    NSDictionary *paraDic = @{@"userId":_useridStr,@"start":startStr,@"limit":pageCountStr};
    NSLog(@"---->%@",paraDic);
    [LYFriendsHttpTool friendsGetRecentInfoWithParams:paraDic compelte:^(NSMutableArray *dataArray) {
        NSLog(@"---->%ld",dataArray.count);
        if(dataArray.count){
            if(!_dataArray.count){
                [_dataArray addObject:dataArray];//第一次加载
            }else{
                if(_pageStartCountFriends == 0){
                    [_dataArray replaceObjectAtIndex:0 withObject:dataArray];
                }else {
                    NSMutableArray *muArr = _dataArray[_index];
                    [muArr addObjectsFromArray:dataArray];
                }
            }
            [weakSelf reloadTableViewAndSetUpProperty];
             _pageStartCountFriends ++;
        }
    }];
}

#pragma mark - 获取最新我的数据
- (void)getDataMys{
    NSString *startStr = [NSString stringWithFormat:@"%ld",_pageStartCountMys * _pageCount];
    NSString *pageCountStr = [NSString stringWithFormat:@"%ld",_pageCount];
    NSDictionary *paraDic = @{@"userId":_useridStr,@"start":startStr,@"limit":pageCountStr,@"frientId":_useridStr};
    NSLog(@"----->%@",paraDic);
         __block LYFriendsViewController *weakSelf = self;
    [LYFriendsHttpTool friendsGetUserInfoWithParams:paraDic compelte:^(NSMutableArray *dataArray) {
        NSLog(@"----->%ld",dataArray.count);
        if(dataArray.count){
            if(_dataArray.count == 1){
                    [_dataArray addObject:dataArray];
                }else{
                    if(_pageStartCountMys == 0){
                        [_dataArray replaceObjectAtIndex:1 withObject:dataArray];
                    }else{
                        NSMutableArray *muArr = _dataArray[_index];
                        [muArr addObjectsFromArray:dataArray];
                    }
                }
        }else{
            NSArray *array = [NSArray array];
            [_dataArray addObject:array];
        }
        [weakSelf reloadTableViewAndSetUpProperty];
        [weakSelf addTableViewHeader];
         _pageStartCountMys ++;
    }];
}

#pragma mark － 刷新表
- (void)reloadTableViewAndSetUpProperty{
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    if(!((NSArray *)_dataArray[_index]).count){
        return;
    }
    FriendsRecentModel *recentM = _dataArray[_index][_section];
    if ([recentM.liked isEqualToString:@"0"]) {
        _likeStr = @"0";
    }else{
        _likeStr = @"1";
    }
}

#pragma mark - 玩友圈action
- (void)friendsClick:(UIButton *)friendsBtn{
    _index = 0;
    _friendsBtn.alpha = 1;
    _myBtn.alpha = 0.5;
    _friendsBtnSelect = YES;
    [self getDataFriends];
    [self removeTableViewHeader];
}
#pragma mark - 我的action
- (void)myClick:(UIButton *)myBtn{
    _index = 1;
    _friendsBtn.alpha = 0.5;
    _myBtn.alpha = 1;
    _friendsBtnSelect = NO;
    [self getDataMys];
}

#pragma mark - 添加表头
- (void)addTableViewHeader{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    _headerView = [[[NSBundle mainBundle]loadNibNamed:@"LYFriendsUserHeaderView" owner:nil options:nil]firstObject];
    _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 277);
    [_headerView.btn_header sd_setBackgroundImageWithURL:[NSURL URLWithString:app.userModel.avatar_img] forState:UIControlStateNormal ];
    _headerView.label_name.text = app.userModel.usernick;
    _headerView.ImageView_bg.backgroundColor = [UIColor redColor];
    self.tableView.tableHeaderView = _headerView;
    [_headerView.btn_newMessage addTarget:self action:@selector(newClick) forControlEvents:UIControlEventTouchUpInside];
    self.tableview_top.constant = -64;
    [self updateViewConstraints];
    
    NSData *imageData = [[NSUserDefaults standardUserDefaults] objectForKey:@"FriendUserBgImage"];
    _headerView.ImageView_bg.image = [[UIImage alloc]initWithData:imageData];
    
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
    LYFriendsMessageViewController *messageVC = [[LYFriendsMessageViewController alloc]init];
    [self.navigationController pushViewController:messageVC animated:YES];
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

    [actionSheet showInView:self.view];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(FriendSendViewDidLoad) name:@"FriendSendViewDidLoad" object:nil];
}

#pragma mark actionsheet代理
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [self takePhotoActionClick];
    }else if(buttonIndex == 1){
        [self photosActionClick];
    }else{
        [self filmingActionClick];
    }
}

#pragma mark 选择完后根据点击的按钮进行操作
- (void)photosActionClick{
    if(self.pageCount <= 0){
        return;//给出提示
    }
    _typeOfImagePicker = @"photos";
    YBImgPickerViewController *ybImagePicker = [[YBImgPickerViewController alloc]init];
    ybImagePicker.photoCount = self.pageCount;
    [ybImagePicker showInViewContrller:self choosenNum:0 delegate:self];
}

- (void)takePhotoActionClick{
    if(self.pageCount <= 0){
        return;//给出提示
    }
    _typeOfImagePicker = @"takePhoto";
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}

- (void)filmingActionClick{
    if(self.pageCount < 4){
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
      FriendsRecentModel *recentM = _dataArray[_index][button.tag];
    NSDictionary *paraDic = @{@"userId":_useridStr,@"messageId":recentM.id,@"type":_likeStr};
//    __block LYFriendsViewController *weakSelf = self;
    [LYFriendsHttpTool friendsLikeMessageWithParams:paraDic compelte:^(bool result) {
        if (result) {
            if([_likeStr isEqualToString:@"1"]){
                _likeStr = @"0";
            }else{
                _likeStr = @"1";
            }
        }
    }];
}

#pragma mark - 评论action
- (void)commentClick:(UIButton *)button{
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
    _commentBtnTag = button.tag;
    
    [UIView animateWithDuration:.25 animations:^{
        _commentView.frame = CGRectMake(0, SCREEN_HEIGHT - 249 - 49 - 52, SCREEN_WIDTH, 49);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)bigViewGes{
    [_bigView removeFromSuperview];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    [_bigView removeFromSuperview];
    if(!_commentView.textField.text.length) return;
    FriendsRecentModel *recentM = _dataArray[_index][_commentBtnTag];
    NSDictionary *paraDic = @{@"userId":_useridStr,@"messageId":recentM.id,@"toUserId":@"",@"comment":_commentView.textField.text};
    __block LYFriendsViewController *weakSelf = self;
    [LYFriendsHttpTool friendsCommentWithParams:paraDic compelte:^(bool resutl) {
        if (resutl) {
            NSLog(@"--->%ld",recentM.commentList.count + 2);
            FriendsCommentModel *commentModel = [[FriendsCommentModel alloc]init];
            commentModel.comment = _commentView.textField.text;
            commentModel.icon = recentM.avatar_img;
            commentModel.nickName = recentM.usernick;
            [recentM.commentList addObject:commentModel];
            NSLog(@"------%ld->%ld",_commentBtnTag,recentM.commentList.count + 2);
            [weakSelf.tableView reloadData];
          //  [weakSelf.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:4 + recentM.commentList.count inSection:_commentBtnTag]] withRowAnimation:UITableViewRowAnimationTop];
        }
    }];
}

#pragma mark - 更多赞
- (void)likeMoreClick:(UIButton *)button{
    FriendsRecentModel *recentM = _dataArray[_index][button.tag];
    LYFriendsMessageDetailViewController *messageDetailVC = [[LYFriendsMessageDetailViewController alloc]init];
    messageDetailVC.recentM = recentM;
    [self.navigationController pushViewController:messageDetailVC animated:YES];
}

#pragma mark - UITableViewDelegate&UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *array = (NSArray *)_dataArray[_index];
    FriendsRecentModel *recentM = array[section];
    if (recentM.commentNum.integerValue >= 6) {
        return 10;
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
                    
                default:{ //评论 4-9
                    FriendsCommentModel *commentModel = recentM.commentList[indexPath.row - 4];
                    LYFriendsCommentTableViewCell *commentCell = [tableView dequeueReusableCellWithIdentifier:LYFriendsCommentCellID forIndexPath:indexPath];
                    if (indexPath.row == 4) {
                        commentCell.imageV_comment.hidden = NO;
                    }else{
                        commentCell.imageV_comment.hidden = YES;
                    }
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
                                                                                                                                                     
             return 62 + size.height;
        }
            break;
            
        case 1://图片
        {
            switch (recentM.lyMomentsAttachList.count) {
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
            break;
        case 2://地址
        {
            return 45;
        }
            break;
        case 3://评论
        {
             NSInteger count = recentM.likeNum.integerValue;
            return count == 0 ? 0 : 46;
        }
            break;
        
            
        default:
        {
            NSLog(@"-----%ld-->%ld",recentM.commentList.count,indexPath.row);
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
}

#pragma mark - 点击头像跳转到指定用户界面
- (void)pushUserMessagePage:(UIButton *)button{
    FriendsRecentModel *recentM = _dataArray[_index][button.tag];
    LYFriendsToUserMessageViewController *friendsUserMegVC = [[LYFriendsToUserMessageViewController alloc]init];
    friendsUserMegVC.friendsId = recentM.userId;
    [self.navigationController pushViewController:friendsUserMegVC animated:YES];
}


- (NSString *)stringFromImageViewFrame:(CGRect)imgFrame{
    return NSStringFromCGRect(imgFrame);
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
             cell.separatorInset = UIEdgeInsetsMake(0, 1000, 0, 0);
        }
            break;
        case 1:
        {
            cell.separatorInset = UIEdgeInsetsMake(0, 1000, 0, 0);
        }
            break;
        case 2:
        {
            cell.separatorInset = UIEdgeInsetsMake(0, 1000, 0, 0);
        }
            break;
        case 3:
        {
            cell.separatorInset = UIEdgeInsetsMake(0, 7, 0, 7);
        }
            break;
        default:
        {
            cell.separatorInset = UIEdgeInsetsMake(0, 35, 0, 7);
        }
            break;
    }
}

#pragma mark - LYFriendsImgOneTableViewCellDelegate
- (void)friendsImgOneCell:(LYFriendsImgOneTableViewCell *)imgOneCell{
   
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
