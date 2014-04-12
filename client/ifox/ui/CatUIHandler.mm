//
//  CatUIHandler.m
//  sc
//
//  Created by fox on 14-3-30.
//
//

#import "CatUIHandler.h"
#import "PaymentIOS.h"

@implementation CatUIHandler



static CatUIHandler* gCatUIHandler;
+ (CatUIHandler*) instance
{
    if ( !gCatUIHandler )
    {
        gCatUIHandler = [ [ CatUIHandler alloc] init ];
        [ gCatUIHandler initUIHandler:@"CatUIView" isAlways:YES isSingle:NO ];
    }
    
    return gCatUIHandler;
}


- ( void ) onInited
{
    UIButton* b = (UIButton*)[ view viewWithTag:1000 ];
    [ b addTarget:self action:@selector(onClose) forControlEvents:UIControlEventTouchUpInside ];
    
    for ( int i = 0 ; i < 3 ; ++i )
    {
        UIButton* button = (UIButton*)[ view viewWithTag:100 + i ];
        [ button addTarget:self action:@selector(onBuy:) forControlEvents:UIControlEventTouchUpInside ];
    }
    
}


- ( void ) onClose
{
    [ self visible:NO ];
}


- ( void ) onBuy:( UIButton* )b
{
    [ [ PaymentIOS instance ] buyGoods:b.tag - 100 ];
}


@end
