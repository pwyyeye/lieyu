//
//  LYFindConversationViewController.m
//  lieyu
//
//  Created by 狼族 on 16/3/15.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYFindConversationViewController.h"
#import "LYMyFriendDetailViewController.h"
#import "LYYUHttpTool.h"

@interface LYFindConversationViewController ()<UIActionSheetDelegate>{
    NSString *_userId_RM;//点击的融云id
}
@end

@implementation LYFindConversationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)didTapCellPortrait:(NSString *)userId{
//    NSLog(@"------>%@",userId);
    
    if(self.conversationType == ConversationType_CHATROOM){
    _userId_RM = userId;
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSArray *managerUserIdArray = [app.userModel.manageUserids componentsSeparatedByString:@","];//管理员账号
    for (NSString *str in managerUserIdArray) {
        if(app.userModel.userid == str.intValue){//登录的是管理员
//            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"查看",@"移除聊天室", nil];
//            [alertView show];
            UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"从聊天室移除" otherButtonTitles:@"查看", nil];
            [actionSheet showInView:self.view];
            return ;
        }
    }
    [self goToPerson];
    }
}

#pragma mark - 跳转到用户个人界面
- (void)goToPerson{
    LYMyFriendDetailViewController *myFriendVC = [[LYMyFriendDetailViewController alloc]init];
    myFriendVC.imUserId = _userId_RM;
    [self resignFirstResponder];
    [self.navigationController pushViewController:myFriendVC animated:YES];

}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0://从聊天室移除
//            [MyUtil showMessage:@"从聊天室移除"];
                        [self removePersonFromChatRoom];
            break;
            
        case 1://查看
                        [self goToPerson];
            break;
            
        default:
            break;
    }
}



- (void)removePersonFromChatRoom{
//   121.40.229.133:80/portal/friendAction.do?action=expand&chatroomId=150&imuserId=130615&minute=1&SEM_LOGIN_TOKEN=g6hccy5yqo78xk3yarls7888
    
    NSDictionary *paraDic = @{@"chatroomId":self.targetId,@"imuserId":_userId_RM,@"minute":@"1"};
    [LYYUHttpTool yuRemoveUserFromeChatRoomWith:paraDic complete:^(BOOL result) {
        
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
