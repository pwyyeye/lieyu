//
//  SaoYiSaoViewController.m
//  lieyu
//
//  Created by 薛斯岐 on 15/10/29.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "SaoYiSaoViewController.h"
#import "LYUserHttpTool.h"
#import "LYMyFriendDetailViewController.h"
#import "CheckOrderWithQRViewController.h"

@interface SaoYiSaoViewController ()
@property (strong, nonatomic) UIView *boxView;
@property (nonatomic) BOOL isReading;
@property (strong, nonatomic) CALayer *scanLayer;
-(BOOL)startReading;
-(void)stopReading;
//捕捉会话
@property (nonatomic, strong) AVCaptureSession *captureSession;
//展示layer
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@end

@implementation SaoYiSaoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
//    self.automaticallyAdjustsScrollViewInsets = NO;
    _captureSession = nil;
    _isReading = NO;
//    [self scanQRCode];
    [self startReading];
    // Do any additional setup after loading the view from its nib.
}
- (BOOL)startReading {
    NSError *error;
    //1.初始化捕捉设备（AVCaptureDevice），类型为AVMediaTypeVideo
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //2.用captureDevice创建输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (!input) {
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    //3.创建媒体数据输出流
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    //4.实例化捕捉会话
    _captureSession = [[AVCaptureSession alloc] init];
    //4.1.将输入流添加到会话
    [_captureSession addInput:input];
    //4.2.将媒体输出流添加到会话中
    [_captureSession addOutput:captureMetadataOutput];
    //5.创建串行队列，并加媒体输出流添加到队列当中
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    //5.1.设置代理
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    //5.2.设置输出媒体数据类型为QRCode
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    //6.实例化预览图层
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    //7.设置预览图层填充方式
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    //8.设置图层的frame 115
//    [_videoPreviewLayer setFrame:CGRectMake(0, 0, SCREEN_WIDTH - 46, SCREEN_HEIGHT - 115 - 64)];
    [_videoPreviewLayer setFrame:CGRectMake(0, 0, SCREEN_WIDTH - 100, SCREEN_WIDTH - 100)];
    NSLog(@"%@",NSStringFromCGRect(_videoPreviewLayer.frame));
        //9.将图层添加到预览view的图层上
    [_viewPreview.layer addSublayer:_videoPreviewLayer];
    //10.设置扫描范围
    captureMetadataOutput.rectOfInterest = CGRectMake(0, 0, 1, 1);
    
    
    
    
    
    //10.1.扫描框
//    _boxView = [[UIView alloc] initWithFrame:CGRectMake(_viewPreview.bounds.size.width * 0.2f, _viewPreview.bounds.size.height * 0.2f, _viewPreview.bounds.size.width - _viewPreview.bounds.size.width * 0.4f, _viewPreview.bounds.size.height - _viewPreview.bounds.size.height * 0.4f)];
////    _boxView.center = _viewPreview.center;
//    NSLog(@"%@",NSStringFromCGRect(_boxView.frame));
//    NSLog(@"%@",NSStringFromCGRect(_viewPreview.frame));
//    _boxView.layer.borderColor = [UIColor greenColor].CGColor;
//    _boxView.layer.borderWidth = 1.0f;
//    [_viewPreview addSubview:_boxView];
    //10.2.扫描线
    _scanLayer = [[CALayer alloc] init];
    _scanLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH - 100, 1);
    _scanLayer.backgroundColor = [UIColor brownColor].CGColor;
    [_viewPreview.layer addSublayer:_scanLayer];
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.04f target:self selector:@selector(moveScanLayer:) userInfo:nil repeats:YES];
    [timer fire];
    //10.开始扫描
    [_captureSession startRunning];
    return YES;
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    //判断是否有数据
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        //判断回传的数据类型
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            NSString *dataString = [metadataObj stringValue];
            NSString *subString = [dataString substringToIndex:69];
            if([subString isEqualToString:@"http://www.lie98.com/lieyu/lyUserShakeAction.do?action=custom?userid="]){
                //如果是速核码
                NSArray *array = [dataString componentsSeparatedByString:@"&"];
                NSString *userId = [array[0] substringFromIndex:69];
                NSString *currentTime = [array[1] substringFromIndex:12];
                NSDictionary *dict = @{@"userid":userId,
                                       @"currentTime":currentTime,
                                       @"usertype":self.userModel.usertype};
                [LYUserHttpTool userScanQRCodeWithPara:dict complete:^(NSDictionary *result) {
                    if ([self.userModel.usertype isEqualToString:@"1"]) {
                        if ([[result valueForKey:@"message"] isEqualToString:@"已经是好友！"]){
                            //如果已经是好友了，进入玩友详情
                            LYMyFriendDetailViewController *MyFriendDetailVC = [[LYMyFriendDetailViewController alloc]initWithNibName:@"LYMyFriendDetailViewController" bundle:nil];
                            MyFriendDetailVC.userID = [NSString stringWithFormat:@"%@",[result valueForKey:@"data"] ];
                            [self.navigationController pushViewController:MyFriendDetailVC animated:YES];
                        }else{
                            [self.navigationController popToRootViewControllerAnimated:YES];
                            [MyUtil showLikePlaceMessage:[result valueForKey:@"message"]];
                        }
                    }
                    else if ([self.userModel.usertype isEqualToString:@"2"]){
                        //商户扫码，进行核实订单
                        NSArray *tempArr = [result valueForKey:@"data"];
                        if (tempArr.count <= 1) {
                            //只有一个订单，扫码核单成功
                            [self.navigationController popToRootViewControllerAnimated:YES];
                            [MyUtil showLikePlaceMessage:[result valueForKey:@"message"]];
                        }else{
                            //多于一单，进入订单选择页面
                            CheckOrderWithQRViewController *checkorderVC = [[CheckOrderWithQRViewController alloc]initWithNibName:@"CheckOrderWithQRViewController" bundle:nil];
                            checkorderVC.tempArr = tempArr;
                            [self.navigationController pushViewController:checkorderVC animated:YES];
                        }
                    }
                }];
                 
            }else{
                NSURL* url = [[NSURL alloc] initWithString:dataString];
                [[ UIApplication sharedApplication]openURL:url];
            }
        }
    }
}

- (void)moveScanLayer:(NSTimer *)timer
{
    CGRect frame = _scanLayer.frame;
    if (_viewPreview.frame.size.height < _scanLayer.frame.origin.y) {
        frame.origin.y = 0;
        _scanLayer.frame = frame;
    }else{
        frame.origin.y += 5;
        [UIView animateWithDuration:0.1 animations:^{
            _scanLayer.frame = frame;
        }];
    }
}
- (IBAction)startStopReading:(id)sender {
    if (!_isReading) {
        if ([self startReading]) {
            [_startBtn setTitle:@"Stop" forState:UIControlStateNormal];
            [_lblStatus setText:@"Scanning for QR Code"];
        }
    }
    else{
        [self stopReading];
        [_startBtn setTitle:@"Start!" forState:UIControlStateNormal];
    }
    _isReading = !_isReading;
}

- (void)viewWillDisappear:(BOOL)animated{
    [self stopReading];
}

-(void)stopReading{
    [_captureSession stopRunning];
    _captureSession = nil;
    [_scanLayer removeFromSuperlayer];
    [_videoPreviewLayer removeFromSuperlayer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scanQRCode{
    NSString *dataString = @"http://www.lie98.com/lieyu/lyUserShakeAction.do?action=custom?userid=130616&currentTime=2016-03-09 16:06:34";
    NSString *subString = [dataString substringToIndex:69];
    if([subString isEqualToString:@"http://www.lie98.com/lieyu/lyUserShakeAction.do?action=custom?userid="]){
        //如果是速核码
        NSArray *array = [dataString componentsSeparatedByString:@"&"];
        NSString *userId = [array[0] substringFromIndex:69];
        NSString *currentTime = [array[1] substringFromIndex:12];
        NSDictionary *dict = @{@"userid":userId,
                               @"currentTime":currentTime,
                               @"usertype":self.userModel.usertype};
        NSLog(@"%d",self.userModel.userid);
        [LYUserHttpTool userScanQRCodeWithPara:dict complete:^(NSDictionary *result) {
            if ([self.userModel.usertype isEqualToString:@"1"]) {
               if ([[result valueForKey:@"message"] isEqualToString:@"已经是好友！"]){
                    //如果已经是好友了，进入玩友详情
                    LYMyFriendDetailViewController *MyFriendDetailVC = [[LYMyFriendDetailViewController alloc]initWithNibName:@"LYMyFriendDetailViewController" bundle:nil];
                    MyFriendDetailVC.userID = [NSString stringWithFormat:@"%@",[result valueForKey:@"data"] ];
                   [self.navigationController pushViewController:MyFriendDetailVC animated:YES];
                }else{
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    [MyUtil showLikePlaceMessage:[result valueForKey:@"message"]];
                }
            }
            else if ([self.userModel.usertype isEqualToString:@"2"]){
                //商户扫码，进行核实订单
                NSArray *tempArr = [result valueForKey:@"data"];
                if (tempArr.count <= 1) {
                    //只有一个订单，扫码核单成功
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    [MyUtil showLikePlaceMessage:[result valueForKey:@"message"]];
                }else{
                    //多于一单，进入订单选择页面
                    CheckOrderWithQRViewController *checkorderVC = [[CheckOrderWithQRViewController alloc]initWithNibName:@"CheckOrderWithQRViewController" bundle:nil];
                    checkorderVC.tempArr = tempArr;
                    [self.navigationController pushViewController:checkorderVC animated:YES];
                }
            }
        }];
    }
}
@end
