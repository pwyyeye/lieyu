//
//  HeaderTableViewCell.h
//  lieyu
//
//  Created by 王婷婷 on 16/1/31.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YUOrderInfo.h"
#import "YUOrderShareModel.h"

@interface HeaderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *hotTriangle;
@property (weak, nonatomic) IBOutlet UIImageView *avatar_image;
@property (weak, nonatomic) IBOutlet UIButton *avatar_button;
@property (weak, nonatomic) IBOutlet UILabel *name_label;
@property (weak, nonatomic) IBOutlet UIImageView *origanator_image;
@property (weak, nonatomic) IBOutlet UILabel *viewNumber_label;
@property (weak, nonatomic) IBOutlet UILabel *title_label;
@property (weak, nonatomic) IBOutlet UIImageView *view_image;

@property (weak, nonatomic) IBOutlet UIView *backView;

@property (nonatomic, strong) YUOrderInfo *orderInfo;
@property (nonatomic, strong) YUOrderShareModel *YUShare;
@end
