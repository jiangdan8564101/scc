//
//  ProDiffConfig.m
//  sc
//
//  Created by YW-01D-0020 on 14-4-29.
//
//

#import "ProDiffConfig.h"


@implementation ProDiffConfigData
@synthesize HP , SP , PAtk , PDef , MAtk , MDef , Agile , Lucky;
@end

@implementation ProDiffConfig
@synthesize Dic;

- ( ProDiffConfigData* ) getData:( int )pro
{
    return [ Dic objectForKey:[ NSNumber numberWithInt:pro ] ];
}


ProDiffConfig* gProDiffConfig = NULL;
+ ( ProDiffConfig* ) instance
{
    if ( !gProDiffConfig )
    {
        gProDiffConfig = [ [ ProDiffConfig alloc ] init ];
    }
    
    return gProDiffConfig;
}



- ( void ) initConfig
{
    Dic = [ [ NSMutableDictionary alloc ] init ];
    
    NSData* data = loadXML( @"proDiff" );
    NSXMLParser* parser = [ [ NSXMLParser alloc] initWithData:data ];
    [ parser setDelegate:self ];
    [ parser parse ];
    [ parser release ];
    
}



-( void )parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ( [ elementName isEqualToString:@"d" ] )
    {
        ProDiffConfigData* data = [ [ ProDiffConfigData alloc ] init ];
        
        int id1 = [ [ attributeDict objectForKey:@"id" ] intValue ];
        data.HP = [ [ attributeDict objectForKey:@"hp" ] floatValue ];
        data.SP = [ [ attributeDict objectForKey:@"sp" ] floatValue ];
        data.PAtk = [ [ attributeDict objectForKey:@"pAtk" ] floatValue ];
        data.PDef = [ [ attributeDict objectForKey:@"pDef" ] floatValue ];
        data.MAtk = [ [ attributeDict objectForKey:@"mAtk" ] floatValue ];
        data.MDef = [ [ attributeDict objectForKey:@"mDef" ] floatValue ];
        data.Agile = [ [ attributeDict objectForKey:@"agile" ] floatValue ];
        data.Lucky = [ [ attributeDict objectForKey:@"lucky" ] floatValue ];
        
        [ Dic setObject:data forKey:[ NSNumber numberWithInt:id1 ] ];
        [ data release ];
    }
    
}



@end
