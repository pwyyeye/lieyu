//
//  MyZSManageViewController.m
//  lieyu
//
//  Created by 薛斯岐 on 15/9/25.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "MyZSManageViewController.h"
#import "ZSDetailModel.h"
#import "LYZSdetailCell.h"
#import "LYZSApplicationViewController.h"
#import "LYUserHttpTool.h"
#import "LYHomePageHttpTool.h"
#import <RongIMKit/RongIMKit.h>
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "UIImage+GIF.h"
#import "LYUserLoginViewController.h"
#import "IQKeyboardManager.h"

@interface MyZSManageViewController (){
    UIView *_bigView;
    UIImageView *_image_place;
    UILabel *_label_place;
}

@end

@implementation MyZSManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    zsList=[[NSMutableArray alloc]init];
    [self setupViewStyles];
    _tableView.showsHorizontalScrollIndicator=NO;
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.separatorColor=RGB(237, 237, 237);
    _tableView.backgroundColor=RGB(237, 237, 237);
    self.view.backgroundColor=RGB(237, 237, 237);
//    [self.tableView setHidden:YES];
    if(!_isBarVip){
        rightBtn=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"more1"] style:UIBarButtonItemStylePlain target:self action:@selector(moreAct:)];
        [self.navigationItem setRightBarButtonItem:rightBtn];
    }
    
    [self getZSDetail];
    
    // Do any additional setup after loading the view from its nib.
}
- (void)setupViewStyles
{
    
    UINib * detailNib = [UINib nibWithNibName:@"LYZSdetailCell" bundle:nil];
    [self.tableView registerNib:detailNib forCellReuseIdentifier:@"LYZSdetailCell"];
    UIView *view1=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 14)];
    
    view1.backgroundColor=RGB(237, 237, 237);
    self.tableView.tableHeaderView=view1;
}
-(void)getZSDetail{
    [zsList removeAllObjects];
    __weak __typeof(self)weakSelf = self;
//    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//    NSDictionary *dic=@{@"userid":[NSNumber numberWithInt:app.userModel.userid]};
    if(_isBarVip){
        NSDictionary *dic=@{@"barid":[NSNumber numberWithInt:_barid]};
        [[LYHomePageHttpTool shareInstance]getBarVipWithParams:dic block:^(NSMutableArray *result) {
            [zsList addObjectsFromArray:result];
            [weakSelf.tableView reloadData];
        }];
    }else{
        NSDictionary *dic=@{@"userid":[NSNumber numberWithInt:self.userModel.userid]};
        [[LYUserHttpTool shareInstance]getMyVipStore:dic block:^(NSMutableArray *result) {
            [zsList addObjectsFromArray:result];
            [weakSelf.tableView reloadData];
            
            if (!zsList.count) {
                [_bigView removeFromSuperview];
                [_image_place removeFromSuperview];
                [_label_place removeFromSuperview];
                
                _bigView = [[UIView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(weakSelf.navigationController.navigationBar.frame) , SCREEN_WIDTH,  SCREEN_HEIGHT - 64 - CGRectGetHeight(weakSelf.navigationController.navigationBar.frame))];
                _bigView.backgroundColor = RGBA(0, 0, 0, 0.4);
                _bigView.alpha = 0.2;
                _bigView.tag = 300;
                [weakSelf.view addSubview:_bgView];
                
                _image_place = [[UIImageView alloc]initWithFrame:CGRectMake(107, 191-64,105 , 119)];
                _image_place.image =[UIImage sd_animatedGIFNamed:@"sorry"];
                _image_place.tag = 100;
                [weakSelf.view addSubview:_image_place];
                
                _label_place = [[UILabel alloc]initWithFrame:CGRectMake(76, 310-64, 168, 22)];
                _label_place.text = @"快快收藏专属经理吧";
                _label_place.textColor = RGBA(29, 32, 47, 1);
                _label_place.font = [UIFont systemFontOfSize:14];
                _label_place.tag = 200;
                _label_place.textAlignment = NSTextAlignmentCenter;
                [weakSelf.view addSubview:_label_place];
            }else{
                [_bgView removeFromSuperview];
                [_image_place removeFromSuperview];
                [_label_place removeFromSuperview];
            }

            
        }];
    }
    
    
//    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 130;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [zsList  count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    LYZSdetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LYZSdetailCell"];
//    NSUInteger row = [indexPath row];
    
    ZSDetailModel * detailModel=zsList[indexPath.row];
    NSLog(@"ZSJL:%@",detailModel);
    [cell.messageBtn addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell cellConfigure:detailModel];
    [cell.phoneBtn addTarget:self action:@selector(callPhone:) forControlEvents:UIControlEventTouchUpInside];
    [cell.scBtn setHidden:!_isBarVip];
    [cell.scBtn  addTarget:self action:@selector(scAct:) forControlEvents:UIControlEventTouchUpInside];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if(_isBarVip){
        return NO;
    }
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        __weak __typeof(self)weakSelf = self;
        ZSDetailModel * detailModel=zsList[indexPath.row];
        NSDictionary *dic=@{@"userid":[NSNumber numberWithInt:self.userModel.userid],@"vipUserid":[NSNumber numberWithInt:detailModel.userid]};
        [[LYUserHttpTool shareInstance] delMyVipStore:dic complete:^(BOOL result) {
            if (result) {
                [MyUtil showMessage:@"修改成功！"];
                [weakSelf getZSDetail];
            }
        }];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark - 更多
-(void)moreAct:(id)sender{
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH,SCREEN_HEIGHT)];
    [_bgView setTag:99999];
    [_bgView setBackgroundColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.4]];
    [_bgView setAlpha:1.0];
    rightBtn.enabled=false;
    [self.view addSubview:_bgView];
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"LYZSeditView" owner:nil options:nil];
    seditView= (LYZSeditView *)[nibView objectAtIndex:0];
    seditView.top=SCREEN_HEIGHT;
    [seditView.quxiaoBtn addTarget:self action:@selector(SetViewDisappear:) forControlEvents:UIControlEventTouchDown];
    [seditView.editListBtn addTarget:self action:@selector(editZsAct:) forControlEvents:UIControlEventTouchDown];
    [seditView.shenqingBtn addTarget:self action:@selector(shenqingAct:) forControlEvents:UIControlEventTouchDown];
    [_bgView addSubview:seditView];
    
    [UIView beginAnimations:@"animationID" context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:seditView cache:NO];
    seditView.top=SCREEN_HEIGHT-seditView.height-64;
    [UIView commitAnimations];
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(0 ,0, SCREEN_WIDTH, SCREEN_HEIGHT-seditView.height-64);
    [button setBackgroundColor:[UIColor clearColor]];
    [button addTarget:self action:@selector(SetViewDisappear:) forControlEvents:UIControlEventTouchDown];
    [_bgView insertSubview:button aboveSubview:_bgView];
    button.backgroundColor=[UIColor clearColor];
}
#pragma mark - 编辑列表
-(void)editZsAct:(id)sender{

}

#pragma mark - 申请专属经理
-(void)shenqingAct:(id)sender{
    LYZSApplicationViewController *applicationViewController=[[LYZSApplicationViewController alloc]initWithNibName:@"LYZSApplicationViewController" bundle:nil];
    applicationViewController.title=@"申请专属经理";
    [self.navigationController pushViewController:applicationViewController animated:YES];
    [self SetViewDisappear:nil];
}

#pragma mark - 消失
-(void)SetViewDisappear:(id)sender
{
    rightBtn.enabled=YES;
    if (_bgView)
    {
        _bgView.backgroundColor=[UIColor clearColor];
        [UIView animateWithDuration:.5
                         animations:^{
                             
                             seditView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 300);
                             _bgView.frame=CGRectMake(0, SCREEN_HEIGHT, self.view.frame.size.width, self.view.frame.size.height);
                             _bgView.alpha=0.0;
                         }];
        [_bgView performSelector:@selector(removeFromSuperview)
                      withObject:nil
                      afterDelay:2];
        
        _bgView=nil;
    }
    
}
#pragma mark -收藏
-(void)scAct:(UIButton *)sender{
    ZSDetailModel * detailModel=zsList[sender.tag];
    NSLog(@"----pass-pass%@---",detailModel);
    //统计收藏的可能性
    NSDictionary *dict = @{@"actionName":@"选择",@"pageName":@"专属经理",@"titleName":@"收藏",@"value":detailModel.username};
    [MTA trackCustomKeyValueEvent:@"LYClickEvent" props:dict];
    
    NSDictionary *dic=@{@"vipUserid":[NSNumber numberWithInt:detailModel.userid],@"userid":[NSNumber numberWithInt:self.userModel.userid]};
    [[LYHomePageHttpTool shareInstance] scVipWithParams:dic complete:^(BOOL result) {
        if(result){
            [MyUtil showMessage:@"收藏成功"];
        }
    }];
}

#pragma mark -电话
- (void)callPhone:(UIButton *)sender
{
    ZSDetailModel * detailModel=zsList[sender.tag];
    
    //统计打电话的可能性
    NSDictionary *dict = @{@"actionName":@"选择",@"pageName":@"专属经理",@"titleName":@"打电话",@"value":detailModel.usernick};
    [MTA trackCustomKeyValueEvent:@"LYClickEvent" props:dict];
    
    if( [MyUtil isPureInt:detailModel.mobile]){
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",detailModel.mobile];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];

    }
}
#pragma mark -发消息
- (void)sendMessage:(UIButton *)sender{
    //进行是否已登陆的判断
    if(((AppDelegate*)[[UIApplication sharedApplication] delegate]).userModel){//已登陆
        ZSDetailModel * detailModel=zsList[sender.tag];
        
        //统计发消息的可能性
        NSDictionary *dict = @{@"actionName":@"选择",@"pageName":@"专属经理",@"titleName":@"发消息",@"value":detailModel.username};
        [MTA trackCustomKeyValueEvent:@"LYClickEvent" props:dict];
        
        RCConversationViewController *conversationVC = [[RCConversationViewController alloc]init];
        conversationVC.conversationType =ConversationType_PRIVATE; //会话类型，这里设置为 PRIVATE 即发起单聊会话。
        conversationVC.targetId = detailModel.imUserId; // 接收者的 targetId，这里为举例。
        conversationVC.userName =detailModel.usernick; // 接受者的 username，这里为举例。
        conversationVC.title = detailModel.usernick; // 会话的 title。
        
        conversationVC.navigationController.navigationBarHidden = NO;
        [IQKeyboardManager sharedManager].enable = NO;
        [IQKeyboardManager sharedManager].isAdd = YES;
        // 把单聊视图控制器添加到导航栈。
        UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"leftBackItem"] style:UIBarButtonItemStylePlain target:self action:@selector(backForward)];
        conversationVC.navigationItem.leftBarButtonItem = left;
        [self.navigationController pushViewController:conversationVC animated:YES];
    }else{
        LYUserLoginViewController *userLoginVC = [[LYUserLoginViewController alloc]initWithNibName:@"LYUserLoginViewController" bundle:[NSBundle mainBundle]];
        [self.navigationController pushViewController:userLoginVC animated:YES];
    }
    
}

- (void)backForward{
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].isAdd = NO;
    [self.navigationController popViewControllerAnimated:YES];
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
