//
//  GroupLeaderRegisterViewController.m
//  lieyu
//
//  Created by 狼族 on 16/7/7.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "GroupLeaderRegisterViewController.h"
#import "BarGroupChatViewController.h"

#import "AlertBlock.h"
#import "LYYUHttpTool.h"

@interface GroupLeaderRegisterViewController ()<UIAlertViewDelegate>

@end

@implementation GroupLeaderRegisterViewController

-(void)viewWillAppear:(BOOL)animated{
    self.title = @"申请原因";
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [_registerButton addTarget:self action:@selector(registerNew) forControlEvents:(UIControlEventTouchUpInside)];
    _textView.layer.borderWidth = 1;
    _textView.layer.cornerRadius = 3;
    _textView.layer.masksToBounds = YES;
}

-(void)registerNew{
    BarGroupChatViewController *barVC = [[BarGroupChatViewController alloc] init];
    
    NSString *reason = _textView.text;
//    NSDictionary *paraDic = @{@"barId":barVC.targetId,@"introduction":reason};
    NSMutableDictionary *paraDic = [[NSMutableDictionary alloc] init];
    
    [paraDic setValue:_groupId forKey:@"barId"];
    [paraDic setValue:reason forKey:@"introduction"];
    [LYYUHttpTool yuRegisterQunZhuWith:paraDic complete:^(NSString *str) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:str delegate:self cancelButtonTitle:nil otherButtonTitles:@"好的", nil];
        [alertView show];
    }];
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_textView resignFirstResponder];
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
