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
//    self.selectionStyle = UITableViewCellSelectionStyleNone;
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
    managerInfo.selectionStyle = UITableViewCellSelectionStyleNone;
    if(indexPath.row == 0 && !notFirstLayout){
        ((ZSDetailModel *)self.managerList[indexPath.row]).issel = true;
        notFirstLayout = YES;
    }
    managerInfo.zsDetail = self.managerList[indexPath.row];
    [managerInfo cellConfigure:(int)indexPath.row];
    managerInfo.chooseBtn.tag = indexPath.row;
    
    [managerInfo.chooseBtn addTarget:self action:@selector(chooseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    return managerInfo;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 87;
}

- (void)chooseBtnClick:(UIButton *)sender{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    [self changeButtonImage:indexPath];
}


- (void)changeButtonImage:(NSIndexPath *)indexPath{
//    for(int i = 0 ; i < self.managerList.count ; i ++){
//        ManagerInfoCell *manager = [self.tableVIew cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
//        if(indexPath.row == i && indexPath.section == 0){
//            manager.radioButon.selected = YES;
//            [manager.radioButon setImage:[UIImage imageNamed:@"CustomBtn_Selected"] forState:UIControlStateSelected];
//        }else{
//            manager.radioButon.selected = NO;
//            [manager.radioButon setImage:[UIImage imageNamed:@"CustomBtn_unSelected"] forState:UIControlStateNormal];
//        }
//    }
    [self.tableVIew reloadData];
    [self.delegate selectManager:(int)indexPath.row];
}

- (void)showButtonImage:(id)sender{
    NSIndexPath *indexPath = self.tableVIew.indexPathForSelectedRow;
    NSLog(@"%@",indexPath);
    
    [self changeButtonImage:indexPath];
}

@end
