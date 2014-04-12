//
//  UIFastScrollView.m
//  sc
//
//  Created by fox on 14-1-5.
//
//

#import "UIFastScrollView.h"
#import "ClientDefine.h"

@implementation UIFastScrollView

@synthesize UseSelect , DataCount , UseFirstSelect , SelectIndex;

- ( void ) initFastScrollView:( UIFastScrollViewItem* )item :(NSObject *)obj :(SEL)s
{
    itemView = item;
    
    array = [ [ NSMutableArray alloc ] init ];
    dataArray = [ [ NSMutableArray alloc ] init ];
    originPointArray = [ [ NSMutableArray alloc ] init ];
    
    onScreenViewDic = [ [ NSMutableDictionary alloc ] init ];
    offScreenViewArray = [ [ NSMutableArray alloc ] init ];
    
    object = obj;
    sel = s;
    
    UseFirstSelect = YES;
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
    return 0;
}

- ( void ) updateContentSize
{
    return;
}

- ( void ) updateOriginPoint
{
    
}

- ( void ) setPos:( int )p
{
    
}

- ( BOOL ) getItemIndexRange
{
    return YES;
}

- ( UIFastScrollViewItem* ) getItem:( int )i
{
    if ( i < array.count )
    {
        return [ array objectAtIndex:i ];
    }
    
    return NULL;
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
            UIFastScrollViewItem* item = [ onScreenViewDic objectForKey:key ];
            
            [ offScreenViewArray addObject:item ];
            
            [ onScreenViewDic removeObjectForKey:key ];
            
            [ item removeFromSuperview ];
            [ array removeObject:item ];
        }
    }
    
    for ( int i = startIndex ; i < endIndex ; i++ )
    {
        if ( ![ [ onScreenViewDic allKeys ] containsObject:[ NSNumber numberWithInt:i ] ] )
        {
            UIFastScrollViewItem* item = NULL;
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
            [ item setData:[ dataArray objectAtIndex:i ] ];
            
            UIButton* button = ( UIButton* )[ item viewWithTag:200 ];
            [ button removeTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside ];
            [ button addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside ];
            
            UIButton* button1 = (UIButton*)[ item viewWithTag:504 ];
            UIButton* button2 = (UIButton*)[ item viewWithTag:505 ];
            [ button1 removeTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside ];
            [ button1 addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside ];
            [ button2 removeTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside ];
            [ button2 addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside ];
            
            item.Index = i;
            
            int x = [ [ originPointArray objectAtIndex:i ] intValue ] / 10000;
            int y = [ [ originPointArray objectAtIndex:i ] intValue ] % 10000;
            
            [ item setCenter:CGPointMake( x , y ) ];
            
            [ onScreenViewDic setObject:item forKey:[ NSNumber numberWithInt:i ] ];
            
            [ self addSubview:item ];
            
            if ( array.count == 1 && !offScreenViewArray.count )
            {
                // first select
                
                SelectIndex = 0;
                
                if ( UseFirstSelect )
                {
                    [ item setSelect:YES ];
                    [ object performSelector:sel withObject:item ];
                }
            }
            
            
            if ( SelectIndex == i )
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
    
    if ( self.DataCount == 0 )
    {
    	return;
    }
    
    [ self addSubviewsOnScreen ];
}



- ( void ) removeItem:( int )i
{
    if ( i != array.count - 1 )
    {
        for ( int j = array.count - 1 ; j > i  ; --j )
        {
            UIFastScrollViewItem* view1 = [ array objectAtIndex:j ];
            UIFastScrollViewItem* view2 = [ array objectAtIndex:j - 1 ];
            
            view1.Index = view2.Index;
            
            [ view1 setCenter:view2.center ];
        }
    }
    
    UIView* view = NULL;
    for ( int j = 0 ; j < array.count ; j++ )
    {
        UIFastScrollViewItem* view1 = [ array objectAtIndex:j ];
        
        if ( view1.Index == i )
        {
            view = view1;
            break;
        }
    }
    
    
    if ( view )
    {
        [ onScreenViewDic removeObjectForKey:[ NSNumber numberWithInt:i ] ];
        
        [ view removeFromSuperview ];
        [ array removeObjectAtIndex:i ];
    }
    
    float p = itemView.frame.size.width * ( i - 1 );
    
    if ( p < 0 )
    {
        p = 0.0f;
    }
    
    if ( SelectIndex == self.DataCount )
    {
        SelectIndex = self.DataCount - 1;
    }
    
    self.DataCount--;
    [ self updateContentSize ];
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
    
    self.DataCount = 0;
    self.UseSelect = NO;
    
    startIndex = 0;
    endIndex = 0;
    
    SelectIndex = 0;
    
    [ self setContentOffset:CGPointMake( 0.0f , 0.0f ) ];
}


- ( void ) setSelect:( int )i
{
    for ( int i = 0 ; i < array.count ; ++i )
    {
        UIFastScrollViewItem* item = [ array objectAtIndex:i ];
        [ item setSelect:NO ];
    }
    
    if ( array.count > i )
    {
        UIFastScrollViewItem* item = [ array objectAtIndex:i ];
        [ item setSelect:YES ];
    }
    
}


- ( void ) addItem:( NSObject* )data
{
    [ dataArray addObject:data ];
    
    self.DataCount++;
}


- ( void ) onClick:( UIButton* )button
{
    if ( !self.UseSelect )
    {
        return;
    }
    
    playSound( PST_SELECT );
    
    for ( int i = 0 ; i < array.count ; ++i )
    {
        UIFastScrollViewItem* item = [ array objectAtIndex:i ];
        [ item setSelect:NO ];
    }
    
    UIFastScrollViewItem* item = ( UIFastScrollViewItem* )button.superview;
    [ item setSelect:YES ];
    
    [ object performSelector:sel withObject:item ];
}



@end
