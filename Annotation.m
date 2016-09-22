//
//  Annotation.m
//  MapViewPinDrop
//
//  Created by sandeep malhotra on 3/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Annotation.h"

@implementation Annotation
@synthesize longitude,latitude;

-(CLLocationCoordinate2D)coordinate
{
	CLLocationCoordinate2D cord = {latitude,longitude};
	return cord;
}
@end
