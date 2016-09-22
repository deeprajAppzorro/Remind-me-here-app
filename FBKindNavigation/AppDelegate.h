//
//  AppDelegate.h
//  FBKindNavigation
//
//  Created by Abhishek Bhardwaj on 12/07/13.
//  Copyright (c) 2013 Abhishek Bhardwaj. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JASidePanelController.h"
#import <Foundation/Foundation.h>
#import "locationModel.h"
#import "AudioController.h"
//@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate,AVSpeechSynthesizerDelegate>

{
    UIBackgroundTaskIdentifier  bgTask;
    
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) JASidePanelController *viewController;
@property (strong, nonatomic) AudioController *audioController;
@property (strong, nonatomic) NSMutableArray* alertDeailsArray;
@property (strong, nonatomic) NSTimer* BackgroundTimer;
@property (strong, nonatomic) NSTimer* AcitveTimer;
@property (strong, nonatomic) AVSpeechSynthesizer *SpeechText;
@property (strong, nonatomic) AVSpeechUtterance *utterance;
@property (nonatomic, assign) BOOL notificationCheck;

+(AppDelegate *)sharedDelegate;
-(NSArray *)FetchPruchasedProductsFromUD;
-(NSArray *)fetchLocationsFromUD;
-(void)PruchasedProductsToUD:(NSString *)ProductUniqueIdentifier;
-(void)insertLocationsToUD:(NSDictionary *)new_dic;
-(void)DeleteLocationToUD:(int)index;
-(void)replaceLocationInUD:(NSDictionary *)dic index:(int)index;
-(void)refreshUD:(NSArray *)ary_locs;

-(void)showHUD;
-(void)hideHUD;
@end
