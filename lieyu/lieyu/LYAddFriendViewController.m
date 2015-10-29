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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _messagetext.text=[NSString stringWithFormat:@"我是%@",self.userModel.username];
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

- (IBAction)sendAct:(UIButton *)sender {
    NSDictionary *dic;
    if([_type isEqualToString:@"1"]){
        dic=@{@"user":[NSNumber numberWithInt:self.userModel.userid],@"friend":[NSNumber numberWithInt:_customerModel.friend],@"makeWay":@"1"};
    }else{
        dic=@{@"user":[NSNumber numberWithInt:self.userModel.userid],@"friend":[NSNumber numberWithInt:_customerModel.userid],@"makeWay":@"1"};
    }
    
    [[LYUserHttpTool shareInstance] addFriends:dic complete:^(BOOL result) {
        if(result){
            
            [MyUtil showMessage:@"发送请求成功"];
        }
    }];

}
@end
