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
#import "LYFriendsToUserMessageViewController.h"
#import "CareofViewController.h"

@interface LYMyFriendDetailViewController ()
{
    preview *_subView;
    find_userInfoModel *_result;
    NSArray *imgArray;
}
@end

@implementation LYMyFriendDetailViewController

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    NSLog(@"%@",self.navigationController.viewControllers);
    UIViewController *VC = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2];
    if([VC isKindOfClass:[LYFindConversationViewController class]]){
        self.setBtn.hidden = YES;
        self.setBG.hidden = YES;
    }else{
        self.setBtn.hidden = NO;
        self.setBG.hidden = NO;
    }
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"个人信息";
    self.userImageView.layer.masksToBounds =YES;
    self.userImageView.layer.cornerRadius =self.userImageView.frame.size.width/2;
    self.xingzuo.layer.cornerRadius = 10;
    self.xingzuo.layer.masksToBounds = YES;
    self.zhiwuLal.layer.cornerRadius = 10;
    self.zhiwuLal.layer.masksToBounds = YES;
    self.guanzhuBtn.layer.cornerRadius = 4;
    self.guanzhuBtn.layer.masksToBounds = YES;
    self.guanzhuBtn.layer.borderColor = [UIColor blackColor].CGColor;
    self.guanzhuBtn.layer.borderWidth = 0.5;
    self.DTView.layer.cornerRadius = 4;
    self.DTView.layer.masksToBounds = YES;
    imgArray = @[_image1,_image2,_image3,_image4];
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
            if (![MyUtil isEmptyString:_customerModel.age]) {
                _age.text=_customerModel.age;
            }
            
            if (![MyUtil isEmptyString:_customerModel.birthday]) {
                _xingzuo.text=[MyUtil getAstroWithBirthday:_customerModel.birthday];
                _age.text=[MyUtil getAgefromDate:_customerModel.birthday];
            }
            
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
    for (UIViewController *VC in self.navigationController.viewControllers) {
        if ([VC isKindOfClass:[SaoYiSaoViewController class]]) {
            [self.navigationController popToRootViewControllerAnimated:YES];
            return;
        }
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
    self.navigationController.navigationBarHidden = YES;
    [self.navigationController setNavigationBarHidden:YES];
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
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController setNavigationBarHidden:NO];
    [_subView removeFromSuperview];
}

- (void)configureThisView{
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
    _delLal.text = _result.introduction.length?_result.introduction:@"相约随时";
    NSArray *tagsArrayy = _result.tags;
    if(tagsArrayy.count > 0){
        _zhiwuLal.text = [tagsArrayy[0] objectForKey:@"tagname"];
    }else{
        _zhiwuLal.text = @"秘密";
    }
    _age.text = _result.age;
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
    if([_result.isFriend isEqualToString:@"1"]){
        [_setBtn setTitle:@"聊天" forState:UIControlStateNormal];
    }else{
        [_setBtn setTitle:@"打招呼" forState:UIControlStateNormal];
    }
    for(int i = 0 ; i < _result.recentImages.count ; i ++){
        UIImageView *image = [imgArray objectAtIndex:i];
        [image sd_setImageWithURL:[NSURL URLWithString:[_result.recentImages objectAtIndex:i]]];
        image.contentMode = UIViewContentModeScaleAspectFill;
        image.clipsToBounds = YES;
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
        [weakSelf configureThisView];
        if (_imUserId) {
            _userID = [NSString stringWithFormat:@"%d",_result.userid];
        }
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
    if([_result.isFriend isEqualToString:@"0"]){
       
        LYAddFriendViewController *addFriendViewController=[[LYAddFriendViewController alloc]initWithNibName:@"LYAddFriendViewController" bundle:nil];
        addFriendViewController.title=@"加好友";
        if (_customerModel) {
            addFriendViewController.customerModel=_customerModel;
        }
        addFriendViewController.type=self.type;
        addFriendViewController.userID = self.userID;
        [self.navigationController pushViewController:addFriendViewController animated:YES];
    }else{
        
        LYFindConversationViewController *conversationVC = [[LYFindConversationViewController alloc]init];
        conversationVC.conversationType =ConversationType_PRIVATE; //会话类型，这里设置为 PRIVATE 即发起单聊会话。
        if (_customerModel) {
            conversationVC.targetId = _customerModel.imUserId; // 接收者的 targetId，这里为举例。
            conversationVC.userName =_customerModel.friendName?_customerModel.friendName:_customerModel.usernick; // 接受者的 username，这里为举例。
            conversationVC.title = _customerModel.friendName?_customerModel.friendName:_customerModel.usernick; // 会话的 title。
        }else{
            conversationVC.targetId = [NSString stringWithFormat:@"%d",_result.userid];
            conversationVC.userName = _customerModel.usernick;
            conversationVC.title = _customerModel.usernick;
//            conversationVC.userName = _result[@"usernick"]?_result[@"usernick"]:_result[@"username"];
//            conversationVC.title = _result[@"usernick"]?_result[@"usernick"]:_result[@"username"];
        }
        
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
    }
}

- (IBAction)addCareof:(UIButton *)sender {
    
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
//
//- (IBAction)checkFans:(UIButton *)sender {
//    CareofViewController *caresViewController = [[CareofViewController alloc]initWithNibName:@"CareofViewController" bundle:nil];
//    caresViewController.userId = self.userID;
//    caresViewController.type = @"1";
//    [self.navigationController pushViewController:caresViewController animated:YES];
//}
//
//- (IBAction)checkCares:(UIButton *)sender {
//    CareofViewController *caresViewController = [[CareofViewController alloc]initWithNibName:@"CareofViewController" bundle:nil];
//    caresViewController.userId = self.userID;
//    caresViewController.type = @"0";
//    [self.navigationController pushViewController:caresViewController animated:YES];
//}

- (IBAction)checkTrends:(UIButton *)sender {
    LYFriendsToUserMessageViewController *friendsVC = [[LYFriendsToUserMessageViewController alloc]initWithNibName:@"LYFriendsToUserMessageViewController" bundle:nil];
    friendsVC.friendsId = self.userID;
    [self.navigationController pushViewController:friendsVC animated:YES];
}
@end
