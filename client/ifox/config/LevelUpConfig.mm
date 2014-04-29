//
//  LevelUpConfig.m
//  sc
//
//  Created by fox on 13-9-7.
//
//

#import "LevelUpConfig.h"

@implementation LevelUpConfig



LevelUpConfig* gLevelUpConfig = NULL;
+ ( LevelUpConfig* ) instance
{
    if ( !gLevelUpConfig )
    {
        gLevelUpConfig = [ [ LevelUpConfig alloc ] init ];
    }
    
    return gLevelUpConfig;
}

- ( void ) initConfig
{
    dic = [ [ NSMutableDictionary alloc ] init ];
    
    NSData* data = loadXML( @"levelup" );
    NSXMLParser* parser = [ [ NSXMLParser alloc] initWithData:data ];
    [ parser setDelegate:self ];
    [ parser parse ];
    [ parser release ];
}

- ( void ) releaseConfig
{
    [ dic removeAllObjects ];
    [ dic release ];
    dic = NULL;
}

-( void )parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ( [ elementName isEqualToString:@"l" ] )
    {
        CreatureBaseData* data = [ [ CreatureBaseData alloc ] init ];
        
        int type = [ [ attributeDict objectForKey:@"type" ] intValue ];
        
        data.MaxHP = [ [ attributeDict objectForKey:@"maxHP" ] floatValue ];
        data.HP = data.MaxHP;
        data.MaxSP = [ [ attributeDict objectForKey:@"maxSP" ] floatValue ];
        data.SP = data.MaxSP;
        data.MaxFS = [ [ attributeDict objectForKey:@"maxFS" ] floatValue ];
        data.FS = data.MaxFS;
        data.PAtk = [ [ attributeDict objectForKey:@"pAtk" ] floatValue ];
        data.PDef = [ [ attributeDict objectForKey:@"pDef" ] floatValue ];
        data.MAtk = [ [ attributeDict objectForKey:@"mAtk" ] floatValue ];
        data.MDef = [ [ attributeDict objectForKey:@"mDef" ] floatValue ];
        data.Agile = [ [ attributeDict objectForKey:@"agile" ] floatValue ];
        data.Lucky = [ [ attributeDict objectForKey:@"lucky" ] floatValue ];
        data.Hit = [ [ attributeDict objectForKey:@"hit" ] floatValue ];
        data.Miss = [ [ attributeDict objectForKey:@"miss" ] floatValue ];
        data.Critical = [ [ attributeDict objectForKey:@"critical" ] floatValue ];
        data.Move = [ [ attributeDict objectForKey:@"move" ] floatValue ];
        data.CP = [ [ attributeDict objectForKey:@"cp" ] floatValue ];
        data.Guest = [ [ attributeDict objectForKey:@"guest" ] floatValue ];
        
        [ dic setObject:data forKey:[ NSNumber numberWithInt:type ] ];
        
        [ data release ];
    }
    
}

- ( CreatureBaseData* ) getBaseData:( int )p
{
    return [ dic objectForKey:[ NSNumber numberWithInt:p ] ];
}



@end
