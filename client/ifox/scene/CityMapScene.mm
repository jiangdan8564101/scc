//
//  CityMapManager.m
//  sc
//
//  Created by fox on 13-1-12.
//
//

#import "CityMapScene.h"
#import "CityMapUIHandler.h"
#import "BattleCreature.h"
#import "GameCreatureAction.h"
#import "TimeUIHandler.h"
#import "GameDataManager.h"
#import "PlayerData.h"
#import "GuideConfig.h"



@implementation CityMapScene

CityMapScene* gCityMapScene = NULL;
+ ( CityMapScene* )instance
{
    if ( !gCityMapScene )
    {
        gCityMapScene = [ [ CityMapScene alloc ] init ];
    }
    
    return gCityMapScene;
}


- ( void ) onEnterMap
{
    [ [ CityMapUIHandler instance ] visible:YES ];
    
    [ [ GameAudioManager instance ] playMusic:@"BGM040" :0 ];

    //[ [ TimeUIHandler instance ] visible:YES ];
    //CCSprite* sprite = [ CCSprite spriteWithFile:@"action/CP505AA.png" ];
    //[ self addChild:sprite];
    //CGPoint point = CGPointMake( 100 , 100 );
    //[ sprite setPosition:point ];
    
    
    [ [ GameDataManager instance ] saveData ];
    [ [ TimeUIHandler instance ] visible:YES ];
    
    [ [ PlayerData instance ] checkStory ];

    GuideConfigData* data = [ [ GuideConfig instance ] getData:SOT_TIME ];
    
    if ( data.NextStory > [ PlayerData instance ].Story )
    {
        [ [ TimeUIHandler instance ] visible:NO ];
        return;
    }
    
    //[ self addChild:player ];
}

- ( void ) onExitMap
{
    [ [ CityMapUIHandler instance ] visible:NO ];
    [ [ TimeUIHandler instance ] visible:NO ];
    
    
}

@end
