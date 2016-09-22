//
//  RightPanel_VC.m
//  FBKindNavigation
//
//  Created by Abhishek Bhardwaj on 12/07/13.
//  Copyright (c) 2013 Abhishek Bhardwaj. All rights reserved.
//

#import "RightPanel_VC.h"

#import "JASidePanelController.h"
#import "UIViewController+JASidePanel.h"

#import "CenterPanel_VC.h"

@interface RightPanel_VC ()

@end

@implementation RightPanel_VC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (IBAction)btnAction_ShowCenterPanel:(id)sender
{
    self.sidePanelController.centerPanel = [[UINavigationController alloc] initWithRootViewController:[[CenterPanel_VC alloc] init]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
