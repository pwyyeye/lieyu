//
//  ZSAddressBookAddViewController.m
//  lieyu
//
//  Created by 王婷婷 on 16/8/23.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "ZSAddressBookAddViewController.h"
#import <AddressBook/AddressBook.h>
#import "AddressBookModel.h"
#import "LYAddressBook.h"
#import "ZSBirthdayTableViewCell.h"
#import "ZSManageHttpTool.h"
#import "LYAddFriendByAddressBookViewController.h"

@interface ZSAddressBookAddViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (nonatomic, strong) NSMutableArray *addressArray;
@property (nonatomic, strong) NSString *updateString;

@property (nonatomic, strong) NSMutableArray *selectedArray;
@property (nonatomic, assign) NSInteger *selectedCount;
@property (nonatomic, assign) NSInteger *totalCount;


//筛选
@property (nonatomic, strong) NSMutableArray *filterList;
@property (nonatomic, assign) BOOL isFiltered;
@property (nonatomic, strong) NSMutableArray *filterSelectedArray;
@property (nonatomic, assign) NSInteger *filterSelectedCount;
@property (nonatomic, assign) NSInteger *filterTotalCount;

@end

@implementation ZSAddressBookAddViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = @"生日添加";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _addressArray = [[NSMutableArray alloc]init];
    _selectedArray = [[NSMutableArray alloc]init];
    LYAddressBook *addressBook = [[LYAddressBook alloc]init];
    NSArray *tempArray = [addressBook getAddressBook];
//    _addressArray = [addressBook getUserModelArrayToSectionArray:[NSMutableArray arrayWithArray:tempArray]];
    _addressArray = [addressBook getAddressBookModelArrayToSectionArray:[NSMutableArray arrayWithArray:tempArray]];
    for (int i = 0 ; i < _addressArray.count; i ++) {
        NSMutableArray *tempArray = [NSMutableArray array];
        NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[_addressArray objectAtIndex:i]];
        for (int j = 0 ; j < array.count; j ++) {
            [tempArray addObject:@"1"];
            _selectedCount ++ ;
        }
        [_selectedArray addObject:tempArray];
    }
    _totalCount = _selectedCount;
    [_tableView registerNib:[UINib nibWithNibName:@"ZSBirthdayTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ZSBirthdayTableViewCell"];
//    _addressArray = [addressBook getAddressBook];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _searchBar.delegate = self;
    [_allSelectButton addTarget:self action:@selector(allSelectedButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_allSelectButton setSelected:YES];
    [self initRightItemButton];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    [self allSelectedButtonClick];
}


- (void)initRightItemButton{
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [button setTitle:@"导出" forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [button addTarget:self action:@selector(addPeople) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = item;
}

#pragma mark - tableview的代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_isFiltered) {
        return 1;
    }else{
        return _addressArray.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_isFiltered) {
        return [_filterList count];
    }else{
        return [((NSMutableArray *)[_addressArray objectAtIndex:section]) count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZSBirthdayTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"ZSBirthdayTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    UserModel *userModel;
    AddressBookModel *userModel;
    if (_isFiltered) {
        userModel = [_filterList objectAtIndex:indexPath.row];
        if ([[_filterSelectedArray objectAtIndex:indexPath.row] isEqualToString:@"0"]) {
            cell.isSelected = NO;
        }else{
            cell.isSelected = YES;
        }
    }else{
        userModel = [((NSMutableArray *)[_addressArray objectAtIndex:indexPath.section]) objectAtIndex:indexPath.row];
        if ([[[_selectedArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] isEqualToString:@"0"]) {
            cell.isSelected = NO;
        }else{
            cell.isSelected = YES;
        }
    }
    cell.tempUserModel = userModel;
    cell.chooseButton.tag = indexPath.section * 100000 + indexPath.row;
    [cell.chooseButton addTarget:self action:@selector(chooseContacter:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (_isFiltered) {
        return nil;
    }else{
        return [[_addressArray objectAtIndex:section] count] ? [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section] : nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (_isFiltered) {
        return 0;
    }else{
        return [[_addressArray objectAtIndex:section] count] ? _tableView.sectionHeaderHeight : 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == _tableView) {
        [_searchBar resignFirstResponder];
    }
}


#pragma mark - searchBar的代理事件
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    _isFiltered = NO;
    [_allSelectButton setSelected:YES];
    [self.tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    _isFiltered = YES;
    [self filterContentForSearchText:searchBar.text];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchText.length <= 0) {
        [searchBar resignFirstResponder];
        _isFiltered = NO;
        [_allSelectButton setSelected:YES];
        [self.tableView reloadData];
    }else{
        _isFiltered = YES;
        [self filterContentForSearchText:searchText];
    }
}

#pragma mark - 筛选
- (void)filterContentForSearchText:(NSString *)searchText{
    _filterList = [[NSMutableArray alloc]init];
    for (NSArray *section in _addressArray) {
        for (AddressBookModel *addressBook in section) {
            if (addressBook.name.length >= searchText.length && searchText != nil) {
                NSComparisonResult result = [addressBook.name compare:searchText options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch range:NSMakeRange(0, [searchText length])];
                if (result == NSOrderedSame) {
                    [_filterList addObject:addressBook];
                }
            }
        }
    }
    _filterSelectedArray = [NSMutableArray array];
    for (int i = 0 ; i < _filterList.count; i ++) {
        [_filterSelectedArray addObject:@"1"];
        _filterSelectedCount ++;
    }
    _filterTotalCount = _filterSelectedCount;
    [_tableView reloadData];
}

#pragma mark - 按钮事件
- (void)allSelectedButtonClick{
    if (_allSelectButton.selected == YES) {
        [_allSelectButton setSelected:NO];
        if (_isFiltered) {
            for (int i = 0 ; i < _filterSelectedArray.count; i ++) {
                ZSBirthdayTableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                cell.isSelected = NO;
                [_filterSelectedArray replaceObjectAtIndex:i withObject:@"0"];
            }
            _filterSelectedCount = 0 ;
        }else{
            for (int i = 0 ; i < _selectedArray.count; i ++) {
                for (int j = 0 ; j < [[_selectedArray objectAtIndex:i] count]; j ++) {
                    ZSBirthdayTableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:j inSection:i]];
                    cell.isSelected = NO;
                    [[_selectedArray objectAtIndex:i] replaceObjectAtIndex:j withObject:@"0"];
                }
            }
            _selectedCount = 0 ;
        }
    }else{
        [_allSelectButton setSelected:YES];
        if (_isFiltered) {
            for (int i = 0 ; i < _filterSelectedArray.count; i ++) {
                ZSBirthdayTableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                cell.isSelected = YES;
                [_filterSelectedArray replaceObjectAtIndex:i withObject:@"1"];
            }
            _filterSelectedCount = _filterTotalCount;
        }else{
            for (int i = 0 ; i < _selectedArray.count; i ++) {
                for (int j = 0 ; j < [[_selectedArray objectAtIndex:i] count]; j ++) {
                    ZSBirthdayTableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:j inSection:i]];
                    cell.isSelected = YES;
                    [[_selectedArray objectAtIndex:i] replaceObjectAtIndex:j withObject:@"1"];
                }
            }
            _selectedCount = _totalCount;
        }
    }
}

- (void)chooseContacter:(UIButton *)button{
    NSInteger section  = button.tag / 100000;
    NSInteger row = button.tag % 100000;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    ZSBirthdayTableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
    //找到这个cell
    if (_isFiltered) {
        if([[_filterSelectedArray objectAtIndex:row] isEqualToString:@"0"]){
            [_filterSelectedArray replaceObjectAtIndex:row withObject:@"1"];
            cell.isSelected = YES;
            _filterSelectedCount ++ ;
        }else{
            [_filterSelectedArray replaceObjectAtIndex:row withObject:@"0"];
            cell.isSelected = NO;
            _filterSelectedCount -- ;
        }
        if (_filterTotalCount == _filterSelectedCount) {
            [_allSelectButton setSelected:YES];
        }else{
            [_allSelectButton setSelected:NO];
        }
    }else{
        if([[[_selectedArray objectAtIndex:section]objectAtIndex:row] isEqualToString:@"0"]){
            [[_selectedArray objectAtIndex:section] replaceObjectAtIndex:row withObject:@"1"];
            cell.isSelected = YES;
            _selectedCount ++ ;
        }else{
            [[_selectedArray objectAtIndex:section] replaceObjectAtIndex:row withObject:@"0"];
            cell.isSelected = NO;
            _selectedCount -- ;
        }
        if (_totalCount == _selectedCount) {
            [_allSelectButton setSelected:YES];
        }else{
            [_allSelectButton setSelected:NO];
        }
    }
}

- (void)addPeople{
    NSMutableArray *updateArray = [[NSMutableArray alloc]init];
    if (_isFiltered) {
        if(_filterSelectedCount <= 0){
            [MyUtil showPlaceMessage:@"请选择联系人"];
            return;
        }
        for (int i = 0 ; i < _filterSelectedArray.count; i ++) {
            if ([[_filterSelectedArray objectAtIndex:i] isEqualToString:@"1"]) {
                AddressBookModel *userModel = [_filterList objectAtIndex:i];
                NSDictionary *dict = @{@"mobile":userModel.mobile,
                                       @"name":userModel.name,
                                       @"birthday":userModel.birthday,
                                       @"headUrl":@""};
                [updateArray addObject:dict];
            }
        }
    }else{
        if(_selectedCount <= 0){
            [MyUtil showPlaceMessage:@"请选择联系人"];
            return;
        }
        for (int i = 0 ; i < _selectedArray.count; i ++) {
            for (int j = 0 ; j < [[_selectedArray objectAtIndex:i] count]; j ++) {
                if ([[[_selectedArray objectAtIndex:i] objectAtIndex:j] isEqualToString:@"1"]) {
                    AddressBookModel *userModel = [[_addressArray objectAtIndex:i] objectAtIndex:j];
                    NSDictionary *dict = @{@"mobile":userModel.mobile,
                                           @"name":userModel.name,
                                           @"birthday":userModel.birthday,
                                           @"headUrl":@""};
                    [updateArray addObject:dict];
                }
            }
        }
    }
    //将字典数组转换成json字符串
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:updateArray options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",jsonString);
    NSDictionary *dict = @{@"isBirthdayImport":@"1",//0是否，1是
                           @"phonebookVoList":jsonString};
    __weak __typeof(self) weakSelf = self;
    [[ZSManageHttpTool shareInstance]zsImportAddressBookWithParams:dict complete:^(NSArray *dataList) {
        LYAddFriendByAddressBookViewController *addFriendByAddressBookVC =  [[LYAddFriendByAddressBookViewController alloc]initWithNibName:@"LYAddFriendByAddressBookViewController" bundle:[NSBundle mainBundle]];
        [weakSelf.navigationController pushViewController:addFriendByAddressBookVC animated:YES];
        addFriendByAddressBookVC.dataList = [[NSMutableArray alloc]initWithArray:dataList];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
