//
//  UserCenterCell.h
//  lieyu
//
//  Created by pwy on 15/11/29.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYUserCenterCell : UICollectionViewCell


@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UIButton *btn_count;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labeltext_cons_center;

@property (weak, nonatomic) IBOutlet UILabel *text;

@property (nonatomic,strong) CALayer *layerShadowBottom;

@property (nonatomic,strong) CALayer *layerShadowRight;

@end
