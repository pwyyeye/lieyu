//
//  LYTagTableViewController.m
//  lieyu
//
//  Created by pwy on 15/10/29.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYTagTableViewController.h"
#import "LYTagTableViewCell.h"
@interface LYTagTableViewController ()

@end

@implementation LYTagTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UINib *nib=[UINib nibWithNibName:@"LYTagTableViewCell" bundle:nil];
    
    [self.tableView registerNib:nib forCellReuseIdentifier:@"lyUserTagCell"];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;//无分割线
    _tagButtons=[NSMutableArray new];
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(makeSure)];
    [self.navigationItem setRightBarButtonItem:rightItem];
    
    self.title=@"标签";
    [[LYUserHttpTool shareInstance] getUserTags:nil block:^(NSMutableArray *result) {
        _dataArray=[self setRow:result];
        [self.tableView reloadData];
        NSLog(@"----pass-pass%@---",_dataArray);
    }];
    
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

#pragma mark酒水类型数据分成3列
-(NSMutableArray *)setRow:(NSMutableArray *)arr{
    int nowCount=1;
    NSMutableArray *pageArr=[[NSMutableArray alloc]initWithCapacity:3];
    NSMutableArray *dataArr=[[NSMutableArray alloc]init];
    for (int i=0; i<arr.count; i++) {
        UserTagModel *usertagModel= arr[i];
        
        if(nowCount%3==0){
            [pageArr addObject:usertagModel];
            [dataArr addObject:pageArr];
            pageArr=[[NSMutableArray alloc]initWithCapacity:3];
        }else{
            [pageArr addObject:usertagModel];
            if(i==arr.count-1){
                [dataArr addObject:pageArr];
            }
        }
        nowCount++;
    }
    return dataArr;
}
-(void)makeSure{

    NSMutableArray *array=[NSMutableArray new];
    
    for (LYUserTagButton *button in _tagButtons) {
        if (button.selected) {

            [array addObject:button.usertag];
        }
    }
    if (array.count>0) {
        if ([self.delegate respondsToSelector:@selector(userTagSelected:)]) {
            [self.delegate userTagSelected:array];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark table代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 37.5;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    view.backgroundColor=[UIColor whiteColor];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LYTagTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"lyUserTagCell" forIndexPath:indexPath];
    
//    static NSString *CellIdentifier = @"lyUserTagCell";
//    LYTagTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier]; //出列可重用的cell
//    cell=nil;
//    if (cell == nil) {
//        cell = [[LYTagTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"lyUserTagCell"];
//    }
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;//cell选中时的颜色
    NSArray *cellArray=_dataArray[indexPath.row];
    if (cellArray.count==3) {
        UserTagModel *tag1=[cellArray objectAtIndex:0];
        cell.button1.usertag=tag1;
        [cell.button1 setTitle:tag1.name forState:UIControlStateNormal];
        
        //将所有button放进集合
        [_tagButtons addObject:cell.button1];
        
        UserTagModel *tag2=[cellArray objectAtIndex:1];
        cell.button2.usertag=tag2;
        [cell.button2 setTitle:tag2.name forState:UIControlStateNormal];
        [_tagButtons addObject:cell.button2];
        
        UserTagModel *tag3=[cellArray objectAtIndex:2];
        cell.button3.usertag=tag3;
        [_tagButtons addObject:cell.button3];
        
        [cell.button3 setTitle:tag3.name forState:UIControlStateNormal];
        
        
    }else if(cellArray.count==2){
        UserTagModel *tag1=[cellArray objectAtIndex:0];
        cell.button1.usertag=tag1;
        [cell.button1 setTitle:tag1.name forState:UIControlStateNormal];
        [_tagButtons addObject:cell.button1];
        
        UserTagModel *tag2=[cellArray objectAtIndex:1];
        cell.button2.usertag=tag2;
        [cell.button2 setTitle:tag2.name forState:UIControlStateNormal];
        [_tagButtons addObject:cell.button2];
        
        cell.button3.hidden=YES;
    }else if (cellArray.count==1){
        UserTagModel *tag1=[cellArray objectAtIndex:0];
        cell.button1.usertag=tag1;
        [cell.button1 setTitle:tag1.name forState:UIControlStateNormal];
        [_tagButtons addObject:cell.button1];
        cell.button2.hidden=YES;
        cell.button3.hidden=YES;
    }
    
    //已选中标签设置为选中状态
    if (_selectedArray.count>0) {
        for (UserTagModel *usertag in _selectedArray) {
            for (LYUserTagButton *button in _tagButtons) {
                UserTagModel *usertag2=button.usertag;
                if (usertag.id==usertag2.id) {
                    button.selected=YES;
                }
            }
        }
    }
    
    return cell;
}


@end
