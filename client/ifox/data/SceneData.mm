//
//  SceneData.m
//  sc
//
//  Created by fox on 13-12-8.
//
//

#import "SceneData.h"
#import "MapConfig.h"
#import "PlayerData.h"

@implementation SceneDataItem


@synthesize Complete , Per , HidePer , CollectArray , DigArray , EnemyArray , DataDic , DoorDic , TreasureDic , SPEnemy;

-( void ) encodeWithCoder:( NSCoder* )coder
{
    [ coder encodeObject:[ NSNumber numberWithInt:SPEnemy ] forKey:@"SPEnemy" ];
    [ coder encodeObject:[ NSNumber numberWithInt:Complete ] forKey:@"complete" ];
    [ coder encodeObject:[ NSNumber numberWithFloat:Per ] forKey:@"per" ];
    [ coder encodeObject:[ NSNumber numberWithFloat:HidePer ] forKey:@"hidePer" ];
    
    
    [ coder encodeObject:CollectArray forKey:@"collectArray" ];
    [ coder encodeObject:DigArray forKey:@"digArray" ];
    [ coder encodeObject:EnemyArray forKey:@"enemyArray" ];
    [ coder encodeObject:DataDic forKey:@"dataDic" ];
    [ coder encodeObject:DoorDic forKey:@"doorDic" ];
    [ coder encodeObject:TreasureDic forKey:@"treasureDic" ];
    
}

-( id ) initWithCoder:( NSCoder* )coder
{
    self = [ self init ];
    
    SPEnemy = [ [ coder decodeObjectForKey:@"SPEnemy" ] intValue ];
    
    Complete = [ [ coder decodeObjectForKey:@"complete" ] intValue ];
    Per = [ [ coder decodeObjectForKey:@"per" ] floatValue ];
    HidePer = [ [ coder decodeObjectForKey:@"hidePer" ] floatValue ];
    
    CollectArray = [ [ NSMutableArray alloc ] init ];
    DigArray = [ [ NSMutableArray alloc ] init ];
    EnemyArray = [ [ NSMutableArray alloc ] init ];
    DataDic = [ [ NSMutableDictionary alloc ] init ];
    DoorDic = [ [ NSMutableDictionary alloc ] init ];
    TreasureDic = [ [ NSMutableDictionary alloc ] init ];
    
    NSArray* arr = [ coder decodeObjectForKey:@"collectArray" ];
    for ( int i = 0 ; i < arr.count ; ++i )
    {
        [ CollectArray addObject:[ arr objectAtIndex:i ] ];
    }
    
    arr = [ coder decodeObjectForKey:@"digArray" ];
    for ( int i = 0 ; i < arr.count ; ++i )
    {
        [ DigArray addObject:[ arr objectAtIndex:i ] ];
    }
    
    arr = [ coder decodeObjectForKey:@"enemyArray" ];
    for ( int i = 0 ; i < arr.count ; ++i )
    {
        [ EnemyArray addObject:[ arr objectAtIndex:i ] ];
    }
    
    NSDictionary* dic = [ coder decodeObjectForKey:@"dataDic" ];
    for ( int i = 0 ; i < dic.count ; ++i )
    {
        [ DataDic setObject:[ dic objectForKey:[ dic.allKeys objectAtIndex:i ] ]  forKey:[ dic.allKeys objectAtIndex:i ] ];
    }
    
    dic = [ coder decodeObjectForKey:@"treasureDic" ];
    for ( int i = 0 ; i < dic.count ; ++i )
    {
        [ TreasureDic setObject:[ dic objectForKey:[ dic.allKeys objectAtIndex:i ] ]  forKey:[ dic.allKeys objectAtIndex:i ] ];
    }
    
    dic = [ coder decodeObjectForKey:@"doorDic" ];
    for ( int i = 0 ; i < dic.count ; ++i )
    {
        [ DoorDic setObject:[ dic objectForKey:[ dic.allKeys objectAtIndex:i ] ]  forKey:[ dic.allKeys objectAtIndex:i ] ];
    }
    
    return self;
}

- ( id ) copyWithZone:( NSZone* )zone
{
    SceneDataItem* copy = [ [ self class ] allocWithZone:zone ];
    
    copy.Complete = Complete;
    copy.Per = Per;
    copy.HidePer = HidePer;
    
    copy.DataDic = [ [ NSMutableDictionary alloc ] init ];
    for ( int i = 0 ; i < DataDic.count ; i++ )
    {
        [ copy.DataDic setObject:[ NSNumber numberWithBool:YES ] forKey:[ NSNumber numberWithInt:[ [ DataDic.allKeys objectAtIndex:i ] intValue ] ] ];
    }
    
    copy.DoorDic = [ [ NSMutableDictionary alloc ] init ];
    for ( int i = 0 ; i < DoorDic.count ; i++ )
    {
        [ copy.DoorDic setObject:[ NSNumber numberWithBool:YES ] forKey:[ NSNumber numberWithInt:[ [ DoorDic.allKeys objectAtIndex:i ] intValue ] ] ];
    }
    
    copy.TreasureDic = [ [ NSMutableDictionary alloc ] init ];
    for ( int i = 0 ; i < TreasureDic.count ; i++ )
    {
        [ copy.TreasureDic setObject:[ NSNumber numberWithBool:YES ] forKey:[ NSNumber numberWithInt:[ [ TreasureDic.allKeys objectAtIndex:i ] intValue ] ] ];
    }
    
    copy.CollectArray = [ [ NSMutableArray alloc ] init ];
    for ( int i = 0 ; i < CollectArray.count ; i++ )
    {
        [ copy.CollectArray addObject: [ NSNumber numberWithInt:[ [ CollectArray objectAtIndex:i ] intValue ] ] ];
    }
    
    copy.DigArray = [ [ NSMutableArray alloc ] init ];
    for ( int i = 0 ; i < DigArray.count ; i++ )
    {
        [ copy.DigArray addObject: [ NSNumber numberWithInt:[ [ DigArray objectAtIndex:i ] intValue ] ] ];
    }
    
    copy.EnemyArray = [ [ NSMutableArray alloc ] init ];
    for ( int i = 0 ; i < EnemyArray.count ; i++ )
    {
        [ copy.EnemyArray addObject: [ NSNumber numberWithInt:[ [ EnemyArray objectAtIndex:i ] intValue ] ] ];
    }
    
    return copy;
}



- ( BOOL ) getCollect:( int )c
{
    for ( int i = 0 ; i < CollectArray.count ; ++i )
    {
        if ( [ [ CollectArray objectAtIndex:i ] intValue ] == c )
        {
            return YES;
        }
    }
    
    return NO;
}
- ( BOOL ) getDig:( int )d
{
    for ( int i = 0 ; i < DigArray.count ; ++i )
    {
        if ( [ [ DigArray objectAtIndex:i ] intValue ] == d )
        {
            return YES;
        }
    }
    
    return NO;
}
- ( BOOL ) getEnemy:( int )e
{
    for ( int i = 0 ; i < EnemyArray.count ; ++i )
    {
        if ( [ [ EnemyArray objectAtIndex:i ] intValue ] == e )
        {
            return YES;
        }
    }
    
    return NO;
}

- ( void ) setCollect:( int )c
{
    for ( int i = 0 ; i < CollectArray.count ; ++i )
    {
        if ( [ [ CollectArray objectAtIndex:i ] intValue ] == c )
        {
            return;
        }
    }
    
    [ CollectArray addObject:[ NSNumber numberWithInt:c ] ];
}
- ( void ) setDig:( int )d
{
    for ( int i = 0 ; i < DigArray.count ; ++i )
    {
        if ( [ [ DigArray objectAtIndex:i ] intValue ] == d )
        {
            return;
        }
    }
    
    [ DigArray addObject:[ NSNumber numberWithInt:d ] ];
}
- ( void ) setEnemy:( int )e
{
    for ( int i = 0 ; i < EnemyArray.count ; ++i )
    {
        if ( [ [ EnemyArray objectAtIndex:i ] intValue ] == e )
        {
            return;
        }
    }
    
    [ EnemyArray addObject:[ NSNumber numberWithInt:e ] ];
}

- ( void ) setData:( int )x
{
    [ DataDic setObject:[ NSNumber numberWithBool:YES ] forKey:[ NSNumber numberWithInt:x ] ];
}
- ( BOOL ) getData:( int )index
{
    return [ [ DataDic objectForKey:[ NSNumber numberWithInt:index ] ] intValue ];
}

- ( void ) setTreasure:( int )x
{
    [ TreasureDic setObject:[ NSNumber numberWithBool:YES ] forKey:[ NSNumber numberWithInt:x ] ];
}
- ( BOOL ) getTreasure:( int )index
{
    return [ [ TreasureDic objectForKey:[ NSNumber numberWithInt:index ] ] intValue ];
}

- ( void ) setDoor:( int )x
{
    [ DoorDic setObject:[ NSNumber numberWithBool:YES ] forKey:[ NSNumber numberWithInt:x ] ];
}
- ( BOOL ) getDoor:( int )index
{
    return [ [ DoorDic objectForKey:[ NSNumber numberWithInt:index ] ] intValue ];
}


@end


@implementation SceneData
@synthesize Data;
@synthesize SPSceneDataItem;

SceneData* gSceneData = NULL;
+ ( SceneData* ) instance
{
    if ( !gSceneData )
    {
        gSceneData = [ [ SceneData alloc ] init ];
    }
    
    return gSceneData;
}

- ( SceneDataItem* ) getSceneData:( int )i
{
    return [ Data objectForKey:[ NSNumber numberWithInt:i ] ];
}


- ( BOOL ) getEnemy:( int )e
{
    for ( int i = 0 ; i < Data.count ; ++i )
    {
        int key = [ [ Data.allKeys objectAtIndex:i ] intValue ];
        SceneDataItem* item = [ Data objectForKey:[ NSNumber numberWithInt:key ] ];
        
        if ( [ item getEnemy:e ] )
        {
            return YES;
        }
    }

    return NO;
}


- ( void ) checkComplete
{
    for ( int j = 0 ; j < Data.count ; ++j )
    {
        int key = [ [ Data.allKeys objectAtIndex:j ] intValue ];
        SceneDataItem* item = [ Data objectForKey:[ NSNumber numberWithInt:key ] ];
        
        SubSceneMap* sub = [ [ MapConfig instance] getSubSceneMap:key ];
        
        int c = 0; int d = 0; int e = 0;
        for ( int i = 0 ; i < sub.Collect.count; ++i )
        {
            CreatureBaseIDPerNum* per = [ sub.Collect objectAtIndex:i ];
            
            if ( [ item getCollect:per.ID ] )
            {
                c++;
            }
        }
        
        for ( int i = 0 ; i < sub.Dig.count; ++i )
        {
            CreatureBaseIDPerNum* per = [ sub.Dig objectAtIndex:i ];
            
            if ( [ item getDig:per.ID ] )
            {
                d++;
            }
        }
        
        for ( int i = 0 ; i < sub.Enemy.count; ++i )
        {
            CreatureBaseIDPerNum* per = [ sub.Enemy objectAtIndex:i ];
            
            if ( [ item getEnemy:per.ID ] )
            {
                e++;
            }
        }
        
        if ( item.Per == 1.0f && c == sub.Collect.count &&
            d == sub.Dig.count &&
            e == sub.Enemy.count )
        {
            item.Complete = YES;
        }
    }

}

- ( void ) randomSPEnemy
{
    if ( [ PlayerData instance ].Day % 5 != 1 )
    {
        return;
    }
    
    for ( int i = 0 ; i < Data.count ; ++i )
    {
        int key = [ [ Data.allKeys objectAtIndex:i ] intValue ];
        SceneDataItem* item = [ Data objectForKey:[ NSNumber numberWithInt:key ] ];
        
        SubSceneMap* sub = [ [ MapConfig instance] getSubSceneMap:key ];
        
        if ( !item.Complete )
        {
            continue;
        }
        
        int r = getRand( 0 , 500 );
        
        item.SPEnemy = NO;
        
        if ( sub.SPEnemy.count )
        {
            CreatureBaseIDPerNum* drop = [ sub.SPEnemy objectAtIndex:0 ];
            
            item.SPEnemy = r < drop.Per;
        }
    }
}

- ( void ) activeSceneData:( int )i
{
    SceneDataItem* item = [ [ SceneDataItem alloc ] init ];
    item.DigArray = [ [ NSMutableArray alloc ] init ];
    item.EnemyArray = [ [ NSMutableArray alloc ] init ];
    item.CollectArray = [ [ NSMutableArray alloc ] init ];
    item.DataDic = [ [ NSMutableDictionary alloc ] init ];
    item.DoorDic = [ [ NSMutableDictionary alloc ] init ];
    item.TreasureDic = [ [ NSMutableDictionary alloc ] init ];
    
    [ Data setObject:item forKey:[ NSNumber numberWithInt:i ] ];
    [ item release ];
}

- ( void ) initData
{
    Data = [ [ NSMutableDictionary alloc ] init ];
    
    SPSceneDataItem = [ [ SceneDataItem alloc ] init ];
    SPSceneDataItem.DigArray = [ [ NSMutableArray alloc ] init ];
    SPSceneDataItem.EnemyArray = [ [ NSMutableArray alloc ] init ];
    SPSceneDataItem.CollectArray = [ [ NSMutableArray alloc ] init ];
    SPSceneDataItem.DataDic = [ [ NSMutableDictionary alloc ] init ];
    SPSceneDataItem.DoorDic = [ [ NSMutableDictionary alloc ] init ];
    SPSceneDataItem.TreasureDic = [ [ NSMutableDictionary alloc ] init ];
    
}


- ( void ) clearData
{
    [ Data removeAllObjects ];
    [ Data release ];
    Data = NULL;
}



@end
