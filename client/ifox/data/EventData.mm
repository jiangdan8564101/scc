//
//  GameEventData.m
//  sc
//
//  Created by fox on 14-1-13.
//
//

#import "EventData.h"
#import "EventConfig.h"


@implementation EventData
@synthesize Dic;



EventData* gEventData = NULL;
+( EventData* )instance
{
    if ( !gEventData )
    {
        gEventData = [ [ EventData alloc ] init ];
    }
    
    return  gEventData;
}

- ( void ) initData
{
    Dic = [ [ NSMutableDictionary alloc ] init ];
}

- ( void ) clearData
{
    [ Dic removeAllObjects ];
}

- ( void ) setCompleteEvent:( int )i
{
    EventConfigData* data = [ [ EventConfig instance ] getEventConfigData:i ];
    
    [ Dic setObject:[ NSNumber numberWithInt:data.NextID ] forKey:[ NSNumber numberWithInt:i ] ];
}


- ( int ) getCompleteEvent:( int )i
{
    return [ [ Dic objectForKey:[ NSNumber numberWithInt:i ] ] intValue ];
}


- ( BOOL ) checkCompleteEventNext:( int )ii
{
    for ( int i = 0 ; i < Dic.count ; ++i )
    {
        if ( [ [ Dic.allValues objectAtIndex:i ] intValue ] == ii )
        {
            return YES;
        }
    }
    
    return NO;
}

@end
