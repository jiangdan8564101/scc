//
//  InfoQuestScrollView.m
//  sc
//
//  Created by fox on 13-12-5.
//
//

#import "InfoQuestScrollView.h"

@implementation InfoQuestScrollView


- ( int ) getPageCount
{
    int count = self.DataCount / 12;
    count += ( self.DataCount % 12 ) ? 1 : 0;
    
    return count;
}

- ( void ) updateContentSize
{
    if ( !self.DataCount )
    {
        return;
    }
    
    int w = self.DataCount / 12;
    int wi = self.DataCount % 12;
    
    [ self setContentSize:CGSizeMake( itemView.frame.size.width * ( w * 3 + ( wi ? 3 : 0 ) ) , 0 ) ];
    
    [ self updateOriginPoint ];
    self.UseSelect = YES;
}


- ( void ) updateOriginPoint
{
    [ originPointArray removeAllObjects ];
    
    for ( int i = 0; i < self.DataCount; i++ )
    {
        int w = i / 12;
        int wi = i % 3;
        int ww = i % 12 / 3;
        
        int x = itemView.frame.size.width * 0.5f + itemView.frame.size.width * w * 3 + itemView.frame.size.width * wi;
        int y = itemView.frame.size.height * 0.5f + itemView.frame.size.height * ww;
        
        [ originPointArray addObject:[ NSNumber numberWithInt:x * 10000 + y ]  ];
    }
}



- ( void ) setPos:( int )p
{
    
}


- ( BOOL ) getItemIndexRange
{
    int s = int( self.contentOffset.x / itemView.frame.size.width / 3 ) * 12;
    
    //startIndex -= 15;
    
    if ( s < 0 )
    {
        s = 0;
    }
    
    int e = s + 12 * 2;
    
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
