//
//  StoryConfig.m
//  sc
//
//  Created by fox on 13-12-29.
//
//

#import "StoryConfig.h"


@implementation StoryConfigData
@synthesize Name , Des , ID , Index;
@end


@implementation StoryConfig
@synthesize Array;


StoryConfig* gStoryConfig = NULL;
+ ( StoryConfig* ) instance
{
    if ( !gStoryConfig )
    {
        gStoryConfig = [ [ StoryConfig alloc ] init ];
    }
    
    return gStoryConfig;
}



- ( void ) initConfig
{
    Array = [ [ NSMutableArray alloc ] init ];
    
    NSData* data = loadXML( @"story" );
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
    if ( [ elementName isEqualToString:@"s" ] )
    {
        StoryConfigData* data = [ [ StoryConfigData alloc ] init ];
     
        data.ID = [ [ attributeDict objectForKey:@"id" ] intValue ];
        data.Name = [ [ NSString alloc ] initWithString:[ attributeDict objectForKey:@"name" ] ];
        data.Des = [ [ NSString alloc ] initWithString:[ attributeDict objectForKey:@"des" ] ];
        data.Index = Array.count + 1;
        
        [ Array addObject:data ];
        
        [ data release ];
    }
}



@end
