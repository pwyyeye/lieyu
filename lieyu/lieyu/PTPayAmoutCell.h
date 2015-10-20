//
//  PTPayAmoutCell.h
//  lieyu
//
//  Created by 薛斯岐 on 15/10/17.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PTPayAmoutCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *payAmountTex;
@property (weak, nonatomic) IBOutlet UIButton *flBtn;
- (IBAction)exitEdit:(UITextField *)sender;

@end
