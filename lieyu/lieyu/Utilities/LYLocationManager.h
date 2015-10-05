//
//  MILocationManager.h
//  Minimo
//
//  Created by ZKTeco on 5/5/14.
//  Copyright (c) 2014 ZKTeco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class CLLocation;
@protocol LYLocationManagerDelegate <NSObject>
- (void)onLocationUpdated:(CLLocation *)location;

@optional
- (void)onIdentifyLocationServiceDenied;
- (void)onIdentifyLocationServiceRestricted;

@end

@class Building;

@interface LYLocationManager : NSObject<CLLocationManagerDelegate>

@property(nonatomic, assign) BOOL success;
@property(nonatomic, weak) id<LYLocationManagerDelegate> locationDelegate;

+(BOOL)isGpsOn;
-(void)beginUpdateLocation:(CLLocationAccuracy)accuracy;
-(void)stopUpdateLocation;

-(void)beginUpdateVisit;
-(void)stopUpdateVisit;

-(void)requestAlwaysAuthorization;
/**
 *  decode
 */
-(void)reverseGeocode:(CLLocation *)location completionHandle:(CLGeocodeCompletionHandler)handle;


@end



