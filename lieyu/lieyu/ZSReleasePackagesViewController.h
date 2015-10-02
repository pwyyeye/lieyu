//
//  ZSReleasePackagesViewController.h
//  lieyu
//
//  Created by SEM on 15/9/21.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBaseViewController.h"
#import "LYZSeditView.h"
#import "UzysAssetsPickerController.h"
@protocol ZSAddTaoCanDelegate<NSObject>
- (void)addTaoCan;

@end
@interface ZSReleasePackagesViewController : LYBaseViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UzysAssetsPickerControllerDelegate>
{
    NSMutableArray *taocanDelList;
    NSString *fromTime;
    NSString *toTime;
    int keyboardHeight;
    BOOL keyboardIsShowing;
    LYZSeditView *seditView;
    UIView  *_bgView;
    NSMutableArray *keyArr;
    
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)sureAct:(UIButton *)sender;
@property (nonatomic, weak) id <ZSAddTaoCanDelegate> delegate;
@end
