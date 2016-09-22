//
//  CenterPanel_VC.m
//  FBKindNavigation
//
//  Created by Abhishek Bhardwaj on 12/07/13.
//  Copyright (c) 2013 Abhishek Bhardwaj. All rights reserved.
//

#import "CenterPanel_VC.h"
#import "Annotation.h"
#import "RemindMeHereVC.h"
#import "BuyProduct_VC.h"
#import "existingLocCell.h"
#import "IAPHelper.h"

//#define LOC_COUNT 5



// ...

@interface DXAnnotation : NSObject <MKAnnotation>

@property(nonatomic, assign) CLLocationCoordinate2D coordinate;

@end
@interface CenterPanel_VC ()<UIActivityItemSource,MKMapViewDelegate>

{
    
    NSTimer *updateLocationTimer;
    CLLocation *oldUserLocation;
    
    
}
@property(strong,nonatomic)NSString *annotationTitle;
@property(strong,nonatomic)NSString *annotationSubtitle;
@property(assign,nonatomic)CLLocationCoordinate2D  annotationCoordinates;
@property (retain, nonatomic) IBOutlet UISegmentedControl *incomingOutgoingSegment;

@end

@implementation CenterPanel_VC
int LOC_COUNT = 5;

@synthesize contentView = _contentView;
@synthesize adBannerView = _adBannerView;
@synthesize adBannerViewIsVisible = _adBannerViewIsVisible;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = @"Map";
    }
    return self;
}


- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    [EC_NotificationCenter addObserver:self selector:@selector(reloadPinsAfterEdit) name:reloadPinsOnMap object:nil];
    [EC_NotificationCenter addObserver:self selector:@selector(getUserReminder) name:reloadPinsOnMap object:nil];
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    numberToolbar.barStyle = UIBarStyleDefault;
    numberToolbar.items = @[[[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelNumberPad)],
                            [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                            [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)]];
    [numberToolbar sizeToFit];
    radiusTextfield.inputAccessoryView = numberToolbar;
    
    oldUserLocation=[CLLocation new];

    
    [self createAdBannerView];
    
    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(mapLongPress:)];
    //longPressGesture.minimumPressDuration = 1.5;
    [_myMap addGestureRecognizer:longPressGesture];
    
    
    
    //Inner View
    [activity_innerView.layer setCornerRadius:30.0f];
    // border
    [activity_innerView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [activity_innerView.layer setBorderWidth:1.5f];
    // drop shadow
    [activity_innerView.layer setShadowColor:[UIColor blackColor].CGColor];
    [activity_innerView.layer setShadowOpacity:0.8];
    [activity_innerView.layer setShadowRadius:3.0];
    [activity_innerView.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    
    
    
    // Cancel button border
    [btn_cancel.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [btn_cancel.layer setBorderWidth:1.5f];
    // drop shadow
    [btn_cancel.layer setShadowColor:[UIColor blackColor].CGColor];
    [btn_cancel.layer setShadowOpacity:0.8];
    [btn_cancel.layer setShadowRadius:3.0];
    [btn_cancel.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    
    
    
    // Done button border
    [btn_done.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [btn_done.layer setBorderWidth:1.5f];
    // drop shadow
    [btn_done.layer setShadowColor:[UIColor blackColor].CGColor];
    [btn_done.layer setShadowOpacity:0.8];
    [btn_done.layer setShadowRadius:3.0];
    [btn_done.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    
    
    // Street View border
    [view_streetAdd.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [view_streetAdd.layer setBorderWidth:1.5f];
    // drop shadow
    [view_streetAdd.layer setShadowColor:[UIColor blackColor].CGColor];
    [view_streetAdd.layer setShadowOpacity:0.8];
    [view_streetAdd.layer setShadowRadius:3.0];
    [view_streetAdd.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    
    // Street Cancel button border
    [btn_streetCancel.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [btn_streetCancel.layer setBorderWidth:1.5f];
    // drop shadow
    [btn_streetCancel.layer setShadowColor:[UIColor blackColor].CGColor];
    [btn_streetCancel.layer setShadowOpacity:0.8];
    [btn_streetCancel.layer setShadowRadius:3.0];
    [btn_streetCancel.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    
    // Street Done button border
    [btn_streetDone.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [btn_streetDone.layer setBorderWidth:1.5f];
    // drop shadow
    [btn_streetDone.layer setShadowColor:[UIColor blackColor].CGColor];
    [btn_streetDone.layer setShadowOpacity:0.8];
    [btn_streetDone.layer setShadowRadius:3.0];
    [btn_streetDone.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    
    
    // btn_existingLoc border
    [btn_existingLoc.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [btn_existingLoc.layer setBorderWidth:1.5f];
    // btn_existingLoc
    [btn_existingLoc.layer setShadowColor:[UIColor blackColor].CGColor];
    [btn_existingLoc.layer setShadowOpacity:0.8];
    [btn_existingLoc.layer setShadowRadius:3.0];
    [btn_existingLoc.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    
    // btn_newLoc border
    [btn_newLoc.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [btn_newLoc.layer setBorderWidth:1.5f];
    // btn_newLoc
    [btn_newLoc.layer setShadowColor:[UIColor blackColor].CGColor];
    [btn_newLoc.layer setShadowOpacity:0.8];
    [btn_newLoc.layer setShadowRadius:3.0];
    [btn_newLoc.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    
    
    // btn_newLoc border
    [tblView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [tblView.layer setBorderWidth:1.5f];
    // btn_newLoc
    [tblView.layer setShadowColor:[UIColor blackColor].CGColor];
    [tblView.layer setShadowOpacity:0.8];
    [tblView.layer setShadowRadius:3.0];
    [tblView.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    
    self.ary_loc = [NSArray arrayWithArray:[AppDelegate sharedDelegate].fetchLocationsFromUD];
    
    
    
    _myMap.showsUserLocation = YES;
//    if(self.ary_loc.count)
//    {
        [self startLocationManager];
//    }
    
 
    
    if(self.ary_loc.count > 0)
    {
        [self showPinsOnViewDidLoad];
    }
    
}

-(void)viewWillAppear:(BOOL)animated
{
    UIColor *selectedColor = [UIColor colorWithRed: 0/255.0 green:144/255.0 blue:81/255.0 alpha:1.0];
    _incomingOutgoingSegment.tintColor=selectedColor;
 
    firstTimeZoom=YES;
 
    [self fixupAdView:[UIDevice currentDevice].orientation];
    self.AcitveTimer = [NSTimer scheduledTimerWithTimeInterval:10
                                                            target:self                                                selector:@selector(checkUserLocation)
                                                          userInfo:nil
                                                           repeats:YES];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self.AcitveTimer invalidate];
    
}





-(void)showAlertInActive:(NSString *)title message:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    alert.tag = 888;
    [alert show];
    
}



-(void)getLOcat:(NSString *)Name description:(NSString *)description AnnotationDetail:(locationModel *)AnnotationDetail
{
    
    
    //NSDictionary *userInfo=@{@"info":AnnotationDetail};
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.alertBody=description;
   // localNotification.userInfo=userInfo;
    localNotification.timeZone=[NSTimeZone localTimeZone];
    localNotification.alertTitle=Name;
    localNotification.fireDate=[NSDate date];
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    localNotification.repeatInterval=kCFCalendarUnitMinute;
    localNotification.category = @"Alert";
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
   
    
   

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)RowTapped:(int)i
{
    
    if(i == 0 && i==1)
    {
        if(editing)
        {
            editing = NO;
            [self action_cancelActivity:nil];
        }
        view_activityIndicator.hidden = YES;
        activityIndicator.hidden = YES;
        if(!view_streetAdd.hidden)
        {
            txt_streetAdd.text = @"";
            [UIView animateWithDuration:.50
                             animations:^
             {
                 
                 CGRect frame= view_streetAdd.frame;
                 frame.origin.y = -128;
                 view_streetAdd.frame = frame;
                 
             }
                             completion:^(BOOL finished)
             {
                 view_back.hidden = YES;
                 view_streetAdd.hidden = YES;
             }];
        }
    }
   if(i == 2)
   {
       
       [self action_cancelActivity:nil];
       if(view_streetAdd.hidden)
       {
           view_streetAdd.hidden = NO;
           
           
           [self action_newLoc:nil];
           btn_existingLoc.hidden = NO;
           btn_newLoc.hidden = NO;
           
           [UIView animateWithDuration:.50
                            animations:^
            {
                
                CGRect frame= view_streetAdd.frame;
                frame.origin.y = 64;
                view_streetAdd.frame = frame;
                
            }
            completion:^(BOOL finished)
            {
                view_back.hidden = NO;
            }];
       }
       
   }
    else if (i==3)
    {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/clublife/id1088538037?mt=8"]];
    }
    else if (i==4)
    {
        
        UIActivityViewController *activityViewController =
        [[UIActivityViewController alloc] initWithActivityItems:@[@"https://itunes.apple.com/us/app/clublife/id1088538037?mt=8"]
                                          applicationActivities:nil];
       // activityViewController.excludedActivityTypes = @[UIActivityTypePostToFacebook,UIActivityTypePostToTwitter,UIActivityTypeMessage];
        [self presentViewController:activityViewController
                                           animated:YES
                                         completion:^{
                                             
                                             
                                             // ...
                                         }];
        
        
    }
   else if(i == 5)
   {
       editing= NO;
       [self hideTheAddressFromConnection];
       BuyProduct_VC *remindObj = [[BuyProduct_VC alloc] init];
       [self presentViewController:remindObj animated:YES completion:^
        {
            
            
        }];

       
       
       
   }
    
    
    
    
    
    
}

- (id)activityViewController:(UIActivityViewController *)activityViewController
         itemForActivityType:(NSString *)activityType
{
    if ([activityType isEqualToString:UIActivityTypePostToFacebook]) {
        return @"Like this!";
    } else if ([activityType isEqualToString:UIActivityTypePostToTwitter]) {
        return @"Retweet this!";
    } else {
        return nil;
    }
}
- (void)dealloc {
    
    [_myMap release];
   [activityView release];
    [txt_activity release];
   [view_back release];
    [activity_innerView release];
    [btn_cancel release];
    [btn_done release];
    [view_streetAdd release];
    [txt_streetAdd release];
    [btn_cancel release];
    [btn_streetDone release];
    [btn_streetCancel release];
    [view_activityIndicator release];
    [activityIndicator release];
    [txt_desc release];
    self.contentView = nil;
    self.adBannerView = nil;
    [btn_existingLoc release];
    [btn_newLoc release];
    [btn_useCurrLoc release];
    [btn_entrAdd release];
    [view_enterAdd release];
    [view_btns release];
    [tblView release];
    
    [datePicker release];
    [_incomingOutgoingSegment release];
    [super dealloc];
}





- (void)startBackgroundTask {
    [self startLocationManager];
    
}



#pragma mark MkMapViewDelegate
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation ///Delegate
{
    
    if (UIApplication.sharedApplication.applicationState == UIApplicationStateBackground) {
        
        [self performSelector:@selector(getUserReminder)];
    }
    

        for(locationModel *locObj in self.ary_loc )
        {
            if ([locObj.startPauseStatus isEqualToString:@"0"] )
            {
           //NSLog(@"%@",locObj.alertStatus);
           
            CLLocationCoordinate2D locPoint = locObj.locPoint;
            
            if (CLLocationCoordinate2DIsValid(locPoint))
            {
                CLLocation *LocationAtual = [[CLLocation alloc] initWithLatitude:locPoint.latitude longitude:locPoint.longitude];
                CLLocationDistance meters = [newLocation distanceFromLocation:LocationAtual];
                

                if (locObj.radius >= meters)
                    
                {
                    
                   
                    if ([locObj.alertStatus isEqualToString:@"start"])
                    {

                        
                        if ([locObj.selectAlertType isEqualToString:@"inComing"])
                        {
                        
                            BOOL fromDate=[self compareTwodate:locObj.date_fromDate];
                            BOOL toDate=[self compareTwodate:locObj.date_Todate];
                            
                            NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init] ;
                            [dateFormatter setDateFormat:@"dd:MM:yyyy"];
                            
                            
                            if ([[dateFormatter stringFromDate:locObj.date_fromDate]isEqualToString:[dateFormatter stringFromDate:locObj.date_Todate]]&&[[dateFormatter stringFromDate:locObj.date_fromDate]isEqualToString:[dateFormatter stringFromDate:[NSDate date]]])
                            {
                                
                                [dateFormatter setDateFormat:@"HH:mm:ss"];
                                
                                BOOL timeCheck= [self CompareTwoTime:[dateFormatter stringFromDate:locObj.date_fromDate] second:[dateFormatter stringFromDate:locObj.date_Todate]];
                                BOOL pastTimeCheck= [self CompareTwoTime:[dateFormatter stringFromDate:locObj.date_fromDate] second:[dateFormatter stringFromDate:[NSDate date]]];
                                BOOL currentTimeCheck= [self CompareTwoTime:[dateFormatter stringFromDate:[NSDate date]] second:[dateFormatter stringFromDate:locObj.date_Todate]];
                                
                                
                                
                                if (pastTimeCheck && timeCheck && currentTimeCheck)
                                {
                                    
                                    [self getLOcat:locObj.str_Name description:locObj.str_Desc AnnotationDetail:locObj];
                                    
                                    
                                    [self alertStatus:@"stop" cordinates:locObj.str_LatLong name:locObj.str_Name radius:locObj.radius];
                                    
                                    return;
                                }
                                
                            }
                            else if (!fromDate && toDate)
                             {
                                
                                [self getLOcat:locObj.str_Name description:locObj.str_Desc AnnotationDetail:locObj];
                                
                                
                                [self alertStatus:@"stop" cordinates:locObj.str_LatLong name:locObj.str_Name radius:locObj.radius];
                                
                                return;
                             }
                        }
                        
                    }
                    else if ([locObj.selectAlertType isEqualToString:@"outGoing"])
                    {
                        [self alertStatus:@"start" cordinates:locObj.str_LatLong name:locObj.str_Name radius:locObj.radius];
                        
                        return;
                        
                    }

                }
                else
                {
           
                        
                    if ([locObj.alertStatus isEqualToString:@"start"])
                    {
                        
                        
                        if ([locObj.selectAlertType isEqualToString:@"outGoing"])
                        {
                            
                            BOOL fromDate=[self compareTwodate:locObj.date_fromDate];
                            BOOL toDate=[self compareTwodate:locObj.date_Todate];
                            
                            NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init] ;
                            [dateFormatter setDateFormat:@"dd:MM:yyyy"];
                            
                            
                            if ([[dateFormatter stringFromDate:locObj.date_fromDate]isEqualToString:[dateFormatter stringFromDate:locObj.date_Todate]]&&[[dateFormatter stringFromDate:locObj.date_fromDate]isEqualToString:[dateFormatter stringFromDate:[NSDate date]]])
                            {
                                
                                [dateFormatter setDateFormat:@"HH:mm:ss"];
                                
                                BOOL timeCheck= [self CompareTwoTime:[dateFormatter stringFromDate:locObj.date_fromDate] second:[dateFormatter stringFromDate:locObj.date_Todate]];
                                BOOL pastTimeCheck= [self CompareTwoTime:[dateFormatter stringFromDate:locObj.date_fromDate] second:[dateFormatter stringFromDate:[NSDate date]]];
                                BOOL currentTimeCheck= [self CompareTwoTime:[dateFormatter stringFromDate:[NSDate date]] second:[dateFormatter stringFromDate:locObj.date_Todate]];
                                
                                
                                
                                if (pastTimeCheck && timeCheck && currentTimeCheck)
                                {
                                    
                                    [self getLOcat:locObj.str_Name description:locObj.str_Desc AnnotationDetail:locObj];
                                    
                                    
                                    [self alertStatus:@"stop" cordinates:locObj.str_LatLong name:locObj.str_Name radius:locObj.radius];
                                    
                                    return;
                                    
                                    
                                }
                                
                            }   else if (!fromDate && toDate)
                            {
                                
                                [self getLOcat:locObj.str_Name description:locObj.str_Desc AnnotationDetail:locObj];
                                
                                
                                [self alertStatus:@"stop" cordinates:locObj.str_LatLong name:locObj.str_Name radius:locObj.radius];
                                return;
                            }
                        }
 
                    }
                    else if ([locObj.selectAlertType isEqualToString:@"inComing"])
                    {
                        [self alertStatus:@"start" cordinates:locObj.str_LatLong name:locObj.str_Name radius:locObj.radius];
                        
                        return;
                        
                    }
     
                }
   
            }
                
        }
        

        
    }
    
    
   
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    
   
//    MKMapPoint annotationPoint = MKMapPointForCoordinate(mapView.userLocation.coordinate);
//    MKMapRect zoomRect = MKMapRectMake(annotationPoint.x+100, annotationPoint.y, 0.05, 0.05);
////    MKMapRect zoomRect = MKMapRectNull;
//    for (id <MKAnnotation> annotation in mapView.annotations)
//    {
//        MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
//        MKMapRect pointRect = MKMapRectMake(annotationPoint.x+100, annotationPoint.y, 0.05, 0.05);
//        zoomRect = MKMapRectUnion(zoomRect, pointRect);
//    }
//    [mapView setVisibleMapRect:zoomRect animated:YES];

    
    if (!self.ary_loc.count) {
        
        if (firstTimeZoom) {
            firstTimeZoom=NO;
            
         [self ZoomOnMap];
        
        }
        
    }
    
    NSLog(@"%f",locationManager.location.coordinate.latitude);
    
   


}
- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    /*
     if(!currentLoc)
     return nil;
     
     currentLoc=nil;
     //    // If it's the user location, just return nil.
     //    if ([annotation isKindOfClass:[MKUserLocation class]])
     //        return nil;
     //    else { // Handles the other annotations.
     //        // Try to dequeue an existing pin view first.
     static NSString *AnnotationIdentifier = @"AnnotationIdentifier";
     MKPinAnnotationView *pinView = (MKPinAnnotationView *)[_myMap dequeueReusableAnnotationViewWithIdentifier:AnnotationIdentifier];
     
     //        if (!pinView)
     //        {
     //            // If an existing pin view was not available, creates one.
     MKPinAnnotationView *customPinView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationIdentifier] autorelease];
     customPinView.animatesDrop = YES;
     customPinView.canShowCallout = YES;
     
     // Adds a detail disclosure button.
     //            UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
     //            [rightButton addTarget:self action:@selector(showDetails:) forControlEvents:UIControlEventTouchUpInside];
     //            customPinView.rightCalloutAccessoryView = rightButton;
     
     return customPinView;
     //        } else
     //            pinView.annotation = annotation;
     //    }
     
     */
    
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }

    static NSString *defaultPinID = @"com.invasivecode.pin";
    MKAnnotationView *view = (id)[_myMap dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
    if (view==nil) {
        view = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:defaultPinID];
        view.canShowCallout = true;
        //view.animatesDrop = true;
       
    } else {
       
         view.annotation = annotation;
    }


    
    for (locationModel * locObj in self.ary_loc) {
        
        
        if (locObj.locPoint.latitude ==  annotation.coordinate.latitude && locObj.locPoint.longitude == annotation.coordinate.longitude ) {
            if ([locObj.startPauseStatus isEqualToString:@"0"]) {
                
                   view.image = [UIImage imageNamed:@"pin"];
            }
            else
            {
                view.image = [UIImage imageNamed:@"pause_pin_icon"];
            }
        }
        
    }

    
    
   /*
    MKAnnotationView *pinView = nil;
    if(annotation != _myMap.userLocation)
    {
        
        pinView = (MKAnnotationView *)[_myMap dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
        if ( pinView == nil )
        {
            pinView = [[MKAnnotationView alloc]
                       initWithAnnotation:annotation reuseIdentifier:defaultPinID];
        
    }
        else
        {
            pinView.annotation = annotation;
        }
        

        pinView.image = [UIImage imageNamed:@"pin"];    //as suggested by Squatch
        */
//        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//        [rightButton addTarget:self action:@selector(showDetails:) forControlEvents:UIControlEventTouchUpInside];
//        UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
//        [leftButton setTitle:@"click" forState:UIControlStateNormal];
//        [leftButton setBackgroundColor:[UIColor cyanColor]];
//        [leftButton addTarget:self action:@selector(LeftshowDetails:) forControlEvents:UIControlEventTouchUpInside];
//        pinView.rightCalloutAccessoryView = rightButton;
//        pinView.leftCalloutAccessoryView =leftButton;
        
        
        
    
        ////// create customView
    
//         UIView *customAnnotationView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 90)];
//         
//         UIButton *rightBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
//         [rightBtn setTitle:@"info" forState:UIControlStateNormal];
//         [rightBtn addTarget:self action:@selector(showDetails:) forControlEvents:UIControlEventTouchUpInside];
//         [rightBtn setBackgroundColor:[UIColor blackColor]];
//         
//         
//         UIImageView *imgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 28, 40, 60)];
//         imgView.image=[UIImage imageNamed:@"pin"];
//         [customAnnotationView addSubview:rightBtn];
//         [customAnnotationView addSubview:imgView];
//         
//         [pinView addSubview:customAnnotationView];
    

        view.detailCalloutAccessoryView = [self detailViewForAnnotation1:annotation];
    
    
    
    
    return view;
   }
   /* else {
        [_myMap.userLocation setTitle:@"I am here"];
    }
    return view;
    
    




    
}
*/
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    Annotation *selectedAnnotation = view.annotation; // This will give the annotation.
    if (selectedAnnotation.coordinate.latitude == _myMap.userLocation.coordinate.latitude && selectedAnnotation.coordinate.longitude == _myMap.userLocation.coordinate.longitude)
        return;
    
    
    
    _annotationTitle=selectedAnnotation.title;
    _annotationSubtitle=selectedAnnotation.subtitle;
    _annotationCoordinates=selectedAnnotation.coordinate;
    
    
    
   NSLog(@"%@\n%@\n%f\n%f",_annotationTitle,_annotationSubtitle,_annotationCoordinates.latitude,_annotationCoordinates.longitude);
 
    
    //[self drawPolyline:_myMap.userLocation.coordinate destination:selectedAnnotation.coordinate];
    
    
    
    
    
}

//Get user added reminder list

-(void)getUserReminder

{
    self.ary_loc = [NSArray arrayWithArray:[AppDelegate sharedDelegate].fetchLocationsFromUD];
}



- (UIView *)detailViewForAnnotation1:(Annotation *)annotation {
    
     Annotation *selectedAnnotation = annotation;

    UIView *view = [[UIView alloc] init];
    view.translatesAutoresizingMaskIntoConstraints = false;

    UITextView *subTitleTextview = [[UITextView alloc] init];
    subTitleTextview.text = selectedAnnotation.subtitle;
    subTitleTextview.font = [UIFont systemFontOfSize:15];
    subTitleTextview.translatesAutoresizingMaskIntoConstraints = false;
    [subTitleTextview setUserInteractionEnabled:NO];
    subTitleTextview.scrollEnabled=YES;
    subTitleTextview.alwaysBounceVertical=YES;
   [view addSubview:subTitleTextview];
    
    UIButton *editButton = [self editButton];
    
    
    UIButton *pauseButton = [self pauseButton];
    
    for (locationModel * locObj in self.ary_loc) {

        
         if (locObj.str_Name ==selectedAnnotation.title&& [locObj.str_Desc isEqualToString:selectedAnnotation.subtitle] && locObj.locPoint.latitude ==  selectedAnnotation.coordinate.latitude && locObj.locPoint.longitude == selectedAnnotation.coordinate.longitude ) {
        if ([locObj.startPauseStatus isEqualToString:@"0"]) {
                
                [pauseButton setTitle:@"Pause" forState:UIControlStateNormal];
            }
            else
            {
                [pauseButton setTitle:@"Start" forState:UIControlStateNormal];
            }
         }
       
    }
    
    UIButton *deleteButton = [self DeleteButton];
    editButton.tag=selectedAnnotation.coordinate.latitude;
    
    [view addSubview:editButton];
    [view addSubview:pauseButton];
    [view addSubview:deleteButton];
    
 
    NSDictionary *viewsDictionary = @{@"superView":view,@"subTitleTextview":subTitleTextview,@"editButton":editButton,@"deleteButton":deleteButton,@"pauseButton":pauseButton};

    // super view Constraints
    NSArray *constraint_H = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[superView(120)]"
                                                                    options:0
                                                                    metrics:nil
                                                                      views:viewsDictionary];
    
    NSArray *constraint_V = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[superView(200)]"
                                                                    options:0
                                                                    metrics:nil
                                                                      views:viewsDictionary];
    
    [view addConstraints:constraint_H];
    [view addConstraints:constraint_V];
    
   // @[@"H:|-20-[normal]-10-|", @"H:|-20-[bold]-10-|", @"V:|-30-[normal]-10-[bold]-10-|"]
    
    
    
    NSArray *constraint_View_H = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[subTitleTextview]-35-|"
                                                                    options:0
                                                                    metrics:nil
                                                                      views:viewsDictionary];
    
    NSArray *constraint_View_V = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[subTitleTextview]|"
                                                                    options:0
                                                                    metrics:nil
                                                                      views:viewsDictionary];
    
    [view addConstraints:constraint_View_V];
    [view addConstraints:constraint_View_H];
    
    
    
    
    
    NSArray *constraint_editButton_H = [NSLayoutConstraint
                                        constraintsWithVisualFormat:@"V:|-90-[editButton]|"
                                                                         options:0
                                                                         metrics:nil
                                                                           views:viewsDictionary];
    
    NSArray *constraint_editButton_V = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[editButton(60)]-90-|"
                                                                         options:0
                                                                         metrics:nil
                                                                           views:viewsDictionary];
    
    [view addConstraints:constraint_editButton_H];
    [view addConstraints:constraint_editButton_V];
    
    
//Delete Button Constraints
    
    NSArray *constraint_deleteButton_H = [NSLayoutConstraint
                                        constraintsWithVisualFormat:@"V:|-90-[deleteButton]|"
                                        options:0
                                        metrics:nil
                                        views:viewsDictionary];
    
    NSArray *constraint_deleteButton_V = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-140-[deleteButton(60)]|"
                                                                               options:0
                                                                               metrics:nil
                                                                                 views:viewsDictionary];

    [view addConstraints:constraint_deleteButton_H];
    [view addConstraints:constraint_deleteButton_V];

 
    
    
  
    
   
 //Pause Button Constraints
    
    NSArray *constraint_pauseButton_H = [NSLayoutConstraint
                                          constraintsWithVisualFormat:@"V:|-90-[pauseButton]|"
                                          options:0
                                          metrics:nil
                                          views:viewsDictionary];
    
    NSArray *constraint_pauseButton_V = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-70-[pauseButton(60)]-70-|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:viewsDictionary];
    
    [view addConstraints:constraint_pauseButton_H];
    [view addConstraints:constraint_pauseButton_V];
    
    return view;
}

- (UIButton *)editButton {
   
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.translatesAutoresizingMaskIntoConstraints = false; // use auto layout in this case
    [button setTitle:@"Edit" forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor colorWithRed:91/255.0 green:177/255.0 blue:40/255.0 alpha:1.0]];
    [button addTarget:self action:@selector(editAnnotationAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}
- (UIButton *)pauseButton {
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.translatesAutoresizingMaskIntoConstraints = false; // use auto layout in this case
    [button setTitle:@"Pause" forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor colorWithRed:91/255.0 green:177/255.0 blue:40/255.0 alpha:1.0]];
    [button addTarget:self action:@selector(pauseAnnotationAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}
- (UIButton *)DeleteButton {
  
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.translatesAutoresizingMaskIntoConstraints = false; // use auto layout in this case
    [button setTitle:@"Delete" forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor colorWithRed:238/255.0 green:84/255.0 blue:35/255.0 alpha:1.0]];
    [button addTarget:self action:@selector(deleteAnnotationAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}
#pragma mark CallOut Button Actions
-(void)editAnnotationAction:(id)sender
{
  
    for (int i=0; i<self.ary_loc.count; i++) {
        
        
        locationModel *locObj = [self.ary_loc objectAtIndex:i];
        
        
        
        
        NSLog(@"%@\n %@\n%f\n%f",locObj.str_Name,locObj.str_Desc,[[NSString stringWithFormat:@"%f",locObj.locPoint.latitude] floatValue],[[NSString stringWithFormat:@"%f",locObj.locPoint.longitude] floatValue]);
        NSLog(@"%@\n %@\n%f\n%f",_annotationTitle,_annotationSubtitle,[[NSString stringWithFormat:@"%f",_annotationCoordinates.latitude] floatValue],[[NSString stringWithFormat:@"%f",_annotationCoordinates.longitude] floatValue]);
        
        
        
        if (locObj.str_Name ==_annotationTitle && [locObj.str_Desc isEqualToString:_annotationSubtitle] && [[NSString stringWithFormat:@"%f",locObj.locPoint.latitude] floatValue] ==  [[NSString stringWithFormat:@"%f",_annotationCoordinates.latitude] floatValue] && [[NSString stringWithFormat:@"%f",locObj.locPoint.longitude] floatValue] == [[NSString stringWithFormat:@"%f",_annotationCoordinates.longitude] floatValue] ) {
            
            
            editing = YES;
            selectedIndex = i;
            locationModel *locObj = [self.ary_loc objectAtIndex:i];
            txt_activity.text = locObj.str_Name;
            txt_desc.text = locObj.str_Desc;
            radiusTextfield.text=[NSString stringWithFormat:@"%.f",locObj.radius];
            
            if ([locObj.selectAlertType isEqualToString:@"inComing"]) {
                _incomingOutgoingSegment.selectedSegmentIndex=0;
                
            }
            else
            {
                _incomingOutgoingSegment.selectedSegmentIndex=1;
            }
            
            NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init] ;
            [dateFormatter setDateFormat:@"dd/MM/yyyy"];
            self.fromDate=locObj.date_fromDate;
            self.Todate=locObj.date_Todate;
            fromDateTextfield.text=[NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:locObj.date_fromDate]];
            toDatetextfield.text=[NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:locObj.date_Todate]];
            
            activityView.hidden = NO;
            break;
            
        }
        
        
        
        
        
    }

    
}
-(void)pauseAnnotationAction:(id)sender
{
    

    for (int i=0; i<self.ary_loc.count; i++) {
        
        locationModel *locObj = [self.ary_loc objectAtIndex:i];
        
        NSLog(@"\n%f\n%f",[[NSString stringWithFormat:@"%f",locObj.locPoint.latitude] floatValue],[[NSString stringWithFormat:@"%f",locObj.locPoint.longitude] floatValue]);
        NSLog(@"\n%f\n%f",[[NSString stringWithFormat:@"%f",_annotationCoordinates.latitude] floatValue],[[NSString stringWithFormat:@"%f",_annotationCoordinates.longitude] floatValue]);
        
        if (locObj.str_Name ==_annotationTitle && [locObj.str_Desc isEqualToString:_annotationSubtitle] && [[NSString stringWithFormat:@"%f",locObj.locPoint.latitude] floatValue] ==  [[NSString stringWithFormat:@"%f",_annotationCoordinates.latitude] floatValue] && [[NSString stringWithFormat:@"%f",locObj.locPoint.longitude] floatValue] == [[NSString stringWithFormat:@"%f",_annotationCoordinates.longitude] floatValue] ) {
            
            
            NSString *startPauseStatus=nil;
            if ([locObj.startPauseStatus isEqualToString:@"0"]) {
                
                startPauseStatus = @"1";
            }
            else
            {
                startPauseStatus = @"0";
            }
            
            NSDictionary *dicTosave = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:locObj.str_Name,locObj.str_Desc,locObj.str_LatLong,locObj.str_entered,locObj.str_currntLoc,[NSString stringWithFormat:@"%.f",locObj.radius],locObj.date_fromDate,locObj.date_Todate,startPauseStatus,locObj.alertStatus,locObj.selectAlertType,nil] forKeys:[NSArray arrayWithObjects:@"name",@"desc",@"latLong",@"enter",@"currntLoc",@"radius",@"date_fromDate",@"date_ToDate",@"startPauseStatus",@"alertStatus",@"selectAlertType",nil]];
            
            [[AppDelegate sharedDelegate] refreshUD:self.ary_loc];
            [[AppDelegate sharedDelegate] replaceLocationInUD:dicTosave index:i];
            self.ary_loc = [NSArray arrayWithArray:[AppDelegate sharedDelegate].fetchLocationsFromUD];
            [self startLocationManager];
            [self reloadPinsAfterEdit];
                break;
            
        }
        
        
        
        
        
    }

    
    
}
-(void)deleteAnnotationAction:(id)sender
{
    
        for (int i=0; i<self.ary_loc.count; i++) {
            
            locationModel *locObj = [self.ary_loc objectAtIndex:i];
            NSLog(@"\n%f\n%f",[[NSString stringWithFormat:@"%f",locObj.locPoint.latitude] floatValue],[[NSString stringWithFormat:@"%f",locObj.locPoint.longitude] floatValue]);
            NSLog(@"\n%f\n%f",[[NSString stringWithFormat:@"%f",_annotationCoordinates.latitude] floatValue],[[NSString stringWithFormat:@"%f",_annotationCoordinates.longitude] floatValue]);
            
          if (locObj.str_Name ==_annotationTitle && [locObj.str_Desc isEqualToString:_annotationSubtitle] && [[NSString stringWithFormat:@"%f",locObj.locPoint.latitude] floatValue] ==  [[NSString stringWithFormat:@"%f",_annotationCoordinates.latitude] floatValue] && [[NSString stringWithFormat:@"%f",locObj.locPoint.longitude] floatValue] == [[NSString stringWithFormat:@"%f",_annotationCoordinates.longitude] floatValue] ){
                
                selectedIndex = i;
                locationModel *locObj = [self.ary_loc objectAtIndex:i];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete Location" message:[NSString stringWithFormat:@"Do you want to delete \"%@\"",locObj.str_Name] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];
                alert.tag = 8880;
                [alert show];
                break;
            }
            
            

        

    }
    
 
    
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    if(!currentLoc)
        return;
    
    NSMutableArray * annotationsToRemove = [ _myMap.annotations mutableCopy ] ;
    for(MKUserLocation *loc in annotationsToRemove)
    {
        
        
        if([loc isKindOfClass:[MKUserLocation class]])
        {
            
        }
        else
        {
            CLLocationCoordinate2D centerCoor = [self getCenterCoordinate];
            // init center location from center coordinate
            CLLocation *centerLocation = [[CLLocation alloc] initWithLatitude:centerCoor.latitude longitude:centerCoor.longitude];
            
            CLLocationCoordinate2D MyAnnotationsCordinates;
            
            MyAnnotationsCordinates.latitude=loc.coordinate.latitude;
            MyAnnotationsCordinates.longitude=loc.coordinate.longitude;
            CLLocation *topCenterLocation = [[CLLocation alloc] initWithLatitude:MyAnnotationsCordinates.latitude longitude:MyAnnotationsCordinates.longitude];
            
            CLLocationDistance radius = [centerLocation distanceFromLocation:topCenterLocation];
            
            NSLog(@"%f",radius);
            
            
            NSString *str_lat1 = [NSString stringWithFormat:@"%f",ctrpoint.latitude];
            NSString *str_long1 = [NSString stringWithFormat:@"%f",ctrpoint.longitude];
            NSString *str_lat2 = [NSString stringWithFormat:@"%f",loc.coordinate.latitude];
            NSString *str_long2 = [NSString stringWithFormat:@"%f",loc.coordinate.longitude];
            
            //            if([str_lat1 isEqualToString:str_lat2] && [str_long1 isEqualToString:str_long2])
            //            {
            //                id<MKAnnotation> myAnnotation = loc;
            //
            //                [_myMap selectAnnotation:myAnnotation animated:YES];
            //                break;
            //            }
        }
        
        
    }
    
    
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    
    
    
}

//Draw Polyline from Destination to current distance
-(void)drawPolyline:(CLLocationCoordinate2D )currentLocation destination:(CLLocationCoordinate2D )destinationLocation
{
    
    
    
    [_myMap removeOverlays:_myMap.overlays];
    NSString *baseUrl = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/directions/json?origin=%f,%f&destination=%f,%f&sensor=true&mode=walking",currentLocation.latitude,currentLocation.longitude,destinationLocation.latitude,destinationLocation.longitude];
    
    
    //http://maps.googleapis.com/maps/api/directions/json?origin=23.030000,72.580000&destination=23.400000,72.750000&sensor=true
    
    NSURL *url = [NSURL URLWithString:[baseUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSLog(@"%@",url);
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSError *error = nil;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        NSArray *routes = [result objectForKey:@"routes"];
        NSLog(@"%@",routes);
        
        if (!routes.count)
        {
            return;
        }
            
        
        NSDictionary *firstRoute = [routes objectAtIndex:0];
        
        NSDictionary *leg =  [[firstRoute objectForKey:@"legs"] objectAtIndex:0];
        
        NSDictionary *end_location = [leg objectForKey:@"end_location"];
        
//        NSLog(@"dDDDDDD>>>>>>%@",leg);
//        double latitude = [[end_location objectForKey:@"lat"] doubleValue];
//        double longitude = [[end_location objectForKey:@"lng"] doubleValue];
//        
//        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
//        
//        MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
//        point.coordinate = coordinate;
//        point.title =  [leg objectForKey:@"end_address"];
//        point.subtitle = @"I'm here!!!";
//        
//        [self.mapview addAnnotation:point];
        
        NSArray *steps = [leg objectForKey:@"steps"];
        
        int stepIndex = 0;
        
        CLLocationCoordinate2D stepCoordinates[1  + [steps count] + 1];
        
        stepCoordinates[stepIndex] = currentLocation;
        
        for (NSDictionary *step in steps) {
            
            NSDictionary *start_location = [step objectForKey:@"start_location"];
            stepCoordinates[++stepIndex] = [self coordinateWithLocation:start_location];
            
            if ([steps count] == stepIndex){
                NSDictionary *end_location = [step objectForKey:@"end_location"];
                stepCoordinates[++stepIndex] = [self coordinateWithLocation:end_location];
            }
        }
        
        MKPolyline *polyLine = [MKPolyline polylineWithCoordinates:stepCoordinates count:1 + stepIndex];
        [_myMap addOverlay:polyLine];
        //[self zoomToPolyLine:_myMap polyline:polyLine animated:YES];
        [_myMap showsUserLocation];
    }];
   
}
- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{

    MKPolylineView *polylineView = [[MKPolylineView alloc] initWithPolyline:overlay];
    polylineView.strokeColor = [UIColor colorWithRed:204/255. green:45/255. blue:70/255. alpha:1.0];
    polylineView.lineWidth = 4;
    
    return polylineView;
}
//-(void)zoomToPolyLine: (MKMapView*)map polyline: (MKPolyline*)polyline animated: (BOOL)animated
//{
//    [map setVisibleMapRect:[polyline boundingMapRect] edgePadding:UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0) animated:animated];
//}

- (CLLocationCoordinate2D)coordinateWithLocation:(NSDictionary*)location
{
    double latitude = [[location objectForKey:@"lat"] doubleValue];
    double longitude = [[location objectForKey:@"lng"] doubleValue];
    
    return CLLocationCoordinate2DMake(latitude, longitude);
}
-(void)mapLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
        return;
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self.myMap];
    ctrpoint = [self.myMap convertPoint:touchPoint toCoordinateFromView:self.myMap];
    mapPoints =[self.myMap convertPoint:touchPoint toCoordinateFromView:self.myMap];
    
   
        txt_activity.text = @"";
        txt_desc.text = @"";
        radiusTextfield.text=@"";
        fromDateTextfield.text=@"From Date";
        toDatetextfield.text=@"To Date";
    
    view_back.hidden = NO;
    activityView.hidden = NO;
    NSLog(@"Location found from Map: %f %f",[self.myMap convertPoint:touchPoint toCoordinateFromView:self.myMap].latitude,[self.myMap convertPoint:touchPoint toCoordinateFromView:self.myMap].longitude);
}



- (IBAction)Callclicked:(id)sender {
    NSString *phoneNumber = [@"tel://" stringByAppendingString:@"8886541959"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
}

-(void)reloadPinsAfterEdit
{
    self.ary_loc = [NSArray arrayWithArray:[AppDelegate sharedDelegate].fetchLocationsFromUD];
    [self performSelector:@selector(dropPin:) withObject:nil afterDelay:0];
}

- (IBAction)action_DoneActivity:(id)sender
{
    NSString *selectRadiusType = nil;
    
    if ([_incomingOutgoingSegment selectedSegmentIndex]==0) {
        
        selectRadiusType=@"inComing";
    }
    else
    {
        selectRadiusType=@"outGoing";
        
    }
 
    
   if(txt_activity.text.length > 0 && txt_desc.text.length > 0 && radiusTextfield.text.length > 0 && ![fromDateTextfield.text isEqualToString:@"From Date"] && ![toDatetextfield.text isEqualToString:@"To Date"])
   {

       [txt_activity resignFirstResponder];
       [radiusTextfield resignFirstResponder];
       [txt_desc resignFirstResponder];
       
       
       
       if(editing)
       {
           activityView.hidden = YES;
           editing = NO;
           oldUserLocation=nil;

//           locationModel *locObj = [self.ary_loc objectAtIndex:deleteIndex];
//           
//           NSDictionary *dicTosave = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:txt_activity.text,txt_desc.text,locObj.str_LatLong,locObj.str_entered,locObj.str_currntLoc,[NSString stringWithFormat:@"%@",radiusTextfield.text],_fromDate,_Todate,locObj.startPauseStatus,locObj.alertStatus,selectRadiusType, nil] forKeys:[NSArray arrayWithObjects:@"name",@"desc",@"latLong",@"enter",@"currntLoc",@"radius",@"date_fromDate",@"date_ToDate",@"startPauseStatus",@"alertStatus",@"selectAlertType",nil]];
//           
//           [[AppDelegate sharedDelegate] refreshUD:self.ary_loc];
//           [[AppDelegate sharedDelegate] replaceLocationInUD:dicTosave index:deleteIndex];
//           self.ary_loc = [NSArray arrayWithArray:[AppDelegate sharedDelegate].fetchLocationsFromUD];
//           [tblView reloadData];
//           
           
           
           
           locationModel *locObj = [self.ary_loc objectAtIndex:selectedIndex];
           
           NSDictionary *dicTosave = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:txt_activity.text,txt_desc.text,locObj.str_LatLong,locObj.str_entered,locObj.str_currntLoc,[NSString stringWithFormat:@"%.f",[radiusTextfield.text floatValue]],_fromDate,_Todate,locObj.startPauseStatus,@"start",selectRadiusType,nil] forKeys:[NSArray arrayWithObjects:@"name",@"desc",@"latLong",@"enter",@"currntLoc",@"radius",@"date_fromDate",@"date_ToDate",@"startPauseStatus",@"alertStatus",@"selectAlertType",nil]];
           
           [[AppDelegate sharedDelegate] refreshUD:self.ary_loc];
           [[AppDelegate sharedDelegate] replaceLocationInUD:dicTosave index:selectedIndex];
           self.ary_loc = [NSArray arrayWithArray:[AppDelegate sharedDelegate].fetchLocationsFromUD];
           [[NSNotificationCenter defaultCenter] postNotificationName:reloadPinsOnMap object:nil userInfo:nil];
           activityView.hidden = YES;
           


       }
       else
       {
           
           NSArray *ListOfProducts=[NSArray arrayWithArray:[AppDelegate sharedDelegate].FetchPruchasedProductsFromUD];
           
           for (NSString *Product_ID in ListOfProducts) {
               
               if ([Product_ID isEqualToString:@"com.Remindme.here.Tier1"]) {
                   
                  LOC_COUNT = 10;
                   
               }
               else if ([Product_ID isEqualToString:@"com.Remindme.here.Tier2"])
               {
                   
                   LOC_COUNT=20;
               }
               else if ([Product_ID isEqualToString:@"com.Remindme.here.Tier3"])
               {
                   LOC_COUNT = (int)self.ary_loc.count+1;
                   
               }
               
           }
           
           
           if(self.ary_loc.count < LOC_COUNT)
           {
               view_back.hidden = YES;
               activityView.hidden = YES;
               oldUserLocation=nil;
               NSString *str_latLong = [NSString stringWithFormat:@"%f,%f",mapPoints.latitude,mapPoints.longitude];
               NSDictionary *dicTosave = nil;
               
               NSLog(@"%i",(int)[_incomingOutgoingSegment selectedSegmentIndex]);
               if(chkForCurrntLoc)
                   dicTosave = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:txt_activity.text,txt_desc.text,str_latLong,@"1",@"1",[NSString stringWithFormat:@"%@",radiusTextfield.text],self.fromDate,self.Todate,@"0",@"start",selectRadiusType,nil] forKeys:[NSArray arrayWithObjects:@"name",@"desc",@"latLong",@"enter",@"currntLoc",@"radius",@"date_fromDate",@"date_ToDate",@"startPauseStatus",@"alertStatus",@"selectAlertType", nil]];
               else
                   dicTosave = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:txt_activity.text,txt_desc.text,str_latLong,@"0",@"0",[NSString stringWithFormat:@"%@",radiusTextfield.text],self.fromDate,self.Todate,@"0",@"start",selectRadiusType ,nil] forKeys:[NSArray arrayWithObjects:@"name",@"desc",@"latLong",@"enter",@"currntLoc",@"radius",@"date_fromDate",@"date_ToDate",@"startPauseStatus",@"alertStatus",@"selectAlertType",nil]];
               [[AppDelegate sharedDelegate] refreshUD:self.ary_loc];
               
               [[AppDelegate sharedDelegate] insertLocationsToUD:dicTosave];
               self.ary_loc = [NSArray arrayWithArray:[AppDelegate sharedDelegate].fetchLocationsFromUD];
               [self performSelector:@selector(dropPin:) withObject:nil afterDelay:0];
           }
           else
           {
               
               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please Pay For Extra Reminder" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
               alert.tag=1;
               [alert show];
               
              
           }
       }
       
       
   }
    else
    {
        if(txt_activity.text.length == 0)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please Enter Activity Name!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            [txt_activity becomeFirstResponder];
        }
        else if(txt_desc.text.length == 0)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please Enter Description Name!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            [txt_desc becomeFirstResponder];
        }
        else if(radiusTextfield.text.length == 0)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please Enter Radius" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            [radiusTextfield becomeFirstResponder];
        }
        else if([fromDateTextfield.text isEqualToString:@"From Date"])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please Select From Date" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
           
        }
        else if([toDatetextfield.text isEqualToString:@"To Date"])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please Select To Date" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            
        }
        
        
    }
    
    if(chkForCurrntLoc)
        chkForCurrntLoc = NO;
    
}
- (IBAction)IncomingOutgoingAction:(id)sender
{
    
    NSLog(@"%li",(long)[_incomingOutgoingSegment selectedSegmentIndex]);
   
    UIColor *selectedColor = [UIColor colorWithRed: 0/255.0 green:144/255.0 blue:81/255.0 alpha:1.0];
    
    UIColor *deselectedColor = [UIColor colorWithRed: 54/255.0 green:52/255.0 blue:48/255.0 alpha:1.0];
    
    for (UIControl *subview in [_incomingOutgoingSegment subviews]) {
        if ([subview isSelected])
            [subview setTintColor:selectedColor];
        else
            [subview setTintColor:deselectedColor];
    }
    _incomingOutgoingSegment.tintColor=selectedColor;
    
   
}

- (IBAction)action_cancelActivity:(id)sender
{
    if(editing)
        editing = NO;
    else
    {
       view_back.hidden = YES;
    }
    [txt_activity resignFirstResponder];
    [txt_desc resignFirstResponder];
    txt_activity.text = @"";
    txt_desc.text = @"";
    radiusTextfield.text=@"";
    fromDateTextfield.text=@"From Date";
    toDatetextfield.text=@"To Date";
    activityView.hidden = YES;
    
}

- (IBAction)dropPin:(id)sender
{
    currentLoc = YES;
    
    [self showPinsOnViewDidLoad];
    
   
}


#pragma mark alertStatus
-(void)alertStatus:(NSString *)status cordinates:(NSString *)cordinate name:(NSString *)name radius:(float)radius
{
    
    
    for (int i=0; i<self.ary_loc.count; i++) {
        
        locationModel *locObj = [self.ary_loc objectAtIndex:i];
        
        
        if (locObj.radius ==radius && [locObj.str_Name isEqualToString:name] && [locObj.str_LatLong isEqualToString:cordinate] ) {
            
            NSDictionary *dicTosave = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:locObj.str_Name,locObj.str_Desc,locObj.str_LatLong,locObj.str_entered,locObj.str_currntLoc,[NSString stringWithFormat:@"%.f",locObj.radius],locObj.date_fromDate,locObj.date_Todate,locObj.startPauseStatus,status,locObj.selectAlertType,nil] forKeys:[NSArray arrayWithObjects:@"name",@"desc",@"latLong",@"enter",@"currntLoc",@"radius",@"date_fromDate",@"date_ToDate",@"startPauseStatus",@"alertStatus",@"selectAlertType",nil]];
            
            [[AppDelegate sharedDelegate] refreshUD:self.ary_loc];
            [[AppDelegate sharedDelegate] replaceLocationInUD:dicTosave index:i];
            self.ary_loc = [NSArray arrayWithArray:[AppDelegate sharedDelegate].fetchLocationsFromUD];
           
        }
        
       
        
    }
 
   
}


- (CLLocationCoordinate2D)getCenterCoordinate
{
    CLLocationCoordinate2D centerCoor;
    centerCoor.latitude=ctrpoint.latitude;
    centerCoor.longitude=ctrpoint.longitude;
    return centerCoor;
}



//For Enter Street Address View
- (IBAction)action_CancelDoneActivity:(id)sender
{
   if([sender tag] == 1) //Cancel Pressed
   {
       [txt_streetAdd resignFirstResponder];
       [self RowTapped:0];
   }
    
    else if ([sender tag] == 2)// Done Pressed
    {
        if(txt_streetAdd.text.length > 0)
        {
            [txt_streetAdd resignFirstResponder];
            view_activityIndicator.hidden = NO;
            activityIndicator.hidden = NO;
            
            NSString *str_stableAdd = [txt_streetAdd.text stringByReplacingOccurrencesOfString:@" " withString:@"+"];
            NSString *str_url = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?address=%@&sensor=false", [str_stableAdd stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            
            NSURLRequest *theRequest =
            [NSURLRequest requestWithURL:[NSURL URLWithString:str_url]
                             cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                         timeoutInterval:10.0];
            
            NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
            [theConnection start];
            txt_streetAdd.text = @"";
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please Enter Address!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    }
    
    
}
#pragma mark NSURLConnection methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if(!receivedData)
        receivedData = [[NSMutableData alloc] init];
    [receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    view_activityIndicator.hidden = YES;
    activityIndicator.hidden = YES;
    UIAlertView *didFailWithErrorMessage = [[UIAlertView alloc] initWithTitle: @"Connection Failure " message: [error localizedDescription]  delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
    [didFailWithErrorMessage show];
    [didFailWithErrorMessage release];
	
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError *e = nil;
    
    NSLog(@"NSDAta - %@", [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding]);
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData: receivedData options: NSJSONReadingMutableContainers error: &e];
    
    if (!jsonDic)
    {
        view_activityIndicator.hidden = YES;
        activityIndicator.hidden = YES;
        NSLog(@"Error parsing JSON: %@", e);
    }
    else
    {
        if([[jsonDic objectForKey:@"status"] isEqualToString:@"ZERO_RESULTS"])
        {
            view_activityIndicator.hidden = YES;
            activityIndicator.hidden = YES;
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Location not found!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
        else
        {
            if(view_streetAdd.hidden == NO)
            {
                view_activityIndicator.hidden = YES;
                activityIndicator.hidden = YES;
                
                [self hideTheAddressFromConnection];
                
                NSArray *ary_Result = [jsonDic objectForKey:@"results"];
                NSDictionary *dic_temp = [ary_Result objectAtIndex:0];
                NSDictionary *dic_temp2 = [dic_temp objectForKey:@"geometry"];
                NSDictionary *dic_temp3 = [dic_temp2 objectForKey:@"location"];
                NSString *str_lat = [dic_temp3 objectForKey:@"lat"];
                NSString *str_long = [dic_temp3 objectForKey:@"lng"];
                
                ctrpoint.latitude = str_lat.doubleValue;
                ctrpoint.longitude = str_long.doubleValue;
                
                //Code to remove allready placed annotations
//                NSMutableArray * annotationsToRemove = [ _myMap.annotations mutableCopy ] ;
//                [ annotationsToRemove removeObject:_myMap.userLocation ] ;
//                [ _myMap removeAnnotations:annotationsToRemove ] ;
                //////////
                
                
                view_back.hidden = NO;
                activityView.hidden = NO;
                
                
                
                //[self performSelector:@selector(dropPin:) withObject:nil afterDelay:0];
            }
            
            
            
        }
    }
}
-(void)hideTheAddressFromConnection
{
    if(!view_streetAdd.hidden)
    {
        txt_streetAdd.text = @"";
        [UIView animateWithDuration:.50
                         animations:^
         {
             
             CGRect frame= view_streetAdd.frame;
             frame.origin.y = -128;
             view_streetAdd.frame = frame;
             
         }
                         completion:^(BOOL finished)
         {
             //view_back.hidden = YES;
             view_streetAdd.hidden = YES;
         }];
    }
}
-(void)logoClicked
{
    editing= NO;
    [self action_cancelActivity:nil];
    [self hideTheAddressFromConnection];
    RemindMeHereVC *remindObj = [[RemindMeHereVC alloc] init];
    [self presentViewController:remindObj animated:YES completion:^
    {
        remindObj.delegate = self;
    }];

}

- (IBAction)action_existingLoc:(id)sender
{
    [tblView reloadData];
    tblView.hidden = NO;
    view_enterAdd.hidden = YES;
    view_btns.hidden = YES;
    [btn_existingLoc setBackgroundColor:[UIColor redColor]];
    [btn_newLoc setBackgroundColor:[UIColor darkGrayColor]];
}

- (IBAction)action_newLoc:(id)sender
{
    //[tblView reloadData];
    tblView.hidden = YES;
    view_enterAdd.hidden = YES;
    view_btns.hidden = NO;
    [btn_existingLoc setBackgroundColor:[UIColor darkGrayColor]];
    [btn_newLoc setBackgroundColor:[UIColor redColor]];
}

- (IBAction)action_useCurrLoc:(id)sender
{
    if (locationManager.location.coordinate.longitude !=0.000000 && locationManager.location.coordinate.latitude !=0.000000 ) {
       
        ctrpoint = locationManager.location.coordinate;
        
        NSLog(@"%f \n %f ",ctrpoint.longitude,ctrpoint.latitude);

        ctrpoint.longitude=ctrpoint.longitude+.005;
        ctrpoint.latitude=ctrpoint.latitude+.005;
        
        NSLog(@"%f \n %f ",ctrpoint.longitude,ctrpoint.latitude);

        view_activityIndicator.hidden = YES;
        activityIndicator.hidden = YES;
        
        [self hideTheAddressFromConnection];
        
        view_back.hidden = NO;
        activityView.hidden = NO;
        chkForCurrntLoc = YES;
     
    }
    
   
    
    
   // UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Under Construction" message:@"" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
   // [alert show];
}

- (IBAction)action_enterAddress:(id)sender
{
    btn_existingLoc.hidden = YES;
    btn_newLoc.hidden = YES;
    view_btns.hidden = YES;
    view_enterAdd.hidden = NO;
}


#pragma mark Date Action Method
- (IBAction)fromDateAction:(id)sender {
    
    checkDatePicker=YES;
    [self datePicker:[NSDate date]];
    toDatetextfield.text=@"To Date";
    
    
}

- (IBAction)toDateAction:(id)sender {
    
    if ([fromDateTextfield.text isEqualToString:@"From Date"]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please Select From date First" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
         [alert show];
        return;
    }
    checkDatePicker=NO;
    [self datePicker:self.fromDate];

    
    
}

-(void)datePicker:(NSDate *)fromDate
{
    
    [txt_activity resignFirstResponder];
    [txt_desc resignFirstResponder];
    [radiusTextfield resignFirstResponder];
    pickerSuperView.hidden=NO;
    float y=datePickerSuperView.frame.origin.y;
    datePickerSuperView.frame=CGRectMake(datePickerSuperView.frame.origin.x, self.view.frame.size.height, datePickerSuperView.frame.size.width, datePickerSuperView.frame.size.height);
    [UIView animateWithDuration:.4
                     animations:^
     {
         
         CGRect frame= datePickerSuperView.frame;
         frame.origin.y = y;
         datePickerSuperView.frame = frame;
         
         
     }
                     completion:^(BOOL finished)
     {
         
         
         
     }];
   
    [datePicker setMinimumDate:fromDate];
    [datePicker setDate:fromDate];
    [datePicker setDatePickerMode:UIDatePickerModeDateAndTime];
    datePicker.hidden=NO;
    datePickerSuperView.hidden=NO;
    
}

-(IBAction)addDateAndCancelAction:(UIButton *)sender
{
    
    if (sender.tag==1) {
        //Add Date Action
        NSDate* date = [datePicker date];
        
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init] ;
        [dateFormatter setDateFormat:@"dd/MM/yyyy"];
        //[dateFormatter setDateStyle:NSDateFormatterShortStyle];
       
        if (checkDatePicker==YES) {
            self.fromDate=[datePicker date];
            fromDateTextfield.text=[NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:date]];
      
            
            
        }
        else
        {
            
            self.Todate=[datePicker date];
             toDatetextfield.text=[NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:date]];
            [dateFormatter setDateFormat:@"dd:MM:yyyy hh:mm"];
      
            
        }
       

    }
    
    datePickerSuperView.hidden=YES;
    datePicker.hidden=YES;
    pickerSuperView.hidden=YES;

}
#pragma mark UITextFieldDelgates
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if (textField == txt_activity) {
        [txt_desc becomeFirstResponder];
        
    }
    else if(textField == txt_desc)
    {
        [radiusTextfield becomeFirstResponder];
        
    }else if(textField == radiusTextfield)
    {
        [radiusTextfield resignFirstResponder];
        
    }
    return YES;
}


-(void)cancelNumberPad{
    [radiusTextfield resignFirstResponder];
    radiusTextfield.text = @"";
}

-(void)doneWithNumberPad{
   
    [radiusTextfield resignFirstResponder];
}
#pragma mark UIAlertViewDelagte
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1) {
        
        if (buttonIndex==1) {
            
            [self RowTapped:5];
        }
        
        
    }
   else if(alertView.tag == 888)
    {
       [self.audioController stopTheSound];
    }
    else if(alertView.tag == 8880)
    {
        
        if (buttonIndex==0) {
            return;
        }
        NSMutableArray * annotationsToRemove = [ _myMap.annotations mutableCopy ] ;
        NSMutableArray *ary_PinCollectionToDelete = [NSMutableArray new];
        //[ annotationsToRemove removeObject:_myMap.userLocation ] ;
        for(MKUserLocation *loc in annotationsToRemove)
        {
            if([loc isKindOfClass:[MKUserLocation class]])
            {
                
            }
            else
            {
                
                CLLocationCoordinate2D  PointToDelete =((locationModel*) [self.ary_loc objectAtIndex:selectedIndex]).locPoint;
//                CLLocation *DeleteLoc = [[CLLocation alloc] initWithLatitude:PointToDelete.latitude longitude:PointToDelete.longitude];
//                CLLocation *DeleteLoc2 = [[CLLocation alloc] initWithLatitude:loc.coordinate.latitude longitude:loc.coordinate.latitude];
//                CLLocationDistance distance = [DeleteLoc distanceFromLocation:DeleteLoc2];
                
                
                NSString *str_lat1 = [NSString stringWithFormat:@"%f",PointToDelete.latitude];
                NSString *str_long1 = [NSString stringWithFormat:@"%f",PointToDelete.longitude];
                NSString *str_lat2 = [NSString stringWithFormat:@"%f",loc.coordinate.latitude];
                NSString *str_long2 = [NSString stringWithFormat:@"%f",loc.coordinate.longitude];

                if([str_lat1 isEqualToString:str_lat2] && [str_long1 isEqualToString:str_long2])
                {
                    [ary_PinCollectionToDelete addObject:loc];
                }
                
                
                
//                if(distance == 0)
//                {
//                    [ary_PinCollectionToDelete addObject:loc];
//                }
//                else
//                {
//                    //[ annotationsToRemove removeObject:loc ] ;
//                }
            }
            
        }
        [ _myMap removeAnnotations:ary_PinCollectionToDelete ] ;
        
        
        
        [[AppDelegate sharedDelegate] refreshUD:self.ary_loc];
        [[AppDelegate sharedDelegate] DeleteLocationToUD:selectedIndex];
        self.ary_loc = [NSArray arrayWithArray:[AppDelegate sharedDelegate].fetchLocationsFromUD];
        [self startLocationManager];
        if (!self.ary_loc.count) {
            
            [self RowTapped:0];
            firstTimeZoom=YES;
            [self ZoomOnMap];

        }
        [tblView reloadData];
    }
}
-(void)startLocationManager
{
 
    locationManager=[[CLLocationManager alloc]init];
    
      NSUInteger Status = [CLLocationManager authorizationStatus];
    if (Status == kCLAuthorizationStatusNotDetermined && ([MKMapView respondsToSelector:@selector(requestAlwaysAuthorization)])) {
        if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationAlwaysUsageDescription"]){
            [locationManager requestAlwaysAuthorization];
            
        }
    }
   
    locationManager.distanceFilter=kCLHeadingFilterNone;//// whenever we move
    locationManager.desiredAccuracy=kCLLocationAccuracyThreeKilometers;//// 100 meter
    [locationManager setDelegate:self];
    [locationManager startUpdatingLocation];
    locationManager.allowsBackgroundLocationUpdates = YES;
  
    if(IS_OS_8_OR_LATER)
    {
        [locationManager requestWhenInUseAuthorization];
        [locationManager requestAlwaysAuthorization];
    }
   
 
}


#pragma mark iAD helper Methods
- (int)getBannerHeight:(UIDeviceOrientation)orientation {
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        return 32;
    } else {
        return 50;
    }
}

- (int)getBannerHeight {
    return [self getBannerHeight:[UIDevice currentDevice].orientation];
}

- (void)createAdBannerView {
    Class classAdBannerView = NSClassFromString(@"ADBannerView");
    if (classAdBannerView != nil) {
        self.adBannerView = [[[classAdBannerView alloc]
                              initWithFrame:CGRectZero] autorelease];
//        [_adBannerView setRequiredContentSizeIdentifiers:[NSSet setWithObjects: ADBannerContentSizeIdentifier320x50,ADBannerContentSizeIdentifier480x32, nil]];
//        if (UIInterfaceOrientationIsLandscape([UIDevice currentDevice].orientation))
//        {
//            [_adBannerView setCurrentContentSizeIdentifier: ADBannerContentSizeIdentifier480x32];
//        }
//        else
//        {
//            [_adBannerView setCurrentContentSizeIdentifier: ADBannerContentSizeIdentifier320x50];
//        }
        [_adBannerView setFrame:CGRectOffset([_adBannerView frame], 0,
                                             -[self getBannerHeight])];
        [_adBannerView setDelegate:self];
        
        [self.view addSubview:_adBannerView];        
    }
}
- (void)fixupAdView:(UIInterfaceOrientation)toInterfaceOrientation {
    if (_adBannerView != nil)
    {
//        if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation))
//        {
//            [_adBannerView setCurrentContentSizeIdentifier:ADBannerContentSizeIdentifier480x32];
//        } else {
//            [_adBannerView setCurrentContentSizeIdentifier:ADBannerContentSizeIdentifier320x50];
//        }
        [UIView beginAnimations:@"fixupViews" context:nil];
        if (_adBannerViewIsVisible)
        {
            CGRect adBannerViewFrame = [_adBannerView frame];
            adBannerViewFrame.origin.x = 0;
            adBannerViewFrame.origin.y = 64;
            [_adBannerView setFrame:adBannerViewFrame];
            CGRect contentViewFrame = _contentView.frame;
            contentViewFrame.origin.y =
            [self getBannerHeight:toInterfaceOrientation];
            contentViewFrame.size.height = self.view.frame.size.height -
            [self getBannerHeight:toInterfaceOrientation];
            _contentView.frame = contentViewFrame;
        } else
        {
            CGRect adBannerViewFrame = [_adBannerView frame];
            adBannerViewFrame.origin.x = 0;
            adBannerViewFrame.origin.y =
            -[self getBannerHeight:toInterfaceOrientation];
            [_adBannerView setFrame:adBannerViewFrame];
            CGRect contentViewFrame = _contentView.frame;
            contentViewFrame.origin.y = 0;
            contentViewFrame.size.height = self.view.frame.size.height;
            _contentView.frame = contentViewFrame;
        }
        [UIView commitAnimations];
    }
}
#pragma mark ADBannerViewDelegate

- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
    if (!_adBannerViewIsVisible)
    {
        _adBannerViewIsVisible = YES;
        [self fixupAdView:[UIDevice currentDevice].orientation];
    }
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    if (_adBannerViewIsVisible)
    {
        _adBannerViewIsVisible = NO;
        [self fixupAdView:[UIDevice currentDevice].orientation];
    }
}

# pragma mark UITableview Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.ary_loc count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"existingLocCell";
    
    existingLocCell *cell = (existingLocCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = (existingLocCell *)[nib objectAtIndex:0];
    }
    
    if(indexPath.row%2 == 0)
        cell.contentView.backgroundColor = [UIColor whiteColor];
    else
        cell.contentView.backgroundColor = [UIColor lightGrayColor];
    
    locationModel *locObj = [self.ary_loc objectAtIndex:indexPath.row];
    cell.lbl_locName.text = locObj.str_Name;
    cell.btn_edit.tag = indexPath.row;
    cell.btn_delete.tag = indexPath.row;
    
    [cell.btn_edit addTarget:self action:@selector(editAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.btn_delete addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)editAction:(id)sender
{
    editing = YES;
    UIButton *editbtn = (UIButton *)sender;
    selectedIndex = (int)editbtn.tag;
    locationModel *locObj = [self.ary_loc objectAtIndex:editbtn.tag];
    txt_activity.text = locObj.str_Name;
    txt_desc.text = locObj.str_Desc;
    radiusTextfield.text=[NSString stringWithFormat:@"%.f",locObj.radius];
    
    if ([locObj.selectAlertType isEqualToString:@"inComing"]) {
        _incomingOutgoingSegment.selectedSegmentIndex=0;
        
    }
    else
    {
        _incomingOutgoingSegment.selectedSegmentIndex=1;
    }
      
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init] ;
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    self.fromDate=locObj.date_fromDate;
    self.Todate=locObj.date_Todate;
    fromDateTextfield.text=[NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:locObj.date_fromDate]];
    toDatetextfield.text=[NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:locObj.date_Todate]];
    
    activityView.hidden = NO;
}
-(void)deleteAction:(id)sender
{
    UIButton *deletebtn = (UIButton *)sender;
    selectedIndex = (int)deletebtn.tag;
    locationModel *locObj = [self.ary_loc objectAtIndex:deletebtn.tag];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete Location" message:[NSString stringWithFormat:@"Do you want to delete \"%@\"",locObj.str_Name] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];
    alert.tag = 8880;
    [alert show];
    
}

#pragma mark Method Call From Reminder View
-(void)deleteAnotationFromRemindView:(int)deleteIndexFromRemind
{
    
    NSMutableArray * annotationsToRemove = [ _myMap.annotations mutableCopy ] ;
    NSMutableArray *ary_PinCollectionToDelete = [NSMutableArray new];
    //[ annotationsToRemove removeObject:_myMap.userLocation ] ;
    for(MKUserLocation *loc in annotationsToRemove)
    {
        if([loc isKindOfClass:[MKUserLocation class]])
        {
            
        }
        else
        {
            
            CLLocationCoordinate2D  PointToDelete =((locationModel*) [self.ary_loc objectAtIndex:deleteIndexFromRemind]).locPoint;
            //                CLLocation *DeleteLoc = [[CLLocation alloc] initWithLatitude:PointToDelete.latitude longitude:PointToDelete.longitude];
            //                CLLocation *DeleteLoc2 = [[CLLocation alloc] initWithLatitude:loc.coordinate.latitude longitude:loc.coordinate.latitude];
            //                CLLocationDistance distance = [DeleteLoc distanceFromLocation:DeleteLoc2];
            
            
            NSString *str_lat1 = [NSString stringWithFormat:@"%f",PointToDelete.latitude];
            NSString *str_long1 = [NSString stringWithFormat:@"%f",PointToDelete.longitude];
            NSString *str_lat2 = [NSString stringWithFormat:@"%f",loc.coordinate.latitude];
            NSString *str_long2 = [NSString stringWithFormat:@"%f",loc.coordinate.longitude];
            
            if([str_lat1 isEqualToString:str_lat2] && [str_long1 isEqualToString:str_long2])
            {
                [ary_PinCollectionToDelete addObject:loc];
            }
            
            
            
            //                if(distance == 0)
            //                {
            //                    [ary_PinCollectionToDelete addObject:loc];
            //                }
            //                else
            //                {
            //                    //[ annotationsToRemove removeObject:loc ] ;
            //                }
        }
        
    }
    [ _myMap removeAnnotations:ary_PinCollectionToDelete ] ;
    
    
    
    [[AppDelegate sharedDelegate] refreshUD:self.ary_loc];
    [[AppDelegate sharedDelegate] DeleteLocationToUD:deleteIndexFromRemind];
    self.ary_loc = [NSArray arrayWithArray:[AppDelegate sharedDelegate].fetchLocationsFromUD];
    [tblView reloadData];
}

-(void)showPinsOnViewDidLoad
{
    
    
    self.ary_loc = [NSArray arrayWithArray:[AppDelegate sharedDelegate].fetchLocationsFromUD];
    [_myMap removeAnnotations:_myMap.annotations];
    currentLoc = YES;
    NSMutableArray *locationsArray=[NSMutableArray new];
    

    
    for(locationModel *locObj in self.ary_loc)
    {
       
        ctrpoint = locObj.locPoint;
        _addAnnotation = [[MyLocation alloc] initWithName:locObj.str_Name address:locObj.str_Desc coordinate:ctrpoint];
        
        [locationsArray addObject:_addAnnotation];
        [_myMap addAnnotation:_addAnnotation];
       
        _addAnnotation = nil;
    }
  

    [self startLocationManager];
}


-(void)ZoomOnMap
{
    if (locationManager.location.coordinate.longitude !=0.000000 && locationManager.location.coordinate.latitude !=0.000000 ) {
        
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(locationManager.location.coordinate, 800, 800);
        [_myMap setRegion:viewRegion animated:YES];
    }

}

-(void)checkUserLocation
{
    if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied){
        
        if (!_alert) {
            _alert=   [UIAlertController
                      alertControllerWithTitle:@"Message"
                      message:@"Please enable your location"
                      preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* yesButton = [UIAlertAction
                                        actionWithTitle:@"Ok"
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action)
                                        {
                                            _alert=nil;
                                            //Handel your yes please button action here
                                            [_alert dismissViewControllerAnimated:YES completion:nil];
                                           
                                            
                                        }];
            
          
            UIAlertAction* SettingButton = [UIAlertAction
                                            actionWithTitle:@"Settings"
                                            style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * action)
                                            {
                                                //Handel your yes please button action here
                                                 _alert=nil;
                                                [[UIApplication sharedApplication] openURL:
                                                 [NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"]];
                                                
                                            }];
            
            [_alert addAction:SettingButton];
            [_alert addAction:yesButton];
            
            [self presentViewController:_alert animated:YES completion:nil];

        }
           }

}
/*-(void)show
 {
 MKMapRect zoomRect = MKMapRectNull;
 for (id <MKAnnotation> annotation in _myMap.annotations) {
 MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
 MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0);
 if (MKMapRectIsNull(zoomRect)) {
 zoomRect = pointRect;
 } else {
 zoomRect = MKMapRectUnion(zoomRect, pointRect);
 }
 }
 [_myMap setVisibleMapRect:zoomRect animated:YES];
 MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(mapView.userLocation.coordinate, 0.270, 0.270);
 [_myMap setRegion:viewRegion animated:YES];
 }*/
#pragma mark Method For Compare Date


//NSString *baseUrl = [NSString stringWithFormat:@"", sourceLocation.coordinate.latitude,  sourceLocation.coordinate.longitude, destinationLocation.coordinate.latitude,  destinationLocation.coordinate.longitude];

-(BOOL)compareTwodate:(NSDate *)date
{
    
    
//    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init] ;
//    [dateFormatter setDateFormat:@"dd:MM:yyyy hh:mm:ss"];
//    NSDate *datemy=[dateFormatter dateFromString:@"08:09:2016 05:30:00"];
//    
//    
    NSDate *today = [NSDate date]; // it will give you current date
    

    NSComparisonResult result;

    result = [today compare:date];
    
    if(result==NSOrderedAscending)
    {
        
        return YES;
    }
    else if(result==NSOrderedDescending)
    {
       
        return NO;
    }
    else
    {
      
        return YES;
    }
    
    
    return YES;
}
-(BOOL)CompareTwoTime:(NSString *)firstTime second:(NSString *)secondTime
{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss"];
    
    NSDate *date1= [formatter dateFromString:firstTime];
    NSDate *date2 = [formatter dateFromString:secondTime];
    
    NSComparisonResult result = [date1 compare:date2];
    if(result == NSOrderedDescending)
    {
        
        return  NO;
    }
    else if(result == NSOrderedAscending)
    {
        
        return YES;
      
    }
    else
    {
       
        return YES;
    }
    
    return nil;
}
-(void)compareDateMethod:(NSDate *)date
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:(NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate date]];
    NSDate *today = [cal dateFromComponents:components];
    components = [cal components:(NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    NSDate *otherDate = [cal dateFromComponents:components];
    
    if([today isEqualToDate:otherDate]) {

        NSLog(@"equal");
    }
    else if(today > otherDate)
    {
        NSLog(@"Today greater");
        
    }
    else if (today < otherDate)
    {
        
        NSLog(@"Today greater");
    }

}



@end
