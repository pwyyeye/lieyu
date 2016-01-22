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
#import <CoreLocation/CoreLocation.h>
#import "EAIntroView.h"

#define UmengAppkey @"56244a0467e58e25ce0026b3"
//#define RONGCLOUD_IM_APPKEY @"3argexb6rtese"
#define RONGCLOUD_IM_APPKEY @"ik1qhw091chyp"//生产

@interface AppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate,EAIntroDelegate,UIAlertViewDelegate>
{
    CLLocationManager *locationManager;
}
 
@property (strong, nonatomic) UIWindow *window;
@property(strong,nonatomic) NSTimer *timer;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property(strong,nonatomic) NSString *s_app_id;
@property(retain,nonatomic) UserModel *userModel;
@property(strong,nonatomic) NSString *qiniu_token;
@property(strong,nonatomic) NSString *qiniu_media_token;
@property(strong,nonatomic) NSString *im_token;
@property(strong,nonatomic) NSString *im_userId;
@property(strong,nonatomic) NSString *citystr;
@property(retain,nonatomic) CLLocation * userLocation;
@property(strong,nonatomic) UINavigationController *navigationController;

@property(strong,nonatomic) EAIntroView *intro;


- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
-(void)doHeart;
- (void)startLoading;
- (void)stopLoading;
-(void)getImToken;
-(void)connectWithToken;

@end

