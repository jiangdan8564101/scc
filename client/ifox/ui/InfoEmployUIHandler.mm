//
//  InfoEmployUIHandler.m
//  sc
//
//  Created by fox on 13-12-29.
//
//

#import "InfoEmployUIHandler.h"
#import "PlayerCreatureData.h"
#import "PlayerData.h"

@implementation InfoEmployUIHandler



static InfoEmployUIHandler* gInfoEmployUIHandler;
+ (InfoEmployUIHandler*) instance
{
    if ( !gInfoEmployUIHandler )
    {
        gInfoEmployUIHandler = [ [ InfoEmployUIHandler alloc] init ];
        [ gInfoEmployUIHandler initUIHandler:@"InfoEmployView" isAlways:YES isSingle:NO ];
    }
    
    return gInfoEmployUIHandler;
}




- ( void ) onInited
{
    [ super onInited ];
    
    UIButton* button = (UIButton*)[ view viewWithTag:2200 ];
    [ button addTarget:self action:@selector(onCloseClick) forControlEvents:UIControlEventTouchUpInside ];
    
    scrollView = (InfoEmployScrollView*)[ view viewWithTag:2000 ];
    scrollView.delegate = self;
    pageLabel = ( UILabel* )[ view viewWithTag:2001 ];
    [ scrollView initEmployScrollView:[ uiArray objectAtIndex:1 ] :self :@selector( onEmployClick: ) ];
    
    imageView = (UIImageView*)[ view viewWithTag:1010 ];
    centerPoint = imageView.center;
}


- ( void ) onOpened
{
    [ super onOpened ];
    
    [ self updateEmployList ];
}


- ( void ) onClosed
{
    [ imageView setImage:NULL ];
    [ super onClosed ];
}


- ( void ) onCloseClick
{
    [ self visible:NO ];
    
    playSound( PST_CANCEL );
}


- ( void ) updateEmployList
{
    if ( !view )
    {
        return;
    }
    
    [ scrollView clear ];
    
    NSArray* array = getSortKeys( [ PlayerData instance ].Employ );
    
    for ( fint32 i = 0 ; i < array.count ; ++i )
    {
        int cID = [ [ array objectAtIndex:i ] intValue ];
        
        [ scrollView addItem:cID ];
    }
    
    [ scrollView updaContentSize ];
    [ scrollView setSelect:0 ];
    
    selectEmploy = [ scrollView getItem:0 ];
    
    int count = scrollView.DataCount / 18;
    count += ( scrollView.DataCount % 18 ) ? 1 : 0;
    
    [ pageLabel setText:[ NSString stringWithFormat:@"%d/%d" , 1 , count ] ];
    [ pageLabel setHidden:!count ];
    
    [ self updateSelectEmploy ];
}


- ( void ) onEmployClick:( InfoEmployItem* )item
{
    if ( selectEmploy == item )
    {
        return;
    }
    
    selectEmploy = item;
    
    [ self updateSelectEmploy ];
}


- ( void ) scrollViewDidEndDecelerating:( UIScrollView* )sv
{
    int index = fabs( sv.contentOffset.x ) / sv.frame.size.width;
    
    int count = scrollView.DataCount / 18;
    count += ( scrollView.DataCount % 18 ) ? 1 : 0;
    
    [ pageLabel setText:[ NSString stringWithFormat:@"%d/%d" , index + 1 , count ] ];
}


- ( void ) updateSelectEmploy
{
    if ( !selectEmploy )
    {
        return;
    }
    
    CreatureCommonData* comm = [[ CreatureConfig instance ] getCommonData:selectEmploy.CreautreID ];
    
    UILabel* label = (UILabel*)[ view viewWithTag:1000 ];
    [ label setText:comm.Name ];
    
    UITextView* textView = (UITextView*)[ view viewWithTag:1001 ];
    [ textView setText:comm.Des ];
    
    NSString* str = [ NSString stringWithFormat:@"CS%@AA" , comm.Action ];
    NSString* path = [ [ NSBundle mainBundle ] pathForResource:str ofType:@"png" inDirectory:CREATURE_PATH ];
    UIImage* image = [ UIImage imageWithContentsOfFile:path ];
    
    CGSize sz = image.size;
    [ imageView setImage:image ];
    CGRect rect = imageView.frame;
    
    if ( gActualResource.type >= RESPAD2 )
    {
        
    }
    else
    {
        sz.width *= 0.5f;
        sz.height *= 0.5f;
    }
    
    rect.size = sz;
    
    
    CGPoint point = centerPoint;
    if ( comm.ImageOffsetX )
    {
        point.x += -sz.width * 0.5f + comm.ImageOffsetX;
    }
    else
    {
        point.x += -sz.width * 0.5f;
    }
    
    if ( comm.ImageOffsetY )
    {
        point.y += -sz.height + comm.ImageOffsetY;
    }
    else
    {
        point.y += -sz.height;
    }
    
    rect.origin = point;
    
    [ imageView setFrame:rect ];
}




@end
