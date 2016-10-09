//
//  LYFriendsRecommendViewController.m
//  lieyu
//
//  Created by 王婷婷 on 16/9/24.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYFriendsRecommendViewController.h"
#import "LYFriendsRecommendTableViewCell.h"
#import "LYUserHttpTool.h"

@interface LYFriendsRecommendViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UILabel *_kongLabel;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *bottomButton;
@property (nonatomic, strong) UIButton *allSelectButton;

@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, strong) NSMutableArray *selectedArray;

@property (nonatomic, assign) NSInteger selectedNumber;
@end

@implementation LYFriendsRecommendViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.title = @"推荐玩友";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:COMMON_GRAY];
    [self initKongLabel];
    [self initTableView];
    [self initRightButton];
    [self initBottomButton];
    [self getData];
}

#pragma mark - 顶部右侧按钮
- (void)initRightButton{
    _allSelectButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 44)];
    [_allSelectButton setTitle:@"全选" forState:UIControlStateNormal];
    [_allSelectButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [_allSelectButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_allSelectButton setImage:[UIImage imageNamed:@"CustomBtn_unSelected"] forState:UIControlStateNormal];
    [_allSelectButton setImage:[UIImage imageNamed:@"CustomBtn_Selected"] forState:UIControlStateSelected];
    [_allSelectButton addTarget:self action:@selector(allSelectButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_allSelectButton setSelected:YES];
    [_allSelectButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    [_allSelectButton setImageEdgeInsets:UIEdgeInsetsMake(0, 60, 0, -10)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_allSelectButton];
}

#pragma mark - tableview
- (void)initTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 102) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView setBackgroundColor:COMMON_GRAY];
    
    [_tableView registerNib:[UINib nibWithNibName:@"LYFriendsRecommendTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"LYFriendsRecommendTableViewCell"];
}

#pragma mark - 进入按钮
- (void)initBottomButton{
    _bottomButton = [[UIButton alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 102, SCREEN_WIDTH, 38)];
    [_bottomButton setBackgroundColor:COMMON_PURPLE];
    [_bottomButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [_bottomButton setTitle:@"进入猎娱" forState:UIControlStateNormal];
    [_bottomButton addTarget:self action:@selector(enterLieyu) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_bottomButton];
}

#pragma mark - 空界面
- (void)initKongLabel{
    _kongLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT / 2 - 50, SCREEN_WIDTH, 20)];
    [_kongLabel setTextAlignment:NSTextAlignmentCenter];
    [_kongLabel setTextColor:COMMON_PURPLE];
    [_kongLabel setFont:[UIFont systemFontOfSize:16]];
    [_kongLabel setText:@"无推荐玩友，请直接进入猎娱！"];
    [self.view addSubview:_kongLabel];
}

#pragma mark - getData
- (void)getData{
    _selectedArray = [[NSMutableArray alloc]init];
    [LYUserHttpTool lyRecommendFriendsWithParams:nil complete:^(NSArray *dataList) {
        if (dataList && dataList.count) {
            _dataList = [[NSMutableArray alloc]initWithArray:dataList];
            for (int i = 0 ; i < _dataList.count; i ++) {
                [_selectedArray addObject:@"1"];
            }
            _selectedNumber = _dataList.count;
            [_tableView reloadData];
        }else{
            _allSelectButton.hidden = YES;
            [_tableView removeFromSuperview];
        }
    }];
}

#pragma mark - tableview的代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_dataList.count) {
        return 1;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LYFriendsRecommendTableViewCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"LYFriendsRecommendTableViewCell" owner:nil options:nil]firstObject];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.userSelectButton.tag = indexPath.row;
    if ([[_selectedArray objectAtIndex:indexPath.row] isEqualToString:@"1"]) {
        [cell.userSelectButton setSelected:YES];
    }else{
        [cell.userSelectButton setSelected:NO];
    }
    [cell.userSelectButton addTarget:self action:@selector(selectedUser:) forControlEvents:UIControlEventTouchUpInside];
    cell.RecommendFriendModel = ((UserModel *)[_dataList objectAtIndex:indexPath.row]);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self selectUserWithIndex:indexPath.row];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.000001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 6;
}

#pragma mark - 选中事件
- (void)selectedUser:(UIButton *)button{
    [self selectUserWithIndex:button.tag];
}

- (void)selectUserWithIndex:(NSInteger) index{
    LYFriendsRecommendTableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    if (cell.userSelectButton.selected == YES) {
        [cell.userSelectButton setSelected:NO];
        [_selectedArray replaceObjectAtIndex:index withObject:@"0"];
        _selectedNumber -- ;
    }else{
        [cell.userSelectButton setSelected:YES];
        [_selectedArray replaceObjectAtIndex:index withObject:@"1"];
        _selectedNumber ++ ;
    }
    if (_selectedNumber >= _dataList.count) {
        [_allSelectButton setSelected:YES];
    }else{
        [_allSelectButton setSelected:NO];
    }
}

- (void)allSelectButtonClick{
    if (_allSelectButton.selected == YES) {
        [_allSelectButton setSelected:NO];
    }else{
        [_allSelectButton setSelected:YES];
    }
    for (int i = 0 ; i < _dataList.count; i ++) {
        LYFriendsRecommendTableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        if (_allSelectButton.selected == YES) {
            [cell.userSelectButton setSelected:YES];
            [_selectedArray replaceObjectAtIndex:i withObject:@"1"];
            _selectedNumber = _dataList.count;
        }else{
            [cell.userSelectButton setSelected:NO];
            [_selectedArray replaceObjectAtIndex:i withObject:@"0"];
            _selectedNumber = 0;
        }
    }
}

- (void)enterLieyu{
    __weak __typeof(self) weakSelf = self;
    if (_selectedNumber > 0) {
        int i = 0 ;
        NSMutableArray *array = [[NSMutableArray alloc]init];
        for (NSString *status in _selectedArray) {
            if ([status isEqualToString:@"1"]) {
                [array addObject:[NSString stringWithFormat:@"%d",((UserModel *)[_dataList objectAtIndex:i]).id]];
            }
            i ++;
        }
        NSDictionary *dict = @{@"followid":[array componentsJoinedByString:@","]};
        [LYUserHttpTool lyFollowRecommendFriendsWithOarams:dict complete:^(BOOL result) {
            if (result) {
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                [MyUtil showPlaceMessage:@"欢迎来到猎娱！"];
            }else{
                [MyUtil showPlaceMessage:@"添加失败，请稍后重试！"];
            }
        }];
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
        [MyUtil showPlaceMessage:@"欢迎来到猎娱！"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
