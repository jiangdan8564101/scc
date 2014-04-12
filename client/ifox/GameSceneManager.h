//
//  GameSceneManager.h
//  ixyhz
//
//  Created by fox1 on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <GameKit/GameKit.h>

#import "cocos2d.h"
#import "GameScene.h"

#define GS_WORK @"work"
#define GS_CITY @"city"
#define GS_WORLD @"world"
#define GS_BATTLE @"battle"
#define GS_BATTLE1 @"battle1"
#define GS_PUBLIC @"public"
#define GS_SHOP @"shop"
#define GS_PROFESSION @"profession"
#define GS_CITYOUT @"cityOut"
#define GS_MONSTER @"monster"
#define GS_ASSOCIATION @"association"


@interface GameSceneManager : NSObject
{
    NSDictionary* sceneDictionary;
    
    GameScene* activeScene;
}


+( GameSceneManager* )instance;



-( GameScene* )getActiveScene;


- ( void ) activeScene:( NSString* )scene;
- ( void ) exitScene;

- ( void ) initSceneManager;
- ( void ) releaseSceneManager;


- ( BOOL ) checkScene:( NSString* )scene;


- ( void ) update:( float )delay;



@end

