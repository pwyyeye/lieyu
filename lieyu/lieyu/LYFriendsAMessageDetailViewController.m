//
//  LYFriendsAMessageDetailViewController.m
//  lieyu
//
//  Created by 狼族 on 16/4/23.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYFriendsAMessageDetailViewController.h"
#import "LYFriendsHttpTool.h"

@interface LYFriendsAMessageDetailViewController (){
    NSArray *_commentListArray;//存储上个页面的评论
}

@end

@implementation LYFriendsAMessageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"消息详情";
    _commentListArray = _recentM.commentList;
    
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSString *MyUserid = [NSString stringWithFormat:@"%d",app.userModel.userid];
    if (![MyUserid isEqualToString:_recentM.userId]) {
        //不是自己的动态详情
        [self configureRightButton];
    }
}

- (void)configureRightButton{
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    button.imageEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    [button setImage:[UIImage imageNamed:@"jubao_btn"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(warningSheet:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _recentM.commentList = _commentListArray.mutableCopy;//页面离开时把原来存储的评论赋值给动态评论
}

#pragma mark - 根据id获取一条动态
- (void)getDataWithType:(dataType)type{
    UITableView *tableView = nil;
    int pageStartCount = 0;
    if (type == dataForFriendsMessage) {
        pageStartCount = _pageStartCountArray[0];
        tableView = _tableViewArray.firstObject;
    }else if(type == dataForMine){
    }

    NSDictionary *paraDic = @{@"userId":_useridStr,@"messageId":_recentM.id};
//    __weak __typeof(self) weakSelf = self;
    if (type == dataForFriendsMessage) {
//        [LYFriendsHttpTool friendsGetAMessageWithParams:paraDic compelte:^(FriendsRecentModel *recentM) {
            [self loadDataWith:tableView dataArray:@[_recentM].mutableCopy pageStartCount:pageStartCount type:type];
//            tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
        
        [LYFriendsHttpTool friendsGetMessageDetailAllCommentsWithParams:paraDic compelte:^(NSMutableArray *commentArray) {
            _recentM.commentList = commentArray;
            if(commentArray.count)   [tableView reloadData];
        }];
    }
}
#pragma mark - 获取数据
- (void)startGetData{
    [self getDataWithType:dataForFriendsMessage];
}

#pragma mark - 为表配置上下刷新控件
- (void)setupMJRefreshForTableView:(UITableView *)tableView i:(NSInteger)i{
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *array = (NSArray *)_dataArray[tableView.tag];
    FriendsRecentModel *recentM = array[section];
        return 4 + recentM.commentList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *dataArr = _dataArray[tableView.tag];
    FriendsRecentModel *recentM = dataArr[indexPath.section];
    switch (indexPath.row) {
        case 0://昵称 头像 动态文本的cell
        {
            LYFriendsNameTableViewCell *nameCell = [tableView dequeueReusableCellWithIdentifier:LYFriendsNameCellID forIndexPath:indexPath];
            nameCell.label_content.numberOfLines = 99;
            nameCell.recentM = recentM;
            nameCell.btn_delete.tag = indexPath.section;
            nameCell.btn_topic.tag = indexPath.section;
            [nameCell.btn_topic addTarget:self action:@selector(topicNameClick:) forControlEvents:UIControlEventTouchUpInside];
          /*  if (!tableView.tag) {
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
                [nameCell.btn_headerImg addTarget:self action:@selector(pushUserMessagePage:) forControlEvents:UIControlEventTouchUpInside]; */
//            }else{
//                [nameCell.btn_delete setTitle:@"删除" forState:UIControlStateNormal];
//                [nameCell.btn_delete setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
//                [nameCell.btn_delete addTarget:self action:@selector(deleteClick:) forControlEvents:UIControlEventTouchUpInside];
//                nameCell.btn_delete.hidden = NO;
//                nameCell.btn_delete.enabled = YES;
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
                videoCell.btn_play.tag = indexPath.section;
                
                 NSString *imageStr = ((FriendsPicAndVideoModel *)recentM.lyMomentsAttachList[0]).thumbnailUrl;
                if (![MyUtil isEmptyString:imageStr]) {
                    [videoCell.imgView_video sd_setImageWithURL:[NSURL URLWithString:[MyUtil getQiniuUrl:imageStr width:0 andHeight:0]] placeholderImage:[UIImage imageNamed:@"empyImage300"]];
                }else{
                    [videoCell.imgView_video sd_setImageWithURL:[NSURL URLWithString:[MyUtil getQiniuUrl:urlStr mediaType:QiNiuUploadTpyeDefault width:0 andHeight:0]] placeholderImage:[UIImage imageNamed:@"empyImage300"]];
                }
//                [videoCell.imgView_video sd_setImageWithURL:[NSURL URLWithString:[MyUtil getQiniuUrl:urlStr mediaType:QiNiuUploadTpyeDefault width:0 andHeight:0]] placeholderImage:[UIImage imageNamed:@"empyImage300"]];
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
//            if(recentM.likeList.count){
                LYFriendsLikeDetailTableViewCell *likeCell = [tableView dequeueReusableCellWithIdentifier:LYFriendsAllLikeCellID forIndexPath:indexPath];
                likeCell.recentM = _recentM;
                for (int i = 0; i< likeCell.btnArray.count; i ++) {
                    UIButton *btn = likeCell.btnArray[i];
                    btn.tag = i;
                    [btn addTarget:self action:@selector(zangBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                }
                return likeCell;
            
        }
            break;
            
        default:{ //评论 4-8
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (isExidtEffectView) [emojisView hideEmojiEffectView];
    _section = indexPath.section;
    FriendsRecentModel *recentM = _dataArray[_index][indexPath.section];
    if (indexPath.row >= 4) {
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
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *arr = _dataArray[_index];
    FriendsRecentModel *recentM = arr[indexPath.section];
    //    NSLog(@"--->%ld",indexPath.section);
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
//                if(size.height >= 56) size.height = 56;
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
//            return count == 0 ? 0 : (SCREEN_WIDTH - 114)/8.f + 20;
            return ((count - 1) / 7 + 1) * ((SCREEN_WIDTH - 114)/8.f + 20);
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

#pragma mark - 点赞的人的头像跳转到个人动态
- (void)zangBtnClick:(UIButton *)button{
    if (isExidtEffectView) {
        [emojisView hideEmojiEffectView];
    }
    
    if(button.tag >= _recentM.likeList.count) return;
    if( index>=0){
        FriendsLikeModel *likeM = _recentM.likeList[button.tag];
        if([likeM.userId isEqualToString:_useridStr]) return;
        
        LYMyFriendDetailViewController *myFriendVC = [[LYMyFriendDetailViewController  alloc]initWithNibName:@"LYMyFriendDetailViewController" bundle:nil];
        myFriendVC.userID = likeM.userId;
        [self.navigationController pushViewController:myFriendVC animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
