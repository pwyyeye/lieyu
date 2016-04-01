//
//  CoinPlayViewController.m
//  lieyu
//
//  Created by 王婷婷 on 16/3/31.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "CoinPlayViewController.h"

@interface CoinPlayViewController (){
    double locX;
    double locY;
    BOOL isEnd;
}
@property (nonatomic, strong) UIImageView *imageCoin;
@end

@implementation CoinPlayViewController
//- (BOOL)prefersStatusBarHidden{
//    return YES;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *button = [[UIButton alloc]init];
    [button setBackgroundColor:[UIColor clearColor]];
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:imageView];
    if (SCREEN_WIDTH == 320 && SCREEN_HEIGHT == 480) {
        [imageView setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"coinBack4" ofType:@"jpg"]]];
        [button setFrame:CGRectMake(12, 32, 61, 61)];
        
    }else{
        [imageView setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"coinBack5" ofType:@"jpg"]]];
        if (SCREEN_WIDTH == 320 && SCREEN_HEIGHT == 568) {
            [button setFrame:CGRectMake(27, 32, 47, 47)];
        }else if (SCREEN_WIDTH == 375 && SCREEN_HEIGHT == 667){
            [button setFrame:CGRectMake(32, 37, 55, 55)];
        }else if (SCREEN_WIDTH == 414 && SCREEN_HEIGHT == 736){
            [button setFrame:CGRectMake(34, 40, 65, 65)];
        }
    }
    
    [self.view addSubview:button];
//    [self.view bringSubviewToFront:button];
//    [self.view setBackgroundColor:[UIColor grayColor]];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication]setStatusBarHidden:YES withAnimation:NO];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication]setStatusBarHidden:NO withAnimation:NO];
}

- (void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)logtouchInfo:(UITouch *)touch{
    CGPoint locInSelf = [touch locationInView:self.view];
//    CGPoint locInWin = [touch locationInView:nil];
    NSLog(@"    touch.locationInView = {%2.3f, %2.3f}", locInSelf.x, locInSelf.y);
    locX = locInSelf.x;
    locY = locInSelf.y;
    
    if (SCREEN_WIDTH == 414 && SCREEN_HEIGHT == 736) {
        [_imageCoin setFrame:CGRectMake(locInSelf.x - 64, locInSelf.y - 64, 128, 128)];
        
    }else{
        [_imageCoin setFrame:CGRectMake(locInSelf.x - 70, locInSelf.y - 70, 140, 140)];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    CGPoint *point = [touches locatio]
//    NSLog(@"%@---%@",touches.)
    
    if (!_imageCoin) {
        _imageCoin = [[UIImageView alloc]initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"coinPlay" ofType:@"png"]]];
        [self.view addSubview:_imageCoin];
    }
    
    for (UITouch *touch in event.allTouches) {
        [self logtouchInfo:touch];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    for (UITouch *touch in event.allTouches) {
        [self logtouchInfo:touch];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    isEnd = YES;
    if (isEnd == YES && (locX <= 20 || locX >= SCREEN_WIDTH - 20 || locY <= 20 || locY >= SCREEN_HEIGHT - 20) ) {
        [_imageCoin removeFromSuperview];
        _imageCoin = nil;
    }
}

- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
    
}



@end
