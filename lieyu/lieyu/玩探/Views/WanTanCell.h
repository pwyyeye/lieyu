//
//  WanTanCell.h
//  lieyu
//
//  Created by 狼族 on 16/8/29.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WanTanCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *tagIamgeView;

@property (weak, nonatomic) IBOutlet UILabel *tagLabel;

@property (weak, nonatomic) IBOutlet UIImageView *redTiPot;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UIImageView *smallTip;


-(void) setIamge:(UIImage *) image andLabel:(NSString *)text;

@end
