//
//  BitianTableViewCell.h
//  lieyu
//
//  Created by 王婷婷 on 15/12/1.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BitianTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *chooseTime;
@property (weak, nonatomic) IBOutlet UIButton *chooseWay;
@property (weak, nonatomic) IBOutlet UIButton *lessBtn;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UITextField *numTextField;

@end
