//
//  RemindMeCell.h
//  MapDemo
//
//  Created by Sandeep Malhotra on 09/11/14.
//  Copyright (c) 2014 Abhishek Bhardwaj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RemindMeCell : UITableViewCell
{
    
}
@property (retain, nonatomic) IBOutlet UILabel *lbl_name;
@property (retain, nonatomic) IBOutlet UILabel *lbl_desc;
@property (retain, nonatomic) IBOutlet UIButton *btn_edit;
@property (retain, nonatomic) IBOutlet UIButton *btn_delete;
@property (retain, nonatomic) IBOutlet UIButton *btn_startPause;

@end
