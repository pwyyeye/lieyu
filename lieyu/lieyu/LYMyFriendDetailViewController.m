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
@interface LYMyFriendDetailViewController ()
{
    preview *_subView;
    NSDictionary *_result;
}
@end

@implementation LYMyFriendDetailViewController

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
//    if(self.navigationController.navigationBarHidden == YES){
//        [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController setNavigationBarHidden:NO];
//    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"个人信息";
    self.userImageView.layer.masksToBounds =YES;
    self.userImageView.layer.cornerRadius =self.userImageView.frame.size.width/2;
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
            _zhiwuLal.text=mytags;
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
            _zhiwuLal.text=mytags;
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
            _zhiwuLal.text=mytags;
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
        [self.userimageBtn addTarget:self action:@selector(checkFriendAvatar) forControlEvents:UIControlEventTouchUpInside];
        if (_customerModel.sex.integerValue==0) {
            self.sexImageView.image=[UIImage imageNamed:@"woman"];
        }else{
            self.sexImageView.image=[UIImage imageNamed:@"manIcon"];
        }
    }else{
        [self getData];
    }
    
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
        array = [_result[@"avatar_img"] componentsSeparatedByString:@"?"];
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

-(void)getData{
    NSDictionary *dict = @{@"userid":self.userID};
    [LYUserHttpTool GetUserInfomationWithID:dict complete:^(NSDictionary *result) {
        _result = result;
        _namelal.text = [result valueForKey:@"usernick"]?[result valueForKey:@"usernick"] : [result valueForKey:@"username"];
        [self.userImageView sd_setImageWithURL:[NSURL URLWithString:result[@"avatar_img"]]];
        [self.userimageBtn addTarget:self action:@selector(checkFriendAvatar) forControlEvents:UIControlEventTouchUpInside];
        if ([[result valueForKey:@"gender"]integerValue]==0) {
            self.sexImageView.image=[UIImage imageNamed:@"woman"];
        }else{
            self.sexImageView.image=[UIImage imageNamed:@"manIcon"];
        }
        _delLal.text = ((NSString *)[result valueForKey:@"introduction"]).length?[result valueForKey:@"introduction"]:@"相约随时";
        NSArray *tagsArrayy = [result valueForKey:@"tags"];
        if(tagsArrayy.count > 0){
            NSMutableString *mytags=[[NSMutableString alloc] init];
            for (int i=0; i<tagsArrayy.count; i++) {
                if (i==tagsArrayy.count-1) {
                    [mytags appendString:[tagsArrayy[i] objectForKey:@"tagName"]?[tagsArrayy[i] objectForKey:@"tagName"]:[tagsArrayy[i] objectForKey:@"tagname"]];
                }else{
                    [mytags appendString:[tagsArrayy[i] objectForKey:@"tagName"]?[tagsArrayy[i] objectForKey:@"tagName"]:[tagsArrayy[i] objectForKey:@"tagname"]];
                    [mytags appendString:@","];
                }
            }
            _zhiwuLal.text=mytags;
        }
        _age.text = [result valueForKey:@"age"];
        if (![MyUtil isEmptyString:[result valueForKey:@"birthday"]]) {
            NSString *birth = [[result valueForKey:@"birthday"] substringToIndex:10];
            _xingzuo.text=[MyUtil getAstroWithBirthday:birth];
        }
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

- (IBAction)sendMessageAct:(UIButton *)sender {
    if (self.userModel==nil) {
        [MyUtil showCleanMessage:@"请先登录"];
        return;
    }
    if(![_type isEqualToString:@"0"] && _type){
        LYAddFriendViewController *addFriendViewController=[[LYAddFriendViewController alloc]initWithNibName:@"LYAddFriendViewController" bundle:nil];
        addFriendViewController.title=@"加好友";
        addFriendViewController.customerModel=_customerModel;
        addFriendViewController.type=self.type;
        [self.navigationController pushViewController:addFriendViewController animated:YES];
    }else{
        
        RCConversationViewController *conversationVC = [[RCConversationViewController alloc]init];
        conversationVC.conversationType =ConversationType_PRIVATE; //会话类型，这里设置为 PRIVATE 即发起单聊会话。
        if (_customerModel) {
            conversationVC.targetId = _customerModel.imUserId; // 接收者的 targetId，这里为举例。
            conversationVC.userName =_customerModel.friendName?_customerModel.friendName:_customerModel.usernick; // 接受者的 username，这里为举例。
            conversationVC.title = _customerModel.friendName?_customerModel.friendName:_customerModel.usernick; // 会话的 title。
        }else{
            conversationVC.targetId = [NSString stringWithFormat:@"%@",[_result valueForKey:@"userid"]];
            conversationVC.userName = _result[@"usernick"]?_result[@"usernick"]:_result[@"username"];
            conversationVC.title = _result[@"usernick"]?_result[@"usernick"]:_result[@"username"];
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
//
//        UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"return"] style:UIBarButtonItemStylePlain target:self action:@selector(backForward)];
//        conversationVC.navigationItem.leftBarButtonItem = left;
        
        [self.navigationController pushViewController:conversationVC animated:YES];
    }
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

@end
