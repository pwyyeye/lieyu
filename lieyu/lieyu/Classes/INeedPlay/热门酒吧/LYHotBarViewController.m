//
//  LYHotBarViewController.m
//  lieyu
//
//  Created by lin on 16/1/26.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYHotBarViewController.h"
#import "LYHotCollectionViewCell.h"
#import "MJRefresh.h"
#import "HotMenuButton.h"

#import "ZSManageHttpTool.h"
#import "JiuBaModel.h"
#import "ProductCategoryModel.h"
#import "MReqToPlayHomeList.h"
#import "LYBaseViewController.h"
#import "LYToPlayRestfulBusiness.h"
#import "LYUserLocation.h"
#import "UIImage+GIF.h"
#import "LYCache.h"

#define PAGESIZE 20

@interface LYHotBarViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>{
    UIView *_purpleLineView;
}

@property(nonatomic,strong)NSMutableArray *bannerList;
@property(nonatomic,strong)NSMutableArray *newbannerList;
@property (weak, nonatomic) IBOutlet UICollectionView *collectView;
@property (weak, nonatomic) IBOutlet UIView *menuView;
@property(nonatomic,strong)NSMutableArray *aryList;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *menuBtnArray;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;
@property(nonatomic,assign) NSInteger curPageIndex;
@end

@implementation LYHotBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"热门酒吧";
    [_collectView registerNib:[UINib nibWithNibName:@"LYHotCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"LYHotCollectionViewCell"];
    
    self.curPageIndex = 1;
    _aryList = [[NSMutableArray alloc]initWithCapacity:0];
     [self installFreshEvent];
    [self getData];
    [self createLineForMenuView];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
//    UIButton *hotBtn = _menuBtnArray[0];
}

- (void)createLineForMenuView{
    UIButton *hotBtn = _menuBtnArray[0];
    _purpleLineView = [[UIView alloc]init];
    _purpleLineView.frame = CGRectMake(0, _menuView.size.height - 1, 42, 1);
    _purpleLineView.backgroundColor = RGBA(186, 40, 227, 1);
    _purpleLineView.center = CGPointMake(hotBtn.center.x + 12, CGRectGetCenter(_purpleLineView.frame).y);
    [_menuView addSubview:_purpleLineView];
}
- (IBAction)btnMenuViewClick:(HotMenuButton *)sender {
    for (HotMenuButton *btn in _menuBtnArray) {
        btn.isMenuSelected = NO;
    }
    sender.isMenuSelected = YES;
    [_collectView setContentOffset:CGPointMake(sender.tag * SCREEN_WIDTH, 0) animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
        UIButton *hotBtn = _menuBtnArray[0];
    CGFloat offsetWidth = scrollView.contentOffset.x;
    CGFloat hotMenuBtnWidth = hotBtn.frame.size.width;
    _purpleLineView.center = CGPointMake(offsetWidth * hotMenuBtnWidth/SCREEN_WIDTH + hotBtn.center.x, _purpleLineView.center.y);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    for (HotMenuButton *btn in _menuBtnArray) {
        btn.isMenuSelected = NO;
    }
    NSInteger index = (NSInteger)scrollView.contentOffset.x/SCREEN_WIDTH;
    HotMenuButton *btn = _menuBtnArray[index];
    btn.isMenuSelected = YES;
    
}

- (void)installFreshEvent
{
 /*   __weak LYHotBarViewController * weakSelf = self;
    //    __weak UITableView *tableView = self.tableView;
    self.collectView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:
                                ^{
                                    weakSelf.curPageIndex = 1;
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
                                             [weakSelf.tableView.mj_header endRefreshing];
                                         }
                                     }];
                                }];
    MJRefreshGifHeader *header=(MJRefreshGifHeader *)self.tableView.mj_header;
    [self initMJRefeshHeaderForGif:header];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
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
  */
}

#pragma mark 获取数据
-(void)getData{
    __weak LYHotBarViewController * weakSelf = self;
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
         }
     }];
}

- (void)loadItemList:(void(^)(LYErrorMessage *ermsg, NSArray *bannerList, NSArray *barList))block

{
    MReqToPlayHomeList * hList = [[MReqToPlayHomeList alloc] init];
    LYToPlayRestfulBusiness * bus = [[LYToPlayRestfulBusiness alloc] init];
    
    CLLocation * userLocation = [LYUserLocation instance].currentLocation;
    hList.longitude = [[NSDecimalNumber alloc] initWithString:@(userLocation.coordinate.longitude).stringValue];
    hList.latitude = [[NSDecimalNumber alloc] initWithString:@(userLocation.coordinate.latitude).stringValue];
    
//    hList.address = _addressStr;
//    hList.subids = _subidStr;
    hList.need_page = @(1);
    hList.p = @(_curPageIndex);
    hList.per = @(PAGESIZE);
    hList.titleStr = self.navigationItem.title;
    
    __weak __typeof(self)weakSelf = self;
    [bus getToPlayOnHomeList:hList pageIndex:2 results:^(LYErrorMessage *ermsg, NSArray *bannerList, NSArray *barList, NSArray *newbanner,NSMutableArray *bartypeslist)
     {
         if (ermsg.state == Req_Success)
         {
             if (weakSelf.curPageIndex == 1) {
                 [weakSelf.aryList removeAllObjects];
                 weakSelf.bannerList = bannerList.mutableCopy;
                 //                [weakSelf.bannerList removeAllObjects];
             }
             
             [weakSelf.aryList addObjectsFromArray:barList];
             [weakSelf.collectView reloadData];
//             [weakSelf noGoodsViewWith:weakSelf.aryList];
         }
         block !=nil? block(ermsg,bannerList,barList):nil;
     }];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 4;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LYHotCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LYHotCollectionViewCell" forIndexPath:indexPath];
      
    return cell;
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
