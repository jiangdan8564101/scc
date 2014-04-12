//
//  ProfessionListScrollView.m
//  sc
//
//  Created by fox on 13-11-17.
//
//

#import "ProfessionListScrollView.h"

@implementation ProfessionListScrollView


- ( int ) getPageCount
{
    int count = self.DataCount / 24;
    count += ( self.DataCount % 24 ) ? 1 : 0;
    
    return count;
}

- ( void ) updateContentSize
{
    if ( !self.DataCount )
    {
        return;
    }
    
    int w = self.DataCount / 24;
    int wi = self.DataCount % 24;
    
    [ self setContentSize:CGSizeMake( itemView.frame.size.width * ( w * 6 + ( wi ? 6 : 0 ) ) , 0 ) ];
    
    [ self updateOriginPoint ];
    
    self.UseSelect = YES;
}


- ( void ) updateOriginPoint
{
    [ originPointArray removeAllObjects ];
    
    for ( int i = 0; i < self.DataCount; i++ )
    {
        int w = i / 24;
        int wi = i % 24;
        
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
        else if ( wi < 18 )
        {
            x = itemView.frame.size.width * 0.5f + itemView.frame.size.width * w * 6 + itemView.frame.size.width * ( wi - 12 );
            y = itemView.frame.size.height * 0.5f + itemView.frame.size.height * 2;
        }
        else
        {
            x = itemView.frame.size.width * 0.5f + itemView.frame.size.width * w * 6 + itemView.frame.size.width * ( wi - 18 );
            y = itemView.frame.size.height * 0.5f + itemView.frame.size.height * 3;
        }

        
        [ originPointArray addObject:[ NSNumber numberWithInt:x * 10000 + y ]  ];
    }
}



- ( void ) setPos:( int )p
{
}


- ( BOOL ) getItemIndexRange
{
    int s = int( self.contentOffset.x / itemView.frame.size.width ) * 6;
    
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



