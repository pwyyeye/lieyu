//
//  LYChooseFriendsController.h
//  lieyu
//
//  Created by pwy on 16/1/31.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LYBaseTableViewController.h"
@protocol LYChooseFriendsControllerDelegate <NSObject>

-(void)chooseFriends:(NSArray *)friendsArray;

@end

@interface LYChooseFriendsController : LYBaseTableViewController

@property(strong,nonatomic) NSMutableArray *listContent;

@property(strong,nonatomic)id<LYChooseFriendsControllerDelegate> delegate;
@property(strong,nonatomic) NSMutableArray *firendsArray;
@property(strong,nonatomic) NSMutableDictionary *logDic;

@end
