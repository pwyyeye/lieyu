//
//  LYMessageDetailViewController.m
//  lieyu
//
//  Created by 狼族 on 15/12/27.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYFriendsMessageDetailViewController.h"
#import "LYFriendsHttpTool.h"
#import "FriendsRecentModel.h"
#import "FriendsCommentModel.h"
#import "LYPictiureView.h"
#import "LYFriendsToUserMessageViewController.h"
#import "LYFriendsCommentView.h"
#import "FriendsLikeModel.h"
#import "IQKeyboardManager.h"
#import "FriendsPicAndVideoModel.h"
#import "LYFriendsTopicViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "ISEmojiView.h"
#import "LYMyFriendDetailViewController.h"

#import "LYFriendsNameTableViewCell.h"
#import "LYFriendsImgTableViewCell.h"
#import "LYFriendsVideoTableViewCell.h"
#import "LYFriendsAddressTableViewCell.h"
#import "LYFriendsLikeDetailTableViewCell.h"
#import "LYFriendsCommentTableViewCell.h"

#define LYFriendsNameCellID @"LYFriendsNameTableViewCell"
#define LYFriendsImgCellID @"LYFriendsImgTableViewCell"
#define LYFriendsVideoCellID @"LYFriendsVideoTableViewCell"
#define LYFriendsAddressCellID @"LYFriendsAddressTableViewCell"
#define LYFriendsLikeDetailCellID @"LYFriendsLikeDetailTableViewCell"
#define LYFriendsCommentsCellID @"LYFriendsCommentTableViewCell"

@interface LYFriendsMessageDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIActionSheetDelegate,ISEmojiViewDelegate,UIActionSheetDelegate,UIGestureRecognizerDelegate>
{
    NSMutableArray *_dataArray;
    NSInteger _indexStart;
    NSString *_useridStr;
    NSString *_likeStr;
    UIView *_bigView;
    LYFriendsCommentView *_commentView;//弹出的评论框
    BOOL _isCommentToUser;//是否对用户评论
    NSInteger _indexRow;//点的第几个行
    NSString *defaultCommnet;//未发送的评论
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
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation LYFriendsMessageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupTableView];
    [self setupAllProperty];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSString *MyUserid = [NSString stringWithFormat:@"%d",app.userModel.userid];
    if (![MyUserid isEqualToString:_recentM.userId]) {
        //不是自己的动态详情
        [self configureRightButton];
    }
    
}

- (void)configureRightButton{
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [button setImage:[UIImage imageNamed:@"jubao_btn"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(warningSheet:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)jubaoDT{
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"选择举报原因" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"污秽色情",@"垃圾广告",@"其他原因",  nil];
        actionSheet.tag = 100;
        [actionSheet showInView:self.view];
}

- (void)warningSheet:(UIButton *)button{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"屏蔽此人",@"举报动态", nil];
    actionSheet.tag = 131;
    [actionSheet showInView:self.view];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     //[IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].isAdd = YES;
    self.navigationController.navigationBarHidden=NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].isAdd = NO;
//    self.navigationController.navigationBarHidden=YES;
}

- (void)setupAllProperty{
    
    _indexStart = 4;
    [self getData];
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.title = @"消息详情";
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    _useridStr = [NSString stringWithFormat:@"%d",app.userModel.userid];
     _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if ([_recentM.liked isEqualToString:@"0"]) {
        _likeStr = @"1";
    }else{
        _likeStr = @"0";
    }
}

- (void)getData{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSString *userIdStr = [NSString stringWithFormat:@"%d",app.userModel==nil?0:app.userModel.userid];
    __weak LYFriendsMessageDetailViewController *weakSelf = self;
    NSDictionary *paraDic = @{@"userId":userIdStr,@"messageId":_recentM.id};
    [LYFriendsHttpTool friendsGetMessageDetailAllCommentsWithParams:paraDic compelte:^(NSMutableArray *commentArray) {
        _dataArray = commentArray;
         if(_dataArray.count)   [weakSelf.tableView reloadData];
    }];
}

- (void)setupTableView{
    NSArray *cellIDArray = @[LYFriendsNameCellID,
                             LYFriendsAddressCellID,
                             LYFriendsVideoCellID,
                             LYFriendsLikeDetailCellID,
                             LYFriendsCommentsCellID];
    for (NSString *cellID in cellIDArray) {
        [self.tableView registerNib:[UINib nibWithNibName:cellID bundle:nil] forCellReuseIdentifier:cellID];
    }
    [_tableView registerClass:[LYFriendsImgTableViewCell class] forCellReuseIdentifier:LYFriendsImgCellID];
}

#pragma mark - 跳转到个人动态界面
- (void)pushUserMessageClick{
    if (isExidtEffectView) {
        [emojisView hideEmojiEffectView];
    }
        if([_recentM.userId isEqualToString:_useridStr]) return;
//    LYFriendsToUserMessageViewController *friendsUserMegVC = [[LYFriendsToUserMessageViewController alloc]init];
//    friendsUserMegVC.friendsId = _recentM.userId;
//    [self.navigationController pushViewController:friendsUserMegVC animated:YES];
    
    LYMyFriendDetailViewController *myFriendVC = [[LYMyFriendDetailViewController  alloc]initWithNibName:@"LYMyFriendDetailViewController" bundle:nil];
    myFriendVC.userID = _recentM.userId;
    [self.navigationController pushViewController:myFriendVC animated:YES];
}

#pragma mark - 表白action
- (void)likeFriendsClick{
    if (isExidtEffectView) {
        [emojisView hideEmojiEffectView];
    }
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if(![MyUtil isUserLogin]){
        [MyUtil showCleanMessage:@"请先登录！"];
        [MyUtil gotoLogin];
        return;
    }
    LYFriendsAddressTableViewCell *cell = (LYFriendsAddressTableViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    cell.btn_like.enabled = NO;
    NSString *likeStr = nil;
    if ([[NSString stringWithFormat:@"%@",_recentM.liked] isEqual:@"0"]) {//未表白过
        likeStr = @"1";
    }else{
        likeStr = @"0";
    }
    if ([likeStr isEqualToString:@"1"]) {
        if (!emojiEffectView) {
            emojisView = [EmojisView shareInstanse];
        }
        [emojisView windowShowEmoji:@{@"emojiName":@"dianzan",
                                      @"emojiNumber":@"24"}];
    }
    
    NSDictionary *paraDic = @{@"userId":_useridStr,@"messageId":_recentM.id,@"type":likeStr};
    __weak LYFriendsMessageDetailViewController *weakSelf = self;
    [LYFriendsHttpTool friendsLikeMessageWithParams:paraDic compelte:^(bool result) {
//        if([_likeStr isEqualToString:@"1"]){
//            _likeStr = @"0";
//        }else{
//            _likeStr = @"1";
//        }
        if (result) {//点赞成功
            FriendsLikeModel *likeModel = [[FriendsLikeModel alloc]init];
            likeModel.icon = app.userModel.avatar_img;
            likeModel.userId = _useridStr;
            [_recentM.likeList insertObject:likeModel atIndex:0];
            _recentM.liked = @"1";
        }else{
            for (int i = 0; i< _recentM.likeList.count;i ++) {
                FriendsLikeModel *likeM = _recentM.likeList[i];
                if ([likeM.userId isEqualToString:_useridStr]) {
                    [_recentM.likeList removeObject:likeM];
                }
            }
                        _recentM.liked = @"0";
        }
        cell.btn_like.enabled = YES;
        [weakSelf.tableView reloadData];
    }];
}

- (void)likeFriendsClickEmoji:(NSString *)likeType{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if(![MyUtil isUserLogin]){
        [MyUtil showCleanMessage:@"请先登录！"];
        [MyUtil gotoLogin];
        return;
    }
    LYFriendsAddressTableViewCell *cell = (LYFriendsAddressTableViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    cell.btn_like.enabled = NO;
    NSDictionary *paraDic = @{@"userId":_useridStr,@"messageId":_recentM.id,@"type":@"1",@"likeType":likeType};
    __weak LYFriendsMessageDetailViewController *weakSelf = self;
    [LYFriendsHttpTool friendsLikeMessageWithParams:paraDic compelte:^(bool result) {
        //        if([_likeStr isEqualToString:@"1"]){
        //            _likeStr = @"0";
        //        }else{
        //            _likeStr = @"1";
        //        }
        if (result) {//点赞成功
            if ([_recentM.liked isEqualToString:@"1"]) {
                for (int i = 0; i< _recentM.likeList.count;i ++) {
                    FriendsLikeModel *likeM = _recentM.likeList[i];
                    if ([likeM.userId isEqualToString:_useridStr]) {
                        [_recentM.likeList removeObject:likeM];
                        break;
                    }
                }
            }
            FriendsLikeModel *likeModel = [[FriendsLikeModel alloc]init];
            likeModel.icon = app.userModel.avatar_img;
            likeModel.userId = _useridStr;
            likeModel.likeType = likeType;
            [_recentM.likeList insertObject:likeModel atIndex:0];
            _recentM.liked = @"1";
        }else{
            for (int i = 0; i< _recentM.likeList.count;i ++) {
                FriendsLikeModel *likeM = _recentM.likeList[i];
                if ([likeM.userId isEqualToString:_useridStr]) {
                    [_recentM.likeList removeObject:likeM];
                }
            }
            _recentM.liked = @"0";
        }
        cell.btn_like.enabled = YES;
        [weakSelf.tableView reloadData];
    }];
}

#pragma mark - 长按表白
- (void)likeLongPressClick:(UILongPressGestureRecognizer *)gesture{
    isExidtEffectView = YES;
    if (!emojiEffectView) {
        emojisView = [EmojisView shareInstanse];
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (isExidtEffectView) {
        [emojisView hideEmojiEffectView];
    }
}

#pragma mark - 评论action
- (void)commentClick{
    if (isExidtEffectView) {
        [emojisView hideEmojiEffectView];
    }
    if(![MyUtil isUserLogin]){
        [MyUtil showCleanMessage:@"请先登录！"];
        [MyUtil gotoLogin];
        return;
    }
    _isCommentToUser = NO;
  
    [self createCommentView];
}

#pragma mark － 创建commentView
- (void)createCommentView{
   //   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBorderApearce:) name:UIKeyboardWillChangeFrameNotification object:nil];
    _bigView = [[UIView alloc]init];
    _bigView.frame = self.view.bounds;
    NSLog(@"---->%@",NSStringFromCGRect(_bigView.frame));
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bigViewGes)];
    [_bigView addGestureRecognizer:tapGes];
    [self.view addSubview:_bigView];
    
    _commentView = [[[NSBundle mainBundle]loadNibNamed:@"LYFriendsCommentView" owner:nil options:nil] firstObject];
    _commentView.frame = CGRectMake(0, SCREEN_HEIGHT - 110 , SCREEN_WIDTH, 48);
    _commentView.bgView.layer.borderColor = RGBA(143, 2, 195, 1).CGColor;
    _commentView.bgView.layer.borderWidth = 0.5;
    [_bigView addSubview:_commentView];
    if (defaultCommnet && ![defaultCommnet isEqualToString:@""]) {
        _commentView.textField.text = defaultCommnet;
    }
    [_commentView.textField becomeFirstResponder];
    _commentView.textField.delegate = self;
    [_commentView.btn_emotion addTarget:self action:@selector(emotionClick:) forControlEvents:UIControlEventTouchUpInside];
    _commentView.btn_send_cont_width = 0 ;
    if(_isCommentToUser){
      
        FriendsCommentModel *commentM = _dataArray[_indexRow - _indexStart];
        _commentView.textField.placeholder = [NSString stringWithFormat:@"回复%@",commentM.nickName];
    }
    
    [UIView animateWithDuration:.25 animations:^{
      //  _commentView.frame = CGRectMake(0, SCREEN_HEIGHT - 249 - 72 - 52, SCREEN_WIDTH, 49);
    } completion:^(BOOL finished) {
        
    }];
    
     [_commentView.textField addObserver:self forKeyPath:@"text" options:(NSKeyValueObservingOptionNew) context:nil];
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
       // [_commentView.textField reloadInputViews];
        [_commentView.textField becomeFirstResponder];
        [UIView animateWithDuration:.1 animations:^{
          //   _commentView.frame = CGRectMake(0,SCREEN_HEIGHT - 216 - 110 -CGRectGetHeight(_commentView.frame) , CGRectGetWidth(_commentView.frame), CGRectGetHeight(_commentView.frame));
           // _commentView.frame = CGRectMake(0, SCREEN_HEIGHT - 249 - 72 - 52, SCREEN_WIDTH, CGRectGetHeight(_commentView.frame));
        }];
        
    }
}

- (void)sendMessageClick:(UIButton *)button{
//    defaultComment = nil;
    [self textFieldShouldReturn:_commentView.textField];
}

- (void)keyBorderApearce:(NSNotification *)note{
    
    //    NSString *keybordHeight = note.userInfo[@"UIKeyboardFrameEndUserInfoKey"];
    CGRect rect = [note.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    [UIView animateWithDuration:.25 animations:^{
       // _commentView.frame = CGRectMake(0, SCREEN_HEIGHT - rect.size.height - 49, SCREEN_WIDTH, 49);
        NSLog(@"--->%@------->%@",NSStringFromCGRect(rect),NSStringFromCGRect(_commentView.frame));
    }completion:^(BOOL finished) {
        NSLog(@"--->%@",NSStringFromCGRect(_commentView.frame));
    }];

}

- (void)emojiView:(ISEmojiView *)emojiView didPressSendButton:(UIButton *)sendbutton{
    [self textFieldShouldReturn:_commentView.textField];
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
- (void)bigViewGes{
    if (isExidtEffectView) {
        [emojisView hideEmojiEffectView];
    }
//    if(_commentView.textField.text.length){
        defaultCommnet = _commentView.textField.text;
//    }
    [_commentView.textField removeObserver:self forKeyPath:@"text"];
    [_bigView removeFromSuperview];
    
}

#pragma mark - 点赞的人的头像跳转到个人动态
- (void)zangBtnClick:(UIButton *)button{
    if (isExidtEffectView) {
        [emojisView hideEmojiEffectView];
    }
//    NSInteger index = button.tag % 16;
//    NSInteger section = (button.tag - index)/16;
    if(button.tag >= _recentM.likeList.count) return;
    if( index>=0){
        FriendsLikeModel *likeM = _recentM.likeList[button.tag];
        if([likeM.userId isEqualToString:_useridStr]) return;
//        LYFriendsToUserMessageViewController *messageVC = [[LYFriendsToUserMessageViewController alloc]init];
//        messageVC.friendsId = likeM.userId;
//        [self.navigationController pushViewController:messageVC animated:YES];
        
        LYMyFriendDetailViewController *myFriendVC = [[LYMyFriendDetailViewController  alloc]initWithNibName:@"LYMyFriendDetailViewController" bundle:nil];
        myFriendVC.userID = likeM.userId;
        [self.navigationController pushViewController:myFriendVC animated:YES];
    }
}


#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_commentView.textField removeObserver:self forKeyPath:@"text"];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if(![MyUtil isUserLogin]){
        [MyUtil showCleanMessage:@"请先登录！"];
        [MyUtil gotoLogin];
        return NO;
    }
    [_bigView removeFromSuperview];
    [textField endEditing:YES];
    if(!_commentView.textField.text.length) return NO;
    NSString *toUserId = nil;
    NSString *toUserNick = nil;
    if (_isCommentToUser) {
        FriendsCommentModel *commentModel = _dataArray[_indexRow - _indexStart];
        toUserId = commentModel.userId;
        toUserNick = commentModel.nickName;
    }else{
        toUserId = @"";
        toUserNick = @"";
    }
    if(_commentView.textField.text.length > 200) {
        [MyUtil showCleanMessage:@"内容太多，200字以内"];
        return NO;
    }
    NSDictionary *paraDic = @{@"userId":_useridStr,@"messageId":_recentM.id,@"toUserId":toUserId,@"comment":_commentView.textField.text};
    __weak LYFriendsMessageDetailViewController *weakSelf = self;
    [LYFriendsHttpTool friendsCommentWithParams:paraDic compelte:^(bool resutl,NSString *commentId) {
        if (resutl) {
            defaultCommnet = nil;
            FriendsCommentModel *commentModel = [[FriendsCommentModel alloc]init];
            commentModel.comment = _commentView.textField.text;
            commentModel.icon = app.userModel.avatar_img;
            commentModel.nickName = app.userModel.usernick;
            commentModel.userId = _useridStr;
            commentModel.commentId = commentId;
            if(toUserId.length){
                commentModel.toUserId = toUserId;
                commentModel.toUserNickName = toUserNick;   
            }else
            {
                commentModel.toUserId = @"0";
            }
            [_dataArray addObject:commentModel];
            _recentM.commentNum = [NSString stringWithFormat:@"%ld",_recentM.commentNum.intValue+1];
            //  [weakSelf.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:4 + recentM.commentList.count inSection:_commentBtnTag]] withRowAnimation:UITableViewRowAnimationTop];
            [weakSelf.tableView reloadData];
        }
    }];
    return YES;
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4 + _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
             LYFriendsNameTableViewCell *nameCell = [tableView dequeueReusableCellWithIdentifier:LYFriendsNameCellID forIndexPath:indexPath];   
            nameCell.recentM = _recentM;
            nameCell.label_content.numberOfLines = 99;
            nameCell.btn_delete.tag = indexPath.section;
//            if (!_index) {
            [nameCell.btn_topic addTarget:self action:@selector(topicNameClick) forControlEvents:UIControlEventTouchUpInside];
                nameCell.btn_headerImg.tag = indexPath.section;
                [nameCell.btn_headerImg addTarget:self action:@selector(pushUserMessagePage) forControlEvents:UIControlEventTouchUpInside];
//            }else{
//                [nameCell.btn_delete setTitle:@"删除" forState:UIControlStateNormal];
//                [nameCell.btn_delete setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
//                [nameCell.btn_delete addTarget:self action:@selector(deleteClick:) forControlEvents:UIControlEventTouchUpInside];
//                nameCell.btn_delete.hidden = NO;
//                nameCell.btn_delete.enabled = YES;
//            }
            if([MyUtil isEmptyString:[NSString stringWithFormat:@"%@",_recentM.id]]){
                nameCell.btn_delete.enabled = NO;
            }
            return nameCell;
        }
            break;
        case 1:
        {
            if([_recentM.attachType isEqualToString:@"0"]){
                LYFriendsImgTableViewCell *imgCell = [tableView dequeueReusableCellWithIdentifier:LYFriendsImgCellID forIndexPath:indexPath];
                if (imgCell.btnArray.count) {
                    for (UIButton *btn in imgCell.btnArray) {
                        [btn removeFromSuperview];
                    }
                }
                imgCell.recentModel = _recentM;
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
                NSString *urlStr = ((FriendsPicAndVideoModel *)_recentM.lyMomentsAttachList[0]).imageLink;
                [videoCell.imgView_video sd_setImageWithURL:[NSURL URLWithString:[MyUtil getQiniuUrl:urlStr mediaType:QiNiuUploadTpyeDefault width:0 andHeight:0]] placeholderImage:[UIImage imageNamed:@"empyImage300"]];
                [videoCell.btn_play addTarget:self action:@selector(playVideo) forControlEvents:UIControlEventTouchUpInside];
                return videoCell;
            }
        }
            break;
            
        case 2://地址
        {
            LYFriendsAddressTableViewCell *addressCell = [tableView dequeueReusableCellWithIdentifier:LYFriendsAddressCellID forIndexPath:indexPath];
            addressCell.recentM = _recentM;
            addressCell.btn_like.tag = indexPath.section;
            addressCell.btn_comment.tag = indexPath.section;
            [addressCell.btn_like addTarget:self action:@selector(likeFriendsClick) forControlEvents:UIControlEventTouchUpInside];
            
            UILongPressGestureRecognizer *likeLongPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(likeLongPressClick:)];
            [addressCell.btn_like addGestureRecognizer:likeLongPress];
            
            [addressCell.btn_comment addTarget:self action:@selector(commentClick) forControlEvents:UIControlEventTouchUpInside];
            if([MyUtil isEmptyString:_recentM.id]){
                addressCell.btn_comment.enabled = NO;
                addressCell.btn_like.enabled = NO;
            }else {
                addressCell.btn_comment.enabled = YES;
                addressCell.btn_like.enabled = YES;
            }
            return addressCell;
        }
            break;
        case 3:{
            LYFriendsLikeDetailTableViewCell *likeCell = [tableView dequeueReusableCellWithIdentifier:LYFriendsLikeDetailCellID forIndexPath:indexPath];
            likeCell.recentM = _recentM;
            for (int i = 0; i< likeCell.btnArray.count; i ++) {
                UIButton *btn = likeCell.btnArray[i];
                //                        btn.tag = likeCell.btnArray.count * indexPath.section  + i ;
                btn.tag = i;
                [btn addTarget:self action:@selector(zangBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            }
            return likeCell;
        }
            break;

        default:{
            FriendsCommentModel *commentModel = _dataArray[indexPath.row - _indexStart];
            LYFriendsCommentTableViewCell *commentCell = [tableView dequeueReusableCellWithIdentifier:LYFriendsCommentsCellID forIndexPath:indexPath];
            commentCell.btn_headerImg.tag = indexPath.row - _indexStart;
            [commentCell.btn_headerImg addTarget:self action:@selector(puUserMessagePageClick:) forControlEvents:UIControlEventTouchUpInside];
            commentCell.commentM = commentModel;
            
            commentCell.btn_firstName.tag = indexPath.section;
            commentCell.btn_firstName.indexTag = indexPath.row;
            [commentCell.btn_firstName addTarget:self action:@selector(pushUserPage:) forControlEvents:UIControlEventTouchUpInside];
            commentCell.btn_firstName.isFirst = YES;
            
            commentCell.btn_secondName.tag = indexPath.section;
            commentCell.btn_secondName.indexTag = indexPath.row;
            [commentCell.btn_secondName addTarget:self action:@selector(pushUserPage:) forControlEvents:UIControlEventTouchUpInside];
            return commentCell;
            
        }
            break;
    }
   
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (isExidtEffectView) [emojisView hideEmojiEffectView];
    _indexRow = indexPath.row;
    if (indexPath.row - _indexStart >= _dataArray.count) {
        return;
    }
    FriendsCommentModel *commentM = _dataArray[indexPath.row - _indexStart];
    if (indexPath.row >= _indexStart) {
        if ([commentM.userId isEqualToString:_useridStr]) {
            UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:nil, nil];
            [actionSheet showInView:self.view];
        }else{
            _isCommentToUser = YES;
            [self createCommentView];
        }
        
    }
    
   
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:{
            CGSize size = [_recentM.message boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 70, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
            
            
            NSString *topicNameStr = nil;
            if(_recentM.topicTypeName.length) topicNameStr = [NSString stringWithFormat:@"#%@#",_recentM.topicTypeName];
            CGSize topicSize = [topicNameStr boundingRectWithSize:CGSizeMake(MAXFLOAT, 30) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
            NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithString:_recentM.message];
            [attributeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, _recentM.message.length )];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
            if(topicNameStr.length) paragraphStyle.firstLineHeadIndent = topicSize.width+3;
            [paragraphStyle setLineSpacing:3];
            [attributeStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [_recentM.message length])];
            size =  [attributeStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 70, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading context:nil].size;
            
            
            // if(size.height >= 47) size.height = 47;
            if(![MyUtil isEmptyString:_recentM.message]) {
//                if(size.height >= 57) size.height = 57;
                size.height =  size.height;
            }else{
                size.height = 0;
                if(![MyUtil isEmptyString:_recentM.topicTypeName]){
                    size.height = 20;
                }
            }
            NSLog(@"------>%f",size.height);
            return 67 + size.height ;
            }
            break;
        case 1://图片
        {
            NSArray *urlArray = [((FriendsPicAndVideoModel *)_recentM.lyMomentsAttachList[0]).imageLink componentsSeparatedByString:@","];
            switch (urlArray.count) {
                case 1:
                {
                    return SCREEN_WIDTH - 70;
                }
                    break;
                case 2:
                {
                    return (SCREEN_WIDTH - 75)/2.f;
                }
                    break;
                case 3:{
                    return (SCREEN_WIDTH - 75)/2.f + 5 + SCREEN_WIDTH - 70;
                }
                    break;
                    
                default:
                    return (SCREEN_WIDTH - 75) + 5;
                    break;
            }
            
        }
            break;
        case 2://地址
        {
            return 50;
        }
            break;
        case 3:{
            if (_recentM.likeList.count) {
                    //                    return  _recentM.likeList.count <= 8 ? (SCREEN_WIDTH - 98)/8.f + 20 : (SCREEN_WIDTH - 98)/8.f * 2 + 30;
                    CGFloat btnWidth = (SCREEN_WIDTH - 91) /7.f;
                    NSInteger rowNum = (_recentM.likeList.count + 6)/ 7.f;
                    return rowNum * (btnWidth + 7) + 10;

            }
            return 0;
        }
            break;
            
        default:{
           
            FriendsCommentModel *commentModel = _dataArray[indexPath.row - _indexStart];
            
            NSString *str = nil;
            if([commentModel.toUserId isEqualToString:@"0"]) {
                str = [NSString stringWithFormat:@"%@：%@",commentModel.nickName,commentModel.comment];
            }else{
                str = [NSString stringWithFormat:@"%@ 回复 %@：%@",commentModel.nickName,commentModel.toUserNickName,commentModel.comment];
            }
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init
                                                       ];
            paragraphStyle.lineSpacing = 5;
            
            NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14], NSParagraphStyleAttributeName:paragraphStyle};
            NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:str];
            [attributedStr addAttributes:attributes range:NSMakeRange(0, attributedStr.length)];
            CGSize size = [attributedStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 70, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
//            CGFloat height;
//            if (size.height < 30) {
//                height = 30;
//            }else {
//                height = size.height;
//            }
            return size.height + 10;

        }
            break;
        }
}

#pragma mark － 评论点击头像跳转到指定用户界面
- (void)pushUserPage:(LYFriendsCommentButton *)button{
    
    if(button.indexTag - _indexStart >= _dataArray.count) return;
    FriendsCommentModel *commentModel = _dataArray[button.indexTag - _indexStart];
    
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

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
   
//    switch (indexPath.row) {
//        case 0:
//        {
//            cell.separatorInset = UIEdgeInsetsMake(0, 1000, 0, 0);
//        }
//            break;
//            
//        default:
//        {
//            if (_recentM.likeNum.integerValue) {
//                if(indexPath.row == 1){
//                    cell.separatorInset = UIEdgeInsetsMake(0, 14, 0, 14);
//                    return;
//                }
//            }
//            cell.separatorInset = UIEdgeInsetsMake(0, 34, 0, 14);
//        }
//            break;
//    }
}

#pragma mark - 点击动态中话题文字
- (void)topicNameClick{
    if(_isTopicDetail) return;
    if (_recentM.topicTypeName.length && _recentM.topicTypeId.length) {
        LYFriendsTopicViewController *friendsTopicVC = [[LYFriendsTopicViewController alloc]init];
        friendsTopicVC.topicTypeId = _recentM.topicTypeId;
        friendsTopicVC.topicName = _recentM.topicTypeName;
        friendsTopicVC.headerViewImgLink = [MyUtil getQiniuUrl:_recentM.topicTypeBgUrl width:0 andHeight:0];
        if([_recentM.isBarTopicType isEqualToString:@"0"]) friendsTopicVC.isFriendsTopic = YES;
        [self.navigationController pushViewController:friendsTopicVC animated:YES];
    }
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
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
            
            NSDictionary *dict = @{@"reportedUserid":_recentM.userId,
                                   @"momentId":_recentM.id,
                                   @"message":message,
                                   @"userid":[NSString stringWithFormat:@"%d",app.userModel.userid]};
            [LYFriendsHttpTool friendsJuBaoWithParams:dict complete:^(NSString *message) {
//                [MyUtil showCleanMessage:message];
                [MyUtil showPlaceMessage:message];
            }];
        }
    }else if (actionSheet.tag == 131){
        if (buttonIndex == 0) {//pingbi
            NSDictionary *dict = @{@"shieldUserid":_recentM.userId};
            [LYFriendsHttpTool friendsPingBiUserWithParams:dict complete:^(NSString *message) {
                [MyUtil showLikePlaceMessage:message];
            }];
        }else if (buttonIndex == 1){
            [self jubaoDT];
        }
    }else{
        if (!buttonIndex) {//删除我的评论
            FriendsCommentModel *commentM = _dataArray[_indexRow - _indexStart];
            NSDictionary *paraDic = @{@"userId":_useridStr,@"commentId":commentM.commentId};
            __weak LYFriendsMessageDetailViewController *weakSelf = self;
            [LYFriendsHttpTool friendsDeleteMyCommentWithParams:paraDic compelte:^(bool result) {
                if(result){
                    [_dataArray removeObjectAtIndex:_indexRow - _indexStart];
                    _recentM.commentNum = [NSString stringWithFormat:@"%ld",_recentM.commentNum.integerValue - 1];
                    [weakSelf.tableView reloadData];
                }
            }];
        }
    }
}
#pragma mark - 跳转到指定用户动态页
- (void)puUserMessagePageClick:(UIButton *)button{
    FriendsCommentModel *commentModel = _dataArray[button.tag];
    if([commentModel.userId isEqualToString:_useridStr]) return;
//    LYFriendsToUserMessageViewController *friendsUserMegVC = [[LYFriendsToUserMessageViewController alloc]init];
//    friendsUserMegVC.friendsId = commentModel.userId;
//    [self.navigationController pushViewController:friendsUserMegVC animated:YES];
    
    LYMyFriendDetailViewController *myFriendVC = [[LYMyFriendDetailViewController  alloc]initWithNibName:@"LYMyFriendDetailViewController" bundle:nil];
    myFriendVC.userID = commentModel.userId;
    [self.navigationController pushViewController:myFriendVC animated:YES];
}

#pragma mark - LYFriendsHeaderTableViewCellDelegate
- (void)friendsHeaderCellImageView:(UIImageView *)imgView{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSArray *urlArray = _recentM.lyMomentsAttachList;
    urlArray = [((FriendsPicAndVideoModel *)urlArray[0]).imageLink componentsSeparatedByString:@","];
    NSMutableArray *oldFrameArray = [[NSMutableArray alloc]init];
    
//    LYFriendsHeaderTableViewCell *headerCell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//    for (UIImageView *imgViewCell in headerCell.imageViewArray) {
//        NSString *oldFrame = NSStringFromCGRect([headerCell convertRect:imgViewCell.frame toView:app.window]);
//        [oldFrameArray addObject:oldFrame];
//    }
    
    

    FriendsPicAndVideoModel *pvM = _recentM.lyMomentsAttachList[0];
    //    NSString *urlString = [MyUtil configureNetworkConnect] == 1 ?[MyUtil getQiniuUrl:pvM.imageLink mediaType:QiNiuUploadTpyeSmallMedia width:0 andHeight:0] : [MyUtil getQiniuUrl:pvM.imageLink mediaType:QiNiuUploadTpyeMedia width:0 andHeight:0];
    if([_recentM.attachType isEqualToString:@"1"]){
    QiNiuUploadTpye quType = [MyUtil configureNetworkConnect] == 1 ? QiNiuUploadTpyeSmallMedia : QiNiuUploadTpyeMedia;
    NSURL *url = [NSURL URLWithString:[[MyUtil getQiniuUrl:pvM.imageLink mediaType:quType width:0 andHeight:0] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] ;
    MPMoviePlayerViewController *player = [[MPMoviePlayerViewController alloc]initWithContentURL:url];
    player.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    player.moviePlayer.controlStyle = MPMovieControlStyleFullscreen;
    player.moviePlayer.scalingMode = MPMovieScalingModeNone;
    [self presentMoviePlayerViewControllerAnimated:player];
    }else{
    LYPictiureView *picView = [[LYPictiureView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) urlArray:urlArray oldFrame:oldFrameArray with:imgView.tag];
    picView.backgroundColor = [UIColor blackColor];
    
    [app.window addSubview:picView];
    }
}

#pragma mark - 查看图片
- (void)checkImageClick:(UIButton *)button{
    if (isExidtEffectView) [emojisView hideEmojiEffectView];
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
    urlArray = [((FriendsPicAndVideoModel *)_recentM.lyMomentsAttachList[0]).imageLink componentsSeparatedByString:@","];
    LYFriendsImgTableViewCell *imgCell = (LYFriendsImgTableViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:section]];
    for (UIButton *btn in imgCell.btnArray) {
        CGRect rect = [imgCell convertRect:btn.frame toView:app.window];
        [oldFrameArray addObject:NSStringFromCGRect(rect)];
    }
    
    
    LYPictiureView *picView = [[LYPictiureView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) urlArray:urlArray oldFrame:oldFrameArray with:index];
    picView.backgroundColor = [UIColor blackColor];
    
    [app.window addSubview:picView];
}

#pragma mark - 视频播放
- (void)playVideo{
    FriendsPicAndVideoModel *pvM = _recentM.lyMomentsAttachList[0];
    //    NSString *urlString = [MyUtil configureNetworkConnect] == 1 ?[MyUtil getQiniuUrl:pvM.imageLink mediaType:QiNiuUploadTpyeSmallMedia width:0 andHeight:0] : [MyUtil getQiniuUrl:pvM.imageLink mediaType:QiNiuUploadTpyeMedia width:0 andHeight:0];
    QiNiuUploadTpye quType = [MyUtil configureNetworkConnect] == 1 ? QiNiuUploadTpyeSmallMedia : QiNiuUploadTpyeMedia;
    NSLog(@"--->%@",[MyUtil getQiniuUrl:pvM.imageLink mediaType:quType width:0 andHeight:0]);
    NSURL *url = [NSURL URLWithString:[[MyUtil getQiniuUrl:pvM.imageLink mediaType:quType width:0 andHeight:0] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] ;
    if (_recentM.isMeSendMessage){
        url = [[NSURL alloc] initFileURLWithPath:pvM.imageLink];
        
    }
    MPMoviePlayerViewController *player = [[MPMoviePlayerViewController alloc]initWithContentURL:url];
    player.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    player.moviePlayer.controlStyle = MPMovieControlStyleFullscreen;
    player.moviePlayer.scalingMode = MPMovieScalingModeNone;
    [self presentMoviePlayerViewControllerAnimated:player];
}
#pragma mark - 点击头像跳转到指定用户界面
- (void)pushUserMessagePage{
    if (isExidtEffectView) [emojisView hideEmojiEffectView];
    //    if([recentM.userId isEqualToString:_useridStr]) return;
    if([_recentM.userId isEqualToString:_useridStr]) {
        //        [self myClick:nil];
        return;
    }
//    LYFriendsToUserMessageViewController *friendsUserMegVC = [[LYFriendsToUserMessageViewController alloc]init];
//    friendsUserMegVC.friendsId = _recentM.userId;
//    [self.navigationController pushViewController:friendsUserMegVC animated:YES];
    
    LYMyFriendDetailViewController *myFriendVC = [[LYMyFriendDetailViewController  alloc]initWithNibName:@"LYMyFriendDetailViewController" bundle:nil];
    myFriendVC.userID = _recentM.userId;
    [self.navigationController pushViewController:myFriendVC animated:YES];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadTableView" object:nil];
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
