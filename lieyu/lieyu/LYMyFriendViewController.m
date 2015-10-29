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
@interface LYMyFriendViewController ()

@end

@implementation LYMyFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO];
    rightBtn=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"add5"] style:UIBarButtonItemStylePlain target:self action:@selector(moreAct:)];
    [self.navigationItem setRightBarButtonItem:rightBtn];
    self.title=@"好友列表";
    
    _listContent = [NSMutableArray new];
    _filteredListContent = [NSMutableArray new];
    [self getMyCustomerslist];
    // Do any additional setup after loading the view from its nib.
}
-(void)getMyCustomerslist{
    [_listContent removeAllObjects];
    __weak __typeof(self)weakSelf = self;
    NSDictionary *dic=@{@"userid":[NSString stringWithFormat:@"%d",self.userModel.userid]};
    [[LYUserHttpTool shareInstance] getFriendsList:dic block:^(NSMutableArray *result) {
        NSMutableArray *addressBookTemp = [[NSMutableArray array]init];
        [addressBookTemp addObjectsFromArray:result];
        
        UILocalizedIndexedCollation *theCollation = [UILocalizedIndexedCollation currentCollation];
        for (CustomerModel *addressBook in addressBookTemp) {
            NSInteger sect = [theCollation sectionForObject:addressBook
                                    collationStringSelector:@selector(friendName)];
            addressBook.sectionNumber = sect;
            
        }
        NSInteger highSection = [[theCollation sectionTitles] count];
        NSMutableArray *sectionArrays = [NSMutableArray arrayWithCapacity:highSection];
        for (int i=0; i<=highSection; i++) {
            NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
            [sectionArrays addObject:sectionArray];
        }
        
        for (CustomerModel *addressBook in addressBookTemp) {
            [(NSMutableArray *)[sectionArrays objectAtIndex:addressBook.sectionNumber] addObject:addressBook];
        }
        
        for (NSMutableArray *sectionArray in sectionArrays) {
            NSArray *sortedSection = [theCollation sortedArrayFromArray:sectionArray collationStringSelector:@selector(friendName)];
            [_listContent addObject:sortedSection];
            
        }
        
        
        [weakSelf.tableView reloadData];
    }];
    
}
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return nil;
    } else {
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
        return [_listContent count];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
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
    if (tableView == self.searchDisplayController.searchResultsTableView)
        return 0;
    return [[_listContent objectAtIndex:section] count] ? tableView.sectionHeaderHeight : 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 59;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
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
    if (tableView == self.searchDisplayController.searchResultsTableView)
        addressBook = (CustomerModel *)[_filteredListContent objectAtIndex:indexPath.row];
    else
        addressBook = (CustomerModel *)[[_listContent objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    if ([[addressBook.friendName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] > 0) {
        cell.nameLal.text = addressBook.friendName;
        
    } else {
        
        cell.nameLal.text = @"No Name";
    }
    
    //    cell.backgroundColor=[UIColor clearColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomerModel *addressBook = nil;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        addressBook = (CustomerModel*)[_filteredListContent objectAtIndex:indexPath.row];
        [self.searchDisplayController.searchResultsTableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    else {
        addressBook = (CustomerModel*)[[_listContent objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
//    ZSCustomerDetailViewController *customerDetailsViewController=[[ZSCustomerDetailViewController alloc]initWithNibName:@"ZSCustomerDetailViewController" bundle:nil];
//    
//    [self.navigationController pushViewController:customerDetailsViewController animated:YES];
}



#pragma mark -
#pragma mark UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)_searchBar
{
    //[self.searchDisplayController.searchBar setShowsCancelButton:NO];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)_searchBar
{
    //[self.searchDisplayController setActive:NO animated:YES];
    [self.tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)_searchBar
{
    //[self.searchDisplayController setActive:NO animated:YES];
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark ContentFiltering

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    [_filteredListContent removeAllObjects];
    for (NSArray *section in _listContent) {
        for (CustomerModel *addressBook in section)
        {
            NSComparisonResult result = [addressBook.friendName compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
            if (result == NSOrderedSame)
            {
                [_filteredListContent addObject:addressBook];
            }
        }
    }
}

#pragma mark -
#pragma mark UISearchDisplayControllerDelegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 更多
-(void)moreAct:(id)sender{
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH,SCREEN_HEIGHT)];
    [_bgView setTag:99999];
    [_bgView setBackgroundColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.4]];
    [_bgView setAlpha:1.0];
    rightBtn.enabled=false;
    [self.view addSubview:_bgView];
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"LYZSeditView" owner:nil options:nil];
    seditView= (LYZSeditView *)[nibView objectAtIndex:0];
    seditView.top=SCREEN_HEIGHT;
    [seditView.quxiaoBtn addTarget:self action:@selector(SetViewDisappear:) forControlEvents:UIControlEventTouchDown];
    [seditView.editListBtn setHidden:YES];
    [seditView.shenqingBtn setImage:[UIImage imageNamed:@"addFriendIcon"] forState:0];
    seditView.firstLal.text=@"添加好友";
//    [seditView.editListBtn addTarget:self action:@selector(editZsAct:) forControlEvents:UIControlEventTouchDown];
    [seditView.shenqingBtn addTarget:self action:@selector(addFriendAct:) forControlEvents:UIControlEventTouchDown];
    [_bgView addSubview:seditView];
    
    [UIView beginAnimations:@"animationID" context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:seditView cache:NO];
    seditView.top=SCREEN_HEIGHT-seditView.height-64;
    [UIView commitAnimations];
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(0 ,0, SCREEN_WIDTH, SCREEN_HEIGHT-seditView.height-64);
    [button setBackgroundColor:[UIColor clearColor]];
    [button addTarget:self action:@selector(SetViewDisappear:) forControlEvents:UIControlEventTouchDown];
    [_bgView insertSubview:button aboveSubview:_bgView];
    button.backgroundColor=[UIColor clearColor];
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
-(void)addFriendAct:(id)sender{
    
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