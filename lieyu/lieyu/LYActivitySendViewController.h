//
//  LYActivitySendViewController.h
//  lieyu
//
//  Created by 狼族 on 16/4/23.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBaseViewController.h"

@protocol LYActivitySendViewControllerDelegate <NSObject>

- (void)activitySendViewControllerSendFinish;

@end

@interface LYActivitySendViewController : LYBaseViewController
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btnArray;
@property (nonatomic,unsafe_unretained) id<LYActivitySendViewControllerDelegate> delegate;
@end
