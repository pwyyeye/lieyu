//
//  LYTagTableViewController.h
//  lieyu
//
//  Created by pwy on 15/10/29.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBaseTableViewController.h"
#import "UserTagModel.h"
#import "LYUserHttpTool.h"


@protocol LYUserTagSelectedDelegate <NSObject>

-(void)userTagSelected:(NSMutableArray *)usertags;

@end

@interface LYTagTableViewController : LYBaseTableViewController

@property(strong,nonatomic) id<LYUserTagSelectedDelegate>delegate;

@property(strong,nonatomic) NSMutableArray *dataArray;

@property(strong,nonatomic) NSMutableArray *tagButtons;

//之前选择的标签
@property(strong,nonatomic) NSArray *selectedArray;
@end


