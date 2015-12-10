//
//  LYHomeSearcherViewController.m
//  lieyu
//
//  Created by 狼族 on 15/11/29.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYHomeSearcherViewController.h"
#import "LYWineBarCell.h"
#import "BeerBarDetailViewController.h"
#import "NetPublic.h"
#import "LYToPlayRestfulBusiness.h"
#import "MReqToPlayHomeList.h"
#import "LYWineBarCell.h"
#import "BiaoQianBtn.h"
#import "TypeChooseCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "BeerBarDetailViewController.h"
#import "JiuBaModel.h"

#define PAGESIZE 20
@interface LYHomeSearcherViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSArray *datalist;
    NSMutableArray *searchlist;
    NSString *keyStr;
    NSMutableArray *hisSerchArr;
    NSMutableArray *hisRoute;
    NSArray *btnArr;
}
@property(nonatomic,assign) NSInteger curPageIndex;
@end

@implementation LYHomeSearcherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    searchlist = [[NSMutableArray alloc]initWithCapacity:0];
    _searchBar.delegate = self;
    _searchBar.placeholder = @"搜索";
    [self setupViewStyles];
    [self.tableView registerNib:[UINib nibWithNibName:@"LYWineBarCell" bundle:nil] forCellReuseIdentifier:@"wineBarCell"];
    self.tableView.hidden = YES;
    [self loadHisData];
    hisSerchArr=[[NSMutableArray alloc]init];
    self.curPageIndex = 1;
    datalist=[[NSMutableArray alloc]init];
    self.tableView.rowHeight = 274;
    _searchBar.returnKeyType = UIReturnKeySearch;
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    UIBarButtonItem *item=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back"] style:UIBarButtonItemStylePlain target:self action:@selector(gotoBack)];
    [self.navigationItem setLeftBarButtonItem:item];
}

- (void)gotoBack{
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark 获取历史搜索数据
-(void)loadHisData{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *Path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filename = [Path stringByAppendingPathComponent:@"hisSerchData.plist"];
    if([fileManager fileExistsAtPath:filename]){
        hisSerchArr= [NSKeyedUnarchiver unarchiveObjectWithFile:filename];
    }else{
        hisSerchArr = [[NSMutableArray alloc]initWithCapacity:6];
        
    }
    [self setHistory];
}
#pragma mark清空记录
-(IBAction)delHisData:(UIButton *)sendid{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"删除历史记录" message:@"确定删除？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [alertView show];
    
}
#pragma mark清空记录
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==0){
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *Path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *filename = [Path stringByAppendingPathComponent:@"hisSerchData.plist"];
        if([fileManager fileExistsAtPath:filename]){
            hisSerchArr= [NSKeyedUnarchiver unarchiveObjectWithFile:filename];
            [hisSerchArr removeAllObjects];
            [NSKeyedArchiver archiveRootObject:hisSerchArr toFile:filename];
        }
        for (UIButton *btn in _btnHistoryArray) {
            btn.layer.borderColor = [UIColor whiteColor].CGColor;
            btn.layer.cornerRadius = 0;
            [btn setTitle:@"" forState:UIControlStateNormal];
        }
    }
}
#pragma mark 保存历史数据
-(void)saveHisData:(NSString *)strKey{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *Path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filename = [Path stringByAppendingPathComponent:@"hisSerchData.plist"];
    if([fileManager fileExistsAtPath:filename]){
        hisRoute= [NSKeyedUnarchiver unarchiveObjectWithFile:filename];
    }else{
        hisRoute = [[NSMutableArray alloc]initWithCapacity:6];
        
    }
    bool ishis=false;
    for (NSString *arrtemp in hisRoute) {
        
        if([arrtemp isEqualToString:strKey]){
            ishis=true;
            break;
        }
    }
    if(!ishis){
        if(hisRoute.count==6){
            [hisRoute removeObjectAtIndex:hisRoute.count-1];
        }
        [hisRoute insertObject:strKey atIndex:0];
        [NSKeyedArchiver archiveRootObject:hisRoute toFile:filename];
    }
    
}

- (void)setHistory{
    for (int i = 0; i < hisSerchArr.count;i ++) {
        UIButton *button = _btnHistoryArray[i];
        button.layer.borderWidth = 0.5;
        button.layer.borderColor = RGBA(114, 5, 147, 1).CGColor;
        button.layer.cornerRadius = 1.8;
        button.layer.masksToBounds = YES;
        NSString *str = hisSerchArr[i];
        [button setTitle:str
                forState:UIControlStateNormal];
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (!searchBar.text.length) {
        self.tableView.hidden = YES;
        [self loadHisData];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar endEditing:NO];
    if (!searchBar.text.length) {
        self.tableView.hidden = YES;
        [self loadHisData];
        return;
    }
    [self.tableView setHidden:NO];
    _curPageIndex=1;
    keyStr= searchBar.text;
    [self getData];
}

- (void)setupViewStyles
{
    __weak LYHomeSearcherViewController * weakSelf = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"LYWineBaraCell" bundle:nil] forCellReuseIdentifier:@"wineBarCell"];
    self.tableView.mj_footer = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
        [weakSelf loadItemList:^(LYErrorMessage *ermsg, NSArray *bannerList, NSArray *barList) {
            if (Req_Success == ermsg.state) {
                if (barList.count == PAGESIZE)
                {
                    weakSelf.tableView.mj_footer.hidden = NO;
                }
                else
                {
                    weakSelf.tableView.mj_footer.hidden = YES;
                }
                weakSelf.curPageIndex ++;
                [self.tableView.mj_footer endRefreshing];
            }
            
        }];
    }];
    MJRefreshBackGifFooter *footer=(MJRefreshBackGifFooter *)self.tableView.mj_footer;
    [self initMJRefeshFooterForGif:footer];
    
    
}

-(void)initMJRefeshHeaderForGif:(MJRefreshGifHeader *) header{
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    // 设置普通状态的动画图片
    [header setImages:@[[UIImage imageNamed:@"mjRefresh"]] forState:MJRefreshStateIdle];
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    [header setImages:@[[UIImage imageNamed:@"refresh1"],[UIImage imageNamed:@"refresh2"],[UIImage imageNamed:@"refresh3"],[UIImage imageNamed:@"refresh4"],[UIImage imageNamed:@"refresh5"],[UIImage imageNamed:@"refresh6"],[UIImage imageNamed:@"refresh7"],[UIImage imageNamed:@"refresh8"],[UIImage imageNamed:@"refresh9"],[UIImage imageNamed:@"refresh10"],[UIImage imageNamed:@"refresh11"],[UIImage imageNamed:@"refresh12"]] forState:MJRefreshStatePulling];
    // 设置正在刷新状态的动画图片
    [header setImages:@[[UIImage imageNamed:@"refresh1"],[UIImage imageNamed:@"refresh2"],[UIImage imageNamed:@"refresh3"],[UIImage imageNamed:@"refresh4"],[UIImage imageNamed:@"refresh5"],[UIImage imageNamed:@"refresh6"],[UIImage imageNamed:@"refresh7"],[UIImage imageNamed:@"refresh8"],[UIImage imageNamed:@"refresh9"],[UIImage imageNamed:@"refresh10"],[UIImage imageNamed:@"refresh11"],[UIImage imageNamed:@"refresh12"]] forState:MJRefreshStateRefreshing];
}

-(void)initMJRefeshFooterForGif:(MJRefreshBackGifFooter *) footer{
    
    // 设置普通状态的动画图片
    [footer setImages:@[[UIImage imageNamed:@"mjRefresh"]] forState:MJRefreshStateIdle];
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    [footer setImages:@[[UIImage imageNamed:@"refresh1"],[UIImage imageNamed:@"refresh2"],[UIImage imageNamed:@"refresh3"],[UIImage imageNamed:@"refresh4"],[UIImage imageNamed:@"refresh5"],[UIImage imageNamed:@"refresh6"],[UIImage imageNamed:@"refresh7"],[UIImage imageNamed:@"refresh8"],[UIImage imageNamed:@"refresh9"],[UIImage imageNamed:@"refresh10"],[UIImage imageNamed:@"refresh11"],[UIImage imageNamed:@"refresh12"]] forState:MJRefreshStatePulling];
    // 设置正在刷新状态的动画图片
    [footer setImages:@[[UIImage imageNamed:@"refresh1"],[UIImage imageNamed:@"refresh2"],[UIImage imageNamed:@"refresh3"],[UIImage imageNamed:@"refresh4"],[UIImage imageNamed:@"refresh5"],[UIImage imageNamed:@"refresh6"],[UIImage imageNamed:@"refresh7"],[UIImage imageNamed:@"refresh8"],[UIImage imageNamed:@"refresh9"],[UIImage imageNamed:@"refresh10"],[UIImage imageNamed:@"refresh11"],[UIImage imageNamed:@"refresh12"]] forState:MJRefreshStateRefreshing];
}
-(void)getData{
    __weak LYHomeSearcherViewController * weakSelf = self;
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
- (IBAction)historyClick:(UIButton *)sender {
    _searchBar.text = sender.currentTitle;
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
    [bus getToPlayOnHomeList:hList results:^(LYErrorMessage *ermsg, NSArray *bannerList, NSArray *barList, NSArray * newbanner,NSMutableArray *bartypeslist)
     {
         if (ermsg.state == Req_Success)
         {
             if (weakSelf.curPageIndex == 1) {
                 [searchlist removeAllObjects];
                 //                [weakSelf.bannerList removeAllObjects];
             }
             
             [searchlist addObjectsFromArray:barList];
             if (searchlist.count) {
                 [self saveHisData:_searchBar.text];
             }
             [weakSelf.tableView reloadData];
         }
         block !=nil? block(ermsg,bannerList,barList):nil;
     }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(searchlist.count){
        return searchlist.count;
    }else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LYWineBarCell *wineCell = [tableView dequeueReusableCellWithIdentifier:@"wineBarCell" forIndexPath:indexPath];
    JiuBaModel *model = [searchlist objectAtIndex:indexPath.row];
    wineCell.jiuBaModel = model;
    return wineCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BeerBarDetailViewController *detailVC = [[BeerBarDetailViewController alloc]init];
    JiuBaModel *model = [searchlist objectAtIndex:indexPath.row];
    detailVC.beerBarId = @(model.barid);
    [self.navigationController pushViewController:detailVC animated:YES];
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
