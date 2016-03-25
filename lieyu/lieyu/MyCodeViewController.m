//
//  MyCodeViewController.m
//  lieyu
//
//  Created by 王婷婷 on 16/3/7.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "MyCodeViewController.h"
#import "UIImageView+WebCache.h"
#import "LYMineUrl.h"
#import "qrencode.h"
@interface MyCodeViewController ()<UIActionSheetDelegate>
@property(strong,nonatomic) UIWebView *phoneCallWebView;
@end

@implementation MyCodeViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的二维码";
//    if ([[MyUtil deviceString] isEqualToString:@"iPhone 4"] || [[MyUtil deviceString] isEqualToString:@"iPhone 4S"]) {
    if (SCREEN_WIDTH == 320) {
        _QRCodeViewBottom.constant = 40;
        _QRCodeBGBottom.constant = 20;
        _QRCodeBGTop.constant = 20;
        _QRCodeHeaderTop.constant = 40;
        _userNameTop.constant = 11;
    }
    [_userHeader sd_setImageWithURL:[NSURL URLWithString:self.userModel.avatar_img] placeholderImage:[UIImage imageNamed:@"empyImage120"]];
    _userHeader.backgroundColor = [UIColor clearColor];
    _userHeader.layer.cornerRadius = CGRectGetHeight(_userHeader.frame) / 2;
    _userHeader.layer.masksToBounds = YES;
    _userNick.text = self.userModel.usernick;
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dataString = [formatter stringFromDate:[NSDate date]];
    NSString *string = [NSString stringWithFormat:@"%@%@&userid=%d&CurrentTime=%@",LY_SERVER,@"lyQRCodeAction?action=custom",self.userModel.userid,dataString];
    CGFloat qrcodeLength = 178;
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, qrcodeLength, qrcodeLength)];
    imageV.layer.cornerRadius = 6;
    imageV.layer.masksToBounds = YES;
    imageV.backgroundColor = [UIColor whiteColor];
    imageV.image = [self qrImageForString:string imageSize:200];
    [self.QRCodeView addSubview:imageV];
    
    UIBarButtonItem *itemBar = [[UIBarButtonItem alloc]initWithTitle:@"客服" style:UIBarButtonItemStylePlain target:self action:@selector(ClickSale)];
    [itemBar setTintColor:[UIColor blackColor]];
    self.navigationItem.rightBarButtonItem = itemBar;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)ClickSale{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"速核码客服帮助" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"客服（021-36512128）", nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        NSURL *phoneURL = [NSURL URLWithString:@"tel:02136512128"];
        
        if ( !_phoneCallWebView ) {
            
            _phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];// 这个webView只是一个后台的容易 不需要add到页面上来  效果跟方法二一样 但是这个方法是合法的
            
        }
        
        [_phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
    }
}

- (UIImage *)qrImageForString:(NSString *)string imageSize:(CGFloat)size {
    if (![string length]) {
        return nil;
    }
    //generate QR
    QRcode *code = QRcode_encodeString([string UTF8String], 0, QR_ECLEVEL_L, QR_MODE_8, 1);
    if (!code) {
        return nil;
    }
    if (code->width > size) {
        printf("Image Size is less Than qr code size(%d)\n",code->width);
        return nil;
    }
    //create context
    CGBitmapInfo bitmapinfo = (CGBitmapInfo)kCGImageAlphaPremultipliedLast;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(0, size, size, 8, size * 4, colorSpace, bitmapinfo);
    CGAffineTransform translateTransform = CGAffineTransformMakeTranslation(0, -size);
    CGAffineTransform scaleTransform = CGAffineTransformMakeScale(1, -1);
    CGContextConcatCTM(ctx, CGAffineTransformConcat(translateTransform, scaleTransform));
    
    //draw QR on this context
    [self drawQRCode:code context:ctx size:size];
    
    //get Image
    CGImageRef qrCGImage = CGBitmapContextCreateImage(ctx);
    UIImage *qrImage = [UIImage imageWithCGImage:qrCGImage];
    
    //free memory
    CGContextRelease(ctx);
    CGImageRelease(qrCGImage);
    CGColorSpaceRelease(colorSpace);
    QRcode_free(code);
    
    return qrImage;
}

- (void)drawQRCode:(QRcode *)code context:(CGContextRef)ctx size:(CGFloat)size{
    int margin = 0 ;
    unsigned char *data = code->data;
    int width = code->width;
    int totalWidth = width + margin * 2;
    int imageSize = (int)floorf(size);
    
    //@todo - review float->int stuff
    int pixelSize = imageSize / totalWidth;
    if (imageSize % totalWidth) {
        pixelSize = imageSize / width;
        margin = (imageSize - width * pixelSize) / 2;
    }
    CGRect rectDraw = CGRectMake(0.0f, 0.0f, pixelSize, pixelSize);
    //draw
    CGContextSetFillColor(ctx, CGColorGetComponents([UIColor blackColor].CGColor));
    for (int i = 0 ; i < width; ++i) {
        for (int j = 0 ; j < width; ++j) {
            if (*data & 1) {
                rectDraw.origin = CGPointMake(margin + j * pixelSize, margin + i * pixelSize);
                CGContextAddRect(ctx, rectDraw);
            }
            ++data;
        }
    }
    CGContextFillPath(ctx);
}


@end
