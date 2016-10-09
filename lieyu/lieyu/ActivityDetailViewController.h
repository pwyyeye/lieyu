//
//  ActivityDetailViewController.h
//  lieyu
//
//  Created by 王婷婷 on 16/9/3.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBaseViewController.h"

@interface ActivityDetailViewController : LYBaseViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *image_layer;
@property (weak, nonatomic) IBOutlet UIImageView *image_header;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *bottomView;

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;

- (IBAction)buyTicketClick:(UIButton *)sender;
- (IBAction)backButtonClick:(UIButton *)sender;
- (IBAction)shareButtonClick:(UIButton *)sender;

@property (nonatomic, strong) NSString *activityID ;

@end
