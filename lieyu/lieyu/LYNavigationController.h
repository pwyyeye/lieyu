//
//  LYNavigationController.h
//  lieyu
//
//  Created by pwy on 15/12/15.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYNavigationController : UINavigationController
@property (nonatomic,strong) UIVisualEffectView *navBar;
@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *percentDrivenInteractiveTransition;
@end
