//
//  GamePlayerAction.h
//  ixyhz
//
//  Created by fox1 on 12-7-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MapGridPos.h"
#import "GameCreature.h"




@interface GameCreatureAction : NSObject
{
    BOOL loading;
    BOOL onLoad;
    
    CCAnimation* animation;
    CCAnimate* animate;
    
    CCTexture2D* texture;
    
    NSMutableArray* frameArray;
    NSDictionary* actionDic;
    
    NSString* actionID;
    
    NSString* action;
    
    int direction;
    
    CCSprite* owner;
    NSObject* target;
    SEL sel;
    
    BOOL loop;
    
    CGRect textureRect;
    
    BOOL inited;
    NSString* isloading;
}


@property ( nonatomic ) BOOL UseAgain , UseAsync , NoClear , UseDefault;
@property ( nonatomic , assign ) CCSprite* Owner;
@property ( nonatomic , readonly ) NSString* Action;
@property ( nonatomic , readonly ) NSString* ActionID;
@property ( nonatomic , assign ) CCTexture2D* Texture;


- ( CGRect ) getRect;

- ( BOOL ) checkPointIn:( float )x :( float )y;

- ( void ) setLoop:( BOOL )loop;
- ( BOOL ) playEffect:( NSObject* )t :( SEL )s;
- ( BOOL ) setAction:( NSString* ) a :( int )d;
- ( void ) setActionID:( NSString* )i;
- ( void ) clearAction;

- ( void ) initAction:( CCSprite* )o;
- ( void ) releaseAction;





@end




