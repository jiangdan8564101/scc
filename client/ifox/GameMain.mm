//
//  GameMain.m
//  sc
//
//  Created by fox1 on 12-7-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GameMain.h"
#import "PathFinder.h"
#import "GameSceneManager.h"
#import "GameManager.h"
#import "GameUIManager.h"
#import "PlayerData.h"

@implementation GameMain



GameMain* gGameMain = NULL;
+ ( GameMain* ) instance
{
    if ( !gGameMain ) 
    {
        gGameMain = [ [ GameMain alloc ] init ];
    }
    
    return gGameMain;
}


- ( void ) initGameMain
{
    if ( !inited ) 
    {
        inited = YES;
        
        [ [ GameSceneManager instance ] initSceneManager ];
    }
    
    
    // add loading
    //[[LoadingViewHandler instance] visible:YES];
    
    [ [ GameUIManager instance ] removeAllUI ];
    
    
    if ( [ [ PlayerData instance ] checkStory ] )
    {
        return;
    }
    
    [ [ GameSceneManager instance ] activeScene:GS_CITY ];
}


- ( void ) releaseGameMain
{
    
}

@end
