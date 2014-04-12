//
//  CityOutUIHandler.m
//  sc
//
//  Created by fox on 13-12-13.
//
//

#import "CityOutUIHandler.h"

@implementation CityOutUIHandler

static CityOutUIHandler* gCityOutUIHandler;
+ (CityOutUIHandler*) instance
{
    if ( !gCityOutUIHandler )
    {
        gCityOutUIHandler = [ [ CityOutUIHandler alloc] init ];
        [ gCityOutUIHandler initUIHandler:@"CityOutView" isAlways:YES isSingle:NO ];
    }
    
    return gCityOutUIHandler;
}

- ( void ) setBG:( NSString* )name
{
    UIImageView* imageView = (UIImageView*)[ view viewWithTag:1000 ];
    
    NSString* path = [ [ NSBundle mainBundle ] pathForResource:name ofType:@"jpg" inDirectory:@"" ];
    UIImage* image = [ UIImage imageWithContentsOfFile:path ];
    
    [ imageView setImage:image ];
}

- ( void ) fade:( float )f
{
    UIImageView* imageView = (UIImageView*)[ view viewWithTag:1000 ];
    
    imageView.alpha = 0.0f;
    
    [ UIView beginAnimations:@"fade in11" context:nil ];
    [ UIView setAnimationDuration:f ];
    [ UIView setAnimationDelegate:self ];
    [ UIView setAnimationCurve:UIViewAnimationCurveEaseIn ];
    imageView.alpha = 1.0f;
    [ UIView commitAnimations ];
}


- ( void ) fadeRight:( float )f
{
    CATransition* transition = [ CATransition animation ];
	transition.duration = f;
	transition.timingFunction = [ CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut ];
	
	transition.type = kCATransitionPush;
	transition.subtype = kCATransitionFromRight;
	
	[ view.layer addAnimation:transition forKey:nil ];
}

- ( void ) fadeLeft:( float )f
{
	CATransition* transition = [ CATransition animation ];
	transition.duration = f;
	transition.timingFunction = [ CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut ];
	
	transition.type = kCATransitionPush;
	transition.subtype = kCATransitionFromLeft;
	
	[ view.layer addAnimation:transition forKey:nil ];
}


@end
