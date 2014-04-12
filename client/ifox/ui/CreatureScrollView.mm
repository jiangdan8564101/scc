//
//  CreatureScrollView.m
//  sc
//
//  Created by fox on 13-9-15.
//
//

#import "CreatureScrollView.h"

@implementation CreatureScrollView


- ( int ) getPageCount
{
    int count = self.DataCount / 6;
    count += ( self.DataCount % 6 ) ? 1 : 0;
    
    return count;
}

- ( void ) updateContentSize
{
    if ( !self.DataCount )
    {
        return;
    }
    
    int w = self.DataCount / 6;
    int wi = self.DataCount % 6;
    
    [ self setContentSize:CGSizeMake( itemView.frame.size.width * ( w * 3 + ( wi ? 3 : 0 ) ) , 0 ) ];
    
    [ self updateOriginPoint ];
    
    self.UseSelect = YES;
}


- ( void ) updateOriginPoint
{
    [ originPointArray removeAllObjects ];
    
    for ( int i = 0; i < self.DataCount; i++ )
    {
        int w = i / 6;
        int wi = i % 6;
        
        int x = 0;
        int y = 0;
        
        if ( wi < 3 )
        {
            x = itemView.frame.size.width * 0.5f + itemView.frame.size.width * w * 3 + itemView.frame.size.width * wi;
            y = itemView.frame.size.height * 0.5f;
        }
        else
        {
            x = itemView.frame.size.width * 0.5f + itemView.frame.size.width * w * 3 + itemView.frame.size.width * ( wi - 3 );
            y = itemView.frame.size.height * 0.5f + itemView.frame.size.height;
        }
        
        [ originPointArray addObject:[ NSNumber numberWithInt:x * 10000 + y ]  ];
    }
}



- ( void ) setPos:( int )p
{
}


- ( BOOL ) getItemIndexRange
{
    int s = int( self.contentOffset.x / itemView.frame.size.width / 3 ) * 6;
    
    //startIndex -= 15;
    
    if ( s < 0 )
    {
        s = 0;
    }
    
    int e = s + 6 * 2;
    
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
