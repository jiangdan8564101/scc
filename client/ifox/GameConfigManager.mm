//
//  GameConfigManager.m
//  sc
//
//  Created by fox1 on 12-7-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GameConfigManager.h"
#import "MapConfig.h"
#import "CreatureConfig.h"
#import "ActionConfig.h"
#import "LevelUpConfig.h"
#import "ItemConfig.h"
#import "SkillConfig.h"
#import "ProfessionConfig.h"
#import "AlchemyConfig.h"
#import "WorkUpConfig.h"
#import "GuideConfig.h"
#import "BuyItemConfig.h"
#import "QuestConfig.h"
#import "StoryConfig.h"
#import "EventConfig.h"
#import "LevelUpPriceConfig.h"
#import "HitConfig.h"
#import "EffectConfig.h"
#import "ProDiffConfig.h"

@implementation GameConfigManager



GameConfigManager* gGameConfigManager = NULL;
+ (GameConfigManager*) instance
{
    if ( !gGameConfigManager ) 
    {
        gGameConfigManager = [ [ GameConfigManager alloc ] init ];
    }
    
    return gGameConfigManager;
}

extern void saveDat1();

- ( void ) initConfig
{
    saveDat1();
    
    [ [ ProDiffConfig instance ] initConfig ];
    
    [ [ SkillConfig instance ] initConfig ];
    [ [ MapConfig instance ] initConfig ];
    [ [ CreatureConfig instance ] initConfig ];
    [ [ ActionConfig instance] initConfig ];
    [ [ LevelUpConfig instance ] initConfig ];
    [ [ ItemConfig instance ] initConfig ];
    [ [ ProfessionConfig instance ] initConfig ];
    [ [ AlchemyConfig instance ] initConfig ];
    [ [ WorkUpConfig instance ] initConfig ];
    [ [ GuideConfig instance ] initConfig ];
    [ [ BuyItemConfig instance ] initConfig ];
    [ [ QuestConfig instance ] initConfig ];
    [ [ StoryConfig instance ] initConfig ];
    [ [ EventConfig instance ] initConfig ];
    [ [ LevelUpPriceConfig instance ] initConfig ];
    [ [ HitConfig instance ] initConfig ];
    [ [ EffectConfig instance ] initConfig ];
    
}


- ( void ) releaseConfig
{
    
}



@end


