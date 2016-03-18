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
#import "FindNotificationNextDetailViewController.h"
#import "FindNewMessageList.h"

@interface FindNotificationDetailViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSArray *_dataArray;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation FindNotificationDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.navigationItem.title = @"消息通知";  
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:@"FindNotificatinDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"FindNotificatinDetailTableViewCell"];
    
    [self getData];
}
- (void)getData{
    NSDictionary *dic = @{@"type":_type};
    __weak __typeof(self) weakSelf = self;
    [LYFindHttpTool getNotificationMessageListWithParams:dic compelte:^(NSArray *dataArray) {
        _dataArray = dataArray;
        [weakSelf.tableView reloadData];
        if (dataArray.count) {
            NSDictionary *dic = @{@"type":_type,@"read":@"1"};
            [LYFindHttpTool NotificationMessageListReadedWithParams:dic compelte:nil];
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FindNotificatinDetailTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"FindNotificatinDetailTableViewCell" forIndexPath:indexPath];
    FindNewMessageList *findNewMessList = _dataArray[indexPath.row];
    cell.findMessList = findNewMessList;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     FindNewMessageList *findNewMessList = _dataArray[indexPath.row];
    FindNotificationNextDetailViewController *findNextDetailVC = [[FindNotificationNextDetailViewController alloc]init];
    findNextDetailVC.findNewList = findNewMessList;
    [self.navigationController pushViewController:findNextDetailVC animated:YES];
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
