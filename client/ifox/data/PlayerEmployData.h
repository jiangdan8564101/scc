//
//  PlayerEmployData.h
//  sc
//
//  Created by fox on 13-9-15.
//
//

#import "GameData.h"
#import "CreatureConfig.h"

@interface PlayerEmployData : GameData


@property ( nonatomic , assign ) BOOL Reload;
@property ( nonatomic , assign ) NSMutableArray* PlayerArray;

+ ( PlayerEmployData* ) instance;

- ( void ) reloadData;

- ( void ) employCreature:( int )i;

- ( void ) employ:( int )i;
- ( BOOL ) canEmploy:( int )i;

@end
