//
//  PlayerEmployData.m
//  sc
//
//  Created by fox on 13-9-15.
//
//

#import "PlayerEmployData.h"
#import "PlayerCreatureData.h"
#import "CreatureConfig.h"
#import "PlayerData.h"
#import "SceneData.h"
#import "EventData.h"
#import "EventConfig.h"

extern int gCreatureID;

@implementation PlayerEmployData

@synthesize Reload;
@synthesize PlayerArray;


PlayerEmployData* gPlayerEmployData = NULL;
+ ( PlayerEmployData* ) instance
{
    if ( !gPlayerEmployData )
    {
        gPlayerEmployData = [ [ PlayerEmployData alloc ] init ];
    }
    
    return gPlayerEmployData;
}


- ( void ) initData
{
    PlayerArray = [ [ NSMutableArray alloc ] init ];
}


- ( void ) clearData
{
    [ PlayerArray removeAllObjects ];
}


- ( void ) reloadData
{
    if ( !Reload )
    {
        BOOL b1 = NO;
        BOOL b2 = NO;
        
        for ( int i = 0 ; i < PlayerArray.count ; ++i )
        {
            CreatureCommonData* comm = [ PlayerArray objectAtIndex:i ];
            if ( comm.ID == 70 )
            {
                b1 = YES;
            }
            
            if ( comm.ID == 71 )
            {
                b2 = YES;
            }
        }
        if ( !b1 )
        {
            CreatureCommonData* comm = [ self CreateCreature:70 ];
            [ PlayerArray addObject:comm ];
            [ comm release ];
        }
        if ( !b2 )
        {
            CreatureCommonData* comm = [ self CreateCreature:71 ];
            [ PlayerArray addObject:comm ];
            [ comm release ];
        }
        return;
    }
    
    [ PlayerArray removeAllObjects ];
    
    CreatureCommonData* comm = [ self CreateCreature:70 ];
    [ PlayerArray addObject:comm ];
    [ comm release ];
    
    comm = [ self CreateCreature:71 ];
    [ PlayerArray addObject:comm ];
    [ comm release ];
    
    NSMutableDictionary* data = [ CreatureConfig instance ].NpcDic;
    
    int r = rand() % data.count;
    
    if ( r >= data.count )
    {
        return;
    }
    
    for ( int i = r ; i < r + 1 ; ++i )
    {
        CreatureCommonData* comm = [ data.allValues objectAtIndex:i ];
        
        if ( !comm.EmployPrice )
        {
            continue;
        }
        
        if ( comm.ID == 70 || comm.ID == 71 || [ [ PlayerCreatureData instance ] getCommonDataWithID:comm.ID ] )
        {
            continue;
        }
        
        comm = [ self CreateCreature:comm.ID ];
        [ PlayerArray addObject:comm ];
        [ comm release ];
    }
    
    Reload = NO;
    
    
    // event
    
    data = [ EventData instance ].Dic;
    
    for ( int i = 0 ; i < data.count ; ++i )
    {
        int eventID = [ [ data.allKeys objectAtIndex:i ] intValue ];
        EventConfigData* event = [ [ EventConfig instance ] getEventConfigData:eventID ];
        
        if ( event.ComEmploy )
        {
            CreatureCommonData* comm = [ self CreateCreature:event.ComEmploy ];
            
            if ( [ [ PlayerCreatureData instance ] getCommonDataWithID:comm.ID ] )
            {
                [ comm release ];
                continue;
            }
            
            [ PlayerArray addObject:comm ];
            [ comm release ];
        }
    }
    
//    if ( [ PlayerData instance ].FreeMode )
//    {
//        NSMutableDictionary* data = [ CreatureConfig instance ].NpcDic;
//        
//        for ( int i = 5 ; i < data.count ; ++i )
//        {
//            CreatureCommonData* comm = [ data.allValues objectAtIndex:i ];
//            
//            if ( comm.ID == 70 || comm.ID == 71 || [ [ PlayerCreatureData instance ] getCommonDataWithID:comm.ID ] )
//            {
//                continue;
//            }
//            
//            comm = [ self CreateCreature:comm.ID ];
//            [ PlayerArray addObject:comm ];
//            [ comm release ];
//        }
//    }
//    else
//    {
//        CreatureCommonData* comm = [ self CreateCreature:70 ];
//        [ PlayerArray addObject:comm ];
//        [ comm release ];
//        
//        comm = [ self CreateCreature:71 ];
//        [ PlayerArray addObject:comm ];
//        [ comm release ];
//        
//        
//        
//    }
    
}


- ( void ) employ:( int )i
{
    CreatureCommonData* comm = [ PlayerArray objectAtIndex:i ];
    
    [ [ PlayerCreatureData instance ] addCommonData:comm ];
    
    [ PlayerArray removeObjectAtIndex:i ];
    
    [ [ PlayerData instance ] addGold:-comm.EmployPrice ];
    
    [ [ PlayerData instance ] setEmployData:comm.ID ];
}

- ( void ) employCreature:( int )i
{
    if ( [ [ PlayerCreatureData instance ] getCommonDataWithID:i ] )
    {
        return;
    }
    
    gCreatureID++;
    
    CreatureCommonData* comm = [ [ CreatureConfig instance ] getCommonData:i ];
    comm.cID = gCreatureID;
    
    [ [ PlayerData instance ]setEmployData:i ];
    
    [ [ PlayerCreatureData instance ] addCommonData:comm ];
}


- ( BOOL ) canEmploy:( int )i
{
    CreatureCommonData* comm = [ PlayerArray objectAtIndex:i ];
    
    if ( [ PlayerData instance ].Gold >= comm.EmployPrice )
    {
        return YES;
    }
    else
    {
        return NO;
    }
}


- ( void ) fire:( int )i
{
    
}


- ( CreatureCommonData* ) CreateCreature:( int )i
{
    gCreatureID++;
    
    CreatureCommonData* comm = [ [ CreatureConfig instance ] getCommonData:i ].copy;
    comm.cID = gCreatureID;
    //[ comm initProfession:CPT_WARRIOR :1 ];
    
    return comm;
}


@end



