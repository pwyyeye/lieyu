//
//  CoinMainViewController.m
//  lieyu
//
//  Created by 王婷婷 on 16/3/31.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "CoinMainViewController.h"
#import "CoinPlayViewController.h"
@interface CoinMainViewController ()

@end

@implementation CoinMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)initView{
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"coinBackground"]];
    [imageView setContentMode:UIViewContentModeScaleAspectFill];
    [imageView setFrame:self.view.bounds];
    [self.view addSubview:imageView];
    
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 20, 80, 40)];
    [backButton setImage:[UIImage imageNamed:@"CoinBack"] forState:UIControlStateNormal];
    [backButton setBackgroundColor:[UIColor clearColor]];
    [backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    UIButton *startButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 16, SCREEN_HEIGHT / 19 * 12, SCREEN_WIDTH / 8 * 7, SCREEN_HEIGHT / 19 * 6)];
    [startButton setImage:[UIImage imageNamed:@"CoinStart"] forState:UIControlStateNormal];
    [startButton setBackgroundColor:[UIColor clearColor]];
    [startButton addTarget:self action:@selector(startClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startButton];
    
    if(SCREEN_WIDTH == 320 && SCREEN_HEIGHT == 480){
        [backButton setFrame:CGRectMake(0, 20, 80, 40)];
        [startButton setFrame:CGRectMake(SCREEN_WIDTH / 16, SCREEN_HEIGHT / 19 * 13, SCREEN_WIDTH / 8 * 7, SCREEN_HEIGHT / 19 * 6)];
    }
}

- (void)backClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)startClick{
    CoinPlayViewController *coinPlayVC = [[CoinPlayViewController alloc]init];
    [self presentViewController:coinPlayVC animated:YES completion:nil];
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
