//
//  LYSearchFriendViewController.m
//  lieyu
//
//  Created by 薛斯岐 on 15/10/29.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYSearchFriendViewController.h"
#import "FindMenuTwoCell.h"
#import "WanYouInfoCell.h"
#import "CustomerModel.h"
#import "LYUserHttpTool.h"
#import "YaoYiYaoViewController.h"
#import "SaoYiSaoViewController.h"
#import "LYMyFriendDetailViewController.h"
@interface LYSearchFriendViewController ()
{
    NSArray *datalist;
    NSMutableArray *searchlist;
}
@end

@implementation LYSearchFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.showsHorizontalScrollIndicator=NO;
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.separatorColor=[UIColor clearColor];
    searchlist=[[NSMutableArray alloc]init];
    self.tableView.tableFooterView=[[UIView alloc]init];//去掉多余的分割线

    datalist=@[
//               @{@"image":@"icon_yaoyiyao_normal",@"title":@"摇一摇"},
               @{@"image":@"saoyisao",@"title":@"扫一扫"}
            ];
    
    // Do any additional setup after loading the view from its nib.
}
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return searchlist.count;
    }
    return datalist.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 1;
    }
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        tableView.separatorStyle = NO;
        
        WanYouInfoCell *cell = (WanYouInfoCell *)[_tableView dequeueReusableCellWithIdentifier:@"WanYouInfoCell"];
    
        if (cell == nil) {
            NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"WanYouInfoCell" owner:self options:nil];
            cell = (WanYouInfoCell *)[nibArray objectAtIndex:0];
//            cell.backgroundColor=[UIColor whiteColor];
            
            
        }
        CustomerModel *customerModel=searchlist[indexPath.row];
//        [cell.userImageView  setImageWithURL:[NSURL URLWithString:customerModel.mark]];
        [cell.userImageView sd_setImageWithURL:[NSURL URLWithString:customerModel.mark] placeholderImage:[UIImage imageNamed:@"CommonIcon"]];
        cell.titleLal.text=customerModel.name;
        NSMutableString *ss=[[NSMutableString alloc]init];
        if(customerModel.userTag.count>0){
            for (int i=0 ; i < customerModel.userTag.count; i++ ){
                NSDictionary *dic =customerModel.userTag[i];
                NSString *biaoqianStr=[dic objectForKey:@"tagName"];
                [ss appendString:biaoqianStr];
                if(i!=customerModel.userTag.count-1){
                    [ss appendString:@","];
                }
            }
            [ss appendString:@"  "];
//            cell.detLal.text=ss;
        }
        [ss appendString:[MyUtil getAstroWithBirthday:customerModel.birthday]];
        cell.detLal.text=ss;
//        cell.miaosuLal.text = [MyUtil getAstroWithBirthday:customerModel.birthday];
        if([customerModel.sex isEqualToString:@"1"]){
            cell.sexImageView.image=[UIImage imageNamed:@"manIcon"];
        }
        UILabel *lineLal=[[UILabel alloc]initWithFrame:CGRectMake(15, 75.5, SCREEN_WIDTH - 30, 0.5)];
        lineLal.backgroundColor=RGB(199, 199, 199);
        [cell addSubview:lineLal];
        cell.accessoryType = UITableViewCellSelectionStyleNone;
        return cell;
    }
    FindMenuTwoCell *cell = (FindMenuTwoCell *)[_tableView dequeueReusableCellWithIdentifier:@"FindMenuTwoCell"];
    if (cell == nil) {
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"FindMenuTwoCell" owner:self options:nil];
        cell = (FindMenuTwoCell *)[nibArray objectAtIndex:0];
        //            cell.backgroundColor=[UIColor whiteColor];
        
        
    }    //cell.backgroundColor=[UIColor clearColor];
    
    NSDictionary *dic=[datalist objectAtIndex:indexPath.row];
    [cell.imageView setImage:[UIImage imageNamed:[dic objectForKey:@"image"]]];
    cell.titleLal.text=[dic objectForKey:@"title"];
    cell.accessoryType = UITableViewCellSelectionStyleNone;
    //    cell.textLabel.text = appRecord.appName;
    //
    
    UILabel *lineLal=[[UILabel alloc]initWithFrame:CGRectMake(15, 43.5, 290, 0.5)];
    lineLal.backgroundColor=RGB(199, 199, 199);
    [cell addSubview:lineLal];
    // Configure the cell...
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 76.f;
    }
    return 44.f;
}
#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        CustomerModel *customerModel=searchlist[indexPath.row];
        LYMyFriendDetailViewController *friendDetailViewController=[[LYMyFriendDetailViewController alloc]initWithNibName:@"LYMyFriendDetailViewController" bundle:nil];
        friendDetailViewController.title=@"详细信息";
        friendDetailViewController.type=@"4";
        friendDetailViewController.customerModel=customerModel;
        [self.navigationController pushViewController:friendDetailViewController animated:YES];
    }else{
        if(indexPath.row==0&&NO){
            YaoYiYaoViewController *yaoYiYaoViewController=[[YaoYiYaoViewController alloc]initWithNibName:@"YaoYiYaoViewController" bundle:nil];
            yaoYiYaoViewController.title=@"摇一摇";
            [self.navigationController pushViewController:yaoYiYaoViewController  animated:YES];
        }else{
//            扫一扫
            SaoYiSaoViewController *saoYiSaoViewController=[[SaoYiSaoViewController alloc]initWithNibName:@"SaoYiSaoViewController" bundle:nil];
            saoYiSaoViewController.title=@"扫一扫";
            [self.navigationController pushViewController:saoYiSaoViewController  animated:YES];
        }
    }
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark -
#pragma mark UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)_searchBar
{
    //[self.searchDisplayController.searchBar setShowsCancelButton:NO];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)_searchBar
{
    [self.searchDisplayController setActive:NO animated:YES];
    //[self.tableView reloadData];
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    if (![MyUtil isEmptyString:searchBar.text] ) {
        [self searchBarSearchButtonClicked:searchBar];
    }
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)nowsearchBar
{
    
    __weak __typeof(self)weakSelf = self;
    NSDictionary *dic=@{@"user":[NSNumber numberWithInt:self.userModel.userid],@"searchValue":nowsearchBar.text,@"firstResult":@"0",@"searchValue":@"50"};
    [[LYUserHttpTool shareInstance]getFindFriendListWithParams:dic block:^(NSMutableArray *result) {
        
        [searchlist removeAllObjects];
        searchlist=[result mutableCopy];
        [weakSelf.searchDisplayController.searchResultsTableView reloadData];
    }];

//    [self.searchDisplayController setActive:NO animated:YES];
    
    //[self.tableView reloadData];
}
#pragma mark ContentFiltering

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    
}
#pragma mark -
#pragma mark UISearchDisplayControllerDelegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
//    [self filterContentForSearchText:searchString scope:
//     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    return false;
}
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
//    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:
//     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    
    return false;
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
