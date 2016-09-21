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
#import "LYWithdrawTypeViewController.h"
#import "ZSMaintViewController.h"
#import "MainTabbarViewController.h"
#import "LPMyOrdersViewController.h"
#import "LYGuWenFansViewController.h"
#import "MyCodeViewController.h"
#import "MineMoneyBagViewController.h"
#import "MineGroupViewController.h"
#import "FindNotificationViewController.h"
#import "wechatCheckAccountViewController.h"
#import "LYZSApplicationViewController.h"
#import "checkUnpassedViewController.h"
#import "LYFriendsHttpTool.h"
#import "LYUserDetailController.h"

@implementation LYUserCenterHeader{
    UIVisualEffectView *_effctView ;
    
    ZSApplyStatusModel *statusModel;
    BOOL canApply;//
    int enterStep;//1开始、2支付
    NSString *sn;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self loadData];
    _badgesArray = [[NSMutableArray alloc]init];
    [_badgesArray addObject:@"0"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:@"loadUserInfo" object:nil];
    self.btnMessage.hidden = YES;
    //设置背景色
    UIImageView *bgImage = [[UIImageView alloc]initWithImage:[MyUtil getImageFromColor:COMMON_PURPLE] ];
    //    UIImageView *bgImage=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"headBgColor"]];
    bgImage.frame=CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetHeight(_headView.frame));
    bgImage.contentMode=UIViewContentModeScaleToFill;
    
    
    [self.headView addSubview:bgImage];
    
    [self.headView bringSubviewToFront:_age];
    [self.headView bringSubviewToFront:_userNick];
    [self.headView bringSubviewToFront:_avatar_img];
    [self.headView bringSubviewToFront:_tags];
    [self.headView bringSubviewToFront:_btnMessage];
    [self.headView bringSubviewToFront:_btnSetting];
    [self.headView bringSubviewToFront:_xingzuo];
    
    [self.avatar_btn addTarget:self action:@selector(changeAvatar) forControlEvents:UIControlEventTouchUpInside];
    
//    _img_icon.layer.cornerRadius = CGRectGetHeight(_img_icon.frame)/2.f;
//    _img_icon.layer.masksToBounds = YES;
//    
//    NSLog(@" CGRectGetHeight(_label_constellation.frame)/2.f : %f", CGRectGetHeight(_label_constellation.frame)/2.f)
//    _label_constellation.layer.cornerRadius = CGRectGetHeight(_label_constellation.frame)/2.f;
//    _label_constellation.layer.masksToBounds = YES;
//    
//    _label_work.layer.cornerRadius = CGRectGetHeight(_label_constellation.frame)/2.f;
//    _label_work.layer.masksToBounds = YES;
    
    
}

- (void)drawRect:(CGRect)rect{
    
    [self.firstMenuButton setMenuName:@"速核码"];
    [self.firstMenuButton setImageUrl:@"userSuHeMa"];
    [self.secondMenuButton setMenuName:@"我的钱包"];
    [self.secondMenuButton setImageUrl:@"MineMoneyBag"];
    [_thirdMenuButton setMenuName:@"娱客帮"];
    [_thirdMenuButton setImageUrl:@"MineGroup"];
    [_forthMenuButton setMenuName:@"商家入驻"];
    [_forthMenuButton setImageUrl:@"MineApply"];
    
    _img_icon.layer.cornerRadius = CGRectGetHeight(_img_icon.frame)/2.f;
    _img_icon.layer.masksToBounds = YES;
    
    _label_constellation.layer.cornerRadius = CGRectGetHeight(_label_constellation.frame)/2.f;
    _label_constellation.layer.masksToBounds = YES;
    
    _label_work.layer.cornerRadius = CGRectGetHeight(_label_constellation.frame)/2.f;
    _label_work.layer.masksToBounds = YES;
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
        [_img_icon setImageWithURL:[NSURL URLWithString:app.userModel.avatar_img] placeholderImage:[UIImage imageNamed:app.userModel.gender.intValue==0?@"lieyu_default_head":@"lieyu_default_head"]];
        [_img_bg setImageWithURL:[NSURL URLWithString:app.userModel.avatar_img] placeholderImage:[UIImage imageNamed:app.userModel.gender.intValue==0?@"lieyu_default_head":@"lieyu_default_head"]];
        
        _label_constellation.text = [MyUtil getAstroWithBirthday:app.userModel.birthday];
        _label_name.text = app.userModel.usernick;
        if ([app.userModel.gender isEqualToString:@"0"]) {
            _img_sex.image=[UIImage imageNamed:@"woman"];
        }else{
            _img_sex.image=[UIImage imageNamed:@"manIcon"];
        }
        if ([MyUtil isEmptyString:app.userModel.age]) {
            _age.hidden=YES;
        }else{
            CGSize size = [_age.titleLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 15) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
            self._ageConstrant.constant = size.width + 10;
            _age.hidden=NO;
        }
        
        if (app.userModel.tags.count==0) {
            _tags.hidden=YES;
        }else{
            CGSize size = [_tags.titleLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 15) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
            //            self._tagConstrant.constant = size.width + 10;
            _tags.hidden=NO;
        }
        
        if ([MyUtil isEmptyString:app.userModel.birthday]) {
            _xingzuo.hidden=YES;
        }else{
            _xingzuo.hidden=NO;
            CGSize size = [_xingzuo.titleLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 15) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
            self._xingzuoConstrant.constant = size.width + 10;
            [_xingzuo setTitle:[MyUtil getAstroWithBirthday:app.userModel.birthday]  forState:UIControlStateNormal];
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
        CGSize size = [mytags boundingRectWithSize:CGSizeMake(MAXFLOAT, 15) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
        self._tagConstrant.constant = size.width + 10;
        [_tags setTitle:mytags forState:UIControlStateNormal];
        if ([MyUtil isEmptyString:mytags]) {
            _label_work.text = @"首富";
        }else{
            _label_work.text = mytags;
        }
        _userNick.text=app.userModel.usernick;
        if([app.userModel.usertype isEqualToString:@"2"] || [app.userModel.usertype isEqualToString:@"3"]){
            _businessButton.hidden = NO;
        }else{
            _businessButton.hidden = YES;
        }
        //        if ([app.userModel.usertype isEqualToString:@"2"]||[app.userModel.usertype isEqualToString:@"3"]) {
        //            //专属经理
        //            //粉丝按钮
        ////            [_beCareType_ly_Image setImage:[UIImage imageNamed:@"CareNumber"]];
        if (!app.userModel.beCollectNum) {
            [_beCare_ly_button setTitle:@"粉丝：0" forState:UIControlStateNormal];
            //                [_beCare_ly_Number setText:@"0"];
        } else {
            [_beCare_ly_button setTitle:[NSString stringWithFormat:@"粉丝：%@",app.userModel.beCollectNum] forState:UIControlStateNormal];
            //                [_beCare_ly_Number setText:app.userModel.beCollectNum];
        }
        //        }else{//普通用户隐藏粉丝按钮
        //            _beCare_ly_button.hidden = YES;
        ////            _beCareType_ly_Image.hidden = YES;
        //            _beCare_ly_Number.hidden = YES;
        ////            _beCareType_ly_Name.hidden = YES;
        //        }
        //关注按钮
        if (!app.userModel.collectNum) {
            [_caresButton setTitle:@"关注：0" forState:UIControlStateNormal];
            //            [_beCareNumber setText:@"0"];
        } else {
            [_caresButton setTitle:[NSString stringWithFormat:@"关注：%@",app.userModel.collectNum] forState:UIControlStateNormal];
            //            [_beCareNumber setText:app.userModel.collectNum];
        }
        //        [_careTypeImage setImage:[UIImage imageNamed:@"collectNumber"]];
    }
    
    
}

- (IBAction)hederImgClick:(id)sender {
    
}

- (void)gotoShanghu{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    ZSMaintViewController *maintViewController=[[ZSMaintViewController alloc]initWithNibName:@"ZSMaintViewController" bundle:nil];
    [app.navigationController pushViewController:maintViewController animated:YES];
    maintViewController.btnBackHidden = YES;
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"shanghuban"];
    
    
    
    maintViewController.btnBackHidden = YES;
    if(app.userModel.usertype.intValue==2 || app.userModel.usertype.intValue == 3){
        UIWindow *window = [UIApplication sharedApplication].delegate.window;
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        _effctView = [[UIVisualEffectView alloc]initWithEffect:effect];
        //            effctView.frame = [UIScreen mainScreen].bounds;
        _effctView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        [window addSubview:_effctView];
        
        CGFloat imgVWidth = 50;
        
        UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, imgVWidth, imgVWidth)];
        imgV.center = _effctView.center;
        
        imgV.image = [UIImage imageNamed:@"loading1"];
        [_effctView addSubview:imgV];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imgV.frame),SCREEN_WIDTH, imgVWidth)];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = @"切换中....";
        [_effctView addSubview:titleLabel];
        
        NSMutableArray *imgArray = [[NSMutableArray alloc]initWithCapacity:9];
        for (int i = 1; i < 10; i ++) {
            
            UIImage *img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"loading%d@2x",i] ofType:@"png"]];
            [imgArray addObject:(__bridge UIImage *)img.CGImage];
        }
        
        CAKeyframeAnimation *keyFrameA = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
        keyFrameA.duration = imgArray.count * 0.1;
        keyFrameA.delegate = self;
        keyFrameA.values = imgArray;
        keyFrameA.repeatCount = 1;
        [imgV.layer addAnimation:keyFrameA forKey:nil];
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    [UIView animateWithDuration:0.2 animations:^{
        _effctView.alpha = 0.f;
    } completion:^(BOOL finished) {
        [_effctView removeFromSuperview];
    }];
}


-(void)updateConstraints{
    [super updateConstraints];
    _line1Heght.constant=0.5;
    if (SCREEN_WIDTH==320) {
        _headHeight.constant=260;
        _buttomHeight.constant=70;
    }
}

//加载角标
-(void)loadBadge:(OrderTTL *)orderTTL{
    _badgeNum = (int)(orderTTL.waitPay + orderTTL.waitRebate + orderTTL.waitPayBack + orderTTL.waitEvaluation + orderTTL.waitConsumption);
    if (orderTTL.waitPay > 0) {
        [_badgesArray addObject:@"1"];
    }else{
        [_badgesArray addObject:@"0"];
    }
    if (orderTTL.waitConsumption > 0) {
        [_badgesArray addObject:@"1"];
    }else{
        [_badgesArray addObject:@"0"];
    }
    if (orderTTL.waitEvaluation > 0) {
        [_badgesArray addObject:@"1"];
    }else{
        [_badgesArray addObject:@"0"];
    }
    if (orderTTL.waitRebate > 0) {
        [_badgesArray addObject:@"1"];
    }else{
        [_badgesArray addObject:@"0"];
    }
    if (orderTTL.waitPayBack > 0) {
        [_badgesArray addObject:@"1"];
    }else{
        [_badgesArray addObject:@"0"];
    }
    //    UIColor *deafultColor = RGBA(186, 40, 227, 1);
    //    if (orderTTL) {
    //        if (orderTTL.waitPay>0) {//待付款
    //            if(![_waitPay viewWithTag:100]){
    //                UILabel *badge=[[UILabel alloc] init];
    //                badge.backgroundColor = deafultColor;
    //                badge.font=[UIFont systemFontOfSize:10];
    //                badge.layer.masksToBounds=YES;
    //                badge.layer.cornerRadius=6;
    //                badge.textColor=[UIColor whiteColor];
    //                badge.textAlignment=NSTextAlignmentCenter;
    //                CGRect frame=_waitPay.frame;
    //                badge.frame=CGRectMake(_waitPay.size.width/2.f + 11, 5, 22, 12);
    //                badge.tag=100;
    //                [_waitPay addSubview:badge];
    //            }
    //            ((UILabel *)[_waitPay viewWithTag:100]).text=[NSString stringWithFormat:@"%d",orderTTL.waitPay];
    //
    //        }else{
    //            [[_waitPay viewWithTag:100] removeFromSuperview];
    //
    //        }
    //        if(orderTTL.waitConsumption>0){//待消费
    //            if (![_waitConsumption viewWithTag:101]) {
    //                UILabel *badge=[[UILabel alloc] init];
    //                badge.backgroundColor=deafultColor;
    //                badge.font=[UIFont systemFontOfSize:10];
    //                badge.layer.masksToBounds=YES;
    //                badge.layer.cornerRadius=6;
    //                badge.textColor=[UIColor whiteColor];
    //                badge.textAlignment=NSTextAlignmentCenter;
    //                CGRect frame=_waitConsumption.frame;
    //                badge.frame=CGRectMake(_waitConsumption.size.width/2.f + 11, 5, 22, 12);
    //                badge.tag=101;
    //                [_waitConsumption addSubview:badge];
    //            }
    //
    //            ((UILabel *)[_waitConsumption viewWithTag:101]).text=[NSString stringWithFormat:@"%d",orderTTL.waitConsumption];
    //        }else{
    //            [[_waitConsumption viewWithTag:101] removeFromSuperview];
    //        }
    //        if (orderTTL.waitRebate>0){//待返利
    //            if (![_waitRebate viewWithTag:102]) {
    //                UILabel *badge=[[UILabel alloc] init];
    //                badge.backgroundColor=deafultColor;
    //                badge.font=[UIFont systemFontOfSize:10];
    //                badge.layer.masksToBounds=YES;
    //                badge.layer.cornerRadius=6;
    //                badge.textColor=[UIColor whiteColor];
    //                badge.textAlignment=NSTextAlignmentCenter;
    //                CGRect frame=_waitRebate.frame;
    //                badge.frame=CGRectMake(_waitRebate.size.width/2.f + 11, 5, 22, 12);
    //                badge.tag=102;
    //                [_waitRebate addSubview:badge];
    //            }
    //            NSLog(@"--->%d",orderTTL.waitRebate);
    //            ((UILabel *)[_waitRebate viewWithTag:102]).text=[NSString stringWithFormat:@"%d",orderTTL.waitRebate];
    //        }else{
    //            [[_waitRebate viewWithTag:102] removeFromSuperview];
    //        }
    //        if(orderTTL.waitEvaluation>0){//待评价
    //            if(![_waitEvaluation viewWithTag:103]){
    //                UILabel *badge=[[UILabel alloc] init];
    //                badge.backgroundColor=deafultColor;
    //                badge.font=[UIFont systemFontOfSize:10];
    //                badge.layer.masksToBounds=YES;
    //                badge.layer.cornerRadius=6;
    //                badge.textColor=[UIColor whiteColor];
    //                badge.textAlignment=NSTextAlignmentCenter;
    //                CGRect frame=_waitEvaluation.frame;
    //                badge.frame=CGRectMake(_waitEvaluation.size.width/2.f + 11, 5, 22, 12);
    //                badge.tag=103;
    //                [_waitEvaluation addSubview:badge];
    //            }
    //            ((UILabel *)[_waitEvaluation viewWithTag:103]).text=[NSString stringWithFormat:@"%d",orderTTL.waitEvaluation];
    //        }else{
    //            [[_waitEvaluation viewWithTag:103] removeFromSuperview];
    //        }
    //        if (orderTTL.waitPayBack>0){//待退款
    //            NSLog(@"--->%ld",orderTTL.waitPayBack);
    //            if(![_waitPayBack viewWithTag:104]){
    //                UILabel *badge=[[UILabel alloc] init];
    //                badge.backgroundColor=deafultColor;
    //                badge.font=[UIFont systemFontOfSize:10];
    //                badge.layer.masksToBounds=YES;
    //                badge.layer.cornerRadius=6;
    //                badge.textColor=[UIColor whiteColor];
    //                badge.textAlignment=NSTextAlignmentCenter;
    //                CGRect frame=_waitPayBack.frame;
    //                badge.frame=CGRectMake(_waitPay.size.width/2.f + 11, 5, 22, 12);
    //                badge.tag=104;
    //                [_waitPayBack addSubview:badge];
    //            }
    //            ((UILabel *)[_waitPayBack viewWithTag:104]).text=[NSString stringWithFormat:@"%d",orderTTL.waitPayBack];
    //        }else{
    //            [[_waitPayBack viewWithTag:104] removeFromSuperview];
    //        }
    //        if (orderTTL.messageNum>0) {//消息中心
    //            if(![_btnMessage viewWithTag:105]){
    //                UILabel *badge=[[UILabel alloc] init];
    //                badge.backgroundColor=[UIColor redColor];
    //                badge.font=[UIFont systemFontOfSize:10];
    //                badge.layer.masksToBounds=YES;
    //                badge.layer.cornerRadius=6;
    //                badge.textColor=[UIColor whiteColor];
    //                badge.textAlignment=NSTextAlignmentCenter;
    //                CGRect frame=_btnMessage.frame;
    //                badge.frame=CGRectMake(frame.size.width-6, -3, 12, 12);
    //                badge.tag=105;
    //                [_btnMessage insertSubview:badge aboveSubview:_btnMessage.titleLabel];
    //            }
    //            ((UILabel *)[_btnMessage viewWithTag:105]).text=[NSString stringWithFormat:@"%d",orderTTL.messageNum];
    //
    //        }else{
    //            [[_btnMessage viewWithTag:105] removeFromSuperview];
    //        }
    
    //    }
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

#pragma mark - 按钮事件
- (IBAction)gotoSetting:(id)sender {
    //统计我的页面的选择
    NSDictionary *dict1 = @{@"actionName":@"跳转",@"pageName":@"我的主页面",@"titleName":@"修改信息"};
    [MTA trackCustomKeyValueEvent:@"LYClickEvent" props:dict1];
    
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    LYUserDetailController *detailViewController = [[LYUserDetailController alloc]init];
    [app.navigationController pushViewController:detailViewController animated:YES];
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
    LPMyOrdersViewController *myOrderVC = [[LPMyOrdersViewController alloc]init];
    myOrderVC.orderIndex = (int)orderType;
    myOrderVC.bagesArr = self.badgesArray;
    //    LYMyOrderManageViewController *myOrderManageViewController=[[LYMyOrderManageViewController alloc]initWithNibName:@"LYMyOrderManageViewController" bundle:nil];
    //    myOrderManageViewController.title=@"我的订单";
    //    myOrderManageViewController.orderType=orderType;
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    //    [app.navigationController pushViewController:myOrderManageViewController animated:YES];
    [app.navigationController pushViewController:myOrderVC animated:YES];
}

- (IBAction)checkFansOrCares:(UIButton *)sender {
    NSDictionary *dict1 = @{@"actionName":@"跳转",@"pageName":@"我的主页面",@"titleName":@"查看粉丝"};
    [MTA trackCustomKeyValueEvent:@"LYClickEvent" props:dict1];
    
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    LYGuWenFansViewController *checkVC = [[LYGuWenFansViewController alloc]init];
    checkVC.userID = [NSString stringWithFormat:@"%d",app.userModel.userid];
    checkVC.type = 0;
    [app.navigationController pushViewController:checkVC animated:YES];
}


- (IBAction)CheckCareButtonAction:(UIButton *)sender {
    NSDictionary *dict1 = @{@"actionName":@"跳转",@"pageName":@"我的主页面",@"titleName":@"查看关注"};
    [MTA trackCustomKeyValueEvent:@"LYClickEvent" props:dict1];
    
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    LYGuWenFansViewController *checkVC = [[LYGuWenFansViewController alloc]init];
    checkVC.userID = [NSString stringWithFormat:@"%d",app.userModel.userid];
    
    //    if ([app.userModel.usertype isEqualToString:@"2"] || [app.userModel.usertype isEqualToString:@"3"]) {
    //        checkVC.type = 0;
    //    }else{
    checkVC.type = 1;
    //    }
    
    [app.navigationController pushViewController:checkVC animated:YES];
    
}




- (IBAction)notificationCenterClick:(UIButton *)sender {
    FindNotificationViewController *findNotificationVC = [[FindNotificationViewController alloc]initWithNibName:@"FindNotificationViewController" bundle:nil];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [app.navigationController pushViewController:findNotificationVC animated:YES];
}

- (IBAction)businessCenterClick:(UIButton *)sender {
    [self gotoShanghu];
}

- (IBAction)QRCodeClick:(MineMenuButton *)sender {
    MyCodeViewController *codeViewController = [[MyCodeViewController alloc]initWithNibName:@"MyCodeViewController" bundle:nil];
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app.navigationController pushViewController:codeViewController animated:YES];
}

- (IBAction)MineMoneyBagClick:(MineMenuButton *)sender {
    MineMoneyBagViewController *mineMoneyBagVC = [[MineMoneyBagViewController alloc]initWithNibName:@"MineMoneyBagViewController" bundle:[NSBundle mainBundle]];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [app.navigationController pushViewController:mineMoneyBagVC animated:YES];
}

- (IBAction)MineGroupClick:(MineMenuButton *)sender {
    MineGroupViewController *mineGroupVC = [[MineGroupViewController alloc]initWithNibName:@"MineGroupViewController" bundle:nil];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [app.navigationController pushViewController:mineGroupVC animated:YES];
}

- (IBAction)MineApplyClick:(MineMenuButton *)sender {
    [LYUserHttpTool getZSJLStatusComplete:^(ZSApplyStatusModel *model) {
        UserModel *userModel = ((AppDelegate *)[UIApplication sharedApplication].delegate).userModel;
        statusModel = model;
        //        statusModel.applyType 1.支付宝 2.银行卡 3.微信
        //        statusModel.wechatAccount
        //        userModel.applyStatus 0.未申请 1.审核中 2.已审核 3.审核未通过 4.待处理
        UIViewController *detailViewController;
        if ([userModel.usertype isEqualToString:@"2"]) {
            [MyUtil showLikePlaceMessage:@"您已经是专属经理！"];
            return ;
        }
        if (userModel.applyStatus == 1) {
            if ([statusModel.applyType isEqualToString:@"3"] && !statusModel.wechatAccount.length) {
                //                canApply = YES;
                //                enterStep = 2;
                detailViewController = [[wechatCheckAccountViewController alloc]initWithNibName:@"wechatCheckAccountViewController" bundle:nil];
                ((wechatCheckAccountViewController *)detailViewController).nsCode=statusModel.sn;
                detailViewController.title = @"微信帐号验证";
            }else{
                if ([userModel.usertype isEqualToString:@"1"]){
                    [MyUtil showLikePlaceMessage:@"正在审核中！"];
                }
            }
        }else if(userModel.applyStatus == 0){
            //            canApply = YES;
            //            enterStep = 1;
            detailViewController = [[LYZSApplicationViewController alloc]initWithNibName:@"LYZSApplicationViewController" bundle:nil];
            detailViewController.title=@"申请专属经理";
        }else if (userModel.applyStatus == 3){
            //            canApply = YES;
            //            enterStep = 3;
            detailViewController = [[checkUnpassedViewController alloc]initWithNibName:@"checkUnpassedViewController" bundle:nil];
            detailViewController.title = @"申请专属经理";
        }else if ([userModel.usertype isEqualToString:@"3"] || userModel.applyStatus == 4){
            [MyUtil showLikePlaceMessage:@"您已经是专属经理！"];
            return ;
        }
        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        [app.navigationController pushViewController:detailViewController animated:YES];
    }];
    
}
@end
