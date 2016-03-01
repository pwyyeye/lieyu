//
//  ChoosePeople.h
//  lieyu
//
//  Created by 王婷婷 on 16/1/29.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChoosePeople : UIView

@property (nonatomic, assign) int store;

@property (weak, nonatomic) IBOutlet UIButton *lessBtn;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UITextField *numberField;

- (IBAction)lessBtnClick:(UIButton *)sender;
- (IBAction)addBtnClick:(UIButton *)sender;


- (void)configure:(int)defaultNum;




@end
