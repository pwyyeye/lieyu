//
//  FindGameCenterCollectionViewCell.h
//  lieyu
//
//  Created by 狼族 on 16/3/7.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FindGameCenterCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *label_title;
@property (nonatomic,strong) UIView *lineView_right;
@property (nonatomic,strong) UIView *lineView_bottom;
@end
