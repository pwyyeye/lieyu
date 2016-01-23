//
//  Setting.m
//  haitao
//
//  Created by pwy on 15/7/28.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import "Setting.h"
#import "LYUserHttpTool.h"
#import "LYUserDetailInfoViewController.h"
#import "LYUserDetailController.h"
#import "AboutLieyu.h"
#import "SDImageCache.h"
#import "LYAccountManager.h"
@interface Setting ()

@end

@implementation Setting

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    _data=@[@"编辑个人资料",@"清除缓存",@"账户管理",@"关于猎娱"];
    
    
    self.title=@"个人设置";
    
    self.tableView.backgroundColor=RGB(237, 237, 237);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;//无分割线
    
    
    self.tableView.frame=CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT);
//    self.tableView.bounces=NO;
    
    UIButton *logoutButton=[[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-40-64, SCREEN_WIDTH, 40)];
    logoutButton.backgroundColor=[UIColor clearColor];
    
    [logoutButton setTitle:@"退出登录" forState:UIControlStateNormal];
    logoutButton.titleLabel.font=[UIFont systemFontOfSize:13];
    [logoutButton setTitleColor:RGB(128, 128, 128) forState:UIControlStateNormal];
    [logoutButton addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logoutButton];

    
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    [self.navigationController setNavigationBarHidden:NO];
}

-(void)logout{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [[LYUserHttpTool shareInstance] userLogOutWithParams:@{@"sessionid":app.s_app_id,@"id":[NSString stringWithFormat:@"%d",app.userModel.userid]} block:^(BOOL result) {
        if (result) {
            app.s_app_id=@"";
            app.userModel=nil;
            [USER_DEFAULT removeObjectForKey:@"username"];
            [USER_DEFAULT removeObjectForKey:@"password"];
             [self.navigationController popViewControllerAnimated:YES ];
        }
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _data.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Configure the cell...
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
   
    
//    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, cell.frame.size.height-10)];
//    label.backgroundColor=[UIColor whiteColor];
//    //清除cell背景颜色 在底部添加白色背景label 高度小于cell 使之看起来有间隔
//    cell.backgroundColor=[UIColor clearColor];
//    cell.contentView.backgroundColor=[UIColor clearColor];
//    
//    [cell.contentView insertSubview:label atIndex:0];
//    
    UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(20, 3, SCREEN_WIDTH, 50)];
    titleLabel.font=[UIFont systemFontOfSize:15.0];
    titleLabel.text=_data[indexPath.row];
    [cell.contentView addSubview:titleLabel];
    
    
    CALayer *layerShadow=[[CALayer alloc]init];
    layerShadow.frame=CGRectMake(0, cell.frame.origin.y, SCREEN_WIDTH, 5);
    layerShadow.borderColor=[RGB(237, 237, 237) CGColor];
    layerShadow.borderWidth=5;
    [cell.layer addSublayer:layerShadow];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;//cell选中时的颜色
    if(indexPath.row==0||indexPath.row==2){
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }else{
        cell.accessoryType=UITableViewCellAccessoryNone;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    UIViewController *detailViewController;
    
    if (indexPath.row==0) {
//        [self gotoAppStorePageRaisal:@""];//app评价地址
//        detailViewController=[[LYUserDetailInfoViewController alloc] init];
        detailViewController=[[LYUserDetailController alloc] init];
    }else if (indexPath.row==1) {
        [USER_DEFAULT removeObjectForKey:@"user_name"];
        [USER_DEFAULT removeObjectForKey:@"user_pass"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:UIApplicationDidReceiveMemoryWarningNotification object:nil];
        
        [[SDImageCache sharedImageCache] clearDisk];
        
        [[LYCoreDataUtil shareInstance] deleteLocalSQLLite];
        [MyUtil showMessage:@"清除成功！"];
        
    }else if(indexPath.row==2){
        detailViewController=[[LYAccountManager alloc] init];
    }else if(indexPath.row==3){
        detailViewController=[[AboutLieyu alloc] initWithNibName:@"AboutLieyu" bundle:nil];
    }

    
    // Push the view controller.
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"return"] style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationItem.backBarButtonItem = left;
    [self.navigationController pushViewController:detailViewController animated:YES];
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

//去app页面评价
-(void) gotoAppStorePageRaisal:(NSString *) nsAppId
{
    NSString  * nsStringToOpen = [NSString  stringWithFormat: @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@",nsAppId  ];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:nsStringToOpen]];
}

@end
