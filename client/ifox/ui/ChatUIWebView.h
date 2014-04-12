//
//  ChatUIWebView.h
//  ixyhz
//
//  Created by fox1 on 12-8-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ChatUIWebView : UIWebView< UIWebViewDelegate >
{
    BOOL isLoaded;
    NSMutableString* stringBuffer;
}

- ( void ) initChatUIWebView;
- ( void ) setChatUIWebView:( NSString* )str;
- ( void ) releaseChatUIWebView;

- ( void ) clearBackground;

- ( void ) clearText;
- ( void ) appendHTMLText:( NSString* )str;

- ( void ) moveBottom;

@end

