//
//  CenterPanel_VC.h
//  FBKindNavigation
//
//  Created by Abhishek Bhardwaj on 12/07/13.
//  Copyright (c) 2013 Abhishek Bhardwaj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "locationModel.h"
#import "AudioController.h"
#import "iAd/ADBannerView.h"
#import "MyLocation.h"


@interface CenterPanel_VC : UIViewController <CLLocationManagerDelegate,ADBannerViewDelegate>
{
   CLLocationCoordinate2D  ctrpoint;
    CLLocationCoordinate2D mapPoints;
    CLLocationManager *locationManager;
    BOOL currentLoc;
    BOOL firstTimeZoom;
    BOOL checkDatePicker;
    IBOutlet UIView *activityView;
    IBOutlet UITextField *txt_activity;
    IBOutlet UITextField *txt_desc;
    IBOutlet UITextField *radiusTextfield;
    IBOutlet UITextField *fromDateTextfield;
    IBOutlet UITextField *toDatetextfield;
    
    IBOutlet UIView *datePickerSuperView;
    
    //NSString *str_activity;
    BOOL entered;
    IBOutlet UIView *view_back;
    
    IBOutlet UIView *activity_innerView;
    IBOutlet UIButton *btn_cancel;
    IBOutlet UIButton *btn_done;
    
    IBOutlet UIView *view_streetAdd;
    IBOutlet UITextField *txt_streetAdd;
    IBOutlet UIButton *btn_streetCancel;
    IBOutlet UIButton *btn_streetDone;
    IBOutlet UIView *view_activityIndicator;
    
    IBOutlet UIActivityIndicatorView *activityIndicator;
    
    NSMutableData *receivedData;
    
    IBOutlet UIButton *btn_existingLoc;
    IBOutlet UIButton *btn_newLoc;
    
    IBOutlet UIButton *btn_useCurrLoc;
    IBOutlet UIButton *btn_entrAdd;
    IBOutlet UIView *view_enterAdd;
    IBOutlet UIView *view_btns;
    
    IBOutlet UIDatePicker *datePicker;
    IBOutlet UIView *pickerSuperView;
    
    IBOutlet UITableView *tblView;
    int selectedIndex;
    BOOL editing;
    BOOL chkForCurrntLoc;
    
    // Rate View
    
    IBOutlet UIView * RatingView;
    
    
}


@property (nonatomic, retain) UIAlertController * alert;
//iAd

@property (strong, nonatomic) NSTimer* AcitveTimer;
@property (nonatomic, retain) IBOutlet UIView *contentView;
@property (nonatomic, retain) ADBannerView * adBannerView;

@property (nonatomic) BOOL adBannerViewIsVisible;
- (IBAction)Callclicked:(id)sender;

- (IBAction)action_DoneActivity:(id)sender;
- (IBAction)action_cancelActivity:(id)sender;
- (IBAction)dropPin:(id)sender;
- (IBAction)action_CancelDoneActivity:(id)sender;
@property (strong, nonatomic) AudioController *audioController;
@property (retain, nonatomic) IBOutlet MKMapView *myMap;
@property (retain, nonatomic) MyLocation *addAnnotation;
@property (retain, nonatomic) NSArray *ary_loc;
@property (strong, nonatomic) NSDate *fromDate;
@property (strong, nonatomic) NSDate *Todate;
-(void)RowTapped:(int)i;
-(void)hideTheAddressFromConnection;
-(void)startLocationManager;
-(void)logoClicked;
- (IBAction)action_existingLoc:(id)sender;
- (IBAction)action_newLoc:(id)sender;
- (IBAction)action_useCurrLoc:(id)sender;
- (IBAction)action_enterAddress:(id)sender;
- (IBAction)fromDateAction:(id)sender;
- (IBAction)toDateAction:(id)sender;
-(void)deleteAnotationFromRemindView:(int)deleteIndexFromRemind;
-(void)showPinsOnViewDidLoad;
- (void)startBackgroundTask;
-(void)getUserReminder;
-(void)reloadPinsAfterEdit;
@end
