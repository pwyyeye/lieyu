//
//  HomePageCollectionViewCell.h
//  lieyu
//
//  Created by 王婷婷 on 16/8/29.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JiuBaModel.h"

@interface HomePageCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *barImage;
@property (weak, nonatomic) IBOutlet UILabel *barNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *barDescLabel;
@property (weak, nonatomic) IBOutlet UILabel *barAddressLabel;

@property (nonatomic, strong) JiuBaModel *model;

@end
