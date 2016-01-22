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
@interface LYMyFriendDetailViewController ()

@end

@implementation LYMyFriendDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"个人信息";
    self.userImageView.layer.masksToBounds =YES;
    
    self.userImageView.layer.cornerRadius =self.userImageView.frame.size.width/2;
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
    
    self.namelal.text=_customerModel.usernick;
    [self.userImageView setImageWithURL:[NSURL URLWithString:_customerModel.avatar_img == nil ? _customerModel.icon : _customerModel.avatar_img]];
    if([_type isEqualToString:@"0"]){
        self.namelal.text=_customerModel.friendName == nil ? _customerModel.name : _customerModel.friendName;
        
        if (_customerModel.sex.integerValue==0) {
            self.sexImageView.image=[UIImage imageNamed:@"woman"];
        }else{
            self.sexImageView.image=[UIImage imageNamed:@"manIcon"];
        }
        if (_customerModel.tag.count>0) {
//            _zhiwuLal.text=_customerModel.tag.firstObject;
        }
       
    }else if([_type isEqualToString:@"4"]){
        self.namelal.text=_customerModel.friendName == nil ? _customerModel.name : _customerModel.friendName;
        [_setBtn setTitle:@"打招呼" forState:0];
        [self.userImageView setImageWithURL:[NSURL URLWithString:_customerModel.avatar_img]];
        if([_customerModel.sex isEqualToString:@"1"]){
            _sexImageView.image=[UIImage imageNamed:@"manIcon"];
        }
    }else{
        [_setBtn setTitle:@"打招呼" forState:0];
        
        self.delLal.text=[NSString stringWithFormat:@"%@米",_customerModel.distance];
        if (_customerModel.distance.doubleValue>1000) {
            self.delLal.text=[NSString stringWithFormat:@"%.2f千米",_customerModel.distance.doubleValue/1000];
        }
        
        if([_customerModel.sex isEqualToString:@"1"]){
            _sexImageView.image=[UIImage imageNamed:@"manIcon"];
        }
        
        [self.userImageView setImageWithURL:[NSURL URLWithString:_customerModel.avatar_img]];
    }
    // Do any additional setup after loading the view from its nib.
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
    
    if(![_type isEqualToString:@"0"]){
        LYAddFriendViewController *addFriendViewController=[[LYAddFriendViewController alloc]initWithNibName:@"LYAddFriendViewController" bundle:nil];
        addFriendViewController.title=@"加好友";
        addFriendViewController.customerModel=_customerModel;
        addFriendViewController.type=self.type;
        [self.navigationController pushViewController:addFriendViewController animated:YES];
    }else{
        
        RCConversationViewController *conversationVC = [[RCConversationViewController alloc]init];
        conversationVC.conversationType =ConversationType_PRIVATE; //会话类型，这里设置为 PRIVATE 即发起单聊会话。
        conversationVC.targetId = _customerModel.imUserId; // 接收者的 targetId，这里为举例。
        conversationVC.userName =_customerModel.friendName; // 接受者的 username，这里为举例。
        conversationVC.title = _customerModel.friendName; // 会话的 title。
        [USER_DEFAULT setObject:@"0" forKey:@"needCountIM"];
        [IQKeyboardManager sharedManager].enable = NO;
        [IQKeyboardManager sharedManager].isAdd = YES;
        // 把单聊视图控制器添加到导航栈。
        UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"leftBackItem"] style:UIBarButtonItemStylePlain target:self action:@selector(backForward)];
        conversationVC.navigationItem.leftBarButtonItem = left;
        
        [self.navigationController pushViewController:conversationVC animated:YES];
    }
}

- (void)backForward{
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].isAdd = NO;
    [USER_DEFAULT setObject:@"1" forKey:@"needCountIM"];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
