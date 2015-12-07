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

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}

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
    ManagerInfoCell *managerInfo = [tableView dequeueReusableCellWithIdentifier:@"managerInfo"];
    if(!managerInfo){
        [tableView registerNib:[UINib nibWithNibName:@"ManagerInfoCell" bundle:nil] forCellReuseIdentifier:@"managerInfo"];
        managerInfo = [tableView dequeueReusableCellWithIdentifier:@"managerInfo"];
    }
    managerInfo.zsDetail = self.managerList[indexPath.row];
    [managerInfo cellConfigure:(int)indexPath.row];
//    if(indexPath.row == 0){
//        managerInfo.radioButon.selected = YES;
//        [managerInfo.radioButon setImage:[UIImage imageNamed:@"CustomBtn_Selected"] forState:UIControlStateSelected];
//    }
    return managerInfo;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 87;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self showButtonImage:self];
}

- (void)showButtonImage:(id)sender{
    NSIndexPath *indexPath = self.tableVIew.indexPathForSelectedRow;
    for(int i = 0 ; i < self.managerList.count ; i ++){
        ManagerInfoCell *manager = [self.tableVIew cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        if([NSIndexPath indexPathForRow:i inSection:0] == indexPath){
            manager.radioButon.selected = YES;
            [manager.radioButon setImage:[UIImage imageNamed:@"CustomBtn_Selected"] forState:UIControlStateSelected];
        }else{
            manager.radioButon.selected = NO;
            [manager.radioButon setImage:[UIImage imageNamed:@"CustomBtn_unSelected"] forState:UIControlStateNormal];
        }
    }
    [self.delegate selectManager:(int)indexPath.row];
}

@end
