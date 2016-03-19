//
//  ChooseTopicViewController.m
//  lieyu
//
//  Created by 王婷婷 on 16/3/18.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "ChooseTopicViewController.h"
#import "LYUserHttpTool.h"
#import "TopicModel.h"

@interface ChooseTopicViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    NSArray *dataArray;
}
@end

@implementation ChooseTopicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchBar.text = @"#";
    [self.searchBar becomeFirstResponder];
    self.searchBar.delegate = self;
    [self getData];
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
}

- (void)getData{
    NSDictionary *dict;
    if (_type) {
        if (_barid) {
            dict = @{@"barid":_barid,
                     @"type":_type};
        }else{
            dict = @{@"type":_type};
        }
    }else if(_barid){
        dict = @{@"barid":_barid};
    }else{
        dict = nil;
    }
    [LYUserHttpTool getTopicList:dict complete:^(NSArray *dataList) {
        dataArray = dataList;
        [self.myTableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableview代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchTopicCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"searchTopicCell"];
        cell.textLabel.text = [NSString stringWithFormat:@"#%@#",((TopicModel *)[dataArray objectAtIndex:indexPath.row]).name];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - searchBar代理
- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSLog(@"shouldChange:%@",text);
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSLog(@"didChange:%@",searchText);
}

- (IBAction)cancelClick:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
