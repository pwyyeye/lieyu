//
//  YaoYiYaoViewController.m
//  lieyu
//
//  Created by 薛斯岐 on 15/10/30.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "YaoYiYaoViewController.h"
#import "LYUserHttpTool.h"
#import "LYUserLocation.h"
#import "LYMyFriendDetailViewController.h"
#import "CustomerModel.h"
#import "YaoSettingViewController.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
@interface YaoYiYaoViewController ()
{
    UIBarButtonItem *rightBtn;
    CustomerModel *customerModel;
    NSArray *cusArr;
}
@end

@implementation YaoYiYaoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    rightBtn=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_setting2_normal"] style:UIBarButtonItemStylePlain target:self action:@selector(setAct:)];
    [self.navigationItem setRightBarButtonItem:rightBtn];
    
    [_detailBtn setBackgroundColor:[UIColor clearColor]];
    self.userImageView.layer.masksToBounds =YES;
    
    self.userImageView.layer.cornerRadius =self.userImageView.frame.size.width/2;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"5018" ofType:@"wav"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &soundID);
    [[UIApplication sharedApplication] setApplicationSupportsShakeToEdit:YES];
    
    [self becomeFirstResponder];
    // Do any additional setup after loading the view from its nib.
}
-(void)setAct:(id)sender{
    YaoSettingViewController *settingViewController=[[YaoSettingViewController alloc]initWithNibName:@"YaoSettingViewController" bundle:nil];
    settingViewController.title=@"设置";
    [self.navigationController pushViewController:settingViewController animated:YES];
}

- (void) motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event

{
    NSLog(@"摇动开始");
    //检测到摇动
    
}



- (void) motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event

{
    NSLog(@"摇动取消");

    //摇动取消
    
}



- (void) motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event

{
    
    //摇动结束
    NSLog(@"摇动结束");
    if (event.subtype == UIEventSubtypeMotionShake) {
        [_resultView setHidden:YES];
        [self addAnimations];
        //something happens
        [self getData];
    }
    
}
-(void)getData{
    __weak __typeof(self)weakSelf = self;
    CLLocation * userLocation = [LYUserLocation instance].currentLocation;
    NSDictionary *dic=@{@"userid":[NSNumber numberWithInt:self.userModel.userid],@"longitude":@(userLocation.coordinate.longitude),@"latitude":@(userLocation.coordinate.latitude)};
    [[LYUserHttpTool shareInstance]getYaoYiYaoFriendListWithParams:dic block:^(NSMutableArray *result) {
        if(result.count>0){
            cusArr=result;
            customerModel=cusArr[0];
            [weakSelf.resultView setHidden:NO];
            weakSelf.namelal.text=customerModel.usernick;
            weakSelf.delLal.text=[NSString stringWithFormat:@"%@米",customerModel.distance];
            if (customerModel.distance.doubleValue>1000) {
                double d=customerModel.distance.doubleValue/1000;
                weakSelf.delLal.text=[NSString stringWithFormat:@"%.2f千米",d];
            }
            if([customerModel.sex isEqualToString:@"1"]){
                weakSelf.sexImageView.image=[UIImage imageNamed: @"manIcon"];
            }else{
                weakSelf.sexImageView.image=[UIImage imageNamed: @"woman"];
            }
            
            [weakSelf.userImageView setImageWithURL:[NSURL URLWithString:customerModel.avatar_img]];
        }else{
           
        }
    }];
}
#pragma mark - 摇一摇动画效果
- (void)addAnimations
{
    NSString *isSound=[USER_DEFAULT objectForKey:@"yaoSound"];
    
    if([MyUtil isEmptyString:isSound]){
        AudioServicesPlaySystemSound (soundID);
    }else{
        if([isSound isEqualToString:@"YES"]){
            AudioServicesPlaySystemSound (soundID);
        }
    }

    
    
    //让imgup上下移动
    CABasicAnimation *translation2 = [CABasicAnimation animationWithKeyPath:@"position"];
    translation2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    if(_is4s){
        translation2.fromValue = [NSValue valueWithCGPoint:CGPointMake(160, 104)];
        translation2.toValue = [NSValue valueWithCGPoint:CGPointMake(160, 104-100)];
    }else{
        translation2.fromValue = [NSValue valueWithCGPoint:CGPointMake(160, 126.5)];
        translation2.toValue = [NSValue valueWithCGPoint:CGPointMake(160, 126.5-100)];
    }
    
    translation2.duration = 0.4;
    translation2.repeatCount = 1;
    translation2.autoreverses = YES;
    
    //让imagdown上下移动
    CABasicAnimation *translation = [CABasicAnimation animationWithKeyPath:@"position"];
    translation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    if(_is4s){
        translation.fromValue = [NSValue valueWithCGPoint:CGPointMake(160,  343.5)];
        translation.toValue = [NSValue valueWithCGPoint:CGPointMake(160,  343.5+100)];
    }else{
        translation.fromValue = [NSValue valueWithCGPoint:CGPointMake(160, 379.5)];
        translation.toValue = [NSValue valueWithCGPoint:CGPointMake(160, 379.5+100)];
    }
    
    translation.duration = 0.4;
    translation.repeatCount = 1;
    translation.autoreverses = YES;
    
    [_topView.layer addAnimation:translation2 forKey:@"translation"];
    [_botView.layer addAnimation:translation forKey:@"translation2"];
    
    //    [aiLoad stopAnimating];
    //    aiLoad.hidden=YES;
    
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

- (IBAction)queryDetailAct:(UIButton *)sender {
    LYMyFriendDetailViewController *friendDetailViewController=[[LYMyFriendDetailViewController alloc]initWithNibName:@"LYMyFriendDetailViewController" bundle:nil];
    friendDetailViewController.title=@"详细信息";
    friendDetailViewController.type=@"1";
    friendDetailViewController.customerModel=customerModel;
    [self.navigationController pushViewController:friendDetailViewController animated:YES];
}
@end
