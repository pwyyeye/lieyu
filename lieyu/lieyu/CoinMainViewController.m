//
//  CoinMainViewController.m
//  lieyu
//
//  Created by 王婷婷 on 16/3/31.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "CoinMainViewController.h"

@interface CoinMainViewController ()

@end

@implementation CoinMainViewController
- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initView{
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@""]];
    [imageView setFrame:self.view.bounds];
    [self.view addSubview:imageView];
    
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(20, 20, 80, 40)];
    [backButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [backButton setBackgroundColor:[UIColor clearColor]];
    [backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    UIButton *startButton = [[UIButton alloc]initWithFrame:CGRectMake(20, 20, 80, 40)];
    [startButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [startButton setBackgroundColor:[UIColor clearColor]];
    [startButton addTarget:self action:@selector(startClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startButton];
}

- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)startClick{
    
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
