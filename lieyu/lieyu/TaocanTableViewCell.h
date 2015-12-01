//
//  TaocanTableViewCell.h
//  lieyu
//
//  Created by 王婷婷 on 15/12/1.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaocanTableViewCell : UITableViewCell

@property (nonatomic, strong) NSDictionary *dict;
@property (weak, nonatomic) IBOutlet UILabel *TaocanInfo;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;
@property (weak, nonatomic) IBOutlet UILabel *marketPrice;
@property (weak, nonatomic) IBOutlet UILabel *profit;


@end
