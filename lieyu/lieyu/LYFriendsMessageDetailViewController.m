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

#define LYFriendsHeaderCellID @"LYFriendsHeaderTableViewCell"
#define LYFriendsLikeDetailCellID @"LYFriendsLikeDetailTableViewCell"
#define LYFriendsCommentDetailCellID @"LYFriendsCommentDetailTableViewCell"

@interface LYFriendsMessageDetailViewController ()<UITableViewDataSource,UITableViewDelegate,LYFriendsHeaderTableViewCellDelegate,UITextFieldDelegate,UIActionSheetDelegate>
{
    NSMutableArray *_dataArray;
    NSInteger _indexStart;
    NSString *_useridStr;
    NSString *_likeStr;
    UIView *_bigView;
    LYFriendsCommentView *_commentView;//弹出的评论框
    BOOL _isCommentToUser;//是否对用户评论
    NSInteger _indexRow;//点的第几个行
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation LYFriendsMessageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupAllProperty];
    [self setupTableView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     [IQKeyboardManager sharedManager].enable = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
}

- (void)setupAllProperty{
    _indexStart = 1;
    [self getData];
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.title = @"消息详情";
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    _useridStr = [NSString stringWithFormat:@"%d",app.userModel.userid];
    
    if ([_recentM.liked isEqualToString:@"0"]) {
        _likeStr = @"0";
    }else{
        _likeStr = @"1";
    }
}

- (void)getData{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSString *userIdStr = [NSString stringWithFormat:@"%d",app.userModel.userid];
    __block LYFriendsMessageDetailViewController *weakSelf = self;
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
    //    if([recentM.userId isEqualToString:_useridStr]) return;
    LYFriendsToUserMessageViewController *friendsUserMegVC = [[LYFriendsToUserMessageViewController alloc]init];
    friendsUserMegVC.friendsId = _recentM.userId;
    [self.navigationController pushViewController:friendsUserMegVC animated:YES];
}

#pragma mark - 表白action
- (void)likeFriendsClick{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSLog(@"---->%@------%@--------%@",_useridStr,_recentM.id,_likeStr);
    NSDictionary *paraDic = @{@"userId":_useridStr,@"messageId":_recentM.id,@"type":_likeStr};
    __block LYFriendsMessageDetailViewController *weakSelf = self;
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
            [_recentM.likeList insertObject:likeModel atIndex:0];
            _indexStart = 2;
        }else{
            for (FriendsLikeModel *likeM in _recentM.likeList) {
                if ([likeM.userId isEqualToString:_useridStr]) {
                    [_recentM.likeList removeObject:likeM];
                }
            }
            _indexStart = 1;
        }
        [weakSelf.tableView reloadData];
    }];
}

#pragma mark - 评论action
- (void)commentClick{
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
    
    [UIView animateWithDuration:.25 animations:^{
        _commentView.frame = CGRectMake(0, SCREEN_HEIGHT - 249 - 119 - 52, SCREEN_WIDTH, 49);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)bigViewGes{
    [_bigView removeFromSuperview];
    
}



#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_bigView removeFromSuperview];
    [textField endEditing:YES];
    if(!_commentView.textField.text.length) return NO;
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSString *toUserId = nil;
    if (_isCommentToUser) {
        FriendsCommentModel *commentModel = _dataArray[_indexRow - _indexStart];
        toUserId = commentModel.userId;
    }else{
        toUserId = @"";
    }
    NSLog(@"----->%@----%@------------%@",_useridStr,_recentM.id,_commentView.textField.text);
    NSDictionary *paraDic = @{@"userId":_useridStr,@"messageId":_recentM.id,@"toUserId":toUserId,@"comment":_commentView.textField.text};
    __block LYFriendsMessageDetailViewController *weakSelf = self;
    [LYFriendsHttpTool friendsCommentWithParams:paraDic compelte:^(bool resutl) {
        if (resutl) {
            NSLog(@"--->%ld",_recentM.commentList.count + 2);
            FriendsCommentModel *commentModel = [[FriendsCommentModel alloc]init];
            commentModel.comment = _commentView.textField.text;
            commentModel.icon = app.userModel.avatar_img;
            commentModel.nickName = app.userModel.usernick;
            commentModel.userId = _useridStr;
            if(toUserId.length) commentModel.toUserId = toUserId;
            else commentModel.toUserId = @"0";
            [_dataArray addObject:commentModel];
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
                        [btn addTarget:self action:@selector(zangBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                        btn.tag = likeCell.btnArray.count * (indexPath.section + 1) - 7 + i +1;
                    }
                return likeCell;
                }
            }
            NSLog(@"---->%ld-----%ld----%ld",indexPath.row,_indexStart, _dataArray.count);
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
    _indexRow = indexPath.row;
    if (indexPath.row >= 1) {
        if (indexPath.row == 1) {
            if (_recentM.likeList.count) {
                return;
            }
        }
        if ([_recentM.userId isEqualToString:_useridStr]) {
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
            NSLog(@"------>%ld-----%ld",indexPath.row,_dataArray.count);
            FriendsCommentModel *commentModel = _dataArray[indexPath.row - _indexStart];
            NSString *string = [NSString stringWithFormat:@"%@:%@",commentModel.nickName,commentModel.comment];
            CGSize size = [string boundingRectWithSize:CGSizeMake(235, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
            return size.height >= 34 ? size.height + 14 : 34;
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
    if (!buttonIndex) {//删除我的评论
        NSLog(@"---->%ld-----",((NSArray *)_dataArray).count);
//        NSLog(@"---->%ld-----%ld",_indexRow,recetnM.commentList.count);
        FriendsCommentModel *commentM = _recentM.commentList[_indexRow - _indexStart];
        //            NSDictionary *paraDic = @{@"userId":_useridStr,@"commentId":commentM.};
        //            [LYFriendsHttpTool friendsDeleteMyCommentWithParams:paraDic compelte:^(bool result) {
        //
        //            }];
    }
}
#pragma mark - 跳转到指定用户动态页
- (void)puUserMessagePageClick:(UIButton *)button{
    FriendsCommentModel *commentModel = _recentM.commentList[button.tag];
    LYFriendsToUserMessageViewController *friendsUserMegVC = [[LYFriendsToUserMessageViewController alloc]init];
    friendsUserMegVC.friendsId = commentModel.userId;
    [self.navigationController pushViewController:friendsUserMegVC animated:YES];
}

#pragma mark - LYFriendsHeaderTableViewCellDelegate
- (void)friendsHeaderCellImageView:(UIImageView *)imgView{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSArray *urlArray = _recentM.lyMomentsAttachList;
    NSMutableArray *oldFrameArray = [[NSMutableArray alloc]init];
    
    LYFriendsHeaderTableViewCell *headerCell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    for (UIImageView *imgViewCell in headerCell.imageViewArray) {
        NSString *oldFrame = NSStringFromCGRect([headerCell convertRect:imgViewCell.frame toView:self.view]);
        NSLog(@"---->%@",oldFrame);
        [oldFrameArray addObject:oldFrame];
    }
    
    LYPictiureView *picView = [[LYPictiureView alloc]initWithFrame:self.view.bounds urlArray:urlArray oldFrame:oldFrameArray with:imgView.tag];
    picView.backgroundColor = [UIColor blackColor];
    
    [app.window addSubview:picView];
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
