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

#define ADDRESSPAGE_MTA @"ADDRESSPAGE"
#define ADDRESSPAGE_TIMEEVENT_MTA @"ADDRESSPAGE_TIMEEVENT"


@interface LYCityChooseViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UITableView *cityListTableView;

@end

@implementation LYCityChooseViewController

-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        self.dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"城市选择";
    _dataArray = [[NSMutableArray alloc] init];
    
    
    _cityListTableView.delegate = self;
    _cityListTableView.dataSource = self;
    [_cityListTableView registerNib:[UINib nibWithNibName:@"LYCityChooseTableViewCell" bundle:nil] forCellReuseIdentifier:@"cityChooseCell"];
    
    
    
    [self getData];
    
}

//获取数据
- (void) getData
{
    [LYHomePageHttpTool getAllLocationInfoWith:nil complete:^(NSString *locationArr) {
        self.dataArray = [locationArr componentsSeparatedByString:@","];
        [_cityListTableView reloadData];
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)gotoBack{
    [self.navigationController popViewControllerAnimated:YES];
}

//- (IBAction)cityClick:(id)sender {
//    [self.navigationController popViewControllerAnimated:YES];
//    [MTA trackCustomEvent:LYCLICK_MTA args:@[@"cityChoose"]];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 1;
    } else {
        return _dataArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cityChooseCell";
    
    LYCityChooseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    if (indexPath.section == 0) {
        cell.cityNameLabel.text = _userLocation;
        cell.layer.masksToBounds = YES;
        cell.layer.cornerRadius = 8;
        cell.cityNameLabel.textColor = RGB(186, 40, 227);
        return cell;
    } else {
        cell.cityNameLabel.text = _dataArray[indexPath.row];
        if ([_dataArray[indexPath.row] isEqualToString:_userLocation]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        return cell;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        UILabel *firstLabel = [[UILabel alloc] initWithFrame:(CGRectMake(20, 0, 200, 40))];
        firstLabel.text = @"定位";
        firstLabel.font = [UIFont systemFontOfSize:13];
        UILabel *zeroLabel = [[UILabel alloc] initWithFrame:(CGRectMake(0, 0, 20, 40))];
        UILabel *blackLabel = [[UILabel alloc] initWithFrame:(CGRectMake(0, 0, 200, 40))];
        [blackLabel addSubview:firstLabel];
        [blackLabel addSubview:zeroLabel];
        return blackLabel;
    } else {
        UILabel *secondLabel = [[UILabel alloc] initWithFrame:(CGRectMake(20, 0, 200, 40))];
        secondLabel.text = @"更多城市";
        secondLabel.font = [UIFont systemFontOfSize:13];
        UILabel *zeroLabel = [[UILabel alloc] initWithFrame:(CGRectMake(0, 0, 20, 40))];
        UILabel *blackLabel = [[UILabel alloc] initWithFrame:(CGRectMake(0, 0, 200, 40))];
        [blackLabel addSubview:secondLabel];
        [blackLabel addSubview:zeroLabel];
        return blackLabel;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LYCityChooseTableViewCell *cell = [_cityListTableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    if (cell.cityNameLabel.text != nil && ![cell.cityNameLabel.text isEqualToString:[USER_DEFAULT objectForKey:@"ChooseCityLastTime"]]) {
        self.Location(cell.cityNameLabel.text);
        [USER_DEFAULT setObject:cell.cityNameLabel.text forKey:@"ChooseCityLastTime"];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    [MTA trackCustomEvent:LYCLICK_MTA args:@[@"cityChoose"]];
}

//-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    LYCityChooseTableViewCell *cell = [_cityListTableView cellForRowAtIndexPath:indexPath];
//    cell.accessoryType = UITableViewCellAccessoryNone;
//}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
