//
//  MyCollectionViewController.m
//  lieyu
//
//  Created by 薛斯岐 on 15/9/23.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "MyCollectionViewController.h"
#import "CollectionCell.h"
#import "PinKeModel.h"
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
    [self getinKeList];
    // Do any additional setup after loading the view from its nib.
}
-(void)getinKeList{
    [collectionList removeAllObjects];
//    PinKeModel * pinKeModel=[[PinKeModel alloc]init];
//    pinKeModel.name=@"颜色酒吧";
//    pinKeModel.jiubaName=@"顶级最嗨最热嘿吧";
//    pinKeModel.dizhi=@"上海市浦东新区张杨北路112号";
//    pinKeModel.time=@"2016-09-09 12:00";
//    pinKeModel.money=@"￥500起";
//    PinKeModel * pinKeModel2=[[PinKeModel alloc]init];
//    pinKeModel2.name=@"颜色酒吧";
//    pinKeModel2.jiubaName=@"顶级最嗨最热嘿吧";
//    pinKeModel2.dizhi=@"上海市浦东新区张杨北路112号";
//    pinKeModel2.time=@"2016-09-09 12:00";
//    pinKeModel2.money=@"￥500起";
//    PinKeModel * pinKeModel3=[[PinKeModel alloc]init];
//    pinKeModel3.name=@"颜色酒吧";
//    pinKeModel3.jiubaName=@"顶级最嗨最热嘿吧";
//    pinKeModel3.dizhi=@"上海市浦东新区张杨北路112号";
//    pinKeModel3.time=@"2016-09-09 12:00";
//    pinKeModel3.money=@"￥500起";
//    [collectionList addObject:pinKeModel];
//    [collectionList addObject:pinKeModel2];
//    [collectionList addObject:pinKeModel3];
    
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 110;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
        return [collectionList  count];
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
    PinKeModel * pinKeModel=collectionList[indexPath.row];
//    cell.nameLal.text=pinKeModel.name;
//    cell.jiageLal.text=pinKeModel.money;
//    cell.miaosuLal.text=pinKeModel.jiubaName;
//    cell.dizhiLal.text=pinKeModel.dizhi;
//    cell.timeLal.text=pinKeModel.time;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
   [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
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
