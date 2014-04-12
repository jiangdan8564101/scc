//
//  InfoQuestReportUIHandler.m
//  sc
//
//  Created by fox on 13-12-6.
//
//

#import "InfoQuestReportUIHandler.h"
#import "QuestConfig.h"
#import "InfoQuestUIHandler.h"
#import "QuestData.h"

@implementation InfoQuestReportUIHandler

static InfoQuestReportUIHandler* gInfoQuestReportUIHandler;
+ (InfoQuestReportUIHandler*) instance
{
    if ( !gInfoQuestReportUIHandler )
    {
        gInfoQuestReportUIHandler = [ [ InfoQuestReportUIHandler alloc] init ];
        [ gInfoQuestReportUIHandler initUIHandler:@"InfoQuestReportView" isAlways:YES isSingle:NO ];
    }
    
    return gInfoQuestReportUIHandler;
}



- ( void ) clear
{
    for ( int i = 0 ; i < array.count ; i++ )
    {
        [ [ array objectAtIndex:i ] removeFromSuperview ];
    }
    [ array removeAllObjects ];
    dataCount = 0;
}


- ( void ) onInited
{
    [ super onInited ];
    
    UIButton* button = (UIButton*)[ view viewWithTag:1001 ];
    [ button addTarget:self action:@selector(onCloseClick) forControlEvents:UIControlEventTouchUpInside ];
    
    array = [ [ NSMutableArray alloc ] init ];
}


- ( void ) setData:( NSArray* )a
{
    [ self clear ];
    
    UIScrollView* scrollView = (UIScrollView*)[ view viewWithTag:1000 ];
    UIView* itemView = [ uiArray objectAtIndex:1 ];
    
    for ( int i = 0 ; i < a.count ; ++i )
    {
        UIView* item =  [ NSKeyedUnarchiver unarchiveObjectWithData:
                         [ NSKeyedArchiver archivedDataWithRootObject:itemView ] ];
        
        QuestConfigData* data = [ [ QuestConfig instance ] getQuest:[ [ a objectAtIndex:i ] intValue ] ];
        UILabel* label = (UILabel*)[ item viewWithTag:100 ];
        [ label setText:data.Name ];
        
        CGPoint p = CGPointMake( item.frame.size.width * 0.5f , item.frame.size.height * 0.5f + item.frame.size.height * i );
        
        [ item setCenter:p ];
        
        [ scrollView addSubview:item ];
        
        dataCount++;
    }
    
    playSound( PST_ALCHEMY );
}

- ( void ) onCloseClick
{
    [ self visible:NO ];
    [ [ InfoQuestUIHandler instance ] visible:YES ];
    
    //playSound( PST_CANCEL );
}

@end
