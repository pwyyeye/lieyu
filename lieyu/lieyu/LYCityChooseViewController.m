//
//  LYCityChooseViewController.m
//  lieyu
//
//  Created by 狼族 on 15/11/28.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYCityChooseViewController.h"
#define ADDRESSPAGE_MTA @"ADDRESSPAGE"
#define ADDRESSPAGE_TIMEEVENT_MTA @"ADDRESSPAGE_TIMEEVENT"


@interface LYCityChooseViewController ()

@end

@implementation LYCityChooseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"地址";
    UIBarButtonItem *item=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return"] style:UIBarButtonItemStylePlain target:self action:@selector(gotoBack)];
    [self.navigationItem setLeftBarButtonItem:item];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)gotoBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)cityClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    [MTA trackCustomEvent:LYCLICK_MTA args:@[@"cityChoose"]];
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
