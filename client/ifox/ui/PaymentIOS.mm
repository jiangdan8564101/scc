//
//  PaymentIOS.cpp
//  
//


#import "PaymentIOS.h"
#import "ItemData.h"
#import "GameDataManager.h"
#import "AlertUIHandler.h"

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
    int n = 0;
    if ( [ transaction.payment.productIdentifier isEqualToString:@"Cat1" ] )
    {
        n = 12;
    }
    else if ( [ transaction.payment.productIdentifier isEqualToString:@"Cat2" ] )
    {
        n = 28;
    }
    else if ( [ transaction.payment.productIdentifier isEqualToString:@"Cat3" ] )
    {
        n = 50;
    }
   
    
    [ [ ItemData instance ] addItem:SPECIAL_ITEM :n ];
    [ [ GameDataManager instance ] setBuyItem:n ];
    
    [ [ AlertUIHandler instance ] alert:NSLocalizedString( @"BuySuccess" , nil ) ];
    playSound( PST_ALCHEMY );
    
    [ [ SKPaymentQueue defaultQueue ] finishTransaction:transaction ];
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
                buy = NO;
                [ self completeTransaction:transaction ];
                break;
            case SKPaymentTransactionStateFailed:
                buy = NO;
                [self failedTransaction:transaction];                
                break;
            case SKPaymentTransactionStateRestored:
                buy = NO;
                [ self completeTransaction:transaction ];
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

