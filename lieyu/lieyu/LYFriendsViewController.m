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

@interface LYFriendsViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,LYFriendsImgOneTableViewCellDelegate,UITextFieldDelegate>{
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
    LYFriendsCommentView *_commentView;
    NSInteger _commentBtnTag;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation LYFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self setupAllProperty];//设置全局属性
    [self setupTableView];
  
    
}

- (void)setupAllProperty{
    _dataArray = [[NSMutableArray alloc]initWithCapacity:0];
    _oldFrameArray = [[NSMutableArray alloc]init];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    _useridStr = [NSString stringWithFormat:@"%d",app.userModel.userid];
}

- (void)setupTableView{
    NSArray *array = @[LYFriendsNameCellID,LYFriendsImgOneCellID,LYFriendsImgTwoCellID,LYFriendsImgThreeCellID,LYFriendsAddressCellID,LYFriendsLikeCellID,LYFriendsCommentCellID,LYFriendsAllCommentCellID];
    for (NSString *cellIdentifer in array) {
        [self.tableView registerNib:[UINib nibWithNibName:cellIdentifer bundle:nil] forCellReuseIdentifier:cellIdentifer];
    }
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:LYFriendsCellID];
    [self.tableView registerClass:[LYFriendsImgTableViewCell class] forCellReuseIdentifier:LYFriendsImgCellID];
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
    _myBtn.alpha = 0.5;
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
    [self getDataFriends];
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
    NSDictionary *paraDic = @{@"userId":_useridStr,@"start":@"0",@"limit":@"10"};
    [LYFriendsHttpTool friendsGetRecentInfoWithParams:paraDic compelte:^(NSArray *dataArray) {
        if(dataArray.count){
            if(!_dataArray.count){
                [_dataArray addObject:dataArray];
            }else{
                [_dataArray replaceObjectAtIndex:0 withObject:dataArray];
            }
            [weakSelf reloadTableViewAndSetUpProperty];
        }
    }];
}

#pragma mark - 获取最新我的数据
- (void)getDataMys{
    NSDictionary *paraDic = @{@"userId":_useridStr,@"start":@"0",@"limit":@"10",@"frientId":_useridStr};
         __block LYFriendsViewController *weakSelf = self;
    [LYFriendsHttpTool friendsGetUserInfoWithParams:paraDic compelte:^(NSMutableArray *dataArray) {
        if(dataArray.count){
            if(_dataArray.count == 1){
                    [_dataArray addObject:dataArray];
                }else{
                    [_dataArray replaceObjectAtIndex:1 withObject:dataArray];
                }
        }else{
            NSArray *array = [NSArray array];
            [_dataArray addObject:array];
        }
        [weakSelf reloadTableViewAndSetUpProperty];
        [weakSelf addTableViewHeader];
    }];
}

#pragma mark － 刷新表
- (void)reloadTableViewAndSetUpProperty{
    [self.tableView reloadData];
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
    [self getDataFriends];
    [self removeTableViewHeader];
}
#pragma mark - 我的action
- (void)myClick:(UIButton *)myBtn{
    _index = 1;
    _friendsBtn.alpha = 0.5;
    _myBtn.alpha = 1;
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

- (void)carmerClick:(UIButton *)carmerClick{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册",@"短视频", nil];

    [actionSheet showInView:self.view];
}

#pragma mark - 表白action
- (void)likeFriendsClick:(UIButton *)button{
      FriendsRecentModel *recentM = _dataArray[_index][button.tag];
    NSDictionary *paraDic = @{@"userId":_useridStr,@"messageId":recentM.id,@"type":_likeStr};
    __block LYFriendsViewController *weakSelf = self;
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
            NSLog(@"-->%ld",(button.tag + 3) /4);
            section = (button.tag + 3) /4  - 1;
            NSLog(@"---->%ld",section);
            index = 0;
            urlArray = ((FriendsRecentModel *)_dataArray[_index][section]).lyMomentsAttachList;
            LYFriendsImgTableViewCell *imgCell = (LYFriendsImgTableViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:section]];
                for (UIButton *btn in imgCell.btnArray) {
                    CGRect rect = [btn convertRect:btn.frame toView:app.window];
                    
                    NSLog(@"---------%@------",NSStringFromCGRect(rect));
                   
                [oldFrameArray addObject:NSStringFromCGRect(rect)];
              }
        }
            break;
        case 2:
        {
            NSLog(@"-->%ld",(button.tag + 2) /4);
            section = (button.tag + 2) /4  - 1;
            NSLog(@"---->%ld",section);
            index = 1;
            urlArray = ((FriendsRecentModel *)_dataArray[_index][section]).lyMomentsAttachList;
            LYFriendsImgTableViewCell *imgCell = (LYFriendsImgTableViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:section]];
            for (UIButton *btn in imgCell.btnArray) {
                NSLog(@"----------%@---------",NSStringFromCGRect(btn.frame));
                CGRect rect = [imgCell convertRect:btn.frame toView:app.window];
                [oldFrameArray addObject:NSStringFromCGRect(rect)];
                NSLog(@"---->%@",NSStringFromCGRect(rect));
            }
        }
            break;
//        case 3:
//        {
//            
//        }
//            break;
//        case 0:
//        {
//            
//        }
//            break;
        default:
            break;
    }
    
    LYPictiureView *picView = [[LYPictiureView alloc]initWithFrame:self.view.bounds urlArray:urlArray oldFrame:oldFrameArray with:index];
    picView.backgroundColor = [UIColor blackColor];
   
    [app.window addSubview:picView];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    [_bigView removeFromSuperview];
    FriendsRecentModel *recentM = _dataArray[_index][_commentBtnTag];
    NSDictionary *paraDic = @{@"userId":_useridStr,@"messageId":recentM.id,@"toUserId":@"",@"comment":_commentView.textField.text};
    [LYFriendsHttpTool friendsCommentWithParams:paraDic compelte:^(bool resutl) {
        
    }];
}
#pragma mark － 删除我的评论
- (void)deleteClick:(UIButton *)button{
    NSMutableArray *array = _dataArray[_index];
    FriendsRecentModel *recentM = array[button.tag];
    NSDictionary *paraDic = @{@"userId":_useridStr,@"messageId":recentM.id};
    __block LYFriendsViewController *weakSelf = self;
    [LYFriendsHttpTool friendsDeleteMyMessageWithParams:paraDic compelte:^(bool result) {
        if (result) {
            [array removeObjectAtIndex:button.tag];
            [weakSelf.tableView deleteSections:[NSIndexSet indexSetWithIndex:button.tag] withRowAnimation:UITableViewRowAnimationTop];
            
        }
    }];
}
#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0://拍照
        {
            
        }
            break;
        case 1://相册
        {
            LYFriendsSendViewController *friendSendVC = [[LYFriendsSendViewController alloc]init];
            [self showViewController:friendSendVC sender:nil];
            
           
            
        }
            break;
        case 2://短视频
        {
            
        }
            break;
        default:
            break;
    }
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
        return 4 + recentM.commentNum.integerValue;
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
                    /*
                    switch (recentM.lyMomentsAttachList.count) {
                        case 2://照片数量为二
                        {
                            LYFriendsImgTwoTableViewCell *imageCell = [tableView dequeueReusableCellWithIdentifier:LYFriendsImgTwoCellID forIndexPath:indexPath];
                            imageCell.recentM = recentM;
                            return imageCell;
                        }
                            break;
                            
                        default:{
                            LYFriendsImgOneTableViewCell *imageCell = [tableView dequeueReusableCellWithIdentifier:LYFriendsImgOneCellID forIndexPath:indexPath];
                            imageCell.delegate = self;
                            imageCell.recentM = recentM;
                            return imageCell;
                        }
                            break;
                    }*/
                    
//                    FriendsRecentModel *recentM = _dataArray[_index][indexPath.section];
                    LYFriendsImgTableViewCell *imgCell = [tableView dequeueReusableCellWithIdentifier:LYFriendsImgCellID forIndexPath:indexPath];
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
               /* case 2:
                {
                    switch (recentM.lyMomentsAttachList.count) {
                        case 3:
                        {
                            LYFriendsImgTwoTableViewCell *imageCell = [tableView dequeueReusableCellWithIdentifier:LYFriendsImgTwoCellID forIndexPath:indexPath];
                            imageCell.recentM = recentM;
                            return imageCell;
                        }
                            break;
                        case 4:
                        {
                            LYFriendsThreeTableViewCell *imageCell = [tableView dequeueReusableCellWithIdentifier:LYFriendsImgThreeCellID forIndexPath:indexPath];
                            imageCell.recentM = recentM;
                            return imageCell;
                        }
                            break;
                            
                        default:{
                            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LYFriendsCellID forIndexPath:indexPath];
                            return cell;
                        }
                            break;
                    }
                }
                    break;*/
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
                        return likeCell;}
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
                        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LYFriendsCellID forIndexPath:indexPath];
                        return cell;
                    }
                }
                    
                default:{ //评论 5-9
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
            return 320;
        }
            break;
//        case 2:
//        {
//            return recentM.lyMomentsAttachList.count > 2 ? 105 : 0;
//        }
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
            FriendsCommentModel *commentM = recentM.commentList[indexPath.section];
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
    FriendsRecentModel *recentM = _dataArray[_index][_section];
  /*  if(indexPath.row == 1 || indexPath.row == 2){
        
        [_oldFrameArray removeAllObjects];
        switch (recentM.lyMomentsAttachList.count) {
            case 1:
            {
                LYFriendsImgOneTableViewCell *imgoneCell = (LYFriendsImgOneTableViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:_section]];
                CGRect rect1 = [imgoneCell.imageView_one convertRect:imgoneCell.imageView_one.frame toView:self.view];
                [_oldFrameArray addObject:[self stringFromImageViewFrame:rect1]];
                _imgIndex = 1;
            }
                break;
            case 2:
            {
                LYFriendsImgTwoTableViewCell *imgtwoCell = (LYFriendsImgTwoTableViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:_section]];
                CGRect rect1 = [imgtwoCell.imageView_one convertRect:imgtwoCell.imageView_one.frame toView:self.view];
                CGRect rect2 = [imgtwoCell.imageView_two convertRect:imgtwoCell.imageView_one.frame toView:self.view];
                [_oldFrameArray addObject:[self stringFromImageViewFrame:rect1]];
                [_oldFrameArray addObject:[self stringFromImageViewFrame:rect2]];
                
                _imgIndex = 1;
            }
                break;
            case 3:
            {
                LYFriendsImgOneTableViewCell *imgoneCell = (LYFriendsImgOneTableViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:_section]];
                CGRect rect1 = [imgoneCell.imageView_one convertRect:imgoneCell.imageView_one.frame toView:self.view];
                
                LYFriendsImgTwoTableViewCell *imgtwoCell = (LYFriendsImgTwoTableViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:_section]];
                CGRect rect2 = [imgtwoCell.imageView_one convertRect:imgtwoCell.imageView_one.frame toView:self.view];
                CGRect rect3 = [imgtwoCell.imageView_two convertRect:imgtwoCell.imageView_one.frame toView:self.view];
                [_oldFrameArray addObject:[self stringFromImageViewFrame:rect1]];
                [_oldFrameArray addObject:[self stringFromImageViewFrame:rect2]];
                [_oldFrameArray addObject:[self stringFromImageViewFrame:rect3]];
                 _imgIndex = 1;
            }
                break;
            case 4:
            {
                LYFriendsImgOneTableViewCell *imgoneCell = (LYFriendsImgOneTableViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:_section]];
                CGRect rect1 = [imgoneCell.imageView_one convertRect:imgoneCell.imageView_one.frame toView:self.view];
                
                LYFriendsThreeTableViewCell *imgThreeCell = (LYFriendsThreeTableViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:_section]];
                CGRect rect2 = [imgThreeCell.imageView_one convertRect:imgThreeCell.imageView_one.frame toView:self.view];
                CGRect rect3 = [imgThreeCell.imageView_two convertRect:imgThreeCell.imageView_one.frame toView:self.view];
                CGRect rect4 = [imgThreeCell.imageView_three convertRect:imgThreeCell.imageView_one.frame toView:self.view];
                [_oldFrameArray addObject:[self stringFromImageViewFrame:rect1]];
                [_oldFrameArray addObject:[self stringFromImageViewFrame:rect2]];
                [_oldFrameArray addObject:[self stringFromImageViewFrame:rect3]];
                [_oldFrameArray addObject:[self stringFromImageViewFrame:rect4]];
                 _imgIndex = 1;
            }
                break;
            default:{
                return;
            }
                break;
        }
        
        LYPictiureView *picView = [[LYPictiureView alloc]initWithFrame:self.view.bounds urlArray:recentM.lyMomentsAttachList oldFrame:_oldFrameArray with:_imgIndex];
        picView.backgroundColor = [UIColor blackColor];
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [app.window addSubview:picView];
    }*/
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
