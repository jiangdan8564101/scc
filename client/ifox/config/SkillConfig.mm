//
//  SkillConfig.m
//  sc
//
//  Created by fox on 13-9-3.
//
//

#import "SkillConfig.h"

@implementation SkillConfigData



@synthesize Name , Des1 , Des2 , Icon , Effect , SkillID ,
ProfessionID , Type , Trigger , TriggerEffect , MoveType , Attribute , Target , Power , SP ,  CP , Turn , MinDamage , AP , Hit , MonsterDamage;
@synthesize Power1 , Power2;

- ( void ) initSkillConfigData
{
    MonsterDamage = monsterDamage;
}

- ( void ) dealloc
{
    [ Des1 release ];
    Des1 = NULL;
    
    [ Des2 release ];
    Des2 = NULL;
    
    [ Name release ];
    Name = NULL;
    
    [ Icon release ];
    Icon = NULL;
    
    [ super dealloc ];
}

@end


@implementation SkillBuff

@synthesize Turn , SkillID , Target;
@synthesize Power , Power1 , Power2;

@end


@implementation SkillConfig

SkillConfig* gSkillConfig = NULL;
+ ( SkillConfig* ) instance
{
    if ( !gSkillConfig )
    {
        gSkillConfig = [ [ SkillConfig alloc ] init ];
    }
    
    return gSkillConfig;
}

- ( SkillConfigData* ) getSkill:( int )i
{
    return [ dic objectForKey:[ NSNumber numberWithInt:i ] ];
}

- ( void ) initConfig
{
    dic = [ [ NSMutableDictionary alloc ] init ];
    
    NSData* data = loadXML( @"skill" );
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
    
    if ( [ elementName isEqualToString:@"s" ] )
    {
        SkillConfigData* data = [ [ SkillConfigData alloc ] init ];
        [ data initSkillConfigData ];
        
        if ( ![ attributeDict objectForKey:@"name" ] )
        {
            assert( 0 );
        }
        if ( ![ attributeDict objectForKey:@"des1" ] )
        {
            assert( 0 );
        }
        if ( ![ attributeDict objectForKey:@"des2" ] )
        {
            assert( 0 );
        }
        if ( ![ attributeDict objectForKey:@"icon" ] )
        {
            assert( 0 );
        }
        
        data.Name = [ [ NSMutableString alloc ] initWithString:[ attributeDict objectForKey:@"name" ] ];
        data.Des1 = [ [ NSMutableString alloc ] initWithString:[ attributeDict objectForKey:@"des1" ] ];
        data.Des2 = [ [ NSMutableString alloc ] initWithString:[ attributeDict objectForKey:@"des2" ] ];
        if ( [ attributeDict objectForKey:@"des3" ] )
        {
            data.Des3 = [ [ NSMutableString alloc ] initWithString:[ attributeDict objectForKey:@"des3" ] ];
        }
        
        data.Icon = [ [ NSMutableString alloc ] initWithString:[ attributeDict objectForKey:@"icon" ] ];
        
        if ( [ attributeDict objectForKey:@"effect" ] )
        {
            data.Effect = [ [ NSMutableString alloc ] initWithString:[ attributeDict objectForKey:@"effect" ] ];
        }
        
        
        
        data.MinDamage = [ [ attributeDict objectForKey:@"minDamage" ] intValue ];
        data.Turn = [ [ attributeDict objectForKey:@"turn" ] intValue ];
        data.Trigger = [ [ attributeDict objectForKey:@"trigger" ] intValue ];
        data.TriggerEffect = [ [ attributeDict objectForKey:@"triggerEffect" ] intValue ];
        data.MoveType = [ [ attributeDict objectForKey:@"moveType" ] intValue ];
        data.ProfessionID = [ [ attributeDict objectForKey:@"pro" ] intValue ];
        data.Attribute = [ [ attributeDict objectForKey:@"attr" ] intValue ];
        data.Type = [ [ attributeDict objectForKey:@"type" ] intValue ];
        data.Target = [ [ attributeDict objectForKey:@"target" ] intValue ];
        data.SkillID = [ [ attributeDict objectForKey:@"id" ] intValue ];
        data.SP = [ [ attributeDict objectForKey:@"sp" ] intValue ];
        data.CP = [ [ attributeDict objectForKey:@"cp" ] intValue ];
        data.AP = [ [ attributeDict objectForKey:@"ap" ] intValue ];
        data.Dig = [ [ attributeDict objectForKey:@"dig" ] intValue ];
        
        data.Hit = [ [ attributeDict objectForKey:@"hit" ] floatValue ];
        data.Power = [ [ attributeDict objectForKey:@"power" ] floatValue ];
        data.Power1 = [ [ attributeDict objectForKey:@"power1" ] floatValue ];
        data.Power2 = [ [ attributeDict objectForKey:@"power2" ] floatValue ];
        
        data.MonsterDamage[ GCT_FLY ] = [ [ attributeDict objectForKey:@"cFly" ] floatValue ];
        data.MonsterDamage[ GCT_DRAGON ] = [ [ attributeDict objectForKey:@"cDragon" ] floatValue ];
        data.MonsterDamage[ GCT_DEAD ] = [ [ attributeDict objectForKey:@"cDead" ] floatValue ];
        data.MonsterDamage[ GCT_EARTH ] = [ [ attributeDict objectForKey:@"cEarth" ] floatValue ];
        data.MonsterDamage[ GCT_METAL ] = [ [ attributeDict objectForKey:@"cMetal" ] floatValue ];
        data.MonsterDamage[ GCT_ICE ] = [ [ attributeDict objectForKey:@"cIce" ] floatValue ];
        data.MonsterDamage[ GCT_FIRE ] = [ [ attributeDict objectForKey:@"cFire" ] floatValue ];
        data.MonsterDamage[ GCT_HOLY ] = [ [ attributeDict objectForKey:@"cHoly" ] floatValue ];
        data.MonsterDamage[ GCT_DARK ] = [ [ attributeDict objectForKey:@"cDark" ] floatValue ];
        data.MonsterDamage[ GCT_ELECTRICAL ] = [ [ attributeDict objectForKey:@"cElectrical" ] floatValue ];
        data.MonsterDamage[ GCT_WIND ] = [ [ attributeDict objectForKey:@"cWind" ] floatValue ];
        
        
        data.MonsterDamage[ GCT_HUMAN ] = [ [ attributeDict objectForKey:@"cHuman" ] floatValue ];
        data.MonsterDamage[ GCT_SPIRIT ] = [ [ attributeDict objectForKey:@"cSpirit" ] floatValue ];
        data.MonsterDamage[ GCT_ANGEL ] = [ [ attributeDict objectForKey:@"cAngel" ] floatValue ];
        data.MonsterDamage[ GCT_DEMON ] = [ [ attributeDict objectForKey:@"cDemon" ] floatValue ];
        data.MonsterDamage[ GCT_DEFENCER ] = [ [ attributeDict objectForKey:@"cDefencer" ] floatValue ];
        data.MonsterDamage[ GCT_OTHER ] = [ [ attributeDict objectForKey:@"cOther" ] floatValue ];
        
        [ dic setObject:data forKey:[ NSNumber numberWithInt:data.SkillID ] ];
        
        [ data release ];
    }
    
}

@end
