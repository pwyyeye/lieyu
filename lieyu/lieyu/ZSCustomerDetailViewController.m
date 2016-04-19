//
//  ZSCustomerDetailViewController.m
//  lieyu
//
//  Created by SEM on 15/9/16.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "ZSCustomerDetailViewController.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "IQKeyboardManager.h"
#import "LYFindConversationViewController.h"
@interface ZSCustomerDetailViewController ()

@end

@implementation ZSCustomerDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title=@"客户详情";
    self.customerImageView.layer.masksToBounds =YES;
    
    self.customerImageView.layer.cornerRadius =self.customerImageView.frame.size.width/2;
    self.nameLal.text=_customerModel.username;
//    self.juliLal.text=[NSString stringWithFormat:@"%@米",_customerModel.distance];
    if(_customerModel.tag.count>0){
        NSDictionary *dic1=_customerModel.tag[0];
        self.zhiweiLal.text=[dic1 objectForKey:@"tagName"];
    }
    if([_customerModel.sex isEqualToString:@"1"]){
        _sexImageView.image=[UIImage imageNamed:@"manIcon"];
    }
    
    [self.customerImageView setImageWithURL:[NSURL URLWithString:_customerModel.avatar_img]];
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

- (IBAction)liaotianAct:(UIButton *)sender {
    LYFindConversationViewController *conversationVC = [[LYFindConversationViewController alloc]init];
    conversationVC.conversationType =ConversationType_PRIVATE; //会话类型，这里设置为 PRIVATE 即发起单聊会话。
    conversationVC.targetId = _customerModel.imuserid; // 接收者的 targetId，这里为举例。
//    conversationVC.userName =_customerModel.friendName?_customerModel.friendName:_customerModel.usernick?_customerModel.usernick:_customerModel.username; // 接受者的 username，这里为举例。
    conversationVC.title = _customerModel.friendName?_customerModel.friendName:_customerModel.usernick?_customerModel.usernick:_customerModel.username; // 会话的 title。
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].isAdd = YES;
    [USER_DEFAULT setObject:@"0" forKey:@"needCountIM"];
    // 把单聊视图控制器添加到导航栈。
//    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"return"] style:UIBarButtonItemStylePlain target:self action:@selector(backForward)];
//    conversationVC.navigationItem.leftBarButtonItem = left;
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(-10, 0, 44, 44)];
    [button setImage:[UIImage imageNamed:@"backBtn"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backForward) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:view];
    conversationVC.navigationItem.leftBarButtonItem = item;
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].isAdd = YES;
    [self.navigationController pushViewController:conversationVC animated:YES];

//    [self.navigationController pushViewController:conversationVC animated:YES];
}

- (void)backForward{
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].isAdd = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)phoneAct:(UIButton *)sender {
    if( [MyUtil isPureInt:_customerModel.mobile]){
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",_customerModel.mobile];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        
    }
}
@end
