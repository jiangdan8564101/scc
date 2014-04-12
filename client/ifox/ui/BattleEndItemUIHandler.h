//
//  BattleEndItem.h
//  sc
//
//  Created by fox on 13-5-19.
//
//

#include "UIHandlerZoom.h"


@interface BattleEndItemUIHandler : UIHandlerZoom
{
    
}

- ( void ) setWin:( BOOL )win :( NSString* )name :( float )per;
- ( void ) setData:( NSMutableDictionary* )dic :(int)gold;

+ ( BattleEndItemUIHandler* ) instance;


@end
