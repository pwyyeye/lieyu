
//
//  LPBuyViewController.m
//  lieyu
//
//  Created by 王婷婷 on 15/12/2.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LPBuyViewController.h"

#import "LPBuyTaocanCell.h"
#import "LPBuyPriceCell.h"
#import "LPBuyInfoCell.h"
#import "ContentTableViewCell.h"
#import "LPBuyManagerCell.h"

//2.7.3 【0002】task=lyUsersVipStoreAction?action=list (已可用) 请求所有的专属经理列表
//2.7.4 【R0002】反馈所有专属经理列表
//2.7.7 【0004】task=lyUsersVipStoreAction?action=list (已可用) 请求用户收藏的专属经理列表
//2.7.8 【R0004】反馈用户收藏的专属经理列表

@interface LPBuyViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) LPBuyTaocanCell *buyTaocanCell;
@property (nonatomic, strong) LPBuyPriceCell *buyPriceCell;
@property (nonatomic, strong) LPBuyInfoCell *buyInfoCell;
@property (nonatomic, strong) ContentTableViewCell *contentCell;
@property (nonatomic, strong) LPBuyManagerCell *managerCell;
@end

@implementation LPBuyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"确认拼客订单";
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"leftBackItem"] style:UIBarButtonItemStylePlain target:self action:@selector(backClick)];
    self.navigationItem.leftBarButtonItem = backBtn;
}

- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        return 70;
    }else if(indexPath.section == 1){
        return 40;
    }else if(indexPath.section == 2){
        return 187;
    }else if(indexPath.section == 3){
        return 100;
    }else{
        return 100;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        LPBuyTaocanCell *cell = [tableView dequeueReusableCellWithIdentifier:@"buyTaocan"];
        if(!cell){
//            [tableView registerNib:[UINib nibWithNibName:@"LPBuyTaocanCell" bundle:nil] forCellReuseIdentifier:@"buyTaocan"];
//            cell = [tableView dequeueReusableCellWithIdentifier:@"buyTaocan"];
            cell = [[[NSBundle mainBundle]loadNibNamed:@"LPBuyTaocanCell" owner:nil options:nil]firstObject];
        }
        return cell;
    }else if(indexPath.section == 1){
        _buyPriceCell = [tableView dequeueReusableCellWithIdentifier:@"buyPrice"];
        if(!_buyPriceCell){
            [tableView registerNib:[UINib nibWithNibName:@"LPBuyPriceCell" bundle:nil] forCellReuseIdentifier:@"buyPrice"];
            _buyPriceCell = [tableView dequeueReusableCellWithIdentifier:@"buyPrice"];
        }
        return _buyPriceCell;
    }else if(indexPath.section == 2){
        _buyInfoCell = [tableView dequeueReusableCellWithIdentifier:@"buyInfo"];
        if(!_buyInfoCell){
            [tableView registerNib:[UINib nibWithNibName:@"LPBuyInfoCell" bundle:nil] forCellReuseIdentifier:@"buyInfo"];
            _buyInfoCell = [tableView dequeueReusableCellWithIdentifier:@"buyInfo"];
        }
        return _buyInfoCell;
    }else if(indexPath.section == 3){
        _contentCell = [tableView dequeueReusableCellWithIdentifier:@"content"];
        if (!_contentCell) {
            [tableView registerNib:[UINib nibWithNibName:@"ContentTableViewCell" bundle:nil] forCellReuseIdentifier:@"content"];
            _contentCell = [tableView dequeueReusableCellWithIdentifier:@"content"];
        }
        return _contentCell;
    }else{
        _managerCell = [tableView dequeueReusableCellWithIdentifier:@"buyManager"];
        if(!_managerCell){
            [tableView registerNib:[UINib nibWithNibName:@"LPBuyManagerCell" bundle:nil] forCellReuseIdentifier:@"buyManager"];
            _managerCell = [tableView dequeueReusableCellWithIdentifier:@"buyManager"];
        }
        return _managerCell;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
