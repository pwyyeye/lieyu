//
//  LYBarDescTitleTableViewCell.h
//  lieyu
//
//  Created by 狼族 on 15/11/29.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYBarDescTitleTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *label_descr;
@property (weak, nonatomic) IBOutlet UIImageView *image_yinHao_left;
@property (weak, nonatomic) IBOutlet UIImageView *image_yinHao_right;
- (void)configneCellWith:(NSString *)title;


@end
