//
//  WorkMapScene.m
//  sc
//
//  Created by fox on 13-1-15.
//
//

#import "WorkMapScene.h"
#import "WorkMapUIHandler.h"
#import "WorkWorkUIHandler.h"
#import "PlayerData.h"
#import "AlertUIHandler.h"

@implementation WorkMapScene



WorkMapScene* gWorkMapScene = NULL;
+ ( WorkMapScene* )instance
{
    if ( !gWorkMapScene )
    {
        gWorkMapScene = [ [ WorkMapScene alloc ] init ];
    }
    
    return gWorkMapScene;
}


- ( void ) onEnterMap
{
    [ [ WorkWorkUIHandler instance ] visible:YES ];
    [ [ WorkMapUIHandler instance ] visible:YES ];
    
    
    [ [ GameAudioManager instance ] playMusic:@"BGM004" :0 ];
    
    [ [ PlayerData instance ] checkStory ];
    
    if ( [ [ PlayerData instance ] updateGrowItem ] )
    {
        [ [ AlertUIHandler instance ] alert:NSLocalizedString( @"WorkGrowItem", nil ) ];
    }
}

- ( void ) onExitMap
{
    [ [ WorkWorkUIHandler instance ] visible:NO ];
    [ [ WorkMapUIHandler instance ] visible:NO ];
}


@end
