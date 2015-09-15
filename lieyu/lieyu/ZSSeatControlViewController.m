//
//  ZSSeatControlViewController.m
//  lieyu
//
//  Created by 薛斯岐 on 15/9/14.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "ZSSeatControlViewController.h"
#import "KaZuoCell.h"
@interface ZSSeatControlViewController ()

@end

@implementation ZSSeatControlViewController
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
    [self.tableView reloadData];
    // Do any additional setup after loading the view from its nib.
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
   
    
    //    @{@"colorRGB":RGB(255, 186, 62),@"imageContent":@"classic20",@"title":@"卡座已满",@"delInfo":@""}
    cell.timeLal.text=@"今天";
    cell.timeLal.text=@"周三";
    //    cell.disImageView;
    
    
    
    
    return cell;
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 43;
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
