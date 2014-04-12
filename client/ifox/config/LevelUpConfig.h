//
//  LevelUpConfig.h
//  sc
//
//  Created by fox on 13-9-7.
//
//

#import "GameConfig.h"
#import "CreatureConfig.h"



@interface LevelUpConfig : GameConfig
{
    NSMutableDictionary* dic;
}

- ( CreatureBaseData* ) getBaseData:( int )p;

+ ( LevelUpConfig* ) instance;


@end


