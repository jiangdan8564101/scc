//
//  ProfessionConfig.m
//  sc
//
//  Created by fox on 13-9-3.
//
//

#import "ProfessionConfig.h"
#import "SkillConfig.h"


@implementation ProfessionSkillData
@synthesize Active;
@synthesize SkillID;
@synthesize AP;

- ( BOOL )isLearned
{
    SkillConfigData* data = [ [ SkillConfig instance ] getSkill:SkillID ];
    
    return AP >= data.AP;
}

- (id)copyWithZone:(NSZone *)zone
{
    ProfessionSkillData *copy = [ [ self class] allocWithZone: zone ];
    
    copy.Active = Active;
    copy.SkillID = SkillID;
    copy.AP = AP;
    
    return copy;
}

@end


@implementation ProfessionLevelData
@synthesize Level , Time , ID;
- (id)copyWithZone:(NSZone *)zone
{
    ProfessionLevelData *copy = [ [ self class] allocWithZone: zone ];
    
    copy.Level = Level;
    copy.Time = Time;
    copy.ID = ID;
    
    return copy;
}

@end

@implementation ProfessionConfigData

@synthesize LevelTime , Conditions;
@synthesize ID , Type , WeaponType , ArmorType;
@synthesize Name , Des , Img , Effect;

- ( int ) getLevelTime:( int )l
{
    if ( LevelTime.count > l - 1 )
    {
        return [ [ LevelTime objectAtIndex:l - 1 ] intValue ];
    }
    
    return 0;
}

- ( void )dealloc
{
    [ Name release ];
    Name = NULL;
    
    [ Des release ];
    Des = NULL;
    
    [ super dealloc ];
}

@end


@implementation ProfessionConfig

@synthesize Dic , WDic;

ProfessionConfig* gProfessionConfig = NULL;
+ ( ProfessionConfig* ) instance
{
    if ( !gProfessionConfig )
    {
        gProfessionConfig = [ [ ProfessionConfig alloc ] init ];
    }
    
    return gProfessionConfig;
}


- ( void ) initConfig
{
    Dic = [ [ NSMutableDictionary alloc ] init ];
    WDic = [ [ NSMutableDictionary alloc ] init ];
    
    NSData* data = loadXML( @"profession" );
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
    
    [ WDic removeAllObjects ];
    [ WDic release ];
    WDic = NULL;
}


-( ProfessionConfigData* ) getProfessionConfig:( int )t
{
    return [ Dic objectForKey:[ NSNumber numberWithInt:t ] ];
}


-( NSMutableArray* ) getWeaponProfessionConfig:( int )t
{
    return [ WDic objectForKey:[ NSNumber numberWithInt:t ] ];
}


-( void )parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    static ProfessionConfigData* lastData = NULL;
    
    if ( [ elementName isEqualToString:@"p" ] )
    {
        ProfessionConfigData* data = [ [ ProfessionConfigData alloc ] init ];
        
        data.Img = [ [ NSMutableString alloc ] initWithString:[ attributeDict objectForKey:@"img" ] ];
        data.ID = [ [ attributeDict objectForKey:@"id" ] intValue ];
        data.Type = [ [ attributeDict objectForKey:@"type" ] intValue ];
        data.WeaponType = [ [ attributeDict objectForKey:@"wt" ] intValue ];
        data.Name = [ [ NSMutableString alloc ] initWithString:[ attributeDict objectForKey:@"name" ] ];
        data.Des = [ [ NSMutableString alloc ] initWithString:[ attributeDict objectForKey:@"des" ] ];
        
        if ( [ attributeDict objectForKey:@"effect" ] )
        {
            data.Effect = [ [ NSMutableString alloc ] initWithString:[ attributeDict objectForKey:@"effect" ] ];
        }
        
        
        lastData = data;
        
        if ( ![ WDic objectForKey:[ NSNumber numberWithInt:data.WeaponType ] ] )
        {
            [ WDic setObject:[ NSMutableArray array ] forKey:[ NSNumber numberWithInt:data.WeaponType ] ];
        }
        
        lastData.LevelTime = [ [ NSMutableArray alloc ] init ];
        
        //lastData.Skills = [ [ NSMutableArray alloc ] init ];
        lastData.Conditions = [ [ NSMutableDictionary alloc ] init ];
        
        [ Dic setObject:data forKey:[ NSNumber numberWithInt:data.ID ] ];
        
        NSMutableArray* array = [ WDic objectForKey:[ NSNumber numberWithInt:data.WeaponType ] ];
        [ array addObject:data ];
        
        [ data release ];
        
        return;
    }
    
    if ( [ elementName isEqualToString:@"l" ] )
    {
        [ lastData.LevelTime addObject:[ NSNumber numberWithInt:[ [ attributeDict objectForKey:@"t" ] intValue ] ] ];
        
        return;
    }
    
    
    if ( [ elementName isEqualToString:@"need" ] )
    {
        int lv = [ [ attributeDict objectForKey:@"lv" ] intValue ];
        int ii = [ [ attributeDict objectForKey:@"id" ] intValue ];
        
        [ lastData.Conditions setObject:[ NSNumber numberWithInt:lv ] forKey:[ NSNumber numberWithInt:ii ] ];
        
        return;
    }

    
//    if ( [ elementName isEqualToString:@"s" ] )
//    {
//        ProfessionSkillData* data = [ [ ProfessionSkillData alloc ] init ];
//        
//        data.ProType = lastData.Type;
//        
//        data.SkillID = [ [ attributeDict objectForKey:@"s" ] intValue ];
//        data.MaxEXP = [ [ attributeDict objectForKey:@"m" ] intValue ];
//        
//        [ lastData.Skills addObject:data ];
//        
//        [ data release ];
//        
//        return;
//    }
    
}

@end
