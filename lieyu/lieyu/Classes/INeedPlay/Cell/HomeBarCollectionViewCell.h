//
//  HomeBarCollectionViewCell.h
//  lieyu
//
//  Created by 狼族 on 16/1/25.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JiuBaModel;

@interface HomeBarCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIView *view_line_distance;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *label_disstance_left_cons;
@property (weak, nonatomic) IBOutlet UIImageView *imgView_bg;
@property (weak, nonatomic) IBOutlet UILabel *label_barDescr;
@property (weak, nonatomic) IBOutlet UILabel *label_address;
@property (weak, nonatomic) IBOutlet UILabel *label_barName;
@property (weak, nonatomic) IBOutlet UILabel *label_price;
@property (weak, nonatomic) IBOutlet UILabel *label_fanli;
@property (weak, nonatomic) IBOutlet UILabel *label_collect;
@property (weak, nonatomic) IBOutlet UIView *shadowView;

@property (weak, nonatomic) IBOutlet UILabel *label_distance;
@property (weak, nonatomic) IBOutlet UILabel *label_zang;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view_cont_one_width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view_cons_width;
@property (strong, nonatomic)  UIVisualEffectView *bulrView;
@property (weak, nonatomic) IBOutlet UILabel *label_yu;
@property (weak, nonatomic) IBOutlet UIView *view_withFanli;
@property (nonatomic,strong) JiuBaModel *jiuBaM;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *label_fanli_right_const;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view_fanli_right_const;


@end
