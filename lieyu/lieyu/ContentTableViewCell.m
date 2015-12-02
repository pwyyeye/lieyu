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
//    self.goodList = [[NSArray alloc]init];
    
}

- (void)cellConfigure{
    NSLog(@"%@",self.goodList);
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
    DetailTableViewCell *detail = [tableView dequeueReusableCellWithIdentifier:@"detail"];
    if(!detail){
        detail = [[[NSBundle mainBundle]loadNibNamed:@"DetailTableViewCell" owner:nil
        options:nil]firstObject];
    }
    NSDictionary *dict = @{@"name":self.goodList[indexPath.row][@"_name"],@"price":self.goodList[indexPath.row][@"_price"],@"number":[NSString stringWithFormat:@"%@%@",self.goodList[indexPath.row][@"_num"],self.goodList[indexPath.row][@"_unit"]]};
    [detail configureCell:dict];
    return detail;
}

@end
