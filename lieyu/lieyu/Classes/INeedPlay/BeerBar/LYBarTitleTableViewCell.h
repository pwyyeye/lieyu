//
//  LYBarTitleTableViewCell.h
//  lieyu
//
//  Created by 狼族 on 15/11/29.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HCSStarRatingView.h>
@interface LYBarTitleTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView_header;
@property (weak, nonatomic) IBOutlet UILabel *label_name;
@property (weak, nonatomic) IBOutlet UIImageView *imageView_rectRight;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *imageView_starArray;
@property (weak, nonatomic) IBOutlet UILabel *label_price;
@property (weak, nonatomic) IBOutlet UILabel *label_line;
@property (weak, nonatomic) IBOutlet UILabel *label_fanli_num;

@property (weak, nonatomic) IBOutlet HCSStarRatingView *barStar;
@end
