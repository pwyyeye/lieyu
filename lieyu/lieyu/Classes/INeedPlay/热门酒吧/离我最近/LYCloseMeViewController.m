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

@interface LYCloseMeViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation LYCloseMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"离我最近";
    [self.tableView registerNib:[UINib nibWithNibName:@"LYWineBarCell" bundle:nil] forCellReuseIdentifier:@"wineBarCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.beerBarArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LYWineBarCell *cell = [tableView dequeueReusableCellWithIdentifier:@"wineBarCell" forIndexPath:indexPath];
    cell.jiuBaModel = self.beerBarArray[indexPath.row];
    NSLog(@"------->%@",cell.jiuBaModel.distance);
    return cell;
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
