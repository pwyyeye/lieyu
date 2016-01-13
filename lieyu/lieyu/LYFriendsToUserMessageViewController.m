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

#define LYFriendsNameCellID @"LYFriendsNameTableViewCell"
#define LYFriendsAddressCellID @"LYFriendsAddressTableViewCell"
#define LYFriendsLikeCellID @"LYFriendsLikeTableViewCell"
#define LYFriendsCommentCellID @"LYFriendsCommentTableViewCell"
#define LYFriendsAllCommentCellID @"LYFriendsAllCommentTableViewCell"
#define LYFriendsImgCellID @"LYFriendsImgTableViewCell"
#define LYFriendsVideoCellID @"LYFriendsVideoTableViewCell"

#define LYFriendsCellID @"cell"

@interface LYFriendsToUserMessageViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIActionSheetDelegate,ISEmojiViewDelegate>{
     NSString *_useridStr;
    NSMutableArray *_dataArray;
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
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

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
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].isAdd = NO;
}

- (void)setupAllProperty{
    _dataArray = [[NSMutableArray alloc]initWithCapacity:0];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    _useridStr = [NSString stringWithFormat:@"%d",app.userModel.userid];
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
        if(dataArray.count){
        _userInfo = userInfo;
        if(_pageStartCount == 0) {
            _dataArray = dataArray;
        }else{
            [_dataArray addObjectsFromArray:dataArray];
        }
        [weakSelf reloadTableViewAndSetUpProperty];
        [weakSelf addTableViewHeader];
        _pageStartCount ++;
            [self.tableView.mj_footer endRefreshing];
        }else {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
}

#pragma mark － 评论点击头像跳转到指定用户界面
- (void)pushUserPage:(LYFriendsCommentButton *)button{
    FriendsRecentModel *recentM = _dataArray[button.tag];
    FriendsCommentModel *commentModel = recentM.commentList[button.indexTag - 4];
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
    _headerView.ImageView_bg.backgroundColor = [UIColor redColor];
    _headerView.btn_newMessage.hidden = YES;
    [_headerView.ImageView_bg sd_setImageWithURL:[NSURL URLWithString:_userInfo.friends_img] placeholderImage:[UIImage imageNamed:@"friendPresentBG.jpeg"]];
    _headerView.ImageView_bg.clipsToBounds = YES;
    self.tableView.tableHeaderView = _headerView;
    [_headerView.btn_header addTarget:self action:@selector(headerImgClick:) forControlEvents:UIControlEventTouchUpInside];
    [self updateViewConstraints];
}

- (void)headerImgClick:(UIButton *)button{
        CustomerModel *customerM = [[CustomerModel alloc]init];
        customerM.avatar_img = _userInfo.avatar_img;
        customerM.sex = [_userInfo.gender isEqualToString:@"0"] ? @"男" : @"女";
        customerM.usernick = _userInfo.usernick;
        customerM.message = _userInfo.introduction;
        customerM.age = [MyUtil getAgefromDate:_userInfo.birthday];
        customerM.userid = _userInfo.userId.intValue;
        LYMyFriendDetailViewController *friendDetailVC = [[LYMyFriendDetailViewController alloc]init];
        friendDetailVC.customerModel = customerM;
    if(_dataArray.count) {
        FriendsRecentModel *recentM = _dataArray[0];
        friendDetailVC.type = [NSString stringWithFormat:@"%@",recentM.type];
    }
        [self.navigationController pushViewController:friendDetailVC animated:YES];
}

#pragma mark - 表白action
- (void)likeFriendsClick:(UIButton *)button{
    LYFriendsAddressTableViewCell *cell = (LYFriendsAddressTableViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:button.tag]];
    cell.btn_like.enabled = NO;
   AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
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

#pragma mark - 评论action
- (void)commentClick:(UIButton *)button{
    _commentBtnTag = button.tag;
    _isCommentToUser = NO;
    [self createCommentView];
}

- (void)keyBorderApearce:(NSNotification *)note{
    
    //    NSString *keybordHeight = note.userInfo[@"UIKeyboardFrameEndUserInfoKey"];
    CGRect rect = [note.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    [UIView animateWithDuration:.25 animations:^{
       // _commentView.frame = CGRectMake(0, SCREEN_HEIGHT - rect.size.height - 49, SCREEN_WIDTH, 49);
        NSLog(@"--->%@------->%@",NSStringFromCGRect(rect),NSStringFromCGRect(_commentView.frame));
    }];
}


#pragma mark - 赞的人头像
- (void)zangBtnClick:(UIButton *)button{
    NSInteger i = button.tag % 7;
    NSInteger section = (button.tag - i) / 7 ;
 
    if(section >=0 && i>=0){
        FriendsRecentModel *recentM = _dataArray[section];
        if(i > recentM.likeList.count) return;
        FriendsLikeModel *likeM = recentM.likeList[i - 1];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FriendsRecentModel *recentM = _dataArray[indexPath.section];
    switch (indexPath.row) {
        case 0:
        {
            LYFriendsNameTableViewCell *nameCell = [tableView dequeueReusableCellWithIdentifier:LYFriendsNameCellID forIndexPath:indexPath];
                nameCell.recentM = recentM;
                nameCell.btn_delete.hidden = YES;
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
                if(recentM.likeList.count <= 8) likeCell.btn_more.hidden = YES;
                for (int i = 0; i< likeCell.btnArray.count; i ++) {
                    UIButton *btn = likeCell.btnArray[i];
                    btn.tag = likeCell.btnArray.count * (indexPath.section + 1) - 7 + i +1;
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
            
            commentCell.btn_headerImg.indexTag = indexPath.row;
            [commentCell.btn_headerImg addTarget:self action:@selector(pushUserPage:) forControlEvents:UIControlEventTouchUpInside];
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
            CGSize size = [recentM.message boundingRectWithSize:CGSizeMake(306, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
          //  if(size.height >= 47) size.height = 47;
//            if(![MyUtil isEmptyString:recentM.message]) {
//                if(size.height >= 47 ) size.height = 47;
//            if(![MyUtil isEmptyString:recentM.message]) {
//                size.height = 15 + size.height;
//            }
            if(![MyUtil isEmptyString:recentM.message]) {
                if(size.height >= 47 ) size.height = 47;
                size.height = 10 + size.height;
            }else{
                size.height = 0;
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
            return count == 0 ? 0 : 46;
        }
            break;
        case 9:{
            return 36;
        }
            
        default:
        {
            if(!recentM.commentList.count) return 36;
            NSLog(@"-----%ld-->%ld",recentM.commentList.count,indexPath.row);
            if(indexPath.row - 4 > recentM.commentList.count - 1) return 36;
            FriendsCommentModel *commentM = recentM.commentList[indexPath.row - 4];
            NSString *str = [NSString stringWithFormat:@"%@:%@",commentM.nickName,commentM.comment];
            CGSize size = [str boundingRectWithSize:CGSizeMake(239, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
            CGFloat height;
            if (size.height + 10 < 36) {
                height = 36;
            }else {
                height = size.height + 15;
            }
            return height;
        }
            break;
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FriendsRecentModel *recentM = _dataArray[indexPath.section];
    if (indexPath.row >= 4 && indexPath.row <= 8) {
        if(!recentM.commentList.count) return;
        _indexRow = indexPath.row;
        if(indexPath.row - 4 == recentM.commentList.count) {
            [self pushFriendsMessageDetailVCWithIndex:indexPath.section];
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
    if(!buttonIndex){
            FriendsRecentModel *recetnM = _dataArray[_section];
            FriendsCommentModel *commentM = recetnM.commentList[_indexRow - 4];
            NSDictionary *paraDic = @{@"userId":_useridStr,@"commentId":commentM.commentId};
            __weak LYFriendsToUserMessageViewController *weakSelf = self;
            [LYFriendsHttpTool friendsDeleteMyCommentWithParams:paraDic compelte:^(bool result) {
                if(result){
                    NSMutableArray *commentArr = ((FriendsRecentModel *)_dataArray[_section]).commentList;
                    NSLog(@"------>%@------%ld",commentArr,_indexRow);
                    [commentArr removeObjectAtIndex:_indexRow - 4];
                    recetnM.commentNum = [NSString stringWithFormat:@"%ld",recetnM.commentNum.integerValue - 1];
                    [weakSelf.tableView reloadData];
                }
            }];
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
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
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
    _commentView.frame = CGRectMake(0, SCREEN_HEIGHT - 110, SCREEN_WIDTH, 49);
    _commentView.bgView.layer.borderColor = RGBA(143, 2, 195, 1).CGColor;
    _commentView.bgView.layer.borderWidth = 0.5;
    [_bigView addSubview:_commentView];
    
    [_commentView.textField becomeFirstResponder];
    _commentView.textField.delegate = self;
    [_commentView.btn_emotion addTarget:self action:@selector(emotionClick:) forControlEvents:UIControlEventTouchUpInside];
//    SCREEN_HEIGHT - 249- 100 - 129
    
    if(_isCommentToUser){
        FriendsRecentModel *recentM = (FriendsRecentModel *)_dataArray[_section];
        FriendsCommentModel *commentM = recentM.commentList[_indexRow - 4];
        _commentView.textField.placeholder = [NSString stringWithFormat:@"回复%@",commentM.nickName];
    }
    
    [UIView animateWithDuration:.25 animations:^{
      //  _commentView.frame = CGRectMake(0,  SCREEN_HEIGHT - 249 - 72 - 52, SCREEN_WIDTH, 49);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)sendMessageClick:(UIButton *)button{
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
- (void)emotionClick:(UIButton *)button{
    button.selected = !button.selected;
    if(button.selected){
        _commentView.btn_send_cont_width.constant = 30;
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
        [_commentView.textField becomeFirstResponder];
        [UIView animateWithDuration:.1 animations:^{
            // _commentView.frame = CGRectMake(0,SCREEN_HEIGHT - 216 - CGRectGetHeight(_commentView.frame) , CGRectGetWidth(_commentView.frame), CGRectGetHeight(_commentView.frame));
           // _commentView.frame = CGRectMake(0, SCREEN_HEIGHT - 249 - 72 - 52, SCREEN_WIDTH, CGRectGetHeight(_commentView.frame));
        }];
    }
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
    NSDictionary *paraDic = @{@"userId":_useridStr,@"messageId":recentM.id,@"toUserId":toUserId,@"comment":_commentView.textField.text};
    __weak LYFriendsToUserMessageViewController *weakSelf = self;
    [LYFriendsHttpTool friendsCommentWithParams:paraDic compelte:^(bool resutl,NSString *commentId) {
        if (resutl) {
            NSLog(@"--->%ld",recentM.commentList.count + 2);
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
