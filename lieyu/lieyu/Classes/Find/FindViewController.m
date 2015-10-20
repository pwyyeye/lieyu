//
//  FindViewController.m
//  lieyu
//
//  Created by newfly on 9/19/15.
//  Copyright (c) 2015 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "FindViewController.h"
#import "MacroDefinition.h"
#import "FindMenuCell.h"
@interface FindViewController ()
{
    NSArray *datalist;
}
@end

@implementation FindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    datalist=@[@{@"image":@"icon_zuijinglianxi_normal",@"title":@"最近联系"},
              @{@"image":@"icon_wanyouliebiao_normal",@"title":@"玩友列表"},
              @{@"image":@"icon_fujinwangke_normal",@"title":@"附近玩客"},
              @{@"image":@"icon_yaoyiyao_normal",@"title":@"摇一摇"},
              @{@"image":@"icon_saoyisao_normal",@"title":@"扫一扫"}];
    
    [self setupViewStyles];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupViewStyles
{
    self.title = @"发现";
}

- (void)viewWillAppear:(BOOL)animated
{
//    [self performSelector:@selector(setCustomTitle:) withObject:@"发现" afterDelay:0.1];

    [super viewWillAppear:animated];
}

- (void)viewWillLayoutSubviews
{

    if (self.navigationController.navigationBarHidden != NO) {
        [self.navigationController setNavigationBarHidden:NO];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self setCustomTitle:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return datalist.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FindMenuCell *cell = nil;
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"FindMenuCell" forIndexPath:indexPath];
    
    NSDictionary *dic =[datalist objectAtIndex:indexPath.section];
    [cell.imageView setImage:[UIImage imageNamed:[dic objectForKey:@"image"]]];
    cell.titleLal.text=[dic objectForKey:@"title"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 51;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //        BeerBarDetailViewController * controller = [[BeerBarDetailViewController alloc] initWithNibName:@"BeerBarDetailViewController" bundle:nil];
    //        [self.navigationController pushViewController:controller animated:YES];
    
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
