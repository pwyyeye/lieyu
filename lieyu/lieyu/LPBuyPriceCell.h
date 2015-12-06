//
//  LPBuyPriceCell.h
//  lieyu
//
//  Created by 王婷婷 on 15/12/2.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LPBuyPriceCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *LPMoney;
@property (weak, nonatomic) IBOutlet UIButton *LPProfit;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;

- (void)cellConfigureWithPay:(NSString *)pay andProfit:(CGFloat)profit;

@end
