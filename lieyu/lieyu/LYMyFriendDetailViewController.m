//
//  LYMyFriendDetailViewController.m
//  lieyu
//
//  Created by 薛斯岐 on 15/10/29.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYMyFriendDetailViewController.h"
#import "LYAddFriendViewController.h"
#import "IQKeyboardManager.h"
#import "UIImageView+WebCache.h"
#import "LYUserHttpTool.h"
#import "preview.h"
#import "UserModel.h"
#import "SaoYiSaoViewController.h"
#import "LYFindConversationViewController.h"
#import "find_userInfoModel.h"
#import "LYFriendsPersonMessageViewController.h"
#import "LYGuWenFansViewController.h"
#import "LYUserLocation.h"
#import "BeerNewBarViewController.h"
#import "LYAdviserHttpTool.h"
#import "LYwoYaoDinWeiMainViewController.h"
#import "FreeOrderViewController.h"
#import "LYFriendsHttpTool.h"
#import "LYLiveShowListModel.h"
#import "LYMyFriendLiveListViewController.h"

@interface LYMyFriendDetailViewController ()
{
    preview *_subView;
    find_userInfoModel *_result;
    NSArray *imgArray;
    NSArray *liveImageArray;
    UILabel *clearLabel;
}

@property (nonatomic, strong) NSMutableArray *liveArray;//直播列表

@end

@implementation LYMyFriendDetailViewController

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    NSLog(@"%@",self.navigationController.viewControllers);
    UIViewController *VC = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2];
    if([VC isKindOfClass:[LYFindConversationViewController class]] && _isChatroom == 0){
        self.setBtn.hidden = YES;
        self.setBG.hidden = YES;
    }else{
        self.setBtn.hidden = NO;
        self.setBG.hidden = NO;
    }
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    _liveArray = [NSMutableArray arrayWithCapacity:1];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
//        [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.navigationController.navigationBarHidden==NO) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
}



- (void)viewDidLoad {
    [super viewDidLoad];
    _scrollView.hidden = YES;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.userImageView.layer.masksToBounds =YES;
    self.userImageView.layer.cornerRadius = 32;
    self.xingzuo.layer.cornerRadius = 10;
    self.xingzuo.layer.masksToBounds = YES;
    self.zhiwuLal.layer.cornerRadius = 10;
    self.zhiwuLal.layer.masksToBounds = YES;
    self.freeBookButton.layer.cornerRadius = 4;
    self.onlineBookButton.layer.cornerRadius = 4;
    self.DTView.layer.cornerRadius = 4;
    self.DTView.layer.masksToBounds = YES;
    imgArray = @[_image1,_image2,_image3,_image4];
    liveImageArray = @[_liveImageView_1,_liveImageView_2,_liveImageView_3,_liveImageView_4];
    if (_userID || _imUserId) {
        [self getData];
    }else{
        if (_type != nil) {
            if ([_type isEqualToString:@"0"]) {
                [_setBtn setTitle:@"聊天" forState:UIControlStateNormal];
            }else{
                [_setBtn setTitle:@"打招呼" forState:UIControlStateNormal];
            }
        }
        if (_customerModel) {
            if(_customerModel.tag.count>0){
                NSMutableString *mytags=[[NSMutableString alloc] init];
                for (int i=0; i<_customerModel.tag.count; i++) {
                    if (i==_customerModel.tag.count-1) {
                        [mytags appendString:[_customerModel.tag[i] objectForKey:@"tagName"]?[_customerModel.tag[i] objectForKey:@"tagName"]:[_customerModel.tag[i] objectForKey:@"tagname"]];
                    }else{
                        [mytags appendString:[_customerModel.tag[i] objectForKey:@"tagName"]?[_customerModel.tag[i] objectForKey:@"tagName"]:[_customerModel.tag[i] objectForKey:@"tagname"]];
                        [mytags appendString:@","];
                    }
                }
                _zhiwuLal.text=[NSString stringWithFormat:@" %@ ",mytags];
            }
            
            if(_customerModel.tag.count==0 && _customerModel.userTag.count>0){
                NSMutableString *mytags=[[NSMutableString alloc] init];
                for (int i=0; i<_customerModel.userTag.count; i++) {
                    if (i==_customerModel.userTag.count-1) {
                        [mytags appendString:[_customerModel.userTag[i] objectForKey:@"tagName"]?[_customerModel.userTag[i] objectForKey:@"tagName"]:[_customerModel.userTag[i] objectForKey:@"tagname"]];
                    }else{
                        [mytags appendString:[_customerModel.userTag[i] objectForKey:@"tagName"]?[_customerModel.userTag[i] objectForKey:@"tagName"]:[_customerModel.userTag[i] objectForKey:@"tagname"]];
                        [mytags appendString:@","];
                    }
                }
                _zhiwuLal.text=[NSString stringWithFormat:@" %@ ",mytags];
            }
            if(_customerModel.tag.count==0 && _customerModel.tags.count>0){
                NSMutableString *mytags=[[NSMutableString alloc] init];
                for (int i=0; i<_customerModel.tags.count; i++) {
                    if (i==_customerModel.tags.count-1) {
                        [mytags appendString:[_customerModel.tags[i] objectForKey:@"tagName"]?[_customerModel.tags[i] objectForKey:@"tagName"]:[_customerModel.tags[i] objectForKey:@"tagname"]];
                    }else{
                        [mytags appendString:[_customerModel.tags[i] objectForKey:@"tagName"]?[_customerModel.tags[i] objectForKey:@"tagName"]:[_customerModel.tags[i] objectForKey:@"tagname"]];
                        [mytags appendString:@","];
                    }
                }
                _zhiwuLal.text=[NSString stringWithFormat:@" %@ ",mytags];
            }
            
            if(_customerModel.tag.count == 0 && _customerModel.tags.count == 0 && _customerModel.userTag.count == 0){
                _zhiwuLal.text = @"保密";
            }
//            if (![MyUtil isEmptyString:_customerModel.age]) {
//                _age.text=_customerModel.age;
//            }
//            
//            if (![MyUtil isEmptyString:_customerModel.birthday]) {
//                _xingzuo.text=[MyUtil getAstroWithBirthday:_customerModel.birthday];
//                _age.text=[MyUtil getAgefromDate:_customerModel.birthday];
//            }
            
            self.namelal.text=_customerModel.friendName?_customerModel.friendName : (_customerModel.usernick ?_customerModel.usernick : (_customerModel.username?_customerModel.username:_customerModel.name));
            [self.userImageView sd_setImageWithURL:[NSURL URLWithString:_customerModel.avatar_img ? _customerModel.avatar_img : (_customerModel.icon ? _customerModel.icon : _customerModel.mark)]];
            [self.headerBGView sd_setImageWithURL:[NSURL URLWithString:_customerModel.avatar_img ? _customerModel.avatar_img : (_customerModel.icon ? _customerModel.icon : _customerModel.mark)]];
            [self.userimageBtn addTarget:self action:@selector(checkFriendAvatar) forControlEvents:UIControlEventTouchUpInside];
            if (_customerModel.sex.integerValue==0) {
                self.sexImageView.image=[UIImage imageNamed:@"woman"];
            }else{
                self.sexImageView.image=[UIImage imageNamed:@"manIcon"];
            }
        }
    }
}

- (void)backForward:(UIButton *)sender{
    NSLog(@"%@",self.navigationController.viewControllers);
    
    for (UIViewController *VC in self.navigationController.viewControllers) {
        NSLog(@"%@",VC.superclass);
        if ([VC isKindOfClass:[SaoYiSaoViewController class]]) {
            [self.navigationController popToRootViewControllerAnimated:YES];
            return;
        }
    }
    UIViewController *VC = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2];
    if ([VC isKindOfClass:[LYFindConversationViewController class]]) {
        [IQKeyboardManager sharedManager].enable = NO;
        [IQKeyboardManager sharedManager].isAdd = YES;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)BaseGoBack{
    for (UIViewController *VC in self.navigationController.viewControllers) {
        if ([VC isKindOfClass:[SaoYiSaoViewController class]]) {
            [self.navigationController popToRootViewControllerAnimated:YES];
            return;
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)checkFriendAvatar{
    
    _subView = [[[NSBundle mainBundle]loadNibNamed:@"preview" owner:nil options:nil]firstObject];
    _subView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    _subView.button.hidden = YES;
    NSArray *array ;
    if (_customerModel) {
        array = [_customerModel.icon componentsSeparatedByString:@"?"];
        
//        NSLog(@"%@",_customerModel);
    }else{
        array = [_result.avatar_img componentsSeparatedByString:@"?"];
//        array = [_result.avatar_img]
    }
    NSLog(@"%@",array);
    if(array == nil){
        _subView.image = self.userImageView.image;
    }else{
        _subView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[array objectAtIndex:0]]]];
    }
    [_subView viewConfigure];
    _subView.imageView.center = _subView.center;
    UITapGestureRecognizer *tapgesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideSubView:)];
    [_subView addGestureRecognizer:tapgesture];
    
    [self.view addSubview:_subView];
}

- (void)hideSubView:(UIButton *)button{
    [_subView removeFromSuperview];
}

- (void)configureThisView{
    _scrollView.hidden = NO;
    if (![_result.usertype
          isEqualToString:@"2"] &&
        ![_result.usertype isEqualToString:@"3"]) {
        //对方是普通用户
//        _collectButton.hidden = YES;
        _fansOrCaresNumLabel.hidden = YES;
        _fansOrCaresLabel.hidden = YES;
        _careNumberImage.hidden = YES;
        _checkCollectButton.hidden = YES;
        _popularityView.hidden = YES;
        _qualificationView.hidden = YES;
        _DTViewTop.constant = -225;
    }else{
        _collectButton.hidden = NO;
        [_fansOrCaresLabel setText:@"粉丝"];
        [_fansOrCaresNumLabel setText:[NSString stringWithFormat:@"%d",_result.beCollectNum]];
        [_careNumberImage setImage:[UIImage imageNamed:@"CareNumber"]];
       
        [_fansOrCaresLabel setText:@"粉丝"];
        _popularityView.hidden = NO;
        [_popularityNumberLabel setText:[NSString stringWithFormat:@"人气：%d",_result.popularityNum]];
        for (UIButton *button in _identification_buttons) {
            if (button.tag == 0) {
                button.selected = YES;
            }
        }
        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 315);
        //酒吧名字
        if(_result.barid == -1){
            _bigBarImage.hidden = YES;
            _checkBarName.enabled = NO;
        }else{
            _bigBarImage.hidden = NO;
            _checkBarName.enabled = YES;
            [_checkBarName addTarget:self action:@selector(checkBarInfo) forControlEvents:UIControlEventTouchUpInside];
        }
        [_barnameLabel setText:_result.barname];
        //空调地图
        [_addressLabel setText:_result.address];
        [_checkBarAddress addTarget:self action:@selector(checkBarLocation) forControlEvents:UIControlEventTouchUpInside];
        
        //待转正专属经理 不提供在线预订
        if ([_result.usertype
             isEqualToString:@"2"]) {
            _onlineBookButton.hidden=NO;
        }else if([_result.usertype
                  isEqualToString:@"3"]){
            _onlineBookButton.hidden=YES;
        }
        
    }
    if ([_result.liked isEqualToString:@"1"] || [_result.liked isEqualToString:@"3"]) {
        [_collectButton setImage:[UIImage imageNamed:@"hadCollect-"] forState:UIControlStateNormal];
        _collectButton.tag = 189;
    }else{
        [_collectButton setImage:[UIImage imageNamed:@"notCollect-"] forState:UIControlStateNormal];
        _collectButton.tag = 589;
    }
    _namelal.text = _result.usernick;
    
    [_userImageView sd_setImageWithURL:[NSURL URLWithString:_result.avatar_img]];
    [_headerBGView sd_setImageWithURL:[NSURL URLWithString:_result.avatar_img]];
//    _namelal.text = [_result valueForKey:@"usernick"]?[_result valueForKey:@"usernick"] : [_result valueForKey:@"username"];
//    [self.userImageView sd_setImageWithURL:[NSURL URLWithString:_result[@"avatar_img"]]];
//    [self.headerBGView sd_setImageWithURL:[NSURL URLWithString:_result[@"avatar_img"]]];
    [self.userimageBtn addTarget:self action:@selector(checkFriendAvatar) forControlEvents:UIControlEventTouchUpInside];
    if (_result.gender == 0) {
        self.sexImageView.image=[UIImage imageNamed:@"woman"];
    }else{
        self.sexImageView.image=[UIImage imageNamed:@"manIcon"];
    }
//    _delLal.text = _result.introduction.length?_result.introduction:@"相约随时";
    NSArray *tagsArrayy = _result.tags;
    if(tagsArrayy.count > 0){
        _zhiwuLal.text = [tagsArrayy[0] objectForKey:@"tagname"];
    }else{
        _zhiwuLal.text = @"秘密";
    }
//    _age.text = _result.age;
    if (![MyUtil isEmptyString:_result.birthday]) {
        NSString *birth = [_result.birthday substringToIndex:10];
        _xingzuo.text=[MyUtil getAstroWithBirthday:birth];
    }else{
        _xingzuo.text = @"秘密";
    }
    // 设置Label的字体 HelveticaNeue  Courier
    UIFont *fnt = [UIFont systemFontOfSize:12];
//    _nameLabel.font = fnt;
    // 根据字体得到NSString的尺寸
    CGSize size = [_zhiwuLal.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName, nil]];
    // 名字的H
//    CGFloat nameH = size.height;
    // 名字的W
    CGFloat nameW = size.width;
    _zhiwuWidth.constant = nameW + 20;
    if([_result.isFriend isEqualToString:@"1"]
       || [self.userModel.usertype isEqualToString:@"2"]
       || [_result.usertype isEqualToString:@"2"]
       || [self.userModel.usertype isEqualToString:@"3"]
       || [_result.usertype isEqualToString:@"3"]){
        //其中一方是专属经理或者两人是好友
        [_setBtn setTitle:@"聊天" forState:UIControlStateNormal];
    }else{
        [_setBtn setTitle:@"打招呼" forState:UIControlStateNormal];
    }
    //动态栏
    if (_result.recentImages.count == 0) {
        _advanceImage.hidden = YES;
        if (!clearLabel) {
            clearLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 0, 150, 72)];
            [clearLabel setFont:[UIFont systemFontOfSize:14]];
            [clearLabel setTextColor:[UIColor darkGrayColor]];
            [clearLabel setText:@"暂无动态！"];
        }
        self.checkTrendsBtn.enabled = NO;
        [self.DTView addSubview:clearLabel];
    }else{
        _advanceImage.hidden = NO;
        [clearLabel removeFromSuperview];
        self.checkTrendsBtn.enabled = YES;
        for(int i = 0 ; i < _result.recentImages.count ; i ++){
            UIImageView *image = [imgArray objectAtIndex:i];
            [image sd_setImageWithURL:[NSURL URLWithString:[_result.recentImages objectAtIndex:i]]];
            image.contentMode = UIViewContentModeScaleAspectFill;
            image.clipsToBounds = YES;
        }
    }
    //直播页面
    if (_liveArray.count == 0) {
        _advangeView.hidden = YES;
        if (!clearLabel) {
            clearLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 0, 150, 72)];
            [clearLabel setFont:[UIFont systemFontOfSize:14]];
            [clearLabel setTextColor:[UIColor darkGrayColor]];
            [clearLabel setText:@"暂无直播！"];
        }
        self.zhiboButton.enabled = NO;
        [self.LIVEView addSubview:clearLabel];
    }else{
        _advangeView.hidden = NO;
        [clearLabel removeFromSuperview];
        self.zhiboButton.enabled = YES;
        NSInteger num = _liveArray.count <= 4? _liveArray.count : 4;
        
        for(int i = 0 ; i < num; i ++){
            LYLiveShowListModel *model = _liveArray[i];
            UIImageView *image = [liveImageArray objectAtIndex:i];
            [image sd_setImageWithURL:[NSURL URLWithString:model.roomImg]];
            image.contentMode = UIViewContentModeScaleAspectFill;
            image.clipsToBounds = YES;
        }
    }
    [_liveStatus addTarget:self action:@selector(liveSelfList:) forControlEvents:(UIControlEventTouchUpInside)];
    if (_liveArray.count != 0) {
        for (LYLiveShowListModel *model in _liveArray) {
            if ([model.roomType isEqualToString:@"playback"]) {
                self.liveStatus.hidden = YES;
            } else {
                self.liveStatus.hidden = NO;
            }
        }
    } else {
        self.liveStatus.hidden = YES;
    }
    
}

-(void)getData{
    NSDictionary *dict;
    if (_userID) {
        dict = @{@"userid":self.userID};
    }else if(_imUserId){
        dict = @{@"imuserId":self.imUserId};
    }
//    _imUserId = @"4S/qx5Cyu3Y=";
//    dict = @{@"imuserId":_imUserId};
//    = @{@"userid":self.userID};
//    NSLog(@"%d",self.userModel.userid);
    
    __weak __typeof(self) weakSelf = self;
    [LYUserHttpTool GetUserInfomationWithID:dict complete:^(find_userInfoModel *result) {
        _result = result;
        if (_imUserId) {
            _userID = [NSString stringWithFormat:@"%d",_result.userid];
        }
        NSDictionary *dictionary = @{@"sort":@"recent",@"page":@"1",@"userid":_userID};
        [LYFriendsHttpTool getLiveShowlistWithParams:dictionary complete:^(NSArray *Arr) {
            [self.liveArray addObjectsFromArray:Arr];
            [weakSelf configureThisView];
        }];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendMessageAct:(UIButton *)sender {
    if (self.userModel==nil) {
        [MyUtil showCleanMessage:@"请先登录"];
        return;
    }
    NSLog(@"%@",self.userModel.usertype);
    if ([_setBtn.titleLabel.text isEqualToString:@"打招呼"]) {
        LYAddFriendViewController *addFriendViewController=[[LYAddFriendViewController alloc]initWithNibName:@"LYAddFriendViewController" bundle:nil];
        addFriendViewController.title=@"加好友";
        if (_customerModel) {
            addFriendViewController.customerModel=_customerModel;
            addFriendViewController.userID =[NSString stringWithFormat:@"%d",_result.userid];
        }else{
            addFriendViewController.type=self.type;
            addFriendViewController.userID = self.userID;
        }
        [self.navigationController pushViewController:addFriendViewController animated:YES];
    }else{
        LYFindConversationViewController *conversationVC = [[LYFindConversationViewController alloc]init];
        conversationVC.conversationType =ConversationType_PRIVATE; //会话类型，这里设置为 PRIVATE 即发起单聊会话。
        conversationVC.targetId = [NSString stringWithFormat:@"%@",_result.imuserId];
        conversationVC.title = _result.usernick;
        [USER_DEFAULT setObject:@"0" forKey:@"needCountIM"];
        [IQKeyboardManager sharedManager].enable = NO;
        [IQKeyboardManager sharedManager].isAdd = YES;
        // 把单聊视图控制器添加到导航栈。
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(-10, 0, 44, 44)];
        [button setImage:[UIImage imageNamed:@"backBtn"] forState:UIControlStateNormal];
        [view addSubview:button];
        [button addTarget:self action:@selector(backForward) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:view];
        conversationVC.navigationItem.leftBarButtonItem = item;
        [self.navigationController pushViewController:conversationVC animated:YES];
        [conversationVC.navigationController setNavigationBarHidden:NO animated:YES];

    }
//    if([_result.isFriend isEqualToString:@"0"] && ![self.userModel.usertype isEqualToString:@"2"]){
//       
//        LYAddFriendViewController *addFriendViewController=[[LYAddFriendViewController alloc]initWithNibName:@"LYAddFriendViewController" bundle:nil];
//        addFriendViewController.title=@"加好友";
//        if (_customerModel) {
//            addFriendViewController.customerModel=_customerModel;
//            addFriendViewController.userID =[NSString stringWithFormat:@"%d",_result.userid];
//        }else{
//            addFriendViewController.type=self.type;
//            addFriendViewController.userID = self.userID;
//        }
//        [self.navigationController pushViewController:addFriendViewController animated:YES];
//    }else{
//        
//        LYFindConversationViewController *conversationVC = [[LYFindConversationViewController alloc]init];
//        conversationVC.conversationType =ConversationType_PRIVATE; //会话类型，这里设置为 PRIVATE 即发起单聊会话。
//        if (_customerModel) {
//            conversationVC.targetId = _customerModel.imUserId; // 接收者的 targetId，这里为举例。
////            conversationVC.userName =_customerModel.friendName?_customerModel.friendName:_customerModel.usernick; // 接受者的 username，这里为举例。
//            conversationVC.title = _customerModel.friendName?_customerModel.friendName:_customerModel.usernick; // 会话的 title。
//        }else{
//            conversationVC.targetId = [NSString stringWithFormat:@"%@",_result.imuserId];
////            conversationVC.userName = _result.usernick;
//            conversationVC.title = _result.usernick;
////            conversationVC.userName = _result[@"usernick"]?_result[@"usernick"]:_result[@"username"];
////            conversationVC.title = _result[@"usernick"]?_result[@"usernick"]:_result[@"username"];
//        }
//        
//        [USER_DEFAULT setObject:@"0" forKey:@"needCountIM"];
//        [IQKeyboardManager sharedManager].enable = NO;
//        [IQKeyboardManager sharedManager].isAdd = YES;
//        // 把单聊视图控制器添加到导航栈。
//        
//        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
//        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(-10, 0, 44, 44)];
//        [button setImage:[UIImage imageNamed:@"backBtn"] forState:UIControlStateNormal];
//        [view addSubview:button];
//        [button addTarget:self action:@selector(backForward) forControlEvents:UIControlEventTouchUpInside];
//        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:view];
//        conversationVC.navigationItem.leftBarButtonItem = item;
//        [self.navigationController pushViewController:conversationVC animated:YES];
//        [conversationVC.navigationController setNavigationBarHidden:NO animated:YES];
//    }
}

- (void)backForward{
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].isAdd = NO;
    [USER_DEFAULT setObject:@"1" forKey:@"needCountIM"];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)dealloc{
    NSLog(@"delloc");
}

- (IBAction)checkFans:(UIButton *)sender {
    LYGuWenFansViewController *checkFans = [[LYGuWenFansViewController alloc]initWithNibName:@"LYGuWenFansViewController" bundle:nil];
    checkFans.userID = [NSString stringWithFormat:@"%d",_result.userid];
    if ([_result.usertype isEqualToString:@"2"] ||
        [_result.usertype isEqualToString:@"3"]) {
        checkFans.type = 0;
    }else{
        checkFans.type = 1;
    }
    [self.navigationController pushViewController:checkFans animated:YES];
}

- (IBAction)addCareof:(UIButton *)sender {
    NSDictionary *dict = @{@"followid":[NSNumber numberWithInt:_result.userid]};
    if (sender.tag == 589) {
        [LYAdviserHttpTool lyAddCollectWithParams:dict complete:^(BOOL result) {
            if (result) {
                [MyUtil showPlaceMessage:@"添加关注成功！"];
                [sender setImage:[UIImage imageNamed:@"hadCollect-"] forState:UIControlStateNormal];
                _fansOrCaresNumLabel.text = [NSString stringWithFormat:@"%d",[_fansOrCaresNumLabel.text intValue] + 1];
                self.userModel.collectNum = [NSString stringWithFormat:@"%d",[self.userModel.collectNum intValue] + 1];
                sender.tag = 189;
            }else{
                [MyUtil showPlaceMessage:@"关注失败，请稍后重试！"];
            }
        }];
    }else if (sender.tag == 189){
        [LYAdviserHttpTool lyDeleteCollectWithParams:dict complete:^(BOOL result) {
            if (result) {
                [MyUtil showPlaceMessage:@"取消关注成功！"];
                [sender setImage:[UIImage imageNamed:@"notCollect-"] forState:UIControlStateNormal];
                _fansOrCaresNumLabel.text = [NSString stringWithFormat:@"%d",[_fansOrCaresNumLabel.text intValue] - 1];
                self.userModel.collectNum = [NSString stringWithFormat:@"%d",[self.userModel.collectNum intValue] - 1];
                sender.tag = 589;
            } else {
                [MyUtil showPlaceMessage:@"取消关注失败，请稍后重试！"];
            }
        }];
    }

}


- (IBAction)checkTrends:(UIButton *)sender {
    LYFriendsPersonMessageViewController *friendsVC = [[LYFriendsPersonMessageViewController alloc]init];
    friendsVC.isFriendToUserMessage = YES;
    friendsVC.friendsId = self.userID;
    [self.navigationController pushViewController:friendsVC animated:YES];
}

- (IBAction)checkPopularityClick:(UIButton *)sender {
    [MyUtil showMessage:@"顾问人气是由猎娱玩友们对该顾问的服务好评数，关注数以及其图文视频直播的喜欢数综合得出。"];
}

- (IBAction)freeBookClick:(UIButton *)sender {
    FreeOrderViewController *freeOrderVC = [[FreeOrderViewController alloc]initWithNibName:@"FreeOrderViewController" bundle:nil];
    [self.navigationController pushViewController:freeOrderVC animated:YES];
    freeOrderVC.userDict = @{@"avatar":_result.avatar_img,
                             @"usernick":_result.usernick,
                             @"userid":[NSString stringWithFormat:@"%d",_result.userid]};
    freeOrderVC.barDict = @{@"baricon":_result.baricon,
                            @"barname":_result.barname,
                            @"barid":[NSString stringWithFormat:@"%d",_result.barid]};
    [MTA trackCustomKeyValueEvent:@"LYClickEvent" props:[self createMTADctionaryWithActionName:@"跳转" pageName:@"专属经理" titleName:@"免费预订"]];
    [MTA trackCustomEvent:@"YDList" args:nil];
}

- (IBAction)onlineBookClick:(UIButton *)sender {
    if (_result.barid <= 0) {
        [MyUtil showCleanMessage:@"抱歉，该酒吧暂不支持在线预订！"];
        return;
    }
    LYwoYaoDinWeiMainViewController *onlineBookVC = [[LYwoYaoDinWeiMainViewController alloc]initWithNibName:@"LYwoYaoDinWeiMainViewController" bundle:nil];
    onlineBookVC.choosedManagerID = [NSString stringWithFormat:@"%d",_result.userid];
    onlineBookVC.barid = _result.barid;
    [self.navigationController pushViewController:onlineBookVC animated:YES];
    [MTA trackCustomKeyValueEvent:@"LYClickEvent" props:[self createMTADctionaryWithActionName:@"跳转" pageName:@"专属经理" titleName:@"在线预订"]];
    [MTA trackCustomEvent:@"YDList" args:nil];
}

- (IBAction)liveSelfList:(UIButton *)sender {
    if (_liveArray.count == 0) {
        return;
    }
    LYMyFriendLiveListViewController *liveListVC = [[LYMyFriendLiveListViewController alloc] init];
    liveListVC.userID = [NSString stringWithFormat:@"%i", _result.userid];
    liveListVC.userName = _result.usernick;
    [self.navigationController pushViewController:liveListVC animated:YES];
}

//进入酒吧详情
- (void)checkBarInfo{
    if (_result.barid <= 0) {
        [MyUtil showCleanMessage:@"对不起，该酒吧尚未录入信息！"];
        return;
    }
    BeerNewBarViewController *barDetailVC = [[BeerNewBarViewController alloc]initWithNibName:@"BeerNewBarViewController" bundle:nil];
    barDetailVC.beerBarId = [NSNumber numberWithInt:_result.barid];
    [self.navigationController pushViewController:barDetailVC animated:YES];
}

//进入地图
- (void)checkBarLocation{
    NSDictionary *dict = @{@"title":_result.barname,
                           @"latitude":_result.latitudeBar,
                           @"longitude":_result.longitudeBar};
    [[LYUserLocation instance] daoHan:dict];
}
@end
