//
//  YaoYiYaoViewController.h
//  lieyu
//
//  Created by 薛斯岐 on 15/10/30.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBaseViewController.h"
#import <AudioToolbox/AudioToolbox.h>
@interface YaoYiYaoViewController : LYBaseViewController{
    SystemSoundID                 soundID;
}
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *botView;
@property (weak, nonatomic) IBOutlet UIView *resultView;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *namelal;
@property (weak, nonatomic) IBOutlet UILabel *delLal;
@property (weak, nonatomic) IBOutlet UILabel *zhiwuLal;
@property (weak, nonatomic) IBOutlet UIButton *detailBtn;
@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;
- (IBAction)queryDetailAct:(UIButton *)sender;

@end
