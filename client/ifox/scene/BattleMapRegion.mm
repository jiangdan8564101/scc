//
//  BattleRegion.m
//  sc
//
//  Created by fox on 13-1-19.
//
//

#import "BattleMapRegion.h"

@implementation BattleMapRegion

@synthesize RegionID , Sprites;

- ( void ) initBattleMapRegion
{
    Sprites = [ [ NSMutableArray alloc ] init ];
}
- ( void ) releaseBattleMapRegion
{
    [ Sprites release ];
    Sprites = NULL;
}

- ( void ) clear
{
    RegionID = 0;
    [ Sprites removeAllObjects ];
}

@end



