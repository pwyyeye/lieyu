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
//#import "RCDChatViewController.h"
@interface LYRecentContactViewController ()

@end

@implementation LYRecentContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE)]];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    //设置tableView样式
    self.conversationListTableView.separatorColor = RGB(223, 223, 223);
    self.conversationListTableView.tableFooterView = [UIView new];
    // Do any additional setup after loading the view.
}

-(void)onSelectedTableRow:(RCConversationModelType)conversationModelType conversationModel:(RCConversationModel *)model atIndexPath:(NSIndexPath *)indexPath
{
    RCConversationViewController *conversationVC = [[RCConversationViewController alloc]init];
    conversationVC.conversationType =model.conversationType;
    conversationVC.targetId = model.targetId;
    conversationVC.userName =model.conversationTitle;
    conversationVC.title = model.conversationTitle;
    [self.navigationController pushViewController:conversationVC animated:YES];
    
    [IQKeyboardManager sharedManager].enable = NO;
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"leftBackItem"] style:UIBarButtonItemStylePlain target:self action:@selector(backForward)];
    conversationVC.navigationItem.leftBarButtonItem = left;
    
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

- (void)backForward{
    [self.navigationController popViewControllerAnimated:YES];
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
    [[NSNotificationCenter defaultCenter] postNotificationName:RECEIVES_MESSAGE object:nil];
}

#pragma mark override
/**
 *  重写方法，通知更新未读消息数目，用于显示未读消息，当收到会话消息的时候，会触发一次。
 */
- (void)notifyUpdateUnreadMessageCount{
    [[NSNotificationCenter defaultCenter] postNotificationName:RECEIVES_MESSAGE object:nil];
    

}


@end
