//
//  BattleRegion.h
//  sc
//
//  Created by fox on 13-1-19.
//
//

#import "cocos2d.h"
#import "BattleMapSprite.h"


@interface BattleMapRegion : NSObject
{
    
}

@property ( nonatomic , assign ) NSMutableArray* Sprites;
@property ( nonatomic ) int RegionID;


- ( void ) initBattleMapRegion;
- ( void ) releaseBattleMapRegion;

- ( void ) clear;

@end
