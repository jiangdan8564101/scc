//
//  InfoMonsterUIHandler.m
//  sc
//
//  Created by fox on 13-12-31.
//
//

#import "InfoMonsterUIHandler.h"
#import "CreatureConfig.h"
#import "SceneData.h"
#import "SkillConfig.h"
#import "MapConfig.h"
#import "ItemConfig.h"

@implementation InfoMonsterUIHandler




static InfoMonsterUIHandler* gInfoMonsterUIHandler;
+ (InfoMonsterUIHandler*) instance
{
    if ( !gInfoMonsterUIHandler )
    {
        gInfoMonsterUIHandler = [ [ InfoMonsterUIHandler alloc] init ];
        [ gInfoMonsterUIHandler initUIHandler:@"InfoMonsterView" isAlways:YES isSingle:NO ];
    }
    
    return gInfoMonsterUIHandler;
}




- ( void ) onInited
{
    [ super onInited ];
    
    UIButton* button = (UIButton*)[ view viewWithTag:2200 ];
    [ button addTarget:self action:@selector(onCloseClick) forControlEvents:UIControlEventTouchUpInside ];
    
    scrollView = (InfoMonsterScrollView*)[ view viewWithTag:2000 ];
    scrollView.delegate = self;
    pageLabel = ( UILabel* )[ view viewWithTag:2001 ];
    [ scrollView initFastScrollView:[ uiArray objectAtIndex:1 ] :self :@selector( onMonsterClick: ) ];
    
    creatureAction = (UICreatureAction*)[ view viewWithTag:1050 ];
    centerPoint = creatureAction.center;
}


- ( void ) onOpened
{
    [ super onOpened ];
    
    [ self updateMonsterList ];
}


- ( void ) onClosed
{
    [ super onClosed ];
}


- ( void ) onCloseClick
{
    [ self visible:NO ];
    
    playSound( PST_CANCEL );
}

-( NSArray* ) getSortKeys1:( NSDictionary* )dic
{
    return [ dic.allValues sortedArrayUsingComparator:^(CreatureCommonData* obj1, CreatureCommonData* obj2)
            {
                if ( obj1.EnemyIndex > obj2.EnemyIndex )
                {
                    return (NSComparisonResult)NSOrderedDescending;
                }
                
                if ( obj1.EnemyIndex < obj2.EnemyIndex )
                {
                    return (NSComparisonResult)NSOrderedAscending;
                }
                
                return (NSComparisonResult)NSOrderedSame;
            }];
}

- ( void ) updateMonsterList
{
    if ( !view )
    {
        return;
    }
    
    [ scrollView clear ];
    
    NSDictionary* dic = [ CreatureConfig instance ].EnemyDic;
    NSArray* array = [ self getSortKeys1:dic ];
    
    
    for ( int i = 0 ; i < array.count ; ++i )
    {
        CreatureCommonData* comm = [ array objectAtIndex:i ];
        
        [ scrollView addItem:[ NSNumber numberWithInt:comm.ID ] ];
    }
    
    [ scrollView updateContentSize ];
    [ scrollView setNeedsLayout ];
    
    int count = [ scrollView getPageCount ];
    [ pageLabel setText:[ NSString stringWithFormat:@"%d/%d" , 1 , count ] ];
    [ pageLabel setHidden:!count ];

    
    [ self updateSelectMonster ];
}


- ( void ) onMonsterClick:( InfoMonsterItem* )item
{
    if ( selectMonster == item )
    {
        return;
    }
    
    selectMonster = item;
    
    [ self updateSelectMonster ];
}


- ( void ) scrollViewDidEndDecelerating:( UIScrollView* )sv
{
    int index = fabs( sv.contentOffset.x ) / sv.frame.size.width;
    
    [ pageLabel setText:[ NSString stringWithFormat:@"%d/%d" , index + 1 , [ scrollView getPageCount ] ] ];
    
}


- ( void ) updateSelectMonster
{
    if ( !selectMonster )
    {
        return;
    }
    
    CreatureCommonData* comm = [ [ CreatureConfig instance ] getCommonData:selectMonster.CreautreID ];
    
    BOOL bb = [ [ SceneData instance ] getEnemy:comm.ID ];
    
    if ( !bb )
    {
        return;
    }
    
    UILabel* label = (UILabel*)[ view viewWithTag:1000 ];
    [ label setText:comm.Name ];

    NSString* str2 = [ NSString stringWithFormat:@"type%d" , comm.Type ];
    NSString* str22 = NSLocalizedString( str2 , nil );
    label = (UILabel*)[ view viewWithTag:1001 ];
    [ label setText:str22 ];
    
    
    label = (UILabel*)[ view viewWithTag:1002 ];
    [ label setText:[ NSString stringWithFormat:@"%d" , (int)comm.BaseData.MaxHP ] ];
    
    label = (UILabel*)[ view viewWithTag:1003 ];
    [ label setText:[ NSString stringWithFormat:@"%d" , (int)comm.Level ] ];
    
    label = (UILabel*)[ view viewWithTag:1004 ];
    [ label setText:[ NSString stringWithFormat:@"%d" , (int)(comm.BaseData.Hit * 100.0f) ] ];
    label = (UILabel*)[ view viewWithTag:1005 ];
    [ label setText:[ NSString stringWithFormat:@"%d" , (int)comm.BaseData.PAtk ] ];
    label = (UILabel*)[ view viewWithTag:1006 ];
    [ label setText:[ NSString stringWithFormat:@"%d" , (int)comm.BaseData.MAtk ] ];
    label = (UILabel*)[ view viewWithTag:1007 ];
    [ label setText:[ NSString stringWithFormat:@"%d" , (int)comm.BaseData.Agile ] ];
    label = (UILabel*)[ view viewWithTag:1008 ];
    [ label setText:[ NSString stringWithFormat:@"%d" , (int)comm.BaseData.Lucky ] ];
    label = (UILabel*)[ view viewWithTag:1009 ];
    [ label setText:[ NSString stringWithFormat:@"%d" , (int)comm.BaseData.Critical ] ];
    label = (UILabel*)[ view viewWithTag:1010 ];
    [ label setText:[ NSString stringWithFormat:@"%d" , (int)comm.BaseData.MaxSP ] ];
    label = (UILabel*)[ view viewWithTag:1011 ];
    [ label setText:[ NSString stringWithFormat:@"%d" , (int)comm.EXP ] ];
    label = (UILabel*)[ view viewWithTag:1012 ];
    [ label setText:[ NSString stringWithFormat:@"%d" , (int)(comm.BaseData.Miss * 100.0f) ] ];
    label = (UILabel*)[ view viewWithTag:1013 ];
    [ label setText:[ NSString stringWithFormat:@"%d" , (int)comm.BaseData.PDef ] ];
    label = (UILabel*)[ view viewWithTag:1014 ];
    [ label setText:[ NSString stringWithFormat:@"%d" , (int)comm.BaseData.MDef ] ];
    label = (UILabel*)[ view viewWithTag:1015 ];
    [ label setText:[ NSString stringWithFormat:@"%d" , (int)comm.BaseData.Move ] ];
    label = (UILabel*)[ view viewWithTag:1016 ];
    [ label setText:[ NSString stringWithFormat:@"%d" , (int)comm.BaseData.MaxCP ] ];
    label = (UILabel*)[ view viewWithTag:1017 ];
    [ label setText:[ NSString stringWithFormat:@"%d" , (int)comm.BaseData.Command ] ];
    label = (UILabel*)[ view viewWithTag:1018 ];
    [ label setText:[ NSString stringWithFormat:@"%d" , (int)comm.BaseData.MaxFS ] ];
    
    
    for ( int i = 0 ; i < GCA_COUNT - 1 ; ++i )
    {
        label = (UILabel*)[ view viewWithTag:1020 + i ];
        
        NSString* str = [ NSString stringWithFormat:@"%0.1f%%" , comm.RealAttrDefence[ i ] * 100.0f ];
        //NSString* str1 = NSLocalizedString( str , nil );
        [ label setText:str ];
    }
    
    UITextView* textView = (UITextView*)[ view viewWithTag:1030 ];
    NSMutableString* textViewStr = [ NSMutableString string ];
    for ( int i = 0 ; i < comm.Skill.count ; ++i )
    {
        int skillID = [ [ comm.Skill.allKeys objectAtIndex:i ] intValue ];
        SkillConfigData* data1 = [ [ SkillConfig instance ] getSkill:skillID ];
        
        [ textViewStr appendString:data1.Name ];
        [ textViewStr appendString:@"\n" ];
    }
    [ textView setText:textViewStr ];
    
    textView = (UITextView*)[ view viewWithTag:1032 ];
    textViewStr = [ NSMutableString string ];
    for ( int i = 0 ; i < comm.Zone.count ; ++i )
    {
        int map1 = [ [ comm.Zone objectAtIndex:i ] intValue ];
        SubSceneMap* sub = [ [ MapConfig instance ] getSubSceneMap:map1 ];
        
        [ textViewStr appendString:sub.Name ];
        [ textViewStr appendString: ( i % 2 == 1 ) ? @"\t\t" : @"\n" ];
    }
    [ textView setText:textViewStr ];
    
    textView = (UITextView*)[ view viewWithTag:1033 ];
    textViewStr = [ NSMutableString string ];
    for ( int i = 0 ; i < comm.Drop.count ; ++i )
    {
        CreatureBaseIDPerNum* map1 = [ comm.Drop objectAtIndex:i ];
        ItemConfigData* data1 = [ [ ItemConfig instance ] getData:map1.ID ];
        
        [ textViewStr appendString:data1.AutoSell ? @"" : data1.Name ];
        
        [ textViewStr appendString: ( i % 2 == 1 ) ? @"\t\t\t" : @"\n" ];
    }
    [ textView setText:textViewStr ];
    
    
    
    [ creatureAction releaseCreatureActionView ];
    
    [ creatureAction initCreatureActionView:[ NSString stringWithFormat:@"CP%@" , comm.Action ] ];
    [ creatureAction setPos:centerPoint ];
    [ creatureAction setAction:CAT_STAND :0 ];
    
    
    textView = (UITextView*)[ view viewWithTag:1031 ];
    [ textView setText:comm.Des ];
    
//    NSString* str = [ NSString stringWithFormat:@"CS%@AA" , comm.Action ];
//    NSString* path = [ [ NSBundle mainBundle ] pathForResource:str ofType:@"png" inDirectory:CREATURE_PATH ];
//    UIImage* image = [ UIImage imageWithContentsOfFile:path ];
//    
//    CGSize sz = image.size;
//    [ imageView setImage:image ];
//    CGRect rect = imageView.frame;
//    rect.size = sz;
//    
//    
//    CGPoint point = centerPoint;
//    if ( comm.ImageOffsetX )
//    {
//        point.x += comm.ImageOffsetX;
//    }
//    else
//    {
//        point.x += -sz.width * 0.5f;
//    }
//    
//    if ( comm.ImageOffsetY )
//    {
//        point.y += comm.ImageOffsetY;
//    }
//    else
//    {
//        point.y += -sz.height;
//    }
//    
//    rect.origin = point;
//    
//    [ imageView setFrame:rect ];
}




@end
