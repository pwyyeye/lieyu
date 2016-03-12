//
//  FindNotificationViewController.m
//  lieyu
//
//  Created by 狼族 on 16/3/8.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "FindNotificationViewController.h"
#import "FindNotificationTableViewCell.h"
#import "FindNotificationDetailViewController.h"
#import "MyMessageListViewController.h"
#import "LYFindHttpTool.h"
#import "FindNewMessage.h"
#import "LYUserHttpTool.h"
#import "MineUserNotification.h"
#import "LYCache.h"

@interface FindNotificationViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray *_titleArray;
    NSArray *_dataArray,*_typeArray;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation FindNotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"消息通知";
    MineUserNotification *minUserNotification = [[MineUserNotification alloc]init];
    minUserNotification.typeName = @"系统通知";
    minUserNotification.type = @"1";
    _titleArray = [[NSMutableArray alloc]initWithObjects:minUserNotification,nil];
//    _typeArray = @[@"14",@"13",@"11",@"1"];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:@"FindNotificationTableViewCell" bundle:nil] forCellReuseIdentifier:@"FindNotificationTableViewCell"];
   
    
    id target = self.navigationController.interactivePopGestureRecognizer.delegate;
    UIScreenEdgePanGestureRecognizer *screenGes = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:target action:@selector(handleNavigationTransition:)];
    screenGes.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:screenGes];
}

- (void)getData{
       [LYUserHttpTool getUserNotificationWithPara:nil compelte:^(NSArray *dataArray) {
           [_titleArray removeAllObjects];
           MineUserNotification *minUserNotification = [[MineUserNotification alloc]init];
           minUserNotification.typeName = @"系统通知";
           minUserNotification.type = @"1";
           [_titleArray addObject:minUserNotification];

        [_titleArray addObjectsFromArray:dataArray];
        [_tableView reloadData];
        [LYFindHttpTool getNotificationMessageWithParams:nil compelte:^(NSArray *dataArray) {
            _dataArray = dataArray;
            [_tableView reloadData];
        }];
    }];
}

- (void)handleNavigationTransition:(UIGestureRecognizer *)ges{
    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   //查询数据库有没有缓存，如果有缓存泽先利用缓存赋值
    LYCoreDataUtil *core  = [LYCoreDataUtil shareInstance];
    NSArray *dataArray = [core getCoreData:@"LYCache" andSearchPara:@{@"lyCacheKey":CACHE_SYSTEM_NOTIFICATION}];
    if(dataArray.count > 0){
        NSArray *dataArr = ((LYCache *)dataArray.firstObject).lyCacheValue;
        //        NSLog(@"%@",dataArr);
        _titleArray = [[NSMutableArray alloc]initWithArray:dataArr];
        MineUserNotification *minUserNotification = [[MineUserNotification alloc]init];
        minUserNotification.typeName = @"系统通知";
        minUserNotification.type = @"1";
        [_titleArray insertObject:minUserNotification atIndex:0];
        [self.tableView reloadData];
    }
    [self getData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FindNotificationTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"FindNotificationTableViewCell" forIndexPath:indexPath];
    MineUserNotification *userNotification =_titleArray[indexPath.row];
    cell.label_title.text = userNotification.typeName;
    cell.imgView.image = [UIImage imageNamed:userNotification.typeName];
    if (!cell.imgView.image) {
        cell.imgView.image = [UIImage imageNamed:@"findtongyong"];
    }
    if (_dataArray.count) {
        FindNewMessage *findNewM = nil;
        for( FindNewMessage *findM in _dataArray){
            if ([findM.type isEqualToString:userNotification.type]) {
                findNewM = findM;
                break;
            }
        }
//        if([cell.label_title.text isEqualToString:findNewM.type]){
        if (findNewM.count) {
            cell.label_badge.text = findNewM.count;
            cell.label_badge.hidden = NO;
            cell.imgArrow.hidden = YES;
//        }
        }else{
            cell.label_badge.hidden = YES;
            cell.imgArrow.hidden = NO;
        }
    }else{
        cell.label_badge.hidden = YES;
        cell.imgArrow.hidden = NO;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MineUserNotification *mineUserNot = _titleArray[indexPath.row];
    if ([mineUserNot.type isEqualToString:@"11"]) {
        AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        MyMessageListViewController *messageListViewController=[[MyMessageListViewController alloc]initWithNibName:@"MyMessageListViewController" bundle:nil];
        messageListViewController.title=@"信息中心";
        [app.navigationController pushViewController:messageListViewController animated:YES];
    }else{
        FindNotificationDetailViewController *notificationDetailVC = [[FindNotificationDetailViewController alloc]init];
       /* switch (indexPath.row) {
            case 0:
            {
                notificationDetailVC.type = @"14";
            }
                break;
            case 1:{
                 notificationDetailVC.type = @"13";
            }
                break;
                
            default:{
                 notificationDetailVC.type = @"1";
            }
                break;
        }*/
        notificationDetailVC.type = mineUserNot.type;
        notificationDetailVC.navigationItem.title = mineUserNot.typeName;
        [self.navigationController pushViewController:notificationDetailVC animated:YES];
    }
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

@end
