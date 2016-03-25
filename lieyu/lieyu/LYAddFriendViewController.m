//
//  LYAddFriendViewController.m
//  lieyu
//
//  Created by 薛斯岐 on 15/10/29.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYAddFriendViewController.h"
#import "LYUserHttpTool.h"
@interface LYAddFriendViewController ()

@end

@implementation LYAddFriendViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    [self.navigationController.navigationBar setHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _messagetext.text=[NSString stringWithFormat:@"我是%@",self.userModel.usernick];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)exitEdit:(id)sender {
    [sender resignFirstResponder];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)sendAct:(UIButton *)sender {
    NSDictionary *dic;
    if(_userID){
        if([_type isEqualToString:@"4"]){
            dic=@{@"friendUserid":self.userID,@"message":_messagetext.text,@"type":_type};
        }else{
            dic=@{@"friendUserid":self.userID,@"message":_messagetext.text,@"type":_type};
        }
    }else{
        if([_type isEqualToString:@"4"]){
            dic=@{@"friendUserid":[NSNumber numberWithInt:_customerModel.id?_customerModel.id:_customerModel.userid?_customerModel.userid:_customerModel.friend],@"message":_messagetext.text,@"type":_type};
        }else{
            dic=@{@"friendUserid":[NSNumber numberWithInt:_customerModel.userid?_customerModel.userid:_customerModel.friend],@"message":_messagetext.text,@"type":_type};
        }
    }
    
    __weak __typeof(self) weakSelf = self;
    [[LYUserHttpTool shareInstance] addFriends:dic complete:^(BOOL result) {
        if(result){
            
            [MyUtil showMessage:@"发送请求成功"];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    }];

}
@end
