//
//  ZSReleaseGoodViewController.h
//  lieyu
//
//  Created by 薛斯岐 on 15/9/22.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBaseViewController.h"
#import "LYZSeditView.h"
#import "UzysAssetsPickerController.h"
@interface ZSReleaseGoodViewController : LYBaseViewController{
    NSMutableArray *chanPinDelList;
    NSMutableArray *biaoQianList;
    LYZSeditView *seditView;
    UIView  *_bgView;
    NSMutableArray *keyArr;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)sureAct:(UIButton *)sender;

@end
