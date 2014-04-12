//
//  LevelUpPriceConfig.m
//  sc
//
//  Created by fox on 14-1-15.
//
//

#import "LevelUpPriceConfig.h"


@implementation LevelUpPriceConfig
@synthesize Dic;

LevelUpPriceConfig* gLevelUpPriceConfig = NULL;
+ ( LevelUpPriceConfig* ) instance
{
    if ( !gLevelUpPriceConfig )
    {
        gLevelUpPriceConfig = [ [ LevelUpPriceConfig alloc ] init ];
    }
    
    return gLevelUpPriceConfig;
}


- ( void ) initConfig
{
    Dic = [ [ NSMutableDictionary alloc ] init ];
    
    NSData* data = loadXML( @"salary" );
    NSXMLParser* parser = [ [ NSXMLParser alloc] initWithData:data ];
    [ parser setDelegate:self ];
    [ parser parse ];
    [ parser release ];

}


- ( float ) getPrice:( int )l
{
    return [ [ Dic objectForKey:[ NSNumber numberWithInt:l ] ] floatValue ];
}


-( void )parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ( [ elementName isEqualToString:@"s" ] )
    {
        int l = [ [ attributeDict objectForKey:@"lv" ] intValue ];
        float p = [ [ attributeDict objectForKey:@"grow" ] floatValue ];
        
        [ Dic setObject:[ NSNumber numberWithFloat:p ] forKey:[ NSNumber numberWithInt:l ] ];
    }
    
}


@end
