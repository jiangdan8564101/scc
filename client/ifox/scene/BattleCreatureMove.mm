

#import "BattleCreatureMove.h"

#import "PathFinder.h"
#import "BattleCreature.h"
#import "GameSceneManager.h"
#import "GameCreatureAction.h"

#import "BattleMapLayer.h"


@implementation BattleCreatureMove


@synthesize MapPos = mapPos;
@synthesize IsMoving = isMoving;
@synthesize MapGridLast = mapGridLast;

- ( void ) initBattleCreatureMove:( BattleCreature* )c
{
    owner = c;
    
    mapPos = [ [ MapGridPos alloc ] init ];
    [ mapPos initGridPos ];
    
    movePos = [ [ MapGrid alloc ] init ];
    
    mapGridLast = [ [ MapGrid alloc ] init ];
    
    movePathCount = 0;
    movePathIndex = 0;
    
    isMoving = NO;
}


- ( void ) releaseBattleCreatureMove
{
    [ mapPos releaseGridPos ];
    [ mapPos release ];
    mapPos = NULL;
    
    [ movePos release ];
    movePos = NULL;
    
    [ mapGridLast release ];
    mapGridLast = NULL;
    
    movePathCount = 0;
    movePathIndex = 0;
    
    isMoving = NO;
}


- ( void ) setSpeed:( float )speed
{
    mapPos.Speed = speed;
}


- ( void ) endMoving
{
    if ( movePathCount )
    {
//        int index = movePath[ movePathCount - 1 ];
//        
//        [ mapPos.Grid setGrid:[ owner.MapLayer.Finder getX:index ] :[ owner.MapLayer.Finder getY:index ] ];
        movePathCount = 0;
    }
    
    movePathIndex = 0;
    
    
    [ owner setAction:CAT_STAND :moveDirection ];
    [ owner move ];
    
    if ( owner.parent )
    {
        CCNode* node = owner.parent;
        
        CGPoint point = owner.position;
        point = [ [ CCDirector sharedDirector ] convertToUI:point ];
        
        // use ui pos,
        [ node reorderChild:owner z:point.y ];
    }
    
    isMoving = NO;
}

- ( void ) startMoving
{
    [ self updateDirection ];
}


- ( void ) startMovingWithMovePath:( NSArray* )array
{
    if ( array.count < 2 )
    {
        return;
    }
    
    int index = [ [ array objectAtIndex:0 ] intValue ];
    
    [ self endMoving ];
    [ self setPos:[ owner.MapLayer.Finder getX:index ] :[ owner.MapLayer.Finder getY:index ] ];
    
    for ( int i = 1 ; i < array.count ; i++ )
    {
        movePath[ i - 1 ] = [ [ array objectAtIndex:i ] intValue ];
    }
    
    movePathCount = array.count - 1;
    
    [ self startMoving ];
}


- ( void ) updateDirection
{
    if ( !movePathCount || movePathIndex >= movePathCount )
    {
        [ self endMoving ];
        [ owner onEndMove ];
        return;
    }
    
    int index = movePath[ movePathIndex ];
    [ movePos setGrid:[ owner.MapLayer.Finder getX:index ] :[ owner.MapLayer.Finder getY:index ] ];
    
    int lastDirection = moveDirection;
    
    moveDirection = [ MapGridPos getDirect:movePos :mapPos.Grid ];
    
    if ( moveDirection == MG_DIRECT_COUNT )
    {
        moveDirection = lastDirection;
    }
    
    isMoving = YES;
    
    [ owner setAction:CAT_MOVE :moveDirection ];
    [ owner movePosition ];
    
    [ mapPos startMove:movePos ];
    
    [ mapGridLast copyGrid:mapPos.Grid ];
    
    movePathIndex++;
    
}


- ( BOOL ) findPath:(int)x :(int)y
{
    movePathCount = [ owner.MapLayer.Finder findPath:movePath :mapPos.Grid.PosX :mapPos.Grid.PosY :x :y ];
    
    if ( !movePathCount )
    {
        return NO;
    }
    
    movePathIndex = 1;
    
    return YES;
}


- ( void ) setPos:( int )x :( int ) y
{
    [ mapPos.Grid setGrid:x :y ];
}


- ( void ) update:( float )delay
{
    if ( !isMoving )
    {
        return;
    }
    
    [ mapPos move:delay ];
    [ owner move ];
    
    if ( !mapPos.isMoving )
    {
        [ self updateDirection ];
    }
}




@end
