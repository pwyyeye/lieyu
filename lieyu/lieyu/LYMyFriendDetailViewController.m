//
//  LYMyFriendDetailViewController.m
//  lieyu
//
//  Created by 薛斯岐 on 15/10/29.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYMyFriendDetailViewController.h"
#import "LYAddFriendViewController.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
@interface LYMyFriendDetailViewController ()

@end

@implementation LYMyFriendDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userImageView.layer.masksToBounds =YES;
    
    self.userImageView.layer.cornerRadius =self.userImageView.frame.size.width/2;
    
    
    if([_type isEqualToString:@"0"]){
        self.namelal.text=_customerModel.friendName;
        [self.userImageView setImageWithURL:[NSURL URLWithString:_customerModel.icon]];
        if (_customerModel.sex.integerValue==0) {
            self.sexImageView.image=[UIImage imageNamed:@"woman"];
        }else{
            self.sexImageView.image=[UIImage imageNamed:@"manIcon"];
        }
        if (_customerModel.tag.count>0) {
            
//            _zhiwuLal.text=_customerModel.tag.firstObject;
        }
    }else if([_type isEqualToString:@"4"]){
        self.namelal.text=_customerModel.name;
        [_setBtn setTitle:@"打招呼" forState:0];
        [self.userImageView setImageWithURL:[NSURL URLWithString:_customerModel.mark]];
        if([_customerModel.sex isEqualToString:@"1"]){
            _sexImageView.image=[UIImage imageNamed:@"manIcon"];
        }
    }else{
        [_setBtn setTitle:@"打招呼" forState:0];
        self.namelal.text=_customerModel.username;
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
        AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        [app.imArr removeAllObjects];
        CustomerModel *model1=[[CustomerModel alloc]init];
        model1.imUserId=self.userModel.imuserId;
        model1.username=self.userModel.username;
        model1.icon=self.userModel.avatar_img;
        CustomerModel *model2=[[CustomerModel alloc]init];
        model2.imUserId=_customerModel.imUserId;
        model2.username=_customerModel.friendName;
        model2.icon=_customerModel.icon;
        [app.imArr addObject:model1];
        [app.imArr addObject:model2];
        RCConversationViewController *conversationVC = [[RCConversationViewController alloc]init];
        conversationVC.conversationType =ConversationType_PRIVATE; //会话类型，这里设置为 PRIVATE 即发起单聊会话。
        conversationVC.targetId = _customerModel.imUserId; // 接收者的 targetId，这里为举例。
        conversationVC.userName =_customerModel.friendName; // 接受者的 username，这里为举例。
        conversationVC.title = _customerModel.friendName; // 会话的 title。
        
        // 把单聊视图控制器添加到导航栈。
        [self.navigationController pushViewController:conversationVC animated:YES];
    }
    
}
@end
