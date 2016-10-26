//
//  LYCityChooseViewController.m
//  lieyu
//
//  Created by 狼族 on 15/11/28.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYCityChooseViewController.h"
#import "LYHomePageHttpTool.h"
#import "LYCityChooseTableViewCell.h"
#import "CityModel.h"
#import "CityChooseButton.h"

#define ADDRESSPAGE_MTA @"ADDRESSPAGE"
#define ADDRESSPAGE_TIMEEVENT_MTA @"ADDRESSPAGE_TIMEEVENT"
//#define width ( SCREEN_WIDTH - 140 ) / 3
//#define height 35

@interface LYCityChooseViewController () <UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
{
    int width;
    int height;
    BOOL _isFilter ;
    NSMutableArray *_filterArray ;
}

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) NSArray *tempArray;
@property (nonatomic, strong) NSArray *hotCityArray;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *cityListTableView;

@end

@implementation LYCityChooseViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.title = @"城市选择";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [_searchBar setBackgroundImage:[UIImage new]];
    _searchBar.delegate = self;
    _dataArray = [[NSMutableArray alloc] init];
    _titleArray = [[NSMutableArray alloc]initWithArray:@[@"选择城市",@"热门城市"]];
    
    width = ( SCREEN_WIDTH - 75 ) / 3 ;
    height = 35;
    
    _cityListTableView.delegate = self;
    _cityListTableView.dataSource = self;
    [_cityListTableView registerNib:[UINib nibWithNibName:@"LYCityChooseTableViewCell" bundle:nil] forCellReuseIdentifier:@"LYCityChooseTableViewCell"];
    
    [self getData];
    
}

#pragma mark - 获取数据
- (void) getData
{
    [LYHomePageHttpTool getAllLocationInfoWith:nil complete:^(NSString *locationArr) {
        _tempArray = [locationArr componentsSeparatedByString:@","];
        NSMutableArray *tempCityArray = [[NSMutableArray alloc]init];
        for (NSString *name in _tempArray) {
            CityModel *cityModel = [[CityModel alloc]init];
            cityModel.cityName = name;
            [tempCityArray addObject:cityModel];
        }
        
        if (tempCityArray.count >= 9) {
            _hotCityArray = [[NSArray alloc]initWithArray:[tempCityArray subarrayWithRange:NSMakeRange(0, 9)]];
        }else{
            _hotCityArray = [[NSArray alloc]initWithArray:tempCityArray];
        }
        UILocalizedIndexedCollation *theCollation = [UILocalizedIndexedCollation currentCollation];
//        NSInteger highSection = [[theCollation sectionTitles] count];
        NSInteger highSection = 5 ;
        NSMutableArray *sectionArrays = [NSMutableArray arrayWithCapacity:highSection];
        for (int i = 0; i < highSection; i++) {
            NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
            [sectionArrays addObject:sectionArray];
        }
        for (CityModel *cityModel in tempCityArray) {
            NSInteger sect = [theCollation sectionForObject:cityModel collationStringSelector:@selector(cityName)];
            if (cityModel.cityName.length && [[cityModel.cityName substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"长"]) {
                sect = 2 ;
            }
            [((NSMutableArray *)[sectionArrays objectAtIndex:(sect / 6)]) addObject:cityModel];
        }
        NSArray *tempTitleArray = @[@"ABCDEF",@"GHIJKL",@"MNOPQR",@"STUVWX",@"YZ#"];
        for (int i = 0 ; i < highSection ; i ++ ) {
            NSMutableArray *sectionArray = [sectionArrays objectAtIndex:i];
            if (sectionArray.count > 0) {
                [_dataArray addObject:sectionArray];
                [_titleArray addObject:[tempTitleArray objectAtIndex:i]];
            }
        }
        [_cityListTableView reloadData];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_isFilter) {
        return 1;
    }else{
        return 2 + _dataArray.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_isFilter) {
        return _filterArray.count;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_isFilter) {
        static NSString *cellIdentifier = @"cityChooseFilterCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (_filterArray.count > indexPath.row) {
            [cell.textLabel setText:[_filterArray objectAtIndex:indexPath.row]];
            [cell.textLabel setTextColor:RGB(149, 149, 149)];
            [cell.textLabel setFont:[UIFont systemFontOfSize:15]];
        }
        return cell;
    }else{
        LYCityChooseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LYCityChooseTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        for (int i = 0 ; i < cell.contentView.subviews.count;) {
            [[cell.contentView.subviews objectAtIndex:i] removeFromSuperview];
        }
        NSMutableArray *cityArray ;
        if (indexPath.section == 0) {
            CityModel *cityModel = [[CityModel alloc]init];
            cityModel.cityName = _userLocation ;
            cityArray = [[NSMutableArray alloc]initWithArray:@[cityModel]];
        }else if (indexPath.section == 1){
            cityArray = [[NSMutableArray alloc]initWithArray:_hotCityArray];
        }else{
            cityArray = [[NSMutableArray alloc]initWithArray:[_dataArray objectAtIndex:(indexPath.section - 2)]];
        }
        for (int i = 0 ; i < cityArray.count ; i ++) {
            CityChooseButton *button = [[CityChooseButton alloc]initWithFrame:CGRectMake((i % 3) * (width + 20) + 15, (i / 3) * (height + 15) + 15, width, height)];
            [button setTitle:((CityModel *)[cityArray objectAtIndex:i]).cityName forState:UIControlStateNormal];
            [button addTarget:self action:@selector(chooseCity:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:button];
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_isFilter) {
        return 50;
    }else{
        if (indexPath.section == 0) {
            return 65 ;
        }else if (indexPath.section == 1){
            return (_hotCityArray.count - 1) / 3 * 50 + 65;
        }else{
            return (((NSMutableArray *)[_dataArray objectAtIndex:indexPath.section - 2]).count - 1) / 3 * 50 + 65;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_isFilter) {
        return 6;
    }else{
        return 32;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (_isFilter) {
        return nil;
    }else{
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 32)];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 10, 32)];
        [label setTextColor:RGB(161, 161, 161)];
        [label setFont:[UIFont systemFontOfSize:15]];
        if (_titleArray.count > section) {
            [label setText:[_titleArray objectAtIndex:section]];
        }
        [view addSubview:label];
        return view;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0000001;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isFilter) {
        self.Location([_filterArray objectAtIndex:indexPath.row]);
        [USER_DEFAULT setObject:[_filterArray objectAtIndex:indexPath.row] forKey:@"ChooseCityLastTime"];
        [self.navigationController popViewControllerAnimated:YES];
        [MTA trackCustomEvent:LYCLICK_MTA args:@[@"cityChoose"]];
    }
}

#pragma mark - scrollview代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == _cityListTableView) {
        [_searchBar resignFirstResponder];
    }
}

#pragma mark - searchBar代理方法
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    _isFilter = NO;
    [self.cityListTableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    _isFilter = YES;
    [self filterContentForSearchText:searchBar.text];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchText.length <= 0) {
        [searchBar resignFirstResponder];
        _isFilter = NO;
        [self.cityListTableView reloadData];
    }else{
        _isFilter = YES;
        [self filterContentForSearchText:searchText];
    }
}

#pragma mark - 筛选
- (void)filterContentForSearchText:(NSString *)searchText{
    _filterArray = [[NSMutableArray alloc]init];
    for (NSString *name in _tempArray) {
        if (name.length >= searchText.length && searchText != nil) {
            NSComparisonResult result = [name compare:searchText options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch range:NSMakeRange(0, [searchText length])];
            if (result == NSOrderedSame) {
                [_filterArray addObject:name];
            }
        }
    }
    [_cityListTableView reloadData];
}

#pragma mark - 点击按钮，选择城市
- (void)chooseCity:(UIButton *)button{
    if (button.titleLabel.text != nil && ![button.titleLabel.text isEqualToString:[USER_DEFAULT objectForKey:@"ChooseCityLastTime"]]) {
        self.Location(button.titleLabel.text);
        [USER_DEFAULT setObject:button.titleLabel.text forKey:@"ChooseCityLastTime"];
    }
    [self.navigationController popViewControllerAnimated:YES];
    [MTA trackCustomEvent:LYCLICK_MTA args:@[@"cityChoose"]];
}

@end
