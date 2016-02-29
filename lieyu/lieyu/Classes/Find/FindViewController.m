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
#import "LYUserHttpTool.h"
#import "OrderTTL.h"
#import "MyMessageListViewController.h"
#import "LPUserLoginViewController.h"

@interface FindViewController ()
{
    NSArray *datalist;
    BOOL isMes;
}
@property(strong,nonatomic) OrderTTL *orderTTL;
@end

@implementation FindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    isMes=false;
    if ([USER_DEFAULT objectForKey:@"badgeValue"]) {
        isMes=true;
    }
//    self.title = @"探";
    self.automaticallyAdjustsScrollViewInsets=NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivesMessage) name:RECEIVES_MESSAGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivesMessage) name:COMPLETE_MESSAGE object:nil];
    _tableView.showsHorizontalScrollIndicator=NO;
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.separatorColor=[UIColor clearColor];
    _tableView.frame=CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    [self setuptitle];
    datalist=@[@{@"image":@"xitongtongzhi",@"title":@"系统通知"},
               @{@"image":@"zuijinlianxiren",@"title":@"最近联系"},
               @{@"image":@"lianxiren",@"title":@"玩友列表"},
//               @{@"image":@"fujinwanyou",@"title":@"附近玩客"},
              // @{@"image":@"icon_yaoyiyao_normal",@"title":@"摇一摇"},
               @{@"image":@"saoyisao",@"title":@"扫一扫"}];
    _tableView.contentInset = UIEdgeInsetsMake(70, 0, -49, 0);
   /* self.navigationController.navigationBar.layer.shadowColor = [[UIColor blackColor]CGColor];
    self.navigationController.navigationBar.layer.shadowOffset = CGSizeMake(0, 0.5);
    self.navigationController.navigationBar.layer.shadowOpacity = 0.2;
    self.navigationController.navigationBar.layer.shadowRadius = 1; */
    
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

- (void)setuptitle{
    _myTitle= [[UILabel alloc] initWithFrame: CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    
    _myTitle.backgroundColor = [UIColor clearColor];
    _myTitle.textColor=[UIColor blackColor];
    _myTitle.textAlignment = NSTextAlignmentCenter;
    [_myTitle setFont:[UIFont systemFontOfSize:16]];
    [_myTitle setText:@"探"];
}

//加载角标
-(void)loadBadge:(OrderTTL *)orderTTL{
    if (orderTTL.messageNum>0) {//消息中心
//        UILabel *badge=[[UILabel alloc] init];
//        badge.backgroundColor=[UIColor redColor];
//        badge.font=[UIFont systemFontOfSize:8];
//        badge.layer.masksToBounds=YES;
//        badge.layer.cornerRadius=6;
//        badge.textColor=[UIColor whiteColor];
//        badge.textAlignment=NSTextAlignmentCenter;
        FindMenuCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        cell.messageImageView.hidden = NO;
//        CGRect frame=_btnMessage.frame;
//        badge.frame=CGRectMake(frame.size.width-6, -3, 12, 12);
//        badge.text=[NSString stringWithFormat:@"%ld",orderTTL.messageNum];
//        badge.tag=105;
//        [_btnMessage insertSubview:badge aboveSubview:_btnMessage.titleLabel];
        
    }else{
        FindMenuCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        cell.messageImageView.hidden = YES;
//        [[_btnMessage viewWithTag:105] removeFromSuperview];
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RECEIVES_MESSAGE object:nil];
}
-(void)receivesMessage{
//    isMes=true;
    //单独启动新线程
    dispatch_async(dispatch_get_main_queue(), ^{
        // 更UI
        [_tableView reloadData];
    });
//    [NSThread detachNewThreadSelector:@selector(reloadData) toTarget:self.tableView withObject:nil];
//    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
//    [self performSelector:@selector(setCustomTitle:) withObject:@"发现" afterDelay:0.1];

    [super viewWillAppear:animated];
    //角标
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    __weak __typeof(self) weakSelf = self;
    if (![MyUtil isEmptyString:app.s_app_id]) {
        [[LYUserHttpTool shareInstance] getOrderTTL:^(OrderTTL *result) {
            _orderTTL=result;
            [weakSelf loadBadge:_orderTTL];
        }];
    }
    
//        self.navigationItem.titleView=titleText;
    [self.navigationController.navigationBar addSubview:_myTitle];
    if (self.navigationController.navigationBarHidden != NO) {
        [self.navigationController setNavigationBarHidden:NO];
    }

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
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==0){
        return 3;
    }
        return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FindMenuCell *cell = nil;
    NSDictionary *dic;
    cell = [tableView dequeueReusableCellWithIdentifier:@"FindMenuCell" forIndexPath:indexPath];
    if(indexPath.section==0){
        if (indexPath.row == 0) {
            dic=[datalist objectAtIndex:0];
            [[cell viewWithTag:100] removeFromSuperview];
            UILabel *lineLal=[[UILabel alloc]initWithFrame:CGRectMake(0, 59.5, SCREEN_WIDTH, 0.3)];
            lineLal.backgroundColor=RGB(199, 199, 199);
            lineLal.tag=100;
            [cell addSubview:lineLal];
        }else if(indexPath.row==1){
            dic=[datalist objectAtIndex:1];
            if([USER_DEFAULT objectForKey:@"badgeValue"]){//true
                [cell.messageImageView setHidden:NO];
            }else{
                [cell.messageImageView setHidden:YES];
            }
            [[cell viewWithTag:100] removeFromSuperview];
            UILabel *lineLal=[[UILabel alloc]initWithFrame:CGRectMake(0, 59.5, SCREEN_WIDTH, 0.3)];
            lineLal.backgroundColor=RGB(199, 199, 199);
            lineLal.tag=100;
            [cell addSubview:lineLal];
        }else if(indexPath.row==2){
            dic=[datalist objectAtIndex:2];
            [[cell viewWithTag:100] removeFromSuperview];
            UILabel *lineLal=[[UILabel alloc]initWithFrame:CGRectMake(0, 59.5, SCREEN_WIDTH, 0.3)];
            lineLal.backgroundColor=RGB(199, 199, 199);
            lineLal.tag=100;
            [cell addSubview:lineLal];
        }else{
            dic=[datalist objectAtIndex:3];
        }

    }
    else{
        if(indexPath.row==0){
            [[cell viewWithTag:100] removeFromSuperview];
            dic=[datalist objectAtIndex:3];
            UILabel *lineLal=[[UILabel alloc]initWithFrame:CGRectMake(0, 59.5, SCREEN_WIDTH, 0.3)];
            lineLal.tag=100;
            lineLal.backgroundColor=RGB(199, 199, 199);
            [cell addSubview:lineLal];
        }else{
//            dic=[datalist objectAtIndex:4];
        }
    }
    [cell.imageView setImage:[UIImage imageNamed:[dic objectForKey:@"image"]]];
    cell.titleLal.text=[dic objectForKey:@"title"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0){
        if (indexPath.row == 0) {
            NSDictionary *dict1 = @{@"actionName":@"选择",@"pageName":@"发现主页面",@"titleName":@"选择系统通知"};
            [MTA trackCustomKeyValueEvent:@"LYClickEvent" props:dict1];
            
            AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            MyMessageListViewController *messageListViewController=[[MyMessageListViewController alloc]initWithNibName:@"MyMessageListViewController" bundle:nil];
            messageListViewController.title=@"信息中心";
            [app.navigationController pushViewController:messageListViewController animated:YES];
            
        }else if(indexPath.row==1){
            if([USER_DEFAULT objectForKey:@"badgeValue"]==nil){
                isMes=false;
            }
            
//            [[NSNotificationCenter defaultCenter] postNotificationName:COMPLETE_MESSAGE object:nil];

            
            //统计发现页面的选择
            NSDictionary *dict1 = @{@"actionName":@"选择",@"pageName":@"发现主页面",@"titleName":@"选择最近联系"};
            [MTA trackCustomKeyValueEvent:@"LYClickEvent" props:dict1];
            
            LYRecentContactViewController * chat=[[LYRecentContactViewController alloc]init];
            chat.title=@"最近联系";
            
            
            [self.navigationController pushViewController:chat animated:YES];
        }else if(indexPath.row==2){
            //玩友列表
            
            //统计发现页面的选择
            NSDictionary *dict1 = @{@"actionName":@"选择",@"pageName":@"发现主页面",@"titleName":@"选择玩友列表"};
            [MTA trackCustomKeyValueEvent:@"LYClickEvent" props:dict1];
            
            LYMyFriendViewController *myFriendViewController=[[LYMyFriendViewController alloc]initWithNibName:@"LYMyFriendViewController" bundle:nil];
            [self.navigationController pushViewController:myFriendViewController animated:YES];
        }else{
            
            //统计发现页面的选择
            NSDictionary *dict1 = @{@"actionName":@"选择",@"pageName":@"发现主页面",@"titleName":@"选择附近的人"};
            [MTA trackCustomKeyValueEvent:@"LYClickEvent" props:dict1];
            
            LYNearFriendViewController *nearFriendViewController=[[LYNearFriendViewController alloc]initWithNibName:@"LYNearFriendViewController" bundle:nil];
            nearFriendViewController.title=@"附近的人";
            [self.navigationController pushViewController:nearFriendViewController animated:YES];
            //附近玩客
        }
        [self.tableView reloadData];
    }else{
        if(indexPath.row == 0 && NO){
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
            
            //统计发现页面的选择
//            NSDictionary *dict1 = @{@"actionName":@"选择",@"pageName":@"发现主页面",@"titleName":@"选择扫一扫"};
//            [MTA trackCustomKeyValueEvent:@"LYClickEvent" props:dict1];
//            
//            SaoYiSaoViewController *saoYiSaoViewController=[[SaoYiSaoViewController alloc]initWithNibName:@"SaoYiSaoViewController" bundle:nil];
//            saoYiSaoViewController.title=@"扫一扫";
//            [self.navigationController pushViewController:saoYiSaoViewController  animated:YES];
            
            LPUserLoginViewController *loginVC = [[LPUserLoginViewController alloc]initWithNibName:@"LPUserLoginViewController" bundle:nil];
            [self.navigationController pushViewController:loginVC animated:YES];
            
        }
    }
}


- (void)backForword{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
