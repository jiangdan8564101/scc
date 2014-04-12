//
//  BuyItemConfig.m
//  sc
//
//  Created by fox on 13-12-1.
//
//

#import "BuyItemConfig.h"

@implementation BuyItemConfig
@synthesize Array;

BuyItemConfig* gBuyItemConfig = NULL;
+ ( BuyItemConfig* ) instance
{
    if ( !gBuyItemConfig )
    {
        gBuyItemConfig = [ [ BuyItemConfig alloc ] init ];
    }
    
    return gBuyItemConfig;
}


- ( void ) initConfig
{
    Array = [ [ NSMutableArray alloc ] init ];
    
    NSData* data = loadXML( @"buyitem" );
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
    
    if ( [ elementName isEqualToString:@"buy" ] )
    {
        [ Array addObject:[ NSMutableArray array ] ];
    }
    
    
    if ( [ elementName isEqualToString:@"i" ] )
    {
        [ [ Array objectAtIndex:Array.count - 1 ] addObject:[ NSNumber numberWithInt:[ [ attributeDict objectForKey:@"id" ] intValue ] ]  ];
    }
    
}



@end


