//
//  LPBuyInfoCell.h
//  lieyu
//
//  Created by 王婷婷 on 15/12/2.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LPBuyInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *LPBarName;
@property (weak, nonatomic) IBOutlet UILabel *LPAddress;
@property (weak, nonatomic) IBOutlet UILabel *LPTime;
@property (weak, nonatomic) IBOutlet UILabel *LPNumber;

- (void)cellConfigureWithName:(NSString *)name Address:(NSString *)address Time:(NSString *)time Number:(NSString *)number;
@end
