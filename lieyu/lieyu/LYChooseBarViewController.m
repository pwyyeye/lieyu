//
//  LYChooseBarViewController.m
//  lieyu
//
//  Created by 王婷婷 on 16/5/25.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYChooseBarViewController.h"
#import <AMapSearchKit/AMapSearchKit.h>

@interface LYChooseBarViewController ()<UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate,AMapSearchDelegate,MKMapViewDelegate,UISearchBarDelegate,MKMapViewDelegate>
{
    CLLocationManager *_locationManager;
    CLGeocoder *_geocoder;
    
    AMapSearchAPI *_search;
    AMapPOIAroundSearchRequest *_request;
    NSMutableArray *_poisArray;
    NSMutableArray *_annoViewArray;//annotationView的数组
//    int _oldSelectedSection;
}
@property (nonatomic, assign) int oldSelectedSection;
//记录选择的cell

@property (nonatomic, assign) CLLocationCoordinate2D coord;//包括经纬度

@end

@implementation LYChooseBarViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app startLoading];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //定位管理器
    if (![CLLocationManager locationServicesEnabled]) {
        [self showMessage:@"定位服务器尚未打开，请进入设置打开，否则无法显示酒店！"];
    }
    //如果没有用户授权，则请求
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        [_locationManager requestWhenInUseAuthorization];
        [self showMessage:@"定位服务当前尚未打开，请设置打开，否则无法定位"];
    }else{
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    }
    [_locationManager startUpdatingLocation];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _poisArray = [[NSMutableArray alloc]init];
    _annoViewArray = [[NSMutableArray alloc]init];
    //配置用户key
    [AMapSearchServices sharedServices].apiKey = @"1a62cee8b0fd0ae60c23fc8f83767d3a";
    self.title = @"选择酒吧";
    
    _oldSelectedSection = -1;
//    self.tableView.delegate = self;
//    self.tableView.dataSource = self;
//    self.mapView.delegate = self;
    _searchBar.delegate = self;
    _mapView.delegate = self;
    
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, -8, 0);
    
    _locationManager = [[CLLocationManager alloc]init];
    _locationManager.delegate = self;
    
    [_mapView setShowsUserLocation:YES];

    [self setHeaderAndFooter];
    
    _contentViewHeight.constant = SCREEN_HEIGHT - SCREEN_WIDTH;
}

#pragma mark - 初始化加载头与尾
- (void)setHeaderAndFooter{
//    __weak __typeof(self)weakSelf = self;
    
    self.tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        if (_request.page > 1) {
            _request.page --;
            [_search AMapPOIAroundSearch:_request];
        }else{
            [_tableView.mj_header endRefreshing];
        }
    }];
    MJRefreshGifHeader *header = (MJRefreshGifHeader *)self.tableView.mj_header;
    [self initMJRefeshHeaderForGif:header];
    
    self.tableView.mj_footer = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
        _request.page ++;
        [_search AMapPOIAroundSearch:_request];
    }];
    MJRefreshBackGifFooter *footer = (MJRefreshBackGifFooter *)self.tableView.mj_footer;
    [self initMJRefeshFooterForGif:footer];
}

#pragma mark - request的初始化
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(nonnull NSArray<CLLocation *> *)locations{
    if (locations.count > 0) {
        CLLocation *location = [locations firstObject];
        _geocoder = [[CLGeocoder alloc]init];
        _coord = location.coordinate;
        [self loadLocation:_coord.latitude and:_coord.longitude];
        
//        NSLog(@"_mapView.center:%@",NSStringFromCGPoint(_mapView.center));
        _mapView.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT - SCREEN_WIDTH / 2 + 64);
        
//        MKCoordinateSpan span ;
//        span.latitudeDelta = 0.2;
//        span.longitudeDelta = 0.2;
//        
//        MKCoordinateRegion region;
//        region.center = location.coordinate;
//        region.span = span;
//        
//        [_mapView setRegion:region];
        [self trackPoint:location.coordinate];
        
        [_locationManager stopUpdatingLocation];
    }else{
        [_locationManager startUpdatingLocation];
    }
}

- (void)trackPoint:(CLLocationCoordinate2D)location{
    MKCoordinateSpan span ;
    span.latitudeDelta = 0.2;
    span.longitudeDelta = 0.2;
    
    MKCoordinateRegion region;
    region.center = location;
    region.span = span;
    
    [_mapView setRegion:region];
    
//    _mapView.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT - SCREEN_WIDTH / 2 + 64);
}

- (void)loadLocation:(CGFloat)latitude and:(CGFloat)longtitude{
    //初始化检索对象
    _search = [[AMapSearchAPI alloc]init];
    _search.delegate = self;
    //构造AmapPOIAroundSearchRequest对象，设置周边请求参数
    _request = [[AMapPOIAroundSearchRequest alloc]init];
    _request.location = [AMapGeoPoint locationWithLatitude:latitude longitude:longtitude];
    
//    _mapView.userTrackingMode = MKUserTrackingModeFollow;
    _mapView.mapType = MKMapTypeStandard;
    _request.keywords = @"酒吧";
    _request.requireExtension = YES;
    _request.offset = 10;
    _request.page = 1;
    _request.radius = 10000;
    [_search AMapPOIAroundSearch:_request];
}

#pragma mark - 结束搜索回调函数
//实现POI搜索对应的回调函数
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response{
    _oldSelectedSection = -1;
    if (response.pois.count == 0) {
//        [MyUtil showPlaceMessage:@"抱歉，附近没有搜索到您所在酒吧！"];
        _request.page --;
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    if(!self.tableView.delegate || !self.tableView.dataSource){
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
    }
    [self setHeaderOrFooter:response.pois];
    self.tableView.contentOffset = CGPointMake(0, 0);
    if(_poisArray.count > 0){
        [_poisArray removeAllObjects];
    }
    [_poisArray addObjectsFromArray:response.pois];
    
    //地图上加锚点
    [self addAnnotation:_poisArray];
    //输出测试的位置
    
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app stopLoading];
//    [self.tableView.mj_footer endRefreshing];
    [self.tableView reloadData];
}

- (void)setHeaderOrFooter:(NSArray *)array{
    if ([self.tableView.mj_header isRefreshing]) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }
    if ([self.tableView.mj_footer isRefreshing]) {
        [self.tableView.mj_footer endRefreshing];
    }
    if (array.count <= 0) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
}

#pragma mark - 地图上添加锚点
- (void)addAnnotation:(NSArray *)array{
//    [_mapView removeOverlay:_mapView.overlays];
    [_mapView removeAnnotations:_mapView.annotations];
    [_annoViewArray removeAllObjects];
    
    for (int i = 0 ; i < array.count; i ++) {
        AMapPOI *pModel = [array objectAtIndex:i];
        if (pModel) {
            CLLocationCoordinate2D location = CLLocationCoordinate2DMake(pModel.location.latitude, pModel.location.longitude);
            MKPointAnnotation *annotaion = [[MKPointAnnotation alloc]init];
//            annotaion.title = [NSString stringWithFormat:@"%ld",(_request.page - 1) * 10 + i + 1];
            
            
            annotaion.title = [NSString stringWithFormat:@"%ld：%@",(_request.page - 1) * 10 + i + 1,pModel.name];
            annotaion.subtitle = pModel.address;
            [_mapView.annotations arrayByAddingObject:annotaion];
            annotaion.coordinate = location;
            [_mapView addAnnotation:annotaion];
        }
    }
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
//    NSLog(@"view.tag----%ld",view.tag);
    if (view.tag > 0) {
        int i = (view.tag - 1) % 10;
        int contentOffset = 85 * i ;
        NSLog(@"%f",(_tableView.frame.size.height / 85) * 85);
        //    if (contentOffset < ((int)_tableView.frame.size.height / 85) * 85) {
        //        self.tableView.contentOffset = CGPointMake(0, 0);
        //    }else{
        //        self.tableView.contentOffset = CGPointMake(0, 85 * (i + 1) - _tableView.frame.size.height);
        //    }
        int height = _tableView.contentOffset.y + _tableView.frame.size.height;
        if(contentOffset < _tableView.contentOffset.y){
            self.tableView.contentOffset = CGPointMake(0, contentOffset);
            
        }else if (contentOffset + 85 > height){
            self.tableView.contentOffset = CGPointMake(0, contentOffset + 85 - _tableView.frame.size.height);
        }
        [self tableView:_tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:i]];
    }
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    if ([annotation isKindOfClass:[MKPointAnnotation class]]) {
        static NSString *annotationIdentifier = @"annotationIdentifier";
        MKAnnotationView *annotationView = (MKAnnotationView *)[_mapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
        if (!annotationView) {
            annotationView = [[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:annotationIdentifier];
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(8, -5, 32, 32)];
            label.tag = 10086;
            [label setTextColor:[UIColor darkGrayColor]];
            [label setFont:[UIFont systemFontOfSize:12]];
            [annotationView addSubview:label];
        }
        UILabel *tagLabel = [annotationView viewWithTag:10086];
        NSArray *array = [annotation.title componentsSeparatedByString:@"："];
        if (array.count) {
            [tagLabel setText:array[0]];
            annotationView.tag = [array[0] intValue];
        }
//        annotationView.tag = [annotation.title intValue];
        annotationView.canShowCallout = YES;
//        annotationView.image = [UIImage imageNamed:@"address"];
        annotationView.image = [UIImage imageNamed:@"black_UnSelected.png"];
        annotationView.centerOffset = CGPointMake(0, -10);
        [_annoViewArray addObject:annotationView];
        return annotationView;
    }
    return nil;
}

#pragma mark - tableView的代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _poisArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"chooseBarCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"chooseBarCell"];
        cell.layer.shadowColor = [[UIColor blackColor]CGColor];
        cell.detailTextLabel.textColor = [UIColor grayColor];
        UILabel *numLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 30, 0, 30, 80)];
        [numLabel setFont:[UIFont systemFontOfSize:14]];
        numLabel.textAlignment = NSTextAlignmentCenter;
        numLabel.tag = 10000;
        [cell addSubview:numLabel];
    }
    AMapPOI *poiModel = [_poisArray objectAtIndex:indexPath.section];
    if (poiModel) {
        cell.textLabel.text = poiModel.name;
        cell.detailTextLabel.text = poiModel.address;
        UILabel *label = [cell viewWithTag:10000];
        [label setText:[NSString stringWithFormat:@"%ld",(_request.page - 1) * 10 + indexPath.section + 1]];
    }
//    NSLog(@"path = %ld - %ld",indexPath.section,indexPath.row);
    if ((int)indexPath.section == _oldSelectedSection) {
//        cell.selected = YES;
        [_tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    }else{
//        cell.selected = NO;
        [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
//    NSLog(@"path = %ld - %ld :selected:%d",indexPath.section,indexPath.row,cell.selected);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //如果点击了新的一行，则将原来的取消选中
    [_tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:_oldSelectedSection] animated:YES];
    [_tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    _oldSelectedSection = (int)indexPath.section;
    
    NSUInteger viewTag = ( _request.page - 1 ) * 10 + indexPath.section + 1;
    MKAnnotationView *annoView = [_mapView viewWithTag:viewTag];
    NSLog(@"%@-%@",annoView.annotation.title,annoView.annotation.subtitle);
    [_mapView selectAnnotation:annoView.annotation animated:YES];
    annoView.canShowCallout = YES;
    //根据点击的点，更改地图的中心位置
    AMapPOI *model = [_poisArray objectAtIndex:indexPath.section];
    if (model) {
        CLLocationCoordinate2D location = CLLocationCoordinate2DMake(model.location.latitude, model.location.longitude);
        NSLog(@"%f===%f", location.latitude,location.longitude)
        [_mapView setCenterCoordinate:location animated:YES];
    }
   }

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0000001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}


#pragma mark - 下方表格的起落
- (IBAction)showTable:(UIButton *)sender {
    if (_contentView.frame.size.height == 110) {
        [UIView animateWithDuration:2 animations:^{
            _contentViewHeight.constant = SCREEN_HEIGHT - SCREEN_WIDTH;
        } completion:^(BOOL finished) {
            [sender setTitle:@"收起表格" forState:UIControlStateNormal];
        }];
    }else{
        [UIView animateWithDuration:2 animations:^{
            _contentViewHeight.constant = 110;
        } completion:^(BOOL finished) {
            [sender setTitle:@"列出结果" forState:UIControlStateNormal];
        }];
    }
}

- (IBAction)backForward:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)submitBar:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"确定"]) {
        if (self.oldSelectedSection == -1) {
            [MyUtil showPlaceMessage:@"请选择酒吧！"];
        }else{
            AMapPOI *model = [_poisArray objectAtIndex:_oldSelectedSection];
//            [MyUtil showMessage:[NSString stringWithFormat:@"%@,%@",model.name,model.address]];
            NSDictionary *dict = [[NSDictionary alloc]init];
            dict = @{@"barName":model.name,
                     @"barAddress":model.address,
                     @"barLongitude":[NSString stringWithFormat:@"%f",model.location.longitude],
                     @"barLatitude":[NSString stringWithFormat:@"%f",model.location.latitude]};
            [[NSNotificationCenter defaultCenter]postNotificationName:@"chooseAMoreBar" object:nil userInfo:dict];
            [self.navigationController popViewControllerAnimated:YES];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else if ([sender.titleLabel.text isEqualToString:@"取消"]){
        [self setOrigin];
    }
}

#pragma mark - searchBar
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
//    NSLog(@"_searchBar.text:%@",_searchBar.text);
    if (![MyUtil isEmptyString:_searchBar.text]) {//empty
        _request.keywords = _searchBar.text;
        _request.radius = 50000;
        _request.page = 1;
    }else{
        _request.keywords = @"酒吧";
        _request.radius = 10000;
        _request.page = 1;
    }
    [_search AMapPOIAroundSearch:_request];
    
    [self setOrigin];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [_rightButton setTitle:@"取消" forState:UIControlStateNormal];
    [_searchBar becomeFirstResponder];
}

- (void)setOrigin{
    [_rightButton setTitle:@"确定" forState:UIControlStateNormal];
    [_searchBar setText:nil];
    [_searchBar resignFirstResponder];
}


@end
