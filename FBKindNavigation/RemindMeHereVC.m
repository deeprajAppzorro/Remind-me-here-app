//
//  RemindMeHereVC.m
//  MapDemo
//
//  Created by Sandeep Malhotra on 09/11/14.
//  Copyright (c) 2014 Abhishek Bhardwaj. All rights reserved.
//

#import "RemindMeHereVC.h"
#import "RemindMeCell.h"
#import "locationModel.h"
#import "CenterPanel_VC.h"
@interface RemindMeHereVC ()
@property (retain, nonatomic) IBOutlet UISegmentedControl *incomingOutgoingSegment;
@end

@implementation RemindMeHereVC
@synthesize delegate;
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
    // Do any additional setup after loading the view from its nib.
     [EC_NotificationCenter addObserver:self selector:@selector(reloadBackGroundData) name:reloadDataInBackground object:nil];
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,50)];
    numberToolbar.barStyle = UIBarStyleDefault;
    numberToolbar.items = @[[[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelNumberPad)],
                            [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                            [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)]];
    [numberToolbar sizeToFit];
    radiusTextfield.inputAccessoryView = numberToolbar;
    
   self.ary_loc = [NSArray arrayWithArray:[AppDelegate sharedDelegate].fetchLocationsFromUD];
    
    if(self.ary_loc.count == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"You haven't created any Locations yet." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    
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
}
-(void)cancelNumberPad{
    [radiusTextfield resignFirstResponder];
    radiusTextfield.text = @"";
}

-(void)doneWithNumberPad{
    
    [radiusTextfield resignFirstResponder];
}
-(void)viewWillAppear:(BOOL)animated
{
    UIColor *selectedColor = [UIColor colorWithRed: 0/255.0 green:144/255.0 blue:81/255.0 alpha:1.0];
    _incomingOutgoingSegment.tintColor=selectedColor;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    static NSString *CellIdentifier = @"RemindMeCell";
    
    RemindMeCell *cell = (RemindMeCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = (RemindMeCell *)[nib objectAtIndex:0];
    }
    

    locationModel *locObj = [self.ary_loc objectAtIndex:indexPath.row];
    cell.lbl_name.text = locObj.str_Name;
    cell.lbl_desc.text = locObj.str_Desc;
    cell.btn_edit.tag = indexPath.row;
    cell.btn_delete.tag = indexPath.row;
     cell.btn_startPause.tag = indexPath.row;
    
    if ([locObj.startPauseStatus isEqualToString:@"0"]) {
        
        [cell.btn_startPause setImage:[UIImage imageNamed:@"stop_icon"] forState:UIControlStateNormal];
        
    }
    else
    {
        [cell.btn_startPause setImage:[UIImage imageNamed:@"start_icon"] forState:UIControlStateNormal];

        
    }

    
   
    [cell.btn_edit addTarget:self action:@selector(editAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.btn_delete addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    
     [cell.btn_startPause addTarget:self action:@selector(startPauseAction:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)editAction:(id)sender
{
    UIButton *editbtn = (UIButton *)sender;
    selectedIndex = (int)editbtn.tag;
    locationModel *locObj = [self.ary_loc objectAtIndex:editbtn.tag];
    txt_name.text = locObj.str_Name;
    txt_desc.text = locObj.str_Desc;
    if ([locObj.selectAlertType isEqualToString:@"inComing"]) {
        
        _incomingOutgoingSegment.selectedSegmentIndex=0;
    
    }
    else
    {
        _incomingOutgoingSegment.selectedSegmentIndex=1;
        
        
    }
  
    radiusTextfield.text=[NSString stringWithFormat:@"%.f",locObj.radius];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init] ;
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    self.fromDate=locObj.date_fromDate;
    self.Todate=locObj.date_Todate;
    fromDateTextfield.text=[NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:locObj.date_fromDate]];
    toDatetextfield.text=[NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:locObj.date_Todate]];
    activityView.hidden = NO;
    activity_innerView.hidden = NO;
}
-(void)deleteAction:(id)sender
{
   UIButton *deletebtn = (UIButton *)sender;
    selectedIndex = (int)deletebtn.tag;
    locationModel *locObj = [self.ary_loc objectAtIndex:deletebtn.tag];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete Location" message:[NSString stringWithFormat:@"Do you want to delete \"%@\"",locObj.str_Name] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];
    alert.tag = 888;
    [alert show];
    
}
-(void)startPauseAction:(id)sender
{
    UIButton *startPauseBtn = (UIButton *)sender;
    selectedIndex = (int)startPauseBtn.tag;
    locationModel *locObj = [self.ary_loc objectAtIndex:startPauseBtn.tag];
    
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
    [[AppDelegate sharedDelegate] replaceLocationInUD:dicTosave index:selectedIndex];
     [[NSNotificationCenter defaultCenter] postNotificationName:reloadPinsOnMap object:nil userInfo:nil];
    [self reloadBackGroundData];
    
}

- (IBAction)action_back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)reloadBackGroundData
{
    self.ary_loc = [NSArray arrayWithArray:[AppDelegate sharedDelegate].fetchLocationsFromUD];
    [tbl_locations reloadData];
   
    
}

- (IBAction)action_cancelEdit:(id)sender
{
    txt_name.text=@"";
    txt_desc.text=@"";
    radiusTextfield.text=@"";
    fromDateTextfield.text=@"From Date";
    toDatetextfield.text=@"To Date";
    [txt_name resignFirstResponder];
    [txt_desc resignFirstResponder];
    [radiusTextfield resignFirstResponder];
    
    activityView.hidden = YES;
    activity_innerView.hidden = YES;
   
}

- (IBAction)action_doneEdit:(id)sender
{
    NSString *selectRadiusType=nil;
    if ([_incomingOutgoingSegment selectedSegmentIndex]==0) {
        
        selectRadiusType=@"inComing";
    }
    else
    {
        selectRadiusType=@"outGoing";
        
    }
  
    if(txt_name.text.length > 0 && txt_desc.text.length > 0 && radiusTextfield.text.length > 0 && ![fromDateTextfield.text isEqualToString:@"From Date"] && ![toDatetextfield.text isEqualToString:@"To Date"])
    {
        
        locationModel *locObj = [self.ary_loc objectAtIndex:selectedIndex];
        
         NSDictionary *dicTosave = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:txt_name.text,txt_desc.text,locObj.str_LatLong,locObj.str_entered,locObj.str_currntLoc,[NSString stringWithFormat:@"%.f",[radiusTextfield.text floatValue]],_fromDate,_Todate,locObj.startPauseStatus,@"start",selectRadiusType,nil] forKeys:[NSArray arrayWithObjects:@"name",@"desc",@"latLong",@"enter",@"currntLoc",@"radius",@"date_fromDate",@"date_ToDate",@"startPauseStatus",@"alertStatus",@"selectAlertType",nil]];
        
        [[AppDelegate sharedDelegate] refreshUD:self.ary_loc];
        [[AppDelegate sharedDelegate] replaceLocationInUD:dicTosave index:selectedIndex];
         [[NSNotificationCenter defaultCenter] postNotificationName:reloadPinsOnMap object:nil userInfo:nil];
        [self reloadBackGroundData];
        activityView.hidden = YES;
        activity_innerView.hidden = YES;
        
    }
    else
    {
        if(txt_name.text.length == 0)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please Enter Activity Name!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            [txt_name becomeFirstResponder];
        }
        else if(txt_desc.text.length == 0)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please Enter Description Name!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            [txt_desc becomeFirstResponder];
        }
        else if(radiusTextfield.text.length == 0)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please Enter Radius!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            [radiusTextfield becomeFirstResponder];
        }
        else if([fromDateTextfield.text isEqualToString:@"From Date"])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please Select From Date!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            
        }
        else if([toDatetextfield.text isEqualToString:@"To Date"])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please Select To Date!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            
        }
        
        
    }
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
    
    [txt_name resignFirstResponder];
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
- (void)dealloc {
    [view_back release];
    [view_editLoc release];
    [txt_name release];
    [txt_desc release];
    [btn_cancel release];
    [btn_done release];
    [tbl_locations release];
    self.delegate = nil;
    [super dealloc];
}
#pragma mark UIAlertViewDelagte
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 888)
    {
        
        if (buttonIndex==0) {
            return;
        }
        CenterPanel_VC *centeObj = self.delegate;
        [centeObj deleteAnotationFromRemindView:selectedIndex];
        [[AppDelegate sharedDelegate] refreshUD:self.ary_loc];
        [[AppDelegate sharedDelegate] DeleteLocationToUD:selectedIndex];
         [[NSNotificationCenter defaultCenter] postNotificationName:reloadPinsOnMap object:nil userInfo:nil];
         [self reloadBackGroundData];
        
    }
}
#pragma mark UITextFieldDelgates
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
