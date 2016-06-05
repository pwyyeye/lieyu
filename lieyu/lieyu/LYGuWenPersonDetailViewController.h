//
//  LYGuWenPersonDetailViewController.h
//  lieyu
//
//  Created by 狼族 on 16/5/26.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBaseViewController.h"

@interface LYGuWenPersonDetailViewController : LYBaseViewController
- (IBAction)backClick:(UIButton *)sender;
- (IBAction)onlinebookClick:(UIButton *)sender;
- (IBAction)freebookClick:(UIButton *)sender;
- (IBAction)checkBigAvatar:(UIButton *)sender;
- (IBAction)AddCare:(UIButton *)sender;
- (IBAction)checkCares:(UIButton *)sender;
- (IBAction)checkTrends:(UIButton *)sender;
- (IBAction)chatWithManager:(UIButton *)sender;


@property (weak, nonatomic) IBOutlet UIImageView *avatar_BG;
@property (weak, nonatomic) IBOutlet UIImageView *avatar_image;
@property (weak, nonatomic) IBOutlet UILabel *usernick_label;
@property (weak, nonatomic) IBOutlet UIImageView *sex_image;
@property (weak, nonatomic) IBOutlet UILabel *xingzuo_label;
@property (weak, nonatomic) IBOutlet UILabel *job_label;
@property (weak, nonatomic) IBOutlet UILabel *popularity_label;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *identification_buttons;
@property (weak, nonatomic) IBOutlet UILabel *barname_label;
@property (weak, nonatomic) IBOutlet UILabel *address_label;
@property (weak, nonatomic) IBOutlet UILabel *beCaredNum_label;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *trend_images;

@end
