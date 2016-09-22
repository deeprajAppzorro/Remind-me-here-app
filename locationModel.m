//
//  locationModel.m
//  MapDemo
//
//  Created by Sandeep Malhotra on 08/11/14.
//  Copyright (c) 2014 Abhishek Bhardwaj. All rights reserved.
//

#import "locationModel.h"

@implementation locationModel
+(locationModel*)getObjectInitWithInfo:(NSDictionary *)dic_info
{
    locationModel *objDashBoard = [[self alloc] init];
    objDashBoard.str_Name = [dic_info objectForKey:@"name"];
    objDashBoard.str_Desc = [dic_info objectForKey:@"desc"];
    objDashBoard.str_LatLong = [dic_info objectForKey:@"latLong"];
    objDashBoard.str_entered = [dic_info objectForKey:@"enter"];
    objDashBoard.str_currntLoc = [dic_info objectForKey:@"currntLoc"];
    objDashBoard.radius =[[dic_info objectForKey:@"radius"] floatValue];
    objDashBoard.date_fromDate=[dic_info objectForKey:@"date_fromDate"];
    objDashBoard.date_Todate=[dic_info objectForKey:@"date_ToDate"];
    objDashBoard.startPauseStatus=[dic_info objectForKey:@"startPauseStatus"];
    objDashBoard.alertStatus=[dic_info objectForKey:@"alertStatus"];
    objDashBoard.selectAlertType=[dic_info objectForKey:@"selectAlertType"];
    NSArray *ary_latLong = [[dic_info objectForKey:@"latLong"] componentsSeparatedByString:@","];
    
   
    objDashBoard.locPoint = CLLocationCoordinate2DMake(((NSString *)[ary_latLong objectAtIndex:0]).doubleValue, ((NSString *)[ary_latLong objectAtIndex:1]).doubleValue);//(Lat,Long)
   
    return objDashBoard;
}
@end
