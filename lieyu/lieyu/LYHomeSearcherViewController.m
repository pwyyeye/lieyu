//
//  LYHomeSearcherViewController.m
//  lieyu
//
//  Created by 狼族 on 15/11/29.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYHomeSearcherViewController.h"
#import "NetPublic.h"
#import "LYToPlayRestfulBusiness.h"
#import "MReqToPlayHomeList.h"
#import "HomeBarCollectionViewCell.h"
#import "BiaoQianBtn.h"
#import "TypeChooseCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "BeerNewBarViewController.h"
#import "JiuBaModel.h"
#import "IQKeyboardManager.h"
#import "LYUserLocation.h"
#import "LYAdviserHttpTool.h"
#import "LYGuWenPersonCollectionViewCell.h"
#import "LYMyFriendDetailViewController.h"
#import "LYFriendsHttpTool.h"
#import "LYLiveShowListModel.h"
#import "LYSearchLiveShowCollectionViewCell.h"
#import "WatchLiveShowViewController.h"

#define PAGESIZE 20
#define SEARCHPAGE_MTA @"SEARCHPAGE"

@interface LYHomeSearcherViewController ()<UISearchBarDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    NSArray *datalist;
    NSString *keyStr;
    NSMutableArray *hisRoute;
    NSArray *btnArr;
    
    NSMutableDictionary *_managerDict;
    int _managerPage;
}
@property(nonatomic,assign) NSInteger curPageIndex;
@end

@implementation LYHomeSearcherViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    if (_isSearchBar) {
        self.title = @"搜索酒吧";
    }else{
        self.title = @"搜索直播";
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    searchlist = [[NSMutableArray alloc]initWithCapacity:0];
    self.edgesForExtendedLayout = UIRectEdgeAll;
    _searchBar.delegate = self;
    _searchBar.placeholder = @"搜索";
    [_searchBar becomeFirstResponder];
    //    [_tableView setContentInset:UIEdgeInsetsMake(64, 0, 0, 0)];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    if(_isSearchBar){
        [self setupViewStyles];
    }else{
        [self setupManagerViewStyles];
        _managerDict = [[NSMutableDictionary alloc]init];
        _managerPage = 1;
    }
    if (_isSearchBar) {
        [self.collectView registerNib:[UINib nibWithNibName:@"HomeBarCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HomeBarCollectionViewCell"];
    }else{
//        [self.collectView registerNib:[UINib nibWithNibName:@"LYGuWenPersonCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"LYGuWenPersonCollectionViewCell"];
        [self.collectView registerNib:[UINib nibWithNibName:@"LYSearchLiveShowCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"LYSearchLiveShowCollectionViewCell"];
    }
    self.collectView.hidden = YES;
    [self loadHisData];
    hisSerchArr=[[NSMutableArray alloc]init];
    self.curPageIndex = 1;
    datalist=[[NSMutableArray alloc]init];
    _searchBar.returnKeyType = UIReturnKeySearch;
    
    for (id img in (_searchBar.subviews[0]).subviews)
    {
        NSLog(@"%@",(_searchBar.subviews[0]).subviews);
        if ([img isKindOfClass:NSClassFromString(@"UISearchBarBackground")])
        {
            //            [img removeFromSuperview];
            
        }
        if ([img isKindOfClass:NSClassFromString(@"UISearchBarTextField")])
        {
            UITextField *textField = (UITextField *)img;
            //            textField.clipsToBounds = YES;
            textField.backgroundColor = RGBA(234, 235, 240, 1);
        }
        
    }
    _searchBar.backgroundImage = [MyUtil getImageFromColor:[UIColor whiteColor]];
    _searchBar.barTintColor = [UIColor whiteColor];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_searchBar.frame), SCREEN_WIDTH, 0.5)];
    lineView.backgroundColor = RGBA(228, 229, 230, 1);
    [self.view addSubview:lineView];
    
}

//- (void)gotoBack{
//    [self.navigationController popViewControllerAnimated:YES];
//}

#pragma mark 获取历史搜索数据
-(void)loadHisData{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *Path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filename;
    if (_isSearchBar) {
        filename = [Path stringByAppendingPathComponent:@"hisSerchData.plist"];
    }else{
        filename = [Path stringByAppendingPathComponent:@"hisSearchLiveShowData.plist"];
    }
    
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
        NSString *filename;
        if (_isSearchBar) {
            filename = [Path stringByAppendingPathComponent:@"hisSerchData.plist"];
        }else{
            filename = [Path stringByAppendingPathComponent:@"hisSearchLiveShowData.plist"];
        }
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
    NSString *filename;
    if (_isSearchBar) {
        filename = [Path stringByAppendingPathComponent:@"hisSerchData.plist"];
    }else{
        filename = [Path stringByAppendingPathComponent:@"hisSearchLiveShowData.plist"];
    }
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
        button.layer.borderColor = COMMON_PURPLE.CGColor;
        button.layer.cornerRadius = 1.8;
        button.layer.masksToBounds = YES;
        NSString *str = hisSerchArr[i];
        [button setTitle:str
                forState:UIControlStateNormal];
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (!searchBar.text.length) {
        self.collectView.hidden = YES;
        [self loadHisData];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSString *string = [searchBar.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    [searchBar endEditing:NO];
    if (!string.length) {
        self.collectView.hidden = YES;
        [MyUtil showCleanMessage:@"请输入正确字符"];
        [self loadHisData];
        return;
    }
    [searchlist removeAllObjects];
    [self.collectView reloadData];
    [self.collectView setHidden:NO];
    _curPageIndex=1;
    _managerPage = 1;
    keyStr= searchBar.text;
    if (_isSearchBar) {
        [self getData];
    }else{
        [self getManagerData];
    }
    [MTA trackCustomKeyValueEvent:LYCLICK_MTA props:[self createMTADctionaryWithActionName:@"确定" pageName:SEARCHPAGE_MTA titleName:@"搜索"]];
}

- (void)setupManagerViewStyles{
    __weak __typeof(self)weakSelf = self;
    _collectView.mj_footer = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
        [weakSelf getManagerData];
    }];
    MJRefreshBackGifFooter *footer = (MJRefreshBackGifFooter *)_collectView.mj_footer;
    [self initMJRefeshFooterForGif:footer];
}

- (void)setupViewStyles
{
    __weak LYHomeSearcherViewController * weakSelf = self;
    //    [self.collectView registerNib:[UINib nibWithNibName:@"LYWineBaraCell" bundle:nil] forCellReuseIdentifier:@"wineBarCell"];
    self.collectView.mj_footer = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
        [weakSelf loadItemList:^(LYErrorMessage *ermsg, NSArray *bannerList, NSArray *barList) {
            if (Req_Success == ermsg.state) {
                if (barList.count == PAGESIZE)
                {
                    weakSelf.collectView.mj_footer.hidden = NO;
                }
                else
                {
                    weakSelf.collectView.mj_footer.hidden = YES;
                }
                weakSelf.curPageIndex ++;
                [weakSelf.collectView.mj_footer endRefreshing];
            }
            
        }];
    }];
    MJRefreshBackGifFooter *footer=(MJRefreshBackGifFooter *)self.collectView.mj_footer;
    [self initMJRefeshFooterForGif:footer];
}

- (void)getManagerData{
    __weak __typeof(self) weakSelf = self;
    NSDictionary *dict = @{@"roomName":keyStr,
                           @"page":[NSString stringWithFormat:@"%d",_managerPage]};
    [LYFriendsHttpTool getLiveShowlistWithParams:dict complete:^(NSArray *Arr) {
        [weakSelf saveHisData:keyStr];
        if (Arr.count) {
            if (_managerPage == 1) {
                [searchlist removeAllObjects];
                [_collectView.mj_header endRefreshing];
            }
            [searchlist addObjectsFromArray:Arr];
            [_collectView.mj_footer endRefreshing];
            _managerPage ++;
        }else{
            if (_managerPage == 1) {
                [MyUtil showPlaceMessage:@"搜索无结果"];
                [_collectView.mj_header endRefreshing];
            }else{
                [_collectView.mj_footer endRefreshingWithNoMoreData];
            }
        }
        [_collectView reloadData];
    }];
//    [LYAdviserHttpTool lyGetAdviserListWithParams:dict complete:^(HomePageModel *model) {
//        NSArray *arrayTemp = model.viplist;
//        [weakSelf saveHisData:keyStr];
//        if(arrayTemp.count){
//            if (_managerPage == 1) {
//                [searchlist removeAllObjects];
//                [_collectView.mj_header endRefreshing];
//            }
//            [searchlist addObjectsFromArray:arrayTemp];
//            [_collectView.mj_footer endRefreshing];
//            
//            _managerPage ++;
//        }else{
//            if (_managerPage == 1) {
//                [MyUtil showCleanMessage:@"搜索无结果"];
//                [_collectView.mj_header endRefreshing];
//            }else{
//                [_collectView.mj_footer endRefreshingWithNoMoreData];
//            }
//        }
//        [_collectView reloadData];
//    }];
}

-(void)getData{
    __weak LYHomeSearcherViewController * weakSelf = self;
    [weakSelf loadItemList:^(LYErrorMessage *ermsg, NSArray *bannerList, NSArray *barList)
     {
         if (Req_Success == ermsg.state)
         {
             if (barList.count == PAGESIZE)
             {
                 weakSelf.curPageIndex = 2;
                 weakSelf.collectView.mj_footer.hidden = NO;
             }
             else
             {
                 weakSelf.collectView.mj_footer.hidden = YES;
                 
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
             }else{
                 [MyUtil showCleanMessage:@"搜索无结果"];
             }
             [weakSelf.collectView reloadData];
         }
         block !=nil? block(ermsg,bannerList,barList):nil;
     }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(searchlist.count){
        return searchlist.count;
    }else {
        return 0;
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 3;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 3;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
//    if (_isSearchBar) {
        return UIEdgeInsetsMake(3, 3, 3, 3);
//    }else{
//        return UIEdgeInsetsMake(0, 0, 0, 0);
//    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (_isSearchBar) {
        return CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH * 9 /16 + 57);
    }else{
        return CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH * 0.7);
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (_isSearchBar) {
        HomeBarCollectionViewCell *cell = [_collectView dequeueReusableCellWithReuseIdentifier:@"HomeBarCollectionViewCell" forIndexPath:indexPath];
        JiuBaModel *jiubaM = searchlist[indexPath.item];
        cell.jiuBaM = jiubaM;
        return cell;
    }else{
        LYSearchLiveShowCollectionViewCell *cell = [_collectView dequeueReusableCellWithReuseIdentifier:@"LYSearchLiveShowCollectionViewCell" forIndexPath:indexPath];
        cell.listModel = [searchlist objectAtIndex:indexPath.item];
        [cell setBackgroundColor:[UIColor redColor]];
//        LYGuWenPersonCollectionViewCell *cell = [_collectView dequeueReusableCellWithReuseIdentifier:@"LYGuWenPersonCollectionViewCell" forIndexPath:indexPath];
//        cell.vipModel = [searchlist objectAtIndex:indexPath.item];
        return cell;
    }
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (_isSearchBar) {BeerNewBarViewController *detailVC = [[BeerNewBarViewController alloc]init];
        JiuBaModel *model = [searchlist objectAtIndex:indexPath.item];
        detailVC.beerBarId = @(model.barid);
        [self.navigationController pushViewController:detailVC animated:YES];
        [MTA trackCustomKeyValueEvent:LYCLICK_MTA props:[self createMTADctionaryWithActionName:@"跳转" pageName:SEARCHPAGE_MTA titleName:model.barname]];
    }else{
//        UserModel *model = (UserModel *)[searchlist objectAtIndex:indexPath.item];
//        LYMyFriendDetailViewController *detailVC = [[LYMyFriendDetailViewController alloc]init];
//        detailVC.userID = [NSString stringWithFormat:@"%d",model.userid];
//        [self.navigationController pushViewController:detailVC animated:YES];
        
        LYLiveShowListModel *model = [searchlist objectAtIndex:indexPath.item];
        WatchLiveShowViewController *watchLiveVC = [[WatchLiveShowViewController alloc]init];
        NSString *roomId = [NSString stringWithFormat:@"%d",model.roomId];
        NSDictionary *dict = @{@"roomid":roomId};
        __weak __typeof(self) weakSelf = self;
        [LYFriendsHttpTool getLiveShowRoomWithParams:dict complete:^(NSDictionary *Arr) {
            if ([Arr[@"roomType"] isEqualToString:@"live"]) {
                watchLiveVC.contentURL = Arr[@"liveRtmpUrl"];
                watchLiveVC.chatRoomId = Arr[@"chatroomid"];
            } else {
                watchLiveVC.contentURL = Arr[@"playbackURL"];
                watchLiveVC.chatRoomId = nil;
            }
            watchLiveVC.hostUser = Arr[@"roomHostUser"];
            NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:model.roomImg]];
            watchLiveVC.shareIamge = [UIImage imageWithData:data];
            [weakSelf.navigationController pushViewController:watchLiveVC animated:YES];
            [MTA trackCustomKeyValueEvent:LYCLICK_MTA props:[self createMTADctionaryWithActionName:@"跳转" pageName:SEARCHPAGE_MTA titleName:roomId]];
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
