//
//  LPBuyTaocanCell.h
//  lieyu
//
//  Created by 王婷婷 on 15/12/2.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LPBuyTaocanCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *LPimage;
@property (weak, nonatomic) IBOutlet UILabel *LPName;
@property (weak, nonatomic) IBOutlet UILabel *LPway;
@property (weak, nonatomic) IBOutlet UILabel *LPprice;
@property (weak, nonatomic) IBOutlet UILabel *LPmarketPrice;

- (void)cellConfigureWithImage:(NSString *)imageUrl name:(NSString *)name way:(NSString *)way price:(NSString *)price marketPrice:(NSString *)marketPrice;

@end
