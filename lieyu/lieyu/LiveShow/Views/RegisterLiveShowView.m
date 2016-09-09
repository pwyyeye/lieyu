//
//  RegisterLiveShowView.m
//  lieyu
//
//  Created by 狼族 on 16/8/18.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "RegisterLiveShowView.h"
#import "LiveShowViewController.h"
#import "LYFriendsHttpTool.h"
#import "HTTPController.h"
#import "UMSocial.h"

@interface RegisterLiveShowView () <UIAlertViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

{
    int _shareType;
    NSString *_stream;//播放流
    NSString *_chatroomid;//聊天室ID
    NSString *_roomid;//直播室ID
    BOOL _isShare;//是否分享
}

@property (weak, nonatomic) IBOutlet UIImageView *LiveImageView;

@property (weak, nonatomic) IBOutlet UITextField *titleTextFiled;

@property (weak, nonatomic) IBOutlet UIButton *addTitleButton;

@property (weak, nonatomic) IBOutlet UIButton *screateButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *beginButtonConstraint;

@property (weak, nonatomic) IBOutlet UIButton *beginShow;



@property (weak, nonatomic) IBOutlet UIButton *weChatSessionButton;

@property (weak, nonatomic) IBOutlet UIButton *qqButton;

@property (weak, nonatomic) IBOutlet UIButton *weiboButton;

@property (weak, nonatomic) IBOutlet UIButton *weChatMonmentButton;

@property (weak, nonatomic) IBOutlet UIButton *lyMonmentButton;

@property (nonatomic, strong) NSString *imgUrl;//图片地址
@property (nonatomic, strong) NSString *titleText;//标题
@property (nonatomic, assign) BOOL _isSecret;//私密

@end

@implementation RegisterLiveShowView

-(void)layoutSubviews{
    [self initUI];
}

#pragma mark --- 初始化页面
-(void)initUI{
    [_beginShow addTarget:self action:@selector(registerShow:) forControlEvents:(UIControlEventTouchUpInside)];
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imagePakerAvtion)];
    [_LiveImageView addGestureRecognizer:tapGes];
    _LiveImageView.userInteractionEnabled = YES;
    
    _isShare = YES;
    _shareType = 3;//默认分享到朋友圈
    
    [self setcorrnerRadius:_qqButton];
    [self setcorrnerRadius:_weiboButton];
    [self setcorrnerRadius:_weChatMonmentButton];
    [self setcorrnerRadius:_weChatSessionButton];
    [self setcorrnerRadius:_lyMonmentButton];
    [self setcorrnerRadius:_titleTextFiled];
    [self setcorrnerRadius:_beginShow];
    
    _beginShow.layer.borderWidth = 1.f;
    _beginShow.layer.borderColor = RGB(187, 40, 217).CGColor;
    _weChatSessionButton.tag = 101;
    _qqButton.tag = 102;
    _weiboButton.tag = 103;
    _weChatMonmentButton.tag = 104;
    _lyMonmentButton.tag = 105;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(registerAction)];
    [self addGestureRecognizer:tap];
    
}

-(void)registerAction{
    [self.titleTextFiled resignFirstResponder];
}

- (IBAction)SliderValueDidChange:(UISlider *)sender {
    _beginLive(sender.value);
}

#pragma mark --- 削圆角以及点击事件
-(void) setcorrnerRadius:(UIView *)view{
    view.layer.cornerRadius = view.frame.size.height / 2;
    view.layer.masksToBounds = YES;
}


- (IBAction)shareAction:(UIButton *)sender {
    switch (sender.tag) {
        case 101://微信
            if (_shareType != 0) {
                _isShare = YES;
            }
            if (_isShare) {
                _shareType = 0;
                _isShare = NO;
                [self.weChatSessionButton setImage:[UIImage imageNamed:@"live_wechat.png"] forState:(UIControlStateNormal)];
                
                [self.weiboButton setImage:[UIImage imageNamed:@"live_B_sina.png"] forState:(UIControlStateNormal)];
                [self.weChatMonmentButton setImage:[UIImage imageNamed:@"live_B_wechatmoment.png"] forState:(UIControlStateNormal)];
                [self.qqButton setImage:[UIImage imageNamed:@"live_B_qq.png"] forState:(UIControlStateNormal)];
            } else {
                _isShare = YES;
                _shareType = -1;//不分享
                [self.weChatSessionButton setImage:[UIImage imageNamed:@"live_B_wechat.png"] forState:(UIControlStateNormal)];
            }
            
            break;
        case 102://QQ
            if (_shareType != 1) {
                _isShare = YES;
            }
            if (_isShare) {
                _shareType = 1;
                _isShare = NO;
                [self.weChatSessionButton setImage:[UIImage imageNamed:@"live_B_wechat.png"] forState:(UIControlStateNormal)];
                [self.weiboButton setImage:[UIImage imageNamed:@"live_B_sina.png"] forState:(UIControlStateNormal)];
                [self.weChatMonmentButton setImage:[UIImage imageNamed:@"live_B_wechatmoment.png"] forState:(UIControlStateNormal)];
                [self.qqButton setImage:[UIImage imageNamed:@"live_qq.png"] forState:(UIControlStateNormal)];
            } else {
                _isShare = YES;
                _shareType = -1;//不分享
                [self.qqButton setImage:[UIImage imageNamed:@"live_B_qq.png"] forState:(UIControlStateNormal)];
            }
            
            break;
        case 103://sina
            if (_shareType != 2) {
                _isShare = YES;
            }
            if (_isShare) {
                _shareType = 2;
                _isShare = NO;
                [self.weChatSessionButton setImage:[UIImage imageNamed:@"live_B_wechat.png"] forState:(UIControlStateNormal)];
                
                [self.weiboButton setImage:[UIImage imageNamed:@"live_sina.png"] forState:(UIControlStateNormal)];
                [self.weChatMonmentButton setImage:[UIImage imageNamed:@"live_B_wechatmoment.png"] forState:(UIControlStateNormal)];
                [self.qqButton setImage:[UIImage imageNamed:@"live_B_qq.png"] forState:(UIControlStateNormal)];
            } else {
                _isShare = YES;
                _shareType = -1;//不分享
                [self.weiboButton setImage:[UIImage imageNamed:@"live_B_sina.png"] forState:(UIControlStateNormal)];
            }
            break;
        case 104://微信朋友圈
            if (_shareType != 3) {
                _isShare = YES;
            }
            if (_isShare) {
                _shareType = 3;
                _isShare = NO;
                [self.weChatSessionButton setImage:[UIImage imageNamed:@"live_B_wechat.png"] forState:(UIControlStateNormal)];
                [self.weiboButton setImage:[UIImage imageNamed:@"live_B_sina.png"] forState:(UIControlStateNormal)];
                [self.weChatMonmentButton setImage:[UIImage imageNamed:@"live_wechatmonent.png"] forState:(UIControlStateNormal)];
                [self.qqButton setImage:[UIImage imageNamed:@"live_B_qq.png"] forState:(UIControlStateNormal)];
            } else {
                _isShare = YES;
                _shareType = -1;//不分享
                [self.weChatMonmentButton setImage:[UIImage imageNamed:@"live_B_wechatmoment.png"] forState:(UIControlStateNormal)];
            }
            break;
//        case 105:
//            _shareType = 4;
//            break;
        default:
            break;
    }
    
}

#pragma mark -- 选择图片
-(void) imagePakerAvtion {
    UIActionSheet *menuSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择",@"拍一张", nil];
    [menuSheet showInView:self];
}


#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    UIImagePickerController *pickerCtl = [[UIImagePickerController alloc]init];
    pickerCtl.allowsEditing = YES;
    pickerCtl.delegate = self;
    switch (buttonIndex) {
        case 0:
        {
            pickerCtl.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
            break;
            
        case 1:
        {
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
                pickerCtl.sourceType = UIImagePickerControllerSourceTypeCamera;
            else pickerCtl.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
            
        default:
            break;
    }
    UIViewController *selfVC = [self getCurrentViewController];
    [selfVC presentViewController:pickerCtl animated:YES completion:NULL];
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

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = info[UIImagePickerControllerEditedImage];
    _LiveImageView.image = image;
    _begainImage(image);

    [HTTPController uploadImageToQiuNiu:image withDegree:0.5 complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        //            AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        //            [app startLoading];
        NSString *imgUrl = [MyUtil getQiniuUrl:key width:0 andHeight:0];
        _imgUrl = imgUrl;
    }];
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
}



#pragma mark --- 开始直播
-(void)registerShow:(UIButton *) sender {
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    [self openLiveShowRoom];
    UIViewController *selfVC = [self getCurrentViewController];
     CLLocation *location = app.userLocation;
//    NSDate* dat = [NSDate date];
//    NSTimeInterval a=[dat timeIntervalSince1970]*1000;
//    NSString *time13 = [NSString stringWithFormat:@"%f",a];
//    NSString *times = [time13 substringToIndex:13];
//    _roomId =  [NSString stringWithFormat:@"%d%@", app.userModel.userid,times];
    NSString *liveStr = [NSString stringWithFormat:@"下载猎娱App猎寻更多特色酒吧。http://10.17.30.44:8080/liveroom/live?liveChatId=%@",_roomId];
     UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeMusic url:liveStr];
     switch (_shareType) {
     case 0://分享微信好友
         {[[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:@"测试一下" image:_LiveImageView.image location:location urlResource:urlResource presentedController:selfVC completion:^(UMSocialResponseEntity *response){
         }];
             [self openLiveShowRoom];
             
         }
     break;
     case 1://分享到QQ
         {[[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:@"测试一下" image:_LiveImageView.image location:location urlResource:urlResource presentedController:selfVC completion:^(UMSocialResponseEntity *response){
     }];
             [self openLiveShowRoom];
         }
     break;
     case 2://分享到微博
         {[[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:@"测试一下" image:_LiveImageView.image location:location urlResource:urlResource presentedController:selfVC completion:^(UMSocialResponseEntity *response){
     if (response.responseCode == UMSResponseCodeSuccess) {
     NSLog(@"分享成功！");
     }
         }];
             [self openLiveShowRoom];
         }
     break;
     case 3://分享到微信朋友圈
         {[[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:@"测试一下" image:_LiveImageView.image location:location urlResource:urlResource presentedController:selfVC completion:^(UMSocialResponseEntity *response){
     if (response.responseCode == UMSResponseCodeSuccess) {
     NSLog(@"分享成功！");
     }
         }];
             [self openLiveShowRoom];
         }
     break;
     case 4://分享到玩友圈
     
     break;
    case -1://不分享
             [self openLiveShowRoom];
    break;
     default:
     break;
     }
    
}

#pragma mark -- 进入直播间
-(void)openLiveShowRoom{
    
//    @"http://www.sinaimg.cn/dy/slidenews/76_img/2016_33/76522_1899053_733117.jpg"
    
    if (!_imgUrl) {
        _imgUrl = @"http://www.sinaimg.cn/dy/slidenews/76_img/2016_33/76522_1899053_733117.jpg";
    }
    if ([_titleTextFiled.text  isEqualToString: @""]) {
        _titleTextFiled.text = @"#凡人皆需侍奉！#";
    }
            NSDictionary *dic = @{@"cityCode":@"310000",@"liveimg":_imgUrl,@"livename":_titleTextFiled.text,@"liveChatId":_roomId,@"streamId":_streamID};
            [LYFriendsHttpTool beginToLiveShowWithParams:dic complete:^(NSDictionary *dict) {
               _stream = dict[@"stream"];
                _chatroomid = dict[@"chatroomid"];
                _roomid = dict[@"roomId"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    //创建一个消息对象
                    NSNotification * notice = [NSNotification notificationWithName:@"kobe24" object:nil userInfo:@{@"stream":_stream,@"chatroomid":_chatroomid,@"roomid":_roomid}];
                    //发送消息
                    [[NSNotificationCenter defaultCenter]postNotification:notice];
                });
            }];
//    __weak registerPushTRoomViewController *weakSelf = self;
//    UIViewController *selfVC = [self getCurrentViewController];
//    [selfVC presentViewController:liveVC animated:YES completion:NULL];
}

#pragma mark --- 返回
-(void)backButtonAction:(UIButton *)sender {
//    UIViewController *selfVC = [self getCurrentViewController];
//    [selfVC dismissViewControllerAnimated:YES completion:NULL];
}

@end