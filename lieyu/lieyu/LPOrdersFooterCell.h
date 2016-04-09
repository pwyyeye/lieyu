//
//  LPOrdersFooterCell.h
//  lieyu
//
//  Created by 王婷婷 on 16/4/7.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LPOrdersFooterCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *backGround;
@property (weak, nonatomic) IBOutlet UILabel *shaperLbl;
@property (weak, nonatomic) IBOutlet UILabel *acturePriceLbl;
@property (weak, nonatomic) IBOutlet UILabel *profitStatusLbl;
@property (weak, nonatomic) IBOutlet UILabel *profitLbl;

@property (weak, nonatomic) IBOutlet UIButton *firstButton;
@property (weak, nonatomic) IBOutlet UIButton *secondButton;

@end
