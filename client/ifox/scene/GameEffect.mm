//
//  GameEffect.m
//  ixyhz
//
//  Created by fox on 12-8-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GameEffect.h"
#import "GameCreatureAction.h"

@implementation GameEffect



- ( void ) onUpdateHeight:( int )h
{
    
}

- ( void ) addEffect:( NSString* )i
{
    if ( [ effectDic objectForKey:i ] )
    {
        return;
    }
    
    CCSprite* sprite = [ [ CCSprite alloc ] init ];
    [ self addChild:sprite ];
    
    GameCreatureAction* action = [ [ GameCreatureAction alloc ] init ];
    [ action initAction:sprite ];
    [ action setUseAsync:NO ];
    [ action setUseDefault:NO ];
    [ action setLoop:YES ];
    [ action setActionID:i ];
    //[ action playEffect:<#(int)#> :<#(int)#> :<#(int)#> :<#(NSObject *)#> :<#(SEL)#>
    
    
    
    [ effectDic setObject:action forKey:i ];
}



- ( void ) setEffectPos:( NSString* )i :( float )x :( float )y
{
    GameCreatureAction* action = [ effectDic objectForKey:i ];
    
    if ( !action )
    {
        return;
    }
    
    action.Owner.position = ccp( x , y );
}


- ( void ) removeEffect:( NSString* )i
{
    GameCreatureAction* action = [ effectDic objectForKey:i ];
    
    if ( !action )
    {
        return;
    }
    
    [ self releaseEffect:action ];
    [ effectDic removeObjectForKey:i ];
}


- ( void ) releaseEffect:( GameCreatureAction* ) action
{
    CCSprite* sprite = action.Owner;
    
    [ action releaseAction ];
    [ action release ];
    
    [ sprite removeFromParentAndCleanup:YES ];
    [ sprite release ];
}


- ( void ) removeAllEffect
{
    NSEnumerator* enumerator = [ effectDic objectEnumerator ];
    GameCreatureAction* action;
    
    while ( action = [ enumerator nextObject ] )
    {
        [ self releaseEffect:action ];
    }
    
    [ effectDic removeAllObjects ];
}

- ( void ) initEffect
{
    effectDic = [ [ NSMutableDictionary alloc ] init ];
}

- ( void ) releaseEffect
{
    [ effectDic release ];
}


@end
