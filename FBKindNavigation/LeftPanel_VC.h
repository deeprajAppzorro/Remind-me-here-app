//
//  LeftPanel_VC.h
//  FBKindNavigation
//
//  Created by Abhishek Bhardwaj on 12/07/13.
//  Copyright (c) 2013 Abhishek Bhardwaj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftPanel_VC : UIViewController
{
    
    IBOutlet UIView *viewForTap;
}
- (IBAction)action_logoClicked:(id)sender;
- (IBAction)btnAction_RemoveRightPanel:(id)sender;
- (IBAction)btnAction_ShowCenterPanel:(id)sender;
-(void)PerformActionOnCenterView:(UIButton*)tempBtn;
@end
