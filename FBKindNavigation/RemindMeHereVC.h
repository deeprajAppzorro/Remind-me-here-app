//
//  RemindMeHereVC.h
//  MapDemo
//
//  Created by Sandeep Malhotra on 09/11/14.
//  Copyright (c) 2014 Abhishek Bhardwaj. All rights reserved.
//

#import "ViewController.h"

@interface RemindMeHereVC : ViewController
{
    IBOutlet UIView *view_editLoc;
    IBOutlet UIView *view_back;
    IBOutlet UITextField *txt_name;
    IBOutlet UITextField *txt_desc;
    IBOutlet UIView *activityView;
    IBOutlet UITextField *radiusTextfield;
    IBOutlet UITextField *fromDateTextfield;
    IBOutlet UITextField *toDatetextfield;
   IBOutlet UIView *datePickerSuperView;
    
    
    
    IBOutlet UIView *activity_innerView;
    IBOutlet UIButton *btn_cancel;
    IBOutlet UIButton *btn_done;
    
    
    IBOutlet UIDatePicker *datePicker;
    IBOutlet UIView *pickerSuperView;
   
    
    BOOL checkDatePicker;
    int selectedIndex;
    
    IBOutlet UITableView *tbl_locations;
}

@property (assign, nonatomic) id delegate;
@property (retain, nonatomic) NSArray *ary_loc;
@property (strong, nonatomic) NSDate *fromDate;
@property (strong, nonatomic) NSDate *Todate;
-(void)editAction:(id)sender;
-(void)deleteAction:(id)sender;
- (IBAction)action_back:(id)sender;
- (IBAction)action_cancelEdit:(id)sender;
- (IBAction)action_doneEdit:(id)sender;

@end
