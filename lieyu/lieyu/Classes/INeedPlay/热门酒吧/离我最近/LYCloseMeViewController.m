//
//  LYCloseMeViewController.m
//  lieyu
//
//  Created by 狼族 on 15/12/4.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYCloseMeViewController.h"
#import "LYWineBarCell.h"
#import "JiuBaModel.h"
#import "BeerBarDetailViewController.h"

@interface LYCloseMeViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@end

@implementation LYCloseMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"离我最近";
    [self.tableView registerNib:[UINib nibWithNibName:@"LYWineBarCell" bundle:nil] forCellReuseIdentifier:@"wineBarCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _dataArray = [[NSMutableArray alloc]initWithCapacity:0];
    [_dataArray addObjectsFromArray:self.beerBarArray];
   _dataArray = [[_dataArray sortedArrayUsingSelector:@selector(compareJiuBaModel:)] mutableCopy];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.beerBarArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LYWineBarCell *cell = [tableView dequeueReusableCellWithIdentifier:@"wineBarCell" forIndexPath:indexPath];
    cell.jiuBaModel = _dataArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JiuBaModel *jiuba = _dataArray[indexPath.row];
    BeerBarDetailViewController *beerDetailVC = [[BeerBarDetailViewController alloc]init];
    beerDetailVC.beerBarId = @(jiuba.barid);
    [self.navigationController pushViewController:beerDetailVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 273;
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
