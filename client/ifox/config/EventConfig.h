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

@property ( nonatomic ) int ID , Story , Employ , BattleMap , BattleMonster , Random , StartGuide , FailedGuide , ComGuide , NextID , CLevel , CKill , CItem0 , CItemNum0 , ComItem0 , ComItemNum0 , ComEmploy , Quest , ComQuest;
@property ( nonatomic , assign ) NSString* CheckScene;
@end


@interface EventConfig : GameConfig
{
    
}

@property ( nonatomic , assign ) NSMutableDictionary* Dic;

+ ( EventConfig* ) instance;

- ( EventConfigData* ) getEventConfigData:( int )i;

@end
