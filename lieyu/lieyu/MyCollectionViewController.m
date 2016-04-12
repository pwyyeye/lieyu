//
//  MyCollectionViewController.m
//  lieyu
//
//  Created by 薛斯岐 on 15/9/23.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "MyCollectionViewController.h"
#import "CollectionCell.h"
#import "MyBarModel.h"
#import "BeerNewBarViewController.h"
#import "LYUserHttpTool.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
@interface MyCollectionViewController ()

@end

@implementation MyCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    collectionList =[[NSMutableArray alloc]init];
    _tableView.showsHorizontalScrollIndicator=NO;
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.separatorColor=[UIColor clearColor];
    _tableView.backgroundColor=RGB(237, 237, 237);
    
    // Do any additional setup after loading the view from its nib.
}
-(void)getData{
    [collectionList removeAllObjects];
    __weak __typeof(self)weakSelf = self;
        [[LYUserHttpTool shareInstance]getMyBarWithParams:nil block:^(NSMutableArray *result) {
            [collectionList addObjectsFromArray:result];
            [weakSelf.tableView reloadData];
        }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self getData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return [collectionList  count];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 91;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
        return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CollectionCell";
    
    CollectionCell *cell = (CollectionCell *)[_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = (CollectionCell *)[nibArray objectAtIndex:0];
        cell.backgroundColor=[UIColor whiteColor];
        
        
    }
    MyBarModel * myBarModel=collectionList[indexPath.section];
    cell.nameLal.text=myBarModel.barname;
    [cell.collectionImageView setImageWithURL:[NSURL URLWithString:myBarModel.barinfo.baricon]];
    cell.jiageLal.text=[NSString stringWithFormat:@"￥%@起",myBarModel.barinfo.lowest_consumption];
    cell.miaosuLal.text=myBarModel.barinfo.subtitle;
    cell.dizhiLal.text=myBarModel.barinfo.address;
//    UILabel *lineLal=[[UILabel alloc]initWithFrame:CGRectMake(15, 95.5, 290, 0.5)];
//    lineLal.backgroundColor=RGB(199, 199, 199);
//    [cell addSubview:lineLal];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

//    cell.timeLal.text=myBarModel.c;
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
//    view.backgroundColor=RGB(239, 239, 244);
    view.backgroundColor = [UIColor redColor];
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc]initWithFrame:CGRectZero];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BeerNewBarViewController * controller = [[BeerNewBarViewController alloc] initWithNibName:@"BeerNewBarViewController" bundle:nil];
    
    JiuBaModel * model = [collectionList objectAtIndex:indexPath.section];
    controller.beerBarId = @(model.barid);
    [self.navigationController pushViewController:controller animated:YES];
   [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"取消";
}
//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return UITableViewCellEditingStyleDelete;
//}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
        return YES;
    
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        __weak __typeof(self)weakSelf = self;
        MyBarModel * myBarModel=collectionList[indexPath.section];
        NSDictionary *dic=@{@"barid":[NSNumber numberWithInt:myBarModel.barid]};
        [[LYUserHttpTool shareInstance] delMyBarWithParams:dic complete:^(BOOL result) {
            if(result){
                
                [MyUtil showMessage:@"删除成功"];
                [weakSelf getData];
            }
        }];

    }
    
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
