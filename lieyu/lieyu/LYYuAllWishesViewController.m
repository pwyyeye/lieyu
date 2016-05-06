//
//  LYYuAllWishesViewController.m
//  lieyu
//
//  Created by 王婷婷 on 16/4/22.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYYuAllWishesViewController.h"
#import "LYYUHttpTool.h"
#import "YUWishesModel.h"
#import "LYFriendsHttpTool.h"
#import "IQKeyboardManager.h"
#import "LYActivitySendViewController.h"
#import "LYFindConversationViewController.h"
#import "UMSocialData.h"
#import "UMSocialSnsService.h"
#import "UMSocial.h"

@interface LYYuAllWishesViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIAlertViewDelegate,LYActivitySendViewControllerDelegate>
{
    int start;
    int limit;
    
    int tag;
    int deleteSection;
    int _oldScrollOffectY;
    int unFinishedNumber;
    
    UILabel *kongLabel;
    
    UILabel *_myTitle;
    UIButton *_rightButton;
    UILabel *_pointLabel;
    
    BOOL start0;//测试
    
    UIVisualEffectView *effectView;
    UIButton *releaseButton;
    
    LYYuAllWishesViewController *detailViewController;
    
    //引导页
    UIView *grayBackground;
    UIImageView *tipImageview;
    UIButton *tryButton;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataList;
@end

@implementation LYYuAllWishesViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar addSubview:_myTitle];
    if (_type == 0) {
        [self.navigationController.navigationBar addSubview:_rightButton];
        if (detailViewController.isChanged == YES) {
            [self refreshData];
            detailViewController.isChanged = NO;
//            if (unFinishedNumber > 0) {
//                _pointLabel.hidden = NO;
//            }else{
//                _pointLabel.hidden = YES;
//            }
        }
    }
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    [self initReleaseWishButton];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    if(_type == 0){
        [_myTitle removeFromSuperview];
        [_rightButton removeFromSuperview];
//    }
    [effectView removeFromSuperview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataList = [[NSMutableArray alloc]init];
    limit = 10;
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    if (_type == 0) {
        self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 49, 0);
    }else if (_type == 1){
        [self.tableView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    }
    [self.view addSubview:self.tableView];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self registerCells];
    [self initRightButton];
    [self initTitle];
    [self initMJFooterAndHeader];
    
    //获取数据
    [self refreshData];
}

#pragma mark - 页面布局
- (void)initTitle{
    _myTitle= [[UILabel alloc] initWithFrame: CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    _myTitle.backgroundColor = [UIColor clearColor];
    _myTitle.textColor=[UIColor blackColor];
    _myTitle.textAlignment = NSTextAlignmentCenter;
    [_myTitle setFont:[UIFont systemFontOfSize:16]];
    if (_type == 0) {
        [_myTitle setText:@"大家想玩"];
    }else if (_type == 1){
        [_myTitle setText:@"我的发布"];
    }
}

#pragma mark - 右侧按钮－进入我的愿望页面
- (void)initRightButton{
    _rightButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 50, 0, 40, 44)];
    [_rightButton setTitle:@"我的" forState:UIControlStateNormal];
    [_rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_rightButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [_rightButton addTarget:self action:@selector(EnterMyWishes) forControlEvents:UIControlEventTouchUpInside];
    
    _pointLabel = [[UILabel alloc]initWithFrame:CGRectMake(35, 10, 6, 6)];
    _pointLabel.layer.cornerRadius = 3;
    _pointLabel.layer.masksToBounds = YES;
    [_pointLabel setBackgroundColor:[UIColor redColor]];
    [_rightButton addSubview:_pointLabel];
    _pointLabel.hidden = YES;
}

#pragma mark - 发送愿望按钮
- (void)initReleaseWishButton{
    //26-47
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    effectView = [[UIVisualEffectView alloc]initWithEffect:effect];
//    [effectView setFrame:CGRectMake(SCREEN_WIDTH / 2 - 30, SCREEN_HEIGHT - 60, 60, 60)];
   
    if (_type == 0) {
        [effectView setFrame:CGRectMake(SCREEN_WIDTH / 2 - 30, SCREEN_HEIGHT - 60, 60, 60)];
    }else if (_type == 1){
        [effectView setFrame:CGRectMake(SCREEN_WIDTH / 2 - 30, SCREEN_HEIGHT - 64, 60, 60)];
    }
    effectView.layer.cornerRadius = 30;
    effectView.layer.masksToBounds = YES;
    [self.view addSubview:effectView];
    [self.view bringSubviewToFront:effectView];
    
    releaseButton = [[UIButton alloc]initWithFrame:CGRectMake(17, 6, 26, 45)];
    [releaseButton setBackgroundImage:[UIImage imageNamed:@"YU_release"] forState:UIControlStateNormal];
    [releaseButton addTarget:self action:@selector(releaseClick) forControlEvents:UIControlEventTouchUpInside];
    [effectView addSubview:releaseButton];
    
    [UIView animateWithDuration:.4 animations:^{
        if (_type == 0) {
            effectView.frame = CGRectMake(SCREEN_WIDTH / 2 - 30, SCREEN_HEIGHT - 123, 60, 60);
        }else if (_type == 1){
            effectView.frame = CGRectMake(SCREEN_WIDTH / 2 - 30, SCREEN_HEIGHT - 147, 60, 60);
        }
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            if (_type == 0) {
                effectView.frame = CGRectMake(SCREEN_WIDTH / 2 - 30, SCREEN_HEIGHT - 120, 60, 60);
            }else if (_type == 1){
                effectView.frame = CGRectMake(SCREEN_WIDTH / 2 - 30, SCREEN_HEIGHT - 144, 60, 60);
            }
        }];
    }];
}

#pragma mark - scrollView代理方法，上拖消失，下拉出现
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    NSLog(@"scrollView.contentOffset.y:%f",scrollView.contentOffset.y);
    if (scrollView.contentOffset.y > _oldScrollOffectY) {
        if (scrollView.contentOffset.y <= 0.f) {
            if (_type == 0) {
                effectView.frame = CGRectMake(SCREEN_WIDTH / 2 - 30, SCREEN_HEIGHT - 120, 60, 60);
            }else if (_type == 1){
                effectView.frame = CGRectMake(SCREEN_WIDTH / 2 - 30, SCREEN_HEIGHT - 144, 60, 60);
            }
        }else{
            [UIView animateWithDuration:0.4 animations:^{
                effectView.frame = CGRectMake(SCREEN_WIDTH / 2 - 30, SCREEN_HEIGHT, 60, 60);
            }];
        }
    }else{
        if (CGRectGetMaxY(effectView.frame) > SCREEN_HEIGHT - 5) {
            [UIView animateWithDuration:.4 animations:^{
                if (_type == 0) {
                    effectView.frame = CGRectMake(SCREEN_WIDTH / 2 - 30, SCREEN_HEIGHT - 123, 60, 60);
                }else if (_type == 1){
                    effectView.frame = CGRectMake(SCREEN_WIDTH / 2 - 30, SCREEN_HEIGHT - 147, 60, 60);
                }
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.2 animations:^{
                    if (_type == 0) {
                        effectView.frame = CGRectMake((SCREEN_WIDTH - 60)/2.f, SCREEN_HEIGHT - 120, 60, 60);
                    }else if (_type == 1){
                        effectView.frame = CGRectMake((SCREEN_WIDTH - 60)/2.f, SCREEN_HEIGHT - 144, 60, 60);
                    }
                }];
            }];
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    _oldScrollOffectY = scrollView.contentOffset.y;
}

#pragma mark - 进入我的发布
- (void)EnterMyWishes{
    detailViewController = [[LYYuAllWishesViewController alloc]init];
    detailViewController.type = 1;
    detailViewController.delegate = self;
    [self.navigationController pushViewController:detailViewController animated:YES];
}

#pragma mark - registerCells
- (void)registerCells{
    [self.tableView registerNib:[UINib nibWithNibName:@"LYYuWishesListTableViewCell" bundle:nil] forCellReuseIdentifier:@"LYYuWishesListTableViewCell"];
}

#pragma mark - 关于数据获取与刷新
- (void)initMJFooterAndHeader{
    __weak __typeof(self)weakSelf = self;
    self.tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        [weakSelf refreshData];
    }];
    MJRefreshGifHeader *header = (MJRefreshGifHeader *)self.tableView.mj_header;
    [self initMJRefeshHeaderForGif:header];
    
    self.tableView.mj_footer = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
        [weakSelf getMoreData];
    }];
    MJRefreshBackGifFooter *footer = (MJRefreshBackGifFooter *)self.tableView.mj_footer;
    [self initMJRefeshFooterForGif:footer];
}

- (void)refreshData{
    [_dataList removeAllObjects];
//    if(start0 == NO){
//        start0 = YES;
//        start = 10 ;
//    }else{
//        start = 0 ;
//        start0 = NO;
//    }
    NSLog(@"--contentOffset:%@",NSStringFromCGPoint(self.tableView.contentOffset));
//    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
    start = 0 ;
    [self getData];
}

- (void)getMoreData{
    start = start + limit;
    [self getData];
}

- (void)getData{
    NSDictionary *dict = @{@"start":[NSNumber numberWithInt:start],
                           @"limit":[NSNumber numberWithInt:limit],
                           @"type":[NSNumber numberWithInt:_type + 1]};
    __weak __typeof(self)weakSelf = self;
    
    [LYYUHttpTool YUGetWishesListWithParams:dict complete:^(NSDictionary *result) {
        NSArray *dataArray = [result objectForKey:@"items"];
        unFinishedNumber = [[result objectForKey:@"results"]intValue];
        if (unFinishedNumber > 0) {
            _pointLabel.hidden = NO;
        }else{
            _pointLabel.hidden = YES;
        }
        [_dataList addObjectsFromArray:dataArray];
        if (_dataList.count == limit) {
            [UIView animateWithDuration:0.3 animations:^{
                [weakSelf.tableView setContentOffset:CGPointMake(0, -64)];
            }];
        }
        if (dataArray.count <= 0) {
            if (_dataList.count <= 0) {
                //显示空界面
//                [self initKongView];
                [weakSelf.tableView.mj_header endRefreshing];
            }else{
                //
//                [self hideKongView];
                if(start == 0){
                    [weakSelf.tableView.mj_header endRefreshing];
                }else{
                    [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            }
        }else{
//            [self hideKongView];
            [weakSelf.tableView.mj_footer endRefreshing];
            [weakSelf.tableView.mj_header endRefreshing];
        }
        if (_dataList.count <= 0) {
            [self initKongView];
        }else{
            [self hideKongView];
        }
        [weakSelf.tableView reloadData];
        if (![USER_DEFAULT objectForKey:@"UsersFirstEnterYU"]) {
            grayBackground = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            grayBackground.tag = 10010;
            [grayBackground setBackgroundColor:RGBA(0, 0, 0, 0.5)];
            [((AppDelegate *)[UIApplication sharedApplication].delegate).window addSubview:grayBackground];
            UIButton *clearButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 30 , SCREEN_HEIGHT - 110, 60, 60)];
            [grayBackground addSubview:clearButton];
            [clearButton addTarget:self action:@selector(releaseClick) forControlEvents:UIControlEventTouchUpInside];
            
            tipImageview = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 149, SCREEN_HEIGHT - 210, 298, 166)];
            [tipImageview setImage:[UIImage imageNamed:@"YU_tipImage"]];
            [grayBackground addSubview:tipImageview];
            
            tryButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 104, SCREEN_HEIGHT / 2 - 35, 208, 70)];
            [tryButton setBackgroundColor:[UIColor clearColor]];
            [tryButton setImage:[UIImage imageNamed:@"YU_tryButton"] forState:UIControlStateNormal];
            [tryButton addTarget:self action:@selector(releaseClick) forControlEvents:UIControlEventTouchUpInside];
            [grayBackground addSubview:tryButton];
            
        }
    }];
}

#pragma mark - 空界面
- (void)initKongView{
    if(!kongLabel){
        kongLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT / 2 - 50, SCREEN_WIDTH, 20)];
        [kongLabel setBackgroundColor:[UIColor clearColor]];
        [kongLabel setTextColor:RGBA(186, 40, 227, 1)];
        [kongLabel setText:@"还未发布任何愿望哦～"];
        [kongLabel setTextAlignment:NSTextAlignmentCenter];
        [kongLabel setFont:[UIFont systemFontOfSize:14]];
    }
    [self.view addSubview:kongLabel];
}

- (void)hideKongView{
    [kongLabel removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableview的代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;  
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LYYuWishesListTableViewCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"LYYuWishesListTableViewCell" owner:nil options:nil]firstObject];
    cell.delegate = self;
    if (_dataList.count > indexPath.section) {
        cell.model = (YUWishesModel *)[_dataList objectAtIndex:indexPath.section];
    }
    cell.avatarButton.tag = indexPath.section;
    [cell.avatarButton addTarget:self action:@selector(avatarClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.reportButton.tag = indexPath.section;
    [cell.reportButton addTarget:self action:@selector(reportWishes:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_type == 1) {
        return YES;
    }else{
        return NO;
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        deleteSection = (int)indexPath.section;
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"确认删除？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil]show];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_dataList.count > indexPath.section) {
        YUWishesModel *model = (YUWishesModel *)[_dataList objectAtIndex:indexPath.section];
        CGRect rectContent = [model.desc boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 62, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
        CGRect rectReply;
        if (model.replyContent.length > 0) {
            rectReply = [model.replyContent boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
        }else{
            rectReply = CGRectMake(0, 0, 0, -20);
        }
        return 221 + rectReply.size.height + rectContent.size.height;
    }else{
        return 0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YUWishesModel *model = [_dataList objectAtIndex:indexPath.section];
    if (model.releaseUserid == self.userModel.userid) {
        [self communicateWithKEFU];
    }else{
        [self communicateWithFriend:model];
    }
}

#pragma mark - 重写返回方法
- (void)BaseGoBack{
    [self.navigationController popViewControllerAnimated:YES];
    _type = 0 ;
}

#pragma mark - 发布
- (void)releaseClick{
    if ([((AppDelegate *)[UIApplication sharedApplication].delegate).window viewWithTag:10010]) {
        [grayBackground removeFromSuperview];
        
        [USER_DEFAULT setObject:@"NO" forKey:@"UsersFirstEnterYU"];
    }
    LYActivitySendViewController *activitySendVC = [[LYActivitySendViewController alloc]init];
    activitySendVC.delegate = self;
    [self.navigationController pushViewController:activitySendVC animated:YES];
}

#pragma mark - 举报
- (void)reportWishes:(UIButton *)button{
    tag = (int)button.tag;
    UIActionSheet *reportAction = [[UIActionSheet alloc]initWithTitle:@"选择举报原因" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"污秽色情",@"垃圾广告",@"其他原因", nil];
    [reportAction showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *message;
    if (buttonIndex == 0) {
        message = @"污秽色情";
    }else if (buttonIndex == 1){
        message = @"垃圾广告";
    }else if (buttonIndex == 2){
        message = @"其他原因";
    }
    if (buttonIndex != 3) {
        [LYYUHttpTool YUReportWishComplete:^(BOOL result) {
            if (result == YES) {
                [MyUtil showPlaceMessage:@"举报成功"];
            }else{
                [MyUtil showPlaceMessage:@"举报失败"];
            }
        }];
//        YUWishesModel *model = (YUWishesModel *)[_dataList objectAtIndex:tag];
//        NSDictionary *dict = @{@"reportedUserid":[NSNumber numberWithInt:model.releaseUserid],
//                               @"momentId":[NSNumber numberWithInt:model.id],
//                               @"message":message,
//                               @"userid":[NSNumber numberWithInt:self.userModel.userid]};
//        [LYFriendsHttpTool friendsJuBaoWithParams:dict complete:^(NSString *message) {
//            [MyUtil showPlaceMessage:message];
//        }];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
//        NSLog(@"取消");
        [self.tableView reloadData];
    }else if(buttonIndex == 1){
//        NSLog(@"删除");
        YUWishesModel *model = (YUWishesModel *)[_dataList objectAtIndex:deleteSection];
        NSDictionary *dict = @{@"id":[NSNumber numberWithInt:model.id]};
        [LYYUHttpTool YUDeleteWishWithParams:dict complete:^(BOOL result) {
            if (result == YES) {
//                [MyUtil showPlaceMessage:@"删除成功！"];
                [_dataList removeObjectAtIndex:deleteSection];
                self.isChanged = YES;
//                self.delegate
                
                [_tableView reloadData];
                if(_dataList.count <= 0){
                    [self initKongView];
                }
            }else{
//                [MyUtil showPlaceMessage:@"删除失败"];
            }
        }];
    }
}

#pragma mark - 代理方法
- (void)deleteUnFinishedNumber{
    if (_type == 0) {
        unFinishedNumber -- ;
        if (unFinishedNumber > 0) {
            _pointLabel.hidden = NO;
        }else{
            _pointLabel.hidden = YES;
        }
    }else if (_type == 1){
        _isChanged = YES;
        [self.delegate deleteUnFinishedNumber];
    }
}

- (void)delegateShareWish:(YUWishesModel *)model{
//    NSLog(@"model:---%@",model);
    NSString *content = [NSString stringWithFormat:@"Q:%@\nA:%@\nhttp://a.app.qq.com/o/simple.jsp?pkgname=com.zq.xixili&g_f=991653",model.desc,model.replyContent];
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = @"http://a.app.qq.com/o/simple.jsp?pkgname=com.zq.xixili&g_f=991653";
    [UMSocialData defaultData].extConfig.wechatSessionData.url = @"http://a.app.qq.com/o/simple.jsp?pkgname=com.zq.xixili&g_f=991653";
    [UMSocialSnsService presentSnsIconSheetView:self appKey:UmengAppkey shareText:content shareImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.userModel.avatar_img]]] shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina,UMShareToSms,nil] delegate:nil];
}

- (void)communicateWithKEFU{
    RCPublicServiceChatViewController *conversationVC = [[RCPublicServiceChatViewController alloc]init];
    conversationVC.conversationType = ConversationType_APPSERVICE;
    conversationVC.targetId = @"KEFU144946169476221";
    conversationVC.title = @"猎娱客服";
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].isAdd = YES;
    [USER_DEFAULT setObject:@"0" forKey:@"needCountIM"];
    
    // 把单聊视图控制器添加到导航栈。
    UIButton *itemBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    itemBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    [itemBtn setImage:[UIImage imageNamed:@"backBtn"] forState:UIControlStateNormal];
    [itemBtn addTarget:self action:@selector(backForward) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:itemBtn];
    conversationVC.navigationItem.leftBarButtonItem = item;
    
    [self.navigationController pushViewController:conversationVC animated:YES];
}

- (void)communicateWithFriend:(YUWishesModel *)model{
    LYFindConversationViewController *conversationVC = [[LYFindConversationViewController alloc]init];
    //    RCConversationViewController *conversationVC = [[RCConversationViewController alloc]init];
    conversationVC.conversationType =ConversationType_PRIVATE; //会话类型，这里设置为 PRIVATE 即发起单聊会话。
    conversationVC.targetId = model.imUserId; // 接收者的 targetId，这里为举例。
    conversationVC.title = model.releaseUserName; // 会话的 title。
    
    [USER_DEFAULT setObject:@"0" forKey:@"needCountIM"];
    
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].isAdd = YES;
    // 把单聊视图控制器添加到导航栈。
    UIButton *itemBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    itemBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    [itemBtn setImage:[UIImage imageNamed:@"backBtn"] forState:UIControlStateNormal];
    [itemBtn addTarget:self action:@selector(backForward) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:itemBtn];
    conversationVC.navigationItem.leftBarButtonItem = item;
    
    [self.navigationController pushViewController:conversationVC animated:YES];
}

- (void)avatarClick:(UIButton *)button{
    YUWishesModel *model = [_dataList objectAtIndex:button.tag];
    if (model.releaseUserid == self.userModel.userid) {
        [self communicateWithKEFU];
    }else{
        [self communicateWithFriend:model];
    }
    
}

- (void)backForward{
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].isAdd = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 发送过后代理
- (void)activitySendViewControllerSendFinish{
    if (_type == 0) {
        [self refreshData];
    }else if (_type == 1){
        [self refreshData];
        _isChanged = YES;
    }
}

@end
