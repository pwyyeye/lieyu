//
//  FindNotificationDetailViewController.m
//  lieyu
//
//  Created by 狼族 on 16/3/8.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "FindNotificationDetailViewController.h"
#import "FindNotificatinDetailTableViewCell.h"
#import "LYFindHttpTool.h"

@interface FindNotificationDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation FindNotificationDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"消息通知"; 
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:@"FindNotificatinDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"FindNotificatinDetailTableViewCell"];
    
    [self getData];
}

- (void)getData{
//    NSDictionary *dic = @{};
//    [LYFindHttpTool getNotificationMessageListWithParams:dic compelte:^(NSArray *dataArray) {
    
//    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FindNotificatinDetailTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"FindNotificatinDetailTableViewCell" forIndexPath:indexPath];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 73;
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
