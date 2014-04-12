//
//  GameDataManager.h
//  sc
//
//  Created by fox1 on 12-7-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ClientDefine.h"

@interface GameDataManager : NSObject
{
    NSMutableDictionary* gameData;
}

- ( void ) setBuyItem:( int )i;
- ( int ) getBuyItem;

-( void ) saveData;
-( BOOL ) hasData;
-( BOOL ) readData;

- ( void ) initGameData;
- ( void ) releaseGameData;

+ ( GameDataManager* ) instance;

@end
