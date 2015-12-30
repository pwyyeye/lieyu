//
//  LYFriendsChooseLocationViewController.m
//  lieyu
//
//  Created by 王婷婷 on 15/12/30.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYFriendsChooseLocationViewController.h"

@interface LYFriendsChooseLocationViewController ()<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate>
{
    CLLocationManager *_locationManager;
    CLGeocoder *_geocoder;
}

@property (nonatomic, assign) CLLocationCoordinate2D coord;//包括经纬度

@end

@implementation LYFriendsChooseLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"所在位置";
    self.tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
//    self.tableView.backgroundColor = [UIColor orangeColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
    
    
    _locationManager = [[CLLocationManager alloc]init];
    _locationManager.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //定位管理器
    if(![CLLocationManager locationServicesEnabled]){
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"定位服务当前尚未打开，请设置打开,否则无法定位签到!" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil]show ];
    }
    //如果没有授权，则请求用户授权
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined){
        [_locationManager requestWhenInUseAuthorization];
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"定位服务当前尚未授权，请进行设置,否则无法定位签到!" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil]show ];
    }else if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse){
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    }
    [_locationManager startUpdatingLocation];
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    //    for(CLLocation *location in locations){
    CLLocation *location = [[CLLocation alloc]init];
    _geocoder = [[CLGeocoder alloc]init];
    _coord = location.coordinate;
    [_geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark *placemark = [placemarks firstObject];
        //            for(CLPlacemark *placemark in placemarks){
        NSString *name=placemark.name;//地名
        NSString *thoroughfare=placemark.thoroughfare;//街道
        NSString *subThoroughfare=placemark.subThoroughfare;//街道相关信息，例如门牌等
        NSString *locality=placemark.locality; // 城市
        NSString *subLocality=placemark.subLocality; // 城市相关信息，例如标志性建筑
        NSString *administrativeArea=placemark.administrativeArea; // 州
        NSString *subAdministrativeArea=placemark.subAdministrativeArea; //其他行政区域信息
        NSString *postalCode=placemark.postalCode; //邮编
        NSString *ISOcountryCode=placemark.ISOcountryCode; //国家编码
        NSString *country=placemark.country; //国家
        NSString *inlandWater=placemark.inlandWater; //水源、湖泊
        NSString *ocean=placemark.ocean; // 海洋
        NSArray *areasOfInterest=placemark.areasOfInterest; //关联的或利益相关的地标
        NSLog(@"%@",[NSString stringWithFormat:@"%@",subThoroughfare]);
        NSLog(@"%@",name);
        //            }
    }];
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
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.detailTextLabel.textColor = [UIColor grayColor];
    }
    if(indexPath.row == 0){
        cell.textLabel.text = @"不显示位置";
    }else{
        cell.textLabel.text = @"大地点";
        cell.detailTextLabel.text = @"长长长的详细地址";
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

@end
