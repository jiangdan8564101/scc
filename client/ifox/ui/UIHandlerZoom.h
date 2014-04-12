//
//  UIHandlerZoom.h
//  sc
//
//  Created by fox on 13-1-16.
//
//

#import "UIHandler.h"

@interface UIHandlerZoom : UIHandler
{
    UIColor* color;
}
- (void) animationCloseFinished:( NSString* )animationID finished:( BOOL )finished context:( BOOL )context;
@end
