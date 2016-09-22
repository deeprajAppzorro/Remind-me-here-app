//
//  locationModel.h
//  MapDemo
//
//  Created by Sandeep Malhotra on 08/11/14.
//  Copyright (c) 2014 Abhishek Bhardwaj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface locationModel : NSObject
{
    
}
@property  (nonatomic,strong)  NSString *str_Name;
@property  (nonatomic,strong)  NSString *str_Desc;
@property  (nonatomic,strong)  NSString *str_LatLong;
@property  (nonatomic,strong)  NSString *str_entered;
@property  (nonatomic,strong)  NSString *str_currntLoc;
@property  (strong ,nonatomic) NSString *startPauseStatus;
@property  (strong ,nonatomic) NSString *alertStatus;
@property  (strong ,nonatomic) NSString *selectAlertType;
@property  (strong, nonatomic) NSDate   *date_fromDate;
@property  (strong, nonatomic) NSDate   *date_Todate;
@property  (nonatomic ,assign) float    radius;


@property (nonatomic, assign)CLLocationCoordinate2D locPoint;
//@property(nonatomic,strong)NSString *str_iconImg;
+(locationModel*)getObjectInitWithInfo:(NSDictionary *)dic_info;
@end
