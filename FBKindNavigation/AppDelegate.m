//
//  AppDelegate.m
//  FBKindNavigation
//
//  Created by Abhishek Bhardwaj on 12/07/13.
//  Copyright (c) 2013 Abhishek Bhardwaj. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "LeftPanel_VC.h"
#import "CenterPanel_VC.h"
#import "RightPanel_VC.h"
#import "RageIAPHelper.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>





@implementation AppDelegate


- (void)dealloc
{
    [_window release];
    [_viewController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  

    UILocalNotification *localNotification = launchOptions[UIApplicationLaunchOptionsLocalNotificationKey];
    if (localNotification)
    {
       [[UIApplication sharedApplication] cancelAllLocalNotifications];
      
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[localNotification valueForKey:@"alertTitle"] message:[localNotification valueForKey:@"alertBody"] delegate:self cancelButtonTitle:@"Mark Complete" otherButtonTitles:@"Ok",@"Pause", nil];
        [alert show];
    }
    
    
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    //Declare base view controller as JASlidePanelController
    self.viewController = [[JASidePanelController alloc] init];
    self.viewController.shouldDelegateAutorotateToVisiblePanel = NO;
   
    //  Declare left,right and Center panel in BaseController
    self.viewController.leftPanel = [[LeftPanel_VC alloc] init];
    
    CenterPanel_VC *objCenter = [[CenterPanel_VC alloc] init];
    self.viewController.centerPanel = [[UINavigationController alloc] initWithRootViewController:objCenter];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:237.0f/255.0f green:84.0f/255.0f blue:36.0f/255.0f alpha:1.0]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    NSDictionary *titleAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName: [UIFont systemFontOfSize:20]};
    [[UINavigationBar appearance] setTitleTextAttributes:titleAttributes];
    
    //Local Notification
    
    [self registerForLocalNotification];
    
    
    //self.viewController.rightPanel = [[RightPanel_VC alloc] init];
    
    self.window.rootViewController = self.viewController;
    
    
    //Disable RIght Panel
    [self.window makeKeyAndVisible];
    
    [Fabric with:@[[Crashlytics class]]];
    
    return YES;
}

-(void)registerForLocalNotification
{
    UIMutableUserNotificationAction *pauseAction = [[UIMutableUserNotificationAction alloc] init];
    pauseAction.identifier = @"Pause";
    pauseAction.title = @"Pause";
    pauseAction.activationMode = UIUserNotificationActivationModeBackground;
    pauseAction.destructive = NO;
    pauseAction.authenticationRequired = NO;
    
    UIMutableUserNotificationAction *markComplete = [[UIMutableUserNotificationAction alloc] init];
    markComplete.identifier = @"Mark Complete";
    markComplete.title = @"Mark Complete";
    markComplete.activationMode = UIUserNotificationActivationModeBackground;
    markComplete.destructive = YES;
    markComplete.authenticationRequired = YES;
    

    
    UIMutableUserNotificationCategory *notificationCategory = [[UIMutableUserNotificationCategory alloc] init];
    notificationCategory.identifier = @"Alert";
    [notificationCategory setActions:@[pauseAction,markComplete] forContext:UIUserNotificationActionContextDefault];
    [notificationCategory setActions:@[pauseAction,markComplete] forContext:UIUserNotificationActionContextMinimal];
    
    NSSet *categories = [NSSet setWithObjects:notificationCategory, nil];
    
    UIUserNotificationType notificationType = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    UIUserNotificationSettings *notificationSettings = [UIUserNotificationSettings settingsForTypes:notificationType categories:categories];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
    
   
}
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void(^)())completionHandler {
    
       [[UIApplication sharedApplication] cancelLocalNotification:notification];
    if ([[notification valueForKey:@"category"] isEqualToString:@"Alert"]) {
        
        if ([identifier isEqualToString:@"Pause"]) {
            
          [self pauseAction:[notification valueForKey:@"alertTitle"] message:[notification valueForKey:@"alertBody"]];
        }
        else if ([identifier isEqualToString:@"Mark Complete"])
        {
            [self markCompleteAction:[notification valueForKey:@"alertTitle"] message:[notification valueForKey:@"alertBody"]];
            

        }
        
        
    }
    
    if(completionHandler != nil)    //Finally call completion handler if its not nil
        completionHandler();
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{

    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    if (!_notificationCheck)
    {
        self.notificationCheck=true;
        
        [self startSpeech:[notification valueForKey:@"alertTitle"] description:[notification valueForKey:@"alertBody"]];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[notification valueForKey:@"alertTitle"] message:[notification valueForKey:@"alertBody"] delegate:self cancelButtonTitle:@"Mark Complete" otherButtonTitles:@"Ok",@"Pause", nil];
        [alert show];
      
    }
    

}

-(void)startSpeech:(NSString *)title description:(NSString *)alertBody
{
    
    if (!_utterance &&!_SpeechText) {
      
        _utterance = [AVSpeechUtterance
                      speechUtteranceWithString:[NSString stringWithFormat:@"hello, You Are Near %@, %@, Thank you",title,alertBody]];
        _SpeechText = [[AVSpeechSynthesizer alloc] init];
        [_SpeechText speakUtterance:_utterance];
        _SpeechText.delegate=self;
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        
        
        
    }
 }


+(AppDelegate *)sharedDelegate
{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}
-(NSArray *)FetchPruchasedProductsFromUD
{
    NSUserDefaults *BuyProductsUD=[NSUserDefaults standardUserDefaults];
    
    NSArray *ary_tempBuy=[BuyProductsUD objectForKey:PruchasedProductkey];   
    NSMutableArray *ary_ID = [NSMutableArray new];
    for(NSString *UniqueIdentifier in ary_tempBuy)
    {
        [ary_ID addObject:[NSString stringWithFormat:@"%@",UniqueIdentifier ]];
    }
    return ary_ID;
    
 }
-(void)PruchasedProductsToUD:(NSString *)ProductUniqueIdentifier
{
    NSUserDefaults *BuyProductsUD = [NSUserDefaults standardUserDefaults];
    NSArray *ary_tempBuy = [BuyProductsUD objectForKey:PruchasedProductkey];
    NSMutableArray *ary_ID = [NSMutableArray new];
    for(NSString *UniqueIdentifier in ary_tempBuy)
    {
        [ary_ID addObject:UniqueIdentifier];
    }
    
    if (![ary_ID containsObject:ProductUniqueIdentifier]) {
       [ary_ID addObject:ProductUniqueIdentifier];
    }
    [BuyProductsUD setObject:ary_ID forKey:PruchasedProductkey];
    [BuyProductsUD synchronize];
    
}

-(NSArray *)fetchLocationsFromUD
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSArray *ary_tempLoc = [userDefault objectForKey:userDefauktKey];
    NSMutableArray *ary_Loc = [NSMutableArray new];
    for(NSDictionary *dic in ary_tempLoc)
    {
        [ary_Loc addObject:[ locationModel getObjectInitWithInfo:dic]];
    }
    return ary_Loc;
}
-(void)insertLocationsToUD:(NSDictionary *)new_dic
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSArray *ary_tempLoc = [userDefault objectForKey:userDefauktKey];
    NSMutableArray *ary_Loc = [NSMutableArray new];
    for(NSDictionary *dic in ary_tempLoc)
    {
        [ary_Loc addObject:dic];
    }
    
    [ary_Loc addObject:new_dic];
    [userDefault setObject:ary_Loc forKey:userDefauktKey];
    [userDefault synchronize];
   
}
-(void)DeleteLocationToUD:(int)index

{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSMutableArray *ary_Loc = [[NSMutableArray alloc] initWithArray:[userDefault objectForKey:userDefauktKey]];
    
    [ary_Loc removeObjectAtIndex:index];
    [userDefault setObject:ary_Loc forKey:userDefauktKey];
    [userDefault synchronize];
    
}
-(void)replaceLocationInUD:(NSDictionary *)dic index:(int)index
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSMutableArray *ary_Loc = [[NSMutableArray alloc] initWithArray:[userDefault objectForKey:userDefauktKey]];
    
    [ary_Loc replaceObjectAtIndex:index withObject:dic];
    [userDefault setObject:ary_Loc forKey:userDefauktKey];
    [userDefault synchronize];
}
-(void)refreshUD:(NSArray *)ary_locs
{
    NSMutableArray *ary_temp = [[NSMutableArray alloc] init];
    for(locationModel *locObj in ary_locs)
    {
        
        
        NSDictionary *dicTosave = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:locObj.str_Name,locObj.str_Desc,locObj.str_LatLong,locObj.str_entered,locObj.str_currntLoc,[NSString stringWithFormat:@"%.f",locObj.radius],locObj.date_fromDate,locObj.date_Todate,locObj.startPauseStatus,locObj.alertStatus,locObj.selectAlertType,nil] forKeys:[NSArray arrayWithObjects:@"name",@"desc",@"latLong",@"enter",@"currntLoc",@"radius",@"date_fromDate",@"date_ToDate",@"startPauseStatus",@"alertStatus",@"selectAlertType", nil]];
        
        [ary_temp addObject:dicTosave];
    }
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:ary_temp forKey:userDefauktKey];
    [userDefault synchronize];
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    
    
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
    UIApplication* app = [UIApplication sharedApplication];
    
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        [app endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }];
    
    self.BackgroundTimer = [NSTimer scheduledTimerWithTimeInterval:5
                                                  target:self                                                selector:@selector(getBackgroundLOcation)
                                                userInfo:nil
                                                 repeats:YES];
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [self.BackgroundTimer invalidate];
    
       [[UIApplication sharedApplication] endBackgroundTask:UIBackgroundTaskInvalid];
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}


-(void)getBackgroundLOcation

{
    CenterPanel_VC *CenterVC=[[CenterPanel_VC alloc] init];
    [CenterVC startBackgroundTask];
}
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
    
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark -- HUD Methods

-(void)showHUD
{
    [MBProgressHUD showHUDAddedTo:self.window animated:NO];
}

-(void)hideHUD
{
    [MBProgressHUD hideHUDForView:self.window animated:NO];
}

#pragma mark UIAlertViewDelagte
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
   
    if (buttonIndex==0) {
        
      //mark complete

         [self markCompleteAction:alertView.title message:alertView.message];
        
    }
    else if(buttonIndex==1)
    {
    
       //OK

        
    }
    else if(buttonIndex==2)
    {
        
        //Pause
        
        [self pauseAction:alertView.title message:alertView.message];
       
        
    }
    
 
    self.notificationCheck=false;
    AVSpeechSynthesizer *talked = self.SpeechText;
    if([talked isSpeaking]) {
        [talked stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
        [self.audioController stopTheSound];

    }
    else{
          [self.audioController stopTheSound];
    }

 
    
}

-(void)markCompleteAction:(NSString *)title message:(NSString *)message
{
    NSArray *ary_loc=[NSArray arrayWithArray:[self fetchLocationsFromUD]];
    for (int i=0; i<ary_loc.count; i++) {
        
        locationModel *locObj = [ary_loc objectAtIndex:i];
        
        if ([locObj.str_Name isEqualToString:title]&&[locObj.str_Desc  isEqualToString:message]) {
            
            
            
            [self refreshUD:ary_loc];
            [self DeleteLocationToUD:i];
            [[NSNotificationCenter defaultCenter] postNotificationName:reloadDataInBackground object:nil userInfo:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:reloadPinsOnMap object:nil userInfo:nil];
        }
        
    }
    
}
-(void)pauseAction:(NSString *)title message:(NSString *)message
{
    NSArray *ary_loc=[NSArray arrayWithArray:[self fetchLocationsFromUD]];
    for (int i=0; i<ary_loc.count; i++)
    {
        
        locationModel *locObj = [ary_loc objectAtIndex:i];
        if ([locObj.str_Name isEqualToString:title] && [locObj.str_Desc  isEqualToString:message] ) {
            
            NSDictionary *dicTosave = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:locObj.str_Name,locObj.str_Desc,locObj.str_LatLong,locObj.str_entered,locObj.str_currntLoc,[NSString stringWithFormat:@"%.f",locObj.radius],locObj.date_fromDate,locObj.date_Todate,@"1",locObj.alertStatus,locObj.selectAlertType,nil] forKeys:[NSArray arrayWithObjects:@"name",@"desc",@"latLong",@"enter",@"currntLoc",@"radius",@"date_fromDate",@"date_ToDate",@"startPauseStatus",@"alertStatus",@"selectAlertType",nil]];
            
            [[AppDelegate sharedDelegate] refreshUD:ary_loc];
            [[AppDelegate sharedDelegate] replaceLocationInUD:dicTosave index:i];
            [[NSNotificationCenter defaultCenter] postNotificationName:reloadDataInBackground object:nil userInfo:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:reloadPinsOnMap object:nil userInfo:nil];
            break;
            
        }
        
        
        
        
        
    }
}
#pragma mark AVSpeechSynthesizerDelegate

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance
{
    _SpeechText=nil;
    _utterance=nil;
    self.audioController = [[AudioController alloc] init];
    [self.audioController tryPlayMusic];
    
}
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didPauseSpeechUtterance:(AVSpeechUtterance *)utterance
{
    
}
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didContinueSpeechUtterance:(AVSpeechUtterance *)utterance
{
    
}
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didCancelSpeechUtterance:(AVSpeechUtterance *)utterance
{
     _SpeechText=nil;
     _utterance=nil;
      [self.audioController stopTheSound];
    
}


@end
