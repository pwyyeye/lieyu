//
//  StrategyDetailViewController.h
//  lieyu
//
//  Created by 王婷婷 on 16/9/1.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBaseViewController.h"

@interface StrategyDetailViewController : LYBaseViewController

@property(nonatomic, strong) NSString *strategyID;

@property (weak, nonatomic) IBOutlet UIImageView *image_layer;
@property (weak, nonatomic) IBOutlet UIImageView *image_header;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIImageView *likeImage;
@property (weak, nonatomic) IBOutlet UIImageView *commentImage;
@property (weak, nonatomic) IBOutlet UIImageView *collectImage;
@property (weak, nonatomic) IBOutlet UILabel *likeNumber;
@property (weak, nonatomic) IBOutlet UILabel *commentNumber;
@property (weak, nonatomic) IBOutlet UILabel *collectNumber;

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;

- (IBAction)likeButtonClick:(UIButton *)sender;
- (IBAction)commentButtonClick:(UIButton *)sender;
- (IBAction)collectButtonClick:(UIButton *)sender;
- (IBAction)backButtonClick:(UIButton *)sender;
- (IBAction)shareButtonClick:(UIButton *)sender;



@end
