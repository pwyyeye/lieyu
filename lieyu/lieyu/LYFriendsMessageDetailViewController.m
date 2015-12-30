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

#define LYFriendsHeaderCellID @"LYFriendsHeaderTableViewCell"
#define LYFriendsLikeDetailCellID @"LYFriendsLikeDetailTableViewCell"
#define LYFriendsCommentDetailCellID @"LYFriendsCommentDetailTableViewCell"

@interface LYFriendsMessageDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_dataArray;
    NSInteger _indexStart;
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

- (void)setupAllProperty{
    _indexStart = 1;
    [self getData];
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.title = @"消息详情";
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

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger likeCount ;
    likeCount = _recentM.likeNum.integerValue == 0 ? 0 : 1;
    NSLog(@"---->%ld",_dataArray.count);
    return 1 + likeCount + _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
            LYFriendsHeaderTableViewCell *headerCell = [tableView dequeueReusableCellWithIdentifier:LYFriendsHeaderCellID forIndexPath:indexPath];
            headerCell.recentM = _recentM;
            
            return headerCell;
        }
            break;

        default:{
            
            if(_recentM.likeNum.integerValue){
                _indexStart = 2;
                if (indexPath.row == 1) {
                LYFriendsLikeDetailTableViewCell *likeCell = [tableView dequeueReusableCellWithIdentifier:LYFriendsLikeDetailCellID forIndexPath:indexPath];
                likeCell.recentM = _recentM;
                return likeCell;
                }
            }
            
            FriendsCommentModel *commentModel = _dataArray[indexPath.row - _indexStart];
            LYFriendsCommentDetailTableViewCell *commentCell = [tableView dequeueReusableCellWithIdentifier:LYFriendsCommentDetailCellID forIndexPath:indexPath];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:{
            CGSize size = [_recentM.message boundingRectWithSize:CGSizeMake(260, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} context:nil].size;
            return 129 + size.height;
            }
            break;
            
        default:
            if (_recentM.commentNum.integerValue) {
                _indexStart = 2;
                if (indexPath.row == 1) {
                    return  _recentM.commentNum.integerValue <= 8 ? 42 : 82;
                }
            }
            NSLog(@"------>%ld",indexPath.row);
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
