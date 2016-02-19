//
//  HDDetailImageCell.h
//  lieyu
//
//  Created by 王婷婷 on 16/2/18.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPImageView.h"
@interface HDDetailImageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet LPImageView *image;
- (void)configureImageView:(NSString *)imageUrl;
@end
