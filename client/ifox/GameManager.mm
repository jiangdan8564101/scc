//
//  GameManager.m
//  sc
//
//  Created by fox1 on 12-7-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GameManager.h"
#import "GameUIManager.h"

#import "GameConfigManager.h"
//#import "GameSocketManager.h"
#import "GameUIManager.h"
#import "GameDataManager.h"
#import "GameSceneManager.h"
#import "ItemData.h"
#import "PlayerEmployData.h"

@implementation GameManager


- ( void ) initGameManager
{
    [ [ GameUIManager instance ] initGameUIManager ];
    
    [ [ GameConfigManager instance ] initConfig ];
    [ [ GameDataManager instance ] initGameData ];
    
    spTime = 0.0f;
    
}



- ( void ) releaseGameManager
{
    
}


-( void ) start
{
    lastTime = [ [ NSDate date ] timeIntervalSince1970 ];
    
    // update per 33 ms
    timer = [ NSTimer scheduledTimerWithTimeInterval:0.03 target:self selector:@selector(gameRun) userInfo:nil repeats:YES ];
    
    srand( lastTime );
    
    //[ [ NSRunLoop currentRunLoop] addTimer:timer  forMode:NSRunLoopCommonModes];
}


-( void )stop
{
    [ timer invalidate ];
}


-( void ) gameRun
{
    nowTime = [ [ NSDate date ] timeIntervalSince1970 ];
    
    delay = nowTime - lastTime;
    
    // scene update
    [ [ GameSceneManager instance ] update:delay ];
    
    // ui update
    [ [ GameUIManager instance ] update:delay ];
    
    // net
    //GameSocketManager::MainSocketUpdate( delay );
    
    // game run here;
    
    spTime += delay;
    employTime += delay;
    
    
    if ( employTime > 120.0f )
    {
        employTime = 0.0f;
        [ PlayerEmployData instance ].Reload = YES;
    }
    
    if ( spTime > 3600.0f )
    {
       //[ [ ItemData instance ] addItem:SPECIAL_ITEM :1 ];
        spTime = 0.0f;
    }
    
    lastTime = nowTime;
}


GameManager* gGameManager = NULL;
+(GameManager *)instance
{
    if ( !gGameManager ) 
    {
        gGameManager = [ [ GameManager alloc ] init ];
    }
    
    return  gGameManager;
}

- ( void ) getError
{
    // 作弊
}


@end
