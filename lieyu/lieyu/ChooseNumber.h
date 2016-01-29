//
//  ChooseNumber.h
//  lieyu
//
//  Created by 王婷婷 on 15/12/8.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseNumber : UIView

@property (nonatomic, assign) int store;

@property (weak, nonatomic) IBOutlet UIButton *lessBtn;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

- (IBAction)lessBtnClick:(UIButton *)sender;
- (IBAction)addBtnClick:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UITextField *numberField;

@end
