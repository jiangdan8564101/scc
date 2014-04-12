//
//  GameCreature.h
//  ixyhz
//
//  Created by fox on 12-8-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameEffect.h"
#import "GameUnit.h"



#define CAT_STAND @"stand"
#define CAT_MOVE @"move"
#define CAT_EFFECT @"effect"
#define CAT_DEFAULT @"default"


@class GameCreatureAction;


@interface GameCreature : GameUnit
{
    GameCreatureAction* creatureAction;
    GameCreatureAction* effectAction;
    
    CCSprite* creatureSprite;
    CCSprite* uiSprite;
    CCSprite* effectSprite;
    
    
    GameEffect* effect;
    
    NSString* actionID;
    
    BOOL inited;
}




@property ( nonatomic , readonly ) BOOL Inited;

- ( void ) update:( float )delay;

- ( void ) setAction:(NSString*)i :(int)dir;
- ( void ) setActionID:(NSString*)i;

- ( void ) playEffect:( NSString* )i :( NSObject* )obj :(SEL)s;
- ( void ) addEffectString:( NSString* )s;
- ( void ) addEffectNode:( CCNode* )node;
- ( void ) setEffectPos:( float )x :( float )y;


- ( void ) initCreature;
- ( void ) releaseCreature;


- ( NSString* ) getActionID;
- ( NSString* ) getAction;
- ( BOOL ) checkAction:( NSString* )a;

@property ( nonatomic , assign ) CCSprite* EffectSprite;
@property ( nonatomic , assign ) CCSprite* CreatureSprite;
@property ( nonatomic , assign ) CCSprite* UISprite;

@property ( nonatomic , assign ) GameEffect* Effect;
@property ( nonatomic , assign ) GameCreatureAction* CreatureAction;
@property ( nonatomic , assign ) GameCreatureAction* EffectAction;

@end
