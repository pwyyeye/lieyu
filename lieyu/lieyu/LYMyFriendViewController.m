//
//  LYMyFriendViewController.m
//  lieyu
//
//  Created by 薛斯岐 on 15/10/28.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYMyFriendViewController.h"
#import "CustomerCell.h"
#import "LYUserHttpTool.h"
#import "LYMyFriendDetailViewController.h"
#import "LYSearchFriendViewController.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "LYAddressBook.h"
#import "ZSManageHttpTool.h"
#import "LYAddFriendByAddressBookViewController.h"
#import "AddressBookModel.h"
#import "FansCell.h"

#import "LYFriendsHttpTool.h"
#import "FriendsListModel.h"
#import "FansModel.h"


static NSString *fansCellID = @"fansCellID";
static NSString *CellIdentifier = @"CustomerCell";
@interface LYMyFriendViewController ()

@end

@implementation LYMyFriendViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.title=@"好友列表";
    _isOpen = NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(10, 0, 44, 44)];
    [button setImage:[UIImage imageNamed:@"add5"] forState:UIControlStateNormal];
    [view addSubview:button];
    [button addTarget:self action:@selector(moreAct:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:view];
    self.navigationItem.rightBarButtonItem = item;
    
//    rightBtn=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"add5"] style:UIBarButtonItemStylePlain target:self action:@selector(moreAct:)];
//    [self.navigationItem setRightBarButtonItem:rightBtn];

    _listContent = [NSMutableArray new];
    _filteredListContent = [NSMutableArray new];
    _fansListArray = [NSMutableArray new];
    self.tableView.tableFooterView=[[UIView alloc]init];//去掉多余的分割线
     _searchBar.barTintColor=[UIColor whiteColor];
    [self getMyCustomerslist];
    // Do any additional setup after loading the view from its nib.
}


-(void)getMyCustomerslist{
    [_listContent removeAllObjects];
    __weak __typeof(self)weakSelf = self;
    [LYFriendsHttpTool getfFriensGroupWithPrams:nil complete:^(NSDictionary *dict) {
        NSMutableArray *addressBookTemp = [[NSMutableArray array]init];
        [addressBookTemp addObjectsFromArray:dict[@"friendsList"]];
        _newFansListSize = [dict[@"newFansListSize"] integerValue];
        UILocalizedIndexedCollation *theCollation = [UILocalizedIndexedCollation currentCollation];
//        for (int i = 0; i < addressBookTemp.count; i++) {
//            FriendsListModel *addressBook = [[FriendsListModel alloc] init];
//            addressBook = addressBookTemp[i];
//            CustomerModel *tempModel = [[CustomerModel alloc] init];
//            NSInteger sect = [theCollation sectionForObject:tempModel collationStringSelector:@selector(friendName)];
//            [addressBook setValue:sect forKey:@"sectionNumber"];
//        }
        for (FriendsListModel *addressBook in addressBookTemp) {
            NSInteger sect = [theCollation sectionForObject:addressBook collationStringSelector:@selector(userFriendName)];
            addressBook.sectionNumber = sect;
        }
        NSInteger highSection = [[theCollation sectionTitles] count];
        NSMutableArray *sectionArrays = [NSMutableArray arrayWithCapacity:highSection];
        for (int i=0; i<=highSection; i++) {
            NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
            [sectionArrays addObject:sectionArray];
        }
        
        for (FriendsListModel *addressBook in addressBookTemp) {
            [(NSMutableArray *)[sectionArrays objectAtIndex:addressBook.sectionNumber] addObject:addressBook];
        }
        
        for (NSMutableArray *sectionArray in sectionArrays) {
            
            NSArray *sortedSection = [theCollation sortedArrayFromArray:sectionArray collationStringSelector:@selector(userFriendName)];
            [_listContent addObject:sortedSection];
        }
        
        [weakSelf.tableView reloadData];

        
    }];
    
//    NSDictionary *dic=@{@"userid":[NSString stringWithFormat:@"%d",self.userModel.userid]};
//    [[LYUserHttpTool shareInstance] getFriendsList:dic block:^(NSMutableArray *result) {
//        NSMutableArray *addressBookTemp = [[NSMutableArray array]init];
//        [addressBookTemp addObjectsFromArray:result];
//        
//        UILocalizedIndexedCollation *theCollation = [UILocalizedIndexedCollation currentCollation];
//        for (CustomerModel *addressBook in addressBookTemp) {
//            NSInteger sect = [theCollation sectionForObject:addressBook collationStringSelector:@selector(friendName)];
//            addressBook.sectionNumber = sect;
//            
//        }
//        NSInteger highSection = [[theCollation sectionTitles] count];
//        NSMutableArray *sectionArrays = [NSMutableArray arrayWithCapacity:highSection];
//        for (int i=0; i<=highSection; i++) {
//            NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
//            [sectionArrays addObject:sectionArray];
//        }
//        
//        for (CustomerModel *addressBook in addressBookTemp) {
//            [(NSMutableArray *)[sectionArrays objectAtIndex:addressBook.sectionNumber] addObject:addressBook];
//        }
//        
//        for (NSMutableArray *sectionArray in sectionArrays) {
//            NSArray *sortedSection = [theCollation sortedArrayFromArray:sectionArray collationStringSelector:@selector(friendName)];
//            [_listContent addObject:sortedSection];
//        }
//        
//        [weakSelf.tableView reloadData];
//    }];
    NSDictionary *dict = @{@"newFansSize":[NSString stringWithFormat:@"%d",3]};
    [LYFriendsHttpTool getNewFansListWithParms:dict complete:^(NSArray *Arr) {
        [_fansListArray addObjectsFromArray:Arr];
    }];
    
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return nil;
    } else {
//        self.tableView.sectionIndexTrackingBackgroundColor = [UIColor redColor];
        return [[NSArray arrayWithObject:UITableViewIndexSearch] arrayByAddingObjectsFromArray:
                [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles]];
        
    }
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 0;
    } else {
        if (title == UITableViewIndexSearch) {
            [tableView scrollRectToVisible:self.searchDisplayController.searchBar.frame animated:NO];
            return -1;
        } else {
            return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index-1];
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 1;
    } else {
        return [_listContent count] + 3;
    }
}

//-(UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    if (tableView == self.searchDisplayController.searchResultsTableView) {
//        return nil;
//    } else {
//        if (section == 1) {
//            _searchBar = [[UISearchBar alloc] initWithFrame:(CGRectMake(0, -20, [UIScreen mainScreen].bounds.size.width, 20))];
//            _searchBar.delegate = self;
//            _searchBar.searchBarStyle = UISearchBarStyleDefault;
//            return _searchBar;
//        } else {
//            return nil;
//        }
//    }
//}

//-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    if (tableView == self.searchDisplayController.searchResultsTableView) {
//        return 0;
//    } else {
//        if (section == 1) {
//            return 40;
//        } else {
//            return 0;
//        }
//    }
//}

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return nil;
    } else {
        if (section == 2) {
            _searchBar = [[UISearchBar alloc] initWithFrame:(CGRectMake(0, -20, [UIScreen mainScreen].bounds.size.width, 20))];
            _searchBar.showsCancelButton = YES;
            _searchBar.delegate = self;
            _searchBar.searchBarStyle = UISearchBarStyleDefault;
            return _searchBar;
        } else {
            return  nil;
        }

    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return nil;
    } else {
        if (section == 0 || section == 1) {
            return nil;
        } else if(section == 2){
            return nil;
        } else {
            return [[_listContent objectAtIndex:section -3] count] ? [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section-3] : nil;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
        return 0;
    if (section == 0 || section == 1) {
        return 0;
    } else if(section == 2){
        return 40;
    } else {
        return [[_listContent objectAtIndex:section-3] count] ? tableView.sectionHeaderHeight : 0;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        if (section >= 3) {
            return [_filteredListContent count];
        } else {
            return 0;
        }
    } else {
        if (section == 0) {
            if (_isOpen) {
                return _fansListArray.count + 1;
            } else {
                return 1;
            }
        } else if(section == 1){
            return 1;
        } else if(section == 2){
            return 0;
        } else {
            return [[_listContent objectAtIndex:section-3] count];
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CustomerCell *cell = (CustomerCell *)[_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = (CustomerCell *)[nibArray objectAtIndex:0];
        cell.backgroundColor=[UIColor whiteColor];
    }
    cell.nameLal.font = [UIFont systemFontOfSize:15];
    FriendsListModel *addressBook = nil;
    if (tableView == self.searchDisplayController.searchResultsTableView){
        if (indexPath.section >= 3) {
           addressBook = (FriendsListModel *)[_filteredListContent objectAtIndex:indexPath.row];
        }
    } else {
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                cell.cusImageView.image = [UIImage imageNamed:@"sayHello"];
                cell.nameLal.text = @"新关注";
                cell.tipLabel.text = @"（互相关注后将成为玩友）";
                if (_isOpen) {
                    cell.smallImageView.image = nil;
                    [cell.smallImageView setImage:[UIImage imageNamed:@"arrowdown"]];
                } else {
                    cell.smallImageView.image = nil;
                    [cell.smallImageView setImage:[UIImage imageNamed:@"arrowRitht"]];
                }
                if (_tipNum != 0) {
                    _redTip = [[UILabel alloc] initWithFrame:(CGRectMake(CGRectGetMaxX(cell.cusImageView.frame) - 10 , CGRectGetMinY(cell.cusImageView.frame), 10, 10))];
                    _redTip.backgroundColor = [UIColor redColor];
                    _redTip.text = [NSString stringWithFormat:@"%d",_tipNum];
                    _redTip.textAlignment = NSTextAlignmentCenter;
                    _redTip.font = [UIFont systemFontOfSize:8];
                    _redTip.layer.cornerRadius = _redTip.frame.size.height / 2;
                    _redTip.layer.masksToBounds = YES;
                    [cell addSubview:_redTip];
                }
                return cell;
            } else {
                FansCell *fansCell = (FansCell *)[tableView dequeueReusableCellWithIdentifier:fansCellID];
                if (fansCell == nil) {
                    NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"FansCell" owner:self options:nil];
                    fansCell = (FansCell *)[nibArray objectAtIndex:0];
                }
                fansCell.selectionStyle = UITableViewCellSelectionStyleNone;
                fansCell.fansModel = _fansListArray[indexPath.row - 1];
                [fansCell.focusButton addTarget:self action:@selector(fansFocusButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
                return fansCell;
            }
            
        } else if (indexPath.section == 1){
            cell.cusImageView.image = [UIImage imageNamed:@"lianxiren"];
            cell.nameLal.text = @"添加手机通讯录";
            cell.smallImageView.image = [UIImage imageNamed:@"arrowRitht"];
            return cell;
        } else {
             addressBook = (FriendsListModel *)[[_listContent objectAtIndex:indexPath.section - 3] objectAtIndex:indexPath.row];
        }
    }
    if ([[addressBook.userFriendName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] > 0) {
        cell.nameLal.text = addressBook.userFriendName;
        
    } else {
        cell.nameLal.text = @"No Name";
    }
    [cell.smallImageView setHidden:YES];
   NSString *imgStr = [MyUtil getQiniuUrl:addressBook.avatar_img width:0 andHeight:0];
    [cell.cusImageView setImageWithURL:[NSURL URLWithString:imgStr]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //    cell.backgroundColor=[UIColor clearColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendsListModel *addressBook = nil;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        addressBook = (FriendsListModel*)[_filteredListContent objectAtIndex:indexPath.row];
        [self.searchDisplayController.searchResultsTableView deselectRowAtIndexPath:indexPath animated:YES];
    } else {
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                _isOpen = !_isOpen;
                CustomerCell *cell = (CustomerCell *)[self.tableView cellForRowAtIndexPath:indexPath];
                
                NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
                [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];            } else {
                 
            }
            return;
        } else if(indexPath.section == 1) {
            [self addressBook];
            return;
        } else {
            addressBook = (FriendsListModel*)[[_listContent objectAtIndex:indexPath.section - 3] objectAtIndex:indexPath.row];
            
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
    }
    LYMyFriendDetailViewController *friendDetailViewController=[[LYMyFriendDetailViewController alloc]initWithNibName:@"LYMyFriendDetailViewController" bundle:nil];
    friendDetailViewController.title=@"详细信息";
    friendDetailViewController.type=@"0";
//    friendDetailViewController.customerModel=addressBook;
    friendDetailViewController.userID = [NSString stringWithFormat:@"%d",addressBook.id];
    [self.navigationController pushViewController:friendDetailViewController animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return UITableViewCellEditingStyleDelete;
//}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView != self.searchDisplayController.searchResultsTableView) {
        if (indexPath.section == 0 || indexPath.section == 1) {
            return NO;
        } else {
            return YES;
        }
    } else {
        return YES;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        __weak __typeof(self)weakSelf = self;
        FriendsListModel *addressBook = nil;
        if (tableView == self.searchDisplayController.searchResultsTableView)
            addressBook = (FriendsListModel *)[_filteredListContent objectAtIndex:indexPath.row];
        else
            addressBook = (FriendsListModel *)[[_listContent objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        NSDictionary *dic=@{@"id":[NSNumber numberWithInt:addressBook.id]};
        [[LYUserHttpTool shareInstance] delMyFriends:dic complete:^(BOOL result) {
            if(result){
                
                [MyUtil showMessage:@"删除成功"];
                if (tableView == weakSelf.searchDisplayController.searchResultsTableView){
                    [weakSelf.searchDisplayController setActive:NO animated:YES];
                }
                [weakSelf getMyCustomerslist];
            }
        }];
    }
}

#pragma mark - 关注按钮
-(void)fansFocusButtonAction:(UIButton *) sender{
    FansCell *cell = (FansCell *)[[sender superview] superview];
    NSIndexPath *index=[_tableView indexPathForCell:cell];
    FansModel *model = _fansListArray[index.row - 1];
    if ([model.friendStatus isEqualToString:@"2"]) {
        NSDictionary *dict = @{@"followid":[NSString stringWithFormat:@"%d",model.id]};
        [LYFriendsHttpTool unFollowFriendWithParms:dict complete:^(NSDictionary *dict) {
            sender.titleLabel.text = @"关注";
        }];
    } else if([model.friendStatus isEqualToString:@"3"]) {//不是改为关注
        NSDictionary *dict = @{@"followid":[NSString stringWithFormat:@"%d",model.id]};
        [LYFriendsHttpTool followFriendWithParms:dict complete:^(NSDictionary *dict) {
//        [_fansListArray removeObject:model];
//        [_tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:index] withRowAnimation:UITableViewRowAnimationAutomatic];
            sender.titleLabel.text = @"取消关注";
        }];
    }
//    --_tipNum;
//    [_tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:index] withRowAnimation:UITableViewRowAnimationAutomatic];
//    [_tableView reloadData];
}

#pragma mark UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    //[self.searchDisplayController.searchBar setShowsCancelButton:NO];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
//    [self.searchDisplayController setActive:NO animated:YES];
//    [self.tableView reloadData];
    [_searchBar resignFirstResponder];
    [_searchBar setText:@""];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self filterContentForSearchText:searchBar.text];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchText.length <= 0) {
        [searchBar resignFirstResponder];
        [self.tableView reloadData];
    }else{
        [self filterContentForSearchText:searchText];
    }
}

#pragma mark - 筛选
- (void)filterContentForSearchText:(NSString *)searchText{
    _filteredListContent = [[NSMutableArray alloc]init];
    for (NSArray *section in _listContent) {
        for (FriendsListModel *addressBook in section) {
            if (addressBook.userFriendName.length >= searchText.length && searchText != nil) {
                NSComparisonResult result = [addressBook.userFriendName compare:searchText options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch range:NSMakeRange(0, [searchText length])];
                if (result == NSOrderedSame) {
                    [_filteredListContent addObject:addressBook];
                }
            }
        }
    }
    [self.searchDisplayController.searchResultsTableView reloadData];
}
#pragma mark -
#pragma mark ContentFiltering

//- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
//{
//    [_filteredListContent removeAllObjects];
//    for (NSArray *section in _listContent) {
//        for (CustomerModel *addressBook in section)
//        {
//            if(addressBook.friendName.length >= searchText.length && searchText != nil){
//                NSComparisonResult result = [addressBook.friendName compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
//                if (result == NSOrderedSame)
//                {
//                    [_filteredListContent addObject:addressBook];
//                }
//            }
//        }
//    }
//    [self.tableView reloadData];
//}

#pragma mark -
#pragma mark UISearchDisplayControllerDelegate

//- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
//{
//    [self filterContentForSearchText:searchString scope:
//     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
//    
//    return YES;
//}

//- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
//{
//    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:
//     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
//    
//    return YES;
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 更多
-(void)moreAct:(id)sender{
    [self addFriendAct:nil];
//    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH,SCREEN_HEIGHT)];
//    [_bgView setTag:99999];
//    [_bgView setBackgroundColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.4]];
//    [_bgView setAlpha:1.0];
//    rightBtn.enabled=false;
//    [self.view addSubview:_bgView];
//    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"LYZSeditView" owner:nil options:nil];
//    seditView= (LYZSeditView *)[nibView objectAtIndex:0];
//    seditView.top=SCREEN_HEIGHT;
//    [seditView.quxiaoBtn addTarget:self action:@selector(SetViewDisappear:) forControlEvents:UIControlEventTouchDown];
//    [seditView.editListBtn setHidden:YES];
//    [seditView.shenqingBtn setImage:[UIImage imageNamed:@"addFriendIcon"] forState:0];
//    seditView.firstLal.text=@"添加好友";
////    [seditView.editListBtn addTarget:self action:@selector(editZsAct:) forControlEvents:UIControlEventTouchDown];
//    [seditView.shenqingBtn addTarget:self action:@selector(addFriendAct:) forControlEvents:UIControlEventTouchDown];
//    [_bgView addSubview:seditView];
//    
//    [UIView beginAnimations:@"animationID" context:nil];
//    [UIView setAnimationDuration:0.3];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
//    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:seditView cache:NO];
//    seditView.top=SCREEN_HEIGHT-seditView.height-64;
//    [UIView commitAnimations];
//    
//    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
//    button.frame=CGRectMake(0 ,0, SCREEN_WIDTH, SCREEN_HEIGHT-seditView.height-64);
//    [button setBackgroundColor:[UIColor clearColor]];
//    [button addTarget:self action:@selector(SetViewDisappear:) forControlEvents:UIControlEventTouchDown];
//    [_bgView insertSubview:button aboveSubview:_bgView];
//    button.backgroundColor=[UIColor clearColor];
}
#pragma mark - 消失
-(void)SetViewDisappear:(id)sender
{
    rightBtn.enabled=YES;
    if (_bgView)
    {
        _bgView.backgroundColor=[UIColor clearColor];
        [UIView animateWithDuration:.5
                         animations:^{
                             
                             seditView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 300);
                             _bgView.frame=CGRectMake(0, SCREEN_HEIGHT, self.view.frame.size.width, self.view.frame.size.height);
                             _bgView.alpha=0.0;
                         }];
        [_bgView performSelector:@selector(removeFromSuperview)
                      withObject:nil
                      afterDelay:2];
        
        _bgView=nil;
    }
    
}

-(void)addressBook{
    LYAddressBook *addressBook = [[LYAddressBook alloc]init];
    NSMutableArray *updateArray = [[NSMutableArray alloc]init];
    NSArray *array = [addressBook getAddressBook];
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

-(void)setFrameForCell{
    
}

-(void)addFriendAct:(id)sender{
    LYSearchFriendViewController *searchFriendViewController=[[LYSearchFriendViewController alloc]initWithNibName:@"LYSearchFriendViewController" bundle:nil];
    [self.navigationController pushViewController:searchFriendViewController animated:YES];
    [self SetViewDisappear:nil];
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
