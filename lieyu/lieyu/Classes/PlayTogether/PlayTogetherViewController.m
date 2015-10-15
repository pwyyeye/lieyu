//
//  PlayTogetherViewController.m
//  lieyu
//
//  Created by newfly on 9/19/15.
//  Copyright (c) 2015 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "PlayTogetherViewController.h"
#import "MacroDefinition.h"
#import "LYRestfulBussiness.h"
#import "MJRefresh.h"
#import "LYHomePageHttpTool.h"
#import "LYPlayTogetherCell.h"

#import "PinKeModel.h"
@interface PlayTogetherViewController
()
{
    NSMutableArray *dataList;
    int pageCount;
    int perCount;
    NSMutableDictionary *nowDic;
}
@property(nonatomic,weak) IBOutlet UIButton * allListButton;
@property(nonatomic,weak) IBOutlet UIButton * nearDistanceButton;
@property(nonatomic,strong) IBOutlet UIButton * fillterButton;
@property(nonatomic,strong) NSArray *oriNavItems;


@end

@implementation PlayTogetherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    dataList=[[NSMutableArray alloc]init];
    pageCount=1;
    perCount=20;
    [self setupViewStyles];
    [self getDataForTogether];
    __weak __typeof(self)weakSelf = self;
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        pageCount=1;
        [dataList removeAllObjects];
        [nowDic removeObjectForKey:@"p"];
        [nowDic setObject:[NSNumber numberWithInt:pageCount] forKey:@"p"];
        [weakSelf getData:nowDic];
    }];
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [nowDic removeObjectForKey:@"p"];
        [nowDic setObject:[NSNumber numberWithInt:pageCount] forKey:@"p"];
        [self getDataWithDicMore:nowDic];
    }];
    // Do any additional setup after loading the view.

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LYPlayTogetherCell *cell = nil;
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"LYPlayTogetherCell" forIndexPath:indexPath];
    
    PinKeModel *pinKeModel =[dataList objectAtIndex:indexPath.row];
    [cell configureCell:pinKeModel];
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 113;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//        BeerBarDetailViewController * controller = [[BeerBarDetailViewController alloc] initWithNibName:@"BeerBarDetailViewController" bundle:nil];
//        [self.navigationController pushViewController:controller animated:YES];
    
}
#pragma mark 获取更多一起玩数据
-(void)getDataWithDicMore:(NSDictionary *)dic{
    __weak __typeof(self)weakSelf = self;
    [[LYHomePageHttpTool shareInstance]getTogetherListWithParams:dic block:^(NSMutableArray *result) {
        if(result.count>0){
            [dataList addObjectsFromArray:result];
            pageCount++;
            [weakSelf.tableView reloadData];
        }else{
            [weakSelf.tableView.footer noticeNoMoreData];
        }
        
        
        
    }];
    [weakSelf.tableView.footer endRefreshing];
    
}

#pragma mark 获取数据
-(void)getData:(NSDictionary *)dic{
    
    __weak __typeof(self)weakSelf = self;
    [[LYHomePageHttpTool shareInstance]getTogetherListWithParams:dic block:^(NSMutableArray *result) {
        
        NSMutableArray *arr=[result mutableCopy];
        [dataList addObjectsFromArray:arr];
        NSLog(@"****block%ld******",dataList.count);
        if(dataList.count>0){
            
            pageCount++;
            [weakSelf.tableView.footer resetNoMoreData];
        }
        [weakSelf.tableView reloadData];
        
        
        
    }];
    [weakSelf.tableView.header endRefreshing];
    
}
-(void)getDataForTogether{
//    min_num=1(最低人数)
//    max_num=2(最高人数)
//    minprice＝100 (价格区间－最低价)
//    maxprice＝1000 (价格区间－最高价)
//    need_page＝1(是否需要分页统计)
//    p=1(页码)
//    per=20(每页多少笔记录 默认20)
//    sort=距离   //-asc(排序), //价格price_cn-asc/desc
//    priceasc
//    pricedesc
//    salesasc
//    salesdesc
//    rebateasc
//    rebatedesc
    pageCount=1;
    [dataList removeAllObjects];
    NSDictionary *dic=@{@"p":[NSNumber numberWithInt:pageCount],@"per":[NSNumber numberWithInt:perCount]};
    nowDic=[[NSMutableDictionary alloc]initWithDictionary:dic];
    [self getData:dic];
}
-(void)getDataForDistance{
    //    min_num=1(最低人数)
    //    max_num=2(最高人数)
    //    minprice＝100 (价格区间－最低价)
    //    maxprice＝1000 (价格区间－最高价)
    //    need_page＝1(是否需要分页统计)
    //    p=1(页码)
    //    per=20(每页多少笔记录 默认20)
    //    sort=距离   //-asc(排序), //价格price_cn-asc/desc
    //    priceasc
    //    pricedesc
    //    salesasc
    //    salesdesc
    //    rebateasc
    //    rebatedesc
    pageCount=1;
    [dataList removeAllObjects];
    NSDictionary *dic=@{@"p":[NSNumber numberWithInt:pageCount],@"per":[NSNumber numberWithInt:perCount],@"sort":@"priceasc"};
    nowDic=[[NSMutableDictionary alloc]initWithDictionary:dic];
    [self getData:dic];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated
{
    [self performSelector:@selector(setCustomTitle:) withObject:@"一起玩" afterDelay:0.1];
    self.oriNavItems = [self.navigationController.navigationBar.items copy];
    [self.navigationController.navigationBar addSubview:_fillterButton];
    CGRect rc = _fillterButton.frame;
    rc.origin.x = 10;
    rc.origin.y = 8;
    _fillterButton.frame = rc;

}
- (void)viewWillLayoutSubviews
{

    if (self.navigationController.navigationBarHidden != NO) {
        [self.navigationController setNavigationBarHidden:NO];

    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self setCustomTitle:nil];
    [_fillterButton removeFromSuperview];
}

- (IBAction)filterClick:(id)sender
{


}

- (void)setupViewStyles
{
    // 使用颜色创建UIImage//未选中颜色
    CGSize imageSize = CGSizeMake(self.nearDistanceButton.width, self.nearDistanceButton.height);
    UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
    [RGB(255, 255, 255) set];
    UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
    UIImage *normalImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self.allListButton setBackgroundImage:normalImg forState:UIControlStateSelected];
    [self.nearDistanceButton setBackgroundImage:normalImg forState:UIControlStateSelected];
    // 使用颜色创建UIImage //选中颜色
    UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
    [RGB(229, 255, 245) set];
    UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
    UIImage *selectedImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self.allListButton setBackgroundImage:selectedImg forState:UIControlStateNormal];
    [self.nearDistanceButton setBackgroundImage:selectedImg forState:UIControlStateNormal];
    self.allListButton.selected=YES;
    
//    UINib * playTogetherNib = [UINib nibWithNibName:@"LYPlayTogetherCell" bundle:nil];
//    [self.tableView registerNib:playTogetherNib forCellReuseIdentifier:@"LYPlayTogetherCell"];
    
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - 所有列表
- (IBAction)allListAct:(UIButton *)sender {
    self.allListButton.selected=YES;
    self.nearDistanceButton.selected=NO;
    [self getDataForTogether];
}
#pragma mark - 最近距离
- (IBAction)nearDistanceAct:(UIButton *)sender {
    self.allListButton.selected=NO;
    self.nearDistanceButton.selected=YES;
    [self getDataForDistance];
}
@end
