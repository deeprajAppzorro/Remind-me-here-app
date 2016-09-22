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
    NSString *_title;
    NSString *_subtitle;
    
    CLLocationCoordinate2D _coordinate;
    
}
// Getters and setters
- (void)setTitle:(NSString *)title;
- (void)setSubtitle:(NSString *)subtitle;
@end
