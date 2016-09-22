//
//  Annotation.h
//  MapViewPinDrop
//
//  Created by sandeep malhotra on 3/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Annotation : NSObject<MKAnnotation>
{
    double longitude;
    double latitude;
    
}
@property (nonatomic )double longitude;
@property (nonatomic )double latitude;
@end
