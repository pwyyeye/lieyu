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
    
    [[LYUserHttpTool shareInstance] getUserTags:nil block:^(NSMutableArray *result) {
        _dataArray=[self setRow:result];
        
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

#pragma mark table代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"lyUserTagCell" forIndexPath:indexPath];
    
    static NSString *CellIdentifier = @"lyUserTagCell";
    LYTagTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier]; //出列可重用的cell
    cell=nil;
    if (cell == nil) {
        cell = [[LYTagTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"lyUserTagCell"];
    }
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;//cell选中时的颜色
    NSArray *cellArray=_dataArray[indexPath.section];
    if (cellArray.count==3) {
        cell.button1.usertag=[cellArray objectAtIndex:0];
        cell.button2.usertag=[cellArray objectAtIndex:1];
        cell.button3.usertag=[cellArray objectAtIndex:2];
    }else if(cellArray.count==2){
        cell.button1.usertag=[cellArray objectAtIndex:0];
        cell.button2.usertag=[cellArray objectAtIndex:1];
        cell.button1.hidden=YES;
    }else if (cellArray.count==1){
        cell.button1.usertag=[cellArray objectAtIndex:0];
        cell.button2.hidden=YES;
        cell.button1.hidden=YES;
    }
    
    return cell;
}


@end
