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
    BOOL _isGroupManage;
}


@end

@implementation BarGroupChatViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
//    [self.navigationController.navigationBar setTranslucent:NO];
//    self.extendedLayoutIncludesOpaqueBars = NO;
    
}

- (void)viewWillDisappear:(BOOL)animated
{
//    self.extendedLayoutIncludesOpaqueBars = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.subviews[0].frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT);
    //判断是否老司机
    for (NSString *userId in _groupManage) {
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if (app.userModel.userid == userId.integerValue) {
            _isGroupManage = YES;
        } else {
            _isGroupManage = NO;
        }
    }
    
    UIButton *right = [UIButton buttonWithType:UIButtonTypeCustom];
    right.frame = CGRectMake(0, 0, 85, 50);
    [right addTarget:self action:@selector(checkAllPeople) forControlEvents:UIControlEventTouchUpInside];
    [right setTitle:@"老司机列表" forState:UIControlStateNormal];
    right.titleLabel.font = [UIFont systemFontOfSize:13];
    [right setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    UIBarButtonItem *rightBut = [[UIBarButtonItem alloc]initWithCustomView:right];
    self.navigationItem.rightBarButtonItem = rightBut;
}

-(void)checkAllPeople{
    BarGroupChatAllPeopleViewController *barGroupVC = [[BarGroupChatAllPeopleViewController alloc] init];
    barGroupVC.groupID = [NSString stringWithFormat:@"%@",self.targetId];
    barGroupVC.isGroupM = _isGroupManage;
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
    if ([app.userModel.imuserId isEqualToString:userId]) {//是自己直接返回
        return;
    } else {
        if (!_isGroupManage) {//普通用户
            [self goToPersonWithType:1];
            return;
        } else {
            UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"查看" otherButtonTitles:@"禁言一个月", nil];
            [actionSheet showInView:self.view];
            return ;
        }
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0://查看
            [self goToPersonWithType:1];
            break;
        case 1://禁言
            if (_isGroupManage) {
                [self removePersonFromChatRoom];
            }
            break;
        default:
            break;
    }
}

#pragma mark --- 查看
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
    __block BarGroupChatViewController *weekSelf = self;
    [LYYUHttpTool yuAddLogInWith:paraDic complete:^(NSDictionary *dic) {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"禁言成功！" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *alertSure = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:nil];
        [alertVC addAction:alertSure];
        [weekSelf presentViewController:alertVC animated:YES completion:nil];
    }];
}

#pragma mark - 群组踢人（已废弃）
- (void)quitFromChatRoom{
    NSDictionary *paraDic = @{@"groupId":self.targetId,@"userId":_userId_RM};
    
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
