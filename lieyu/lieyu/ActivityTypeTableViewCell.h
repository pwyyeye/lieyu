//
//  ActivityTypeTableViewCell.h
//  lieyu
//
//  Created by 王婷婷 on 16/9/3.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityTypeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *partyButton;
@property (weak, nonatomic) IBOutlet UIButton *barActivityButton;
@property (weak, nonatomic) IBOutlet UILabel *partyLabel;
@property (weak, nonatomic) IBOutlet UILabel *barActivityLabel;
@property (weak, nonatomic) IBOutlet UILabel *partyText;
@property (weak, nonatomic) IBOutlet UILabel *barText;
@property (weak, nonatomic) IBOutlet UIView *shadowView;

@end
