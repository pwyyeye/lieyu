//
//  LYUserDetailController.h
//  lieyu
//
//  Created by pwy on 15/10/27.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBaseTableViewController.h"
#import "LYAlert.h"
@interface LYUserDetailController : LYBaseTableViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,LYAlertDelegate>
@property(strong,nonatomic) UITableViewCell *selectcedCell;

@property(strong,nonatomic) NSString *modifyNick;

@property(strong,nonatomic) UILabel *selectedLabel;

@property(strong,nonatomic) UIDatePicker *datePicker;

//弹出视图
@property(strong,nonatomic) LYAlert *alertView;

@end
