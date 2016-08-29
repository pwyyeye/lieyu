//
//  RegisterLiveShowView.h
//  lieyu
//
//  Created by 狼族 on 16/8/18.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterLiveShowView : UIView

@property (nonatomic, copy) void(^beginLive)(CGFloat);
@property (weak, nonatomic) IBOutlet UIButton *backButton;

@property (weak, nonatomic) IBOutlet UISlider *beautifySlider;

@property (copy, nonatomic) void(^begainImage)(UIImage *);

@end
