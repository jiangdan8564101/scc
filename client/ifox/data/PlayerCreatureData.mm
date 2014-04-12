//
//  GamePlayerData.m
//  sc
//
//  Created by fox on 13-4-17.
//
//

#import "PlayerCreatureData.h"
#import "CreatureConfig.h"

@implementation PlayerCreatureData
@synthesize PlayerDic , PlayerSendDic;

extern int gCreatureID;

PlayerCreatureData* gPlayerCreatureData = NULL;
+ ( PlayerCreatureData* ) instance
{
    if ( !gPlayerCreatureData )
    {
        gPlayerCreatureData = [ [ PlayerCreatureData alloc ] init ];
    }
    
    return gPlayerCreatureData;
}

- ( void ) initData
{
    PlayerDic = [ [ NSMutableDictionary alloc ] init ];
    PlayerSendDic = [ [ NSMutableDictionary alloc ] init ];
    
    
    for ( int i = 0 ; i < MAX_TEAM ; ++i )
    {
        for ( int j = 0 ; j < MAX_BATTLE_PLAYER ; ++j )
        {
            team[ i ][ j ] = 0;
        }
    }
}


- ( void ) setSendTeam:( int )t :( int )s
{
    [ PlayerSendDic setObject:[ NSNumber numberWithInt:s ] forKey:[ NSNumber numberWithInt:t ] ];
}

- ( void ) clearSendTeam:( int )t
{
    if ( [ PlayerSendDic objectForKey:[ NSNumber numberWithInt:t ] ] )
    {
        [ PlayerSendDic removeObjectForKey:[ NSNumber numberWithInt:t ] ];
    }
}

- ( int ) getSendTeam:( int )s
{
    for ( int i = 0 ; i < PlayerSendDic.allKeys.count ; ++i )
    {
        int k = [ [ PlayerSendDic.allKeys objectAtIndex:i ] intValue ];
        int v = [[ PlayerSendDic objectForKey:[ NSNumber numberWithInt:k ] ] intValue ];
        
        if ( v == s )
        {
            return k;
        }
    }
    
    return INVALID_ID;
}

- ( int ) getTeamSend:( int )t
{
    if ( [ PlayerSendDic objectForKey:[ NSNumber numberWithInt:t ] ] )
    {
        return [ [ PlayerSendDic objectForKey:[ NSNumber numberWithInt:t ] ] intValue ];
    }
    
    return INVALID_ID;
}

- ( int ) getFreeTeamCount
{
    int count = 0;
    for ( int i = 0 ; i < MAX_TEAM ; ++i )
    {
        if ( team[ i ][ 0 ] > 0 )
        {
            if ( [ self getTeamSend:i ] == INVALID_ID )
            {
                count++;
            }
        }
    }
    
    return count;
}


- ( int* ) getTeam:( int )i
{
    return team[ i ];
}

- ( void ) addMember:( int )i :( int )p :( int )c
{
    team[ i ][ p ] = c;
}

- ( void ) removeMember:( int )i :( int )p
{
    team[ i ][ p ] = 0;
    
    for ( int j = p ; j < MAX_BATTLE_PLAYER - 1 ; j++ )
    {
        team[ i ][ j ] = team[ i ][ j + 1 ];
    }
    
    team[ i ][ MAX_BATTLE_PLAYER - 1 ] = 0;
}

- ( CreatureCommonData* ) getCommonData:( int )i
{
    return [ PlayerDic objectForKey:[ NSNumber numberWithInt:i ] ];
}

- ( CreatureCommonData* ) getCommonDataWithID:( int )ii
{
    for ( int i = 0 ; i < PlayerDic.allValues.count ; ++i )
    {
        CreatureCommonData* comm = [ PlayerDic.allValues objectAtIndex:i ];
        
        if ( comm.ID == ii )
        {
            return comm;
        }
    }
    
    return NULL;
}

- ( void ) addCommonData:(CreatureCommonData*)data
{
    CreatureCommonData* d = data.copy;
    [ PlayerDic setObject:d forKey:[ NSNumber numberWithInt:data.cID ] ];
    [ d release ];
}

- ( void ) removeCommonData:( int )i
{
    CreatureCommonData* d = [ PlayerDic objectForKey:[ NSNumber numberWithInt:i ] ];
    int c = d.cID;
    [ PlayerDic removeObjectForKey:[ NSNumber numberWithInt:i ] ];
    
    for ( int i = 0 ; i < MAX_TEAM ; ++i )
    {
        for ( int j = 0 ; j < MAX_BATTLE_PLAYER ; ++j )
        {
            if ( team[ i ][ j ] == c )
            {
                [ self removeMember:i :j ];
            }
        }
    }
}

- ( void ) clearData
{
    [ PlayerDic removeAllObjects ];
        
    for ( int i = 0 ; i < MAX_TEAM ; ++i )
    {
        for ( int j = 0 ; j < MAX_BATTLE_PLAYER ; ++j )
        {
            team[ i ][ j ] = 0;
        }
    }
}




@end



