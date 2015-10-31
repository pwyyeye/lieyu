//
//  PlayTogetherViewController.h
//  lieyu
//
//  Created by newfly on 9/19/15.
//  Copyright (c) 2015 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LYBaseViewController.h"

@interface PlayTogetherViewController : LYBaseViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(strong,nonatomic) UILabel *myTitle;

- (IBAction)allListAct:(UIButton *)sender;

- (IBAction)nearDistanceAct:(UIButton *)sender;

@end
