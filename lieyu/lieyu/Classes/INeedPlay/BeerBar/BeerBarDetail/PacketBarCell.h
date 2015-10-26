//
//  PacketBarCell.h
//  lieyu
//
//  Created by newfly on 9/20/15.
//  Copyright © 2015 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PacketBarCell : UITableViewCell<LYTableViewCellLayout>

@property(nonatomic,weak)IBOutlet UILabel * labFanli;
@property(nonatomic,weak)IBOutlet UIImageView * photoImage;
@property(nonatomic,weak)IBOutlet UILabel * labBuyerDetail;
@property(nonatomic,weak)IBOutlet UILabel * labCost;
@property(nonatomic,weak)IBOutlet UILabel * labCostDel;
@property(nonatomic,weak)IBOutlet UILabel * labTitle;
@property (weak, nonatomic) IBOutlet UIButton *flBtn;

@end
