//
//  LYChooseJiuBaViewController.m
//  lieyu
//
//  Created by 薛斯岐 on 15/9/25.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYChooseJiuBaViewController.h"
#import "LYJiuBaCell.h"
#import "LYUserHttpTool.h"
@interface LYChooseJiuBaViewController ()

@end

@implementation LYChooseJiuBaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _listContent = [NSMutableArray new];
    _filteredListContent = [NSMutableArray new];
    [self getJiuBalist];
    // Do any additional setup after loading the view from its nib.
}
#pragma mark - 所有酒吧
-(void)getJiuBalist{
    [_listContent removeAllObjects];
     __weak __typeof(self)weakSelf = self;
    [[LYUserHttpTool shareInstance]getJiuBaList:nil block:^(NSMutableArray *result) {
        NSMutableArray *addressBookTemp = [[NSMutableArray  alloc]initWithArray:result];
        UILocalizedIndexedCollation *theCollation = [UILocalizedIndexedCollation currentCollation];
        for (JiuBaModel *addressBook in addressBookTemp) {
            NSInteger sect = [theCollation sectionForObject:addressBook
                                    collationStringSelector:@selector(barname)];
            addressBook.sectionNumber = sect;
            
        }
        NSInteger highSection = [[theCollation sectionTitles] count];
        NSMutableArray *sectionArrays = [NSMutableArray arrayWithCapacity:highSection];
        for (int i=0; i<=highSection; i++) {
            NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
            [sectionArrays addObject:sectionArray];
        }
        
        for (JiuBaModel *addressBook in addressBookTemp) {
            [(NSMutableArray *)[sectionArrays objectAtIndex:addressBook.sectionNumber] addObject:addressBook];
        }
        
        for (NSMutableArray *sectionArray in sectionArrays) {
            NSArray *sortedSection = [theCollation sortedArrayFromArray:sectionArray collationStringSelector:@selector(barname)];
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
    
    return 60;
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
    static NSString *CellIdentifier = @"LYJiuBaCell";
    
    LYJiuBaCell *cell = (LYJiuBaCell *)[_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = (LYJiuBaCell *)[nibArray objectAtIndex:0];
        cell.backgroundColor=[UIColor whiteColor];
        
        
    }
    
    
    JiuBaModel *addressBook = nil;
    if (tableView == self.searchDisplayController.searchResultsTableView)
        addressBook = (JiuBaModel *)[_filteredListContent objectAtIndex:indexPath.row];
    else
        addressBook = (JiuBaModel *)[[_listContent objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    if ([[addressBook.barname stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] > 0) {
        cell.jiubaLal.text = addressBook.barname;
        cell.quYuLal.text = addressBook.address;
    } else {
        
        cell.jiubaLal.text = @"No Name";
        cell.quYuLal.text = addressBook.address;
    }
    
    //    cell.backgroundColor=[UIColor clearColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JiuBaModel *addressBook = nil;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        addressBook = (JiuBaModel*)[_filteredListContent objectAtIndex:indexPath.row];
        [self.searchDisplayController.searchResultsTableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    else {
        addressBook = (JiuBaModel*)[[_listContent objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    [self.delegate chooseJiuBa:addressBook];
    [self.navigationController popViewControllerAnimated:YES];
    
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
        for (JiuBaModel *addressBook in section)
        {
            NSComparisonResult result = [addressBook.barname compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
