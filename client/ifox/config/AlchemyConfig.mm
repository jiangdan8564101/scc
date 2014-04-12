//
//  AlchemyConfig.m
//  sc
//
//  Created by fox on 13-10-14.
//
//

#import "AlchemyConfig.h"


@implementation AlchemyConfigItemData
@synthesize Number , ItemID;
@end


@implementation AlchemyConfigData
@synthesize Items;
@synthesize ItemID , Number;
@synthesize AlchemyID , Rank;
@end

@implementation AlchemyConfig
@synthesize Dic;

AlchemyConfig* gAlchemyConfig = NULL;
+ ( AlchemyConfig* ) instance
{
    if ( !gAlchemyConfig )
    {
        gAlchemyConfig = [ [ AlchemyConfig alloc ] init ];
    }
    
    return gAlchemyConfig;
}


- ( AlchemyConfigData* ) getAlchemy:( int )d
{
    return [ Dic objectForKey:[ NSNumber numberWithInt:d ] ];
}


- ( void ) initConfig
{
    Dic = [ [ NSMutableDictionary alloc ] init ];
    
    NSData* data = loadXML( @"alchemy" );
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
    if ( [ elementName isEqualToString:@"a" ] )
    {
        AlchemyConfigData* data = [ [ AlchemyConfigData alloc ] init ];
        data.Items = [ [ NSMutableArray alloc ] init ];
        
        data.AlchemyID = [ [ attributeDict objectForKey:@"id" ] intValue ];
        data.Rank = [ [ attributeDict objectForKey:@"rank" ] intValue ];
        data.ItemID = [ [ attributeDict objectForKey:@"itemID" ] intValue ];
        data.Number = [ [ attributeDict objectForKey:@"num" ] intValue ];

        for ( int i = 0 ; i < MAX_ALCHEMY_ITEM ; ++i )
        {
            if ( [ attributeDict objectForKey:[ NSString stringWithFormat:@"i%d" , i ] ] )
            {
                int ii = [ [ attributeDict objectForKey:[ NSString stringWithFormat:@"i%d" , i ] ] intValue ];
                int n = [ [ attributeDict objectForKey:[ NSString stringWithFormat:@"n%d" , i ] ] intValue ];
                
                AlchemyConfigItemData* itemData = [ [ AlchemyConfigItemData alloc ] init ];
                
                itemData.ItemID = ii;
                itemData.Number = n;
                    
                [ data.Items addObject:itemData ];
                [ itemData release ];
            }
        }
        
        
        [ Dic setObject:data forKey:[ NSNumber numberWithInt:data.AlchemyID ] ];
        [ data release ];
    }
    
}


@end



