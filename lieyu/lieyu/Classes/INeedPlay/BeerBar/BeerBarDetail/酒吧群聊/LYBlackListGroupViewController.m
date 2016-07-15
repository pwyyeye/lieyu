//
//  LYBlackListGroupViewController.m
//  lieyu
//
//  Created by 狼族 on 16/7/14.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBlackListGroupViewController.h"
#import "LYGroupPeopleTableViewCell.h"
#import "BlockListModel.h"
#import "LYYUHttpTool.h"

@interface LYBlackListGroupViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) NSArray *dataArray;
@end

@implementation LYBlackListGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [_myTableView registerNib:[UINib nibWithNibName:@"LYGroupPeopleTableViewCell" bundle:nil] forCellReuseIdentifier:@"LYGroupPeopleTableViewCell"];
    self.title = @"黑名单列表";
    _myTableView.dataSource = self;
    _myTableView.delegate = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getData{
    NSDictionary *dic = @{@"groupId":_groupID};
    __block LYBlackListGroupViewController *weekSelf = self;
    [LYYUHttpTool yuExpandAllLogInWith:dic complete:^(NSArray *Arr) {
        weekSelf.dataArray = Arr;
        dispatch_async(dispatch_get_main_queue(), ^{
             [weekSelf.myTableView reloadData];
            
        });
    }];
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LYGroupPeopleTableViewCell *cell = [_myTableView dequeueReusableCellWithIdentifier:@"LYGroupPeopleTableViewCell" forIndexPath:indexPath];
    BlockListModel *model=_dataArray[indexPath.row];
    cell.typeLabel.text = model.userId;
    cell.chatButton.titleLabel.text = @"解除";
    [cell.chatButton addTarget:self action:@selector(logoutPerson:) forControlEvents:(UIControlEventTouchUpInside)];
    return cell;
}

- (void) logoutPerson:(UIButton *) sender{
        LYGroupPeopleTableViewCell *cell=(LYGroupPeopleTableViewCell *)[[sender superview] superview];
        NSIndexPath *index=[_myTableView indexPathForCell:cell];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 71;
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
