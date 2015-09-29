//
//  ZSSeatControlView.m
//  lieyu
//
//  Created by SEM on 15/9/15.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "ZSSeatControlView.h"
#import "KaZuoCell.h"
#import "ZSManageHttpTool.h"
@interface ZSSeatControlView ()

@end

@implementation ZSSeatControlView

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    self.title=@"卡座满控制";
    
    //    _scrollView.contentOffset=CGPointMake(0, -kImageOriginHight+100);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    listArr =[[NSMutableArray alloc]init];
    
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    // Do any additional setup after loading the view from its nib.
}
#pragma mark -获取一周卡座信息
-(void)getKaZuoData{
    [listArr removeAllObjects];
    __weak __typeof(self)weakSelf = self;
    NSDictionary *dic=@{@"barid":@"1",@"userid":@"1"};
    [[ZSManageHttpTool shareInstance] getDeckFullWithParams:dic block:^(NSString *result) {
        
        [weakSelf.tableView reloadData];
        
    }];
     
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark tableview代理方法
#pragma mark tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"KaZuoCell";
    
    KaZuoCell *cell = (KaZuoCell *)[_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = (KaZuoCell *)[nibArray objectAtIndex:0];
        cell.backgroundColor=[UIColor whiteColor];
        
        
    }
    
    cell.isQuanManSwitch.tag=indexPath.row;
    [cell.isQuanManSwitch addTarget:self action:@selector(kazuoChoose:) forControlEvents:UIControlEventValueChanged];
    //    @{@"colorRGB":RGB(255, 186, 62),@"imageContent":@"classic20",@"title":@"卡座已满",@"delInfo":@""}
    cell.timeLal.text=@"今天";
    cell.zhouLal.text=@"周三";
    //    cell.disImageView;
    
    
    
    
    return cell;
    
    
}
-(void)kazuoChoose:(UISwitch *)sender{
    NSLog(@"*****%ld",sender.tag);
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 43;
}

@end
