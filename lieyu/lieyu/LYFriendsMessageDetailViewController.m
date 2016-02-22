//
//  LYMessageDetailViewController.m
//  lieyu
//
//  Created by 狼族 on 15/12/27.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYFriendsMessageDetailViewController.h"
#import "LYFriendsHeaderTableViewCell.h"
#import "LYFriendsLikeDetailTableViewCell.h"
#import "LYFriendsHttpTool.h"
#import "FriendsRecentModel.h"
#import "LYFriendsCommentDetailTableViewCell.h"
#import "FriendsCommentModel.h"
#import "LYPictiureView.h"
#import "LYFriendsToUserMessageViewController.h"
#import "LYFriendsCommentView.h"
#import "FriendsLikeModel.h"
#import "IQKeyboardManager.h"
#import "FriendsPicAndVideoModel.h"
#import <MediaPlayer/MediaPlayer.h>
#import "ISEmojiView.h"

#define LYFriendsHeaderCellID @"LYFriendsHeaderTableViewCell"
#define LYFriendsLikeDetailCellID @"LYFriendsLikeDetailTableViewCell"
#define LYFriendsCommentDetailCellID @"LYFriendsCommentDetailTableViewCell"

@interface LYFriendsMessageDetailViewController ()<UITableViewDataSource,UITableViewDelegate,LYFriendsHeaderTableViewCellDelegate,UITextFieldDelegate,UIActionSheetDelegate,ISEmojiViewDelegate,UIActionSheetDelegate>
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
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation LYFriendsMessageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupAllProperty];
    [self setupTableView];
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
    [button addTarget:self action:@selector(jubaoDT:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)jubaoDT:(UIButton *)button{
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"选择举报原因" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"污秽色情",@"垃圾广告",@"其他原因",  nil];
        actionSheet.tag = 100;
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
    _indexStart = 1;
    [self getData];
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.title = @"消息详情";
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    _useridStr = [NSString stringWithFormat:@"%d",app.userModel.userid];
    
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
    NSArray *cellIDArray = @[LYFriendsHeaderCellID,LYFriendsLikeDetailCellID,LYFriendsCommentDetailCellID];
    for (NSString *cellID in cellIDArray) {
        [self.tableView registerNib:[UINib nibWithNibName:cellID bundle:nil] forCellReuseIdentifier:cellID];
    }
}

#pragma mark - 跳转到个人动态界面
- (void)pushUserMessageClick{
        if([_recentM.userId isEqualToString:_useridStr]) return;
    LYFriendsToUserMessageViewController *friendsUserMegVC = [[LYFriendsToUserMessageViewController alloc]init];
    friendsUserMegVC.friendsId = _recentM.userId;
    [self.navigationController pushViewController:friendsUserMegVC animated:YES];
}

#pragma mark - 表白action
- (void)likeFriendsClick{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if(![MyUtil isUserLogin]){
        [MyUtil showCleanMessage:@"请先登录！"];
        [MyUtil gotoLogin];
        return;
    }
    LYFriendsHeaderTableViewCell *cell = (LYFriendsHeaderTableViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell.btn_like.enabled = NO;
    NSString *likeStr = nil;
    if ([[NSString stringWithFormat:@"%@",_recentM.liked] isEqual:@"0"]) {//未表白过
        likeStr = @"1";
    }else{
        likeStr = @"0";
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
            _indexStart = 2;
            _recentM.liked = @"1";
        }else{
            for (int i = 0; i< _recentM.likeList.count;i ++) {
                FriendsLikeModel *likeM = _recentM.likeList[i];
                if ([likeM.userId isEqualToString:_useridStr]) {
                    [_recentM.likeList removeObject:likeM];
                }
            }
            _indexStart = 1;
                        _recentM.liked = @"0";
        }
        cell.btn_like.enabled = YES;
        [weakSelf.tableView reloadData];
    }];
}

#pragma mark - 评论action
- (void)commentClick{
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
    _commentView.frame = CGRectMake(0, SCREEN_HEIGHT - 110 , SCREEN_WIDTH, 54);
    _commentView.bgView.layer.borderColor = RGBA(143, 2, 195, 1).CGColor;
    _commentView.bgView.layer.borderWidth = 0.5;
    [_bigView addSubview:_commentView];
    if (defaultCommnet && ![defaultCommnet isEqualToString:@""]) {
        _commentView.textField.text = defaultCommnet;
    }
    [_commentView.textField becomeFirstResponder];
    _commentView.textField.delegate = self;
    [_commentView.btn_emotion addTarget:self action:@selector(emotionClick:) forControlEvents:UIControlEventTouchUpInside];
    
    if(_isCommentToUser){
        NSInteger likeCount = _recentM.likeList.count == 0 ? 1:2;
//        for (FriendsCommentModel *com in _recentM.commentList) {
//            NSLog(@"--->%@",com.comment);
//        }
        FriendsCommentModel *commentM = _dataArray[_indexRow - likeCount];
        _commentView.textField.placeholder = [NSString stringWithFormat:@"回复%@",commentM.nickName];
    }
    
    [UIView animateWithDuration:.25 animations:^{
      //  _commentView.frame = CGRectMake(0, SCREEN_HEIGHT - 249 - 72 - 52, SCREEN_WIDTH, 49);
    } completion:^(BOOL finished) {
        
    }];
    
    
}

- (void)emotionClick:(UIButton *)button{
    button.selected = !button.selected;
    if(button.selected){
        _commentView.btn_send_cont_width.constant = 60;
        [_commentView.btn_send setTitle:@"发送" forState:UIControlStateNormal];
        [_commentView.btn_send addTarget:self action:@selector(sendMessageClick:) forControlEvents:UIControlEventTouchUpInside];
        [self updateViewConstraints];
        [_commentView.textField endEditing:YES];
        ISEmojiView *emojiView = [[ISEmojiView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 216)];
        emojiView.delegate = self;
        emojiView.inputView = _commentView.textField;
        _commentView.textField.inputView = emojiView;
        [_commentView.textField becomeFirstResponder];
        [UIView animateWithDuration:.1 animations:^{
            CGFloat y = SCREEN_HEIGHT - CGRectGetHeight(_commentView.frame) - CGRectGetHeight(emojiView.frame);
          //  _commentView.frame = CGRectMake(0,y - 60 , CGRectGetWidth(_commentView.frame), CGRectGetHeight(_commentView.frame));
            NSLog(@"----->%@",NSStringFromCGRect(_commentView.frame));
        }];
    }else{
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
//    if(_commentView.textField.text.length){
        defaultCommnet = _commentView.textField.text;
//    }
    [_bigView removeFromSuperview];
    
}

#pragma mark - 点赞的人的头像跳转到个人动态
- (void)zangBtnClick:(UIButton *)button{
    NSInteger index = button.tag % 16;
    NSInteger section = (button.tag - index)/16;
    if(index > _recentM.likeList.count) return;
    if(section >=0 && index>=0){
        FriendsLikeModel *likeM = _recentM.likeList[index - 1];
        if([likeM.userId isEqualToString:_useridStr]) return;
        LYFriendsToUserMessageViewController *messageVC = [[LYFriendsToUserMessageViewController alloc]init];
        messageVC.friendsId = likeM.userId;
        [self.navigationController pushViewController:messageVC animated:YES];
    }
}


#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
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
    NSInteger likeCount = _recentM.likeList.count == 0? 1 : 2;
    if (_isCommentToUser) {
        FriendsCommentModel *commentModel = _dataArray[_indexRow - likeCount];
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
    NSInteger likeCount ;
    likeCount = _recentM.likeList.count == 0 ? 0 : 1;
    return 1 + likeCount + _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
            LYFriendsHeaderTableViewCell *headerCell = [tableView dequeueReusableCellWithIdentifier:LYFriendsHeaderCellID forIndexPath:indexPath];
            headerCell.delegate = self;
            headerCell.recentM = _recentM;
            [headerCell.btn_headerImg addTarget:self action:@selector(pushUserMessageClick) forControlEvents:UIControlEventTouchUpInside];
            [headerCell.btn_like addTarget:self action:@selector(likeFriendsClick) forControlEvents:UIControlEventTouchUpInside];
            [headerCell.btn_comment addTarget:self action:@selector(commentClick) forControlEvents:UIControlEventTouchUpInside];
            return headerCell;
        }
            break;

        default:{
            
            if(_recentM.likeList.count){
                if (indexPath.row == 1) {
                    _indexStart = 2;
                LYFriendsLikeDetailTableViewCell *likeCell = [tableView dequeueReusableCellWithIdentifier:LYFriendsLikeDetailCellID forIndexPath:indexPath];
                likeCell.recentM = _recentM;
                    for (int i = 0; i< likeCell.btnArray.count; i ++) {
                        UIButton *btn = likeCell.btnArray[i];
                        btn.tag = likeCell.btnArray.count * indexPath.section  + i + 1;
                        [btn addTarget:self action:@selector(zangBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    }
                return likeCell;
                }
            }
            FriendsCommentModel *commentModel = _dataArray[indexPath.row - _indexStart];
            LYFriendsCommentDetailTableViewCell *commentCell = [tableView dequeueReusableCellWithIdentifier:LYFriendsCommentDetailCellID forIndexPath:indexPath];
            commentCell.btn_headerImg.tag = indexPath.row - _indexStart;
            [commentCell.btn_headerImg addTarget:self action:@selector(puUserMessagePageClick:) forControlEvents:UIControlEventTouchUpInside];
            commentCell.imageView_comment.hidden = YES;
            if (_indexStart == 1) {
                if (indexPath.row == 1) {
                    commentCell.imageView_comment.hidden = NO;
                }
            }else{
                if (indexPath.row == 2) {
                    commentCell.imageView_comment.hidden = NO;
                }
            }
            commentCell.commentModel = commentModel;
            return commentCell;
            
        }
            break;
    }
   
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(!indexPath.row) return;
    _indexRow = indexPath.row;
    NSInteger likeCount ;
    likeCount = _recentM.likeList.count == 0 ? 1 : 2;
    if(likeCount == 2 && indexPath.row == 1) return;
    FriendsCommentModel *commentM = _dataArray[indexPath.row - likeCount];
    if (indexPath.row >= 1) {
        if (indexPath.row == 1) {
            if (_recentM.likeList.count) {
                return;
            }
        }
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
            CGSize size = [_recentM.message boundingRectWithSize:CGSizeMake(260, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} context:nil].size;
            return 129 + size.height;
            }
            break;
            
        default:
            if (_recentM.likeList.count) {
                
                if (indexPath.row == 1) {
                    _indexStart = 2;
                    return  _recentM.likeList.count <= 8 ? 42 : 82;
                }
            }
            FriendsCommentModel *commentModel = _dataArray[indexPath.row - _indexStart];
            NSString *string = [NSString stringWithFormat:@"%@:%@",commentModel.nickName,commentModel.comment];
//            CGSize size = [string boundingRectWithSize:CGSizeMake(235, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
//            return size.height >= 34 ? size.height + 14 : 34;
            
            CGSize size = [string boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 91, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
            CGFloat height;
            if (size.height + 10 < 36) {
                height = 36;
            }else {
                height = size.height + 10 + 3;
            }
            return height;
            
            break;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
            cell.separatorInset = UIEdgeInsetsMake(0, 1000, 0, 0);
        }
            break;
            
        default:
        {
            if (_recentM.likeNum.integerValue) {
                if(indexPath.row == 1){
                    cell.separatorInset = UIEdgeInsetsMake(0, 14, 0, 14);
                    return;
                }
            }
            cell.separatorInset = UIEdgeInsetsMake(0, 34, 0, 14);
        }
            break;
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
    }else{
        NSInteger count = _recentM.likeList.count == 0 ? 1 : 2;
        if (!buttonIndex) {//删除我的评论
            FriendsCommentModel *commentM = _dataArray[_indexRow - count];
            NSDictionary *paraDic = @{@"userId":_useridStr,@"commentId":commentM.commentId};
            __weak LYFriendsMessageDetailViewController *weakSelf = self;
            [LYFriendsHttpTool friendsDeleteMyCommentWithParams:paraDic compelte:^(bool result) {
                if(result){
                    [_dataArray removeObjectAtIndex:_indexRow - count];
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
    LYFriendsToUserMessageViewController *friendsUserMegVC = [[LYFriendsToUserMessageViewController alloc]init];
    friendsUserMegVC.friendsId = commentModel.userId;
    [self.navigationController pushViewController:friendsUserMegVC animated:YES];
}

#pragma mark - LYFriendsHeaderTableViewCellDelegate
- (void)friendsHeaderCellImageView:(UIImageView *)imgView{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSArray *urlArray = _recentM.lyMomentsAttachList;
    urlArray = [((FriendsPicAndVideoModel *)urlArray[0]).imageLink componentsSeparatedByString:@","];
    NSMutableArray *oldFrameArray = [[NSMutableArray alloc]init];
    
    LYFriendsHeaderTableViewCell *headerCell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    for (UIImageView *imgViewCell in headerCell.imageViewArray) {
        NSString *oldFrame = NSStringFromCGRect([headerCell convertRect:imgViewCell.frame toView:app.window]);
        [oldFrameArray addObject:oldFrame];
    }
    
    

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
