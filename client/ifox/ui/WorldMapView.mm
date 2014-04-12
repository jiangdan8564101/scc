//
//  WorldMapView.m
//  sc
//
//  Created by fox on 13-1-13.
//
//

#import "WorldMapView.h"

@implementation WorldMapView


- (CGPoint)getLocation:(NSSet *)touches
{
    UITouch * touch = [touches anyObject];
    return [touch locationInView:self.superview];
}

- (void)move:(NSSet *)touches
{
    CGPoint endPoint = [ self getLocation:touches ];
    
    int x = endPoint.x - startPoint.x;
    int y = endPoint.y - startPoint.y;
    
    if (x == 0 && y == 0)
    {
        return;
    }
    
    if ( self.frame.origin.x + x > 0 )
    {
        x = -self.frame.origin.x;
    }
    if ( self.frame.origin.y + y > 0 )
    {
        y = -self.frame.origin.y;
    }
    
    if ( self.frame.origin.x + x < -self.frame.size.width + SCENE_WIDTH )
    {
        x = -self.frame.size.width + SCENE_WIDTH - self.frame.origin.x;
    }
    
    if ( self.frame.origin.y + y < -self.frame.size.height + SCENE_HEIGHT )
    {
        y = -self.frame.size.height + SCENE_HEIGHT - self.frame.origin.y;
    }
    
    startPoint = endPoint;
    self.frame = CGRectMake(self.frame.origin.x + x, self.frame.origin.y + y, self.frame.size.width, self.frame.size.height);
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    startPoint = [self getLocation:touches ];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self move:touches];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self move:touches];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self move:touches];
}

@end
