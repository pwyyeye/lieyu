//
//  LiveShowEndView.m
//  lieyu
//
//  Created by 狼族 on 16/8/25.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LiveShowEndView.h"
#import "UMSocial.h"

@implementation LiveShowEndView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    self.backButton.layer.borderColor = RGB(187, 40, 217).CGColor;
    self.backButton.layer.borderWidth = 1.f;
    self.focusButton.layer.borderColor = RGB(187, 40, 217).CGColor;
    self.focusButton.layer.borderWidth = 1.f;
    
    [self setCornerRadiusView:self.backButton With:self.backButton.frame.size.height / 2 and:YES];
    [self setCornerRadiusView:self.focusButton With:self.focusButton.frame.size.height / 2 and:YES];
}

//获取控制器
-(UIViewController *)getCurrentViewController{
    UIResponder *next = [self nextResponder];
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = [next nextResponder];
    } while (next != nil);
    return nil;
}

- (IBAction)shareButtonAction:(UIButton *)sender {
    
    UIViewController *selfVC = [self getCurrentViewController];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    CLLocation *location = app.userLocation;
    NSString *liveStr = [NSString stringWithFormat:@"%@%@%@",LY_SERVER,LY_LIVE_share,_chatRoomID];
    UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeMusic url:liveStr];
    switch (sender.tag) {
        case 100://分享微信好友
        {[[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:@"猎娱直播间" image:_shareImage location:location urlResource:urlResource presentedController:selfVC completion:^(UMSocialResponseEntity *response){
        }];
        }
            break;
        case 99://分享到QQ
        {[[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:@"猎娱直播间" image:_shareImage location:location urlResource:urlResource presentedController:selfVC completion:^(UMSocialResponseEntity *response){
        }];
        }
            break;
        case 102://分享到微博
        {[[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:@"猎娱直播间" image:_shareImage location:location urlResource:urlResource presentedController:selfVC completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功！");
            }
        }];
        }
            break;
        case 101://分享到微信朋友圈
        {[[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:@"猎娱直播间" image:_shareImage location:location urlResource:urlResource presentedController:selfVC completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功！");
            }
        }];
        }
            break;
        default:
            break;
    }

    
}





-(void)setCornerRadiusView:(UIView *) maskView With:(CGFloat) size and:(BOOL) mask{
    maskView.layer.cornerRadius = size;
    maskView.layer.masksToBounds = YES;
}
@end
