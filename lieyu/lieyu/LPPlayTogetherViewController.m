//
//  LPPlayTogetherViewController.m
//  lieyu
//
//  Created by 王婷婷 on 15/12/1.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LPPlayTogetherViewController.h"
#import "BarInfoTableViewCell.h"
#import "TaocanTableViewCell.h"
#import "AddressTableViewCell.h"
#import "BitianTableViewCell.h"
#import "ContentTableViewCell.h"
#import "LiuchengTableViewCell.h"

@interface LPPlayTogetherViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation LPPlayTogetherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        BarInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"barInfo"];
        if(!cell){
            cell = [[[NSBundle mainBundle]loadNibNamed:@"BarInfoTableViewCell" owner:nil options:nil]firstObject];
        }
        return cell;
    }else if(indexPath.row == 1){
        TaocanTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"taoCan"];
        if(!cell){
            cell = [[[NSBundle mainBundle]loadNibNamed:@"TaocanTableViewCell" owner:nil options:nil]firstObject];
        }
        return cell;
    }else if(indexPath.row == 2){
        AddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"address"];
        if(!cell){
            cell = [[[NSBundle mainBundle]loadNibNamed:@"AddressTableViewCell" owner:nil options:nil]firstObject];
        }
        return cell;
    }else if(indexPath.row == 3){
        BitianTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"biTian"];
        if(!cell){
            cell = [[[NSBundle mainBundle]loadNibNamed:@"BitianTableViewCell" owner:nil options:nil]firstObject];
        }
        return cell;
    }else if(indexPath.row == 4){
        ContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"content"];
        if(!cell){
            cell = [[[NSBundle mainBundle]loadNibNamed:@"ContentTableViewCell" owner:nil options:nil]firstObject];
        }
        return cell;
    }else{
        LiuchengTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"liucheng"];
        if(!cell){
            cell = [[[NSBundle mainBundle]loadNibNamed:@"LiuchengTableViewCell" owner:nil options:nil]firstObject];
        }
        return cell;
    }
    return nil;
}
@end
