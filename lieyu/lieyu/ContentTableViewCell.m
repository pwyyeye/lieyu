//
//  ContentTableViewCell.m
//  lieyu
//
//  Created by 王婷婷 on 15/12/1.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "ContentTableViewCell.h"
#import "DetailTableViewCell.h"

@interface ContentTableViewCell()

@end


@implementation ContentTableViewCell

- (void)awakeFromNib {
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.goodList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"goodlist[%ld]:%@",indexPath.row,self.goodList[indexPath.row]);
//    DetailTableViewCell *detail = [tableView dequeueReusableCellWithIdentifier:@""];
//    [detail configureCell:self.goodList[indexPath.row]];
    
    return nil;
}

@end
