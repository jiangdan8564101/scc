//
//  InfoMonsterScrollView.m
//  sc
//
//  Created by fox on 13-12-31.
//
//

#import "InfoMonsterScrollView.h"

@implementation InfoMonsterScrollView


- ( int ) getPageCount
{
    int count = self.DataCount / 18;
    count += ( self.DataCount % 18 ) ? 1 : 0;
    
    return count;
}

- ( void ) updateContentSize
{
    int w = self.DataCount / 18;
    int wi = self.DataCount % 18;
    
    [ self setContentSize:CGSizeMake( itemView.frame.size.width * ( w + ( wi ? 1 : 0 ) ) , 0 ) ];
    
    [ self updateOriginPoint ];
    
    self.UseSelect = YES;
}


- ( void ) updateOriginPoint
{
    [ originPointArray removeAllObjects ];
    
    for ( int i = 0; i < self.DataCount; i++ )
    {
        int w = i / 18;
        int wi = i % 18;
        
        int x = itemView.frame.size.width * 0.5f + itemView.frame.size.width * w;
        int y = itemView.frame.size.height * 0.5f + itemView.frame.size.height * wi;
        
        [ originPointArray addObject:[ NSNumber numberWithInt:x * 10000 + y ]  ];
    }
}



- ( void ) setPos:( int )p
{
//    int ww = itemView.frame.size.width * p;
//    
//    if ( ww >= self.contentSize.width )
//    {
//        int w = self.DataCount / 18;
//        int wi = self.DataCount % 18;
//        
//        ww = itemView.frame.size.width * ( w + ( wi ? 1 : 0 ) - 1 ) ;
//    }
//    
//    [ self setContentOffset:CGPointMake( ww , 0.0f ) ];
}


- ( BOOL ) getItemIndexRange
{
    int s = int( self.contentOffset.x / itemView.frame.size.width ) * 18;
    
    //startIndex -= 15;
    
    if ( s < 0 )
    {
        s = 0;
    }
    
    int e = s + 18 * 2;
    
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
