//
//  LYHomeSearchViewController.m
//  lieyu
//
//  Created by 薛斯岐 on 15/11/2.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYHomeSearchViewController.h"
#import "LYWineBarInfoCell.h"
#import "BeerBarDetailViewController.h"
#import "NetPublic.h"
#import "LYToPlayRestfulBusiness.h"
#import "MReqToPlayHomeList.h"
#import "JiuBaModel.h"
#import "BiaoQianBtn.h"
#import "TypeChooseCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#define PAGESIZE 20
@interface LYHomeSearchViewController ()
{
    NSArray *datalist;
    NSMutableArray *searchlist;
    NSString *keyStr;
}
@property(nonatomic,assign) NSInteger curPageIndex;
@end

@implementation LYHomeSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.curPageIndex = 1;
    _tableView.showsHorizontalScrollIndicator=NO;
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.separatorColor=[UIColor clearColor];
    datalist=[[NSMutableArray alloc]init];
    searchlist=[[NSMutableArray alloc]init];
    [self setupViewStyles];
    [self getData];
    // Do any additional setup after loading the view from its nib.
}
- (void)setupViewStyles
{
   
    __weak LYHomeSearchViewController * weakSelf = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"LYWineBarInfoCell" bundle:nil] forCellReuseIdentifier:@"LYWineBarInfoCell"];
    self.searchDisplayController.searchResultsTableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadItemList:^(LYErrorMessage *ermsg, NSArray *bannerList, NSArray *barList) {
            if (Req_Success == ermsg.state) {
                weakSelf.curPageIndex ++;
                [self.searchDisplayController.searchResultsTableView.footer endRefreshing];
            }
            
        }];
    }];
    
    
}
-(void)getData{
    __weak LYHomeSearchViewController * weakSelf = self;
    //    __weak UITableView *tableView = self.tableView;
    [weakSelf loadItemList:^(LYErrorMessage *ermsg, NSArray *bannerList, NSArray *barList)
     {
         if (Req_Success == ermsg.state)
         {
             if (barList.count == PAGESIZE)
             {
                 weakSelf.curPageIndex = 2;
                 weakSelf.tableView.footer.hidden = NO;
             }
             else
             {
                 weakSelf.tableView.footer.hidden = YES;
             }
             //             [weakSelf.tableView.header endRefreshing];
         }
     }];
    
}
- (void)loadItemList:(void(^)(LYErrorMessage *ermsg, NSArray *bannerList, NSArray *barList))block

{
    MReqToPlayHomeList * hList = [[MReqToPlayHomeList alloc] init];
    LYToPlayRestfulBusiness * bus = [[LYToPlayRestfulBusiness alloc] init];
    
//    CLLocation * userLocation = [LYUserLocation instance].currentLocation;
//    hList.longitude = [[NSDecimalNumber alloc] initWithString:@(userLocation.coordinate.longitude).stringValue];
//    hList.latitude = [[NSDecimalNumber alloc] initWithString:@(userLocation.coordinate.latitude).stringValue];
//    hList.city = [LYUserLocation instance].city;
    
    
    
#if 1
    hList.barname = keyStr;
    hList.need_page = @(1);
    hList.p = @(_curPageIndex);
    hList.per = @(PAGESIZE);
#endif
    
    __weak __typeof(self)weakSelf = self;
    [bus getToPlayOnHomeList:hList results:^(LYErrorMessage *ermsg, NSArray *bannerList, NSArray *barList)
     {
         if (ermsg.state == Req_Success)
         {
             if (weakSelf.curPageIndex == 1) {
                 [searchlist removeAllObjects];
                 //                [weakSelf.bannerList removeAllObjects];
             }
             
             [searchlist addObjectsFromArray:barList];
             
             [self.searchDisplayController.searchResultsTableView reloadData];
         }
         block !=nil? block(ermsg,bannerList,barList):nil;
     }];
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
        
        
        LYWineBarInfoCell * barCell = [tableView dequeueReusableCellWithIdentifier:@"LYWineBarInfoCell" forIndexPath:indexPath];
        
        
       
        [barCell configureCell:[searchlist objectAtIndex:indexPath.row]];
        
        UILabel *lineLal=[[UILabel alloc]initWithFrame:CGRectMake(15, 103.5, 290, 0.5)];
        lineLal.backgroundColor=RGB(199, 199, 199);
        [barCell addSubview:lineLal];
        barCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return barCell;
    }
    TypeChooseCell*cell = (TypeChooseCell *)[_tableView dequeueReusableCellWithIdentifier:@"TypeChooseCell"];
    if (cell == nil) {
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"TypeChooseCell" owner:self options:nil];
        cell = (TypeChooseCell *)[nibArray objectAtIndex:0];
        cell.backgroundColor=[UIColor whiteColor];
        
        
    }
    NSDictionary *dic= datalist [indexPath.section];
    NSArray *arr=[dic objectForKey:@"data"];
    NSArray *arrTemp=arr[indexPath.row];
    if(arrTemp.count==1){
        cell.oneBtn.hidden=false;
        cell.twoBtn.hidden=true;
        cell.threeBtn.hidden=true;
    }
    if(arrTemp.count==2){
        cell.oneBtn.hidden=false;
        cell.twoBtn.hidden=false;
        cell.threeBtn.hidden=true;
    }
    if(arrTemp.count==3){
        cell.oneBtn.hidden=false;
        cell.twoBtn.hidden=false;
        cell.threeBtn.hidden=false;
    }
    for (int i=0; i<arrTemp.count; i++) {
        ProductCategoryModel *productCategoryModel=arrTemp[i];
        if(i==0){
            [cell.oneBtn setTitle:productCategoryModel.name forState:UIControlStateNormal];
            cell.oneBtn.model=productCategoryModel;
            [cell.oneBtn addTarget:self action:@selector(typeChoose:event:) forControlEvents:UIControlEventTouchDown] ;
            [cell.oneBtn setSelected:productCategoryModel.isSel];
        }
        if(i==1){
            [cell.twoBtn setTitle:productCategoryModel.name forState:UIControlStateNormal];
            cell.twoBtn.model=productCategoryModel;
            [cell.twoBtn addTarget:self action:@selector(typeChoose:event:) forControlEvents:UIControlEventTouchDown] ;
            [cell.twoBtn setSelected:productCategoryModel.isSel];
        }
        if(i==2){
            [cell.threeBtn setTitle:productCategoryModel.name forState:UIControlStateNormal];
            cell.threeBtn.model=productCategoryModel;
            [cell.threeBtn addTarget:self action:@selector(typeChoose:event:) forControlEvents:UIControlEventTouchDown] ;
            [cell.threeBtn setSelected:productCategoryModel.isSel];
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 104;
    }
    return 44.f;
}
#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        BeerBarDetailViewController * controller = [[BeerBarDetailViewController alloc] initWithNibName:@"BeerBarDetailViewController" bundle:nil];
        
        JiuBaModel *model=[searchlist objectAtIndex:indexPath.row ];
        controller.beerBarId = @(model.barid);
        [self.navigationController pushViewController:controller animated:YES];
    }else{
        
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

- (void)searchBarSearchButtonClicked:(UISearchBar *)nowsearchBar
{
    
    _curPageIndex=1;
    keyStr=nowsearchBar.text;
    [self getData];
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
-(void)typeChoose:(BiaoQianBtn *)button event:(id)event{
    
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
