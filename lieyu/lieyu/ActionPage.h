//
//  ActionPage.h
//  lieyu
//
//  Created by 王婷婷 on 16/2/16.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBaseViewController.h"

@interface ActionPage : LYBaseViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSString *topicid;
@property (nonatomic, strong) UIImage *ActionImage;
@end
