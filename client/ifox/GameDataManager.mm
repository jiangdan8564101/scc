//
//  GameDataManager.m
//  sc
//
//  Created by fox1 on 12-7-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GameDataManager.h"
#import "PlayerCreatureData.h"
#import "PlayerData.h"
#import "GameKeyChain.h"
#import "CreatureConfig.h"
#import "PlayerCreatureData.h"
#import "PlayerEmployData.h"
#import "ItemData.h"
#import "QuestData.h"
#import "SceneData.h"
#import "EventData.h"
#import "PaymentIOS.h"


@implementation GameDataManager

static NSString* const KEY_KEYCHAIN = @"foxgame.sc001";
static NSString* const KEY_KEYCHAIN_BUYITEM = @"buyItem";
static NSString* const KEY_USERDATA = @"user.dat";


int gCreatureID = MAIN_PLAYER_ID;


-( void ) saveData
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory , NSUserDomainMask ,YES );
    NSString* path = [ paths objectAtIndex:0 ];

    NSString* filename = [ path stringByAppendingPathComponent:KEY_USERDATA ];
    
    NSLog( @"datapath%@" , filename );
    
    NSMutableDictionary* dic1 = [ NSMutableDictionary dictionaryWithContentsOfFile:filename ];
    
    if ( !dic1 )
    {
        NSFileManager* fm = [ NSFileManager defaultManager ];
        [ fm createFileAtPath:filename contents:nil attributes:nil ];
    }
    
    
    NSMutableDictionary* dic = [ NSMutableDictionary dictionary ];
    
#ifndef DEBUG
    NSString *idfv = [ [ [ UIDevice currentDevice] identifierForVendor ] UUIDString ];
    if ( idfv )
    {
        NSData* data111 = [ NSKeyedArchiver archivedDataWithRootObject:idfv ];
        [ dic setObject:data111 forKey:@"idfv" ];
    }
#endif
    
    NSData* data1 = [ NSKeyedArchiver archivedDataWithRootObject:[ PlayerCreatureData instance ].PlayerDic  ];
    [ dic setObject:data1 forKey:@"creatures" ];
    
    data1 = [ NSKeyedArchiver archivedDataWithRootObject:[ PlayerCreatureData instance ].PlayerSendDic  ];
    [ dic setObject:data1 forKey:@"creaturesSend" ];
    
    
    data1 = [ NSKeyedArchiver archivedDataWithRootObject:[ ItemData instance ].Items  ];
    
    [ dic setObject:data1 forKey:@"items" ];
    
    [ dic setObject:[ NSNumber numberWithInt:gCreatureID ] forKey:@"creatureID" ];
    NSMutableArray* arr = [ NSMutableArray array ];
    
    for ( int i = 0 ; i < MAX_TEAM ; i++ )
    {
        NSMutableArray* arr1 = [ NSMutableArray array ];
        int* team = [ [ PlayerCreatureData instance ] getTeam:i ];
        
        for ( int j = 0 ; j < MAX_BATTLE_PLAYER ; j++ )
        {
            [ arr1 addObject:[ NSNumber numberWithInt:team[ j ] ] ];
        }
        
        [ arr addObject:arr1 ];
    }
    [ dic setObject:arr forKey:@"team" ];
    
    data1 = [ NSKeyedArchiver archivedDataWithRootObject:[ QuestData instance ].Data  ];
    // quest data
    [ dic setObject:data1 forKey:@"quest" ];

    // scene data
    
    data1 = [ NSKeyedArchiver archivedDataWithRootObject:[ SceneData instance ].Data  ];
    [ dic setObject:data1 forKey:@"scene" ];
    
    // event data
    
    data1 = [ NSKeyedArchiver archivedDataWithRootObject:[ EventData instance ].Dic  ];
    [ dic setObject:data1 forKey:@"event" ];
    
    // player data
    
    NSMutableArray* array2 = [ NSMutableArray array ];
    [ array2 addObject:[ NSNumber numberWithInt:[ PlayerData instance ].getMoney ] ];
    [ array2 addObject:[ NSNumber numberWithInt:[ PlayerData instance ].getGold ] ];
    
    for ( int i = 0 ; i < WUT_COUNT ; ++i )
    {
        [ array2 addObject:[ NSNumber numberWithInt:[ PlayerData instance ].WorkLevel[ i ] ] ];
    }
    [ array2 addObject:[ NSNumber numberWithInt:[ PlayerData instance ].WorkRank ] ];
    [ array2 addObject:[ NSNumber numberWithInt:[ PlayerData instance ].AlchemyRank ] ];
    [ array2 addObject:[ NSNumber numberWithInt:[ PlayerData instance ].AssessRank ] ];
    [ array2 addObject:[ NSNumber numberWithInt:[ PlayerData instance ].Year ] ];
    [ array2 addObject:[ NSNumber numberWithInt:[ PlayerData instance ].Month ] ];
    [ array2 addObject:[ NSNumber numberWithInt:[ PlayerData instance ].Day ] ];
    [ array2 addObject:[ NSNumber numberWithInt:[ PlayerData instance ].GoPay ] ];
    [ array2 addObject:[ NSNumber numberWithInt:[ PlayerData instance ].Story ] ];
    [ array2 addObject:[ NSNumber numberWithInt:[ PlayerData instance ].SellGold ] ];
    [ array2 addObject:[ NSNumber numberWithFloat:[ PlayerData instance ].BattleSpeed ] ];
    
    NSData* data2 = [ NSKeyedArchiver archivedDataWithRootObject:array2 ];
    [ dic setObject:data2 forKey:@"user" ];
    
    data2 = [ NSKeyedArchiver archivedDataWithRootObject:[ PlayerData instance ].Employ ];
    [ dic setObject:data2 forKey:@"userEmploy" ];
    data2 = [ NSKeyedArchiver archivedDataWithRootObject:[ PlayerData instance ].Monster ];
    [ dic setObject:data2 forKey:@"userMonster" ];
    data2 = [ NSKeyedArchiver archivedDataWithRootObject:[ PlayerData instance ].WorkItem ];
    [ dic setObject:data2 forKey:@"userWorkItem" ];
    
    BOOL b = [ dic writeToFile:filename atomically:YES ];
    b = YES;
    
    
}

-( BOOL ) hasData
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory , NSUserDomainMask ,YES );
    NSString* path = [ paths objectAtIndex:0 ];
    
    NSString* filename = [ path stringByAppendingPathComponent:KEY_USERDATA ];
    
    NSLog( @"datapath%@" , filename );
    
    if ( filename )
    {
        NSMutableDictionary* dic = [ NSMutableDictionary dictionaryWithContentsOfFile:filename ];
        
        if ( !dic )
        {
            return NO;
        }
        
        return YES;
    }
    
    return NO;
}

- ( void ) setBuyItem:( int )i
{
    int n = 0;
    if ( [ gameData objectForKey:KEY_KEYCHAIN_BUYITEM ] )
    {
        n = [ [ gameData objectForKey:KEY_KEYCHAIN_BUYITEM ] intValue ];
    }
    
    n += i;
    
    [ gameData setObject:[ NSNumber numberWithInt:n ] forKey:KEY_KEYCHAIN_BUYITEM ];
    [ GameKeyChain save:KEY_KEYCHAIN data:gameData ];
}

- ( int ) getBuyItem
{
    if ( [ gameData objectForKey:KEY_KEYCHAIN_BUYITEM ] )
    {
        return  [ [ gameData objectForKey:KEY_KEYCHAIN_BUYITEM ] intValue ];
    }

    return 0;
}

-( BOOL ) readData
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory , NSUserDomainMask ,YES );
    NSString* path = [ paths objectAtIndex:0 ];
    
    NSString* filename = [ path stringByAppendingPathComponent:KEY_USERDATA ];
    
    if ( filename )
    {
        NSMutableDictionary* dic = [ NSMutableDictionary dictionaryWithContentsOfFile:filename ];
        
        if ( !dic )
        {
            return NO;
        }
        
#ifndef DEBUG
        NSData* data111 = [ dic objectForKey:@"idfv" ];
        NSString* stridfv = [ NSKeyedUnarchiver unarchiveObjectWithData:data111 ];
        
        NSString *idfv = [ [ [ UIDevice currentDevice] identifierForVendor ] UUIDString ];
        if ( stridfv && idfv )
        {
            if ( ![ stridfv isEqualToString:idfv ] )
            {
                return NO;
            }
        }
#endif
        NSData* data1 = [ dic objectForKey:@"creatures" ];
        NSMutableDictionary* creatures = [ NSKeyedUnarchiver unarchiveObjectWithData:data1 ];
        NSArray* arr = creatures.allValues;
        
        for ( int i = 0 ; i < arr.count ; i++ )
        {
            [ [ PlayerCreatureData instance ] addCommonData:[ arr objectAtIndex:i ] ];
        }
        
        data1 = [ dic objectForKey:@"creaturesSend" ];
        NSDictionary* dic2 = [ NSKeyedUnarchiver unarchiveObjectWithData:data1 ];
        for ( int i = 0 ; i < dic2.allKeys.count ; i++ )
        {
            int k = [ [ dic2.allKeys objectAtIndex:i ] intValue ];
            int v = [ [ dic2 objectForKey:[ dic2.allKeys objectAtIndex:i ]  ]intValue ];
            
            [ [ PlayerCreatureData instance ].PlayerSendDic setObject:[ NSNumber numberWithInt:v ] forKey:[ NSNumber numberWithInt:k ] ];
        }
        
        data1 = [ dic objectForKey:@"items" ];
        NSMutableDictionary* items = [ NSKeyedUnarchiver unarchiveObjectWithData:data1 ];
        arr = items.allValues;
        
        for ( int i = 0 ; i < arr.count ; i++ )
        {
            [ [ ItemData instance ] initItem:[ arr objectAtIndex:i ] ];
        }
        
        // quest data
        data1 = [ dic objectForKey:@"quest" ];
        NSMutableDictionary* quest = [ NSKeyedUnarchiver unarchiveObjectWithData:data1 ];
        for ( int i = 0 ; i < quest.allKeys.count ; ++i )
        {
            int q = [ [ quest.allKeys objectAtIndex:i ] intValue ];
            int v = [ [ quest objectForKey:[ quest.allKeys objectAtIndex:i ] ] intValue ];
            
            [ [ QuestData instance ] setQuest:q :v ];
        }
        
        // scene data
        data1 = [ dic objectForKey:@"scene" ];
        NSMutableDictionary* scene = [ NSKeyedUnarchiver unarchiveObjectWithData:data1 ];
        for ( int i = 0 ; i < scene.allKeys.count ; ++i )
        {
            int q = [ [ scene.allKeys objectAtIndex:i ] intValue ];
            SceneDataItem* v = [ scene objectForKey:[ scene.allKeys objectAtIndex:i ] ] ;
            
            [ [ SceneData instance ].Data setObject:v forKey:[ NSNumber numberWithInt:q ] ];
        }
        
        
        // event data
        data1 = [ dic objectForKey:@"event" ];
        NSMutableDictionary* event = [ NSKeyedUnarchiver unarchiveObjectWithData:data1 ];
        for ( int i = 0 ; i < event.allKeys.count ; ++i )
        {
            int q = [ [ event.allKeys objectAtIndex:i ] intValue ];
            int v = [ [ event objectForKey:[ event.allKeys objectAtIndex:i ] ] intValue ];
            
            [ [ EventData instance ].Dic setObject:[ NSNumber numberWithInt:v ] forKey:[ NSNumber numberWithInt:q ] ];
        }
        
#ifdef DEBUG
//        [ [ ItemData instance ] addItem:SPECIAL_ITEM:1 ];
//        for ( int i = 0 ; i < [ ItemConfig instance ].ItemDic.count ; i++ )
//        {
//            ItemConfigData* datacc = [ [ ItemConfig instance ].ItemDic.allValues objectAtIndex: i ];
//            [ [ ItemData instance ] addItem:datacc.ID :99 ];
//        }
#endif
        
//        [ [ ItemData instance ] addItem:99 :10 ];
//        [ [ ItemData instance ] addItem:50005 :10 ];
//        [ [ ItemData instance ] addItem:50009 :10 ];
//        [ [ ItemData instance ] addItem:50041 :10 ];
        
//        [ [ ItemData instance ] addItem:1299 :1 ];
//        [ [ ItemData instance ] addItem:1519 :1 ];
//        [ [ ItemData instance ] addItem:1650 :1 ];
//        [ [ ItemData instance ] addItem:1714 :1 ];
//        [ [ ItemData instance ] addItem:1128 :1 ];
//        [ [ ItemData instance ] addItem:1399 :1 ];
//        [ [ ItemData instance ] addItem:1451 :2 ];
//        [ [ ItemData instance ] addItem:1835 :2 ];
//        [ [ ItemData instance ] addItem:1556 :2 ];
//        [ [ ItemData instance ] addItem:1400 :2 ];
//        [ [ ItemData instance ] addItem:1754 :2 ];
//        [ [ ItemData instance ] addItem:1815 :2 ];
//        [ [ ItemData instance ] addItem:1873 :2 ];
        
//        [ [ ItemData instance ] addItem:365 :2 ];
//        [ [ ItemData instance ] addItem:366 :3 ];
//        [ [ ItemData instance ] addItem:367 :4 ];
        
//        [ [ ItemData instance ] addItem:60100 :41 ];
//        [ [ ItemData instance ] addItem:61400 :42 ];
//        [ [ ItemData instance ] addItem:61410 :44 ];
//        [ [ ItemData instance ] addItem:91100 :43 ];
        
        gCreatureID = [ [ dic objectForKey:@"creatureID" ] intValue ];
        //[ [ PlayerEmployData instance ] reloadData ];
        
        arr = [ dic objectForKey:@"team" ];
        
        for ( int i = 0 ; i < arr.count ; i++ )
        {
            NSMutableArray* arr1 = [ arr objectAtIndex:i ];
            
            for ( int j = 0 ; j < MAX_BATTLE_PLAYER ; j++ )
            {
                if ( [ [ arr1 objectAtIndex:j ] intValue ] )
                {
                    [ [ PlayerCreatureData instance ] addMember:i :j :[ [ arr1 objectAtIndex:j ] intValue ] ];
                }
                
            }
        }
        
        
        data1 = [ dic objectForKey:@"user" ];
        arr = [ NSKeyedUnarchiver unarchiveObjectWithData:data1 ];
        [ [ PlayerData instance ] setMoney:[ [ arr objectAtIndex:0 ] intValue ] ];
        [ [ PlayerData instance ] setGold:[ [ arr objectAtIndex:1 ] intValue ] ];
        
        for ( int i = 0 ; i < WUT_COUNT ; ++i )
        {
            [ PlayerData instance ].WorkLevel[ i ] = [ [ arr objectAtIndex:2 + i ] intValue ];
        }
        
        // 这里更新时有问题。
        [ PlayerData instance ].WorkRank = [ [ arr objectAtIndex:6 ] intValue ];
        [ PlayerData instance ].AlchemyRank = [ [ arr objectAtIndex:7 ] intValue ];
        [ PlayerData instance ].AssessRank = [ [ arr objectAtIndex:8 ] intValue ];
        [ PlayerData instance ].Year = [ [ arr objectAtIndex:9 ] intValue ];
        [ PlayerData instance ].Month = [ [ arr objectAtIndex:10 ] intValue ];
        [ PlayerData instance ].Day = [ [ arr objectAtIndex:11 ] intValue ];
        [ PlayerData instance ].GoPay = [ [ arr objectAtIndex:12 ] intValue ];
        [ PlayerData instance ].Story = [ [ arr objectAtIndex:13 ] intValue ];
        [ PlayerData instance ].SellGold = [ [ arr objectAtIndex:14 ] intValue ];
        [ PlayerData instance ].BattleSpeed = arr.count > 15 ? [ [ arr objectAtIndex:15 ] floatValue ] : 1.0f;
        
        [ [ SceneData instance ] randomSPEnemy ];
        
        data1 = [ dic objectForKey:@"userWorkItem" ];
        NSDictionary* dic1 = [ NSKeyedUnarchiver unarchiveObjectWithData:data1 ];
        for ( int i = 0 ; i < dic1.allKeys.count ; i++ )
        {
            int k = [ [ dic1.allKeys objectAtIndex:i ] intValue ];
            int v = [ [ dic1 objectForKey:[ dic1.allKeys objectAtIndex:i ]  ]intValue ];
            
            [ [ PlayerData instance ].WorkItem setObject:[ NSNumber numberWithInt:v ] forKey:[ NSNumber numberWithInt:k ] ];
        }

        
        data1 = [ dic objectForKey:@"userMonster" ];
        dic1 = [ NSKeyedUnarchiver unarchiveObjectWithData:data1 ];
        for ( int i = 0 ; i < dic1.allKeys.count ; i++ )
        {
            int k = [ [ dic1.allKeys objectAtIndex:i ] intValue ];
            int v = [ [ dic1 objectForKey:[ dic1.allKeys objectAtIndex:i ]  ]intValue ];
            
            [ [ PlayerData instance ].Monster setObject:[ NSNumber numberWithInt:v ] forKey:[ NSNumber numberWithInt:k ] ];
        }
        
        data1 = [ dic objectForKey:@"userEmploy" ];
        dic1 = [ NSKeyedUnarchiver unarchiveObjectWithData:data1 ];
        for ( int i = 0 ; i < dic1.allKeys.count ; i++ )
        {
            int k = [ [ dic1.allKeys objectAtIndex:i ] intValue ];
            int v = [ [ dic1 objectForKey:[ dic1.allKeys objectAtIndex:i ]  ]intValue ];
            
            [ [ PlayerData instance ].Employ setObject:[ NSNumber numberWithInt:v ] forKey:[ NSNumber numberWithInt:k ] ];
        }
        
        [ [ PlayerData instance ] updateWorkItemEffect ];
        
        //[ PlayerData instance ].Gold = 88888;
        
        //[ PlayerData instance ].WorkRank = 13;
        //[ PlayerData instance ].Story = 14;
        //[ PlayerData instance ].Day = 20;
    }
    
    return YES;
}

GameDataManager* gGameDataManager = NULL;
+ ( GameDataManager* ) instance
{
    if ( !gGameDataManager ) 
    {
        gGameDataManager = [ [ GameDataManager alloc ] init ];
    }
    
    return gGameDataManager;
}


- ( void ) initGameData
{
    [ [ PlayerData instance ] initData ];
    [ [ PlayerCreatureData instance ] initData ];
    [ [ PlayerEmployData instance ] initData ];
    [ [ ItemData instance ] initData ];
    [ [ QuestData instance ] initData ];    
    [ [ SceneData instance ] initData ];
    [ [ EventData instance ] initData ];

    [ [ PaymentIOS instance ] getList:[ NSMutableArray arrayWithObjects:@"Cat1" , @"Cat2" , @"Cat3" , nil] ];

    [ gameData release ];
    gameData = NULL;
    
    gameData = (NSMutableDictionary*)[ GameKeyChain load:KEY_KEYCHAIN ];
    
    if ( !gameData )
    {
        // init
        gameData = [ [ NSMutableDictionary alloc ] init ];
        [ GameKeyChain save:KEY_KEYCHAIN data:gameData ];
    }
    else
    {
        gameData = gameData.retain;
    }
    

    //[ self readData ];
}


- ( void ) releaseGameData
{
    
}

@end

