//
//  FreeOrderViewController.h
//  lieyu
//
//  Created by 狼族 on 16/5/30.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBaseViewController.h"

@interface FreeOrderViewController : LYBaseViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)submitClick:(UIButton *)sender;

@property (nonatomic, strong) NSString *userID;

@property (nonatomic, strong) NSDictionary *barDict;
@property (nonatomic, strong) NSDictionary *userDict;

@end
