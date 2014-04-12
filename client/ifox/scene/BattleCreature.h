//
//  BattleCreature.h
//  sc
//
//  Created by fox on 13-2-12.
//
//

#import "GameCreature.h"
#import "BattleCreatureMove.h"
#import "CreatureConfig.h"

@class BattleMapLayer;

@interface BattleCreature : GameCreature
{
    BattleCreatureMove* battleCreatureMove;
    
    MapGrid* originalGrid;
    
    NSObject* object;
    SEL sel;
    
    NSObject* object1;
    SEL sel1;
}

@property ( nonatomic ) BOOL ACT;
@property ( nonatomic , assign ) CreatureCommonData* CommonData;
@property ( nonatomic , assign ) BattleMapLayer* MapLayer;


- ( MapGrid* ) getOriginalPos;
- ( MapGrid* ) getPos;
- ( MapGrid* ) getLastPos;

- ( void ) setOriginalPos:( int )x :( int )y;
- ( void ) setPos:( int ) x :( int )y;
- ( void ) backPos;
- ( void ) switchPos;

- ( void ) startMovingWithMovePath:( NSArray* ) array;
- ( BOOL ) startMove:( int )x :( int )y;
- ( BOOL ) startMove:(int)x :(int)y :(NSObject*)obj :(SEL)s :(NSObject*)obj1 :(SEL)s1;
- ( BOOL ) isMoving;
- ( void ) movePosition;

- ( BOOL ) checkTerrain:( int )t;
- ( BOOL ) checkDoor:( int )d;


- ( void ) move;
- ( void ) endMove;
- ( void ) onEndMove;

- ( void ) endACT;
- ( void ) startDead;

- ( void ) synMaxHP:( int )hp SP:( int )sp FS:( int )fs;
- ( void ) addHP:( int )hp SP:( int )sp FS:( int )fs;

@end


