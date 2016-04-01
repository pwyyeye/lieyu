//
//  FingerPlayViewController.m
//  lieyu
//
//  Created by 狼族 on 16/4/1.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "FingerPlayViewController.h"
#import "LYNavigationController.h"
#import <AVFoundation/AVFoundation.h>
#import "FingerAnalyseViewController.h"

@interface FingerPlayViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btn_left;
@property (weak, nonatomic) IBOutlet UIButton *btn_right;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineview_con_top;
@property (weak, nonatomic) IBOutlet UIButton *btn_left_bottom;
@property (weak, nonatomic) IBOutlet UIButton *btn_right_bottom;

@end

@implementation FingerPlayViewController{
    NSTimer *_leftTimer,*_rightTimer;
    NSInteger _leftCount,_rightCount;
    AVAudioPlayer *_player;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    LYNavigationController *nav = (LYNavigationController *)self.navigationController;
    nav.cj_canDragBack = NO;
    _rightCount = 0;
    _leftCount = 0;
    
    _lineView.layer.borderColor = [UIColor yellowColor].CGColor;
    _lineView.layer.borderWidth = 1;
    _lineView.hidden = YES;
    _lineView.layer.cornerRadius = CGRectGetHeight(_lineView.frame)/2.f;
    
    _player = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"finger" ofType:@"mp3"]] error:nil];
    [_player prepareToPlay];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)leftClick:(id)sender {//[myTimer setFireDate:[NSDate distantFuture]];
    NSLog(@"--->");
//    UIButton *btn = (UIButton *)sender;
//    if (btn == _btn_left) {
//        _btn_left_bottom.highlighted = btn.highlighted;
//    }else{
//        _btn_right_bottom.highlighted = btn.highlighted;
//    }
    
    if (_leftTimer == nil) {
        _leftTimer = [NSTimer scheduledTimerWithTimeInterval:0.01f target:self selector:@selector(leftLoop:) userInfo:nil repeats:YES];
        [_leftTimer fire];
    }
       [_leftTimer setFireDate:[NSDate distantPast]];
}
- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)leftLoop:(NSTimer *)timer{
   
    if(_btn_left.highlighted && _btn_right.highlighted){
        _leftCount ++;
    
        if (_leftCount >= 500.f/2.f) {
            _rightCount --;
        }else{
             _rightCount = _leftCount;
        }
        _lineView.hidden = NO;
        _lineview_con_top.constant = _rightCount * 2 / 500.f * CGRectGetHeight(_btn_left.frame) + 190;
        NSLog(@"select");
        [_player play];
    }else{
        NSLog(@"un");
        [_player stop];
        [timer setFireDate:[NSDate distantFuture]];
    }
    
    
    
    if (_leftCount == 500) {
        [_player stop];
//        [self showMessage:@"hahahahhaha"];
        [timer invalidate];
        timer = nil;
        FingerAnalyseViewController *finerAnalyseVC = [[FingerAnalyseViewController alloc]init];
        [self.navigationController pushViewController:finerAnalyseVC animated:YES];
    }
    
//    if (_leftCount == ) {
//
//    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _player = nil;
    
}

- (void)dealloc{
    NSLog(@"---");
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
