//
//  ZSMyClientsViewController.m
//  lieyu
//
//  Created by SEM on 15/9/16.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "ZSMyClientsViewController.h"
#import "CustomerCell.h"
#import "CustomerModel.h"
#import "ZSCustomerDetailViewController.h"
#import "ZSManageHttpTool.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "LYAddressBook.h"
#import "LYAddFriendByAddressBookViewController.h"
#import "AddressBookModel.h"
#import "ZSManageHttpTool.h"

@interface ZSMyClientsViewController ()
{
    BOOL _isFilter;
}
@end

@implementation ZSMyClientsViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title=@"我的客户";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO];
    [self.view setBackgroundColor:COMMON_GRAY];
    
    _listContent = [NSMutableArray new];
    _filteredListContent = [NSMutableArray new];
    
    [_searchBar setBackgroundImage:[UIImage new]];
    _searchBar.delegate = self;
    _searchBar.returnKeyType = UIReturnKeySearch;
    
    [self getMyCustomerslist];
    [self initRightItemsButton];
}

#pragma mark - 初始化顶部右侧按钮
- (void)initRightItemsButton{
    UIButton *addButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [addButton setImage:[UIImage imageNamed:@"add5"] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addClient:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc]initWithCustomView:addButton];
    self.navigationItem.rightBarButtonItem = addItem;
}


#pragma mark - 按钮事件
- (void)addClient:(UIButton *)button{
    LYAddressBook *addressBook = [[LYAddressBook alloc]init];
    NSMutableArray *updateArray = [[NSMutableArray alloc]init];
    NSArray *array = [addressBook getAddressBook];
    if (array.count <= 0) {
        [MyUtil showPlaceMessage:@"未获取到联系人！"];
    }else{
        for (AddressBookModel *userModel in array) {
            NSDictionary *dict = @{@"mobile":userModel.mobile,
                                   @"name":userModel.name,
                                   @"birthday":userModel.birthday,
                                   @"headUrl":@""};
            [updateArray addObject:dict];
        }
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:updateArray options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSDictionary *dict = @{@"isBirthdayImport":@"0",//0是否，1是
                               @"phonebookVoList":jsonString};
        __weak __typeof(self) weakSelf = self;
        [[ZSManageHttpTool shareInstance]zsImportAddressBookWithParams:dict complete:^(NSArray *dataList) {
            LYAddFriendByAddressBookViewController *addFriendByAddressBookVC =  [[LYAddFriendByAddressBookViewController alloc]initWithNibName:@"LYAddFriendByAddressBookViewController" bundle:[NSBundle mainBundle]];
            [weakSelf.navigationController pushViewController:addFriendByAddressBookVC animated:YES];
            addFriendByAddressBookVC.dataList = [[NSMutableArray alloc]initWithArray:dataList];
        }];
    }
}


-(void)getMyCustomerslist{
    [_listContent removeAllObjects];
    __weak __typeof(self)weakSelf = self;
    NSDictionary *dic=@{@"userid":[NSString stringWithFormat:@"%d",self.userModel.userid]};
    [[ZSManageHttpTool shareInstance] getUsersFriendWithParams:dic block:^(NSMutableArray *result) {
        LYAddressBook *addressBook = [[LYAddressBook alloc]init];
        _listContent = [addressBook getCustomArrayToSectionArray:result];
        [weakSelf.tableView reloadData];
    }];

}

#pragma mark - tableview代理方法
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (_isFilter) {
        return nil;
    } else {
        return [[NSArray arrayWithObject:UITableViewIndexSearch] arrayByAddingObjectsFromArray:
                [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles]];
    }
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (_isFilter) {
        return 0;
    } else {
        if (title == UITableViewIndexSearch) {
            return -1;
        } else {
            return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index-1];
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_isFilter) {
        return 1;
    } else {
        return [_listContent count];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (_isFilter) {
        return nil;
    } else {
        return [[_listContent objectAtIndex:section] count] ? [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section] : nil;
    }
}
/*
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView != self.searchDisplayController.searchResultsTableView) {
        NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
        if (sectionTitle == nil) {
            return nil;
        }
        
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(20, 0, 320, 20);
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.shadowColor = [UIColor grayColor];
        label.shadowOffset = CGSizeMake(-1.0, 1.0);
        label.font = [UIFont boldSystemFontOfSize:20];
        label.textColor=[self colorWithHexString:@"#BDE2E5"];
        label.text = sectionTitle;
        
        UIImageView *xiaxianView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 22,320, 3)];
        xiaxianView.image=[UIImage imageNamed:@"分割线-深"];
        UIView *view = [[UIView alloc] init];
        view.backgroundColor=[self colorWithHexString:@"#00000000"];
        [view addSubview:label];
        [view addSubview:xiaxianView];
        return view;
    }
    return nil;
}
*/
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_isFilter)
        return 0;
    return [[_listContent objectAtIndex:section] count] ? 32 : 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (_isFilter) {
        return nil;
    }else{
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 32)];
        [view setBackgroundColor:COMMON_GRAY];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 10, 32)];
        [label setTextColor:[UIColor darkTextColor]];
        [label setFont:[UIFont systemFontOfSize:16]];
        [label setText:[[_listContent objectAtIndex:section] count] ? [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section] : nil];
        [view addSubview:label];
        return view;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 55;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_isFilter) {
        return [_filteredListContent count];
    } else {
        return [[_listContent objectAtIndex:section] count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CustomerCell";
    
    CustomerCell *cell = (CustomerCell *)[_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = (CustomerCell *)[nibArray objectAtIndex:0];
        cell.backgroundColor=[UIColor whiteColor];
    }
    CustomerModel *addressBook = nil;
    if (_isFilter)
        addressBook = (CustomerModel *)[_filteredListContent objectAtIndex:indexPath.row];
    else
        addressBook = (CustomerModel *)[[_listContent objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if ([[addressBook.username stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] > 0) {
        cell.nameLal.text = addressBook.username;
    } else {
        cell.nameLal.text = @"No Name";
    }
    if (![MyUtil isEmptyString:addressBook.ordernum]&&![@"null" isEqualToString:addressBook.ordernum]) {
        cell.countLal.text=addressBook.ordernum;
    }else{
        cell.countLal.text=@"0";
    }
    [cell.cusImageView setImageWithURL:[NSURL URLWithString:addressBook.avatar_img]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomerModel *addressBook = nil;
    if (_isFilter) {
        addressBook = (CustomerModel*)[_filteredListContent objectAtIndex:indexPath.row];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    else {
        addressBook = (CustomerModel*)[[_listContent objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    ZSCustomerDetailViewController *customerDetailsViewController=[[ZSCustomerDetailViewController alloc]initWithNibName:@"ZSCustomerDetailViewController" bundle:nil];
    customerDetailsViewController.customerModel=addressBook;
    [self.navigationController pushViewController:customerDetailsViewController animated:YES];
    //WTT
    [_searchBar resignFirstResponder];
}



#pragma mark - scrollView代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    if (!_isFilter) {
//        _searchBar.text = @"";
//    }
    [_searchBar resignFirstResponder];
}

#pragma mark UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchText.length == 0) {
        [_searchBar resignFirstResponder];
        _isFilter = NO;
        [self.tableView reloadData];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self filterContentForSearchText:_searchBar.text scope:nil];
}

#pragma mark -
#pragma mark ContentFiltering

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    _isFilter = YES;
    [_filteredListContent removeAllObjects];
    for (NSArray *section in _listContent) {
        for (CustomerModel *addressBook in section)
        {
            NSComparisonResult result = [addressBook.username compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
            if (result == NSOrderedSame)
            {
                [_filteredListContent addObject:addressBook];
            }
        }
    }
    [self.tableView reloadData];
}

#pragma mark UISearchDisplayControllerDelegate

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
