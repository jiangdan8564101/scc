//
//  PlayerInfoScrollView.m
//  sc
//
//  Created by fox on 13-9-19.
//
//

#import "PlayerInfoScrollView.h"

@implementation PlayerInfoScrollView



- ( int ) getPageCount
{
    return self.DataCount;
}

- ( void ) updateContentSize
{
    [ self setContentSize:CGSizeMake( itemView.frame.size.width * self.DataCount , 0 ) ];
    
    [ self updateOriginPoint ];
}


- ( void ) updateOriginPoint
{
    [ originPointArray removeAllObjects ];
    
    for ( int i = 0; i < self.DataCount; i++ )
    {
        int x =  itemView.frame.size.width * 0.5f + itemView.frame.size.width * i;
        int y = itemView.frame.size.height * 0.5f;
        
        [ originPointArray addObject:[ NSNumber numberWithInt:x * 10000 + y ]  ];
    }
}



- ( void ) setPos:( int )p
{
    [ self setContentOffset:CGPointMake( itemView.frame.size.width * ( p ) , 0.0f ) ];
}


- ( BOOL ) getItemIndexRange
{
    int s = int( self.contentOffset.x / itemView.frame.size.width ) * 1;
    
    //startIndex -= 15;
    
    if ( s < 0 )
    {
        s = 0;
    }
    
    int e = s + 1 * 2;
    
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


