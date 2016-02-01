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
#import "LPAlertView.h"
#import "ChooseNumber.h"
#import "UIImageView+WebCache.h"

@interface HDDetailViewController ()<UITableViewDataSource,UITableViewDelegate,LPAlertViewDelegate>
@property (nonatomic, strong) HeaderTableViewCell *headerCell;
@property (nonatomic, strong) LYDinWeiTableViewCell *LYdwCell;
@property (nonatomic, strong) HDDetailTableViewCell *HDDetailCell;
@property (nonatomic, strong) JoinedTableViewCell *joinedCell;
@property (nonatomic, strong) ChooseNumber *chooseNumber;

@end

@implementation HDDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = [UIColor clearColor];
    [self registerCell];
    self.title = @"活动详情";
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
        _headerCell = [tableView dequeueReusableCellWithIdentifier:@"HeaderTableViewCell" forIndexPath:indexPath];
        [_headerCell.avatar_button.imageView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@""]];
        _headerCell.name_label.text = @"";
        _headerCell.viewNumber_label.text = @"";
        _headerCell.title_label.text = @"";
        _headerCell.selected = NO;
        return _headerCell;
    }else if (indexPath.section == 1){
        _LYdwCell = [tableView dequeueReusableCellWithIdentifier:@"LYDinWeiTableViewCell" forIndexPath:indexPath];
        [_LYdwCell.imageView_header sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@""]];
        _LYdwCell.label_name.text = @"";
        _LYdwCell.label_buyCount.text = @"";
        _LYdwCell.label_price_now.text = @"";
        _LYdwCell.label_price_old.text = @"";
        _LYdwCell.label_percent.text = @"";
        _LYdwCell.hotImage.hidden = NO;
        _LYdwCell.selected = NO;
        return _LYdwCell;
    }else if(indexPath.section == 2){
        _HDDetailCell = [tableView dequeueReusableCellWithIdentifier:@"HDDetailTableViewCell" forIndexPath:indexPath];
        _HDDetailCell.startTime_label.text = @"";
        _HDDetailCell.residue_label.text = @"";
        _HDDetailCell.joinedNumber_label.text = @"";
        _HDDetailCell.joinedpro_label.text = @"";
        _HDDetailCell.address_label.text = @"";
        _HDDetailCell.barName_label.text = @"";
        _HDDetailCell.selected = NO;
        return _HDDetailCell;
    }else if(indexPath.section == 3){
        _joinedCell = [tableView dequeueReusableCellWithIdentifier:@"JoinedTableViewCell" forIndexPath:indexPath];
        [_joinedCell configureJoinedNumber];
        _joinedCell.selected = NO;
        return _joinedCell;
    }else if(indexPath.section == 4){
        _joinedCell = [tableView dequeueReusableCellWithIdentifier:@"JoinedTableViewCell" forIndexPath:indexPath];
        [_joinedCell configureMessage];
        _joinedCell.selected = NO;
        return _joinedCell;
    }else if (indexPath.section == 5){
        _joinedCell = [tableView dequeueReusableCellWithIdentifier:@"JoinedTableViewCell" forIndexPath:indexPath];
        [_joinedCell configureMoreAction];
        _joinedCell.selected = NO;
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height;
    if (indexPath.section == 0) {
        _headerCell.title_label.font = [UIFont systemFontOfSize:14];
        _headerCell.title_label.text = @"我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我";
        CGSize size = [_headerCell.title_label.text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 146, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
        height = size.height + 51;
    }else if (indexPath.section == 1){
        height = 104;
    }else if(indexPath.section == 2){
        height = 200;
    }else if (indexPath.section == 3){
        return 100;
    }else if(indexPath.section == 4){
        return 100;
    }else if(indexPath.section == 5){
        return 320 / 16 * 9;
    }
    return height;
}

- (IBAction)WannaJoin:(UIButton *)sender {
    LPAlertView *alertView = [[LPAlertView alloc]initWithDelegate:self buttonTitles:@"取消", @"确定", nil];
    alertView.delegate = self;
    _chooseNumber = [[[NSBundle mainBundle]loadNibNamed:@"ChooseNumber" owner:nil options:nil]firstObject];
    _chooseNumber.tag = 14;
//    _chooseNumber.store = 2;
    _chooseNumber.frame = CGRectMake(10, SCREEN_HEIGHT - 320, SCREEN_WIDTH - 20, 250);
    alertView.contentView = _chooseNumber;
    [alertView show];
}

- (void)LPAlertView:(LPAlertView *)alertView clickedButtonAtIndexChooseNum:(NSInteger)buttonIndex{
    
}

@end
