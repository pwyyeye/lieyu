//
//  LYBarDescTableViewCell.h
//  lieyu
//
//  Created by 狼族 on 15/12/9.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYBarDescTableViewCell : UITableViewCell
@property (strong, nonatomic)  UILabel *label_descr;
@property (strong, nonatomic)  UIImageView *image_yinHao_left;
@property (strong, nonatomic)  UIImageView *image_yinHao_right;
@property (nonatomic,copy) NSString *title;

@end
