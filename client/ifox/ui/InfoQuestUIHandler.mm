//
//  InfoQuestUIHandler.m
//  sc
//
//  Created by fox on 13-12-5.
//
//

#import "InfoQuestUIHandler.h"
#import "QuestConfig.h"
#import "ItemConfig.h"
#import "QuestData.h"

@implementation InfoQuestUIHandler



static InfoQuestUIHandler* gInfoQuestUIHandler;
+ (InfoQuestUIHandler*) instance
{
    if ( !gInfoQuestUIHandler )
    {
        gInfoQuestUIHandler = [ [ InfoQuestUIHandler alloc] init ];
        [ gInfoQuestUIHandler initUIHandler:@"InfoQuestView" isAlways:YES isSingle:NO ];
    }
    
    return gInfoQuestUIHandler;
}


- ( void ) onInited
{
    [ super onInited ];
    
    UIButton* button = (UIButton*)[ view viewWithTag:2200 ];
    [ button addTarget:self action:@selector(onCloseClick) forControlEvents:UIControlEventTouchUpInside ];
    
    scrollView = (InfoQuestScrollView*)[ view viewWithTag:2000 ];
    scrollView.delegate = self;
    pageLabel = ( UILabel* )[ view viewWithTag:2001 ];
    [ scrollView initFastScrollView:[ uiArray objectAtIndex:1 ] :self :@selector( onQuestClick: ) ];
}


- ( void ) onOpened
{
    [ super onOpened ];
    
    [ self updateQuestList ];
}


- ( void ) onClosed
{
    [ super onClosed ];
    
    selectQuest = NULL;
}


- ( void ) onCloseClick
{
    [ self visible:NO ];
    
    playSound( PST_CANCEL );
}


- ( void ) updateQuestList
{
    if ( !view )
    {
        return;
    }
    
    [ scrollView clear ];
    
    NSMutableDictionary* dic = [ QuestData instance ].Data;
    
    NSArray* allkeys = [ dic allKeys ];
    
    for ( fint32 i = 0 ; i < allkeys.count ; ++i )
    {
        int questID = [ [ allkeys objectAtIndex:i ] intValue ];
        QuestConfigData* data = [ [ QuestConfig instance ] getQuest:questID ];
        
        [ scrollView addItem:data ];
    }
    
    [ scrollView updateContentSize ];
    [ scrollView setNeedsLayout ];
    
    int count = [ scrollView getPageCount ];
    [ pageLabel setText:[ NSString stringWithFormat:@"%d/%d" , 1 , count ] ];
    [ pageLabel setHidden:!count ];
    
    
    [ self updateSelectQuest ];
}


- ( void ) onQuestClick:( InfoQuestItem* )item
{
    if ( !item )
    {
        return;
    }
    
    if ( selectQuest == item )
    {
        return;
    }
    
    selectQuest = item;
    
    [ self updateSelectQuest ];
}


- ( void ) scrollViewDidEndDecelerating:( UIScrollView* )sv
{
    int index = fabs( sv.contentOffset.x ) / sv.frame.size.width;
    
    [ pageLabel setText:[ NSString stringWithFormat:@"%d/%d" , index + 1 , [ scrollView getPageCount ] ] ];
}


- ( void ) updateSelectQuest
{
    if ( !selectQuest )
    {
        return;
    }
    
    QuestConfigData* data = [ [ QuestConfig instance ] getQuest:selectQuest.QuestID ];
    
    UILabel* label = (UILabel*)[ view viewWithTag:1000 ];
    [ label setText:[ NSString stringWithFormat:@"%d" , data.QuestID ] ];
    label = (UILabel*)[ view viewWithTag:1001 ];
    [ label setText:data.Rank ];
    label = (UILabel*)[ view viewWithTag:1002 ];
    [ label setText:data.Name ];
    label = (UILabel*)[ view viewWithTag:1003 ];
    [ label setText:data.Owner ];
    label = (UILabel*)[ view viewWithTag:1004 ];
    [ label setText:data.Time ];
    
    UITextView* textView = (UITextView*)[ view viewWithTag:1005 ];
    [ textView setText:data.Des ];
    
    textView = (UITextView*)[ view viewWithTag:1006 ];
    [ textView setText:data.CDes ];
    
    NSString* str = [ NSString localizedStringWithFormat:NSLocalizedString( @"QuestGold" , nil )  , (int)data.ComGold ];
    label = (UILabel*)[ view viewWithTag:1007 ];
    [ label setText:str ];
    
    label = (UILabel*)[ view viewWithTag:1008 ];
    if ( data.ComItem0 )
    {
        ItemConfigData* item = [ [ ItemConfig instance ] getData:data.ComItem0 ];
        
        str = [ NSString localizedStringWithFormat:NSLocalizedString( @"QuestItem" , nil )  , item.Name , (int)data.ComItemNum0 ];
        [ label setText:str ];
    }
    else
    {
        [ label setText:@"" ];
    }
    
    label = (UILabel*)[ view viewWithTag:1009 ];
    if ( data.ComItem1 )
    {
        ItemConfigData* item = [ [ ItemConfig instance ] getData:data.ComItem1 ];
        
        str = [ NSString localizedStringWithFormat:NSLocalizedString( @"QuestItem" , nil )  , item.Name , (int)data.ComItemNum1 ];
        
        [ label setText:str ];
    }
    else
    {
        [ label setText:@"" ];
    }
    
    label = (UILabel*)[ view viewWithTag:1010 ];
    if ( data.ComItem2 )
    {
        ItemConfigData* item = [ [ ItemConfig instance ] getData:data.ComItem2 ];
        
        str = [ NSString localizedStringWithFormat:NSLocalizedString( @"QuestItem" , nil )  , item.Name , (int)data.ComItemNum2 ];
        
        [ label setText:str ];
    }
    else
    {
        [ label setText:@"" ];
    }
    
    label = (UILabel*)[ view viewWithTag:1011 ];
    if ( data.ComItem3 )
    {
        ItemConfigData* item = [ [ ItemConfig instance ] getData:data.ComItem3 ];
        
        str = [ NSString localizedStringWithFormat:NSLocalizedString( @"QuestItem" , nil )  , item.Name , (int)data.ComItemNum3 ];
        
        [ label setText:str ];
    }
    else
    {
        [ label setText:@"" ];
    }
    
}

@end
