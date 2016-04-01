//
//  LYNavigationController.h
//  lieyu
//
//  Created by pwy on 15/12/15.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYNavigationController : UINavigationController<UINavigationControllerDelegate, UIGestureRecognizerDelegate>


//是否可以滑动返回
@property (nonatomic,assign) BOOL cj_canDragBack;
@end
