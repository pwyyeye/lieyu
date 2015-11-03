//
//  LYPlayTogetherMainViewController.m
//  lieyu
//
//  Created by 薛斯岐 on 15/10/16.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYPlayTogetherMainViewController.h"
#import "LYHomePageHttpTool.h"
#import "PTTopCell.h"
#import "PTTaoCanCell.h"
#import "PTShowIntroductionsCell.h"
#import "EScrollerView.h"
#import "LYPlayTogetherPayViewController.h"
@interface LYPlayTogetherMainViewController ()
{
    EScrollerView *scroller;
}
@end

@implementation LYPlayTogetherMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.showsHorizontalScrollIndicator=NO;
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.separatorColor=[UIColor clearColor];
    //获取详细
    [self getdata];
    // Do any additional setup after loading the view.
}
-(void)getdata{
    NSDictionary *dic=@{@"smid":[NSNumber numberWithInt:self.smid]};
    __weak __typeof(self)weakSelf = self;
    [[LYHomePageHttpTool shareInstance]getTogetherDetailWithParams:dic block:^(PinKeModel *result) {
        _pinKeModel = result;
        [weakSelf.tableView reloadData];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==1){
        if(_pinKeModel.goodsList){
            return _pinKeModel.goodsList.count;
        }else{
            return 0;
        }
        
    }else{
        return 1;
    }
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(_pinKeModel){
        return 3;
    }else{
        return 0;
    }
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section==0){
        return 1;
    }else{
        return 34;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section==0){
        return [[UIView alloc] initWithFrame:CGRectZero];
    }else{
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 34)];
        view.backgroundColor=RGB(247, 247, 247);
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(15, 11, 200, 12)];
        if(section==1){
            label.text=@"套餐内容";
        }else{
            label.text=@"拼客消费流程";
        }
        
        label.font=[UIFont systemFontOfSize:12];
        label.textColor=RGB(51, 51, 51);
        [view addSubview:label];
        return view;
    }
    
    
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    
//    return 134;
//}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    
//}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    switch (indexPath.section)
    {
        case 0:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"PTTopCell" forIndexPath:indexPath];
            if (cell) {
                PTTopCell * adCell = (PTTopCell *)cell;
                [adCell configureCell:self.pinKeModel];
                

            }
        }
            break;
        case 1:
        {
            NSArray *taocanArr=self.pinKeModel.goodsList;
            
            cell = [tableView dequeueReusableCellWithIdentifier:@"PTTaoCanCell" forIndexPath:indexPath];
            if (cell) {
                PTTaoCanCell * taocanCell = (PTTaoCanCell *)cell;
                [taocanCell configureCell:taocanArr[indexPath.row]];
                
                
            }
        }
            break;
        
        default:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"PTShowIntroductionsCell" forIndexPath:indexPath];
        }
            break;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat h = 0.0f;
    switch (indexPath.section) {
        case 0://广告
        {
            h = 305;
        }
            break;
        case 1:// 选项卡 ，酒吧或夜总会
        {
            h = 44;
        }
            break;
        
        default:
        {
            h = 162;
        }
            break;
    }
    return h;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //        BeerBarDetailViewController * controller = [[BeerBarDetailViewController alloc] initWithNibName:@"BeerBarDetailViewController" bundle:nil];
    //        [self.navigationController pushViewController:controller animated:YES];
    
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
#pragma mark 立即拼客
- (IBAction)ljpkAct:(UIButton *)sender {
    if(_pinKeModel){
        UIStoryboard *stroyBoard=[UIStoryboard storyboardWithName:@"NewMain" bundle:nil];
        LYPlayTogetherPayViewController *playTogetherPayViewController=[stroyBoard instantiateViewControllerWithIdentifier:@"LYPlayTogetherPayViewController"];
        playTogetherPayViewController.title=@"拼客详情";
        playTogetherPayViewController.smid=_pinKeModel.smid;
        [self.navigationController pushViewController:playTogetherPayViewController animated:YES];
    }
   
}
@end
