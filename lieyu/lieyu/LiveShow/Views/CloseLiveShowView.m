//
//  CloseLiveShowView.m
//  lieyu
//
//  Created by 狼族 on 16/8/18.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "CloseLiveShowView.h"
#import "UMSocial.h"

@interface CloseLiveShowView ()



@property (weak, nonatomic) IBOutlet UIButton *qqButton;

@property (weak, nonatomic) IBOutlet UIButton *weChatButton;

@property (weak, nonatomic) IBOutlet UIButton *weChatMonmentButton;
@property (weak, nonatomic) IBOutlet UIButton *sinaButton;

@property (weak, nonatomic) IBOutlet UIButton *wanyouButton;


@end


@implementation CloseLiveShowView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

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
//    UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:_begainImage];
    UIViewController *selfVC = [self getCurrentViewController];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    CLLocation *location = app.userLocation;
    NSString *liveStr = [NSString stringWithFormat:@"%@%@%@",LY_SERVER,LY_LIVE_share,_chatRoomID];
    UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeDefault url:liveStr];
    //主标题
    [UMSocialData defaultData].extConfig.wechatSessionData.title = @"猎娱直播间";
    [UMSocialData defaultData].extConfig.wechatTimelineData.title =  _shareText;
    [UMSocialData defaultData].extConfig.qqData.title = @"猎娱直播间";
    //分享的链接
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = liveStr;
    [UMSocialData defaultData].extConfig.wechatSessionData.url = liveStr;
    switch (sender.tag) {
        case 100://分享微信好友
        {[[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:_shareText image:_begainImage location:location urlResource:urlResource presentedController:selfVC completion:^(UMSocialResponseEntity *response){
        }];
            
        }
            break;
        case 99://分享到QQ
        {[[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:_shareText image:_begainImage location:location urlResource:urlResource presentedController:selfVC completion:^(UMSocialResponseEntity *response){
        }];
        }
            break;
        case 102://分享到微博
        {[[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:_shareText image:_begainImage location:location urlResource:urlResource presentedController:selfVC completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功！");
            }
        }];
        }
            break;
        case 101://分享到微信朋友圈
        {[[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:_shareText image:_begainImage location:location urlResource:urlResource presentedController:selfVC completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功！");
            }
        }];
        }
            break;
        case 4://分享到玩友圈
            
            break;
        case -1://不分享
            break;
        default:
            break;
    }

}


-(void)layoutSubviews{
    self.backButton.layer.borderColor = RGB(187, 40, 217).CGColor;
    self.backButton.layer.borderWidth = 2.f;
}


@end
