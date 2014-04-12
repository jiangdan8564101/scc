//
//  ShopSellScrollView.m
//  sc
//
//  Created by fox on 13-11-5.
//
//

#import "InfoStoryScrollView.h"

@implementation InfoStoryScrollView
@synthesize UseSelect , DataCount;

- ( void ) initStoryScrollView:( InfoStoryItem* )item :( NSObject* )obj :( SEL )s
{
    itemView = item;
    
    array = [ [ NSMutableArray alloc ] init ];
    
    object = obj;
    sel = s;
}

- ( void ) dealloc
{
    [ self clear ];
    
    [ array release ];
    array = NULL;
    
    [ super dealloc ];
}

- ( void ) updaContentSize
{
    int w = DataCount / 19;
    int wi = DataCount % 19;
    
    [ self setContentSize:CGSizeMake( itemView.frame.size.width * ( w + ( wi ? 1 : 0 ) ) , 0 ) ];
}


- ( InfoStoryItem* ) getItem:( int )i
{
    return [ array objectAtIndex:i ];
}


- ( void ) removeItem:( int )i
{
    if ( i != array.count - 1 )
    {
        for ( int j = array.count - 1 ; j > i  ; --j )
        {
            InfoStoryItem* view1 = [ array objectAtIndex:j ];
            InfoStoryItem* view2 = [ array objectAtIndex:j - 1 ];
            
            view1.Index = view2.Index;
            
            [ view1 setCenter:view2.center ];
        }
    }
    
    
    UIView* view = [ array objectAtIndex:i ];
    
    if ( view )
    {
        [ view removeFromSuperview ];
        [ array removeObjectAtIndex:i ];
    }
    
    float p = itemView.frame.size.width * ( i - 1 );
    
    if ( p < 0 )
    {
        p = 0.0f;
    }
    
    DataCount--;
    [ self updaContentSize ];
    //[ self setContentOffset:CGPointMake( p , 0.0f ) ];
}


- ( void ) clear
{
    for ( int i = 0 ; i < array.count ; i++ )
    {
        [ [ array objectAtIndex:i ] removeFromSuperview ];
    }
    [ array removeAllObjects ];
    DataCount = 0;
}


- ( void ) setSelect:( int )i
{
    for ( int i = 0 ; i < array.count ; ++i )
    {
        InfoStoryItem* item = [ array objectAtIndex:i ];
        [ item setSelect:NO ];
    }
    
    InfoStoryItem* item = [ array objectAtIndex:i ];
    [ item setSelect:YES ];
}


- ( void ) addItem:( StoryConfigData* )data
{
    InfoStoryItem* item =  [ NSKeyedUnarchiver unarchiveObjectWithData:
                           [ NSKeyedArchiver archivedDataWithRootObject:itemView ] ];
    [ array addObject:item ];
    [ item setData:data ];
    
    
    UIButton* button = ( UIButton* )[ item viewWithTag:200 ];
    [ button addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside ];
    
    int w = DataCount / 19;
    int wi = DataCount % 19;
    
    [ item setCenter:CGPointMake( item.frame.size.width * 0.5f + item.frame.size.width * w , item.frame.size.height * 0.5f + item.frame.size.height * wi ) ];
    
    [ self addSubview:item ];
    
    DataCount++;
}


- ( void ) onClick:( UIButton* )button
{
    if ( UseSelect )
    {
        for ( int i = 0 ; i < array.count ; ++i )
        {
            InfoStoryItem* item = [ array objectAtIndex:i ];
            [ item setSelect:NO ];
        }
    }
    
    InfoStoryItem* item = ( InfoStoryItem* )button.superview;
    [ item setSelect:YES ];
    
    [ object performSelector:sel withObject:button.superview ];
}

@end


