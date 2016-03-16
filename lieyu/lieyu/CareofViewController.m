//
//  CareofViewController.m
//  lieyu
//
//  Created by 王婷婷 on 16/3/15.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "CareofViewController.h"
#import "LYUserHttpTool.h"

@interface CareofViewController ()

@end

@implementation CareofViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if([_type isEqualToString:@"1"]){
        self.title = @"粉丝";
    }else if ([_type isEqualToString:@"0"]){
        self.title = @"关注的人";
    }
    [self getData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)getData{
    NSDictionary *dict = @{@"userId":_userId,
                           @"type":_type};
    [LYUserHttpTool getCaresOrFansList:dict complete:^(NSMutableArray *dataList) {
        NSLog(@"%@",dataList);
    }];
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
