//
//  QuestData.m
//  sc
//
//  Created by fox on 13-10-15.
//
//

#import "QuestData.h"
#import "QuestConfig.h"
#import "PlayerData.h"
#import "InfoQuestUIHandler.h"
#import "InfoQuestReportUIHandler.h"
#import "GuideConfig.h"
#import "TalkUIHandler.h"
#import "ItemData.h"
#import "SceneData.h"
#import "PublicUIHandler.h"


@implementation QuestData
@synthesize Data;

QuestData* gQuestData = NULL;
+ ( QuestData* ) instance
{
    if ( !gQuestData )
    {
        gQuestData = [ [ QuestData alloc ] init ];
    }
    
    return gQuestData;
}


- ( void ) initData
{
    Data = [ [ NSMutableDictionary alloc ] init ];
}


- ( void ) clearData
{
    [ Data removeAllObjects ];
    [ Data release ];
    Data = NULL;
}


- ( int ) getQuest:( int )i
{
    if ( [ Data objectForKey:[ NSNumber numberWithInt:i ] ] )
    {
        return [ [ Data objectForKey:[ NSNumber numberWithInt:i ] ] intValue ];
    }
    
    return INVALID_ID;
}


- ( void ) setQuest:( int )i :( int )n
{
    [ Data setObject:[ NSNumber numberWithInt:n ] forKey:[ NSNumber numberWithInt:i ] ];
}


- ( void ) checkNewQuest
{
    NSMutableDictionary* dic = [ QuestConfig instance ].Dic;
    
    for ( int i = 0 ; i < dic.allKeys.count ; ++i )
    {
        int q = [ [ dic.allKeys objectAtIndex:i ] intValue ];
        QuestConfigData* questData = [ [ QuestConfig instance ] getQuest:q ];
        
        if ( [ Data objectForKey:[ NSNumber numberWithInt:questData.QuestID ] ] )
        {
            int n = [ [ Data objectForKey:[ NSNumber numberWithInt:questData.QuestID ] ] intValue ];
            
            if ( n == QDT_COMPLETE && questData.NextID )
            {
                if ( ![ Data objectForKey:[ NSNumber numberWithInt:questData.NextID ] ] )
                {
                    [ self setQuest:questData.NextID :QDT_ACTIVE ];
                }
            }
            
            continue;
        }
        
        if ( questData.StoryID && questData.StoryID <= [ PlayerData instance ].Story )
        {
            [ self setQuest:questData.QuestID :QDT_ACTIVE ];
        }
        
        if ( questData.WorkRank && questData.WorkRank <= [ PlayerData instance ].WorkRank )
        {
            [ self setQuest:questData.QuestID :QDT_ACTIVE ];
        }
    }
}


- ( BOOL ) checkQuestOver:( QuestConfigData* )quest
{
    int v = [ [ Data objectForKey:[ NSNumber numberWithInt:quest.QuestID ] ] intValue ];
    
    if ( v == QDT_COMPLETE )
    {
        return NO;
    }
    
    if ( quest.CGroundLV )
    {
        if ( quest.CGroundLV <= [ PlayerData instance ].WorkLevel[ WUT_GROUND ] &&
            quest.CShopLV <= [ PlayerData instance ].WorkLevel[ WUT_SHOP ] &&
            quest.CHomeLV <= [ PlayerData instance ].WorkLevel[ WUT_HOME ] &&
            quest.CWorkLV <= [ PlayerData instance ].WorkLevel[ WUT_WORK ] )
        {
            [ self setQuest:quest.QuestID :QDT_COMPLETE ];
            return YES;
        }
        
        return NO;
    }
    
    if ( quest.CKill0 || quest.CKill1 )
    {
        int n0 = [ [ PlayerData instance ] getMonsterData:quest.CKill0 ];
        
        int n1 = [ [ PlayerData instance ] getMonsterData:quest.CKill1 ];
        
        if ( n0 >= quest.CKillNum0 && n1 >= quest.CKillNum1 )
        {
            [ self setQuest:quest.QuestID :QDT_COMPLETE ];
            return YES;
        }
        
        return NO;
    }
    
    if ( quest.CItem0 || quest.CItem1 )
    {
        PackItemData* n0 =  [ [ ItemData instance ] getItem:quest.CItem0 ];
        
        PackItemData* n1 =  [ [ ItemData instance ] getItem:quest.CItem0 ];
        
        if ( n0.Number >= quest.CItemNum0 && n1.Number >= quest.CItemNum1 )
        {
            [ self setQuest:quest.QuestID :QDT_COMPLETE ];
            return YES;
        }
        
        return NO;
    }
    
    if ( quest.CSerch )
    {
        SceneDataItem* item = [ [ SceneData instance ] getSceneData:quest.CSerch ];
        
        if ( item && item.Per >= quest.CSerchPer )
        {
            [ self setQuest:quest.QuestID :QDT_COMPLETE ];
            return YES;
        }
        
        return NO;
    }
    
    if ( quest.CAlchemy )
    {
        PackItemData* item = [ [ ItemData instance ] getItem:quest.CAlchemy ];
        
        if ( !item.alchemyItem )
        {
            [ self setQuest:quest.QuestID :QDT_COMPLETE ];
            return YES;
        }
        
        return NO;
    }
    
    return NO;
}

- ( void ) questComplete:( QuestConfigData* )quest
{
    //@property( nonatomic ) int ComGold , ComItem0 , ComItem1 , ComItem2 , ComItem3;
   // @property( nonatomic ) int ComItemNum0 , ComItemNum1 , ComItemNum2 , ComItemNum3;
    
    [ [ PlayerData instance ] addGold:quest.ComGold ];
    
    if ( quest.ComItem0 )
       [ [ ItemData instance ] addItem:quest.ComItem0 :quest.ComItemNum0 ];
    if ( quest.ComItem1 )
        [ [ ItemData instance ] addItem:quest.ComItem1 :quest.ComItemNum1 ];
    if ( quest.ComItem2 )
        [ [ ItemData instance ] addItem:quest.ComItem2 :quest.ComItemNum2 ];
    if ( quest.ComItem3 )
        [ [ ItemData instance ] addItem:quest.ComItem3 :quest.ComItemNum3 ];
}

- ( void ) checkOverQuest
{
    NSMutableDictionary* dic = [ QuestConfig instance ].Dic;

    NSMutableArray* array = [ NSMutableArray array ];

    for ( int i = 0 ; i < dic.allKeys.count ; ++i )
    {
        int q = [ [ dic.allKeys objectAtIndex:i ] intValue ];
        
        QuestConfigData* questData = [ [ QuestConfig instance ] getQuest:q ];
        BOOL b = [ self checkQuestOver:questData ];
        
        if ( b )
        {
            [ array addObject:[ NSNumber numberWithInt:q ] ];
            [ self questComplete:questData ];
        }
    }
    
    if ( array.count )
    {
        [ [ InfoQuestReportUIHandler instance ] visible:YES ];
        [ [ InfoQuestReportUIHandler instance ] setData:array ];
        
        [ [ PublicUIHandler instance ] updateGold ];
    }
    
}


- ( void ) checkQuest
{
    [ self checkOverQuest ];
    [ self checkNewQuest ];
    
    if ( ![ [ InfoQuestReportUIHandler instance ] isOpened ] )
    {
        [ [ InfoQuestUIHandler instance ] visible:YES ];
    }
    
    GuideConfigData* data = [ [ GuideConfig instance ] getStoryData:[ PlayerData instance].Story ];
    
    if ( data )
    {
        if ( [ data.CheckScene isEqualToString:@"quest" ] )
        {
            [ [ TalkUIHandler instance ] visible:YES ];
            [ [ TalkUIHandler instance ] setData:data.GuideID ];
        }
    }

}


@end


