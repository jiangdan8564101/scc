//
//  ActionConfig.m
//  sc
//
//  Created by fox on 13-4-29.
//
//

#import "ActionConfig.h"

@implementation ActionConfig

ActionConfig* gActionConfig = NULL;
+ ( ActionConfig* ) instance
{
    if ( !gActionConfig )
    {
        gActionConfig = [ [ ActionConfig alloc ] init ];
    }
    
    return gActionConfig;
}


- ( NSDictionary* ) getAction:( NSString* )str
{
    return [ actionDic objectForKey:str ];
}



- ( void ) initConfig
{
    actionDic = [ [ NSMutableDictionary alloc ] init ];
    
    NSData* data = loadXML( @"action" );
    NSXMLParser* parser = [ [ NSXMLParser alloc] initWithData:data ];
    [ parser setDelegate:self ];
    [ parser parse ];
    [ parser release ];
}

- ( void ) releaseConfig
{
    [ actionDic removeAllObjects ];
    [ actionDic release ];
    actionDic = NULL;
}


-( void )parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    
    if ( [ elementName isEqualToString:@"a" ] )
    {
        [ actionDic setObject:attributeDict forKey:[ attributeDict objectForKey:@"id" ] ];
    }
}




@end
