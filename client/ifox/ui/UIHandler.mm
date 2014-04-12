//
//  UIHandler.m
//  sc
//
//  Created by fox1 on 12-7-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIHandler.h"
#import "GameUIManager.h"
#import "ClientDefine.h"

@implementation UIHandler

@synthesize IsSingle = isSingle, IsAlways = isAlways;
@synthesize View = view;
@synthesize uiArray = uiArray;
@synthesize isOpened;

- ( void ) initUIHandler:(NSString*)sViewName isAlways:(BOOL)bIsAlways isSingle:(BOOL)bIsSingle
{
    self = [super init];
    if (self) {
        isAlways = bIsAlways;
        isSingle = bIsSingle;
        
        viewName = [ [ NSMutableString alloc ] init ];
        [ viewName appendString:sViewName ];
        
        if ( gActualResource.type == RESPHONE5 )
        {
            [ viewName appendString:@"Iphone5" ];
        }
        
        if ( gActualResource.type == RESPHONE4 )
        {
            [ viewName appendString:@"Iphone" ];
        }
    }
}


- (void) open
{
    BOOL b = ( view == NULL );
    
    if ( !view )
    {
        uiArray = [ [ NSBundle mainBundle ] loadNibNamed:viewName owner:self options:NULL].retain;
        
        view = [ uiArray objectAtIndex:0 ];
        
        if ( ![ view isKindOfClass:[ UIViewBase class ] ] )
        {
            if ( view.superclass != [ UIViewBase class ] )
            {
                DEBUGLOG(@"not UIViewBase");
                assert(0);
            }
        }
        
        [ view initUIViewBase:self ];
        
        UIButton* btnClose = (UIButton*)[ view viewWithTag:UI_CLOSE_BUTTON_TAG ];
        if ( btnClose )
        {
            [ btnClose
             addTarget:self
             action:@selector(buttonClose::)
             forControlEvents:UIControlEventTouchUpInside];
        }
        
        // center,,
        [ view setCenter:CGPointMake( SCENE_WIDTH * 0.5f , SCENE_HEIGHT * 0.5f ) ];
    }
    
    if ( isSingle )
    {
        if ( !isOpened )
        {
            [ [ GameUIManager instance] removeAllUI:view ];
        }
    }
    
    [ view setHidden:NO ];
    [ [ GameUIManager instance ] addUI : view ];
    
    if ( b )
    {
        [ self onInited ];
    }
    
    if ( !isOpened )
    {
        [ self onOpened ];
    }
    
    isOpened = YES;
}


- (void) close 
{
    if ( view )
    {
        isOpened = NO;
        
        [ self onClosed ];
        
        if ( view.superview )
        {
            [ view removeFromSuperview ];
            view = NULL;
        }
        
        [ self onRelease ];
        
        [ uiArray release ];
        uiArray = NULL;
    }
    
}


- (void) onOpened
{
    //DEBUGLOG( @"onOpened %@" , view );
}
- (void) onClosed
{
    //DEBUGLOG( @"onClosed %@" , view );
}
- ( void ) onInited
{
    //DEBUGLOG( @"onInit %@" , view );
}
- ( void ) onRelease
{
    //DEBUGLOG( @"onRelease %@" , view );
}

- (void) visible : (BOOL)bVisible
{
    if ( bVisible )
    {
        [ self open ];
    }
    else
    {
        if ( isOpened )
        {
            isOpened = NO;
            
            [ view setHidden:YES ];
            [ self onClosed ];
        }
    }
}


- (void) loadingStart
{
    if ( aiView )
    {
        return;
    }
    
    [ self loadingStop ];
    
    CGRect rect = view.frame;
    
    aiView = [ [ UIActivityIndicatorView alloc ] init ];
    [ aiView setCenter : CGPointMake( rect.size.width * 0.5f, rect.size.height * 0.5f ) ];
    [ aiView setActivityIndicatorViewStyle : UIActivityIndicatorViewStyleWhiteLarge ];
    [ aiView setColor :[ UIColor whiteColor ] ];
    [ view addSubview : aiView ];
    [ aiView startAnimating ];
    
    aiTimer = [ NSTimer
                scheduledTimerWithTimeInterval:5
                target:self
                selector:@selector( loadingStop )
                userInfo:nil
                repeats:NO ];
}



- ( void ) loadingStop
{
    if ( aiTimer )
    {
        [ aiTimer invalidate ];
        aiTimer = nil;
    }
    
    if ( aiView )
    {
        [ aiView removeFromSuperview ];
        [ aiView release ];
        aiView = NULL;
    }
}


- ( void ) buttonClose:( UIButton* )selector :( UIEvent* )event
{
    // DEBUGLOG(@"%@", selector);
    // NSLog(@"%@", event);

    [ self visible:NO ];
}


- ( void ) update:( float ) delay
{
    // delay second ，update ui animation，or something，
}

@end
