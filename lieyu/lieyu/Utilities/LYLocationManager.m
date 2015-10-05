//
//  MILocationManager.m
//  Minimo
//
//  Created by ZKTeco on 5/5/14.
//  Copyright (c) 2014 ZKTeco. All rights reserved.
//

#import "LYLocationManager.h"
#import "CLLocation+CoordinateConvert.h"

@interface LYLocationManager()
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, assign) BOOL forVisiting;
@end

@implementation LYLocationManager

-(id)init
{
    self = [super init];
    if (self != nil) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.forVisiting = NO;
    }
    return self;
}

-(void)beginUpdateLocation:(CLLocationAccuracy)accuracy{
    self.locationManager.desiredAccuracy = accuracy;
    self.locationManager.delegate = self;

    if( [self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
    {
        [self.locationManager requestAlwaysAuthorization];
    }
}

-(void)requestAlwaysAuthorization
{
    if( [self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
    {
        [self.locationManager requestAlwaysAuthorization];
    }}


-(void)stopUpdateLocation{
    [self.locationManager stopUpdatingLocation];
}

-(void)beginUpdateVisit{
    self.forVisiting = YES;
    self.locationManager.delegate = self;
    if( [self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
    {
        [self.locationManager requestWhenInUseAuthorization];
    }
}

-(void)stopUpdateVisit{
    [self.locationManager stopMonitoringVisits];
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager
	 didUpdateLocations:(NSArray *)locations
{
    CLLocation* location = (locations == nil || locations.count == 0) ? nil : locations[0];
    
    if(self.locationDelegate != nil)
    {

//------地球坐标要转换为 火星坐标
        CLLocation *newLocation = [location locationMarsFromEarth];
        [self.locationDelegate onLocationUpdated:newLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    [manager stopUpdatingLocation];
    self.success = NO;
}

- (void)startTrackingLocation {
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (status == kCLAuthorizationStatusNotDetermined) {
        if( [self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
        {
            [self.locationManager requestWhenInUseAuthorization];
        }
    }
    else if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusAuthorizedAlways) {
        if(self.forVisiting){
            [self.locationManager startMonitoringVisits];
        }
        else{
            [self.locationManager startUpdatingLocation];
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
        case kCLAuthorizationStatusAuthorizedAlways:
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            NSLog(@"Got authorization, start tracking location");
            [self startTrackingLocation];
            break;
        case kCLAuthorizationStatusNotDetermined:
        {
            if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
            {
                [self.locationManager requestWhenInUseAuthorization];
            }
        }
            break;
        case kCLAuthorizationStatusRestricted:
            if(self.locationDelegate != nil && [self.locationDelegate respondsToSelector:@selector(onIdentifyLocationServiceRestricted)]){
                [self.locationDelegate onIdentifyLocationServiceRestricted];
            }
            break;
        case kCLAuthorizationStatusDenied:
            if(self.locationDelegate !=nil && [self.locationDelegate respondsToSelector:@selector(onIdentifyLocationServiceDenied)]){


                [self.locationDelegate onIdentifyLocationServiceDenied];
            }
            break;
        default:
            break;
    }
}


-(void)reverseGeocode:(CLLocation *)location completionHandle:(CLGeocodeCompletionHandler)handle
{
    CLGeocoder *geoCode = [[CLGeocoder alloc] init];
    [geoCode reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error)
     {
         handle(placemarks,error);
    }];
}

+(BOOL)isGpsOn
{
    if (([CLLocationManager locationServicesEnabled]) && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized)) {
        return YES;
    } else {
        return NO;
    }
}


@end





