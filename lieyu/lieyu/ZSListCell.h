//
//  ZSListCell.h
//  lieyu
//
//  Created by 薛斯岐 on 15/9/19.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZSListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UIImageView *CoutentImageView;
@property (weak, nonatomic) IBOutlet UIImageView *mesImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *delLal;
@property (weak, nonatomic) IBOutlet UIImageView *disImageView;
@end
