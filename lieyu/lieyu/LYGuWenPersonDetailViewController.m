//
//  LYGuWenPersonDetailViewController.m
//  lieyu
//
//  Created by 狼族 on 16/5/26.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYGuWenPersonDetailViewController.h"
#import "FreeOrderViewController.h"
#import "IQKeyboardManager.h"
#import "LYAdviserInfoModel.h"
#import "LYAdviserHttpTool.h"

@interface LYGuWenPersonDetailViewController ()

@property (nonatomic, strong) LYAdviserInfoModel *adviserModel;

@end

@implementation LYGuWenPersonDetailViewController

- (void)loadView{
    NSLog(@"dfasdfasd");
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self getData];
}

- (void)getData{
    //    NSDictionary *dict = @{@"userid":_userID};
    NSDictionary *dict = @{@"userid":@"130616"};
    __weak __typeof(self)weakSelf = self;
    [LYAdviserHttpTool lyGetManagerInfoWithParams:dict complete:^(LYAdviserInfoModel *adviserModel) {
        weakSelf.adviserModel = adviserModel;
//        [weakSelf.tableView reloadData];
        [weakSelf reloadData];
    }];
}

- (void)reloadData{
    [_avatar_BG sd_setImageWithURL:[NSURL URLWithString:_adviserModel.avatar_img] placeholderImage:[UIImage imageNamed:@""]];
    [_avatar_image sd_setImageWithURL:[NSURL URLWithString:_adviserModel.avatar_img] placeholderImage:[UIImage imageNamed:@""]];
    _avatar_image.layer.cornerRadius = _avatar_image.frame.size.width / 2 ;
    _avatar_image.layer.masksToBounds = YES;
    _avatar_image.contentMode = UIViewContentModeScaleAspectFill;
    [_usernick_label setText:_adviserModel.usernick];
    if (_adviserModel.gender == 0) {
        //man
        [_sex_image setImage:[UIImage imageNamed:@"woman"]];
    }else if (_adviserModel.gender == 1){
        [_sex_image setImage:[UIImage imageNamed:@"manIcon"]];
    }
    NSString *birth = [_adviserModel.birthday substringToIndex:10];
    [_xingzuo_label setText:[MyUtil getAstroWithBirthday:birth]];
    [_job_label setText:[[_adviserModel.tags objectAtIndex:0] objectForKey:@"tagname"]];
    [_beCaredNum_label setText:[NSString stringWithFormat:@"%d",_adviserModel.beCollectNum]];
    [_popularity_label setText:[NSString stringWithFormat:@"人气 %d",_adviserModel.popularityNum]];
    [_barname_label setText:_adviserModel.barname];
    [_address_label setText:_adviserModel.address];
    for (int i = 0 ; i < 4 ; i ++) {
        UIImageView *imageView = [_trend_images objectAtIndex:i];
        [imageView sd_setImageWithURL:[NSURL URLWithString:[_adviserModel.recentImages objectAtIndex:0]] placeholderImage:[UIImage imageNamed:@""]];
    }
}

- (IBAction)backClick:(UIButton *)sender {
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].isAdd = NO;
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)onlinebookClick:(UIButton *)sender {
}

- (IBAction)freebookClick:(UIButton *)sender {
    FreeOrderViewController *freeOrderVC = [[FreeOrderViewController alloc]initWithNibName:@"FreeOrderViewController" bundle:nil];
    [self.navigationController pushViewController:freeOrderVC animated:YES];
}

- (IBAction)checkBigAvatar:(UIButton *)sender {
}

- (IBAction)AddCare:(UIButton *)sender {
}

- (IBAction)checkCares:(UIButton *)sender {
}

- (IBAction)checkTrends:(UIButton *)sender {
}

- (IBAction)chatWithManager:(UIButton *)sender {
}
@end
