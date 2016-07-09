//
//  BarGroupChatViewController.m
//  lieyu
//
//  Created by 狼族 on 16/7/7.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "BarGroupChatViewController.h"
#import "BarGroupChatAllPeopleViewController.h"
#import "LYMyFriendDetailViewController.h"
#import "LYYUHttpTool.h"

@interface BarGroupChatViewController ()<UIActionSheetDelegate>
{
    NSString *_userId_RM;
}
@end

@implementation BarGroupChatViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.edgesForExtendedLayout = UIRectEdgeAll;
}

- (void) viewWillDisappear:(BOOL)animated
{
    self.extendedLayoutIncludesOpaqueBars = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    UIButton *right = [UIButton buttonWithType:UIButtonTypeCustom];
    right.frame = CGRectMake(0, 0, 65, 50);
    [right addTarget:self action:@selector(checkAllPeople) forControlEvents:UIControlEventTouchUpInside];
    [right setTitle:@"老司机列表" forState:UIControlStateNormal];
    right.titleLabel.font = [UIFont systemFontOfSize:11];
    [right setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    UIBarButtonItem *rightBut = [[UIBarButtonItem alloc]initWithCustomView:right];
    self.navigationItem.rightBarButtonItem = rightBut;
}

-(void)checkAllPeople{
    BarGroupChatAllPeopleViewController *barGroupVC = [[BarGroupChatAllPeopleViewController alloc] init];
    barGroupVC.groupID = [NSString stringWithFormat:@"%@",self.targetId];
    [self.navigationController pushViewController:barGroupVC animated:YES];
    barGroupVC.navigationItem.leftBarButtonItem = [self getItem];
}

- (UIBarButtonItem *)getItem{
    UIButton *itemBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    itemBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    [itemBtn setImage:[UIImage imageNamed:@"backBtn"] forState:UIControlStateNormal];
    [itemBtn addTarget:self action:@selector(BaseGoBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:itemBtn];
    return item;
}

- (void)BaseGoBack{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) didTapCellPortrait:(NSString *)userId
{
    _userId_RM = userId;
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if ([app.userModel.imuserId isEqualToString:userId]) {
            return;
        } else {
            UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"从聊天室移除" otherButtonTitles:@"移出群组"@"查看", nil];
            [actionSheet showInView:self.view];
            return ;
        }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0://禁言
            [self removePersonFromChatRoom];
            break;
        case 1://从群组移出
            [self quitFromChatRoom];
            break;
        case 2://查看
            [self goToPersonWithType:1];
            break;
        default:
            break;
    }
}

- (void)goToPersonWithType:(int)type{
    LYMyFriendDetailViewController *myFriendVC = [[LYMyFriendDetailViewController alloc]init];
    myFriendVC.isChatroom = type;
    myFriendVC.imUserId = _userId_RM;
    [self resignFirstResponder];
    [self.navigationController pushViewController:myFriendVC animated:YES];
}

#pragma mark - 群组禁言
- (void)removePersonFromChatRoom{
    NSDictionary *paraDic = @{@"groupId":self.targetId,@"userId":_userId_RM,@"minute":@"43200"};
    [LYYUHttpTool yuAddLogInWith:paraDic complete:^(NSDictionary *dic) {
        NSLog(@"将%@禁言成功",_userId_RM);
    }];
}

#pragma mark - 群组踢人
- (void)quitFromChatRoom{
    NSDictionary *paraDic = @{@"groupId":self.targetId,@"userId":_userId_RM,@"minute":@"43200"};
    
    [LYYUHttpTool yuQuitGroupWith:paraDic complete:^(NSDictionary *str) {
        NSLog(@"将%@踢出群组成功",_userId_RM);
    }];
    
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
