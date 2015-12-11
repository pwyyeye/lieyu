//
//  LPPlayTogetherViewController.h
//  lieyu
//
//  Created by 王婷婷 on 15/12/1.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PinKeModel.h"
#import "LPAlertView.h"

@interface LPPlayTogetherViewController : UIViewController<LPAlertViewDelegate>

@property (nonatomic, assign)int smid;

@property (nonatomic, strong) PinKeModel *pinKeModel;

@property (weak, nonatomic) IBOutlet UIButton *zixunBtn;
@property (weak, nonatomic) IBOutlet UIButton *zhuyiBtn;
@property (weak, nonatomic) IBOutlet UIButton *buyBtn;

@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)ZiXunLieyu:(UIButton *)sender;
- (IBAction)ZhuYiShixiang:(UIButton *)sender;
- (IBAction)BuyNow:(UIButton *)sender;
- (IBAction)LikeClick:(UIButton *)sender;
- (IBAction)ShareClick:(UIButton *)sender;



@end
