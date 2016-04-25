//
//  LYFriendsChooseLocationViewController.m
//  lieyu
//
//  Created by 王婷婷 on 15/12/30.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYFriendsChooseLocationViewController.h"

@interface LYFriendsChooseLocationViewController ()<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate,AMapSearchDelegate>
{
    CLLocationManager *_locationManager;
    CLGeocoder *_geocoder;
    AMapSearchAPI *_search;
    AMapPOIAroundSearchRequest *request;
   
    int page;
    AppDelegate *app;
}

@property (nonatomic, assign) CLLocationCoordinate2D coord;//包括经纬度

@end

@implementation LYFriendsChooseLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    poisArray = [[NSMutableArray alloc]init];
    app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    // 配置用户key
    [AMapSearchServices sharedServices].apiKey = @"1a62cee8b0fd0ae60c23fc8f83767d3a";
    
    self.title = @"所在位置";
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
//    self.tableView.backgroundColor = [UIColor orangeColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:self.tableView];
    
    _locationManager = [[CLLocationManager alloc]init];
    _locationManager.delegate = self;
    
    [self setHeaderAndFooter];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [app startLoading];
}

- (void)setHeaderAndFooter{
//    __weak __typeof(self)weakSelf = self;
//    self.tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
//        page = 1;
//        request.page = page;
//        [_search AMapPOIAroundSearch:request];
//    }];
//    MJRefreshGifHeader *header = (MJRefreshGifHeader *)self.tableView.mj_header;
//    [self initMJRefeshHeaderForGif:header];

    self.tableView.mj_footer = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
        page ++;
        request.page = page;
        [_search AMapPOIAroundSearch:request];
    }];
    MJRefreshBackGifFooter *footer = (MJRefreshBackGifFooter *)self.tableView.mj_footer;
    [self initMJRefeshFooterForGif:footer];
}

- (void)loadLocatoin:(CGFloat)latitude and:(CGFloat)longtitude{
    //初始化检索对象
    _search = [[AMapSearchAPI alloc]init];
    _search.delegate = self;
    //构造AmapPOIAroundSearchRequest对象，设置周边请求参数
    request = [[AMapPOIAroundSearchRequest alloc]init];
    request.location = [AMapGeoPoint locationWithLatitude:latitude longitude:longtitude];
    request.types = @"010000|020000|030000|040000|050000|060000|070000|080000|090000|100000|110000|120000|130000|140000|150000|150000|160000|170000|180000|190000|200000";
    request.sortrule = 0;
    request.requireExtension = YES;
    request.page = ++page;
    //实现周边搜索
    [_search AMapPOIAroundSearch:request];
}

//实现 POI 搜索对应的回调函数
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response{
    if (response.pois.count == 0) {
//        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        return;
    }
    //通过AmapPOIAroundSearchRequest对象处理搜索结果
//    for(AMapPOI *p in response.pois){
//        NSLog(@"%@",p);
//    }
    if(!self.tableView.delegate || !self.tableView.dataSource){
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
    }
    [poisArray addObjectsFromArray:response.pois];
    [app stopLoading];
    [self.tableView.mj_footer endRefreshing];
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //定位管理器
    if(![CLLocationManager locationServicesEnabled]){
        [self showMessage:@"定位服务当前尚未打开，请设置打开,否则无法签到!"];
    }
    //如果没有授权，则请求用户授权
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined){
        [_locationManager requestWhenInUseAuthorization];
        [self showMessage:@"定位服务当前尚未打开，请设置打开,否则无法签到!"];
    }else{
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    }
    [_locationManager startUpdatingLocation];
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    //    for(CLLocation *location in locations){
    CLLocation *location = [locations firstObject];
    _geocoder = [[CLGeocoder alloc]init];
    _coord = location.coordinate;
    [self loadLocatoin:_coord.latitude and:_coord.longitude];
    [_locationManager stopUpdatingLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return poisArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.detailTextLabel.textColor = [UIColor grayColor];
    }
    if(indexPath.row == 0){
        cell.textLabel.text = @"不显示位置";
        cell.detailTextLabel.text = @"";
    }else if(indexPath.row == 1){
        cell.textLabel.text = [NSString stringWithFormat:@"%@",((AMapPOI *)poisArray[0]).city];
        cell.detailTextLabel.text = @"";
    }else{
        int i = (int)indexPath.row;
        cell.textLabel.text = [NSString stringWithFormat:@"%@%@%@",((AMapPOI *)poisArray[i-2]).city,((AMapPOI *)poisArray[i-2]).district,((AMapPOI *)poisArray[i-2]).address];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@%@%@",((AMapPOI *)poisArray[i-2]).city,((AMapPOI *)poisArray[i-2]).district,((AMapPOI *)poisArray[i-2]).name];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if(indexPath.row == 0){
        [self.delegate getLocationInfo:@"" Location:@""];
    }else if(indexPath.row == 1){
        [self.delegate getLocationInfo:cell.textLabel.text Location:cell.textLabel.text];
    }else{
        [self.delegate getLocationInfo:((AMapPOI *)poisArray[0]).city Location:cell.textLabel.text];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
