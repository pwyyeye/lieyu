//
//  ChanPinListViewController.m
//  lieyu
//
//  Created by 薛斯岐 on 15/9/21.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "ChanPinListViewController.h"
#import "KuCunCell.h"
#import "ZSManageHttpTool.h"
#import "KuCunModel.h"
@interface ChanPinListViewController ()

@end

@implementation ChanPinListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     _tableView.separatorColor=[UIColor clearColor];
    _listContent = [NSMutableArray new];
    _filteredListContent = [NSMutableArray new];
    [self getKuCunList];
    // Do any additional setup after loading the view from its nib.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
        return 1;
   
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 64;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [_filteredListContent count];
    } else {
        return [_listContent  count];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"KuCunCell";
    
    KuCunCell *cell = (KuCunCell *)[_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = (KuCunCell *)[nibArray objectAtIndex:0];
        cell.backgroundColor=[UIColor whiteColor];
        
        
    }
    
    
    KuCunModel *kuCunModel = nil;
    cell.selBtn.tag=indexPath.row;
    if (tableView == self.searchDisplayController.searchResultsTableView){
        kuCunModel = (KuCunModel *)[_filteredListContent objectAtIndex:indexPath.row];
        [cell.selBtn addTarget:self action:@selector(chooseRadioForSer:) forControlEvents:UIControlEventTouchDown] ;
    }else{
        kuCunModel= (KuCunModel *)[_listContent objectAtIndex:indexPath.row];
        [cell.selBtn addTarget:self action:@selector(chooseRadio:) forControlEvents:UIControlEventTouchDown] ;
    }
    cell.namelal.text=kuCunModel.name;
    [cell.countLal setHidden:YES];
    [cell.selBtn setHidden:NO];
    [cell.selBtn setSelected:kuCunModel.isSel];
    
    
    
        //addressBook = (CustomerModel *)[_filteredListContent objectAtIndex:indexPath.row];
    
        //addressBook = (CustomerModel *)[[_listContent objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
//    if ([[addressBook.name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] > 0) {
//        cell.nameLal.text = addressBook.name;
//        
//    } else {
//        
//        cell.nameLal.text = @"No Name";
//    }
    
    //    cell.backgroundColor=[UIColor clearColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    CustomerModel *addressBook = nil;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
//        addressBook = (CustomerModel*)[_filteredListContent objectAtIndex:indexPath.row];
        [self.searchDisplayController.searchResultsTableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    else {
//        addressBook = (CustomerModel*)[[_listContent objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    
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
    for (KuCunModel *kuCunModel in _listContent) {
        NSComparisonResult result = [kuCunModel.name compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
        if (result == NSOrderedSame)
        {
            [_filteredListContent addObject:kuCunModel];
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
#pragma mark -库存列表
-(void)getKuCunList{
    [_listContent removeAllObjects];
//    [serchDataList removeAllObjects];
    __weak __typeof(self)weakSelf = self;
    NSDictionary *dic=@{@"barid":@"1",@"userid":@"1"};
    [[ZSManageHttpTool shareInstance] getMyKuCunListWithParams:dic block:^(NSMutableArray *result) {
        _listContent =result;
        [weakSelf.tableView reloadData];
    }];
    
    
}
#pragma mark -选择
-(void)chooseRadio:(UIButton *)sender{
    if(self.isDX){
        KuCunModel * kuCunModel = (KuCunModel *)[_listContent objectAtIndex:sender.tag];
        kuCunModel.isSel=true;
        sender.selected=kuCunModel.isSel;
        for (KuCunModel * kuCunModelTemp in _listContent) {
            if(![kuCunModel isEqual:kuCunModelTemp]){
                kuCunModelTemp.isSel=false;
            }
        }
        [_tableView reloadData];
    }else{
        KuCunModel * kuCunModel = (KuCunModel *)[_listContent objectAtIndex:sender.tag];
        kuCunModel.isSel=!kuCunModel.isSel;
        sender.selected=kuCunModel.isSel;
    }
    
}
#pragma mark -搜索的选择
-(void)chooseRadioForSer:(UIButton *)sender{
    if(self.isDX){
        KuCunModel * kuCunModel = (KuCunModel *)[_filteredListContent objectAtIndex:sender.tag];
        kuCunModel.isSel=true;
        sender.selected=kuCunModel.isSel;
        for (KuCunModel * kuCunModelTemp in _listContent) {
            if(![kuCunModel isEqual:kuCunModelTemp]){
                kuCunModelTemp.isSel=false;
            }
        }
        [_tableView reloadData];
        [self.searchDisplayController.searchResultsTableView reloadData];
    }else{
        KuCunModel * kuCunModel = (KuCunModel *)[_filteredListContent objectAtIndex:sender.tag];
        kuCunModel.isSel=!kuCunModel.isSel;
        sender.selected=kuCunModel.isSel;
    }
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
#pragma mark - 确定按钮
- (IBAction)sureAct:(UIButton *)sender {
    NSMutableArray *arr=[[NSMutableArray alloc]init];
    for (KuCunModel * kuCunModel in _listContent) {
        if(kuCunModel.isSel){
            kuCunModel.useCount=1;
            [arr addObject:kuCunModel];
        }
    }
    [self.delegate addChanPin:arr];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
