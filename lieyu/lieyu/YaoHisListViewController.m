//
//  YaoHisListViewController.m
//  lieyu
//
//  Created by 薛斯岐 on 15/10/30.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "YaoHisListViewController.h"
#import "LYUserHttpTool.h"
#import "LYUserLocation.h"
#import "WanYouInfoCell.h"
#import "CustomerModel.h"
#import "LYMyFriendDetailViewController.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
@interface YaoHisListViewController ()
{
    NSMutableArray *datalist;
    
}
@end

@implementation YaoHisListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    datalist =[[NSMutableArray alloc]init];

    [self getData];
    self.tableView.tableFooterView=[[UIView alloc]init];//去掉多余的分割线
    // Do any additional setup after loading the view from its nib.
}
-(void)getData{
    
    __weak __typeof(self)weakSelf = self;
    CLLocation * userLocation = [LYUserLocation instance].currentLocation;
    NSDictionary *dic=@{@"longitude":@(userLocation.coordinate.longitude),@"latitude":@(userLocation.coordinate.latitude)};
    [[LYUserHttpTool shareInstance]
     getYaoYiYaoHisFriendListWithParams:dic block:^(NSMutableArray *result) {
         [datalist removeAllObjects];
         
         [datalist addObjectsFromArray:result];
         [weakSelf.tableView reloadData];
     }];
}
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return datalist.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    WanYouInfoCell *cell = (WanYouInfoCell *)[_tableView dequeueReusableCellWithIdentifier:@"WanYouInfoCell"];
    if (cell == nil) {
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"WanYouInfoCell" owner:self options:nil];
        cell = (WanYouInfoCell *)[nibArray objectAtIndex:0];
        //            cell.backgroundColor=[UIColor whiteColor];
        
        
    }
    CustomerModel *customerModel=datalist[indexPath.row];
    [cell.userImageView  setImageWithURL:[NSURL URLWithString:customerModel.avatar_img]];
    cell.titleLal.text=customerModel.username;
    
    cell.detLal.text=[NSString stringWithFormat:@"%@米",customerModel.distance];
    if (customerModel.distance.doubleValue>1000) {
        double d=customerModel.distance.doubleValue/1000;
        cell.detLal.text=[NSString stringWithFormat:@"%.2f千米",d];
    }
    if([customerModel.sex isEqualToString:@"1"]){
        cell.sexImageView.image=[UIImage imageNamed:@"manIcon"];
    }
    UILabel *lineLal=[[UILabel alloc]initWithFrame:CGRectMake(15, 75.5, 290, 0.5)];
    lineLal.backgroundColor=RGB(199, 199, 199);
    [cell addSubview:lineLal];
    cell.accessoryType = UITableViewCellSelectionStyleNone;
    return cell;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 76.f;
    
}
#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CustomerModel *customerModel=datalist[indexPath.row];
    LYMyFriendDetailViewController *friendDetailViewController=[[LYMyFriendDetailViewController alloc]initWithNibName:@"LYMyFriendDetailViewController" bundle:nil];
    friendDetailViewController.title=@"详细信息";
    friendDetailViewController.type=@"3";
    friendDetailViewController.customerModel=customerModel;
    [self.navigationController pushViewController:friendDetailViewController animated:YES];
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
