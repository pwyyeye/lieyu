//
//  BarGroupChatAllPeopleViewController.m
//  lieyu
//
//  Created by 狼族 on 16/7/7.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "BarGroupChatAllPeopleViewController.h"
#import "GroupLeaderInfoViewController.h"
#import "LYGroupPeopleTableViewCell.h"
#import "LYFindConversationViewController.h"
#import "LYBlackListGroupViewController.h"
#import "LYMyFriendDetailViewController.h"
#import "LYYUHttpTool.h"

@interface BarGroupChatAllPeopleViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UIView *_noticeView;//角标
//    NSMutableArray *_dataArray;//玩家数组
    NSMutableArray *_manngerDataArray;//管理员数组
    NSIndexPath *_indexPath;
}

@property (strong, nonatomic) NSMutableArray *dataArray;//玩家数组
@property (strong, nonatomic) NSMutableArray *manngerDataArray;//管理员数组

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation BarGroupChatAllPeopleViewController

-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray new];
    }
    return _dataArray;
}

-(NSMutableArray *)manngerDataArray
{
    if (!_manngerDataArray) {
        self.manngerDataArray = [NSMutableArray new];
    }
    return _manngerDataArray;
}
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [_myTableView registerNib:[UINib nibWithNibName:@"LYGroupPeopleTableViewCell" bundle:nil] forCellReuseIdentifier:@"LYGroupPeopleTableViewCell"];
    self.title = @"老司机列表";
    _myTableView.dataSource = self;
    _myTableView.delegate = self;
//    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    [self getData];
}

#pragma mark - 获取群组成员
- (void)getData{
    NSDictionary *dic = @{@"groupId":_groupID};
    __block BarGroupChatAllPeopleViewController *weekSelf = self;
    [LYYUHttpTool yuGetGroupListWith:dic complete:^(NSArray *Arr) {
        for (UserModel *model in Arr) {
            if (model.isGrpupManage) {//是管理员
                [weekSelf.manngerDataArray addObject:model];
            } else {//不是管理员
                [weekSelf.dataArray addObject:model];
            }
        }
       dispatch_async(dispatch_get_main_queue(), ^{
           [_myTableView reloadData];
           _myTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
           AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
           
                   if (!_isGroupM) {
                       NSLog(@"%d",app.userModel.userid);
                       //申请机长
                       UIButton *recentBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 64, 20)];
                       [recentBtn setTitle:@"申请机长" forState:UIControlStateNormal];
                       [recentBtn addTarget:self action:@selector(recentConnect) forControlEvents:UIControlEventTouchUpInside];
                       [recentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                       recentBtn.titleLabel.font = [UIFont systemFontOfSize:13];
                       UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:recentBtn];;
                       self.navigationItem.rightBarButtonItem = rightItem;
                   } else {
                       //查看黑名单列表
                       UIButton *recentBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 84, 20)];
                       [recentBtn setTitle:@"禁言黑名单" forState:UIControlStateNormal];
                       [recentBtn addTarget:self action:@selector(checkBlockList) forControlEvents:UIControlEventTouchUpInside];
                       [recentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                       recentBtn.titleLabel.font = [UIFont systemFontOfSize:13];
                       UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:recentBtn];;
                       self.navigationItem.rightBarButtonItem = rightItem;
                       
                   }
       });
    }];
}


-(void)dealloc{

}

-(void)checkBlockList {
    LYBlackListGroupViewController *blockListVC  = [[LYBlackListGroupViewController alloc] init];
    blockListVC.groupID = _groupID;
    blockListVC.title = @"黑名单";
    [self.navigationController pushViewController:blockListVC animated:YES];
}

#pragma mark - 申请机长
- (void)recentConnect{
    GroupLeaderInfoViewController * leader=[[GroupLeaderInfoViewController alloc]init];
    leader.title=@"申请机长";
    leader.groupId = _groupID;
    [self.navigationController pushViewController:leader animated:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section == 0? _manngerDataArray.count:_dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LYGroupPeopleTableViewCell *cell = [_myTableView dequeueReusableCellWithIdentifier:@"LYGroupPeopleTableViewCell" forIndexPath:indexPath];
    UserModel *userM = [[UserModel alloc] init];
    if (!indexPath.section) {//第一个分区，管理员
        userM = _manngerDataArray[indexPath.row];
    } else {//第二个分区，玩友
        userM = _dataArray[indexPath.row];
    }
    [cell.chatButton addTarget:self action:@selector(chatParvite:) forControlEvents:(UIControlEventTouchUpInside)];
    [cell.iconImag addTarget:self action:@selector(personDetail:) forControlEvents:(UIControlEventTouchUpInside)];
//    cell.chatButton.tag = indexPath.row;
    cell.usermodel = userM;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (app.userModel.userid == userM.userid) {
        cell.chatButton.hidden = YES;
    }
    
    return cell;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    UserModel *userM = [[UserModel alloc] init];
//    if (indexPath.section == 0) {
//        userM = _manngerDataArray[indexPath.row];
//    } else {
//        userM = _dataArray[indexPath.row];
//    }
//    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    if (app.userModel.userid != userM.userid) {
//        LYFindConversationViewController *conversationVC = [[LYFindConversationViewController alloc]init];
//        conversationVC.targetId = userM.imuserId;
//        conversationVC.conversationType = ConversationType_PRIVATE;
//        conversationVC.title = userM.usernick;
//        [self.navigationController pushViewController:conversationVC animated:YES];
//        
//        conversationVC.navigationItem.leftBarButtonItem = [self getItem];
//    }
//}

-(void)personDetail: (UIButton *)sender{
    LYGroupPeopleTableViewCell *cell=[(LYGroupPeopleTableViewCell *)[sender superview] superview];
    NSIndexPath *index=[_myTableView indexPathForCell:cell];
    UserModel *userM = [[UserModel alloc] init];
    if (!index.section) {//管理员
        userM = _manngerDataArray[index.row];
    } else {
        userM = _dataArray[index.row];
    }
    LYMyFriendDetailViewController *friendDetailViewController=[[LYMyFriendDetailViewController alloc]initWithNibName:@"LYMyFriendDetailViewController" bundle:nil];
//    LYMyFriendDetailViewController *friendDetailViewController = [[LYMyFriendDetailViewController alloc] init];
    //    friendDetailViewController.title=@"详细信息";
    friendDetailViewController.type=@"4";
    //    [friendDetailViewController.navigationController setNavigationBarHidden:NO animated:YES];
    //    friendDetailViewController.customerModel=addressBook;
    friendDetailViewController.userID = [NSString stringWithFormat:@"%d",userM.userid];
    [self.navigationController pushViewController:friendDetailViewController animated:YES];
//    friendDetailViewController.navigationItem.leftBarButtonItem = [self getItem];

}

-(void)chatParvite: (UIButton *)sender{
    LYGroupPeopleTableViewCell *cell=[(LYGroupPeopleTableViewCell *)[sender superview] superview];
    NSIndexPath *index=[_myTableView indexPathForCell:cell];
    UserModel *userM = [[UserModel alloc] init];
    if (!index.section) {//管理员
        userM = _manngerDataArray[index.row];
    } else {
        userM = _dataArray[index.row];
    }
    LYFindConversationViewController *conversationVC = [[LYFindConversationViewController alloc]init];
    conversationVC.targetId = userM.imuserId;
    conversationVC.conversationType = ConversationType_PRIVATE;
    conversationVC.title = userM.usernick;
    [self.navigationController pushViewController:conversationVC animated:YES];
    
    conversationVC.navigationItem.leftBarButtonItem = [self getItem];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

- (UIBarButtonItem *)getItem{
    UIButton *itemBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    itemBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    [itemBtn setImage:[UIImage imageNamed:@"backBtn"] forState:UIControlStateNormal];
    [itemBtn addTarget:self action:@selector(BaseGoBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:itemBtn];
    return item;
}
-(void)BaseGoBack
{
    [self.navigationController popViewControllerAnimated:YES];
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
