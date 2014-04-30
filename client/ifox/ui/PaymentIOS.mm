//
//  PaymentIOS.cpp
//  
//


#import "PaymentIOS.h"
#import "ItemData.h"
#import "GameDataManager.h"
#import "AlertUIHandler.h"
#import "VerificationController.h"

@implementation PaymentIOS


static PaymentIOS* paymentIOS;
+ ( PaymentIOS* ) instance
{
    if ( !paymentIOS )
    {
        paymentIOS = [ [ PaymentIOS alloc ] init ];
    }
    
    return paymentIOS;
}


- ( NSMutableArray* )   getList
{
    return products;
}


- ( void ) getList:( NSMutableArray* )arr
{
    if ( products )
    {
        return;
    }
    
    if ( [ SKPaymentQueue canMakePayments ] )
    {
        SKProductsRequest* request = [ [ [ SKProductsRequest alloc ] initWithProductIdentifiers:
                                        [ NSSet setWithArray:arr ] ] autorelease ];
        
        request.delegate = self;
        
        [ request start ];
        
        [ [ SKPaymentQueue defaultQueue ] addTransactionObserver:self ];
    }
    else
    {
        
    }
}


- (void)dealloc
{
    [ products release ];
    products = NULL;
    
    [ super dealloc ];
}



- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0)
{
    [ products release ];
    products = [ [ NSMutableArray alloc ] initWithArray:response.products ];
    
}


- (void) completeTransaction:(SKPaymentTransaction *) transaction
{
    BOOL b = [ [ VerificationController sharedInstance ] verifyPurchase:transaction ];
    
    if ( !b )
    {
        [ [ AlertUIHandler instance ] alert:NSLocalizedString( @"BuyFailed" , nil ) ];
        [ [ SKPaymentQueue defaultQueue ] finishTransaction:transaction ];
        buy = NO;
        return;
    }
    
    buyCount = 0;
    if ( [ transaction.payment.productIdentifier isEqualToString:@"Cat1" ] )
    {
        buyCount = 12;
    }
    else if ( [ transaction.payment.productIdentifier isEqualToString:@"Cat2" ] )
    {
        buyCount = 28;
    }
    else if ( [ transaction.payment.productIdentifier isEqualToString:@"Cat3" ] )
    {
        buyCount = 50;
    }
    
    [ [ SKPaymentQueue defaultQueue ] finishTransaction:transaction ];
}

- ( void ) complete
{
    [ [ ItemData instance ] addItem:SPECIAL_ITEM :buyCount ];
    [ [ GameDataManager instance ] setBuyItem:buyCount ];
    
    [ [ AlertUIHandler instance ] alert:NSLocalizedString( @"BuySuccess" , nil ) ];
    playSound( PST_ALCHEMY );
    buy = NO;
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction
{
    NSLog(@"transaction.error.code:%@", transaction.error.localizedDescription );
    
    if ( transaction.error.code == 0 )
    {
        [ [ SKPaymentQueue defaultQueue ] restoreCompletedTransactions];
    }
    
    [ [ SKPaymentQueue defaultQueue ] finishTransaction:transaction ];
}


- (void) paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [ self completeTransaction:transaction ];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                buy = NO;
                break;
            case SKPaymentTransactionStateRestored:
                [ self completeTransaction:transaction ];
                buy = NO;
                break;
            case SKPaymentTransactionStatePurchasing:
                break;
            default:
                break;
        }
    }
}


- (void) buyGoods:( int ) index
{
    if ( !products || products.count == 0 || products.count < ( index + 1 ) )
    {
        return;
    }
    
    SKProduct *sko = [products objectAtIndex:index];
    
    if ( buy )
    {
        return;
    }
    
    buy = YES;
    
    SKMutablePayment *payment = [ SKMutablePayment paymentWithProduct:sko ];
    payment.quantity = 1;
    [ [ SKPaymentQueue defaultQueue ] addPayment:payment ];
}


@end

