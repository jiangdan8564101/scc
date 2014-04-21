//
//  EventConfig.h
//  sc
//
//  Created by fox on 14-1-13.
//
//

#import "GameConfig.h"


@interface EventConfigData : NSObject
{
    
}

@property ( nonatomic ) int ID , Employ , BattleMap , BattleMonster , Random , StartBattleGuide , StartGuide , FailedGuide , ComGuide , NextID , ComItem0 , ComItemNum0 , ComItem1 , ComItemNum1 , ComEmploy;
@end


@interface EventConfig : GameConfig
{
    
}

@property ( nonatomic , assign ) NSMutableDictionary* Dic;

+ ( EventConfig* ) instance;

- ( EventConfigData* ) getEventConfigData:( int )i;

@end
