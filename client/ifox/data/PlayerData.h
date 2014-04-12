//
//  PlayerData.h
//  sc
//
//  Created by fox on 13-4-18.
//
//

#import "GameData.h"
#import "WorkUpConfig.h"

@interface PlayerData : GameData
{
    int workLevel[ WUT_COUNT ];
    int dayData[ 12 ];
    
    float workItemEffect[ ICDET_COUNT ];
    
}

@property ( nonatomic ) int Story;
@property ( nonatomic ) int GoPay;
@property ( nonatomic ) int Year , Month , Day;
@property ( nonatomic ) int Money , Gold , SellGold;
@property ( nonatomic ) float BattleSpeed;
@property ( nonatomic ) int* WorkLevel;
@property ( nonatomic ) int WorkRank , AssessRank , AlchemyRank;
@property ( nonatomic , assign ) NSMutableDictionary* Employ;
@property ( nonatomic , assign ) NSMutableDictionary* Monster;
@property ( nonatomic , assign ) NSMutableDictionary* WorkItem;
@property ( nonatomic ) float* WorkItemEffect;
@property ( nonatomic , assign ) NSMutableDictionary* GrowItemOneDay;
@property ( nonatomic , assign ) NSMutableDictionary* GrowItem;


+ ( PlayerData* ) instance;

- ( BOOL ) updateGrowItem;
- ( void ) updateGrow;
- ( void ) updateWorkItemEffect;

- ( int ) getDay;
- ( void ) pay;
- ( void ) addGold:( int )g;

- ( void ) goDate:( int )d;
- ( BOOL ) canWorkLevelUp:( int )t;
- ( void ) workLevelUp:( int )t;

- ( BOOL ) checkBattleStory:( int )s;
- ( BOOL ) checkBattleEndStory:( int )s;

- ( BOOL ) checkStory;
- ( void ) nextStory:( int )s;

- ( void ) setEmployData:( int )c;
- ( int ) getEmployData:( int )c;
    
- ( void ) setMonsterData:( int )c;
- ( int ) getMonsterData:( int )c;
    
- ( void ) setWorkItemData:( int )c :( int )i;
- ( int ) getWorkItemData:( int )c;

- ( BOOL ) checkWorkRank;
- ( void ) levelUpWorkRank;

@end




