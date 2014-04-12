//
//  UILabelNumber.m
//  sc
//
//  Created by fox on 14-1-1.
//
//

#import "UILabelNumber.h"

@implementation UILabelNumber


- ( int ) GetNumber
{
    return number;
}


- ( void ) JumpNumber:(int)n :(float)t :(NSObject *)obj :(SEL)s
{
    object = obj;
    sel = s;
    
    jumpNumber = n;
    
    if ( jumpNumber == number )
    {
        [ self UpdateNumber ];
        [ object performSelector:sel withObject:nil ];
        return;
    }
    
    startNumber = number;
    
    jumpCount = jumpNumber - number;
    jumpCount /= t;
    
    jumpTime = t;
    jumpDelay = 0.0f;
    
    startJump = YES;
}

- ( void ) StopJump
{
    number = jumpNumber;
    
    startJump = NO;
}

- ( void ) UpdateNumber
{
    if ( number > 0 )
    {
        [ self setText:[ NSString stringWithFormat:@"+%d" , number ] ];
    }
    else
    {
        [ self setText:[ NSString stringWithFormat:@"%d" , number ] ];
    }
}


-( void ) SetNumber:( int )n
{
    [ self StopJump ];
    
    number = n;
    
    [ self UpdateNumber ];
}


-( void ) update:( float )delay
{
    if ( !startJump )
    {
        return;
    }
    
    jumpDelay += delay;
    
    number = startNumber + jumpCount * jumpDelay;
    
    [ self UpdateNumber ];
    
    if ( jumpDelay > jumpTime )
    {
        [ self StopJump ];
        [ self UpdateNumber ];
        
        [ object performSelector:sel withObject:nil ];
    }
}





@end
