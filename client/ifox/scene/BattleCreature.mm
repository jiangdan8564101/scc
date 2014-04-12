//
//  BattleCreature.m
//  sc
//
//  Created by fox on 13-2-12.
//
//

#import "BattleCreature.h"
#import "BattleMapScene.h"
#import "PlayerData.h"
#import "ItemData.h"

@implementation BattleCreature
@synthesize CommonData , ACT , MapLayer;

//- (void) onEnter
//{
//    [ [ [ CCDirector sharedDirector ] touchDispatcher ] addTargetedDelegate:self priority:0 swallowsTouches:YES ];
//
//    [ super onEnter ];
//}
//
//
//- (void) onExit
//{
//    [ [ [ CCDirector sharedDirector ] touchDispatcher ] removeDelegate:self ];
//    
//    [ super onExit ];
//}
//
//
//- (CGRect) getRect
//{
//    return [ creatureAction getRect ];
//}
//
//- ( BOOL ) containsTouchLocation:( UITouch *)touch
//{
//    return CGRectContainsPoint( [ self getRect ] , [ self convertTouchToNodeSpaceAR:touch ] );
//}
//
//
//- ( BOOL ) ccTouchBegan:( UITouch *)touch withEvent:( UIEvent *)event
//{
//    if ( ![ self containsTouchLocation:touch ] )
//    {
//        return NO;
//    }
//    
//    return YES;
//}
//
//- ( void ) ccTouchEnded:( UITouch* )touch withEvent:( UIEvent* )event
//{
//    if ( [ self checkACT ] && !MapScene.LastSelect )
//    {
//        CGPoint point = [touch locationInView: [touch view]];
//        [ [ BattleCommandUIHandler instance ] visible:YES ];
//        [ [ BattleCommandUIHandler instance ] setData:self ];
//        [ [ BattleCommandUIHandler instance ] setPos:point.x :point.y ];
//        
//        MapScene.LastSelect = self;
//        [ MapScene getMovePath:self ];
//    }
//}

- ( BOOL ) checkTerrain:( int )t
{
    return [ CommonData isEquipSkillMoveType:t ];
}

- ( BOOL ) checkDoor:( int )d
{
    switch ( d )
    {
        case GSFT_Door1:
        {
            PackItemData* data = [ [ ItemData instance ] getItem:KEY_ITEM1 ];
            if ( data.Number > 0 )
            {
                return YES;
            }
        }
            break;
        case GSFT_Door2:
        {
            PackItemData* data = [ [ ItemData instance ] getItem:KEY_ITEM2 ];
            if ( data.Number > 0 )
            {
                return YES;
            }
        }
            break;
        case GSFT_Door3:
        {
            PackItemData* data = [ [ ItemData instance ] getItem:KEY_ITEM3 ];
            if ( data.Number > 0 )
            {
                return YES;
            }
        }
            break;
    }
    
    return NO;
}

- ( BOOL ) startMove:( int )x :( int )y
{
    if ( battleCreatureMove.MapPos.Grid.PosX == x && battleCreatureMove.MapPos.Grid.PosY == y )
    {
        return NO;
    }
    
    if ( battleCreatureMove.IsMoving )
    {
        
    }
    
    BOOL b = [ battleCreatureMove findPath:x :y ];
    
    if ( b )
    {
        [ battleCreatureMove startMoving ];
    }
    
    return b;
}

- ( BOOL ) startMove:(int)x :(int)y :(NSObject*)obj :(SEL)s :(NSObject*)obj1 :(SEL)s1
{
    BOOL b = [ self startMove:x :y ];
    
    object = obj;
    sel = s;
    
    object1 = obj1;
    sel1 = s1;
    
    return b;
}

- ( void ) startMovingWithMovePath:( NSArray* ) array
{
    [ battleCreatureMove startMovingWithMovePath:array ];
}

- ( BOOL ) isMoving
{
    return [ battleCreatureMove IsMoving ];
}

- ( void ) movePosition
{
    [ object performSelector:sel ];
}

- ( MapGrid* ) getOriginalPos
{
    return originalGrid;
}

- ( MapGrid* ) getPos
{
    return battleCreatureMove.MapPos.Grid;
}

- ( MapGrid* ) getLastPos
{
    return battleCreatureMove.MapGridLast;
}

- ( void ) setOriginalPos:( int )x :( int )y
{
    [ originalGrid setGrid:x :y ];
}

- ( void ) setPos:( int ) x :( int )y
{
    if ( !battleCreatureMove || battleCreatureMove.IsMoving )
    {
        return;
    }
    
    [ battleCreatureMove setPos:x :y ];
    
    [ self move ];
}


- ( void ) backPos
{
    [ self endMove ];
    [ self setPos:originalGrid.PosX :originalGrid.PosY ];
}

- ( void ) switchPos
{
    int x = originalGrid.PosX;
    int y = originalGrid.PosY;
    
    int px = [ self getPos ].PosX;
    int py = [ self getPos ].PosY;
    
    [ MapLayer setMapSpriteCreature:x :y :NULL ];
    [ MapLayer setMapSpriteCreature:px :py :self ];
    [ self setOriginalPos:px :py ];
}

- ( void ) move
{
    CGPoint point = CGPointMake( battleCreatureMove.MapPos.Grid.RealPosX , battleCreatureMove.MapPos.Grid.RealPosY );
    
    point = [ [ CCDirector sharedDirector ] convertToGL:point ];
    
    [ self setPosition:point ];
    
    [ object1 performSelector:sel1 withObject:nil ];
    
    [ battleCreatureMove.MapPos updateSpeed ];
}

- ( void ) endMove
{
    [ battleCreatureMove endMoving ];
}

- ( void ) onEndMove
{
    [ object performSelector:sel ];
    object = NULL;
    sel = NULL;
}


- ( void ) addHP:( int )hp SP:( int )sp FS:( int )fs
{
    CommonData.RealBaseData.HP = CommonData.RealBaseData.HP + hp;
    if ( CommonData.RealBaseData.HP <= 0 )
    {
        CommonData.RealBaseData.HP = 0;
        CommonData.Dead = YES;
    }
    
    CommonData.RealBaseData.SP = CommonData.RealBaseData.SP + sp;
    if ( CommonData.RealBaseData.SP <= 0 )
    {
        CommonData.RealBaseData.SP = 0;
    }
    
    CommonData.RealBaseData.FS = CommonData.RealBaseData.FS + fs;
    if ( CommonData.RealBaseData.SP <= 0 )
    {
        CommonData.RealBaseData.FS = 0;
    }
    
}

- ( void ) endACT
{
    ACT = NO;
}

- ( void ) startDead
{
    [ MapLayer removeCreature:self ];
}

- ( void ) synMaxHP:( int )hp SP:( int )sp FS:( int )fs
{
    CommonData.RealBaseData.MaxHP = hp;
    CommonData.RealBaseData.MaxSP = sp;
    CommonData.RealBaseData.MaxFS = fs;
}


- ( void ) initCreature
{
    if ( inited )
    {
        return;
    }
    
    [ super initCreature ];
    
    battleCreatureMove = [ [ BattleCreatureMove alloc ] init ];
    [ battleCreatureMove initBattleCreatureMove:self ];
    [ battleCreatureMove.MapPos updateSpeed ];
    
    self.ACT = NO;
    originalGrid = [ [ MapGrid alloc ] init];
    
    
    //[ self playEffect:@"SO015A" :nil :nil ];
}


- ( void ) releaseCreature
{
    if ( !inited )
    {
        return;
    }
    
    object = NULL;
    sel = NULL;
    
    
    [ battleCreatureMove releaseBattleCreatureMove ];
    [ battleCreatureMove release ];
    battleCreatureMove = NULL;
    
    [ super releaseCreature ];
    
    if ( self.parent )
    {
        [ self removeFromParentAndCleanup:YES ];
    }
    
    [ CommonData release ];
    CommonData = NULL;
    
    [ originalGrid release ];
    originalGrid = NULL;
}



- ( void ) update:( float )delay
{
    [ battleCreatureMove update:delay ];
}

@end
