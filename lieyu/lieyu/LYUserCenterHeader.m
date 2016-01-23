//
//  LYUserCenterHeader.m
//  lieyu
//
//  Created by pwy on 15/11/29.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYUserCenterHeader.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "UserTagModel.h"
#import "LYMyOrderManageViewController.h"
#import "MyMessageListViewController.h"
#import "Setting.h"
#import "LYUserDetailController.h"
@implementation LYUserCenterHeader

- (void)awakeFromNib {
    // Initialization code
    [self loadData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:@"loadUserInfo" object:nil];
    self.btnMessage.hidden = YES;
    //设置背景色
    UIImageView *bgImage=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"headBgColor"]];
    bgImage.frame=CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetHeight(_headView.frame));
    bgImage.contentMode=UIViewContentModeScaleToFill;
    
    
    [self.headView addSubview:bgImage];
   
    [self.headView bringSubviewToFront:_age];
    [self.headView bringSubviewToFront:_userNick];
    [self.headView bringSubviewToFront:_avatar_img];
    [self.headView bringSubviewToFront:_tags];
    [self.headView bringSubviewToFront:_btnMessage];
    [self.headView bringSubviewToFront:_btnSetting];
    
    self.avatar_img.layer.borderColor=RGB(176,143,199).CGColor; //要设置的颜色
    self.avatar_img.layer.borderWidth=2.5;
    [self.avatar_btn addTarget:self action:@selector(changeAvatar) forControlEvents:UIControlEventTouchUpInside];
}

- (void)changeAvatar{
    //统计我的页面的选择
    NSDictionary *dict1 = @{@"actionName":@"跳转",@"pageName":@"我的主页面",@"titleName":@"更换头像"};
    [MTA trackCustomKeyValueEvent:@"LYClickEvent" props:dict1];
    
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    LYUserDetailController *detail = [[LYUserDetailController alloc]init];
//    Setting *setting =[[Setting alloc] init];
    [app.navigationController pushViewController:detail animated:YES];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"loadUserInfo" object:nil];
}

-(void)loadData{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if (app.userModel) {
        //设置头像
        [_avatar_img setImageWithURL:[NSURL URLWithString:app.userModel.avatar_img] placeholderImage:[UIImage imageNamed:app.userModel.gender.intValue==0?@"lieyu_default_female":@"lieyu_default_male"]];
        if ([MyUtil isEmptyString:app.userModel.age]) {
            _age.hidden=YES;
        }else{
            _age.hidden=NO;
        }
        
        if (app.userModel.tags.count==0) {
            _tags.hidden=YES;
        }else{
            _tags.hidden=NO;
        }
        [_age setTitle:[NSString stringWithFormat:@"%@岁",app.userModel.age]  forState:UIControlStateNormal];
        if (![MyUtil isEmptyString:app.userModel.birthday]&&[MyUtil  isEmptyString:app.userModel.age]) {
            [_age setTitle:[NSString stringWithFormat:@"%@岁",[MyUtil getAgefromDate:app.userModel.birthday]]  forState:UIControlStateNormal];
            
        }
        NSArray *tags=app.userModel.tags;
        NSMutableString *mytags=[[NSMutableString alloc] init];
        for (UserTagModel *tag in tags) {
            if (![MyUtil isEmptyString:tag.tagname]){
                if ([tag isEqual:tags.lastObject]) {
                    [mytags appendString:tag.tagname];
                }else{
                    [mytags appendString:tag.tagname];
                    [mytags appendString:@","];
                }
            }else if(![MyUtil isEmptyString:tag.name]){
                if ([tag isEqual:tags.lastObject]) {
                    [mytags appendString:tag.name];
                }else{
                    [mytags appendString:tag.name];
                    [mytags appendString:@","];
                }
            }
            
            
            
        }
        [_tags setTitle:mytags forState:UIControlStateNormal];
        _userNick.text=app.userModel.usernick;
    }
    

}

-(void)updateConstraints{
     [super updateConstraints];
    _line1Heght.constant=0.5;
    
}
//加载角标
-(void)loadBadge:(OrderTTL *)orderTTL{
   
    if (orderTTL) {
        if (orderTTL.waitPay>0) {//待付款
            UILabel *badge=[[UILabel alloc] init];
            badge.backgroundColor=[UIColor redColor];
            badge.font=[UIFont systemFontOfSize:8];
            badge.layer.masksToBounds=YES;
            badge.layer.cornerRadius=6;
            badge.textColor=[UIColor whiteColor];
            badge.textAlignment=NSTextAlignmentCenter;
            CGRect frame=_waitPay.frame;
            badge.frame=CGRectMake(frame.size.width-20, 10, 12, 12);
            badge.text=[NSString stringWithFormat:@"%ld",orderTTL.waitPay];
            badge.tag=100;
            [_waitPay addSubview:badge];
            
        }else{
            [[_waitPay viewWithTag:100] removeFromSuperview];
        
        }
        if(orderTTL.waitConsumption>0){//待消费
            UILabel *badge=[[UILabel alloc] init];
            badge.backgroundColor=[UIColor redColor];
            badge.font=[UIFont systemFontOfSize:8];
            badge.layer.masksToBounds=YES;
            badge.layer.cornerRadius=6;
            badge.textColor=[UIColor whiteColor];
            badge.textAlignment=NSTextAlignmentCenter;
            CGRect frame=_waitConsumption.frame;
            badge.frame=CGRectMake(frame.size.width-20, 10, 12, 12);
            badge.text=[NSString stringWithFormat:@"%ld",orderTTL.waitConsumption];
            badge.tag=101;
            [_waitConsumption addSubview:badge];
        }else{
            [[_waitConsumption viewWithTag:101] removeFromSuperview];
        }
        if (orderTTL.waitRebate>0){//待返利
            UILabel *badge=[[UILabel alloc] init];
            badge.backgroundColor=[UIColor redColor];
            badge.font=[UIFont systemFontOfSize:8];
            badge.layer.masksToBounds=YES;
            badge.layer.cornerRadius=6;
            badge.textColor=[UIColor whiteColor];
            badge.textAlignment=NSTextAlignmentCenter;
            CGRect frame=_waitRebate.frame;
            badge.frame=CGRectMake(frame.size.width-20, 10, 12, 12);
            badge.text=[NSString stringWithFormat:@"%ld",orderTTL.waitRebate];
            badge.tag=102;
            [_waitRebate addSubview:badge];
        }else{
            [[_waitRebate viewWithTag:102] removeFromSuperview];
        }
        if(orderTTL.waitEvaluation>0){//待评价
            UILabel *badge=[[UILabel alloc] init];
            badge.backgroundColor=[UIColor redColor];
            badge.font=[UIFont systemFontOfSize:8];
            badge.layer.masksToBounds=YES;
            badge.layer.cornerRadius=6;
            badge.textColor=[UIColor whiteColor];
            badge.textAlignment=NSTextAlignmentCenter;
            CGRect frame=_waitEvaluation.frame;
            badge.frame=CGRectMake(frame.size.width-20, 10, 12, 12);
            badge.text=[NSString stringWithFormat:@"%ld",orderTTL.waitEvaluation];
            badge.tag=103;
            [_waitEvaluation addSubview:badge];
        }else{
            [[_waitEvaluation viewWithTag:103] removeFromSuperview];
        }
        if (orderTTL.waitPayBack>0){//待退款
            UILabel *badge=[[UILabel alloc] init];
            badge.backgroundColor=[UIColor redColor];
            badge.font=[UIFont systemFontOfSize:8];
            badge.layer.masksToBounds=YES;
            badge.layer.cornerRadius=6;
            badge.textColor=[UIColor whiteColor];
            badge.textAlignment=NSTextAlignmentCenter;
            CGRect frame=_waitPayBack.frame;
            badge.frame=CGRectMake(frame.size.width-20, 10, 12, 12);
            badge.text=[NSString stringWithFormat:@"%ld",orderTTL.waitPayBack];
            badge.tag=104;
            [_waitPayBack addSubview:badge];
        }else{
            [[_waitPayBack viewWithTag:104] removeFromSuperview];
        }
        if (orderTTL.messageNum>0) {//消息中心
            UILabel *badge=[[UILabel alloc] init];
            badge.backgroundColor=[UIColor redColor];
            badge.font=[UIFont systemFontOfSize:8];
            badge.layer.masksToBounds=YES;
            badge.layer.cornerRadius=6;
            badge.textColor=[UIColor whiteColor];
            badge.textAlignment=NSTextAlignmentCenter;
            CGRect frame=_btnMessage.frame;
            badge.frame=CGRectMake(frame.size.width-6, -3, 12, 12);
            badge.text=[NSString stringWithFormat:@"%ld",orderTTL.messageNum];
            badge.tag=105;
            [_btnMessage insertSubview:badge aboveSubview:_btnMessage.titleLabel];

        }else{
            [[_btnMessage viewWithTag:105] removeFromSuperview];
        }
            
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // 初始化时加载collectionCell.xib文件
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"LYUserCenterHeader" owner:self options:nil];
        
        // 如果路径不存在，return nil
        if (arrayOfViews.count < 1)
        {
            return nil;
        }
        // 如果xib中view不属于UICollectionViewCell类，return nil
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[LYUserCenterHeader class]])
        {
            return nil;
        }
        // 加载nib
        self = [arrayOfViews objectAtIndex:0];
    }
    return self;
}

- (IBAction)gotoSetting:(id)sender {
    //统计我的页面的选择
    NSDictionary *dict1 = @{@"actionName":@"跳转",@"pageName":@"我的主页面",@"titleName":@"设置"};
    [MTA trackCustomKeyValueEvent:@"LYClickEvent" props:dict1];
    
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    Setting *setting =[[Setting alloc] init];
    [app.navigationController pushViewController:setting animated:YES];
}

- (IBAction)gotoMessageList:(id)sender {
    //统计我的页面的选择
    NSDictionary *dict1 = @{@"actionName":@"跳转",@"pageName":@"我的主页面",@"titleName":@"信息中心"};
    [MTA trackCustomKeyValueEvent:@"LYClickEvent" props:dict1];
    
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    MyMessageListViewController *messageListViewController=[[MyMessageListViewController alloc]initWithNibName:@"MyMessageListViewController" bundle:nil];
    messageListViewController.title=@"信息中心";
    [app.navigationController pushViewController:messageListViewController animated:YES];
}

- (IBAction)gotoOrderList:(id)sender {
    //统计我的页面的选择
    NSDictionary *dict1 = @{@"actionName":@"跳转",@"pageName":@"我的主页面",@"titleName":@"全部订单"};
    [MTA trackCustomKeyValueEvent:@"LYClickEvent" props:dict1];
    
    [self gotoMyOrderList:LYOrderTypeDefault];
}

- (IBAction)gotoWaitPayOrderList:(id)sender {
    //统计我的页面的选择
    NSDictionary *dict1 = @{@"actionName":@"跳转",@"pageName":@"我的主页面",@"titleName":@"待付款"};
    [MTA trackCustomKeyValueEvent:@"LYClickEvent" props:dict1];
    
    [self gotoMyOrderList:LYOrderTypeWaitPay];
}

- (IBAction)gotoWaitConsumptionOrderList:(id)sender {
    //统计我的页面的选择
    NSDictionary *dict1 = @{@"actionName":@"跳转",@"pageName":@"我的主页面",@"titleName":@"待消费"};
    [MTA trackCustomKeyValueEvent:@"LYClickEvent" props:dict1];
    
    [self gotoMyOrderList:LYOrderTypeWaitConsumption];
}

- (IBAction)gotoWaitRebateOrderList:(id)sender {
    //统计我的页面的选择
    NSDictionary *dict1 = @{@"actionName":@"跳转",@"pageName":@"我的主页面",@"titleName":@"待返利"};
    [MTA trackCustomKeyValueEvent:@"LYClickEvent" props:dict1];
    
    [self gotoMyOrderList:LYOrderTypeWaitRebate];
}

- (IBAction)gotoWaitEvaluationOrderList:(id)sender {
    //统计我的页面的选择
    NSDictionary *dict1 = @{@"actionName":@"跳转",@"pageName":@"我的主页面",@"titleName":@"待评价"};
    [MTA trackCustomKeyValueEvent:@"LYClickEvent" props:dict1];
    
    [self gotoMyOrderList:LYOrderTypeWaitEvaluation];
}

- (IBAction)gotoWaitPayBackOrderList:(id)sender {
    //统计我的页面的选择
    NSDictionary *dict1 = @{@"actionName":@"跳转",@"pageName":@"我的主页面",@"titleName":@"待退款"};
    [MTA trackCustomKeyValueEvent:@"LYClickEvent" props:dict1];
    
    [self gotoMyOrderList:LYOrderTypeWaitPayBack];
}

-(void)gotoMyOrderList:(NSInteger)orderType{
    LYMyOrderManageViewController *myOrderManageViewController=[[LYMyOrderManageViewController alloc]initWithNibName:@"LYMyOrderManageViewController" bundle:nil];
    myOrderManageViewController.title=@"我的订单";
    myOrderManageViewController.orderType=orderType;
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app.navigationController pushViewController:myOrderManageViewController animated:YES];
}
@end
