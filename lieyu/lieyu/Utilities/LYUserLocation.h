//
//  LYUserLocation.h
//  lieyu
//
//  Created by newfly on 10/5/15.
//  Copyright (c) 2015 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LYUserLocation : NSObject

+(LYUserLocation *)instance;
@property(nonatomic,strong)CLLocation *currentLocation;
@property(nonatomic,strong)NSString *city;
-(void)daoHan:(NSDictionary *) dic;
- (CLLocationDistance)configureDistance:(NSString *)latitude And:(NSString *)longitude;
- (CLLocation *)getCurrentLocation;
@end


