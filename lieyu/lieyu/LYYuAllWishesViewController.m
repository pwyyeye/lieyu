//
//  LYYuAllWishesViewController.m
//  lieyu
//
//  Created by 王婷婷 on 16/4/22.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYYuAllWishesViewController.h"
#import "LYYuWishesListTableViewCell.h"
#import "LYYUHttpTool.h"
#import "YUWishesModel.h"
#import "LYFriendsHttpTool.h"
#import "IQKeyboardManager.h"

@interface LYYuAllWishesViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIAlertViewDelegate,LYYuWishesCellDelegate>
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
    [releaseButton removeFromSuperview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataList = [[NSMutableArray alloc]init];
    limit = 2;
    
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
}

- (void)initReleaseWishButton{
    if (_type == 0) {
        releaseButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 30, SCREEN_HEIGHT - 60, 60, 60)];
    }else if (_type == 1){
        releaseButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 30, SCREEN_HEIGHT - 64, 60, 60)];
    }
    [releaseButton addTarget:self action:@selector(releaseClick) forControlEvents:UIControlEventTouchUpInside];
    [releaseButton setBackgroundImage:[UIImage imageNamed:@"YU_release"] forState:UIControlStateNormal];
    [self.view addSubview:releaseButton];
    
    [UIView animateWithDuration:.4 animations:^{
        if (_type == 0) {
            releaseButton.frame = CGRectMake(SCREEN_WIDTH / 2 - 30, SCREEN_HEIGHT - 123, 60, 60);
        }else if (_type == 1){
            releaseButton.frame = CGRectMake(SCREEN_WIDTH / 2 - 30, SCREEN_HEIGHT - 147, 60, 60);
        }
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            if (_type == 0) {
                releaseButton.frame = CGRectMake(SCREEN_WIDTH / 2 - 30, SCREEN_HEIGHT - 120, 60, 60);
            }else if (_type == 1){
                releaseButton.frame = CGRectMake(SCREEN_WIDTH / 2 - 30, SCREEN_HEIGHT - 144, 60, 60);
            }
        }];
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y > _oldScrollOffectY) {
        if (scrollView.contentOffset.y <= 0.f) {
            if (_type == 0) {
                releaseButton.frame = CGRectMake(SCREEN_WIDTH / 2 - 30, SCREEN_HEIGHT - 120, 60, 60);
            }else if (_type == 1){
                releaseButton.frame = CGRectMake(SCREEN_WIDTH / 2 - 30, SCREEN_HEIGHT - 144, 60, 60);
            }
        }else{
            [UIView animateWithDuration:0.4 animations:^{
                releaseButton.frame = CGRectMake(SCREEN_WIDTH / 2 - 30, SCREEN_HEIGHT, 60, 60);
            }];
        }
    }else{
        if (CGRectGetMaxY(releaseButton.frame) > SCREEN_HEIGHT - 5) {
            [UIView animateWithDuration:.4 animations:^{
                if (_type == 0) {
                    releaseButton.frame = CGRectMake(SCREEN_WIDTH / 2 - 30, SCREEN_HEIGHT - 123, 60, 60);
                }else if (_type == 1){
                    releaseButton.frame = CGRectMake(SCREEN_WIDTH / 2 - 30, SCREEN_HEIGHT - 147, 60, 60);
                }
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.2 animations:^{
                    if (_type == 0) {
                        releaseButton.frame = CGRectMake((SCREEN_WIDTH - 60)/2.f, SCREEN_HEIGHT - 120, 60, 60);
                    }else if (_type == 1){
                        releaseButton.frame = CGRectMake((SCREEN_WIDTH - 60)/2.f, SCREEN_HEIGHT - 144, 60, 60);
                    }
                }];
            }];
        }
    }
    //scrollView.contentOffset.y 下拉变大，上拉变小
//    NSLog(@"%f",scrollView.contentOffset.y);
//    int newScrollOffsetY = scrollView.contentOffset.y;
//    if (newScrollOffsetY > _oldScrollOffectY) {
//        [UIView animateWithDuration:0.4 animations:^{
//            releaseButton.frame = CGRectMake(SCREEN_WIDTH / 2 - 30, SCREEN_HEIGHT, 60, 60);
//        }];
//    }else{
//        [UIView animateWithDuration:0.4 animations:^{
//            releaseButton.frame = CGRectMake(SCREEN_WIDTH / 2 - 30, SCREEN_HEIGHT - 123, 60, 60);
//        } completion:^(BOOL finished) {
//            [UIView animateWithDuration:0.2 animations:^{
//                releaseButton.frame = CGRectMake(SCREEN_WIDTH / 2 - 30, SCREEN_HEIGHT - 120, 60, 60);
//            }];
//        }];
//    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    _oldScrollOffectY = scrollView.contentOffset.y;
}

#pragma mark - 进入我的发布
- (void)EnterMyWishes{
    LYYuAllWishesViewController *detailViewController = [[LYYuAllWishesViewController alloc]init];
    detailViewController.type = 1;
    [self.navigationController pushViewController:detailViewController animated:YES];
}

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
//        for (YUWishesModel *model in dataArray) {
//            if ([model.isfinished isEqualToString:@"0"] && model.releaseUserid == self.userModel.userid) {
//                unFinishedNumber ++;
//            }
//        }
//        if (unFinishedNumber > 0) {
//            _pointLabel.hidden = NO;
//        }else{
//            _pointLabel.hidden = YES;
//        }
        [_dataList addObjectsFromArray:dataArray];
        if (dataArray.count <= 0) {
            if (_dataList.count <= 0) {
                //显示空界面
                [self initKongView];
                [weakSelf.tableView.mj_header endRefreshing];
            }else{
                //
                [self hideKongView];
                if(start == 0){
                    [weakSelf.tableView.mj_header endRefreshing];
                }else{
                    [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            }
        }else{
            [self hideKongView];
            [weakSelf.tableView.mj_footer endRefreshing];
            [weakSelf.tableView.mj_header endRefreshing];
        }
        [weakSelf.tableView reloadData];
    }];
}

- (void)initKongView{
    kongLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT / 2 - 10, SCREEN_WIDTH, 20)];
    [kongLabel setBackgroundColor:[UIColor clearColor]];
    [kongLabel setTextColor:RGBA(186, 40, 227, 1)];
    [kongLabel setText:@"还未发布任何愿望哦～"];
    [kongLabel setTextAlignment:NSTextAlignmentCenter];
    [kongLabel setFont:[UIFont systemFontOfSize:14]];
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
    cell.model = (YUWishesModel *)[_dataList objectAtIndex:indexPath.section];
    cell.avatarButton.tag = indexPath.section;
    [cell.avatarButton addTarget:self action:@selector(avatarClick) forControlEvents:UIControlEventTouchUpInside];
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
    YUWishesModel *model = (YUWishesModel *)[_dataList objectAtIndex:indexPath.section];
    CGRect rectContent = [model.desc boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 62, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
    CGRect rectReply;
    if (model.replyContent.length > 0) {
        rectReply = [model.replyContent boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
    }else{
        rectReply = CGRectMake(0, 0, 0, -10);
    }
    return 211 + rectReply.size.height + rectContent.size.height;
}

#pragma mark - 重写返回方法
- (void)BaseGoBack{
    [self.navigationController popViewControllerAnimated:YES];
    _type = 0 ;
}

#pragma mark - 发布
- (void)releaseClick{
    
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
        YUWishesModel *model = (YUWishesModel *)[_dataList objectAtIndex:tag];
        NSDictionary *dict = @{@"reportedUserid":[NSNumber numberWithInt:model.releaseUserid],
                               @"momentId":[NSNumber numberWithInt:model.id],
                               @"message":message,
                               @"userid":[NSNumber numberWithInt:self.userModel.userid]};
        [LYFriendsHttpTool friendsJuBaoWithParams:dict complete:^(NSString *message) {
            [MyUtil showPlaceMessage:message];
        }];
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
                [_tableView reloadData];
            }else{
//                [MyUtil showPlaceMessage:@"删除失败"];
            }
        }];
    }
}

- (void)deleteUnFinishedNumber{
    unFinishedNumber -- ;
    if (unFinishedNumber > 0) {
        _pointLabel.hidden = NO;
    }else{
        _pointLabel.hidden = YES;
    }
}

- (void)avatarClick:(UIButton *)button{
    YUWishesModel *model = [_dataList objectAtIndex:button.tag];
    RCConversationViewController *conversationVC = [[RCConversationViewController alloc]init];
    conversationVC.conversationType =ConversationType_PRIVATE; //会话类型，这里设置为 PRIVATE 即发起单聊会话。
    conversationVC.targetId = [NSString stringWithFormat:@"%d",model.releaseUserid]; // 接收者的 targetId，这里为举例。
    conversationVC.title = model.releaseUserName; // 会话的 title。
    
    [USER_DEFAULT setObject:@"0" forKey:@"needCountIM"];
    
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].isAdd = YES;
    // 把单聊视图控制器添加到导航栈。
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"return"] style:UIBarButtonItemStylePlain target:self action:@selector(backForward)];
    conversationVC.navigationItem.leftBarButtonItem = left;
    [self.navigationController pushViewController:conversationVC animated:YES];
}

- (void)backForward{
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].isAdd = NO;
    [self.navigationController popViewControllerAnimated:YES];
}


@end
