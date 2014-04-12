//
//  GamePlayerData.h
//  sc
//
//  Created by fox on 13-4-17.
//
//

#import "GameData.h"
#import "CreatureConfig.h"


@interface PlayerCreatureData : GameData
{
    int team[ MAX_TEAM ][ MAX_BATTLE_PLAYER ];
}

@property ( nonatomic , assign ) NSMutableDictionary* PlayerDic;
@property ( nonatomic , assign ) NSMutableDictionary* PlayerSendDic;

- ( void ) clearSendTeam:( int )t;
- ( void ) setSendTeam:( int )t :( int )s;
- ( int ) getSendTeam:( int )s;
- ( int ) getTeamSend:( int )t;
- ( int ) getFreeTeamCount;

- ( int* ) getTeam:( int )i;
- ( void ) addMember:( int )t :( int )p :( int )c;
- ( void ) removeMember:( int )i :( int )p;

- ( CreatureCommonData* ) getCommonData:( int )t;
- ( CreatureCommonData* ) getCommonDataWithID:( int )i;
- ( void ) addCommonData:(CreatureCommonData*)data;
- ( void ) removeCommonData:( int )i;



+ ( PlayerCreatureData* ) instance;



@end



