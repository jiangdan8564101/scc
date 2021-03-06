//
//  ShopSellScrollView.m
//  sc
//
//  Created by fox on 13-11-5.
//
//

#import "ShopSellScrollView.h"
#import "ClientDefine.h"

@implementation ShopSellScrollView

- ( int ) getPageCount
{
    int nn = 0;
    if ( gActualResource.type >= RESPAD2 )
    {
        nn = 17;
    }
    else
    {
        nn = 10;
    }
    int count = self.DataCount / nn;
    count += ( self.DataCount % nn ) ? 1 : 0;
    
    return count;
}

- ( void ) updateContentSize
{
    int nn = 0;
    if ( gActualResource.type >= RESPAD2 )
    {
        nn = 17;
    }
    else
    {
        nn = 10;
    }
    
    int w = self.DataCount / nn;
    int wi = self.DataCount % nn;
    
    [ self setContentSize:CGSizeMake( itemView.frame.size.width * ( w + ( wi ? 1 : 0 ) ) , 0 ) ];
    
    [ self updateOriginPoint ];
    
    self.UseSelect = YES;
}


- ( void ) updateOriginPoint
{
    int nn = 0;
    if ( gActualResource.type >= RESPAD2 )
    {
        nn = 17;
    }
    else
    {
        nn = 10;
    }
    
    [ originPointArray removeAllObjects ];
    
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
    int nn = 0;
    if ( gActualResource.type >= RESPAD2 )
    {
        nn = 17;
    }
    else
    {
        nn = 10;
    }
    
    int ww = itemView.frame.size.width * p;
    
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
        nn = 17;
    }
    else
    {
        nn = 10;
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


