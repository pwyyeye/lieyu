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
@implementation LYUserCenterHeader

- (void)awakeFromNib {
    // Initialization code
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if (app.userModel) {
        //设置头像
        [_avatar_img setImageWithURL:[NSURL URLWithString:app.userModel.avatar_img] placeholderImage:[UIImage imageNamed:app.userModel.gender.intValue==0?@"lieyu_default_female":@"lieyu_default_male"]];
        [_age setTitle:[NSString stringWithFormat:@"%@岁",app.userModel.age]  forState:UIControlStateNormal];
        NSArray *tags=app.userModel.tags;
        NSMutableString *mytags=[[NSMutableString alloc] init];
        for (UserTagModel *tag in tags) {
            if ([tag isEqual:tags.lastObject]) {
                [mytags appendString:tag.tagname];
            }else{
                [mytags appendString:tag.tagname];
                [mytags appendString:@","];
            }
            
        }
        [_tags setTitle:mytags forState:UIControlStateNormal];
        _userNick.text=app.userModel.usernick;
    }
    
  //  修改的部分
//    UIColor *_inputColor0 = RGBA(109, 0, 142,0.8);
//    UIColor *_inputColor1 = RGBA(64, 1, 120,0.8);
//    CGPoint _inputPoint0 = CGPointMake(0.5, 0);
//    CGPoint _inputPoint1 = CGPointMake(0.5, 1);
//    CAGradientLayer *layer = [CAGradientLayer new];
//    layer.colors = @[(__bridge id)_inputColor0.CGColor, (__bridge id)_inputColor1.CGColor];
//    layer.startPoint = _inputPoint0;
//    layer.endPoint = _inputPoint1;
//    layer.frame = CGRectMake(0, -20, SCREEN_WIDTH, self.bounds.size.height);
//    [self.headView.layer addSublayer:layer];
//    
//
//    [self.headView.layer setShadowColor:[UIColor redColor].CGColor];
//    self.headView.layer.shadowOffset=CGSizeMake(0, -4);
//    self.headView.layer.shadowOpacity=0.8;
//    self.headView.layer.shadowRadius = 4;
    
//    _avatar_img_bg.image=[MyUtil getImageFromColor:RGBA(255, 255, 255, 0.5)];

    
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
    
//    UIImage *bgImage=[UIImage imageNamed:@"headBgColor"];
//    bgImage=[bgImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeTile];
//    
//    self.headView.backgroundColor=[UIColor colorWithPatternImage:bgImage] ;
    
}

-(void)updateConstraints{
     [super updateConstraints];
    _line1Heght.constant=0.5;
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
}

- (IBAction)gotoMessageList:(id)sender {
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    MyMessageListViewController *messageListViewController=[[MyMessageListViewController alloc]initWithNibName:@"MyMessageListViewController" bundle:nil];
    messageListViewController.title=@"信息中心";
    [app.navigationController pushViewController:messageListViewController animated:YES];
}

- (IBAction)gotoOrderList:(id)sender {
    LYMyOrderManageViewController *myOrderManageViewController=[[LYMyOrderManageViewController alloc]initWithNibName:@"LYMyOrderManageViewController" bundle:nil];
    myOrderManageViewController.title=@"我的订单";
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app.navigationController pushViewController:myOrderManageViewController animated:YES];
}

- (IBAction)gotoWaitPayOrderList:(id)sender {
}

- (IBAction)gotoWaitConsumptionOrderList:(id)sender {
}

- (IBAction)gotoWaitRebateOrderList:(id)sender {
}

- (IBAction)gotoWaitEvaluationOrderList:(id)sender {
}

- (IBAction)gotoWaitPayBackOrderList:(id)sender {
}
@end
