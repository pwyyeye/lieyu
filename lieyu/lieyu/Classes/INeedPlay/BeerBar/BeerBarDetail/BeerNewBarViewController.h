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
#import "LYBaseViewController.h"
@interface BeerNewBarViewController : LYBaseViewController
<
UITableViewDelegate,
UITableViewDataSource,
NeedHideNavigationBar
>

@property (weak, nonatomic) IBOutlet UIView *view_bottom;
@property (weak, nonatomic) IBOutlet UIButton *btnShare;

@property (weak, nonatomic) IBOutlet UIButton *btn_collect;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property(nonatomic,strong)NSNumber * beerBarId;
- (IBAction)dianweiAct:(UIButton *)sender;
- (IBAction)chiHeAct:(UIButton *)sender;
- (IBAction)zsliAct:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttomViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableView_Height;

@property(strong,nonatomic) UIWebView *phoneCallWebView;

- (IBAction)groupChatButtonAction:(UIButton *)sender;


@end
