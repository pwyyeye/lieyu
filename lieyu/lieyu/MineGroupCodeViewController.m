//
//  MineGroupCodeViewController.m
//  lieyu
//
//  Created by 王婷婷 on 16/8/17.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "MineGroupCodeViewController.h"
#import "qrencode.h"
#import "LYUserHttpTool.h"

@interface MineGroupCodeViewController ()

@property (nonatomic, assign) CGFloat imageWidth;
@property (nonatomic, strong) NSString *codeString;

@end

@implementation MineGroupCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"分享二维码";
    
    [self getData];
}

- (void)getData{
    //获取完字符串之后操作
    [LYUserHttpTool lyGetYukebangQRCodeWithParams:nil complete:^(NSString *result) {
        if (![MyUtil isEmptyString:result]) {
            _imageWidth = SCREEN_HEIGHT / 2 - 150;
            _codeString = result;
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _imageWidth, _imageWidth)];
            imageView.layer.cornerRadius = 6;
            imageView.layer.masksToBounds = YES;
            imageView.backgroundColor = RGBA(242, 242, 242, 1);
            imageView.image = [self qrImageForString:_codeString imageSize:_imageWidth];
            [self.codeView addSubview:imageView];
        }else{
            [MyUtil showPlaceMessage:@"二维码为空，请稍后重试！"];
        }
    }];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 下载图片
- (IBAction)downloadQRCode:(UIButton *)sender {
    CGFloat width = _imageWidth * sender.tag;
    UIImage *QRCode = [self qrImageForString:_codeString imageSize:width];
    UIImageWriteToSavedPhotosAlbum(QRCode, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
}

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (!error) {
        [MyUtil showPlaceMessage:@"下载成功！请进入相册查看"];
    }else{
        [MyUtil showPlaceMessage:@"下载失败，请稍后重试！"];
    }
}

@end
