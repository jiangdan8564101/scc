//
//  HitConfig.m
//  sc
//
//  Created by YW-01D-0020 on 14-1-17.
//
//

#import "HitConfig.h"

@implementation HitConfigData
@synthesize ProLevel , ID , Per , Value;
@end


@implementation HitConfig

HitConfig* gHitConfig = NULL;
+ ( HitConfig* ) instance
{
    if ( !gHitConfig )
    {
        gHitConfig = [ [ HitConfig alloc ] init ];
    }
    
    return gHitConfig;
}


- ( HitConfigData** ) getHit:( int )p
{
    return data[ p ];
}


- ( void ) initConfig
{
    NSData* data1 = loadXML( @"hit" );
    NSXMLParser* parser = [ [ NSXMLParser alloc] initWithData:data1 ];
    [ parser setDelegate:self ];
    [ parser parse ];
    [ parser release ];
}

- ( void ) releaseConfig
{
    for ( int i = 0 ; i < MAX_PROFESSION_LEVEL ; ++i )
    {
        for ( int j = 0 ; j < BRHS_HIT5 ; ++j )
        {
            [ data[ i ][ j ] release ];
            data[ i ][ j ] = NULL;
        }
    }
}


-( void )parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    
    if ( [ elementName isEqualToString:@"h" ] )
    {
        int pro = [ [ attributeDict objectForKey:@"ProLevel" ] intValue ];
        int i = [ [ attributeDict objectForKey:@"id" ] intValue ];
        int per = [ [ attributeDict objectForKey:@"per" ] intValue ];
        float value = [ [ attributeDict objectForKey:@"value" ] floatValue ];
        
        data[ pro ][ i - 1 ] = [ [ HitConfigData alloc ] init ];
        data[ pro ][ i - 1 ].ProLevel = pro;
        data[ pro ][ i - 1 ].ID = i;
        data[ pro ][ i - 1 ].Per = per;
        data[ pro ][ i - 1 ].Value = value;
    }
    
}


@end
