//
//  LYRecentContactViewController.m
//  lieyu
//
//  Created by 薛斯岐 on 15/11/3.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYRecentContactViewController.h"
#import "IQKeyboardManager.h"
#import <RongIMKit/RongIMKit.h>
#import "LYFindConversationViewController.h"

//#import "RCDChatViewController.h"
@interface LYRecentContactViewController ()

@end

@implementation LYRecentContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE)]];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = YES;
    [self setupView];
    //设置tableView样式
    self.conversationListTableView.separatorColor = RGB(223, 223, 223);
    self.conversationListTableView.tableFooterView = [UIView new];
    
    _unreadMessageCount=0;
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
 
    // Do any additional setup after loading the view.
}
- (void)setupView{
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"backBtn"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backClick)];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)backClick{
    [USER_DEFAULT setObject:@"1" forKey:@"needCountIM"];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)back{
    [USER_DEFAULT setObject:@"1" forKey:@"needCountIM"];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //统计错误情况下 需要特殊处理
    if (_unreadMessageCount==0) {
        [USER_DEFAULT removeObjectForKey:@"badgeValue"];
        [[NSNotificationCenter defaultCenter] postNotificationName:COMPLETE_MESSAGE object:nil];
    }
}
-(void)onSelectedTableRow:(RCConversationModelType)conversationModelType conversationModel:(RCConversationModel *)model atIndexPath:(NSIndexPath *)indexPath
{
    LYFindConversationViewController *conversationVC = [[LYFindConversationViewController alloc]init];
    conversationVC.conversationType =model.conversationType;
    conversationVC.targetId = model.targetId;
//    conversationVC.userName =model.conversationTitle;
    conversationVC.title = model.conversationTitle;
    
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].isAdd = YES;
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(-10, 0, 44, 44)];
    [button setImage:[UIImage imageNamed:@"backBtn"] forState:UIControlStateNormal];
    [view addSubview:button];
    [button addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:view];
    conversationVC.navigationItem.leftBarButtonItem = item;
    
    [self.navigationController pushViewController:conversationVC animated:YES];
    
    //设置不需要统计角标
    [USER_DEFAULT setObject:@"0" forKey:@"needCountIM"];
    NSInteger unread= model.unreadMessageCount;
    if (unread) {
        [USER_DEFAULT setObject:[NSString stringWithFormat:@"%d",(int)unread] forKey:@"delBadgeValue"];
        [[NSNotificationCenter defaultCenter] postNotificationName:COMPLETE_MESSAGE object:nil];
    }
    
//    if (model.conversationModelType == RC_CONVERSATION_MODEL_TYPE_PUBLIC_SERVICE) {
//        RCPublicServiceChatViewController *_conversationVC = [[RCPublicServiceChatViewController alloc] init];
//        _conversationVC.conversationType = model.conversationType;
//        _conversationVC.targetId = model.targetId;
//        _conversationVC.userName = model.conversationTitle;
//        _conversationVC.title = model.conversationTitle;
//        
//        [self.navigationController pushViewController:_conversationVC animated:YES];
//    }
//    
//    if (conversationModelType == RC_CONVERSATION_MODEL_TYPE_NORMAL) {
//        RCDChatViewController *_conversationVC = [[RCDChatViewController alloc]init];
//        _conversationVC.conversationType = model.conversationType;
//        _conversationVC.targetId = model.targetId;
//        _conversationVC.userName = model.conversationTitle;
//        _conversationVC.title = model.conversationTitle;
//        _conversationVC.conversation = model;
//        _conversationVC.unReadMessage = model.unreadMessageCount;
//        _conversationVC.enableNewComingMessageIcon=YES;//开启消息提醒
//        _conversationVC.enableUnreadMessageIcon=YES;
//        [self.navigationController pushViewController:_conversationVC animated:YES];
//    }
//    
//    //聚合会话类型，此处自定设置。
//    if (conversationModelType == RC_CONVERSATION_MODEL_TYPE_COLLECTION) {
//        
//        RCDChatListViewController *temp = [[RCDChatListViewController alloc] init];
//        NSArray *array = [NSArray arrayWithObject:[NSNumber numberWithInt:model.conversationType]];
//        [temp setDisplayConversationTypes:array];
//        [temp setCollectionConversationType:nil];
//        temp.isEnteredToCollectionViewController = YES;
//        [self.navigationController pushViewController:temp animated:YES];
//    }
    
   
    
}

- (void)willDisplayConversationTableCell:(RCConversationBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    if (cell.model.unreadMessageCount>0) {
        _unreadMessageCount+=cell.model.unreadMessageCount;
    }

}

- (void)backForward{
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].isAdd = NO;
    [self.navigationController popViewControllerAnimated:YES];
    //设置需要统计角标
    [USER_DEFAULT setObject:@"1" forKey:@"needCountIM"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/**
 *  收到新消息,用于刷新会话列表，如果派生类调用了父类方法，请不要再次调用refreshConversationTableViewIfNeeded，避免多次刷新
 *  当收到多条消息时，会在最后一条消息时在内部调用refreshConversationTableViewIfNeeded
 *
 *  @param notification notification
 */
- (void)didReceiveMessageNotification:(NSNotification *)notification{
    
    NSLog(@"----pass-pass%@---",notification);
//    [[NSNotificationCenter defaultCenter] postNotificationName:RECEIVES_MESSAGE object:nil];
}

#pragma mark override
/**
 *  重写方法，通知更新未读消息数目，用于显示未读消息，当收到会话消息的时候，会触发一次。
 */
- (void)notifyUpdateUnreadMessageCount{
//    [[NSNotificationCenter defaultCenter] postNotificationName:RECEIVES_MESSAGE object:nil];
    

}


@end
