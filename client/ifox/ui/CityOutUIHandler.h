//
//  CityOutUIHandler.h
//  sc
//
//  Created by fox on 13-12-13.
//
//

#import "UIHandlerZoom.h"

@interface CityOutUIHandler : UIHandlerZoom
{


}

+ ( CityOutUIHandler* ) instance;

- ( void ) setBG:( NSString* )name;
- ( void ) fade:( float )f;
- ( void ) fadeRight:( float )f;
- ( void ) fadeLeft:( float )f;

@end
