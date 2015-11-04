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
#import "LYNearFriendViewController.h"
#import "LYMyFriendViewController.h"
#import "SaoYiSaoViewController.h"
#import "YaoYiYaoViewController.h"
#import "LYRecentContactViewController.h"
@interface FindViewController ()
{
    NSArray *datalist;
}
@end

@implementation FindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.showsHorizontalScrollIndicator=NO;
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.separatorColor=[UIColor clearColor];
    datalist=@[@{@"image":@"icon_zuijinglianxi_normal",@"title":@"最近联系"},
              @{@"image":@"icon_wanyouliebiao_normal",@"title":@"玩友列表"},
              @{@"image":@"icon_fujinwangke_normal",@"title":@"附近玩客"},
              @{@"image":@"icon_yaoyiyao_normal",@"title":@"摇一摇"},
              @{@"image":@"icon_saoyisao_normal",@"title":@"扫一扫"}];
//    datalist=@[
//               @{@"image":@"icon_wanyouliebiao_normal",@"title":@"玩友列表"},
//               @{@"image":@"icon_fujinwangke_normal",@"title":@"附近玩客"},
//               @{@"image":@"icon_yaoyiyao_normal",@"title":@"摇一摇"},
//               @{@"image":@"icon_saoyisao_normal",@"title":@"扫一扫"}];
//    [self setupViewStyles];
//    self.title = nil;
//    self.navigationItem.title = @"发现";
//    UILabel *titleText = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, 320, 44)];
//    
//    titleText.backgroundColor = [UIColor clearColor];
//    titleText.textColor=[UIColor whiteColor];
//    titleText.textAlignment = NSTextAlignmentCenter;
//    [titleText setFont:[UIFont systemFontOfSize:17.0]];
//    [titleText setText:@"我是导航栏标题"];
//    self.navigationItem.titleView=titleText;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
//    [self performSelector:@selector(setCustomTitle:) withObject:@"发现" afterDelay:0.1];

    [super viewWillAppear:animated];
//    [self setCustomTitle:@"发现"];
    
         _myTitle= [[UILabel alloc] initWithFrame: CGRectMake(0, 0, 320, 44)];
    
        _myTitle.backgroundColor = [UIColor clearColor];
        _myTitle.textColor=[UIColor whiteColor];
        _myTitle.textAlignment = NSTextAlignmentCenter;
        [_myTitle setFont:[UIFont systemFontOfSize:17.0]];
        [_myTitle setText:@"发现"];
//        self.navigationItem.titleView=titleText;
    [self.navigationController.navigationBar addSubview:_myTitle];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];

    if (self.navigationController.navigationBarHidden != NO) {
        [self.navigationController setNavigationBarHidden:NO];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [super setCustomTitle:@""];
    [_myTitle removeFromSuperview];

}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 14)];
    view.backgroundColor=RGB(239, 239, 244);
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 14;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==0){
        return 1;
    }
        return 2;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FindMenuCell *cell = nil;
    NSDictionary *dic;
    cell = [tableView dequeueReusableCellWithIdentifier:@"FindMenuCell" forIndexPath:indexPath];
    if(indexPath.section==0){
        dic=[datalist objectAtIndex:0];
        
    }
    else if(indexPath.section==1){
        if(indexPath.row==0){
            dic=[datalist objectAtIndex:1];
            UILabel *lineLal=[[UILabel alloc]initWithFrame:CGRectMake(15, 50.5, 290, 0.5)];
            lineLal.backgroundColor=RGB(199, 199, 199);
            [cell addSubview:lineLal];
        }else{
            dic=[datalist objectAtIndex:2];
        }
        
    }else{
        if(indexPath.row==0){
            dic=[datalist objectAtIndex:3];
            UILabel *lineLal=[[UILabel alloc]initWithFrame:CGRectMake(15, 50.5, 290, 0.5)];
            lineLal.backgroundColor=RGB(199, 199, 199);
            [cell addSubview:lineLal];
        }else{
            dic=[datalist objectAtIndex:4];
        }
    }
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
    if(indexPath.section==0){
        LYRecentContactViewController * chat=[[LYRecentContactViewController alloc]init];
        chat.title=@"最近联系";
        [self.navigationController pushViewController:chat animated:YES];
    }
    else if(indexPath.section==1){
        if(indexPath.row==0){
            //玩友列表
            LYMyFriendViewController *myFriendViewController=[[LYMyFriendViewController alloc]initWithNibName:@"LYMyFriendViewController" bundle:nil];
            [self.navigationController pushViewController:myFriendViewController animated:YES];
        }else{
            LYNearFriendViewController *nearFriendViewController=[[LYNearFriendViewController alloc]initWithNibName:@"LYNearFriendViewController" bundle:nil];
            nearFriendViewController.title=@"附近的人";
            [self.navigationController pushViewController:nearFriendViewController animated:YES];
            //附近玩客
        }
    }else{
        if(indexPath.row==0){
            //摇一摇
            YaoYiYaoViewController *yaoYiYaoViewController;
            if([[MyUtil deviceString] isEqualToString:@"iPhone 4S"]||[[MyUtil deviceString] isEqualToString:@"iPhone 4"]){
                yaoYiYaoViewController=[[YaoYiYaoViewController alloc]initWithNibName:@"YaoYiYaoViewController4" bundle:nil];
                yaoYiYaoViewController.is4s=true;
            }else{
                yaoYiYaoViewController=[[YaoYiYaoViewController alloc]initWithNibName:@"YaoYiYaoViewController" bundle:nil];
                yaoYiYaoViewController.is4s=false;
            }
//            yaoYiYaoViewController=[[YaoYiYaoViewController alloc]initWithNibName:@"YaoYiYaoViewController4" bundle:nil];
//            yaoYiYaoViewController.is4s=true;
            yaoYiYaoViewController.title=@"摇一摇";
            [self.navigationController pushViewController:yaoYiYaoViewController  animated:YES];
            
        }else{
            //扫一扫
            SaoYiSaoViewController *saoYiSaoViewController=[[SaoYiSaoViewController alloc]initWithNibName:@"SaoYiSaoViewController" bundle:nil];
            saoYiSaoViewController.title=@"扫一扫";
            [self.navigationController pushViewController:saoYiSaoViewController  animated:YES];
        }
    }
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
