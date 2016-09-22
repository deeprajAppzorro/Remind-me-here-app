//
//  ProductsListingCell.m
//  MapDemo
//
//  Created by deepraj on 8/31/16.
//  Copyright © 2016 Abhishek Bhardwaj. All rights reserved.
//

#import "ProductsListingCell.h"

@implementation ProductsListingCell
@synthesize BuyProductBtn;
@synthesize ProductDescLabel;
@synthesize ProductTitleLabel;
@synthesize ProductPriceLabel;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
