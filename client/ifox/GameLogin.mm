//
//  GameLogin.m
//  sc
//
//  Created by fox1 on 12-7-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GameLogin.h"
#import "GameManager.h"
#import "GameNetManager.h"
#import "GameAudioManager.h"
#import "LoginUIHandler.h"

@implementation GameLogin




- ( void ) initGameLogin
{
    if ( inited ) 
    {
        return;
    }
    
    
    inited = YES;
    
    loginScene = [ CCScene node ];
    
    [ [ CCDirector sharedDirector ] runWithScene:loginScene ];
    
    [ [ GameManager instance ] initGameManager ];
    [ [ GameManager instance ] start ];
    
    //GameSocketManager::Init();
    //[ GameNetManager initGameNetManager ];
    
    [ [ GameAudioManager instance ] initAudioManager ];
    //[ [ GameAudioManager instance ] playMusic:@"15279_5688015_1" ];
    
    //[ [ GameFileManager instance ] load ];
    
    [ [ LoginUIHandler instance ] visible:YES ];
}


- ( void ) releaseGameLogin
{
    [ [ LoginUIHandler instance ] visible:NO ];
    
    [ loginScene removeFromParentAndCleanup:YES ];
    loginScene = NULL;
}


GameLogin* gGameLogin = NULL;
+ ( GameLogin* ) instance
{
    if ( !gGameLogin )
    {
        gGameLogin = [ [ GameLogin alloc ] init ];
    }
    
    return gGameLogin;
}

@end
