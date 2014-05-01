//
//  PlayerData.m
//  sc
//
//  Created by fox on 13-4-18.
//
//

#import "PlayerData.h"
#import "ItemData.h"
#import "WorkUpConfig.h"
#import "GuideConfig.h"
#import "TalkUIHandler.h"
#import "GameSceneManager.h"
#import "PlayerCreatureData.h"
#import "AlertUIHandler.h"
#import "LevelUpPriceConfig.h"
#import "GameCenterFile.h"

@implementation PlayerData

@synthesize Story;
@synthesize GoPay;
@synthesize Year , Month , Day;
@synthesize SellGold;
@synthesize WorkLevel , WorkRank , AlchemyRank , AssessRank;
@synthesize Employ , Monster , WorkItem;
@synthesize WorkItemEffect;
@synthesize BattleSpeed;
@synthesize GrowItemOneDay;
@synthesize GrowItem;

PlayerData* gPlayerData = NULL;
+ ( PlayerData* ) instance
{
    if ( !gPlayerData )
    {
        gPlayerData = [ [ PlayerData alloc ] init ];
    }
    
    return gPlayerData;
}


- ( void ) initData
{
    WorkLevel = workLevel;
    WorkItemEffect = workItemEffect;
    
    Year = 1;
    Month = 1;
    Day = 1;
    
    dayData[ 0 ] = 31;
    dayData[ 1 ] = 28;
    dayData[ 2 ] = 31;
    dayData[ 3 ] = 30;
    dayData[ 4 ] = 31;
    dayData[ 5 ] = 30;
    dayData[ 6 ] = 31;
    dayData[ 7 ] = 31;
    dayData[ 8 ] = 30;
    dayData[ 9 ] = 31;
    dayData[ 10 ] = 30;
    dayData[ 11 ] = 31;
    
    gold1 = 0;
    gold2 = 0;
    
    Story = 1;
    
    BattleSpeed = 1;
    
    Employ = [ [ NSMutableDictionary alloc ] init ];
    Monster = [ [ NSMutableDictionary alloc ] init ];
    WorkItem = [ [ NSMutableDictionary alloc ] init ];
    GrowItemOneDay = [ [ NSMutableDictionary alloc ] init ];
    GrowItem = [ [ NSMutableDictionary alloc ] init ];
}


- ( BOOL ) updateGrowItem
{
    BOOL b = NO;

    for ( int i = 0 ; i < GrowItemOneDay.count ; i++ )
    {
        int key = [ [ GrowItemOneDay.allKeys objectAtIndex:i ] intValue ];
        
        float v = 0.0f;
        if ( [ GrowItem objectForKey:[ NSNumber numberWithInt:key ] ] )
        {
            v += [ [ GrowItem objectForKey:[ NSNumber numberWithInt:key ] ] floatValue ];
        }
        
        while ( v >= 1.0f )
        {
            v -= 1.0f;
            [ [ ItemData instance ] addItem:key :1 ];
            
            b = YES;
        }
        
        [ GrowItem setObject:[ NSNumber numberWithFloat:v ] forKey:[ NSNumber numberWithInt:key ] ];
    }
    
    return b;
}


- ( void ) updateGrow
{
    for ( int i = 0 ; i < GrowItemOneDay.count ; i++ )
    {
        int key = [ [ GrowItemOneDay.allKeys objectAtIndex:i ] intValue ];
        float value = [ [ GrowItemOneDay objectForKey:[ GrowItemOneDay.allKeys objectAtIndex:i ] ] floatValue ];
        
        float v = 0.0f;
        if ( [ GrowItem objectForKey:[ NSNumber numberWithInt:key ] ] )
        {
            v += [ [ GrowItem objectForKey:[ NSNumber numberWithInt:key ] ] floatValue ];
        }
        
        v += value;
        
        [ GrowItem setObject:[ NSNumber numberWithFloat:v ] forKey:[ NSNumber numberWithInt:key ] ];
    }
}

- ( void ) updateWorkItemEffect
{
    [ GrowItemOneDay removeAllObjects ];
    
    for ( int i = 0 ; i < ICDET_COUNT ; ++i )
    {
        workItemEffect[ i ] = 0.0f;
    }
    
    for ( int i = 0 ; i < WorkItem.count ; ++i )
    {
        int itemID = [ [ WorkItem.allValues objectAtIndex:i ] intValue ];
        ItemConfigData* item = [ [ ItemConfig instance ] getData:itemID ];
        
        if ( item.GrowID )
        {
            float v = 0.0f;
            if ( [ GrowItemOneDay objectForKey:[ NSNumber numberWithInt:item.GrowID ] ] )
            {
                v = [ [ GrowItemOneDay objectForKey:[ NSNumber numberWithInt:item.GrowID ] ] floatValue ];
            }
            
            v += item.GrowDay;
            [ GrowItemOneDay setObject:[ NSNumber numberWithFloat:v ] forKey:[ NSNumber numberWithInt:item.GrowID ] ];
        }
        
        workItemEffect[ item.EffectType ] += item.Effect;
    }
}


- ( void ) setEmployData:( int )c
{
    [ Employ setObject:[ NSNumber numberWithInt:1 ] forKey:[ NSNumber numberWithInt:c ] ];
}


- ( int ) getEmployData:( int )c
{
    return [ [ Employ objectForKey:[ NSNumber numberWithInt:c ] ] intValue ];
}


- ( void ) setMonsterData:( int )c
{
    int n = 1;
    
    if ( [ Monster objectForKey:[ NSNumber numberWithInt:c ] ] )
    {
        n = [ [ Monster objectForKey:[ NSNumber numberWithInt:c ] ] intValue ] + 1;
        
        if ( n > 1000 )
        {
            n = MAX_ITEM;
        }
    }
    
    [ Monster setObject:[ NSNumber numberWithInt:n ] forKey:[ NSNumber numberWithInt:c ] ];
}


- ( void ) setWorkItemData:( int )c :( int )i
{
    [ WorkItem setObject:[ NSNumber numberWithInt:i ] forKey:[ NSNumber numberWithInt:c ] ];
}


- ( int ) getWorkItemData:( int )c
{
    return [ [ WorkItem objectForKey:[ NSNumber numberWithInt:c ] ] intValue ];
}


- ( int ) getMonsterData:( int )c
{
    return [ [ Monster objectForKey:[ NSNumber numberWithInt:c ] ] intValue ];
}


- ( int ) getDay
{
    if ( GoPay )
    {
        return dayData[ GoPay - 1 ];
    }
    else
    {
        return Day;
    }
}


- ( void ) pay
{
    // check error ,,,
    
    int day = dayData[ GoPay - 1 ];
    
    int goldCount = 0;
    
    WorkUpConfigData* data = [ [ WorkUpConfig instance ] getWorkUp:WorkRank ];
    
    NSMutableDictionary* dic = [ PlayerCreatureData instance ].PlayerDic;
    
    goldCount -= data.Gold;
    goldCount -= data.DayGold * dic.allValues.count * day;
    
    for ( int i = 0 ; i < dic.allValues.count ; ++i )
    {
        CreatureCommonData* comm = [ dic.allValues objectAtIndex:i ];
        
        goldCount -= [ comm getEmployPrice ];
    }
    
    [ self addGold:goldCount ];
    
    GoPay = 0;
    
    if ( SellGold >= MAX_GOLD )
    {
        SellGold = MAX_GOLD;
    }
    
    [ [ GameKitHelper sharedGameKitHelper ] reportScore:SellGold forCategory:@"gold" ];
    
    //SellGold = 0;
}


- ( void ) goDate:( int )d
{
    if ( Day + d > dayData[ Month - 1 ] )
    {
        Day = Day + d - dayData[ Month - 1 ];
        
        GoPay = Month;
        
        Month++;
        
        if ( Month > 12 )
        {
            Month = 1;
            Year++;
        }
    }
    else
    {
        Day += d;
    }
    
    for ( int i = 0 ; i < d ; i++ )
    {
        [ self updateGrow ];
    }
}


- ( void ) clearData
{
    
}


- ( void ) addGold:( int )g
{
    int gold = gold1 + gold2 + g;
    
    gold1 = gold / 2;
    gold2 = gold - gold1;
}
- ( int ) getGold
{
    return gold1 + gold2;
}
- ( void ) setGold:( int )g
{
    gold1 = g / 2;
    gold2 = g - gold1;
}

- ( void ) addMoney:( int )g
{
    int money = money1 + money2 + g;
    
    money1 = money / 2;
    money2 = money - money1;
}
- ( int ) getMoney
{
    return money1 + money2;
}
- ( void ) setMoney:( int )g
{
    money1 = g / 2;
    money2 = g - money1;
}

- ( BOOL ) canWorkLevelUp:( int )t
{
    int l = WorkLevel[ t ];
    
    if ( l >  WorkRank )
    {
        for ( int i = 0 ; i < WUT_COUNT ; ++i )
        {
            if ( i == WorkRank )
            {
                [ [ AlertUIHandler instance ] alert:NSLocalizedString( @"WorkUpError2", nil )  ];
                
                return NO;
            }
        }
        
        [ [ AlertUIHandler instance ] alert:NSLocalizedString( @"WorkUpError1", nil )  ];
        
        return NO;
    }
    
    WorkUpConfigItemData* data = [ [ [ WorkUpConfig instance ] getWorkUp:l ].Array objectAtIndex:t ];
    PackItemData* packData0 = [ [ ItemData instance ] getItem:data.Item0 ];
    PackItemData* packData1 = [ [ ItemData instance ] getItem:data.Item1 ];
    
    BOOL b = ( packData0.Number >= data.Num0 && packData1.Number >= data.Num1 && [ PlayerData instance ].getGold >= data.Gold );
    
    if ( [ PlayerData instance ].getGold < data.Gold )
    {
        [ [ AlertUIHandler instance ] alert:NSLocalizedString( @"NotGold", nil )  ];
        return b;
    }
    
    if ( !b )
    {
        [ [ AlertUIHandler instance ] alert:NSLocalizedString( @"WorkUpError3", nil )  ];
    }
    else
    {
        [ [ AlertUIHandler instance ] alert:NSLocalizedString( @"WorkUpSuccess", nil )  ];
    }
    
    return b;
}


- ( void ) workLevelUp:( int )t
{
    int l = WorkLevel[ t ];
    
    WorkUpConfigItemData* data = [ [ [ WorkUpConfig instance ] getWorkUp:l ].Array objectAtIndex:t ];
    
    WorkLevel[ t ]++;
    
    [ [ ItemData instance ] removeItem:data.Item0 :data.Num0 ];
    [ [ ItemData instance ] removeItem:data.Item1 :data.Num1 ];
    
    [ [ PlayerData instance ] addGold:-data.Gold ];
}

- ( BOOL ) checkBattleStory:( int )s
{
    if ( [ [ TalkUIHandler instance ] isOpened ] )
    {
        return YES;
    }
    
    GuideConfigData* data = [ [ GuideConfig instance ] getStoryData:Story ];
    
    if ( s && data && data.CheckBattle == s )
    {
        [ [ TalkUIHandler instance ] visible:YES ];
        [ [ TalkUIHandler instance ] setData:data.GuideID ];
        
        return YES;
    }
    
    return NO;
}

- ( BOOL ) checkBattleEndStory:( int )s
{
    if ( [ [ TalkUIHandler instance ] isOpened ] )
    {
        return YES;
    }
    
    GuideConfigData* data = [ [ GuideConfig instance ] getStoryData:Story ];
    
    if ( s && data && data.CheckBattleEnd == s )
    {
        [ [ TalkUIHandler instance ] visible:YES ];
        [ [ TalkUIHandler instance ] setData:data.GuideID ];
        
        return YES;
    }
    
    return NO;
}

- ( BOOL ) checkStory
{
    if ( [ [ TalkUIHandler instance ] isOpened ] )
    {
        return YES;
    }
    
    GuideConfigData* data = [ [ GuideConfig instance ] getStoryData:Story ];
    
    if ( data && !data.CheckBattle && !data.CheckBattleEnd )
    {
        if ( data.CheckScene )
        {
            if ( ![[ [ GameSceneManager instance ] getActiveScene ].Name isEqualToString:data.CheckScene ] )
            {
                return NO;
            }
        }
        
        if ( data.WorkRank )
        {
            if ( WorkRank < data.WorkRank )
            {
                return NO;
            }
        }
        
        [ [ TalkUIHandler instance ] visible:YES ];
        [ [ TalkUIHandler instance ] setData:data.GuideID ];
        
        return YES;
    }
    
    return NO;
}


- ( void ) nextStory:( int )s
{
    Story = s;
    
    [ self checkStory ];
}


- ( BOOL ) checkWorkRank
{
    for ( int i = 0 ; i < WUT_COUNT ; ++i )
    {
        if ( workLevel[ i ] == WorkRank )
        {
            return NO;
        }
    }
    
    return YES;
}


- ( void ) levelUpWorkRank
{
    WorkRank++;
    
    [ [ ItemData instance ] addItem:WORK_RANK_ITEM + WorkRank :1 ];
}

@end


