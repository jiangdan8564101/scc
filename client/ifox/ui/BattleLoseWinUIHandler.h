//
//  BattleLoseWinUIHandler.h
//  sc
//
//  Created by fox on 13-8-25.
//
//

#import "UIHandlerZoom.h"

@interface BattleLoseWinUIHandler : UIHandlerZoom
{

}

+ ( BattleLoseWinUIHandler* ) instance;

- ( void ) show:( NSString* )name :( BOOL )win :( float )per;

@end
