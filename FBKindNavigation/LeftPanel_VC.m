//
//  LeftPanel_VC.m
//  FBKindNavigation
//
//  Created by Abhishek Bhardwaj on 12/07/13.
//  Copyright (c) 2013 Abhishek Bhardwaj. All rights reserved.
//

#import "LeftPanel_VC.h"

#import "JASidePanelController.h"
#import "UIViewController+JASidePanel.h"

#import "CenterPanel_VC.h"
#import "SliderCell.h"
@interface LeftPanel_VC ()

@end

@implementation LeftPanel_VC

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
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(myTapMethod:)];
//    [tap setNumberOfTouchesRequired:1];
//    [tap setNumberOfTapsRequired:3];
//    [viewForTap addGestureRecognizer:tap];
}


- (IBAction)action_logoClicked:(id)sender
{
    [self.sidePanelController showCenterPanelAnimated:YES];
    [self performSelector:@selector(logoClicked) withObject:nil afterDelay:0.20];
}

- (IBAction)btnAction_RemoveRightPanel:(id)sender
{
    self.sidePanelController.rightPanel = nil;
    
    // Again to assign right pannel in project
    // self.sidePanelController.rightPanel = [[JARightViewController alloc] init];
}

- (IBAction)btnAction_ShowCenterPanel:(id)sender
{
    //self.sidePanelController.centerPanel = [[UINavigationController alloc] initWithRootViewController:[[CenterPanel_VC alloc] init]];
    [self.sidePanelController showCenterPanelAnimated:YES];
}

#pragma mark Tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SliderCell";
    
    SliderCell *cell = (SliderCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = (SliderCell *)[nib objectAtIndex:0];
    }
    if(indexPath.row == 0)
    {
      cell.lbl_heading.text = @"Map";
        cell.imgViewCelIcon.image = [UIImage imageNamed:@"map.png"];
    }
    else if (indexPath.row == 1)
    {
        cell.lbl_heading.text = @"Alarm List";
        cell.imgViewCelIcon.image = [UIImage imageNamed:@"logo.png"];
    }
    else if (indexPath.row == 2)
    {
       cell.lbl_heading.text = @"Add Location";
        cell.imgViewCelIcon.image = [UIImage imageNamed:@"adress.png"];
    }
    else if (indexPath.row==3)
    {
        cell.lbl_heading.text = @"Rate";
        cell.imgViewCelIcon.image = [UIImage imageNamed:@"rat_icon"];
        
    }
    else if (indexPath.row==4)
    {
        cell.lbl_heading.text = @"Share";
        cell.imgViewCelIcon.image = [UIImage imageNamed:@"share_icon"];
        
    }
    else if (indexPath.row==5)
    {
        cell.lbl_heading.text = @"Buy";
        cell.imgViewCelIcon.image = [UIImage imageNamed:@"buy_icon"];
        
    }
    
    //buy_icon  rat_icon share_icon
    
//    if(indexPath.row == 2)
//    {
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(myTapMethod:)];
//        //[tap setNumberOfTouchesRequired:1];
//        [tap setNumberOfTapsRequired:3];
//        [cell.contentView addGestureRecognizer:tap];
//
//    }
    cell.contentView.tag = indexPath.row;
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        [self.sidePanelController showCenterPanelAnimated:YES];

        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = indexPath.row;
        [self performSelector:@selector(PerformActionOnCenterView:) withObject:button afterDelay:0.20];
    
       
    
        

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)PerformActionOnCenterView:(UIButton*)tempBtn
{
        CenterPanel_VC *centreObj = [[((UINavigationController *)self.sidePanelController.centerPanel) viewControllers] objectAtIndex:0];
    if(tempBtn.tag == 1)
    {
    
        [centreObj logoClicked];
    }
    else
    {
      
        [centreObj RowTapped:(int)tempBtn.tag];
    }
    
}
-(void)logoClicked
{
    CenterPanel_VC *centreObj = [[((UINavigationController *)self.sidePanelController.centerPanel) viewControllers] objectAtIndex:0];
    [centreObj logoClicked];
}
- (void)dealloc {
    [viewForTap release];
    [super dealloc];
}
@end
