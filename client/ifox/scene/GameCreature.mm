//
//  GameCreature.m
//  ixyhz
//
//  Created by fox on 12-8-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GameCreature.h"
#import "GameCreatureAction.h"

@implementation GameCreature

@synthesize CreatureSprite = creatureSprite , EffectSprite = effectSprite , UISprite = uiSprite , Effect = effect , CreatureAction = creatureAction , EffectAction = effectAction , Inited = inited ;





- ( void ) playEffect:( NSString* )i :( NSObject* )obj :(SEL)s
{
    [ effectAction releaseAction ];
    [ effectAction initAction:effectSprite ];
    
    [ effectAction setUseDefault:NO ];
    [ effectAction setUseAsync:NO ];
    [ effectAction setLoop:NO ];
    [ effectAction setActionID:i ];
    [ effectAction playEffect:obj :s ];
}

- ( void ) setEffectPos:( float )x :( float )y
{
    effectSprite.position = ccp( x , y );
}

- ( void ) addEffectString:( NSString* )s
{
    CCLabelBMFont* label = [ CCLabelTTF labelWithString:s fontName:@"Marker Felt" fontSize:19 ];
    [ effectSprite addChild:label ];
    effectSprite.scaleX = 1.0f;
    effectSprite.scaleY = 1.0f;
    
    [ label setColor4:ccc3(255,0,0) :ccc3(0,255,0) :ccc3(255,255,0) :ccc3(255,255,0) ];
}

- ( void ) addEffectNode:( CCNode* )node
{
    [ effectSprite addChild:node ];
}

- ( NSString* ) getActionID
{
    return creatureAction.Action;
}

- ( NSString* ) getAction
{
    return creatureAction.Action;
}


- ( BOOL ) checkAction:( NSString* )a
{
    return [ creatureAction.Action isEqualToString:a ];
}


- ( void ) initCreature
{
    if ( inited )
    {
        return;
    }
    
    creatureSprite = [ CCSprite node ];
    [ self addChild:creatureSprite ];
    
    effect = [ [ GameEffect alloc ] init ];
    [ effect initEffect ];
    [ self addChild:effect ];
    
    uiSprite = [ CCSprite node ];
    [ self addChild:uiSprite ];
    
    effectSprite = [ CCSprite node ];
    [ self addChild:effectSprite ];
    
    creatureAction = [ [ GameCreatureAction alloc ] init ];
    [ creatureAction initAction:creatureSprite ];
    
    effectAction = [ [ GameCreatureAction alloc ] init ];
    [ effectAction initAction:effectSprite ];
    
    inited = YES;
}


- ( void ) releaseCreature
{
    if ( !inited )
    {
        return;
    }
    
    inited = NO;
    
    [ creatureAction releaseAction ];
    [ creatureAction release ];
    creatureAction = NULL;
    
    [ effectAction releaseAction ];
    [ effectAction release ];
    effectAction = NULL;
    
    [ effect removeAllEffect ];
    [ effect removeFromParentAndCleanup:YES ];
    [ effect releaseEffect ];
    [ effect release ];
    effect = NULL;
    
    [ creatureSprite removeFromParentAndCleanup:YES ];
    creatureSprite = NULL;
    
    [ uiSprite removeFromParentAndCleanup:YES ];
    uiSprite = NULL;
    
    [ effectSprite removeFromParentAndCleanup:YES ];
    effectSprite = NULL;
    
    [ actionID release ];
    actionID = NULL;
}

- ( void ) update:( float )delay
{
    
}


- ( void ) setActionID:(NSString*)i
{
    [ actionID release ];
    actionID = [ [ NSString alloc ] initWithString:i ];
}


- ( void ) setAction:(NSString*)i :(int)dir
{
    if ( [ i isEqualToString:CAT_STAND ] )
    {
        [ creatureAction setActionID:[ NSString stringWithFormat:@"CP%@A" , actionID ] ];
    }
    else if ( [ i isEqualToString:CAT_MOVE ] )
    {
        [ creatureAction setActionID:[ NSString stringWithFormat:@"CP%@B" , actionID ] ];
    }
    
    [ creatureAction setAction:i :dir ];
}

@end
