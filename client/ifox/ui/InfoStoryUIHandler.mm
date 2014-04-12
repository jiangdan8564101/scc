//
//  InfoStoryUIHandler.m
//  sc
//
//  Created by fox on 13-12-29.
//
//

#import "InfoStoryUIHandler.h"
#import "StoryConfig.h"
#import "PlayerData.h"



@implementation InfoStoryUIHandler




static InfoStoryUIHandler* gInfoStoryUIHandler;
+ (InfoStoryUIHandler*) instance
{
    if ( !gInfoStoryUIHandler )
    {
        gInfoStoryUIHandler = [ [ InfoStoryUIHandler alloc] init ];
        [ gInfoStoryUIHandler initUIHandler:@"InfoStoryView" isAlways:YES isSingle:NO ];
    }
    
    return gInfoStoryUIHandler;
}




- ( void ) onInited
{
    [ super onInited ];
    
    UIButton* button = (UIButton*)[ view viewWithTag:2200 ];
    [ button addTarget:self action:@selector(onCloseClick) forControlEvents:UIControlEventTouchUpInside ];
    
    scrollView = (InfoStoryScrollView*)[ view viewWithTag:2000 ];
    scrollView.delegate = self;
    pageControl = ( UIPageControl* )[ view viewWithTag:2001 ];
    [ scrollView initStoryScrollView:[ uiArray objectAtIndex:1 ] :self :@selector( onStoryClick: ) ];
}


- ( void ) onOpened
{
    [ super onOpened ];
    
    [ self updateStoryList ];
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


- ( void ) updateStoryList
{
    if ( !view )
    {
        return;
    }
    
    [ scrollView clear ];
    
    NSMutableArray* array = [ StoryConfig instance ].Array;
    
    for ( fint32 i = 0 ; i < array.count ; ++i )
    {
        StoryConfigData* data = [ array objectAtIndex:i ];
        
        if ( data.ID <= [ PlayerData instance ].Story )
        {
            [ scrollView addItem:data ];
        }
    }
    
    [ scrollView updaContentSize ];
    [ scrollView setSelect:0 ];
    
    selectStory = [ scrollView getItem:0 ];
    
    pageControl.numberOfPages = scrollView.DataCount / 19;
    pageControl.numberOfPages += ( scrollView.DataCount % 19 ) ? 1 : 0;
    pageControl.currentPage = 0;
    
    [ self updateSelectStory ];
}


- ( void ) onStoryClick:( InfoStoryItem* )item
{
    if ( selectStory == item )
    {
        return;
    }
    
    selectStory = item;
    
    [ self updateSelectStory ];
}


- ( void ) scrollViewDidEndDecelerating:( UIScrollView* )sv
{
    int index = fabs( sv.contentOffset.x ) / sv.frame.size.width;
    
    pageControl.currentPage = index;
}


- ( void ) updateSelectStory
{
    if ( !selectStory )
    {
        return;
    }
    
    NSMutableArray* array = [ StoryConfig instance ].Array;
    for ( fint32 i = 0 ; i < array.count ; ++i )
    {
        StoryConfigData* data = [ array objectAtIndex:i ];
        
        if ( data.ID == selectStory.StoryID )
        {
            UILabel* label = (UILabel*)[ view viewWithTag:1000 ];
            [ label setText:data.Name ];
            
            UITextView* textView = (UITextView*)[ view viewWithTag:1001 ];
            [ textView setText:data.Des ];
            
            return;
        }
        
    }

    
    
}




@end
