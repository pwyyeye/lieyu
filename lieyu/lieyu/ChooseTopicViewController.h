//
//  ChooseTopicViewController.h
//  lieyu
//
//  Created by 王婷婷 on 16/3/18.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBaseViewController.h"

@interface ChooseTopicViewController : LYBaseViewController
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *barid;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

- (IBAction)cancelClick:(UIButton *)sender;
@end
