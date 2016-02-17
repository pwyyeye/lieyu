//
//  HomeNewPageINeedPlayViewController.h
//  lieyu
//
//  Created by 狼族 on 16/2/16.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LYBaseViewController.h"
#import "HomePageEntryConstant.h"
#import "EScrollerView.h"
#import "LYAlert.h"
#import "CityChooseButton.h"

@interface HomeNewPageINeedPlayViewController : LYBaseViewController<UINavigationControllerDelegate,LYChooseCityDelegate>
@property(strong,nonatomic) LYAlert *alertView;
@end
