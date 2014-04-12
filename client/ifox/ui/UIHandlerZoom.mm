//
//  UIHandlerZoom.m
//  sc
//
//  Created by fox on 13-1-16.
//
//

#import "UIHandlerZoom.h"

@implementation UIHandlerZoom


- ( void ) onOpened
{
    if ( !color )
    {
        color = [ [ view backgroundColor ] copy ];
    }
    
    [ view setBackgroundColor:color ];
    [ view setTransform:CGAffineTransformMakeScale( 1.0f , 1.0f ) ];
    [ view setAlpha:0.1f ];
    
    //NSLog( @"onOpened %@" , viewName );
    
    [ UIView beginAnimations:@"zoom in" context:nil ];
    
    [ UIView setAnimationDuration:0.3f ];
    [ view setAlpha:1.0f ];
    [ UIView commitAnimations ];
    
}


- ( void )animationOpenFinished
{
    [ UIView setAnimationDelegate:nil ];
}


- ( void ) onClosed
{
    if ( !view )
    {
        return;
    }
    
    [ view setBackgroundColor:[ UIColor clearColor ] ];
    //NSLog( @"onClosed %@" , viewName );
    [ view setHidden:NO ];
    
    [ UIView beginAnimations:@"zoom out" context:nil ];
    [ UIView setAnimationDelegate:self ];
    [ UIView setAnimationDidStopSelector:@selector(animationCloseFinished:finished:context:) ];
    [ UIView setAnimationDuration:0.3f ];
    [ UIView setAnimationCurve:UIViewAnimationCurveEaseIn ];
    
    
    [ view setTransform:CGAffineTransformMakeScale( 0.85f , 0.85f ) ];
    [ view setAlpha:0.01f ];
    
    [ UIView commitAnimations ];
}


- (void) animationCloseFinished:( NSString* )animationID finished:( BOOL )finished context:( BOOL )context
{
    //NSLog( @"onClosed f %@ %d" , viewName , finished );
    [ UIView setAnimationDelegate:nil ];
    
    if ( !isOpened )
    {
        [ view setHidden:YES ];
        [ view setTransform:CGAffineTransformMakeScale( 1.0f , 1.0f ) ];
    }
}


@end
