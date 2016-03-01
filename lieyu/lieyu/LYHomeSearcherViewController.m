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
#import "BeerNewBarViewController.h"
#import "JiuBaModel.h"
#import "IQKeyboardManager.h"

#define PAGESIZE 20
#define SEARCHPAGE_MTA @"SEARCHPAGE"

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
    self.edgesForExtendedLayout = UIRectEdgeAll;
    _searchBar.delegate = self;
    _searchBar.placeholder = @"搜索";
    self.navigationItem.title = @"搜索";
//    [_tableView setContentInset:UIEdgeInsetsMake(64, 0, 0, 0)];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [self setupViewStyles];
    [self.tableView registerNib:[UINib nibWithNibName:@"LYWineBarCell" bundle:nil] forCellReuseIdentifier:@"wineBarCell"];
    self.tableView.hidden = YES;
    [self loadHisData];
    hisSerchArr=[[NSMutableArray alloc]init];
    self.curPageIndex = 1;
    datalist=[[NSMutableArray alloc]init];
    _searchBar.returnKeyType = UIReturnKeySearch;
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden=YES;
}
-(void)viewWillLayoutSubviews{
    [super  viewWillLayoutSubviews];
    self.navigationController.navigationBarHidden=NO;
    
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
        self.btn_clean.hidden = YES;
         [MTA trackCustomKeyValueEvent:LYCLICK_MTA props:[self createMTADctionaryWithActionName:@"确定" pageName:SEARCHPAGE_MTA titleName:@"删除历史记录"]];
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
    if(hisSerchArr.count == 0){
        self.btn_clean.hidden = YES;
    }else{
        self.btn_clean.hidden = NO;
    }
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
    NSString *string = [searchBar.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    [searchBar endEditing:NO];
    if (!string.length) {
        self.tableView.hidden = YES;
        [MyUtil showCleanMessage:@"请输入正确字符"];
        [self loadHisData];
        return;
    }
    [self.tableView setHidden:NO];
    _curPageIndex=1;
    keyStr= searchBar.text;
    [self getData];
    [MTA trackCustomKeyValueEvent:LYCLICK_MTA props:[self createMTADctionaryWithActionName:@"确定" pageName:SEARCHPAGE_MTA titleName:@"搜索"]];
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
                [weakSelf.tableView.mj_footer endRefreshing];
            }
            
        }];
    }];
    MJRefreshBackGifFooter *footer=(MJRefreshBackGifFooter *)self.tableView.mj_footer;
    [self initMJRefeshFooterForGif:footer];
}


//-(void)initMJRefeshFooterForGif:(MJRefreshBackGifFooter *) footer{
//    
//    // 设置普通状态的动画图片
//    [footer setImages:@[[UIImage imageNamed:@"mjRefresh"]] forState:MJRefreshStateIdle];
//    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
//    [footer setImages:@[[UIImage imageNamed:@"refresh1"],[UIImage imageNamed:@"refresh2"],[UIImage imageNamed:@"refresh3"],[UIImage imageNamed:@"refresh4"],[UIImage imageNamed:@"refresh5"],[UIImage imageNamed:@"refresh6"],[UIImage imageNamed:@"refresh7"],[UIImage imageNamed:@"refresh8"],[UIImage imageNamed:@"refresh9"],[UIImage imageNamed:@"refresh10"],[UIImage imageNamed:@"refresh11"],[UIImage imageNamed:@"refresh12"]] forState:MJRefreshStatePulling];
//    // 设置正在刷新状态的动画图片
//    [footer setImages:@[[UIImage imageNamed:@"refresh1"],[UIImage imageNamed:@"refresh2"],[UIImage imageNamed:@"refresh3"],[UIImage imageNamed:@"refresh4"],[UIImage imageNamed:@"refresh5"],[UIImage imageNamed:@"refresh6"],[UIImage imageNamed:@"refresh7"],[UIImage imageNamed:@"refresh8"],[UIImage imageNamed:@"refresh9"],[UIImage imageNamed:@"refresh10"],[UIImage imageNamed:@"refresh11"],[UIImage imageNamed:@"refresh12"]] forState:MJRefreshStateRefreshing];
//}

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
                 weakSelf.tableView.mj_footer.hidden = NO;
             }
             else
             {
                 weakSelf.tableView.mj_footer.hidden = YES;
                 if(!barList.count) [MyUtil showCleanMessage:@"搜索无结果"];
             }
             //             [weakSelf.tableView.header endRefreshing];
         }
     }];
}

- (IBAction)historyClick:(UIButton *)sender {
    _searchBar.text = sender.currentTitle;
    if (sender.currentTitle==nil) {
        return;
    }
    [self searchBarSearchButtonClicked:_searchBar];
    [MTA trackCustomKeyValueEvent:LYCLICK_MTA props:[self createMTADctionaryWithActionName:@"点击历史" pageName:SEARCHPAGE_MTA titleName:sender.currentTitle]];
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
    [bus getToPlayOnHomeList:hList pageIndex:0 results:^(LYErrorMessage *ermsg, NSArray *bannerList, NSArray *barList, NSArray * newbanner,NSMutableArray *bartypeslist)
     {
         if (ermsg.state == Req_Success)
         {
             if (weakSelf.curPageIndex == 1) {
                 [searchlist removeAllObjects];
                 //                [weakSelf.bannerList removeAllObjects];
             }
             
             [searchlist addObjectsFromArray:barList];
             if (searchlist.count) {
                 [weakSelf saveHisData:_searchBar.text];
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
    wineCell.selectionStyle = UITableViewCellSelectionStyleNone;
    JiuBaModel *model = [searchlist objectAtIndex:indexPath.row];
    wineCell.jiuBaModel = model;
    return wineCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BeerNewBarViewController *detailVC = [[BeerNewBarViewController alloc]init];
    JiuBaModel *model = [searchlist objectAtIndex:indexPath.row];
    detailVC.beerBarId = @(model.barid);
    [self.navigationController pushViewController:detailVC animated:YES];
    [MTA trackCustomKeyValueEvent:LYCLICK_MTA props:[self createMTADctionaryWithActionName:@"跳转" pageName:SEARCHPAGE_MTA titleName:model.barname]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 94 + SCREEN_WIDTH / 16 * 9;
}

@end
