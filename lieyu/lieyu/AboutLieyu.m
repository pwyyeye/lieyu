//
//  AboutLieyu.m
//  lieyu
//
//  Created by pwy on 15/10/31.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "AboutLieyu.h"

@interface AboutLieyu ()

@end

@implementation AboutLieyu

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title=@"关于猎娱";
    _version.text=[NSString stringWithFormat:@"版本号 V%@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
    if([[MyUtil deviceString] isEqualToString:@"iPhone 6 Plus"]){
        self.commonIconHead.constant = 80;
    }
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
