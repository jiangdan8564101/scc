//
//  UILabelNumber.h
//  sc
//
//  Created by fox on 14-1-1.
//
//

#import <UIKit/UIKit.h>

@interface UILabelNumber : UILabel
{
    NSObject* object;
    SEL sel;
    
    int number;
    BOOL startJump;
    int jumpNumber;
    int startNumber;
    int jumpCount;
    float jumpTime;
    float jumpDelay;
}

-( void ) JumpNumber:( int )n :( float )t :( NSObject* )obj :( SEL )s;

-( void ) SetNumber:( int )n;
-( int ) GetNumber;

- ( void ) update:( float )d;

@end
