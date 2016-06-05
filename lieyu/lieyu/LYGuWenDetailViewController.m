//
//  LYGuWenDetailViewController.m
//  lieyu
//
//  Created by 狼族 on 16/5/31.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYGuWenDetailViewController.h"
#import "LYAdviserHttpTool.h"
#import "LYAdviserInfoModel.h"
#import "IQKeyboardManager.h"
#import "FreeOrderViewController.h"
#import "preview.h"
#import "LYFindConversationViewController.h"
#import "BeerNewBarViewController.h"
#import "LYUserLocation.h"
#import "LYwoYaoDinWeiMainViewController.h"
#import "LYFriendsPersonMessageViewController.h"
#import "LYGuWenFansViewController.h"

@interface LYGuWenDetailViewController ()
{
    preview *_subView;
}
@property (nonatomic, strong) LYAdviserInfoModel *adviserModel;
@end

@implementation LYGuWenDetailViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getData];
    [self initThisView];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - 相关事宜
- (void)initThisView{
    _xingzuo_label.layer.cornerRadius = 10;
    _xingzuo_label.layer.masksToBounds = YES;
    _job_label.layer.cornerRadius = 10;
    _job_label.layer.masksToBounds = YES;
    _bookfree_button.layer.cornerRadius = 4;
    _bookonline_button.layer.cornerRadius = 4;
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 290);
}

- (void)getData{
    NSDictionary *dict = @{@"userid":_userID};
//    NSDictionary *dict = @{@"userid":@"130616"};
    __weak __typeof(self)weakSelf = self;
    [LYAdviserHttpTool lyGetManagerInfoWithParams:dict complete:^(LYAdviserInfoModel *adviserModel) {
        weakSelf.adviserModel = adviserModel;
        //        [weakSelf.tableView reloadData];
        [weakSelf reloadData];
    }];
}

- (void)reloadData{
    if ([_adviserModel.liked isEqualToString:@"1"]) {
        [_collectButton setImage:[UIImage imageNamed:@"CareNumber"] forState:UIControlStateNormal];
        _collectButton.tag = 189;
    }else{
        [_collectButton setImage:[UIImage imageNamed:@"AddCare"] forState:UIControlStateNormal];
        _collectButton.tag = 589;
    }
    [_avatar_BG sd_setImageWithURL:[NSURL URLWithString:_adviserModel.avatar_img] placeholderImage:[UIImage imageNamed:@"empyImage300"]];
    [_avatar_image sd_setImageWithURL:[NSURL URLWithString:_adviserModel.avatar_img] placeholderImage:[UIImage imageNamed:@"empyImage120"]];
    _avatar_image.layer.cornerRadius = _avatar_image.frame.size.width / 2 ;
    _avatar_image.layer.masksToBounds = YES;
    _avatar_image.contentMode = UIViewContentModeScaleAspectFill;
    [_usernick_label setText:_adviserModel.usernick];
    if (_adviserModel.gender == 0) {
        //man
        [_sex_image setImage:[UIImage imageNamed:@"manIcon"]];
    }else if (_adviserModel.gender == 1){
        [_sex_image setImage:[UIImage imageNamed:@"woman"]];
    }
    if([_adviserModel.birthday length]){
        NSString *birth = [_adviserModel.birthday substringToIndex:10];
        [_xingzuo_label setText:[MyUtil getAstroWithBirthday:birth]];
    }else{
        [_xingzuo_label setText:@"未知"];
    }
    if(_adviserModel.tags.count){
        [_job_label setText:[[_adviserModel.tags objectAtIndex:0] objectForKey:@"tagname"]];
    }else{
        [_job_label setText:@"未知"];
    }
    [_beCaredNum_label setText:[NSString stringWithFormat:@"%d",_adviserModel.beCollectNum]];
    [_popularity_label setText:[NSString stringWithFormat:@"人气 %d",_adviserModel.popularityNum]];
    [_barname_label setText:_adviserModel.barname];
    [_address_label setText:_adviserModel.address];
    if (_adviserModel.barid == -1) {
        _bigBar.hidden = YES;
        _checkbar_button.enabled = NO;
    }else{
        [_checkbar_button addTarget:self action:@selector(checkBarClick) forControlEvents:UIControlEventTouchUpInside];
    }
    for (int i = 0 ; i < 4 ; i ++) {
        UIImageView *imageView = [_trend_images objectAtIndex:i];
        if (_adviserModel.recentImages.count > i) {
            [imageView sd_setImageWithURL:[NSURL URLWithString:[_adviserModel.recentImages objectAtIndex:i]] placeholderImage:[UIImage imageNamed:@"empyImage120"]];
        }else{
            break;
        }
    }
    UIButton *button = [_identification_buttons objectAtIndex:0];
    button.selected = YES;
}

#pragma mark - 按钮事件
//返回
- (IBAction)backClick:(UIButton *)sender {
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].isAdd = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

//在线预订
- (IBAction)onlinebookClick:(UIButton *)sender {
    if (_adviserModel.barid <= 0) {
        [MyUtil showCleanMessage:@"抱歉，该酒吧暂不支持在线预订！"];
        return;
    }
    LYwoYaoDinWeiMainViewController *onlineBookVC = [[LYwoYaoDinWeiMainViewController alloc]initWithNibName:@"LYwoYaoDinWeiMainViewController" bundle:nil];
    onlineBookVC.barid = _adviserModel.barid;
    [self.navigationController pushViewController:onlineBookVC animated:YES];
    [MTA trackCustomKeyValueEvent:@"LYClickEvent" props:[self createMTADctionaryWithActionName:@"跳转" pageName:@"专属经理" titleName:@"在线预订"]];
    [MTA trackCustomEvent:@"YDList" args:nil];
}

//免费预订
- (IBAction)freebookClick:(UIButton *)sender {
    FreeOrderViewController *freeOrderVC = [[FreeOrderViewController alloc]initWithNibName:@"FreeOrderViewController" bundle:nil];
    [self.navigationController pushViewController:freeOrderVC animated:YES];
    freeOrderVC.userDict = @{@"avatar":_adviserModel.avatar_img,
                 @"usernick":_adviserModel.usernick,
                 @"userid":_adviserModel.userid};
    freeOrderVC.barDict = @{@"baricon":_adviserModel.baricon,
                  @"barname":_adviserModel.barname,
                  @"barid":[NSString stringWithFormat:@"%d",_adviserModel.barid]};
    [MTA trackCustomKeyValueEvent:@"LYClickEvent" props:[self createMTADctionaryWithActionName:@"跳转" pageName:@"专属经理" titleName:@"免费预订"]];
    [MTA trackCustomEvent:@"YDList" args:nil];
}

//查看大头像
- (IBAction)checkBigAvatar:(UIButton *)sender {
    _subView = [[[NSBundle mainBundle]loadNibNamed:@"preview" owner:nil options:nil]firstObject];
    _subView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    _subView.button.hidden = YES;
    NSArray *array;
    if (_adviserModel.avatar_img.length) {
        array = [_adviserModel.avatar_img componentsSeparatedByString:@"?"];
    }
    if (array.count <= 1) {
        _subView.image = self.avatar_image.image;
    }else{
        _subView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[array objectAtIndex:0]]]];
    }
    [_subView viewConfigure];
    _subView.imageView.center = _subView.center;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideSubview:)];
    [_subView addGestureRecognizer:tapGesture];
    
    [self.view addSubview:_subView];
}

- (void)hideSubview:(UIButton *)button{
    [_subView removeFromSuperview];
}

//添加关注
- (IBAction)AddCare:(UIButton *)sender {
    NSDictionary *dict = @{@"userid":[NSNumber numberWithInt:self.userModel.userid],
                           @"vipUserid":_adviserModel.userid};
    if (sender.tag == 589) {
        [LYAdviserHttpTool lyAddCollectWithParams:dict complete:^(BOOL result) {
            if (result) {
                [MyUtil showPlaceMessage:@"添加关注成功！"];
                [sender setImage:[UIImage imageNamed:@"CareNumber"] forState:UIControlStateNormal];
                _beCaredNum_label.text = [NSString stringWithFormat:@"%d",[_beCaredNum_label.text intValue] + 1];
                sender.tag = 189;
            }else{
                [MyUtil showPlaceMessage:@"关注失败，请稍后重试！"];
            }
        }];
    }else if (sender.tag == 189){
        [LYAdviserHttpTool lyDeleteCollectWithParams:dict complete:^(BOOL result) {
            if (result) {
                [MyUtil showPlaceMessage:@"取消关注成功！"];
                [sender setImage:[UIImage imageNamed:@"AddCare"] forState:UIControlStateNormal];
                _beCaredNum_label.text = [NSString stringWithFormat:@"%d",[_beCaredNum_label.text intValue] - 1];
                sender.tag = 589;
            }else{
                [MyUtil showPlaceMessage:@"取消关注失败，请稍后重试！"];
            }
        }];
    }
}

//查看粉丝列表
- (IBAction)checkCares:(UIButton *)sender {
    //用专属经理的ID号查询其粉丝
//    NSDictionary *dict = @{@"vipUserid":_adviserModel.userid};
//    [LYAdviserHttpTool lyCheckFansWithParams:dict complete:^(NSArray *dataList) {
    LYGuWenFansViewController *checkFans = [[LYGuWenFansViewController alloc]initWithNibName:@"LYGuWenFansViewController" bundle:nil];
    checkFans.type = 0;
    checkFans.userID = _adviserModel.userid;
    [self.navigationController pushViewController:checkFans animated:YES];
//    }];
}

//进入好友动态
- (IBAction)checkTrends:(UIButton *)sender {
    LYFriendsPersonMessageViewController *friendsVC = [[LYFriendsPersonMessageViewController alloc]init];
    friendsVC.isFriendToUserMessage = YES;
    friendsVC.friendsId = _adviserModel.userid;
    [self.navigationController pushViewController:friendsVC animated:YES];
}

//聊天
- (IBAction)chatWithManager:(UIButton *)sender {
    if (self.userModel == nil) {
        [MyUtil showCleanMessage:@"请先登录"];
        return;
    }
    LYFindConversationViewController *conversationVC = [[LYFindConversationViewController alloc]init];
    conversationVC.conversationType = ConversationType_PRIVATE;
    conversationVC.targetId = _adviserModel.imuserid;
    conversationVC.title = _adviserModel.usernick;
    
    [USER_DEFAULT setObject:@"0" forKey:@"needCountIM"];
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].isAdd = YES;
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, -30, 0, 0)];
    [button setImage:[UIImage imageNamed:@"backBtn"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:button];
    conversationVC.navigationItem.leftBarButtonItem = item;
    [self.navigationController pushViewController:conversationVC animated:YES];
}

//进入地图
- (IBAction)checkAddressClick:(UIButton *)sender {
    NSDictionary *dict = @{@"title":_adviserModel.barname,
                           @"latitude":_adviserModel.latitude,
                           @"longitude":_adviserModel.longitude};
    [[LYUserLocation instance] daoHan:dict];
}

//进入酒吧详情
- (void)checkBarClick{
    if (_adviserModel.barid <= 0) {
        [MyUtil showCleanMessage:@"对不起，该酒吧尚未录入信息！"];
        return;
    }
    BeerNewBarViewController *barDetailVC = [[BeerNewBarViewController alloc]initWithNibName:@"BeerNewBarViewController" bundle:nil];
    barDetailVC.beerBarId = [NSNumber numberWithInt:_adviserModel.barid];
    [self.navigationController pushViewController:barDetailVC animated:YES];
}

@end
