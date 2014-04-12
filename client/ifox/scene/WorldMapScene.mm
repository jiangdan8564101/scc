//
//  WorldMapScene.m
//  sc
//
//  Created by fox on 13-1-13.
//
//

#import "WorldMapScene.h"
#import "WorldMapUIHandler.h"
#import "TimeUIHandler.h"
#import "GameDataManager.h"
#import "PlayerData.h"
#import "GuideConfig.h"
#import "PlayerData.h"
#import "SceneUIHandler.h"

@implementation WorldMapScene


WorldMapScene* gWorldMapScene = NULL;
+ ( WorldMapScene* )instance
{
    if ( !gWorldMapScene )
    {
        gWorldMapScene = [ [ WorldMapScene alloc ] init ];
    }
    
    return gWorldMapScene;
}


- ( void ) onEnterMap
{
    [ [ WorldMapUIHandler instance ] visible:YES ];
    
    if ( [ PlayerData instance ].Story > 1 )
    {
        [ [ GameAudioManager instance ] playMusic:@"BGM037" :0 ];
    }
    else
    {
        [ [ GameAudioManager instance ] stopMusic ];
    }
    
    
    
    [ [ TimeUIHandler instance ] visible:YES ];
    
    [ [ GameDataManager instance ] saveData ];
    
    [ [ PlayerData instance ] checkStory ];
    
    GuideConfigData* data = [ [ GuideConfig instance ] getData:SOT_TIME ];
    
    if ( data.NextStory > [ PlayerData instance ].Story )
    {
        [ [ TimeUIHandler instance ] visible:NO ];
        return;
    }
    
    if ( [ [ PlayerData instance ] checkBattleEndStory:[ SceneUIHandler instance ].SelScene ])
    {
        [ [ TimeUIHandler instance ] visible:NO ];
        [ [ GameAudioManager instance ] stopMusic ];
        return;
    }
    
}


- ( void ) onExitMap
{
    [ [ WorldMapUIHandler instance ] visible:NO ];
    
    [ [ TimeUIHandler instance ] visible:NO ];
    
    
}


@end
