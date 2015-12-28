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

#define LYFriendsNameCellID @"LYFriendsNameTableViewCell"
#define LYFriendsImgOneCellID @"LYFriendsImgOneTableViewCell"
#define LYFriendsImgTwoCellID @"LYFriendsImgTwoTableViewCell"
#define LYFriendsImgThreeCellID @"LYFriendsThreeTableViewCell"
#define LYFriendsAddressCellID @"LYFriendsAddressTableViewCell"
#define LYFriendsLikeCellID @"LYFriendsLikeTableViewCell"
#define LYFriendsCommentCellID @"LYFriendsCommentTableViewCell"
#define LYFriendsAllCommentCellID @"LYFriendsAllCommentTableViewCell"
#define LYFriendsCellID @"cell"

@interface LYFriendsToUserMessageViewController ()<UITableViewDataSource,UITableViewDelegate,LYFriendsImgOneTableViewCellDelegate>{
     NSString *_useridStr;
    NSMutableArray *_dataArray;
     LYFriendsUserHeaderView *_headerView;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation LYFriendsToUserMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupAllProperty];//设置全局属性
    [self setupTableView];
}

- (void)setupAllProperty{
    _dataArray = [[NSMutableArray alloc]initWithCapacity:0];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    _useridStr = [NSString stringWithFormat:@"%d",app.userModel.userid];
    [self getData];
}


- (void)setupTableView{
    NSArray *array = @[LYFriendsNameCellID,LYFriendsImgOneCellID,LYFriendsImgTwoCellID,LYFriendsImgThreeCellID,LYFriendsAddressCellID,LYFriendsLikeCellID,LYFriendsCommentCellID,LYFriendsAllCommentCellID];
    for (NSString *cellIdentifer in array) {
        [self.tableView registerNib:[UINib nibWithNibName:cellIdentifer bundle:nil] forCellReuseIdentifier:cellIdentifer];
    }
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:LYFriendsCellID];
}

#pragma mark - 获取指定用户数据
- (void)getData{
    NSDictionary *paraDic = @{@"userId":_useridStr,@"start":@"0",@"limit":@"10",@"frientId":_friendsId};
    __block LYFriendsToUserMessageViewController *weakSelf = self;
    [LYFriendsHttpTool friendsGetUserInfoWithParams:paraDic compelte:^(NSMutableArray *dataArray) {
        _dataArray = dataArray;
        [weakSelf.tableView reloadData];
        [weakSelf addTableViewHeader];
    }];
}

#pragma mark - 添加表头
- (void)addTableViewHeader{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    _headerView = [[[NSBundle mainBundle]loadNibNamed:@"LYFriendsUserHeaderView" owner:nil options:nil]firstObject];
    _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 277);
    [_headerView.btn_header sd_setBackgroundImageWithURL:[NSURL URLWithString:app.userModel.avatar_img] forState:UIControlStateNormal ];
    _headerView.label_name.text = app.userModel.usernick;
    _headerView.ImageView_bg.backgroundColor = [UIColor redColor];
    _headerView.btn_newMessage.hidden = YES;
    self.tableView.tableHeaderView = _headerView;
  //  [_headerView.btn_newMessage addTarget:self action:@selector(newClick) forControlEvents:UIControlEventTouchUpInside];
    [self updateViewConstraints];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    FriendsRecentModel *recentM = _dataArray[section];
    if (recentM.commentNum.integerValue >= 6) {
        return 11;
    }else{
        return 5 + recentM.commentNum.integerValue;
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
          //  nameCell.btn_headerImg.tag = indexPath.section;
         //   [nameCell.btn_headerImg addTarget:self action:@selector(pushUserMessagePage:) forControlEvents:UIControlEventTouchUpInside];
                nameCell.btn_delete.hidden = YES;
            return nameCell;
            
        }
            break;
        case 1:
        {
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
            }
        }
            break;
        case 2:
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
            break;
        case 3://地址
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
            
        case 4://好友的赞
        {
            if(recentM.likeList.count){
                LYFriendsLikeTableViewCell *likeCell = [tableView dequeueReusableCellWithIdentifier:LYFriendsLikeCellID forIndexPath:indexPath];
                likeCell.recentM = recentM;
                return likeCell;}
            else{
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LYFriendsCellID forIndexPath:indexPath];
                return cell;
            }
        }
            break;
        case 10:
        {
            if (recentM.commentList.count >= 6) {
                LYFriendsAllCommentTableViewCell *allCommentCell = [tableView dequeueReusableCellWithIdentifier:LYFriendsAllCommentCellID forIndexPath:indexPath];
                allCommentCell.recentM = recentM;
                return allCommentCell;
            }else{
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LYFriendsCellID forIndexPath:indexPath];
                return cell;
            }
        }
            
        default:{ //评论 5-9
            FriendsCommentModel *commentModel = recentM.commentList[indexPath.row - 5];
            LYFriendsCommentTableViewCell *commentCell = [tableView dequeueReusableCellWithIdentifier:LYFriendsCommentCellID forIndexPath:indexPath];
            if (indexPath.row == 5) {
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
        case 0:
        {
            return 111;
        }
            break;
            
        case 1:
        {
            return 320;
        }
            break;
        case 2:
        {
            return recentM.lyMomentsAttachList.count > 2 ? 105 : 0;
        }
            break;
        case 3:
        {
            return 45;
        }
            break;
        case 4:
        {
            
            NSInteger count = recentM.likeNum.integerValue;
            return count == 0? 0 : 46;
        }
            break;
            
            
        default:
        {
            return 50;
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
