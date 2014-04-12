//
//  BattleCreatureMove.h
//  sc
//
//  Created by fox on 13-2-12.
//
//

#import <Foundation/Foundation.h>
#import "MapGridPos.h"

@class BattleCreature;



@interface BattleCreatureMove : NSObject
{
    MapGridPos* mapPos;
    
    int movePath[ 256 ];
    int movePathCount;
    int movePathIndex;
    
    
    MapGrid* movePos;
    
    int moveDirection;
    
    BattleCreature* owner;

    MapGrid* mapGridLast;
    
    BOOL isMoving;
}

@property ( nonatomic , readonly ) BOOL IsMoving;
@property ( nonatomic , readonly ) MapGridPos* MapPos;
@property ( nonatomic , readonly ) MapGrid* MapGridLast;



- ( BOOL ) findPath:(int)x :(int)y;

- ( void ) initBattleCreatureMove:( BattleCreature* )c;
- ( void ) releaseBattleCreatureMove;
- ( void ) setSpeed:( float )speed;

- ( void ) endMoving;
- ( void ) startMoving;
- ( void ) startMovingWithMovePath:( NSArray* )array;

- ( void ) updateDirection;

- ( void ) setPos:( int )x :( int ) y;

- ( void ) update:( float )delay;


@end

