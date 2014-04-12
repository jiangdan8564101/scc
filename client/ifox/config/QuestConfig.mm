//
//  QuestConfig.m
//  sc
//
//  Created by fox on 13-10-15.
//
//

#import "QuestConfig.h"


@implementation QuestConfigData

@synthesize QuestID , NextID , StoryID , WorkRank , Rank , Img , Name , Owner , Time , Des , CDes;
@synthesize CSerchPer;
@synthesize CItem0 , CItem1 , CItemNum0 , CItemNum1 , CSerch , CAlchemy;
@synthesize CGold , CGroundLV , CShopLV , CHomeLV , CWorkLV;
@synthesize CKill0 , CKillNum0 , CKill1 , CKillNum1;
@synthesize ComGold , ComItem0 , ComItem1 , ComItem2 , ComItem3;
@synthesize ComItemNum0 , ComItemNum1 , ComItemNum2 , ComItemNum3;

@end


@implementation QuestConfig
@synthesize Dic;

QuestConfig* gQuestConfig = NULL;
+ ( QuestConfig* ) instance
{
    if ( !gQuestConfig )
    {
        gQuestConfig = [ [ QuestConfig alloc ] init ];
    }
    
    return gQuestConfig;
}


- ( QuestConfigData* ) getQuest:( int )d
{
    return [ Dic objectForKey:[ NSNumber numberWithInt:d ] ];
}


- ( void ) initConfig
{
    Dic = [ [ NSMutableDictionary alloc ] init ];
    
    NSData* data = loadXML( @"quest" );
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
    if ( [ elementName isEqualToString:@"q" ] )
    {
//        <q id="0" rank="0" name="" owner="" time="" des="" cdes="" ci0="" ci1="" cserch="" calchemy="" cgroundlv="" cgshoplv="" chomelv="" cworklv="" ckill0="" ckillnum0="" ckill1="" ckillnum1="" cgold="" comGold="" comi0="" comi1="" comi2=“” comi3="" />
        QuestConfigData* data = [ [ QuestConfigData alloc ] init ];
        
        data.Img = [ [ attributeDict objectForKey:@"img" ] copy ];
        data.Name = [ [ attributeDict objectForKey:@"name" ] copy ];
        data.Owner = [ [ attributeDict objectForKey:@"owner" ] copy ];
        data.Time = [ [ attributeDict objectForKey:@"time" ] copy ];
        data.Des = [ [ attributeDict objectForKey:@"des" ] copy ];
        data.CDes = [ [ attributeDict objectForKey:@"cdes" ] copy ];
        data.Rank = [ [ attributeDict objectForKey:@"rank" ] copy ];
        
        data.QuestID = [ [ attributeDict objectForKey:@"id" ] intValue ];
        data.NextID = [ [ attributeDict objectForKey:@"next" ] intValue ];
        data.StoryID = [ [ attributeDict objectForKey:@"story" ] intValue ];
        data.WorkRank = [ [ attributeDict objectForKey:@"workRank" ] intValue ];
        
        
        data.CItem0 = [ [ attributeDict objectForKey:@"ci0" ] intValue ];
        data.CItem1 = [ [ attributeDict objectForKey:@"ci1" ] intValue ];
        data.CItemNum0 = [ [ attributeDict objectForKey:@"cinum0" ] intValue ];
        data.CItemNum1 = [ [ attributeDict objectForKey:@"cinum1" ] intValue ];
        data.CSerch = [ [ attributeDict objectForKey:@"cserch" ] intValue ];
        data.CSerchPer = [ [ attributeDict objectForKey:@"cserchper" ] floatValue ];
        
        data.CAlchemy = [ [ attributeDict objectForKey:@"calchemy" ] intValue ];
        data.CGroundLV = [ [ attributeDict objectForKey:@"cgroundlv" ] intValue ];
        data.CHomeLV = [ [ attributeDict objectForKey:@"chomelv" ] intValue ];
        data.CShopLV = [ [ attributeDict objectForKey:@"cshoplv" ] intValue ];
        data.CWorkLV = [ [ attributeDict objectForKey:@"cworklv" ] intValue ];
        data.CKill0 = [ [ attributeDict objectForKey:@"ckill0" ] intValue ];
        data.CKill1 = [ [ attributeDict objectForKey:@"ckill1" ] intValue ];
        data.CKillNum0 = [ [ attributeDict objectForKey:@"ckillnum0" ] intValue ];
        data.CKillNum1 = [ [ attributeDict objectForKey:@"ckillnum1" ] intValue ];
        data.CGold = [ [ attributeDict objectForKey:@"cgold" ] intValue ];
        
        data.ComGold = [ [ attributeDict objectForKey:@"comGold" ] intValue ];
        data.ComItem0 = [ [ attributeDict objectForKey:@"comi0" ] intValue ];
        data.ComItem1 = [ [ attributeDict objectForKey:@"comi1" ] intValue ];
        data.ComItem2 = [ [ attributeDict objectForKey:@"comi2" ] intValue ];
        data.ComItem3 = [ [ attributeDict objectForKey:@"comi3" ] intValue ];
        data.ComItemNum0 = [ [ attributeDict objectForKey:@"cominum0" ] intValue ];
        data.ComItemNum1 = [ [ attributeDict objectForKey:@"cominum1" ] intValue ];
        data.ComItemNum2 = [ [ attributeDict objectForKey:@"cominum2" ] intValue ];
        data.ComItemNum3 = [ [ attributeDict objectForKey:@"cominum3" ] intValue ];
        
        
        [ Dic setObject:data forKey:[ NSNumber numberWithInt:data.QuestID ] ];
        [ data release ];
    }
    
}


@end
