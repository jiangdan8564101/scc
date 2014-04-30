//
//  AlchemyScrollView.m
//  sc
//
//  Created by fox on 13-11-2.
//
//

#import "AlchemyScrollView.h"

@implementation AlchemyScrollView


- ( int ) getPageCount
{
    int nn = 0;
    if ( gActualResource.type >= RESPAD2 )
    {
        nn = 14;
    }
    else
    {
        nn = 8;
    }
    
    int count = self.DataCount / nn;
    count += ( self.DataCount % nn ) ? 1 : 0;
    
    return count;
}

- ( void ) update:( float )delay
{
    for ( int i = 0 ; i < array.count ; ++i )
    {
        AlchemyUIItem* item = [ array objectAtIndex:i ];
        [ item update:delay ];
    }
}

- ( void ) updateContentSize
{
    if ( !self.DataCount )
    {
        return;
    }
    
    int nn = 0;
    if ( gActualResource.type >= RESPAD2 )
    {
        nn = 14;
    }
    else
    {
        nn = 8;
    }
    
    int w = self.DataCount / nn;
    int wi = self.DataCount % nn;
    
    [ self setContentSize:CGSizeMake( itemView.frame.size.width * ( w + ( wi ? 1 : 0 ) ) , 0 ) ];
    
    [ self updateOriginPoint ];
    self.UseSelect = YES;
}


- ( void ) updateOriginPoint
{
    [ originPointArray removeAllObjects ];
    
    int nn = 0;
    if ( gActualResource.type >= RESPAD2 )
    {
        nn = 14;
    }
    else
    {
        nn = 8;
    }
    
    for ( int i = 0; i < self.DataCount; i++ )
    {
        int w = i / nn;
        int wi = i % nn;
        
        int x = itemView.frame.size.width * 0.5f + itemView.frame.size.width * w;
        int y = itemView.frame.size.height * 0.5f + itemView.frame.size.height * wi;
        
        [ originPointArray addObject:[ NSNumber numberWithInt:x * 10000 + y ]  ];
    }
}



- ( void ) setPos:( int )p
{
    int ww = itemView.frame.size.width * p;
    
    int nn = 0;
    if ( gActualResource.type >= RESPAD2 )
    {
        nn = 14;
    }
    else
    {
        nn = 8;
    }
    
    if ( ww >= self.contentSize.width )
    {
        int w = self.DataCount / nn;
        int wi = self.DataCount % nn;
        
        ww = itemView.frame.size.width * ( w+ ( wi ? 1 : 0 ) - 1 ) ;
    }
    
    [ self setContentOffset:CGPointMake( ww , 0.0f ) ];
}


- ( BOOL ) getItemIndexRange
{
    int nn = 0;
    if ( gActualResource.type >= RESPAD2 )
    {
        nn = 14;
    }
    else
    {
        nn = 8;
    }
    
    int s = int( self.contentOffset.x / itemView.frame.size.width ) * nn;
    
    //startIndex -= 15;
    
    if ( s < 0 )
    {
        s = 0;
    }
    
    int e = s + nn * 2;
    
    if ( e > self.DataCount )
    {
        e = self.DataCount;
    }
    
    if ( s == startIndex && e == endIndex )
    {
        return NO;
    }
    
    startIndex = s;
    endIndex = e;
    
    return YES;
}




@end
