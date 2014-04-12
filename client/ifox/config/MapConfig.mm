//
//  MapConfig.m
//  sc
//
//  Created by fox on 13-2-11.
//
//

#import "MapConfig.h"

@implementation SubSceneMap

@synthesize Name , ID , LV , Collect , Dig , Enemy , SPEnemy , Treasure;
@synthesize BossID , BossNum;

- (void) dealloc
{
    [ Name release ];
    Name = NULL;
    
    [ super dealloc ];
}

@end

@implementation SceneMap

@synthesize Name , SubScenes , ID , Story , WorkRank;

- (void) dealloc
{
    [ Name release ];
    Name = NULL;
    
    [ SubScenes release ];
    SubScenes = NULL;
    
    [ super dealloc ];
}

@end


@implementation MapConfig
@synthesize Scenes;
@synthesize SPSubSceneMap;


MapConfig* gMapConfig = NULL;
+ (MapConfig*) instance
{
    if ( !gMapConfig )
    {
        gMapConfig = [ [ MapConfig alloc ] init ];
    }
    
    return gMapConfig;
}


- ( SceneMap* ) getSceneMap: ( int )i
{
    return [ Scenes objectForKey:[ NSNumber numberWithInt:i ] ];
}


- ( SubSceneMap* ) getSubSceneMap:( int )i
{
    return [ subScenes objectForKey:[ NSNumber numberWithInt:i ] ];
}


- ( void ) initConfig
{
    Scenes = [ [ NSMutableDictionary alloc ] init ];
    subScenes = [ [ NSMutableDictionary alloc ] init ];
    
    SPSubSceneMap = [ [ SubSceneMap alloc ] init ];
    SPSubSceneMap.Collect = [ [ NSMutableArray alloc ] init ];
    SPSubSceneMap.Dig = [ [ NSMutableArray alloc ] init ];
    SPSubSceneMap.Enemy = [ [ NSMutableArray alloc ] init ];
    SPSubSceneMap.SPEnemy = [ [ NSMutableArray alloc ] init ];
    SPSubSceneMap.Treasure = [ [ NSMutableArray alloc ] init ];
    
    
    NSData* data = loadXML( @"map" );
    NSXMLParser* parser = [ [ NSXMLParser alloc] initWithData:data ];
    [ parser setDelegate:self ];
    [ parser parse ];
    [ parser release ];
}

- ( void ) releaseConfig
{
    [ Scenes removeAllObjects ];
    [ Scenes release ];
    Scenes = NULL;
}

-( void )parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    static SceneMap* lastSceneMap = NULL;
    static SubSceneMap* lastSubSceneMap = NULL;
    
    if ( [ elementName isEqualToString:@"m" ] )
    {
        SceneMap* sceneMap = [ [ SceneMap alloc ] init ];
        
        sceneMap.SubScenes = [ [ NSMutableArray alloc ] init ];
        
        if ( [ attributeDict objectForKey:@"name" ] )
        {
            sceneMap.Name = [ [ NSMutableString alloc ] initWithString:[ attributeDict objectForKey:@"name" ] ];
        }
        else
        {
            assert( 0 );
        }
        
        sceneMap.ID = [ [ attributeDict objectForKey:@"id" ] intValue ];
        sceneMap.Story = [ [ attributeDict objectForKey:@"story" ] intValue ];
        sceneMap.WorkRank = [ [ attributeDict objectForKey:@"workRank" ] intValue ];
        
//        sceneMap.Day = [ [ attributeDict objectForKey:@"day" ] intValue ];
        sceneMap.Day = 1;
        
        lastSceneMap = sceneMap;
        
        [ Scenes setObject:sceneMap forKey:[ NSNumber numberWithInt:sceneMap.ID ] ];
        
        [ sceneMap release ];
    }
    
    if ( [ elementName isEqualToString:@"s" ] )
    {
        lastSubSceneMap = [ [ SubSceneMap alloc ] init ];
        lastSubSceneMap.Collect = [ [ NSMutableArray alloc ] init ];
        lastSubSceneMap.Dig = [ [ NSMutableArray alloc ] init ];
        lastSubSceneMap.Enemy = [ [ NSMutableArray alloc ] init ];
        lastSubSceneMap.SPEnemy = [ [ NSMutableArray alloc ] init ];
        lastSubSceneMap.Treasure = [ [ NSMutableArray alloc ] init ];
        
        if ( [ attributeDict objectForKey:@"name" ] )
        {
            lastSubSceneMap.Name = [ [ NSMutableString alloc ] initWithString:[ attributeDict objectForKey:@"name" ] ];
        }
        else
        {
            //assert( 0 );
        }
        lastSubSceneMap.ID = [ [ attributeDict objectForKey:@"id" ] intValue ];
        lastSubSceneMap.LV = [ [ attributeDict objectForKey:@"lv" ] intValue ];
        
        [ lastSceneMap.SubScenes addObject:lastSubSceneMap ];
        
        [ lastSubSceneMap release ];
        
        [ subScenes setObject:lastSubSceneMap forKey:[ NSNumber numberWithInt:lastSubSceneMap.ID ] ];
    }
    
    
    if ( [ elementName isEqualToString:@"c" ] )
    {
        CreatureBaseIDPerNum* drop = [ [ CreatureBaseIDPerNum alloc ] init ];
        drop.ID = [ [ attributeDict objectForKey:@"id" ] intValue ];
        drop.Per = [ [ attributeDict objectForKey:@"per" ] intValue ];
        drop.Num = [ [ attributeDict objectForKey:@"num" ] intValue ];
        
        [ lastSubSceneMap.Collect addObject:drop ];
    }
    
    if ( [ elementName isEqualToString:@"d" ] )
    {
        CreatureBaseIDPerNum* drop = [ [ CreatureBaseIDPerNum alloc ] init ];
        drop.ID = [ [ attributeDict objectForKey:@"id" ] intValue ];
        drop.Per = [ [ attributeDict objectForKey:@"per" ] intValue ];
        drop.Num = [ [ attributeDict objectForKey:@"num" ] intValue ];
        
        [ lastSubSceneMap.Dig addObject:drop ];
    }
    
    
    
    if ( [ elementName isEqualToString:@"e" ] )
    {
        CreatureBaseIDPerNum* drop = [ [ CreatureBaseIDPerNum alloc ] init ];
        drop.ID = [ [ attributeDict objectForKey:@"id" ] intValue ];
        drop.Per = [ [ attributeDict objectForKey:@"per" ] intValue ];
        drop.Num = [ [ attributeDict objectForKey:@"num" ] intValue ];
        
        [ lastSubSceneMap.Enemy addObject:drop ];
    }
    
    if ( [ elementName isEqualToString:@"t" ] )
    {
        CreatureBaseIDPerNum* drop = [ [ CreatureBaseIDPerNum alloc ] init ];
        drop.ID = [ [ attributeDict objectForKey:@"id" ] intValue ];
        drop.Per = [ [ attributeDict objectForKey:@"per" ] intValue ];
        drop.Num = [ [ attributeDict objectForKey:@"num" ] intValue ];
        
        [ lastSubSceneMap.Treasure addObject:drop ];
    }
    
    if ( [ elementName isEqualToString:@"b" ] )
    {
        lastSubSceneMap.BossID = [ [ attributeDict objectForKey:@"id" ] intValue ];
        lastSubSceneMap.BossNum = [ [ attributeDict objectForKey:@"num" ] intValue ];
    }
    
    if ( [ elementName isEqualToString:@"p" ] )
    {
        CreatureBaseIDPerNum* drop = [ [ CreatureBaseIDPerNum alloc ] init ];
        drop.ID = [ [ attributeDict objectForKey:@"id" ] intValue ];
        drop.Per = [ [ attributeDict objectForKey:@"per" ] intValue ];
        drop.Num = [ [ attributeDict objectForKey:@"num" ] intValue ];
        
        [ lastSubSceneMap.SPEnemy addObject:drop ];
    }
    
}



@end
