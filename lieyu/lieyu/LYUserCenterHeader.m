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
@implementation LYUserCenterHeader

- (void)awakeFromNib {
    // Initialization code
    [self loadData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:@"loadUserInfo" object:nil];
     
    //设置背景色
    UIImageView *bgImage=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"headBgColor"]];
    bgImage.frame=self.headView.bounds;
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
        if (![MyUtil isEmptyString:app.userModel.birthday]) {
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
            badge.text=[NSString stringWithFormat:@"%d",orderTTL.waitPay];
            [_waitPay addSubview:badge];
            
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
            badge.text=[NSString stringWithFormat:@"%d",orderTTL.waitConsumption];
            [_waitConsumption addSubview:badge];
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
            badge.text=[NSString stringWithFormat:@"%d",orderTTL.waitRebate];
            [_waitRebate addSubview:badge];
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
            badge.text=[NSString stringWithFormat:@"%d",orderTTL.waitEvaluation];
            [_waitEvaluation addSubview:badge];
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
            badge.text=[NSString stringWithFormat:@"%d",orderTTL.waitPayBack];
            [_waitPayBack addSubview:badge];
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
            badge.text=[NSString stringWithFormat:@"%d",orderTTL.messageNum];
            [_btnMessage insertSubview:badge aboveSubview:_btnMessage.titleLabel];

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
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    Setting *setting =[[Setting alloc] init];
    [app.navigationController pushViewController:setting animated:YES];
}

- (IBAction)gotoMessageList:(id)sender {
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    MyMessageListViewController *messageListViewController=[[MyMessageListViewController alloc]initWithNibName:@"MyMessageListViewController" bundle:nil];
    messageListViewController.title=@"信息中心";
    [app.navigationController pushViewController:messageListViewController animated:YES];
}

- (IBAction)gotoOrderList:(id)sender {
    [self gotoMyOrderList:LYOrderTypeDefault];
}

- (IBAction)gotoWaitPayOrderList:(id)sender {
    [self gotoMyOrderList:LYOrderTypeWaitPay];
}

- (IBAction)gotoWaitConsumptionOrderList:(id)sender {
    [self gotoMyOrderList:LYOrderTypeWaitConsumption];
}

- (IBAction)gotoWaitRebateOrderList:(id)sender {
    [self gotoMyOrderList:LYOrderTypeWaitRebate];
}

- (IBAction)gotoWaitEvaluationOrderList:(id)sender {
    [self gotoMyOrderList:LYOrderTypeWaitEvaluation];
}

- (IBAction)gotoWaitPayBackOrderList:(id)sender {
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
