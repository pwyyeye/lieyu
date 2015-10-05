//
//  AppDelegate.h
//  lieyu
//
//  Created by pwy on 15/9/5.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "UserModel.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(strong,nonatomic) NSTimer *timer;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property(strong,nonatomic) NSString *s_app_id;
@property(retain,nonatomic) UserModel *userModel;
@property(strong,nonatomic) NSString *qiniu_token;
@property(strong,nonatomic) NSString *im_token;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
-(void)doHeart;
- (void)startLoading;
- (void)stopLoading;
-(void)getImToken;
@end

