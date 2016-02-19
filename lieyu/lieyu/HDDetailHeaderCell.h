//
//  HDDetailHeaderCell.h
//  lieyu
//
//  Created by 王婷婷 on 16/2/16.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HDDetailHeaderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *environmentLabel;
@property (weak, nonatomic) IBOutlet UILabel *musicLabel;


@property (nonatomic, strong) NSDictionary *dict;
@end
