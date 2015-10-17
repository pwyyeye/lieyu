//
//  PTTypeChooseCell.h
//  lieyu
//
//  Created by 薛斯岐 on 15/10/17.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
// "pinkertype":"0"// 0、请客 1、AA付款 2、自由付款 （发起人自由 其他AA）

#import <UIKit/UIKit.h>

@interface PTTypeChooseCell : UITableViewCell<LYTableViewCellLayout>
{
    NSString *pinkertype;
}
@property (weak, nonatomic) IBOutlet UIButton *payAllBtn;
@property (weak, nonatomic) IBOutlet UIButton *aaBtn;
@property (weak, nonatomic) IBOutlet UIButton *freePayBtn;
- (IBAction)typeChooseAct:(UIButton *)sender;

@end
