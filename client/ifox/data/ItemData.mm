//
//  ItemData.m
//  sc
//
//  Created by fox on 13-9-7.
//
//

#import "ItemData.h"
#import "PlayerData.h"
#import "CreatureConfig.h"
#import "GameCenterFile.h"

@implementation PackItemData
{
}
@synthesize ItemID , Number , newItem , alchemyItem;


-( void ) encodeWithCoder:( NSCoder* )coder
{
    [ coder encodeObject:[ NSNumber numberWithInt:ItemID ] forKey:@"id" ];
    [ coder encodeObject:[ NSNumber numberWithInt:Number ] forKey:@"num" ];
    [ coder encodeObject:[ NSNumber numberWithInt:newItem ] forKey:@"new" ];
    [ coder encodeObject:[ NSNumber numberWithInt:alchemyItem ] forKey:@"alchemy" ];
}

-( id ) initWithCoder:( NSCoder* )coder
{
    self = [ self init ];
    
    ItemID = [ [ coder decodeObjectForKey:@"id" ] intValue ];
    Number = [ [ coder decodeObjectForKey:@"num" ] intValue ];
    newItem = [ [ coder decodeObjectForKey:@"new" ] intValue ];
    alchemyItem = [ [ coder decodeObjectForKey:@"alchemy" ] intValue ];
    
    return self;
}

- ( id ) copyWithZone:( NSZone* )zone
{
    PackItemData* copy = [ [ self class ] allocWithZone:zone ];
    
    copy.Number = Number;
    copy.ItemID = ItemID;
    copy.newItem = newItem;
    copy.alchemyItem = alchemyItem;
    
    return copy;
}

@end

@implementation ItemData

@synthesize Items;


- ( NSArray* ) useHPItem:( NSArray* )c
{
    NSMutableDictionary* dic = types[ ICDT_CON ];
    NSArray* array = getSortKeys( dic );
    NSMutableDictionary* dic1 = [ NSMutableDictionary dictionary ];
    
    for ( int i = 0 ; i < array.count ; ++i )
    {
        PackItemData* data = [ dic objectForKey:[ array objectAtIndex:i ] ];
        ItemConfigData* cd = [ [ ItemConfig instance ] getData:data.ItemID ];
        
        if ( !data.Number || !cd.HP )
        {
            continue;
        }
        
        for ( int j = 0 ; j < c.count ; ++j )
        {
            CreatureCommonData* comm = [ c objectAtIndex:j ];
            
            if ( !comm.Dead && comm.RealBaseData.HP < comm.RealBaseData.MaxHP )
            {
                // use item,,
                BOOL b = cd.HP > ( comm.RealBaseData.MaxHP - comm.RealBaseData.HP ) * 0.75f || comm.RealBaseData.MaxHP >= comm.RealBaseData.HP * 2;
                
                if ( data.Number && b )
                {
                    data.Number--;
                    comm.RealBaseData.HP += cd.HP;
                    
                    [ dic1 setObject:comm forKey:[ NSNumber numberWithInt:j ] ];
                    
                    if ( comm.RealBaseData.HP > comm.RealBaseData.MaxHP )
                    {
                        comm.RealBaseData.HP = comm.RealBaseData.MaxHP;
                    }
                }
            }
        }
    }
    
    array = getSortKeys( dic1 );
    return array;
}
- ( NSArray* ) useSPItem:( NSArray* )c
{
    NSMutableDictionary* dic = types[ ICDT_CON ];
    NSArray* array = getSortKeys( dic );
    NSMutableDictionary* dic1 = [ NSMutableDictionary dictionary ];
    
    for ( int i = 0 ; i < array.count ; ++i )
    {
        PackItemData* data = [ dic objectForKey:[ array objectAtIndex:i ] ];
        ItemConfigData* cd = [ [ ItemConfig instance ] getData:data.ItemID ];
        
        if ( !data.Number || !cd.SP )
        {
            continue;
        }
        
        for ( int j = 0 ; j < c.count ; ++j )
        {
            CreatureCommonData* comm = [ c objectAtIndex:j ];
            
            if ( comm.RealBaseData.SP < comm.RealBaseData.MaxSP )
            {
                // use item,,
                
                BOOL b = cd.HP > ( comm.RealBaseData.MaxSP - comm.RealBaseData.SP ) * 0.75f || comm.RealBaseData.MaxSP >= comm.RealBaseData.SP * 2;
                
                if ( data.Number && b )
                {
                    data.Number--;
                    comm.RealBaseData.SP += cd.SP;
                    
                    [ dic1 setObject:comm forKey:[ NSNumber numberWithInt:j ] ];
                    
                    if ( comm.RealBaseData.SP > comm.RealBaseData.MaxSP )
                    {
                        comm.RealBaseData.SP = comm.RealBaseData.MaxSP;
                    }
                }
            }
        }
    }
    
    array = getSortKeys( dic1 );
    return array;
    
}
- ( NSArray* ) useFSItem:( NSArray* )c
{
    return NULL;
}

- ( void ) sellItem:( int )i :( int )n
{
    if ( !n )
    {
        return;
    }
    
    ItemConfigData* dd = [ [ ItemConfig instance ] getData:i ];
    PackItemData* pd = [ self getItem:i ];
    
    if ( pd.Number >= n )
    {
        [ self removeItem:i :n ];
        
        int sell = dd.Sell;
        
        if ( dd.Type2 )
        {
            sell = sell + sell * [ PlayerData instance ].WorkItemEffect[ dd.Type2 + ICDET_SELL1 - 1 ];
        }
        
        [ PlayerData instance ].SellGold += sell * n;
        [ PlayerData instance ].Gold += sell * n;
        
        //[ [ GameKitHelper sharedGameKitHelper ] reportScore:[ PlayerData instance ].SellGold forCategory:@"gold" ];
    }
    
}

- ( void ) buyItem:( int )i :( int )n
{
    if ( !n )
    {
        return;
    }
    
    ItemConfigData* dd = [ [ ItemConfig instance ] getData:i ];
    
    if ( [ PlayerData instance ].Gold >= dd.Buy * n )
    {
        [ self addItem:i :n ];
        
        [ PlayerData instance ].Gold -= dd.Buy * n;
    }
    
}

- ( NSMutableDictionary* ) getType:( int )t
{
    return types[ t ];
}

- ( PackItemData* ) getItem:( int )i
{
    return [ Items objectForKey:[ NSNumber numberWithInt:i ] ];
}

- ( void ) initItem:( PackItemData* )d
{
    [ Items setObject:d forKey:[ NSNumber numberWithInt:d.ItemID ] ];
    
    ItemConfigData* dd = [ [ ItemConfig instance ] getData:d.ItemID ];
    [ types[ dd.Type ] setObject:d forKey:[ NSNumber numberWithInt:d.ItemID ] ];
}

- ( PackItemData* ) addItem:( int )i :( int )n
{
    PackItemData* data = [ Items objectForKey:[ NSNumber numberWithInt:i ] ];
    
    if ( !data )
    {
        data = [ [ PackItemData alloc ] init ];
        data.newItem = YES;
        data.alchemyItem = YES;
        
        [ Items setObject:data forKey:[ NSNumber numberWithInt:i ] ];
        
        ItemConfigData* d = [ [ ItemConfig instance ] getData:i ];
        [ types[ d.Type ] setObject:data forKey:[ NSNumber numberWithInt:i ] ];
    }
    
    data.ItemID = i;
    data.Number += n;
    
    return data;
}

- ( void ) removeItem:( int )i :( int )n
{
    if ( !n )
    {
        return;
    }
    
    PackItemData* data = [ Items objectForKey:[ NSNumber numberWithInt:i ] ];
    
    if ( !data )
    {
        return;
    }
    
    data.ItemID = i;
    data.Number -= n;
}

- ( int ) alchemyNum:( int )i
{
    AlchemyConfigData* acd = [ [ AlchemyConfig instance ] getAlchemy:i ];
    
    int max = MAX_ITEM;
    
    for ( int i = 0 ; i < acd.Items.count ; ++i )
    {
        AlchemyConfigItemData* acid = [ acd.Items objectAtIndex:i ];
        
        PackItemData* itemData = [ self getItem:acid.ItemID ];
        
        if ( !itemData )
        {
            return 0 ;
        }
        
        int n = itemData.Number / acd.Number;
        
        if ( n < max )
        {
            max = n;
        }
    }
    
    return max;
}


- ( BOOL ) canAlchemy:( int )ii :( int )n
{
    if ( !n )
    {
        return NO;
    }
    
    AlchemyConfigData* acd = [ [ AlchemyConfig instance ] getAlchemy:ii ];
    
    for ( int i = 0 ; i < acd.Items.count ; ++i )
    {
        AlchemyConfigItemData* acid = [ acd.Items objectAtIndex:i ];
        
        PackItemData* itemData = [ self getItem:acid.ItemID ];
        
        if ( !itemData || itemData.Number < acid.Number * n )
        {
            return NO;
        }
    }
    
    return YES;
}

- ( void ) alchemyItem:( int )ii :( int )n
{
    if ( !n )
    {
        return;
    }
    
    AlchemyConfigData* acd = [ [ AlchemyConfig instance ] getAlchemy:ii ];
    
    for ( int i = 0 ; i < acd.Items.count ; ++i )
    {
        AlchemyConfigItemData* acid = [ acd.Items objectAtIndex:i ];
        
        PackItemData* itemData = [ self getItem:acid.ItemID ];
        
        itemData.Number -= acid.Number * n;
    }
    
    PackItemData* pdata = [ self addItem:acd.ItemID :n ];
    pdata.alchemyItem = NO;
    pdata.newItem = NO;
}


- ( void ) initData
{
    for ( int i = 0 ; i < ICDT_COUNT ; ++i )
    {
        types[ i ] = [ [ NSMutableDictionary alloc ] init ];
    }
    
    Items = [ [ NSMutableDictionary alloc ] init ];
}


ItemData* gItemData = NULL;
+ ( ItemData* ) instance
{
    if ( !gItemData )
    {
        gItemData = [ [ ItemData alloc ] init ];
    }
    
    return gItemData;
}


@end





