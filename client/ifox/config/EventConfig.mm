//
//  EventConfig.m
//  sc
//
//  Created by fox on 14-1-13.
//
//

#import "EventConfig.h"

@implementation EventConfigData

@synthesize ID , WorkUp , Employ , BattleMap , BattleMonster ,  Random , StartGuide , FailedGuide , ComGuide , NextID , CKill , CLevel , CItem0 , CItemNum0 , ComItem0 , ComItemNum0 , ComEmploy , Quest , ComQuest;
@synthesize CheckScene;
@end

@implementation EventConfig
@synthesize Dic;

EventConfig* gEventConfig = NULL;
+ ( EventConfig* ) instance
{
    if ( !gEventConfig )
    {
        gEventConfig = [ [ EventConfig alloc ] init ];
    }
    
    return gEventConfig;
}

- ( EventConfigData* ) getEventConfigData:( int )i
{
    return [ Dic objectForKey:[ NSNumber numberWithInt:i ] ];
}

- ( void ) initConfig
{
    Dic = [ [ NSMutableDictionary alloc ] init ];
    
    NSData* data = loadXML( @"event" );
    NSXMLParser* parser = [ [ NSXMLParser alloc] initWithData:data ];
    [ parser setDelegate:self ];
    [ parser parse ];
    [ parser release ];
}

- ( void ) releaseConfig
{
    [ Dic removeAllObjects ];
    [ Dic release ];
    Dic = NULL;
}

-( void )parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ( [ elementName isEqualToString:@"e" ] )
    {
        EventConfigData* data = [ [ EventConfigData alloc ] init ];
        
        data.ID = [ [ attributeDict objectForKey:@"id" ] intValue ];
        
        data.WorkUp = [ [ attributeDict objectForKey:@"workUp" ] intValue ];
        data.CheckScene = [ [ attributeDict objectForKey:@"checkScene" ] copy ];
        data.Employ = [ [ attributeDict objectForKey:@"employ" ] intValue ];
        
        data.BattleMap = [ [ attributeDict objectForKey:@"battleMap" ] intValue ];
        data.BattleMonster = [ [ attributeDict objectForKey:@"battleMonster" ] intValue ];
        data.Random = [ [ attributeDict objectForKey:@"random" ] intValue ];
        data.StartGuide = [ [ attributeDict objectForKey:@"startGuide" ] intValue ];
        data.FailedGuide = [ [ attributeDict objectForKey:@"failedGuide" ] intValue ];
        data.ComGuide = [ [ attributeDict objectForKey:@"comGuide" ] intValue ];
        data.NextID = [ [ attributeDict objectForKey:@"nextID" ] intValue ];
        data.CKill = [ [ attributeDict objectForKey:@"cKill" ] intValue ];
        data.CItem0 = [ [ attributeDict objectForKey:@"cItem0" ] intValue ];
        data.CItemNum0 = [ [ attributeDict objectForKey:@"cItemNum0" ] intValue ];
        
        data.ComItem0 = [ [ attributeDict objectForKey:@"comItem0" ] intValue ];
        data.ComItemNum0 = [ [ attributeDict objectForKey:@"comItemNum0" ] intValue ];
        data.ComEmploy = [ [ attributeDict objectForKey:@"comEmploy" ] intValue ];
        
        data.Quest = [ [ attributeDict objectForKey:@"quest" ] intValue ];
        data.ComQuest = [ [ attributeDict objectForKey:@"comQuest" ] intValue ];

        [ Dic setObject:data forKey:[ NSNumber numberWithInt:data.ID ] ];
        
        [ data release ];
    }
    
}

@end
