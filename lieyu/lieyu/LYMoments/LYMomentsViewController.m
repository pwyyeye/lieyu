//
//  LYMomentsViewController.m
//  lieyu
//
//  Created by 狼族 on 16/8/29.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYMomentsViewController.h"
#import "LiveListViewController.h"
#import "UIButton+WebCache.h"
#import "LYChangeImageViewController.h"
#import "LYFriendsMessageViewController.h"

#import "UserMomentViewController.h"

#define headerHeight SCREEN_WIDTH * 9 / 16

#define iconWidth SCREEN_WIDTH / 96 * 17

@interface LYMomentsViewController ()<UIActionSheetDelegate,CAAnimationDelegate>

{
    UIButton *_liveShow;
    LYFriendsUserHeaderView *_headerView;//我的表头
    NSString *_results;//新消息条数
    NSString *_icon;//新消息头像
    UIImageView *bgImage;//背景图
    UIImageView *_iconIamge;//头像
    UILabel *_nameLabel;//姓名
    UIButton *_messageButton;//消息按钮
    NSTimer *_timers;//定时获取我的新消息
    UILabel *_myTitle;
    UIImageView *_animationImageview;
    CAKeyframeAnimation *_CAkeyAnimation;
}

@end

@implementation LYMomentsViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.title = @"玩友圈";
    UITableView *tabView = _tableViewArray[0];
    tabView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    
    _timers = [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(getFriendNewMessage) userInfo:nil repeats:YES];//定时器获取新消息数
    [_timers fire];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageNum = 1;
    [self addTableViewHeader];
    [self setuploadingView];
    _pageStartCountArray[0] = 0;
    [self startLoadingAnimating];
    [self getDataWithType:dataForFriendsMessage needLoad:NO];
}

-(void)setuploadingView{
    //刷新动画
    NSMutableArray *imgsArray = [[NSMutableArray alloc] init];
    for (int i = 1; i < 10; i++) {
        UIImage *img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"loading%d@2x",i] ofType:@"png"]];
        [imgsArray addObject:(__bridge UIImage *)img.CGImage];
    }
    _CAkeyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
    _CAkeyAnimation.duration = imgsArray.count * 0.1;
    _CAkeyAnimation.delegate = self;
    _CAkeyAnimation.values = imgsArray;
    _CAkeyAnimation.repeatCount = 100;
    _animationImageview = [[UIImageView alloc] initWithFrame:(CGRectMake(14, 14, 25, 25))];
    [self.view addSubview:_animationImageview];
    [self.view bringSubviewToFront:_animationImageview];
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_liveShow removeFromSuperview];
    _liveShow = nil;
    [_timers invalidate];
    _timers = nil;
}

#pragma mark - 为表配置上下刷新控件
- (void)setupMJRefreshForTableView:(UITableView *)tableView i:(NSInteger)i{
    __weak __typeof(self) weakSelf = self;
    
    tableView.mj_footer = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
        [weakSelf getDataWithType:i needLoad:NO];
    }];
}

#pragma mark - 获取最新玩友圈数据
- (void)getDataWithType:(dataType)type needLoad:(BOOL)need{
    UITableView *tableView = nil;
    __block int pageStartCount;
    if (type == dataForFriendsMessage) {
        pageStartCount = _pageStartCountArray[0];
        tableView = _tableViewArray.firstObject;
    }else if(type == dataForMine){
        pageStartCount = _pageStartCountArray[1];
        tableView = [_tableViewArray objectAtIndex:1];
    }
    NSString *startStr = [NSString stringWithFormat:@"%ld",(long)pageStartCount * _pageCount];
    NSString *pageCountStr = [NSString stringWithFormat:@"%ld",(long)_pageCount];
    NSDictionary *paraDic = nil;
    __weak __typeof(self) weakSelf = self;
    if (type == dataForFriendsMessage) {//玩友圈数据
        paraDic = @{@"start":startStr,@"limit":pageCountStr};
        [LYFriendsHttpTool friendsGetRecentInfoWithParams:paraDic compelte:^(NSMutableArray *dataArray) {
            if (pageStartCount == 0) {
                [weakSelf stopLoadingAnimating];
            }
            [weakSelf loadDataWith:tableView dataArray:dataArray pageStartCount:pageStartCount type:type];
        }];
        
    }else if(type == dataForMine){//我的玩友圈数据
        paraDic = @{@"userId":_useridStr,@"start":startStr,@"limit":pageCountStr,@"frientId":_useridStr};
        [LYFriendsHttpTool friendsGetUserInfoWithParams:paraDic needLoading:need compelte:^(FriendsUserInfoModel*userInfo, NSMutableArray *dataArray) {
            _userBgImageUrl = userInfo.friends_img;
            [weakSelf loadDataWith:tableView dataArray:dataArray pageStartCount:pageStartCount type:type];
            [weakSelf addTableViewHeader];
        }];
    }
}

- (void)loadDataWith:(UITableView *)tableView dataArray:(NSMutableArray *)dataArray pageStartCount:(int)pageStartCount type:(dataType)type{
    if(dataArray.count){
        NSString *str = dataArray.firstObject;
        if (dataArray.count == 1 && [str isKindOfClass:[NSString class]]) {
            [tableView.mj_footer endRefreshing];
        }else{
            if(pageStartCount == 0){//下啦刷新时
                [_dataArray replaceObjectAtIndex:tableView.tag withObject:dataArray];
            }else {//上拉加载时
                NSMutableArray *muArr = _dataArray[tableView.tag];
                [muArr addObjectsFromArray:dataArray];
            }
            pageStartCount ++;
            if (type == dataForFriendsMessage) {
                _pageStartCountArray[0] = pageStartCount;
            }else if(type == dataForMine){
                _pageStartCountArray[1] = pageStartCount;
            }
            [tableView.mj_footer endRefreshing];
            
        }
    }else{
        [tableView.mj_footer endRefreshingWithNoMoreData];
    }
    
    [tableView reloadData];
    [tableView.mj_header endRefreshing];
}
#pragma mark - 配置导航
- (void)setupMenuView{
    //配置直播按钮
    _liveShow = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 50, 0, 40, 44)];
    [_liveShow setTitle:@"直播" forState:UIControlStateNormal];
    [_liveShow setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_liveShow.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [_liveShow addTarget:self action:@selector(recentConnect) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:_liveShow];
};

#pragma mark --- 进入直播列表
-(void) recentConnect{
    LiveListViewController *liveVC = [[LiveListViewController alloc] init];
    liveVC.index = 1;
    [self.navigationController pushViewController:liveVC animated:YES];
}


#pragma mark - 获取我的未读消息数
- (void)getFriendNewMessage{
    _results = @"";
    _icon = @"";
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if(app.userModel == nil)return;
    
    NSDictionary *paraDic = @{@"userId":_useridStr};
    __weak __typeof(self) weakSelf = self;
    [LYFriendsHttpTool friendsGetFriendsMessageNotificationWithParams:paraDic compelte:^(NSString * reslults, NSString *icon) {
        _results = reslults;
        _icon = icon;
        if(_results) _messageButton.hidden = NO;
        else _messageButton.hidden = YES;
        if(_results.integerValue){
            UITableView *tableView = [_tableViewArray objectAtIndex:0];
            tableView.tableHeaderView = nil;
            [weakSelf addTableViewHeader];
        }
    }];
}

#pragma mark - 添加表头
- (void)addTableViewHeader{
    UITableView *tableView = _tableViewArray.firstObject;
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor whiteColor];
    if(_results.integerValue){//有新消息
        _messageButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
        _messageButton.frame = CGRectMake(SCREEN_WIDTH / 4, headerHeight+ 5, SCREEN_WIDTH / 2 , 40);
        _messageButton.layer.cornerRadius = _messageButton.frame.size.height / 2;
        _messageButton.layer.masksToBounds = YES;
        [_messageButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [_messageButton setTitle:[NSString stringWithFormat:@"%@条新消息",_results] forState:(UIControlStateNormal)];
        [_messageButton addTarget:self action:@selector(messageButtonAction) forControlEvents:(UIControlEventTouchUpInside)];
        _messageButton.backgroundColor = RGB(96, 96, 96);
        headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, headerHeight + 50);
        [headerView addSubview:_messageButton];
    }else{
        [_messageButton removeFromSuperview];
        _messageButton = nil;
        headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, headerHeight + 30);
    }
    //背景图
    bgImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, headerHeight)];
    [bgImage setImage:[UIImage imageNamed:@"empyImage16_9"]];
//    [imgView sd_setImageWithURL:[NSURL URLWithString:_headerViewImgLink] placeholderImage:[UIImage imageNamed:@"empyImage16_9"]];
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesChooseImage)];
    [bgImage addGestureRecognizer:tapGes];
    bgImage.userInteractionEnabled = YES;
    [self setupBackIamgeView];
    [headerView addSubview:bgImage];
    
    //头像和姓名
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    _iconIamge = [[UIImageView alloc] init];
    [_iconIamge sd_setImageWithURL:[NSURL URLWithString:app.userModel.avatar_img]];
    _iconIamge.frame = CGRectMake(SCREEN_WIDTH - 10 - iconWidth, headerHeight - iconWidth / 4 * 3, iconWidth, iconWidth);
    _iconIamge.userInteractionEnabled = YES;
    UIGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconIamgeAction)];
    [_iconIamge addGestureRecognizer:tapGesture];
    _iconIamge.layer.cornerRadius = _iconIamge.frame.size.height / 2;
    _iconIamge.layer.masksToBounds = YES;
    [headerView addSubview:_iconIamge];
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.textColor = [UIColor whiteColor];
    [_nameLabel setText:app.userModel.usernick];
    [_nameLabel.font fontWithSize:18];
    [_nameLabel setTextAlignment:NSTextAlignmentRight];
    _nameLabel.frame =CGRectMake(SCREEN_WIDTH - iconWidth - 10 - 15 - 90, SCREEN_WIDTH * 187 / 375 - 30, 90, 30);
    _nameLabel.backgroundColor = [UIColor clearColor];
    [headerView addSubview:_nameLabel];
    tableView.tableHeaderView = headerView;
}

- (void)startLoadingAnimating{
    [_animationImageview.layer addAnimation:_CAkeyAnimation forKey:@"loadAnimation"];
}

- (void)stopLoadingAnimating{
    [_animationImageview.layer removeAnimationForKey:@"loadAnimation"];
}

#pragma mark --设置背景图
-(void)setupBackIamgeView{
    
        NSData *imageData = [[NSUserDefaults standardUserDefaults] objectForKey:@"FriendUserBgImage"];
        if(!_userBgImageUrl){
            bgImage.image = [[UIImage alloc]initWithData:imageData];
        }else{
            if(imageData){
                //                [_headerView.ImageView_bg sd_setImageWithURL:[NSURL URLWithString:_userBgImageUrl] placeholderImage:[[UIImage alloc]initWithData:imageData]];
                [bgImage setImage:[UIImage imageWithData:imageData]];
            }else{
                [bgImage sd_setImageWithURL:[NSURL URLWithString:_userBgImageUrl] placeholderImage:[UIImage imageNamed:@"friendPresentBG.jpg"]];
            }
        }
        if(imageData == nil && [MyUtil isEmptyString:_userBgImageUrl]){
            bgImage.image = [UIImage imageNamed:@"friendPresentBG.jpg"];
        }
        bgImage.userInteractionEnabled = YES;
        bgImage.clipsToBounds = YES;
}
#pragma mark - 表头选择背景action
- (void)tapGesChooseImage{
    
    LYChangeImageViewController *changeImageVC = [[LYChangeImageViewController alloc]init];
    __weak typeof(self) weakSelf = self;
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    UIAlertAction *imageAction = [UIAlertAction actionWithTitle:@"选一张美图" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf.navigationController pushViewController:changeImageVC animated:YES];
    }];
    [alertVC addAction:cancelAction];
    [alertVC addAction:imageAction];
    [self presentViewController:alertVC animated:YES completion:^{
        
    }];
    [changeImageVC setPassImage:^(NSString *imageurl,UIImage *image) {
        bgImage.image = image;
        _headerView.ImageView_bg.image = image;
        _userBgImageUrl = [MyUtil getQiniuUrl:imageurl width:0 andHeight:0];
        NSData *imageData = UIImagePNGRepresentation(image);
        [[NSUserDefaults standardUserDefaults] setObject:imageData forKey:@"FriendUserBgImage"];
    }];
    
}
#pragma mark - 新消息
-(void)messageButtonAction{
    _results = @"";
    _icon = @"";
    LYFriendsMessageViewController *messageVC = [[LYFriendsMessageViewController alloc]init];
    [self.navigationController pushViewController:messageVC animated:YES];
    
    //[self removeTableViewHeader];
    UITableView *tableView = [_tableViewArray objectAtIndex:0];
    tableView.tableHeaderView = nil;
    [self addTableViewHeader];
}

#pragma mark -- 跳转到个人界面
-(void)iconIamgeAction{
    UserMomentViewController *userMomentVC = [[UserMomentViewController alloc] init];
    [self.navigationController pushViewController:userMomentVC animated:YES];
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (isExidtEffectView) {
        isExidtEffectView = NO;
        [emojisView hideEmojiEffectView];
    }
    
    if(self.scrollViewForTableView != scrollView){
        CGFloat offset;
        offset = -20;
        if (scrollView.contentOffset.y > _contentOffSetY) {
            if (scrollView.contentOffset.y <= 0.f) {//发布按钮弹出
                effectView.frame = CGRectMake((SCREEN_WIDTH - 60)/2.f, SCREEN_HEIGHT - 120 + offset, 60, 60);
            }else{
                [UIView animateWithDuration:0.4 animations:^{
                    effectView.frame = CGRectMake((SCREEN_WIDTH - 60)/2.f, SCREEN_HEIGHT, 60, 60);
                }];
            }
        }else{
            if(CGRectGetMaxY(effectView.frame) > SCREEN_HEIGHT - 5){//发布按钮下移
                [UIView animateWithDuration:.4 animations:^{
                    effectView.frame = CGRectMake((SCREEN_WIDTH - 60)/2.f, SCREEN_HEIGHT - 123 + offset, 60, 60);
                }completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.2 animations:^{
                        effectView.frame = CGRectMake((SCREEN_WIDTH - 60)/2.f, SCREEN_HEIGHT - 120 +offset, 60, 60);
                    }];
                }];
            }
        }
    }else{
       
    }
    UITableView *tableView = [_tableViewArray objectAtIndex:0];
    if (tableView.contentOffset.y < 0) {
        CGFloat y = scrollView.contentOffset.y;
        CGFloat hegiht = headerHeight;
        bgImage.frame = CGRectMake(- ((hegiht - y) * 16 / 9.f - SCREEN_WIDTH ) /2.f, y, (hegiht - y) * 16 / 9.f, hegiht -y);
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if(self.scrollViewForTableView  != scrollView){
        _contentOffSetY = scrollView.contentOffset.y;//拖拽结束获取偏移量
    }
    UITableView *tableView = [_tableViewArray objectAtIndex:0];
    if (tableView.contentOffset.y < 0) {
        _pageStartCountArray[0] = 0;
        [self startLoadingAnimating];
        [self getDataWithType:dataForFriendsMessage needLoad:NO];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
