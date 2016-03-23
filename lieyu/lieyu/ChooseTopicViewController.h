//
//  ChooseTopicViewController.h
//  lieyu
//
//  Created by 王婷婷 on 16/3/18.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBaseViewController.h"
typedef void (^ReturnTopicID)(NSString *topicID, NSString *topicName);

@interface ChooseTopicViewController : LYBaseViewController
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *barid;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic, copy) ReturnTopicID returnTopicID;

- (void)returnTopicID:(ReturnTopicID) block;

- (IBAction)cancelClick:(UIButton *)sender;
@end
