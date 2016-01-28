//
//  ZujuViewController.h
//  lieyu
//
//  Created by 王婷婷 on 16/1/28.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "preview.h"
#import "DetailView.h"
#import "MenuHrizontal.h"
#import "ManagersView.h"

@interface ZujuViewController : UIViewController<showImageInPreview,MenuHrizontalDelegate,ChooseManage>
{
    MenuHrizontal *mMenuHriZontal;
    NSMutableArray *weekDateArr;
    NSString *datePar;
}
@property (weak, nonatomic) IBOutlet UIView *menuView;
@property (weak, nonatomic) IBOutlet UIView *termView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *numberLbl;
@property (weak, nonatomic) IBOutlet UILabel *moneyLbl;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;


@property (nonatomic, strong) preview *subView;

@property (nonatomic, assign) int barid;
@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *endTime;
@end
