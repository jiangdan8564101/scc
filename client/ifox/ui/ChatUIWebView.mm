//
//  ChatUIWebView.m
//  ixyhz
//
//  Created by fox1 on 12-8-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ChatUIWebView.h"

@implementation ChatUIWebView



- ( void ) clearBackground
{
    self.backgroundColor = [ UIColor clearColor ]; 
    self.opaque = NO;
    self.dataDetectorTypes = UIDataDetectorTypeNone;
    
    UIScrollView* scroller = [ self.subviews objectAtIndex:0 ];
    if ( scroller )
    {
        for ( UIView *v in [ scroller subviews ] ) 
        {
            if ( [ v isKindOfClass:[ UIImageView class ] ] )
            {
                v.hidden = YES;
            }
        }
    }
}


- ( void ) initChatUIWebView
{
    if ( isLoaded )
    {
        return;
    }
    
    self.delegate = self;
    
    NSString* htmlString = @"<html><body style=\"background-color:transparent\"></body></html>";
    NSString* path = [ [ NSBundle mainBundle] bundlePath ];
    NSURL* baseURL = [ NSURL fileURLWithPath:path ];
    [ self loadHTMLString:htmlString baseURL:baseURL ];
    
    [ self clearBackground ];
    
    stringBuffer = [ [ NSMutableString alloc ] init ];
}


- ( void ) setChatUIWebView:( NSString* )str
{
    NSString* htmlString = [ NSString stringWithFormat:@"<html><body style=\"background-color:transparent\">%@</body></html>" , str ];
    NSString* path = [ [ NSBundle mainBundle] bundlePath ];
    NSURL* baseURL = [ NSURL fileURLWithPath:path ];
    [ self loadHTMLString:htmlString baseURL:baseURL ];
}


- ( void ) releaseChatUIWebView
{
    [ stringBuffer release ];
}


- ( void ) webViewDidFinishLoad:( UIWebView* )webView
{
    isLoaded = YES;
    
    NSString* java = [ NSString stringWithFormat:@"document.body.innerHTML += '%@'" , stringBuffer ];
    [ self stringByEvaluatingJavaScriptFromString:java ];
}


- ( void ) clearText
{
    [ self stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML = '' " ];
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ( navigationType == UIWebViewNavigationTypeLinkClicked ) 
    {
        NSString* string1 = request.URL.relativeString;
        
        NSRange range = [string1 rangeOfString:@"clearText" ];
        
        if ( range.length != 0 ) 
        {
            return YES;
        }
        
        
        NSURL *requestURL =[ [ request URL ] retain ];
        if ( ( [ [ requestURL scheme ] isEqualToString: @"http" ] ||
              [ [ requestURL scheme ] isEqualToString: @"https" ] || 
              [ [ requestURL scheme ] isEqualToString: @"mailto" ] )
            && ( navigationType == UIWebViewNavigationTypeLinkClicked ) ) 
        {
            return ![ [ UIApplication sharedApplication ] openURL: [ requestURL autorelease ] ];
        }
        
        
    }

    
    
    return YES;
}


- ( void ) appendHTMLText:( NSString* )str
{
    if ( isLoaded ) 
    {
        NSString* java = [ NSString stringWithFormat:@"document.body.innerHTML += '%@'" , str ];
        [ self stringByEvaluatingJavaScriptFromString:java ];
        
//        NSInteger height = [ [ self stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight;"] intValue ];
//        
//        if ( height > 1024 )
//        {
//            NSString* java2 = [ NSString stringWithFormat:@"document.body.innerHTML = '%@'" , str ];
//            [ self stringByEvaluatingJavaScriptFromString:java2 ];
//            [ self moveBottom ];
//        }
    }
    else
    {
        [ stringBuffer appendString:str ];
    }
}


- ( void ) moveBottom
{
    NSInteger height = [ [ self stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight;"] intValue ]; 
    NSString* javascript = [NSString stringWithFormat:@"window.scrollBy(0, %d);" , height ];   
    [ self stringByEvaluatingJavaScriptFromString:javascript ]; 
}

@end
