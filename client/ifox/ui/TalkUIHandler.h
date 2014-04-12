//
//  TalkUIHandler.h
//  sc
//
//  Created by fox on 13-11-26.
//
//

#import "UIHandlerZoom.h"
#import "GuideConfig.h"


@interface TalkUIHandler : UIHandlerZoom
{
    UILabel* labelName;
    UITextView* labelText;
    UIImageView* imageViewRight;
    UIImageView* imageViewMiddle;
    UIImageView* imageViewLeft;
    UIImageView* imageViewName;
    UIImageView* imageViewBG;
    UIView* whiteView;
    
    CGPoint centerPointRight;
    CGPoint centerPointMiddle;
    CGPoint centerPointLeft;
    
    BOOL waitFade;
    BOOL wait;
    BOOL wait1;
    float strDelay;
    int strPos;
    int strCount;
    BOOL strStart;
    
    NSMutableString* strText;
    
    BOOL setpStart;
    int stepPos;
    GuideConfigData* activeData;
    GuideConfigStep* activeStep;
    
    float uiDelay;
    
    NSObject* object;
    SEL sel;
    
    UIColor* colorMask;
}

+ ( TalkUIHandler* ) instance;

- ( UIImageView* ) getImageRight;
- ( UIImageView* ) getImageMiddle;
- ( UIImageView* ) getImageLeft;

- ( void ) clearImage;
- ( void ) setData:( int )data;
- ( void ) setSel:( NSObject* )obj :( SEL )s;
- ( void ) setString:( NSString* )str;

@end











