//
//  HomePageINeedPlayViewController.h
//  lieyu
//
//  Created by newfly on 9/14/15.
//  Copyright (c) 2015 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LYBaseViewController.h"
#import "HomePageEntryConstant.h"
#import "EScrollerView.h"
#import "LYAlert.h"
#import "CityChooseButton.h"


@interface HomePageINeedPlayViewController : LYBaseViewController<UINavigationControllerDelegate,LYChooseCityDelegate>

@property (weak, nonatomic) IBOutlet UIButton *cityBtn;

@property(strong,nonatomic) LYAlert *alertView;


@end
