//
//  LYUserLocation.m
//  lieyu
//
//  Created by newfly on 10/5/15.
//  Copyright (c) 2015 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYUserLocation.h"
#import <MapKit/MapKit.h>
@implementation LYUserLocation

+(LYUserLocation *)instance
{
    static LYUserLocation * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[LYUserLocation alloc] init];
    });
    return instance;
}
-(CLLocation *)currentLocation{
     AppDelegate *delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    return delegate.userLocation;
}
-(NSString *)city{
    AppDelegate *delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    return delegate.citystr;
}
-(void)daoHan:(NSDictionary *) dic{
    //获取当前位置
    MKMapItem *mylocation = [MKMapItem mapItemForCurrentLocation];
    
    //当前经维度
    float currentLatitude=mylocation.placemark.location.coordinate.latitude;
    float currentLongitude=mylocation.placemark.location.coordinate.longitude;
    
    CLLocationCoordinate2D coords1 = CLLocationCoordinate2DMake(currentLatitude,currentLongitude);
    
    //目的地位置
    
    NSString *latitude=[dic objectForKey:@"latitude"];
    NSString *longitude=[dic objectForKey:@"longitude"];
    NSString *title=[dic objectForKey:@"title"];
    CLLocationCoordinate2D coordinate=CLLocationCoordinate2DMake(latitude.doubleValue,longitude.doubleValue);
    CLLocationCoordinate2D coords2 = coordinate;
    
    // ios6以下，调用google map
    if (SYSTEM_VERSION_LESS_THAN(@"6.0"))
    {
        NSString *urlString = [[NSString alloc] initWithFormat:@"http://maps.google.com/maps?saddr=%f,%f&daddr=%f,%f&dirfl=d", coords1.latitude,coords1.longitude,coords2.latitude,coords2.longitude];
        NSURL *aURL = [NSURL URLWithString:urlString];
        //打开网页google地图
        [[UIApplication sharedApplication] openURL:aURL];
    }
    else
        // 直接调用ios自己带的apple map
    {
        //当前的位置
        MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
        //起点
        //MKMapItem *currentLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:coords1 addressDictionary:nil]];
        //目的地的位置
        MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:coords2 addressDictionary:nil]];
        
        toLocation.name = title;

        
        NSArray *items = [NSArray arrayWithObjects:currentLocation, toLocation, nil];
        NSDictionary *options = @{ MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving, MKLaunchOptionsMapTypeKey: [NSNumber numberWithInteger:MKMapTypeStandard], MKLaunchOptionsShowsTrafficKey:@YES };
        //打开苹果自身地图应用，并呈现特定的item
        [MKMapItem openMapsWithItems:items launchOptions:options];
    }
}

#pragma mark - 根据传入目的地经纬度计算距离
- (CLLocationDistance)configureDistance:(NSString *)latitude And:(NSString *)longitude{
    CLLocation *currentLocation = [self currentLocation];
    CLLocation *destinationLocation = [[CLLocation alloc]initWithLatitude:[latitude doubleValue] longitude:[longitude doubleValue]];
    CLLocationDistance kiloMeters = [currentLocation distanceFromLocation:destinationLocation] / 1000;
    return kiloMeters;
}

@end
