//
//  ActionDetailViewController.m
//  lieyu
//
//  Created by 王婷婷 on 16/2/16.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//
//介绍活动详情页面

#import "ActionDetailViewController.h"
#import "HDDetailHeaderCell.h"
#import "UIImageView+WebCache.h"
#import "BeerBarOrYzhDetailModel.h"
#import "HDDetailImageCell.h"
#import "HDDetailFootCell.h"
#import "LYwoYaoDinWeiMainViewController.h"
@interface ActionDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    HDDetailImageCell *DetailImageCell;
}
@end

@implementation ActionDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.title = @"活动详情";
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = 100;
//    _actionID = @"7";
    if (_actionID) {
        [self getData];
    }
    [self registerCell];
//    [self configureRightItem];
}

- (void)configureRightItem{
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [button setImage:[UIImage imageNamed:@"share_black"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)registerCell{
    [self.tableView registerNib:[UINib nibWithNibName:@"HDDetailImageCell" bundle:nil] forCellReuseIdentifier:@"HDDetailImageCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HDDetailHeaderCell" bundle:nil] forCellReuseIdentifier:@"HDDetailHeaderCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HDDetailFootCell" bundle:nil] forCellReuseIdentifier:@"HDDetailFootCell"];
}

- (void)getData{
    NSDictionary *dict = @{@"id":_actionID};
    [LYHomePageHttpTool getActionDetail:dict complete:^(BarActivityList *action) {
        _barActivity = action;
        [self.tableView reloadData];
    }];
}

#pragma mark - 分享
- (void)shareAction{
//微信，微博，朋友圈
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    if (self.navigationController.navigationBar.hidden == YES) {
        [self.navigationController.navigationBar setHidden:NO];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_barActivity) {
        return 3;
    }else{
        return 0;
    }
}

- (NSDictionary *)feedBackDictionary{
    NSDictionary *dict = @{@"startTime":_barActivity.beginDate,
                           @"endTime":_barActivity.endDate,
                           @"address":_barActivity.barInfo.address,
                           @"latitude":_barActivity.barInfo.latitude,
                           @"longitude":_barActivity.barInfo.longitude,
                           @"environment":_barActivity.environment,
                           @"music":_barActivity.music};
    return dict;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        DetailImageCell = [[[NSBundle mainBundle]loadNibNamed:@"HDDetailImageCell" owner:nil options:nil]firstObject];
        [DetailImageCell configureImageView:_barActivity.imageUrl];
        DetailImageCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return DetailImageCell;
    }else if (indexPath.section == 1){
        HDDetailHeaderCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"HDDetailHeaderCell" owner:nil options:nil]firstObject];
        cell.dict = [self feedBackDictionary];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        HDDetailFootCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"HDDetailFootCell" owner:nil options:nil]firstObject];
        cell.decriptLbl.text = _barActivity.content;
//      cell.decriptLbl.text = @"fjdkshakjfdhsfhsdkjhfjsfgkdsiuoewuroipweutrihdjskfkdlsanfjdkslhfjkladhsjklfhdsajfhlkdshfkljhakdshlfkdhsajlkfhdklsjhfkyuyroietyireytuiowrhfjlkdsvnl,vnkjshjfklhgfdlsjgl;jwoiretpuuriehjgllskghfjkdlhgjklfdhlgjkhfugoeujfsljfkldjglfdhgiurheuihrkjlehjkrehgljkfjdkshakjfdhsfhsdkjhfjsfgkdsiuoewuroipweutrihdjskfkdlsanfjdkslhfjkladhsjklfhdsajfhlkdshfkljhakdshlfkdhsajlkfhdklsjhfkyuyroietyireytuiowrhfjlkdsvnl,vnkjshjfklhgfdlsjgl;jwoiretpuuriehjgllskghfjkdlhgjklfdhlgjkhfugoeujfsljfkldjglfdhgiurheuihrkjlehjkrehgljkfjdkshakjfdhsfhsdkjhfjsfgkdsiuoewuroipweutrihdjskfkdlsanfjdkslhfjkladhsjklfhdsajfhlkdshfkljhakdshlfkdhsajlkfhdklsjhfkyuyroietyireytuiowrhfjlkdsvnl,vnkjshjfklhgfdlsjgl;jwoiretpuuriehjgllskghfjkdlhgjklfdhlgjkhfugoeujfsljfkldjglfdhgiurheuihrkjlehjkrehgljk";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.000001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return 6;
    }else{
        return 0.000001;
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (_tableView.contentSize.height < SCREEN_HEIGHT - 113) {
        _tableView.scrollEnabled = NO;
    }
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.section == 0) {
//        
//    }else if (indexPath.section == 1){
//        return 115;
//    }else{
//        return 200;
//    }
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - 查看套餐
- (IBAction)YuDingClick:(UIButton *)sender {
    LYwoYaoDinWeiMainViewController *woYaoDinWeiMainViewController=[[LYwoYaoDinWeiMainViewController alloc]initWithNibName:@"LYwoYaoDinWeiMainViewController" bundle:nil];
    woYaoDinWeiMainViewController.barid=[_barActivity.barInfo.id intValue];
    woYaoDinWeiMainViewController.startTime = _barActivity.barInfo.startTime;
    woYaoDinWeiMainViewController.endTime = _barActivity.barInfo.endTime;
    [self.navigationController pushViewController:woYaoDinWeiMainViewController animated:YES];
    [MTA trackCustomKeyValueEvent:LYCLICK_MTA props:[self createMTADctionaryWithActionName:@"跳转" pageName:@"活动详情" titleName:@"我要订位"]];
}
@end
