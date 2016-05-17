//
//  UserNotificationViewController.m
//  lieyu
//
//  Created by 狼族 on 16/3/8.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "UserNotificationViewController.h"
#import "UserNotificationTableViewCell.h"
#import "LYUserHttpTool.h"
#import "MineUserNotification.h"

@interface UserNotificationViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSArray *_dataArray;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation UserNotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"消息通知";
    [self getData];
    // Do any additional setup after loading the view from its nib.
    
    NSLog(@"---->%@",[[UIApplication sharedApplication] currentUserNotificationSettings]);
//    NSLog(@"---->%@",setting.types);
    [_tableView registerNib:[UINib nibWithNibName:@"UserNotificationTableViewCell" bundle:nil] forCellReuseIdentifier:@"UserNotificationTableViewCell"];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}

- (void)getData{
    [LYUserHttpTool getUserNotificationWithPara:nil compelte:^(NSArray *dataArray) {
        _dataArray = dataArray;
        [_tableView reloadData];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2 + _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:{//接受推送通知
            UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = RGBA(243, 243, 243, 1);
            UILabel *titalLabel = [[UILabel alloc]init];
            titalLabel.backgroundColor = [UIColor whiteColor];
            titalLabel.frame = CGRectMake(8, 10, SCREEN_WIDTH - 16, 50);
            titalLabel.text = @"  接受推送通知";
            titalLabel.font = [UIFont systemFontOfSize:14];
            titalLabel.layer.cornerRadius = 2;
            titalLabel.layer.masksToBounds = YES;
            titalLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightLight];
            [cell.contentView addSubview:titalLabel];
            
            UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 8 - 18, 28, 8, 15)];
            imgView.image = [UIImage imageNamed:@"arrowRight"];
            [cell.contentView addSubview:imgView];
            
            UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 50 - 25, 10, 50,50 )];
            detailLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightLight];
            UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
            detailLabel.text = setting.types == UIUserNotificationTypeNone ? @"未开启" : @"开启";
            [cell.contentView addSubview:detailLabel];
            
            return cell;
        }
            break;
        case 1:{
            UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = RGBA(243, 243, 243, 1);
            UILabel *titalLabel = [[UILabel alloc]init];
            titalLabel.frame = CGRectMake(20, 8, SCREEN_WIDTH -40, 60);
            titalLabel.text = @"要开启或关闭猎娱的推送通知，请在iPhone的“设置”－“通知”中找到“猎娱”进行设置\n\n猎娱通知";
            titalLabel.font = [UIFont systemFontOfSize:12];
            titalLabel.textColor = RGBA(0, 0, 0, .4);
            titalLabel.numberOfLines = 0;
            [cell.contentView addSubview:titalLabel];
            return cell;
        }
            break;
        default:{
            
            UserNotificationTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"UserNotificationTableViewCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            MineUserNotification *userNotificationM = _dataArray[indexPath.row - 2];
             cell.notificationLabel.text = [NSString stringWithFormat:@"  %@", userNotificationM.typeName];
            cell.notificationSwitch.on = [userNotificationM.on isEqual:@"0"] ? NO:YES;
            cell.notificationSwitch.tag = indexPath.row - 2;
            if (indexPath.row == 2) {
                CAShapeLayer *shapeL = [CAShapeLayer layer];
                UIBezierPath *topRect = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, SCREEN_WIDTH - 16, cell.notificationLabel.size.height) byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(2,2)];
                shapeL.path = topRect.CGPath;
                cell.notificationLabel.layer.mask = shapeL;
            }else if(indexPath.row - 1 == _dataArray.count){
                CAShapeLayer *shapeL = [CAShapeLayer layer];
                UIBezierPath *topRect = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0,0, SCREEN_WIDTH - 16, cell.notificationLabel.size.height) byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(2,2)];
                shapeL.path = topRect.CGPath;
                cell.notificationLabel.layer.mask = shapeL;
            }else{
                cell.notificationLabel.maskView = nil;
            }
            [cell.notificationSwitch addTarget:self action:@selector(swichClick:) forControlEvents:UIControlEventValueChanged];
                                                   return cell;
        }
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            return 60;
            break;
        case 1:
            return 80;
            break;
            
        default:
            return 50;
            break;
    }
}

- (void)swichClick:(UISwitch *)sch{
    MineUserNotification *userNotificationM = _dataArray[sch.tag];
    NSString *typeStr = userNotificationM.type;
    NSDictionary *dic = nil;
    if (sch.on) {//要去开启通知
        dic = @{@"type":typeStr,@"on":@"1"};
    }else{//要去关闭通知
        dic = @{@"type":typeStr,@"on":@"0"};
    }
    [LYUserHttpTool changeUserNotificationWithPara:dic compelte:^(bool result) {
        if (!result) {
            sch.on = !sch.on;
        }
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

@end
