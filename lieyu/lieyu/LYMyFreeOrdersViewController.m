//
//  LYMyFreeOrdersViewController.m
//  lieyu
//
//  Created by 王婷婷 on 16/6/15.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYMyFreeOrdersViewController.h"
#import "FreeOrderTableViewCell.h"
#import "LPOrderButton.h"
#import "LYUserHttpTool.h"
#import "LYFreeOrderModel.h"
#import "LYFindConversationViewController.h"
#import "IQKeyboardManager.h"

#define LIMIT 10

@interface LYMyFreeOrdersViewController ()
{
    int _start;
    NSString *_type;
    NSMutableArray *_dataArray;
    NSMutableDictionary *_searchDict;
}
@end

@implementation LYMyFreeOrdersViewController

- (void)viewDidLoad {
    _dataArray = [[NSMutableArray alloc]init];
    if ([self.userModel.usertype isEqualToString:@"2"]|| [self.userModel.usertype isEqualToString:@"3"]) {
        _type = @"1";
        BOOL shanghuban = [[NSUserDefaults standardUserDefaults] boolForKey:@"shanghuban"];
        if(!shanghuban)_type = @"0";
        
        if (_isManager) {
            _type = @"1";
        }
    }else{
        _type = @"0";
    }
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    NSLog(@"----pass-pass%@---",@"test delloc");
}


- (void)registerCells{
    [myTableView registerNib:[UINib nibWithNibName:@"FreeOrderTableViewCell" bundle:nil] forCellReuseIdentifier:@"FreeOrderTableViewCell"];
}

#pragma mark - 根据按钮tag获取对应数据
- (void)changeTableViewAtIndex:(int)newTag{
    for (LPOrderButton *btn in arrayButton) {
        //        NSLog(@"%ld--%d",btn.tag,newTag);
        if (btn.tag == newTag) {
            btn.selected = YES;
        }else{
            btn.selected = NO;
        }
    }
    switch (newTag) {
        case 0:
            [self getAllOrder];
            break;
        case 1:
            [self getDaiQueRen];
            break;
        case 2:
            [self getDaiPingJia];
            break;
        case 3:
            [self getYiPingJia];
            break;
        default:
            break;
    }
}

- (void)getAllOrder{
    _start = 0 ;
    NSDictionary *dict = @{@"type":_type,
                           @"start":[NSNumber numberWithInt:_start],
                           @"limit":[NSNumber numberWithInt:LIMIT]};
    _searchDict = [[NSMutableDictionary alloc]initWithDictionary:dict];
    [self getOrderWithDic:dict];
}

- (void)getDaiQueRen{
    _start = 0 ;
    NSDictionary *dict = @{@"type":_type,
                           @"start":[NSNumber numberWithInt:_start],
                           @"limit":[NSNumber numberWithInt:LIMIT],
                           @"orderStatus":@"1"};
    _searchDict = [[NSMutableDictionary alloc]initWithDictionary:dict];
    [self getOrderWithDic:dict];
}

- (void)getDaiPingJia{
    _start = 0 ;
    NSDictionary *dict = @{@"type":_type,
                           @"start":[NSNumber numberWithInt:_start],
                           @"limit":[NSNumber numberWithInt:LIMIT],
                           @"orderStatus":@"2"};
    _searchDict = [[NSMutableDictionary alloc]initWithDictionary:dict];
    [self getOrderWithDic:dict];
}

- (void)getYiPingJia{
    _start = 0 ;
    NSDictionary *dict = @{@"type":_type,
                           @"start":[NSNumber numberWithInt:_start],
                           @"limit":[NSNumber numberWithInt:LIMIT],
                           @"orderStatus":@"3"};
    _searchDict = [[NSMutableDictionary alloc]initWithDictionary:dict];
    [self getOrderWithDic:dict];
}

- (void)getOrderWithDic:(NSDictionary *)dict{
    __weak __typeof(self)weakSelf = self;
    [[LYUserHttpTool shareInstance]getMyFreeOrdersWithParams:dict block:^(NSArray *dataArray) {
        if (_start == 0) {
            [_dataArray removeAllObjects];
            
            myTableView.contentOffset = CGPointMake(0, -90);
            [myTableView.mj_header endRefreshing];
        }
        _start = _start + LIMIT;
        [_dataArray addObjectsFromArray:dataArray];
        if (dataArray.count) {
            [myTableView.mj_footer endRefreshing];
        }else{
            [myTableView.mj_footer endRefreshingWithNoMoreData];
        }
        if (_dataArray.count) {
            [weakSelf hideKongView];
        }else{
            [weakSelf addKongView];
        }
        [myTableView reloadData];
    }];
}

#pragma mark - 刷新数据
- (void)refreshData{
    _start = 0 ;
    [_searchDict removeObjectForKey:@"start"];
    [_searchDict setObject:[NSNumber numberWithInt:_start] forKey:@"start"];
    [self getOrderWithDic:_searchDict];
}

- (void)loadMoreData{
    [_searchDict removeObjectForKey:@"start"];
    [_searchDict setObject:[NSNumber numberWithInt:_start] forKey:@"start"];
    [self getOrderWithDic:_searchDict];
}

#pragma mark - tableView代理事件
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FreeOrderTableViewCell *cell = [myTableView dequeueReusableCellWithIdentifier:@"FreeOrderTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    LYFreeOrderModel *model = (LYFreeOrderModel *)[_dataArray objectAtIndex:indexPath.section];
    model.isManager=_isManager;
    cell.freeOrder = model;
    cell.messageButton.tag = indexPath.section;
    cell.phoneButton.tag = indexPath.section;
    cell.firstButton.tag = indexPath.section;
    cell.secondButton.tag = indexPath.section;
    
    [cell.messageButton addTarget:self action:@selector(messageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.phoneButton addTarget:self action:@selector(phoneButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.firstButton addTarget:self action:@selector(firstButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.secondButton addTarget:self action:@selector(secondButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 214;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.000001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 3;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - 各按钮事件
- (void)messageButtonClick:(UIButton *)button{
    LYFindConversationViewController *conversationVC = [[LYFindConversationViewController alloc]init];
    conversationVC.conversationType =ConversationType_PRIVATE; //会话类型，这里设置为 PRIVATE 即发起单聊会话。
    LYFreeOrderModel *model = [_dataArray objectAtIndex:button.tag];
    if ([self.userModel.usertype isEqualToString:@"2"] || [self.userModel.usertype isEqualToString:@"3"]) {
        conversationVC.targetId = model.imUserId;
        conversationVC.title = model.usernick;
    }else{
        conversationVC.targetId = model.vipImUserId;
        conversationVC.title = model.vipUsernick;
    }
    [USER_DEFAULT setObject:@"0" forKey:@"needCountIM"];
    
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].isAdd = YES;
    // 把单聊视图控制器添加到导航栈。
    UIButton *itemBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    itemBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    [itemBtn setImage:[UIImage imageNamed:@"backBtn"] forState:UIControlStateNormal];
    [itemBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:itemBtn];
    conversationVC.navigationItem.leftBarButtonItem = item;
    
    [self.navigationController pushViewController:conversationVC animated:YES];
}

- (void)backBtnClick{
    [USER_DEFAULT setObject:@"1" forKey:@"needCountIM"];
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].isAdd = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)phoneButtonClick:(UIButton *)button{
    LYFreeOrderModel *model = [_dataArray objectAtIndex:button.tag];
    if ([self.userModel.usertype isEqualToString:@"2"] || [self.userModel.usertype isEqualToString:@"3"]) {
        if( [MyUtil isPureInt:model.mobile]){
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",model.mobile];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }
    }else{
        if( [MyUtil isPureInt:model.vipMobile]){
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",model.vipMobile];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }
    }
}

- (void)firstButtonClick:(UIButton *)button{
    if (![button.titleLabel.text isEqualToString:@"满意"]) return;
    
    LYFreeOrderModel *model = [_dataArray objectAtIndex:button.tag];
    NSDictionary *dict = @{@"id":[NSNumber numberWithInteger:model.id],
                           @"orderStatus":@"3",//2：专属经理确认订单时传的状态 3：用户确认完成时的状态
                           @"isSatisfaction":@"1"};//订单状态传2时，无需传值；传3时，1：满意 0：不满意
    [LYUserHttpTool lyChangeFreeOrderStatusWithParams:dict complete:^(BOOL result) {
        if (result) {
            [MyUtil showMessage:@"感谢您的支持，我们将再接再厉！"];
            [_dataArray removeObjectAtIndex:button.tag];
            [myTableView reloadData];
        }
    }];
   
   
}


- (void)secondButtonClick:(UIButton *)button{
    LYFreeOrderModel *model = [_dataArray objectAtIndex:button.tag];
    if ([button.titleLabel.text isEqualToString:@"取消"]) {
        [self lyDeleteFreeOrder:button.tag];
    }else if ([button.titleLabel.text isEqualToString:@"不满意"]){
        AlertBlock *alert = [[AlertBlock alloc]initWithTitle:@"提示" message:@"你是否确认此“不满意“操作？" cancelButtonTitle:@"取消" otherButtonTitles:@"确定" block:^(NSInteger buttonIndex){
            //在这里面执行触发的行为，省掉了代理，这样的好处是在使用多个Alert的时候可以明确定义各自触发的行为，不需要在代理方法里判断是哪个Alert了
            if (buttonIndex == 0) {
                
            }else if (buttonIndex == 1){
                NSDictionary *dict = @{@"id":[NSNumber numberWithInteger:model.id],
                                       @"orderStatus":@"3",//2：专属经理确认订单时传的状态 3：用户确认完成时的状态
                                       @"isSatisfaction":@"0"};//订单状态传2时，无需传值；传3时，1：满意 0：不满意
                [LYUserHttpTool lyChangeFreeOrderStatusWithParams:dict complete:^(BOOL result) {
                    if (result) {
                        [MyUtil showMessage:@"感谢您的支持，我们将持续改进！"];
                        [_dataArray removeObjectAtIndex:button.tag];
                        [myTableView reloadData];
                    }
                }];
            }
        }];
        [alert show];
        
       
    }else if ([button.titleLabel.text isEqualToString:@"删除"]){
        __weak typeof(self) weakSelf=self;
        AlertBlock *alert = [[AlertBlock alloc]initWithTitle:@"提示" message:@"你是否确认删除？" cancelButtonTitle:@"取消" otherButtonTitles:@"确定" block:^(NSInteger buttonIndex){
            if (buttonIndex == 0) {
                
            }else if (buttonIndex == 1){
                [weakSelf lyDeleteFreeOrder:button.tag];
            }
        }];
        [alert show];
        
        
    }else if ([button.titleLabel.text isEqualToString:@"预留卡座"]){
        NSDictionary *dict = @{@"id":[NSNumber numberWithInteger:model.id],
                               @"orderStatus":@"2"};
        [LYUserHttpTool lyChangeFreeOrderStatusWithParams:dict complete:^(BOOL result) {
            if (result) {
                [MyUtil showPlaceMessage:@"卡座预留成功！"];
                [_dataArray removeObjectAtIndex:button.tag];
                [myTableView reloadData];
            }
        }];
    }else{
        
    }
}

- (void)lyDeleteFreeOrder:(NSInteger)index{
    LYFreeOrderModel *model = [_dataArray objectAtIndex:index];
    NSDictionary *dict = @{@"id":[NSNumber numberWithInteger:model.id]};
    [LYUserHttpTool lyDeleteFreeOrderWithParams:dict complete:^(BOOL result) {
        if (result) {
            [MyUtil showPlaceMessage:@"删除成功！"];
            [_dataArray removeObjectAtIndex:index];
            [myTableView reloadData];
        }
    }];
}


@end
