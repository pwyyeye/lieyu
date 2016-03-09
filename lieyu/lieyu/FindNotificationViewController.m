//
//  FindNotificationViewController.m
//  lieyu
//
//  Created by 狼族 on 16/3/8.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "FindNotificationViewController.h"
#import "FindNotificationTableViewCell.h"
#import "FindNotificationDetailViewController.h"
#import "MyMessageListViewController.h"

@interface FindNotificationViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSArray *_titleArray,*_titleImageArray;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation FindNotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.title = @"消息通知";
    _titleArray = @[@"表白",@"评论",@"打招呼",@"系统通知"];
    _titleImageArray = @[@"表白",@"评论",@"打招呼",@"打招呼"];
    _tableView.separatorColor = UITableViewCellSeparatorStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:@"FindNotificationTableViewCell" bundle:nil] forCellReuseIdentifier:@"FindNotificationTableViewCell"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FindNotificationTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"FindNotificationTableViewCell" forIndexPath:indexPath];
    cell.label_title.text = _titleArray[indexPath.row];
    cell.imgView.image = [UIImage imageNamed:_titleImageArray[indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 2) {
        AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        MyMessageListViewController *messageListViewController=[[MyMessageListViewController alloc]initWithNibName:@"MyMessageListViewController" bundle:nil];
        messageListViewController.title=@"信息中心";
        [app.navigationController pushViewController:messageListViewController animated:YES];
    }else{
        FindNotificationDetailViewController *notificationDetailVC = [[FindNotificationDetailViewController alloc]init];
        [self.navigationController pushViewController:notificationDetailVC animated:YES];
    }
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
