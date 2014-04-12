//
//  GameSceneManager.m
//  ixyhz
//
//  Created by fox1 on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GameSceneManager.h"
#import "CityMapScene.h"
#import "GameManager.h"
#import "WorldMapScene.h"
#import "WorkMapScene.h"
#import "BattleMapScene.h"
#import "PublicMapScene.h"
#import "ProfessionMapScene.h"
#import "ShopMapScene.h"
#import "CityOutMapScene.h"
#import "MonsterMapScene.h"
#import "AssociationMapScene.h"

@implementation GameSceneManager





GameSceneManager* gGameSceneManager = NULL;
+( GameSceneManager* ) instance;
{
    if ( !gGameSceneManager )
    {
        gGameSceneManager = [ [ GameSceneManager alloc ] init ];
    }
    
    return gGameSceneManager;
}



-( GameScene* ) getActiveScene
{
    return activeScene;
}


-( void ) activeScene:( NSString* )scene
{
    ///GamePlayer* player = [ GameManager instance ].MainPlayer;
    //[ player endMove ];
    
    if ( activeScene )
    {
        if ( [ scene isEqualToString:activeScene.Name ] )
        {
            return;
        }
        
        [ activeScene onExitMap ];
    }
    
    activeScene = [ sceneDictionary objectForKey:scene ];
    
    if ( [ [ CCDirector sharedDirector ] runningScene ] )
    {
        [ [ CCDirector sharedDirector ] popScene ];
    }
    
    
    [ [ CCDirector sharedDirector ] runWithScene:activeScene ];
    [ activeScene onEnterMap ];
}

- ( void ) exitScene
{
    if ( [ [ CCDirector sharedDirector ] runningScene ] )
    {
        [ [ CCDirector sharedDirector ] popScene ];
    }
    
    [ activeScene onExitMap ];
    activeScene = NULL;
}



- ( void ) update:( float )delay
{
    if ( activeScene )
    {
        [ activeScene update:delay ];
    }
}


- ( void ) initSceneManager
{
    CityMapScene* city = [ CityMapScene instance ];
    [ city initScene:GS_CITY ];
    WorldMapScene* world = [ WorldMapScene instance ];
    [ world initScene:GS_WORLD ];
    WorkMapScene* work = [ WorkMapScene instance ];
    [ work initScene:GS_WORK ];
    BattleMapScene* battle = [ BattleMapScene instance ];
    [ battle initScene:GS_BATTLE ];
    
    PublicMapScene* public1 = [ PublicMapScene instance ];
    [ public1 initScene:GS_PUBLIC ];
    ShopMapScene* shop = [ ShopMapScene instance ];
    [ shop initScene:GS_SHOP ];
    ProfessionMapScene* pro = [ ProfessionMapScene instance ];
    [ pro initScene:GS_PROFESSION ];
    CityOutMapScene* cityout = [ CityOutMapScene instance ];
    [ cityout initScene:GS_CITYOUT ];
    MonsterMapScene* monster = [ MonsterMapScene instance ];
    [ monster initScene:GS_MONSTER ];
    AssociationMapScene* ass = [ AssociationMapScene instance ];
    [ ass initScene:GS_ASSOCIATION ];
    
    sceneDictionary = [ [ NSDictionary alloc ] initWithObjectsAndKeys:
                       city , city.Name ,
                       world , world.Name ,
                       work , work.Name ,
                       battle , battle.Name ,
                       public1 , public1.Name ,
                       shop , shop.Name ,
                       pro , pro.Name ,
                       cityout , cityout.Name ,
                       monster , monster.Name ,
                       ass , ass.Name ,
                    nil ];
}


- ( void ) releaseSceneManager
{
    [ sceneDictionary release ];
}


- ( BOOL ) checkScene:( NSString* )scene
{
    if ( activeScene )
    {
        return [activeScene.Name isEqualToString:scene ];
    }
    
    return NO;
}


@end


