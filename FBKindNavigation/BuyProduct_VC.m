//
//  BuyProduct_VC.m
//  MapDemo
//
//  Created by deepraj on 8/31/16.
//  Copyright © 2016 Abhishek Bhardwaj. All rights reserved.
//

#import "BuyProduct_VC.h"
#import "CenterPanel_VC.h"
#import "ProductsListingCell.h"
#import "RageIAPHelper.h"
#import <StoreKit/StoreKit.h>
@interface BuyProduct_VC ()

{
    IBOutlet UITableView *ProductsTableView;
     NSNumberFormatter * _priceFormatter;

}
@property (strong, nonatomic) NSArray *products;
@property (retain, nonatomic) NSArray *ListOfProducts;

@end

@implementation BuyProduct_VC

- (void)viewDidLoad {
    [super viewDidLoad];
     [self reload];
    [App_Delegate performSelectorOnMainThread:@selector(showHUD) withObject:nil waitUntilDone:YES];
    [IAPHelper restoreCompletedTransactions];
   
  [EC_NotificationCenter addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
     [EC_NotificationCenter addObserver:self selector:@selector(ProductPurchasedList) name:IAPHelperGetRestoredProductPurchasedNotification object:nil];
    _priceFormatter = [[NSNumberFormatter alloc] init];
    [_priceFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [_priceFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    self.ListOfProducts=[NSArray arrayWithArray:[AppDelegate sharedDelegate].FetchPruchasedProductsFromUD];
    NSLog(@"666666 =%lu",(unsigned long)[_ListOfProducts count]);
  
    
 
   // [ProductsTableView reloadData];
    // Do any additiona 1l setup after loading the view from its nib.
}
#pragma mark - Load Products
- (void)reload {
    _products = nil;
    [ProductsTableView reloadData];
    [[RageIAPHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
        if (success) {
            [App_Delegate performSelectorOnMainThread:@selector(hideHUD) withObject:nil waitUntilDone:YES];
            self.products =products;
            
            if ([self.products count]) {
                
               // [ProductsTableView reloadData];
               
                
                
            }
            
        }
        
    }];
}
- (void)productPurchased:(NSNotification *)notification
{
    
    
    [App_Delegate performSelectorOnMainThread:@selector(hideHUD) withObject:nil waitUntilDone:YES];
    
  NSLog(@"%@",notification.userInfo);
  
    
    
    if ([[notification.userInfo valueForKey:@"status"] isEqualToString:@"Failed to validate receipt."] || [notification.object isEqualToString:@"Payment cancelled."])
    {
        
      
        [self creatAlertControllerWithOneButton:@"Message" AlertMessage:@"Transaction Cancelled" ButtonName:@"Ok"];
    }
    else if([[notification.userInfo valueForKey:@"status"] isEqualToString:@"Complete"])
    {
        [[AppDelegate sharedDelegate] PruchasedProductsToUD:notification.object];
         [IAPHelper restoreCompletedTransactions];
      
    }
   
    
}

-(void)ProductPurchasedList
{
   
    
     [App_Delegate performSelectorOnMainThread:@selector(hideHUD) withObject:nil waitUntilDone:YES];
    self.ListOfProducts=[NSArray arrayWithArray:[AppDelegate sharedDelegate].FetchPruchasedProductsFromUD];
    [ProductsTableView reloadData];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)action_back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

# pragma mark UITableview Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.products.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    
    ProductsListingCell *cell =(ProductsListingCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
   //     cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ProductsListingCell" owner:self options:nil];
        cell = (ProductsListingCell *)[nib objectAtIndex:0];
    }
    
    if(indexPath.row%2 == 0)
    {
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
    else
    {
        cell.contentView.backgroundColor = [UIColor lightGrayColor];
    }
    SKProduct * product = (SKProduct *) [self.products objectAtIndex:indexPath.row];
   
    cell.ProductTitleLabel.text = product.localizedTitle;
    cell.ProductDescLabel.text=product.localizedDescription;
    
    
    
    [_priceFormatter setLocale:product.priceLocale];
    cell.ProductPriceLabel.text = [_priceFormatter stringFromNumber:product.price];
    
    
    
   
    if ([self.ListOfProducts containsObject:product.productIdentifier]) {
        
        [cell.BuyProductBtn setTitle:@"Done" forState:UIControlStateNormal];
    }
    else
    {
        [cell.BuyProductBtn setTitle:@"Buy" forState:UIControlStateNormal];
    }
    cell.BuyProductBtn.tag = indexPath.row;
    [cell.BuyProductBtn addTarget:self action:@selector(buyButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - Buy Product

- (IBAction)buyButtonTapped:(id)sender{
    
    
    UIButton *buyButton = (UIButton *)sender;
    
    if ([buyButton.currentTitle isEqualToString:@"Done"]) {
        
        [self creatAlertControllerWithOneButton:@"Message" AlertMessage:@"Already Purchased" ButtonName:@"Ok"];
        return;
    }
    SKProduct *product = _products[buyButton.tag];
    
    NSLog(@"Buying %@...", product.productIdentifier);
    [App_Delegate performSelectorOnMainThread:@selector(showHUD) withObject:nil waitUntilDone:YES];
    [[RageIAPHelper sharedInstance] buyProduct:product];
    
}


#pragma mark - Restore Completed Transactions

-(IBAction)restoreTappedAction:(id)sender {
    
    
     [App_Delegate performSelectorOnMainThread:@selector(showHUD) withObject:nil waitUntilDone:YES];
    [RageIAPHelper restoreCompletedTransactions];
}

-(void)creatAlertControllerWithOneButton:(NSString *)stringAlertTitle AlertMessage:(NSString *)stringAlertMessage ButtonName:(NSString *)stringButtonName{
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:stringAlertTitle
                                  message:stringAlertMessage
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:stringButtonName
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                    //Handel your yes please button action here
                                    [alert dismissViewControllerAnimated:YES completion:^{
                                    }];
                                    
                                }];
    
    [alert addAction:yesButton];
    
    
    [self presentViewController:alert animated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
