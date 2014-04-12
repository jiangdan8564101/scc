//
//  EffectConfig.m
//  sc
//
//  Created by fox on 14-1-29.
//
//

#import "EffectConfig.h"

@implementation EffectConfigData
@synthesize PosX , PosY;
@end



@implementation EffectConfig

@synthesize Dic;

EffectConfig* gEffectConfig = NULL;
+ ( EffectConfig* ) instance
{
    if ( !gEffectConfig )
    {
        gEffectConfig = [ [ EffectConfig alloc ] init ];
    }
    
    return gEffectConfig;
}



- ( void ) initConfig
{
    Dic = [ [ NSMutableDictionary alloc ] init ];
    
    NSData* data = loadXML( @"effect" );
    NSXMLParser* parser = [ [ NSXMLParser alloc] initWithData:data ];
    [ parser setDelegate:self ];
    [ parser parse ];
    [ parser release ];
    
}


- ( EffectConfigData* ) getData:( NSString* )str
{
    return [ Dic objectForKey:str ];
}


-( void )parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ( [ elementName isEqualToString:@"e" ] )
    {
        EffectConfigData* data = [ [ EffectConfigData alloc ] init ];
        
        int x = [ [ attributeDict objectForKey:@"x" ] intValue ];
        int y = [ [ attributeDict objectForKey:@"y" ] intValue ];
        
        data.PosX = x;
        data.PosY = y;
        
        [ Dic setObject:data forKey:[ attributeDict objectForKey:@"id" ] ];
        [ data release ];
    }
    
}



@end
