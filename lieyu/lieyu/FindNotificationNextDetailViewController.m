//
//  FindNotificationNextDetailViewController.m
//  lieyu
//
//  Created by 狼族 on 16/3/9.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "FindNotificationNextDetailViewController.h"
#import "FindNewMessageList.h"

@interface FindNotificationNextDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label_title;
@property (weak, nonatomic) IBOutlet UILabel *label_time;
@property (weak, nonatomic) IBOutlet UILabel *label_content;

@end

@implementation FindNotificationNextDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"消息通知详情";
    // Do any additional setup after loading the view from its nib.
    _label_title.text = _findNewList.title;
    _label_time.text = _findNewList.createDate;
    _label_content.text = _findNewList.content;
    
    id target = self.navigationController.interactivePopGestureRecognizer.delegate;
    UIScreenEdgePanGestureRecognizer *screenGes = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:target action:@selector(handleNavigationTransition:)];
    screenGes.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:screenGes];
}

- (void)handleNavigationTransition:(UIGestureRecognizer *)ges{
    
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
