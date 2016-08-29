//
//  MineWithdrawListViewController.m
//  lieyu
//
//  Created by 王婷婷 on 16/8/19.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "MineWithdrawListViewController.h"

@interface MineWithdrawListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *withdrawAmountLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSString *withdrawAmount;

@property (nonatomic, strong) NSArray *listArray;
@end

@implementation MineWithdrawListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"提现记录";
    self.view.backgroundColor = RGBA(242, 242, 242, 1);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self getData];
}

#pragma mark - 设置tableview的上下刷新控件
- (void)setupTableViewRefresh{
    __weak __typeof(self) weakSelf = self;
    _tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        
    }];
}

- (void)getData{
    self.withdrawAmount = @"12231.43";
    if (_listArray.count <= 0) {
        _tableView.hidden = YES;
    }else{
        _tableView.hidden = NO;
        [_tableView reloadData];
    }
}

- (void)setWithdrawAmount:(NSString *)withdrawAmount{
    _withdrawAmount = withdrawAmount;
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"累计提现：%@元",_withdrawAmount]];
    [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 5)];
    [attributeString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, 5)];
    _withdrawAmountLabel.attributedText = attributeString;
}

#pragma mark - tableview的代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
