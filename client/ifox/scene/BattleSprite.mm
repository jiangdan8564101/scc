//
//  BattleSprite.m
//  sc
//
//  Created by fox on 13-2-13.
//
//

#import "BattleSprite.h"
#import "BattleSpriteAction.h"
#import "MapGridPos.h"

@implementation BattleSprite

@synthesize Type , PosX , PosY;

- ( void ) setPos:( int ) x :( int )y
{
    PosX = x;
    PosY = y;
    
    CGPoint point = CGPointMake( x * MG_GRID_X + MG_GRID_X_HALF , y * MG_GRID_Y + MG_GRID_Y_HALF );
    
    point = [ [ CCDirector sharedDirector ] convertToGL:point ];
    
    [ self setPosition:point ];
}

- ( void ) update:( float )delay
{
    
}

- ( void ) playEffect:( NSString* )i :(NSObject*)o :(SEL)s
{
    battleSpriteAction.UseAsync = NO;
    [ battleSpriteAction setActionID:i ];
    [ battleSpriteAction playEffect:self :@selector(onEffectOver)];
    
    object = o;
    sel = s;
}


- ( void ) onEffectOver
{
    [ object performSelector:sel withObject:self ];

    object = NULL;
    sel = NULL;
}


- ( void ) setAction:( int )i
{
    [ battleSpriteAction setAction:i ];
}

- ( int ) getActionIndex
{
    return [ battleSpriteAction ActionIndex ];
}


- ( void ) setActionID:( NSString* )i
{
    [ battleSpriteAction setActionID:i ];
}

- ( void ) initBattleSprite
{
    battleSpriteAction = [ [ BattleSpriteAction alloc ] init ];
    [ battleSpriteAction initAction:self ];
}

- ( void ) releaseBattleSprite
{
    [ battleSpriteAction releaseAction ];
    [ battleSpriteAction release ];
    battleSpriteAction = NULL;
}





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
//    return [ battleSpriteAction getRect ];
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
//    
//}



@end
