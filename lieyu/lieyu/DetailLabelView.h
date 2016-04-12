//
//  DetailLabelView.h
//  lieyu
//
//  Created by 王婷婷 on 16/4/11.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface DetailLabelView : UIView
@property (weak, nonatomic) IBOutlet UILabel *introduceLbl;
@property (weak, nonatomic) IBOutlet UILabel *numberLbl;
@property (weak, nonatomic) IBOutlet UIView *backGround;

- (void)configureManager:(BOOL)isManager;
- (void)configureNumber:(int)number;
@end
