//
//  LYMessageDetailViewController.m
//  lieyu
//
//  Created by 狼族 on 15/12/27.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYFriendsMessageDetailViewController.h"
#import "LYFriendsHeaderTableViewCell.h"
#import "LYFriendsLikeDetailTableViewCell.h"
#import "LYFriendsHttpTool.h"

#define LYFriendsHeaderCellID @"LYFriendsHeaderTableViewCell"
#define LYFriendsLikeDetailCellID @"LYFriendsLikeDetailTableViewCell"

@interface LYFriendsMessageDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation LYFriendsMessageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupAllProperty];
    [self setupTableView];
    
   
}

- (void)setupAllProperty{
    [self getData];
}

- (void)getData{
    __block LYFriendsMessageDetailViewController *weakSelf = self;

}

- (void)setupTableView{
    NSArray *cellIDArray = @[LYFriendsHeaderCellID,LYFriendsLikeDetailCellID];
    for (NSString *cellID in cellIDArray) {
        [self.tableView registerNib:[UINib nibWithNibName:cellID bundle:nil] forCellReuseIdentifier:cellID];
    }
}

#pragma mark -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
            LYFriendsHeaderTableViewCell *headerCell = [tableView dequeueReusableCellWithIdentifier:LYFriendsHeaderCellID forIndexPath:indexPath];
            headerCell.recentM = _recentM;
            
            return headerCell;
        }
            break;
            
        default:{
        
            LYFriendsLikeDetailTableViewCell *likeCell = [tableView dequeueReusableCellWithIdentifier:LYFriendsLikeDetailCellID forIndexPath:indexPath];
            return likeCell;
        }
            break;
    }
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            return 189;
            break;

            
        default:
            return 82;
            break;
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
