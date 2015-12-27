//
//  LYFriendsMessageViewController.m
//  lieyu
//
//  Created by 狼族 on 15/12/25.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYFriendsMessageViewController.h"
#import "LYNewMessageTableViewCell.h"
#import "LYFriendsHttpTool.h"

#define LYFriendsNewMessage @"LYNewMessageTableViewCell"

@interface LYFriendsMessageViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation LYFriendsMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getData];
    [self setupTableViewCell];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}

- (void)setupTableViewCell{
    [self.tableView registerNib:[UINib nibWithNibName:LYFriendsNewMessage bundle:nil] forCellReuseIdentifier:LYFriendsNewMessage];
}

- (void)getData{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSString *userId = [NSString stringWithFormat:@"%d",app.userModel.userid];
    NSDictionary *paraDic = @{@"userId":userId,@"messageId":@""};
    [LYFriendsHttpTool friendsGetMyNewsMessageWithParams:paraDic compelte:^(FriendsUserMessageModel *messageModel) {
        
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor redColor];
    return cell;
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
