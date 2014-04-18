//
//  PaymentIOS.h
//  
//


#import <StoreKit/SKProductsRequest.h>
#import <StoreKit/SKProduct.h>
#import <StoreKit/SKPaymentQueue.h>
#import <StoreKit/SKPayment.h>
#import <StoreKit/SKPaymentTransaction.h>

@interface PaymentIOS : NSObject< SKProductsRequestDelegate , SKPaymentTransactionObserver >
{
    NSMutableArray* products;
    
    BOOL buy;
}

- ( NSMutableArray* ) getList;
- ( void ) getList:( NSMutableArray* )arr;
- ( void ) buyGoods:( int ) index;

+ ( PaymentIOS* ) instance;

@end



