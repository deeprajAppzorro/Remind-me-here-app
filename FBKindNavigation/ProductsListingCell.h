//
//  ProductsListingCell.h
//  MapDemo
//
//  Created by deepraj on 8/31/16.
//  Copyright © 2016 Abhishek Bhardwaj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductsListingCell : UITableViewCell
@property(strong ,nonatomic)IBOutlet UILabel *ProductTitleLabel;
@property(strong,nonatomic)IBOutlet UILabel *ProductDescLabel;
@property(strong,nonatomic)IBOutlet UILabel *ProductPriceLabel;
@property(strong,nonatomic)IBOutlet UIButton *BuyProductBtn;
@end
