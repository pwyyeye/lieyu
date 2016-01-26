//
//  ManagersView.h
//  lieyu
//
//  Created by 王婷婷 on 16/1/25.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ManagerChooseButton.h"

@protocol ChooseManage<NSObject>

- (void)chooseManagerDone:(ManagerChooseButton *)button;

@end

@interface ManagersView : UIView

@property (nonatomic, strong) NSArray *managersArray;
@property (nonatomic, strong) NSMutableArray *buttonsArray;
@property (nonatomic, assign) id<ChooseManage> delegate;


- (void)configure:(NSArray *)managerList;
@end
