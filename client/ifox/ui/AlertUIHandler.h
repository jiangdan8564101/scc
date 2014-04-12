//
//  AlertUIHandler.h
//  sc
//
//  Created by fox on 13-12-12.
//
//

#import "UIHandlerZoom.h"

@interface AlertUIHandler : UIHandlerZoom
{
    int n;
}


+ ( AlertUIHandler* ) instance;

- ( void ) alert:( NSString* )str;

@end
