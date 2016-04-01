//
//  CoinPlayViewController.m
//  lieyu
//
//  Created by 王婷婷 on 16/3/31.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "CoinPlayViewController.h"

@interface CoinPlayViewController ()
@property (nonatomic, strong) UIImageView *imageCoin;
@end

@implementation CoinPlayViewController
//- (BOOL)prefersStatusBarHidden{
//    return YES;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication]setStatusBarHidden:YES withAnimation:NO];
    UIButton *button = [[UIButton alloc]init];
    [button setBackgroundColor:[UIColor brownColor]];
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
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
    [self.view addSubview:imageView];
    
    [self.view addSubview:button];
//    [self.view bringSubviewToFront:button];
//    [self.view setBackgroundColor:[UIColor grayColor]];
}

- (void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)logtouchInfo:(UITouch *)touch{
    CGPoint locInSelf = [touch locationInView:self.view];
//    CGPoint locInWin = [touch locationInView:nil];
    NSLog(@"    touch.locationInView = {%2.3f, %2.3f}", locInSelf.x, locInSelf.y);
    if (SCREEN_WIDTH == 414 && SCREEN_HEIGHT == 736) {
        [_imageCoin setFrame:CGRectMake(locInSelf.x - 64, locInSelf.y - 64, 128, 128)];
        
    }else{
        [_imageCoin setFrame:CGRectMake(locInSelf.x - 70, locInSelf.y - 70, 140, 140)];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    CGPoint *point = [touches locatio]
//    NSLog(@"%@---%@",touches.)
    
    _imageCoin = [[UIImageView alloc]initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"coinPlay" ofType:@"png"]]];
    [self.view addSubview:_imageCoin];
    
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
    [_imageCoin removeFromSuperview];
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

@end
