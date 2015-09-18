//
//  KaZuoView.h
//  lieyu
//
//  Created by SEM on 15/9/18.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KaZuoView : UIView
@property (weak, nonatomic) IBOutlet UIButton *NoKaZuoBtn;
@property (weak, nonatomic) IBOutlet UIButton *YesKaZuoBtn;
@property (weak, nonatomic) IBOutlet UIButton *SureBtn;
- (IBAction)noKaZuoAct:(UIButton *)sender;
- (IBAction)YesKaZuoAct:(UIButton *)sender;

@end
