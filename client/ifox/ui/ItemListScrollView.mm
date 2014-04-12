//
//  ItemListScrollView.m
//  sc
//
//  Created by fox on 13-9-23.
//
//

#import "ItemListScrollView.h"

@implementation ItemListScrollView
@synthesize DataCount;

- ( void ) initItemScrollView:( ItemListItem* )item :(NSObject *)obj :(SEL)s
{
    itemView = item;
    
    array = [ [ NSMutableArray alloc ] init ];
    dataArray = [ [ NSMutableArray alloc ] init ];
    originPointArray = [ [ NSMutableArray alloc ] init ];
    
    onScreenViewDic = [ [ NSMutableDictionary alloc ] init ];
    offScreenViewArray = [ [ NSMutableArray alloc ] init ];
    
    object = obj;
    sel = s;
}

- ( void ) dealloc
{
    [ self clear ];
    
    [ array release ];
    array = NULL;
    
    [ dataArray release ];
    dataArray = NULL;
    
    [ originPointArray release ];
    originPointArray = NULL;
    
    [ onScreenViewDic release ];
    onScreenViewDic = NULL;
    
    [ offScreenViewArray release ];
    offScreenViewArray = NULL;
    
    [ super dealloc ];
}

- ( int ) getPageCount
{
    int count = self.DataCount / 18;
    count += ( self.DataCount % 18 ) ? 1 : 0;

    return count;
}

- ( void ) updaContentSize
{
    int w = DataCount / 18;
    int wi = DataCount % 18;
    
    [ self setContentSize:CGSizeMake( itemView.frame.size.width * ( w * 6 + ( wi ? 6 : 0 ) ) , 0 ) ];
    
    [ self updateOriginPoint ];
    
}


- ( void ) updateOriginPoint
{
    [ originPointArray removeAllObjects ];
    
    for ( int i = 0; i < DataCount; i++ )
    {
        int w = i / 18;
        int wi = i % 18;
        
        int x = 0;
        int y = 0;
        
        if ( wi < 6 )
        {
            x = itemView.frame.size.width * 0.5f + itemView.frame.size.width * w * 6 + itemView.frame.size.width * wi;
            y = itemView.frame.size.height * 0.5f;
        }
        else if ( wi < 12 )
        {
            x = itemView.frame.size.width * 0.5f + itemView.frame.size.width * w * 6 + itemView.frame.size.width * ( wi - 6 );
            y = itemView.frame.size.height * 0.5f + itemView.frame.size.height;
        }
        else
        {
            x = itemView.frame.size.width * 0.5f + itemView.frame.size.width * w * 6 + itemView.frame.size.width * ( wi - 12 );
            y = itemView.frame.size.height * 0.5f + itemView.frame.size.height * 2;
        }
        
        [ originPointArray addObject:[ NSNumber numberWithInt:x * 10000 + y ]  ];
    }
}


- ( void ) setPos:( int )p
{
    int ww = itemView.frame.size.width * p * 6;
    
    if ( ww >= self.contentSize.width )
    {
        int w = DataCount / 18;
        int wi = DataCount % 18;
        
        ww = itemView.frame.size.width * ( w * 6 + ( wi ? 6 : 0 ) - 1 ) ;
    }
    
    [ self setContentOffset:CGPointMake( ww , 0.0f ) ];
}

- ( BOOL ) getItemIndexRange
{
    int s = int( self.contentOffset.x / itemView.frame.size.width / 6 ) * 18;
    
    if ( s < 0 )
    {
        s = 0;
    }
    
    int e = s + 18 * 2;
    
    if ( e > DataCount )
    {
        e = DataCount;
    }
    
    if ( s == startIndex && e == endIndex )
    {
        return NO;
    }
    
    startIndex = s;
    endIndex = e;
    
    return YES;
}


- ( void ) addSubviewsOnScreen
{
    BOOL b = [ self getItemIndexRange ];
    
    if ( !b )
    {
        return;
    }
    
    for ( NSNumber *key in [ onScreenViewDic allKeys ] )
    {
        if ( [ key intValue ] < startIndex || [ key intValue] >= endIndex )
        {
            ItemListItem* item = [ onScreenViewDic objectForKey:key ];
            
            [ offScreenViewArray addObject:item ];
            
            [ onScreenViewDic removeObjectForKey:key];
            
            [ item removeFromSuperview ];
            [ array removeObject:item ];
        }
    }
    
    for ( int i = startIndex ; i < endIndex ; i++ )
    {
        if ( ![ [ onScreenViewDic allKeys ] containsObject:[ NSNumber numberWithInt:i ] ] )
        {
            ItemListItem* item = NULL;
            if ( offScreenViewArray.count )
            {
                item = [ offScreenViewArray objectAtIndex:0 ];
            }
            
            if ( !item )
            {
                item =  [ NSKeyedUnarchiver unarchiveObjectWithData:
                         [ NSKeyedArchiver archivedDataWithRootObject:itemView ] ];
            }
            
            [ array addObject:item ];
            if ( offScreenViewArray.count )
            {
                [ offScreenViewArray removeObjectAtIndex:0 ];
            }
            
            if ( [ [ dataArray objectAtIndex:i ] isKindOfClass:[ PackItemData class ] ] )
            {
                [ item setData:[ dataArray objectAtIndex:i ] ];
            }
            else
            {
                [ item setSkillData:[ dataArray objectAtIndex:i ] ];
            }
            
            UIButton* button = ( UIButton* )[ item viewWithTag:200 ];
            [ button removeTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside ];
            [ button addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside ];
            item.Index = i;
            
            int x = [ [ originPointArray objectAtIndex:i ] intValue ] / 10000;
            int y = [ [ originPointArray objectAtIndex:i ] intValue ] % 10000;
            
            [ item setCenter:CGPointMake( x , y ) ];
            
            [ onScreenViewDic setObject:item forKey:[ NSNumber numberWithInt:i ] ];
            
            [ self addSubview:item ];
            
            if ( array.count == 1 && !offScreenViewArray.count )
            {
                // first select
                selectIndex = 0;
                [ item setSelect:YES ];
                [ object performSelector:sel withObject:item ];
            }
            
            
            if ( selectIndex == i )
            {
                [ item setSelect:YES ];
            }
            
        }
    }
    
    [ object performSelector:sel withObject:nil ];
}


- ( void ) layoutSubviews
{
    [ super layoutSubviews ];
    
    if ( DataCount == 0 )
    {
    	return;
    }
    
    [ self addSubviewsOnScreen ];
}



- ( ItemListItem* ) getItem:( int )i
{
    if ( i >= array.count )
    {
        return NULL;
    }
    
    return [ array objectAtIndex:i ];
}

- ( void ) setSelect:( int )i
{
    for ( int i = 0 ; i < array.count ; ++i )
    {
        ItemListItem* item = [ array objectAtIndex:i ];
        [ item setSelect:NO ];
    }
    
    ItemListItem* item = [ array objectAtIndex:i ];
    [ item setSelect:YES ];
}

- ( void ) removeItem:( int )i
{
    if ( i != array.count - 1 )
    {
        for ( int j = array.count - 1 ; j > i  ; --j )
        {
            ItemListItem* view1 = [ array objectAtIndex:j ];
            ItemListItem* view2 = [ array objectAtIndex:j - 1 ];
            
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
    [ self setContentOffset:CGPointMake( p , 0.0f ) ];
}


- ( void ) clear
{
    for ( int i = 0 ; i < array.count ; i++ )
    {
        [ [ array objectAtIndex:i ] removeFromSuperview ];
    }
    
    [ onScreenViewDic removeAllObjects ];
    [ offScreenViewArray removeAllObjects ];
    
    [ originPointArray removeAllObjects ];
    [ dataArray removeAllObjects ];
    [ array removeAllObjects ];
    
    DataCount = 0;
    
    startIndex = 0;
    endIndex = 0;
    selectIndex = 0;
}


- ( void ) addItem:( PackItemData* )data
{
    [ dataArray addObject:data ];
    
    DataCount++;
}

- ( void ) addSkillItem:( ProfessionSkillData* )data
{
    [ dataArray addObject:data ];
    
    DataCount++;
}



- ( void ) onClick:( UIButton* )button
{
    playSound( PST_SELECT );
    
    for ( int i = 0 ; i < array.count ; ++i )
    {
        ItemListItem* item = [ array objectAtIndex:i ];
        [ item setSelect:NO ];
    }
    
    ItemListItem* item = ( ItemListItem* )button.superview;
    [ item setSelect:YES ];

    selectIndex = item.Index;

    [ object performSelector:sel withObject:button.superview ];
}



@end

