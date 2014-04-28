//
//  WorkFurnitureUIHandler.m
//  sc
//
//  Created by fox on 13-11-18.
//
//

#import "WorkFurnitureUIHandler.h"
#import "ItemData.h"
#import "WorkWorkUIHandler.h"
#import "PlayerData.h"

@implementation WorkFurnitureUIHandler


static WorkFurnitureUIHandler* gWorkFurnitureUIHandler;
+ ( WorkFurnitureUIHandler* ) instance
{
    if ( !gWorkFurnitureUIHandler )
    {
        gWorkFurnitureUIHandler = [ [ WorkFurnitureUIHandler alloc] init ];
        [ gWorkFurnitureUIHandler initUIHandler:@"WorkFurnitureView" isAlways:YES isSingle:NO ];
    }
    
    return gWorkFurnitureUIHandler;
}



- ( void ) onInited
{
    [ super onInited ];
    
    itemScrollView = (ItemListScrollView*)[ view viewWithTag:2000 ];
    itemScrollView.delegate = self;
    itemPageLabel = ( UILabel* )[ view viewWithTag:2001 ];
    [ itemScrollView initItemScrollView:[ uiArray objectAtIndex:1 ] :self :@selector( onItemClick: ) ];
    
    UIButton* button = (UIButton*)[ view viewWithTag:1200 ];
    [ button addTarget:self action:@selector(onCloseClick) forControlEvents:UIControlEventTouchUpInside ];
    
    button = (UIButton*)[ view viewWithTag:1201 ];
    [ button addTarget:self action:@selector(onPutClick) forControlEvents:UIControlEventTouchUpInside ];
    
    des1label = ( UITextView* )[ view viewWithTag:2011 ];
    namelabel = ( UILabel* )[ view viewWithTag:2010 ];
}


- ( void ) onPutClick
{
    if ( !selectItem )
    {
        return;
    }
    
    PackItemData* data1 = [ [ ItemData instance ] getItem:selectItem.ItemID ];
    
    if ( data1.Number <= 0 )
    {
        data1.Number = 0;
        return;
    }
    
    WorkWorkFloor* selectFloor = [ WorkWorkUIHandler instance ].SelectFloor;
    [ selectFloor setItem:selectItem.ItemID ];
    [ [ PlayerData instance ] setWorkItemData:selectFloor.tag :selectItem.ItemID ];
    [ self visible:NO ];
    
    [ [ PlayerData instance ] updateWorkItemEffect ];
    
    playSound( PST_OK );
}


- ( void ) onOpened
{
    [ super onOpened ];
    
    [ self updateItemData ];
}


- ( void ) scrollViewDidEndDecelerating:( UIScrollView* )sv
{
    int index = fabs( sv.contentOffset.x ) / sv.frame.size.width;
    
    [ itemPageLabel setText:[ NSString stringWithFormat:@"%d/%d" , index + 1 , [ itemScrollView getPageCount ] ] ];
}


- ( void ) onCloseClick
{
    [ self visible:NO ];
    
    playSound( PST_CANCEL );
}


- ( void ) onClosed
{
    [ super onClosed ];
    
}


- ( void ) updateSelectItem
{
    [ namelabel setText:@"" ];
    [ des1label setText:@"" ];

    if ( !selectItem )
    {
        return;
    }
    
    ItemConfigData* item = [ [ ItemConfig instance ] getData:selectItem.ItemID ];
    
    NSMutableString* str = [ NSMutableString stringWithFormat:@"【 %@ 】", item.Name ];
    [ namelabel setText:str ];
    [ des1label setText:item.Des1 ];
}


- ( void ) updateItemState
{
    
}


- ( void ) updateItemData
{
    if ( !view )
    {
        return;
    }
    
    [ itemScrollView clear ];
    
    selectItem = NULL;
    
    NSMutableDictionary* dic = [ [ ItemData instance ] getType:ICDT_FURNITURE ];
    
    NSArray* values = [ dic allValues ];
    
    for ( fint32 i = 0 ; i < values.count ; ++i )
    {
        PackItemData* data = [ values objectAtIndex:i ];
        
        ItemConfigData* cdata = [ [ ItemConfig instance ] getData:data.ItemID ];
        
        if ( cdata.PutPosition != [ WorkWorkUIHandler instance ].SelectFloor.Type + 1 )
        {
            continue;
        }
        
        [ itemScrollView addItem:data ];
    }
    
    if ( values.count )
    {
        
    }
    
    [ itemScrollView updaContentSize ];
    int count = [ itemScrollView getPageCount ];
    [ itemScrollView setNeedsLayout ];
    
    [ itemPageLabel setText:[ NSString stringWithFormat:@"%d/%d" , 1 , count ] ];
    [ itemPageLabel setHidden:!count ];
    
    [ self updateSelectItem ];
    [ self updateItemState ];
}



- ( void ) onItemClick:( ItemListItem* )item
{
    if ( !item )
    {
        return;
    }
    
    if ( selectItem == item )
    {
        return;
    }
    
    selectItem = item;
    
    [ self updateSelectItem ];
}

- ( void ) update:( float ) delay
{

}


@end
