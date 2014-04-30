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
    
    int buyCount;
    BOOL buy;
}

- ( NSMutableArray* ) getList;
- ( void ) getList:( NSMutableArray* )arr;
- ( void ) buyGoods:( int ) index;
- ( void ) complete;

+ ( PaymentIOS* ) instance;

@end



