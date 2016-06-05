//
//  LYChooseBarViewController.h
//  lieyu
//
//  Created by 王婷婷 on 16/5/25.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "LYBaseViewController.h"

@interface LYChooseBarViewController : LYBaseViewController

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeight;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;

- (IBAction)showTable:(UIButton *)sender;
- (IBAction)backForward:(UIButton *)sender;
- (IBAction)submitBar:(UIButton *)sender;

@end
