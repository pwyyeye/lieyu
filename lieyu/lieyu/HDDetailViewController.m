//
//  HDDetailViewController.m
//  lieyu
//
//  Created by 王婷婷 on 16/1/31.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "HDDetailViewController.h"
#import "HeaderTableViewCell.h"
#import "HDDetailTableViewCell.h"
#import "JoinedTableViewCell.h"
#import "LYDinWeiTableViewCell.h"


@interface HDDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) HeaderTableViewCell *headerCell;
@property (nonatomic, strong) LYDinWeiTableViewCell *LYdwCell;
@property (nonatomic, strong) HDDetailTableViewCell *HDDetailCell;
@property (nonatomic, strong) JoinedTableViewCell *joinedCell;

@end

@implementation HDDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self registerCell];
}

- (void)registerCell{
    [self.tableView registerNib:[UINib nibWithNibName:@"HeaderTableViewCell" bundle:nil] forCellReuseIdentifier:@"HeaderTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"LYDinWeiTableViewCell" bundle:nil] forCellReuseIdentifier:@"LYDinWeiTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HDDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"HDDetailTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"JoinedTableViewCell" bundle:nil] forCellReuseIdentifier:@"JoinedTableViewCell"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return _headerCell;
    }else if (indexPath.section == 1){
        return _LYdwCell;
    }else if(indexPath.section == 2){
        return _HDDetailCell;
    }else if(indexPath.section == 3){
        [_joinedCell configureJoinedNumber];
        return _joinedCell;
    }else if(indexPath.section == 4){
        [_joinedCell configureMessage];
        return _joinedCell;
    }else if (indexPath.section == 5){
        [_joinedCell configureMoreAction];
        return _joinedCell;
    }else{
        return nil;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 8;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
