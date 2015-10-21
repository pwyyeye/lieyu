//
//  DWnumCell.h
//  lieyu
//
//  Created by 薛斯岐 on 15/10/21.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DWnumCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *numLal;
- (IBAction)jiaAct:(UIButton *)sender;
- (IBAction)jianAct:(UIButton *)sender;
@end
