//
//  AlertUIHandler.m
//  sc
//
//  Created by fox on 13-12-12.
//
//

#import "AlertUIHandler.h"

@implementation AlertUIHandler


static AlertUIHandler* gAlertUIHandler;
+ (AlertUIHandler*) instance
{
    if ( !gAlertUIHandler )
    {
        gAlertUIHandler = [ [ AlertUIHandler alloc] init ];
        [ gAlertUIHandler initUIHandler:@"AlertUIView" isAlways:YES isSingle:NO ];
    }
    
    return gAlertUIHandler;
}


- ( void ) onInited
{
    [ super onInited ];
    
    view.tag = 12300000;
    
    UIButton* button = (UIButton*)[ view viewWithTag:200 ];
    [ button addTarget:self action:@selector(onCloseClick) forControlEvents:UIControlEventTouchUpInside ];
}


- ( void ) alert:( NSString* )str
{
    [ self visible:YES ];
    UILabel* textView = (UILabel*)[ view viewWithTag:1000 ];
    [ textView setText:str ];
    n = 0;
    
}


- ( void ) onClosed
{
    [ super onClosed ];
}

- ( void ) onCloseClick
{
    n++;
    
    if ( n > 1 )
    {
        [ self visible:NO ];
    }
}

@end
