//
//  ManagerChooseButton.h
//  lieyu
//
//  Created by 王婷婷 on 16/1/25.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ZSDetailModel.h"

@interface ManagerChooseButton : UIButton
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImg;
@property (weak, nonatomic) IBOutlet UILabel *recommond;
@property (weak, nonatomic) IBOutlet UIImageView *star1Img;
@property (weak, nonatomic) IBOutlet UIImageView *star2Img;
@property (weak, nonatomic) IBOutlet UIImageView *star3Img;
@property (weak, nonatomic) IBOutlet UIImageView *star4Img;
@property (weak, nonatomic) IBOutlet UIImageView *star5Img;
@property (weak, nonatomic) IBOutlet UILabel *maskLabel;

@property (nonatomic, strong) NSArray *starsArray;

- (void)configure:(ZSDetailModel *)Model;

@end
