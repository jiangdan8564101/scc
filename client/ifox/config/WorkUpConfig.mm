//
//  WorkUpConfig.m
//  sc
//
//  Created by fox on 13-11-23.
//
//

#import "WorkUpConfig.h"


@implementation WorkUpConfigItemData
@synthesize Item0 , Item1 , Num0 , Num1 , Gold;
@end


@implementation WorkUpConfigData
@synthesize Array, Level , Employ , Gold , DayGold;
@end

@implementation WorkUpConfig
@synthesize Array;

- ( WorkUpConfigData* ) getWorkUp:( int )d
{
    return [ Array objectAtIndex:d ];
}

WorkUpConfig* gWorkUpConfig = NULL;
+ ( WorkUpConfig* ) instance
{
    if ( !gWorkUpConfig )
    {
        gWorkUpConfig = [ [ WorkUpConfig alloc ] init ];
    }
    
    return gWorkUpConfig;
}


- ( void ) initConfig
{
    Array = [ [ NSMutableArray alloc ] init ];
    
    NSData* data = loadXML( @"workup" );
    NSXMLParser* parser = [ [ NSXMLParser alloc] initWithData:data ];
    [ parser setDelegate:self ];
    [ parser parse ];
    [ parser release ];
}


- ( void ) releaseConfig
{
    [ Array removeAllObjects ];
    [ Array release ];
    Array = NULL;
}


-( void )parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    static int level = 0;
    static WorkUpConfigData* data = NULL;
    WorkUpConfigItemData* d = NULL;
    
    if ( [ elementName isEqualToString:@"level" ] )
    {
        data = [ [ WorkUpConfigData alloc ] init ];
        
        data.Level = level;
        data.Gold = [ [ attributeDict objectForKey: @"gold" ] intValue ];
        data.Employ = [ [ attributeDict objectForKey: @"employ" ] intValue ];
        data.DayGold = [ [ attributeDict objectForKey: @"goldDay" ] intValue ];
        
        [ Array addObject:data ];
        [ data release ];
        
        // memory leek,,
        data.Array = [ [ NSMutableArray alloc ] init ];
        [ data.Array addObject:[ [ WorkUpConfigItemData alloc ] init ] ];
        [ data.Array addObject:[ [ WorkUpConfigItemData alloc ] init ] ];
        [ data.Array addObject:[ [ WorkUpConfigItemData alloc ] init ] ];
        [ data.Array addObject:[ [ WorkUpConfigItemData alloc ] init ] ];
        
        data.Level = level;
        
        d = [ data.Array objectAtIndex:0 ];
        
        level++;
    }
    
    if ( [ elementName isEqualToString:@"l0" ] )
    {
        d = [ data.Array objectAtIndex:0 ];
    }
    
    if ( [ elementName isEqualToString:@"l1" ] )
    {
        d = [ data.Array objectAtIndex:1 ];
    }
    if ( [ elementName isEqualToString:@"l2" ] )
    {
        d = [ data.Array objectAtIndex:2 ];
    }
    if ( [ elementName isEqualToString:@"l3" ] )
    {
        d = [ data.Array objectAtIndex:3 ];
    }
    
    if ( d )
    {
        d.Item0 = [ [ attributeDict objectForKey:@"item0" ] intValue ];
        d.Item1 = [ [ attributeDict objectForKey:@"item1" ] intValue ];
        d.Num0 = [ [ attributeDict objectForKey:@"num0" ] intValue ];
        d.Num1 = [ [ attributeDict objectForKey:@"num1" ] intValue ];
        d.Gold = [ [ attributeDict objectForKey:@"gold" ] intValue ];
    }
    

}

@end
