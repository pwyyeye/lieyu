//
//  LyZSuploadIdCardViewController.h
//  lieyu
//
//  Created by 薛斯岐 on 15/9/25.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBaseViewController.h"
#import "LYZSeditView.h"
@interface LyZSuploadIdCardViewController : LYBaseViewController{
    LYZSeditView *seditView;
    UIView  *_bgView;
    int picTag;
    UIImage *idcard_zhengmian;
    UIImage *idcard_fanmian;
    
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgHeaderConstrant;

- (IBAction)nextAct:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *zmAddBtn;
@property (weak, nonatomic) IBOutlet UIButton *fmAddBtn;
@property (nonatomic, retain)  NSDictionary *paramdic;
- (IBAction)addPictures:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *nextStepBtn;
@property (weak, nonatomic) IBOutlet UIImageView *imgQianmian;
@property (weak, nonatomic) IBOutlet UIImageView *imgHoumian;

@end
