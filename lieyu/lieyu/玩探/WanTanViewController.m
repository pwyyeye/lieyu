//
//  WanTanViewController.m
//  lieyu
//
//  Created by 狼族 on 16/8/29.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "WanTanViewController.h"
#import "WanTanCell.h"

//#import "LYFriendsMessagesViewController.h"
#import "LYMomentsViewController.h"
#import "LYRecentContactViewController.h"
#import "LYMyFriendViewController.h"
#import "LYYuAllWishesViewController.h"
#import "FindGameCenterViewController.h"
#import "LYGuWenListViewController.h"

static NSString *wantanCellID = @"wantanCellID";

@interface WanTanViewController ()
{
    UILabel *_myTitle;
    NSString *_results;
    NSString *_icon;
    NSTimer *_timers;//定时获取我的新消息
}
@end

@implementation WanTanViewController


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar addSubview:_myTitle];
    if (self.navigationController.navigationBarHidden != NO) {
        [self.navigationController setNavigationBarHidden:NO];
    }
    _timers = [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(getNewMessage) userInfo:nil repeats:YES];//定时器获取新消息数
    [_timers fire];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //    [super setCustomTitle:@""];
    [_myTitle removeFromSuperview];
    
    [_timers invalidate];
    _timers = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WanTanCell" bundle:nil] forCellReuseIdentifier:wantanCellID];
    [self setuptitle];
    self.tableView.showsHorizontalScrollIndicator=NO;
    self.tableView.showsVerticalScrollIndicator=NO;
    self.tableView.separatorColor=[UIColor clearColor];
    self.tableView.contentInset = UIEdgeInsetsMake(70, 0, 0, 0);
    [self.view setBackgroundColor:RGB(241, 241, 241)];
}

- (void)setuptitle{
    _myTitle= [[UILabel alloc] initWithFrame: CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    _myTitle.backgroundColor = [UIColor clearColor];
    _myTitle.textColor=[UIColor blackColor];
    _myTitle.textAlignment = NSTextAlignmentCenter;
    [_myTitle setFont:[UIFont systemFontOfSize:16]];
    [_myTitle setText:@"玩探"];
}
#pragma mark - 获取我的未读消息数
- (void)getNewMessage{
    _results = @"";
    _icon = @"";
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if(app.userModel == nil)return;
    
    NSDictionary *paraDic = @{@"userId":[NSString stringWithFormat:@"%d",app.userModel.userid]};
    __weak __typeof(self) weakSelf = self;
    [LYFriendsHttpTool friendsGetFriendsMessageNotificationWithParams:paraDic compelte:^(NSString * reslults, NSString *icon) {
        _results = reslults;
        _icon = icon;
        if(_results.integerValue){
            [weakSelf.tableView reloadData];
        }
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Tableviewdatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if(section == 1) {
        return 2;
    } else if(section == 2){
        return 2;
    } else {
        return 1;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WanTanCell *cell = [tableView dequeueReusableCellWithIdentifier:wantanCellID forIndexPath:indexPath];
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];

    if (indexPath.section == 0) {
        cell.redTiPot.hidden = YES;
        [cell setIamge:[UIImage imageNamed:@"wanyouquan.png"] andLabel:@"玩友圈"];
        cell.iconImageView.layer.cornerRadius = cell.iconImageView.frame.size.height / 2;
        cell.iconImageView.layer.masksToBounds = YES;
        cell.iconImageView.image = nil;
        if (_results) {
            cell.iconImageView.image = nil;
            [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:_icon]];
            cell.smallTip.hidden = NO;
        } else {
            cell.smallTip.hidden = YES;
        }
        
    } else if(indexPath.section == 1){
        if (indexPath.row == 0) {
            
            if ([USER_DEFAULT objectForKey:@"badgeValue"]) {
                cell.redTiPot.hidden = NO;
            } else {
                cell.redTiPot.hidden = YES;
            }
            [cell setIamge:[UIImage imageNamed:@"lianxi.png"] andLabel:@"最近联系"];
        } else {
            cell.redTiPot.hidden = YES;
            [cell setIamge:[UIImage imageNamed:@"wanyoulist.png"] andLabel:@"玩友列表"];
        }
    } else if(indexPath.section == 2){
        if (indexPath.row == 0) {
            cell.redTiPot.hidden = YES;
            [cell setIamge:[UIImage imageNamed:@"xiangwan.png"] andLabel:@"大家想玩"];
        } else if(indexPath.row == 1){
            cell.redTiPot.hidden = YES;
            [cell setIamge:[UIImage imageNamed:@"wantanGW.png"] andLabel:@"娱乐顾问"];
        }
    } else {
        cell.redTiPot.hidden = YES;
        [cell setIamge:[UIImage imageNamed:@"baodian.png"] andLabel:@"娱乐宝典"];
        cell.tagIamgeView.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y,cell.frame.size.width, cell.frame.size.height + 10);
    }
    
    return cell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 60;
    } else {
        return 50;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 14)];
    view.backgroundColor=RGB(239, 239, 244);
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 4;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {//玩友圈
        LYMomentsViewController *friendsMessage = [[LYMomentsViewController alloc] init];
        friendsMessage.isFriendToUserMessage = YES;
        [self.navigationController pushViewController:friendsMessage animated:YES];
        
    } else if(indexPath.section == 1){
        if (indexPath.row == 0) {//最近联系
            //统计发现页面的选择
            NSDictionary *dict1 = @{@"actionName":@"选择",@"pageName":@"发现主页面",@"titleName":@"选择最近联系"};
            [MTA trackCustomKeyValueEvent:@"LYClickEvent" props:dict1];
            
            LYRecentContactViewController * chat=[[LYRecentContactViewController alloc]init];
            chat.title=@"最近联系";
            [self.navigationController pushViewController:chat animated:YES];
        } else {//玩友列表
            //统计发现页面的选择
            NSDictionary *dict1 = @{@"actionName":@"选择",@"pageName":@"发现主页面",@"titleName":@"选择玩友列表"};
            [MTA trackCustomKeyValueEvent:@"LYClickEvent" props:dict1];
            
            LYMyFriendViewController *myFriendViewController=[[LYMyFriendViewController alloc]initWithNibName:@"LYMyFriendViewController" bundle:nil];
            myFriendViewController.tipNum = 3;
            [self.navigationController pushViewController:myFriendViewController animated:YES];
            
        }
    } else if(indexPath.section == 2){
        if (indexPath.row == 0) {//大家想玩
            LYYuAllWishesViewController *allWishsVC = [[LYYuAllWishesViewController alloc] init];
            [self.navigationController pushViewController:allWishsVC animated:YES];
        } else if(indexPath.row == 1){//娱乐顾问
            LYGuWenListViewController *guWenListVC = [[LYGuWenListViewController alloc]init];
            guWenListVC.filterSortFlag = 1;
            guWenListVC.filterSexFlag = 2;
            guWenListVC.filterAreaFlag = 0;
            guWenListVC.cityName = [USER_DEFAULT objectForKey:@"UserChoosedLocation"]==nil?@"上海":(NSString *)[USER_DEFAULT objectForKey:@"UserChoosedLocation"];
            guWenListVC.isGuWenListVC = YES;
            guWenListVC.contentTag = 1;
            //        guWenListVC.subidStr = @"2";
            [self.navigationController pushViewController:guWenListVC animated:YES];
            
        }
    } else {//娱乐宝典
        NSDictionary *dict1 = @{@"actionName":@"选择",@"pageName":@"发现主页面",@"titleName":@"娱乐宝典"};
        [MTA trackCustomKeyValueEvent:@"LYClickEvent" props:dict1];
        
        FindGameCenterViewController *findGameVC = [[FindGameCenterViewController alloc]init];
        [self.navigationController pushViewController:findGameVC animated:YES];
    }
}




/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
