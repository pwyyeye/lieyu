//
//  BeerBarDetailViewController.h
//  lieyu
//
//  Created by newfly on 9/19/15.
//  Copyright © 2015 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NeedHideNavigationBar.h"
#import "EScrollerView.h"
@interface BeerBarDetailViewController : UIViewController
<
    UITableViewDelegate,
    UITableViewDataSource,
    NeedHideNavigationBar
>

@property(nonatomic,strong)NSNumber * beerBarId;
- (IBAction)dianweiAct:(UIButton *)sender;
- (IBAction)chiHeAct:(UIButton *)sender;
- (IBAction)zsliAct:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttomViewHeight;

@end
