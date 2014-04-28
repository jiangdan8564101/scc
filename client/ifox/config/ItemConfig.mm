//
//  ItemConfig.m
//  sc
//
//  Created by fox on 13-7-14.
//
//

#import "ItemConfig.h"


@implementation ItemConfigData

@synthesize HP , MaxHP , SP , MaxSP , FS , MaxFS , PAtk , PDef , MAtk , MDef , Agile , Lucky , Hit , Miss , Critical , Move , CP , Guest , Command;

@synthesize Effect , EffectType;
@synthesize GrowID , GrowDay;
@synthesize MainAttrType , MainAttr;
@synthesize MonsterDamage , AttrDefence;
@synthesize ID , Type , Type2 , AutoSell , WeaponType , ArmorType , Img , Name , Des1 , Des2 , Skill , Sell , Buy , PutPosition;
@synthesize Key , Rank;
@synthesize ProLevel;


- ( void ) initItemConfigData
{
    MonsterDamage = monsterDamage;
    AttrDefence = attrDefence;
}

- ( void )dealloc
{
    [ Img release ];
    Img = NULL;
    
    [ Name release ];
    Name = NULL;
    
    [ Des1 release ];
    Des1 = NULL;
    
    [ Des2 release ];
    Des2 = NULL;
    
    [ Skill release ];
    Skill = NULL;
    
    [ super dealloc ];
}
@end





@implementation ItemConfig
@synthesize ItemDic;

ItemConfig* gItemConfig = NULL;
+ ( ItemConfig* ) instance
{
    if ( !gItemConfig )
    {
        gItemConfig = [ [ ItemConfig alloc ] init ];
    }
    
    return gItemConfig;
}


- ( void ) initConfig
{
    ItemDic = [ [ NSMutableDictionary alloc ] init ];
    
    
    NSData* data = loadXML( @"item" );
    NSXMLParser* parser = [ [ NSXMLParser alloc] initWithData:data ];
    [ parser setDelegate:self ];
    [ parser parse ];
    [ parser release ];
}


- ( void ) releaseConfig
{
    [ ItemDic removeAllObjects ];
    [ ItemDic release ];
    ItemDic = NULL;
}


- ( ItemConfigData* ) getData:( int )i
{
    return [ ItemDic objectForKey:[ NSNumber numberWithInt:i ] ];
}


-( void )parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    
    if ( [ elementName isEqualToString:@"i" ] )
    {
        ItemConfigData* commonData = [ [ ItemConfigData alloc ] init ];
        [ commonData initItemConfigData ];
        
        commonData.Skill = [ [ NSMutableArray alloc ] init ];
        
        if ( [ [ attributeDict objectForKey:@"s0" ] intValue ] )
        {
            [ commonData.Skill addObject:[ attributeDict objectForKey:@"s0" ] ];
        }
        if ( [ [ attributeDict objectForKey:@"s1" ] intValue ] )
        {
            [ commonData.Skill addObject:[ attributeDict objectForKey:@"s1" ] ];
        }
        if ( [ [ attributeDict objectForKey:@"s2" ] intValue ] )
        {
            [ commonData.Skill addObject:[ attributeDict objectForKey:@"s2" ] ];
        }
        
        commonData.ID = [ [ attributeDict objectForKey:@"id" ] intValue ];
        commonData.Img = [ [ NSMutableString alloc ] initWithString:[ attributeDict objectForKey:@"img" ] ];
        commonData.Name = [ [ NSMutableString alloc ] initWithString:[ attributeDict objectForKey:@"name" ] ];
        commonData.Des1 = [ [ NSMutableString alloc ] initWithString:[ attributeDict objectForKey:@"des1" ] ];
        //commonData.Des2 = [ [ NSMutableString alloc ] initWithString:[ attributeDict objectForKey:@"des2" ] ];
        
        commonData.ProLevel = [ [ attributeDict objectForKey:@"level" ] intValue ];

        commonData.Sell = [ [ attributeDict objectForKey:@"sell" ] intValue ];
        commonData.Buy = [ [ attributeDict objectForKey:@"buy" ] intValue ];
        
        commonData.Key = [ [ attributeDict objectForKey:@"key" ] intValue ];
        commonData.Rank = [ [ attributeDict objectForKey:@"rank" ] intValue ];
        commonData.Quality = [ [ attributeDict objectForKey:@"quality" ] intValue ];
        
        commonData.PutPosition = [ [ attributeDict objectForKey:@"putPosition" ] intValue ];
        
        commonData.EffectType = [ [ attributeDict objectForKey:@"effectType" ] intValue ];
        commonData.Effect = [ [ attributeDict objectForKey:@"effect" ] floatValue ];
        
        commonData.GrowID = [ [ attributeDict objectForKey:@"growID" ] intValue ];
        commonData.GrowDay = [ [ attributeDict objectForKey:@"growDay" ] floatValue ];
        
        commonData.Type = [ [ attributeDict objectForKey:@"type" ] intValue ];
        commonData.Type2 = [ [ attributeDict objectForKey:@"type2" ] intValue ];
        
        commonData.WeaponType = [ [ attributeDict objectForKey:@"wt" ] intValue ];
        commonData.ArmorType = [ [ attributeDict objectForKey:@"at" ] intValue ];
        
        commonData.MaxHP = [ [ attributeDict objectForKey:@"maxHP" ] floatValue ];
        commonData.HP = [ [ attributeDict objectForKey:@"hp" ] floatValue ];
        commonData.MaxSP = [ [ attributeDict objectForKey:@"maxSP" ] floatValue ];
        commonData.SP = [ [ attributeDict objectForKey:@"sp" ] floatValue ];
        commonData.MaxFS = [ [ attributeDict objectForKey:@"maxFS" ] floatValue ];
        commonData.FS = [ [ attributeDict objectForKey:@"fs" ] floatValue ];
        commonData.PAtk = [ [ attributeDict objectForKey:@"pAtk" ] floatValue ];
        commonData.PDef = [ [ attributeDict objectForKey:@"pDef" ] floatValue ];
        commonData.MAtk = [ [ attributeDict objectForKey:@"mAtk" ] floatValue ];
        commonData.MDef = [ [ attributeDict objectForKey:@"mDef" ] floatValue ];
        commonData.Agile = [ [ attributeDict objectForKey:@"agile" ] floatValue ];
        commonData.Lucky = [ [ attributeDict objectForKey:@"lucky" ] floatValue ];
        commonData.Hit = [ [ attributeDict objectForKey:@"hit" ] floatValue ];
        commonData.Miss = [ [ attributeDict objectForKey:@"miss" ] floatValue ];
        commonData.Critical = [ [ attributeDict objectForKey:@"critical" ] floatValue ];
        commonData.Move = [ [ attributeDict objectForKey:@"move" ] floatValue ];
        commonData.CP = [ [ attributeDict objectForKey:@"cp" ] floatValue ];
        commonData.Guest = [ [ attributeDict objectForKey:@"guest" ] floatValue ];
        commonData.AutoSell = [ [ attributeDict objectForKey:@"autoSell" ] floatValue ];
        
        commonData.MainAttrType = [ [ attributeDict objectForKey:@"mainP" ] floatValue ];
        commonData.MainAttr = [ [ attributeDict objectForKey:@"main" ] intValue ];
        
        commonData.MonsterDamage[ GCT_FLY ] = [ [ attributeDict objectForKey:@"bFly" ] floatValue ];
        commonData.MonsterDamage[ GCT_DEAD ] = [ [ attributeDict objectForKey:@"bDead" ] floatValue ];
        commonData.MonsterDamage[ GCT_DRAGON ] = [ [ attributeDict objectForKey:@"bDragon" ] floatValue ];
        commonData.MonsterDamage[ GCT_EARTH ] = [ [ attributeDict objectForKey:@"bEarth" ] floatValue ];
        commonData.MonsterDamage[ GCT_METAL ] = [ [ attributeDict objectForKey:@"bMetal" ] floatValue ];
        
        commonData.AttrDefence[ GCA_PHYSICAL ] = [ [ attributeDict objectForKey:@"aP" ] floatValue ];
        commonData.AttrDefence[ GCA_EARTH ] = [ [ attributeDict objectForKey:@"aE" ] floatValue ];
        commonData.AttrDefence[ GCA_ICE ] = [ [ attributeDict objectForKey:@"aI" ] floatValue ];
        commonData.AttrDefence[ GCA_FIRE ] = [ [ attributeDict objectForKey:@"aF" ] floatValue ];
        commonData.AttrDefence[ GCA_ELECTRICAL ] = [ [ attributeDict objectForKey:@"aEl" ] floatValue ];
        commonData.AttrDefence[ GCA_HOLY ] = [ [ attributeDict objectForKey:@"aH" ] floatValue ];
        commonData.AttrDefence[ GCA_DARK ] = [ [ attributeDict objectForKey:@"aD" ] floatValue ];
        commonData.AttrDefence[ GCA_NULL ] = [ [ attributeDict objectForKey:@"aN" ] floatValue ];
        
        [ ItemDic setObject:commonData forKey:[ NSNumber numberWithInt:commonData.ID ] ];
        
        [ commonData release ];
    }
    
}



@end
