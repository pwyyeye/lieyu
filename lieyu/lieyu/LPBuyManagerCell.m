//
//  LPBuyManagerCell.m
//  lieyu
//
//  Created by 王婷婷 on 15/12/2.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LPBuyManagerCell.h"
#import "ManagerInfoCell.h"

@implementation LPBuyManagerCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)cellConfigure{
    self.tableVIew.dataSource = self;
    self.tableVIew.delegate = self;
    self.tableVIew.scrollEnabled = NO;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.managerList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ManagerInfoCell *managerInfo = [tableView dequeueReusableCellWithIdentifier:@""];
    if(!managerInfo){
        [tableView registerNib:[UINib nibWithNibName:@"" bundle:nil] forCellReuseIdentifier:@""];
        managerInfo = [tableView dequeueReusableCellWithIdentifier:@""];
    }
//    managerInfo ce
    return managerInfo;
}

@end
