//
//  LYFriendsToUserMessageViewController.m
//  lieyu
//
//  Created by 狼族 on 15/12/28.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYFriendsToUserMessageViewController.h"
#import "LYFriendsNameTableViewCell.h"
#import "LYFriendsImgOneTableViewCell.h"
#import "LYFriendsImgTwoTableViewCell.h"
#import "LYFriendsThreeTableViewCell.h"
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

@interface LYFriendsToUserMessageViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>{
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
    [IQKeyboardManager sharedManager].enable = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
}

- (void)setupAllProperty{
    _dataArray = [[NSMutableArray alloc]initWithCapacity:0];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    _useridStr = [NSString stringWithFormat:@"%d",app.userModel.userid];
    _pageStartCount = 0;
    _pageCount = 10;
    [self getData];
    self.title = @"好友动态";
}


- (void)setupTableView{
    NSArray *array = @[LYFriendsNameCellID,LYFriendsImgOneCellID,LYFriendsImgTwoCellID,LYFriendsImgThreeCellID,LYFriendsAddressCellID,LYFriendsLikeCellID,LYFriendsCommentCellID,LYFriendsAllCommentCellID];
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
    urlArray = ((FriendsRecentModel *)_dataArray[section]).lyMomentsAttachList;
    LYFriendsImgTableViewCell *imgCell = (LYFriendsImgTableViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:section]];
    for (UIButton *btn in imgCell.btnArray) {
        CGRect rect = [imgCell convertRect:btn.frame toView:app.window];
        [oldFrameArray addObject:NSStringFromCGRect(rect)];
    }
    
    LYPictiureView *picView = [[LYPictiureView alloc]initWithFrame:self.view.bounds urlArray:urlArray oldFrame:oldFrameArray with:index];
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
    __block LYFriendsToUserMessageViewController *weakSelf = self;
    [LYFriendsHttpTool friendsGetUserInfoWithParams:paraDic compelte:^(NSMutableArray *dataArray) {
        _dataArray = dataArray;
        [weakSelf reloadTableViewAndSetUpProperty];
        [weakSelf addTableViewHeader];
        _pageStartCount ++;
    }];
}

#pragma mark － 刷新表
- (void)reloadTableViewAndSetUpProperty{
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    if(!((NSArray *)_dataArray).count){
        return;
    }
    FriendsRecentModel *recentM = _dataArray[_section];
    if ([recentM.liked isEqualToString:@"0"]) {
        _likeStr = @"0";
    }else{
        _likeStr = @"1";
    }
}

#pragma mark - 添加表头
- (void)addTableViewHeader{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    _headerView = [[[NSBundle mainBundle]loadNibNamed:@"LYFriendsUserHeaderView" owner:nil options:nil]firstObject];
    _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 220);
    [_headerView.btn_header sd_setBackgroundImageWithURL:[NSURL URLWithString:app.userModel.avatar_img] forState:UIControlStateNormal ];
    _headerView.label_name.text = app.userModel.usernick;
    _headerView.ImageView_bg.backgroundColor = [UIColor redColor];
    _headerView.btn_newMessage.hidden = YES;
    self.tableView.tableHeaderView = _headerView;
    [_headerView.btn_header addTarget:self action:@selector(headerImgClick:) forControlEvents:UIControlEventTouchUpInside];
    [self updateViewConstraints];
}



- (void)headerImgClick:(UIButton *)button{
    
//        CustomerModel *customerM = [[CustomerModel alloc]init];
//        customerM.
}

#pragma mark - 表白action
- (void)likeFriendsClick:(UIButton *)button{
    FriendsRecentModel *recentM = _dataArray[button.tag];
    NSDictionary *paraDic = @{@"userId":_useridStr,@"messageId":recentM.id,@"type":_likeStr};
    __block LYFriendsToUserMessageViewController *weakSelf = self;
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
    FriendsRecentModel *recentM = _dataArray[_commentBtnTag];
    NSDictionary *paraDic = @{@"userId":_useridStr,@"messageId":recentM.id,@"toUserId":@"",@"comment":_commentView.textField.text};
    __block LYFriendsToUserMessageViewController *weakSelf = self;
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
    FriendsRecentModel *recentM = _dataArray[button.tag];
    LYFriendsMessageDetailViewController *messageDetailVC = [[LYFriendsMessageDetailViewController alloc]init];
    messageDetailVC.recentM = recentM;
    [self.navigationController pushViewController:messageDetailVC animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    FriendsRecentModel *recentM = _dataArray[section];
    if (recentM.commentNum.integerValue >= 6) {
        return 10;
    }else{
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
    FriendsRecentModel *recentM = _dataArray[indexPath.section];
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
