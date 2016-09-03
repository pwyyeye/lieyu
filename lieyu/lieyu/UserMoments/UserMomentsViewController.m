//
//  UserMomentsViewController.m
//  lieyu
//
//  Created by 狼族 on 16/8/29.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "UserMomentsViewController.h"
#import "LiveListViewController.h"
#import "UIButton+WebCache.h"
#import "LYChangeImageViewController.h"
#import "LYFriendsMessageViewController.h"

#define headerHeight SCREEN_WIDTH * 187 / 375

#define iconWidth SCREEN_WIDTH / 6
@interface UserMomentsViewController () <UITableViewDelegate>
{
    UIButton *_liveShow;
    LYFriendsUserHeaderView *_headerView;//我的表头
    NSString *_results;//新消息条数
    NSString *_icon;//新消息头像
    UIImageView *bgIamge;//背景图
    UIImageView *_iconIamge;//头像
    UILabel *_nameLabel;//姓名
}
@end

@implementation UserMomentsViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
//    UITableView *tabView = _tableViewArray[1];
//    tabView.frame = CGRectMake(0,64, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    
    UITableView *tableView = _tableViewArray.lastObject;
    [tableView.mj_header beginRefreshing];
    _index = 1;
    self.pageNum = 2;
    [self setupTableForHeaderForMinPage];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的玩友圈";
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_liveShow removeFromSuperview];
    _liveShow = nil;
    
}

#pragma mark - 获取我的未读消息数
- (void)getFriendsNewMessage{
    
}

#pragma mark - 话题
- (void)addTableViewHeaderViewForTopic{
    
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
    liveVC.index = 0;
    [self.navigationController pushViewController:liveVC animated:YES];
}


#pragma mark - 添加表头
- (void)setupTableForHeaderForMinPage{
    UITableView *tableView = _tableViewArray.lastObject;
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor whiteColor];
    headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 187 / 375);
    //背景图
    bgIamge = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, headerHeight)];
    [bgIamge setImage:[UIImage imageNamed:@"empyImage16_9"]];
    //    [imgView sd_setImageWithURL:[NSURL URLWithString:_headerViewImgLink] placeholderImage:[UIImage imageNamed:@"empyImage16_9"]];
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesChooseImage)];
    [bgIamge addGestureRecognizer:tapGes];
    bgIamge.userInteractionEnabled = YES;
    [self setupBackIamgeView];
    [headerView addSubview:bgIamge];
    //头像和姓名
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    _iconIamge = [[UIImageView alloc] init];
    [_iconIamge sd_setImageWithURL:[NSURL URLWithString:app.userModel.avatar_img]];
    _iconIamge.frame = CGRectMake(SCREEN_WIDTH - 10 - iconWidth, headerHeight - 50, iconWidth, iconWidth);
    _iconIamge.userInteractionEnabled = YES;
    _iconIamge.layer.cornerRadius = _iconIamge.frame.size.height / 2;
    _iconIamge.layer.masksToBounds = YES;
    [headerView addSubview:_iconIamge];
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.textColor = [UIColor whiteColor];
    [_nameLabel setText:app.userModel.usernick];
    [_nameLabel setTextAlignment:NSTextAlignmentRight];
    _nameLabel.frame =CGRectMake(SCREEN_WIDTH - iconWidth - 10 - 7 - 90, SCREEN_WIDTH * 187 / 375 - 30, 90, 30);
    _nameLabel.backgroundColor = [UIColor clearColor];
    [headerView addSubview:_nameLabel];
    tableView.delegate = self;
    tableView.tableHeaderView = headerView;
}


#pragma mark --设置背景图
-(void)setupBackIamgeView{
    
    NSData *imageData = [[NSUserDefaults standardUserDefaults] objectForKey:@"FriendUserBgImage"];
    if(!_userBgImageUrl){
        bgIamge.image = [[UIImage alloc]initWithData:imageData];
    }else{
        if(imageData){
            //                [_headerView.ImageView_bg sd_setImageWithURL:[NSURL URLWithString:_userBgImageUrl] placeholderImage:[[UIImage alloc]initWithData:imageData]];
            [bgIamge setImage:[UIImage imageWithData:imageData]];
        }else{
            [bgIamge sd_setImageWithURL:[NSURL URLWithString:_userBgImageUrl] placeholderImage:[UIImage imageNamed:@"friendPresentBG.jpg"]];
        }
    }
    if(imageData == nil && [MyUtil isEmptyString:_userBgImageUrl]){
        bgIamge.image = [UIImage imageNamed:@"friendPresentBG.jpg"];
    }
    bgIamge.userInteractionEnabled = YES;
    bgIamge.clipsToBounds = YES;
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
        bgIamge.image = image;
        _headerView.ImageView_bg.image = image;
        _userBgImageUrl = [MyUtil getQiniuUrl:imageurl width:0 andHeight:0];
        NSData *imageData = UIImagePNGRepresentation(image);
        [[NSUserDefaults standardUserDefaults] setObject:imageData forKey:@"FriendUserBgImage"];
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
