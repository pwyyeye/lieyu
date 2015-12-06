//
//  LYUserDetailTableViewCell.h
//  lieyu
//
//  Created by 狼族 on 15/12/6.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYUserDetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *label_title;
@property (weak, nonatomic) IBOutlet UIImageView *image_arrow;
@property (weak, nonatomic) IBOutlet UITextField *textF_content;

@end
