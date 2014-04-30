//
//  BattleNumberView.m
//  sc
//
//  Created by fox on 13-5-5.
//
//

#import "BattleNumberView.h"
#import "gameDefine.h"

@implementation BattleNumberView
@synthesize NumType;

- ( int ) getNumber
{
    return number;
}

- ( void ) setNumber:( int )n
{
    if ( -n == FIGHT_MISS )
    {
        UIImageView* view = [ [ UIImageView alloc ] initWithImage:[ UIImage imageNamed:@"battleMiss" ] ];
        [ self addSubview:view ];
        [ view setCenter:CGPointMake( 0 , 0 ) ];
        [ array addObject:view ];
        [ view release ];
        
        return;
    }
    
    UIImageView* view1 = NULL;
    if ( n > 0 )
    {
        view1 = [ [ UIImageView alloc ] initWithImage:[ UIImage imageNamed:[ NSString stringWithFormat:@"%@+" , name ] ] ];
    }
    else
    {
        view1 = [ [ UIImageView alloc ] initWithImage:[ UIImage imageNamed:[ NSString stringWithFormat:@"%@-" , name ] ] ];
    }
    
    if ( n < 0 )
    {
        n = -n;
    }
    
    number = n;
    
    for ( int i = 0 ; i < array.count ; ++i )
    {
        [ [ array objectAtIndex:i ] removeFromSuperview ];
    }
    [ array removeAllObjects ];
    
    int n3 = n / 100;
    int n2 = ( n - n3 * 100 ) / 10;
    int n1 = ( n - n2 * 10 - n3 * 100 ) / 1;
    
    
    [ view1 setCenter:CGPointMake( -2 * width , 0 ) ];
    [ self addSubview:view1 ];
    [ array addObject:view1 ];
    [ view1 release ];
    
    
    if ( n3 != 0 )
    {
        UIImageView* view = [ [ UIImageView alloc ] initWithImage:[ UIImage imageNamed:[ NSString stringWithFormat:@"%@%d" , name , n3 ] ] ];
        [ view setCenter:CGPointMake( -2 * width , 0 ) ];
        
        [ self addSubview:view ];
        [ array addObject:view ];
        [ view release ];
    }
    
    if ( n2 != 0 || n3 != 0 )
    {
        UIImageView* view = [ [ UIImageView alloc ] initWithImage:[ UIImage imageNamed:[ NSString stringWithFormat:@"%@%d" , name , n2 ] ] ];
        [ self addSubview:view ];
        [ view setCenter:CGPointMake( -1 * width , 0 ) ];
        [ array addObject:view ];
        [ view release ];
    }
    
    UIImageView* view = [ [ UIImageView alloc ] initWithImage:[ UIImage imageNamed:[ NSString stringWithFormat:@"%@%d" , name , n1 ] ] ];
    [ self addSubview:view ];
    [ view setCenter:CGPointMake( 0 , 0 ) ];
    [ array addObject:view ];
    [ view release ];
    
    if ( NumType == NT_CENTER )
    {
        int w = array.count * width * 0.5f;
        
        for ( int i = 0 ; i < array.count ; ++i )
        {
            int n = ( array.count - i );
            [ [ array objectAtIndex:i ] setCenter:CGPointMake( -n * width + w + width * 0.5f , 0 ) ];
        }
    }
    
    if ( [ name isEqualToString:@"bb" ] )
    {
        UIImageView* view = [ [ UIImageView alloc ] initWithImage:[ UIImage imageNamed:@"battleCritical" ] ];
        [ self addSubview:view ];
        [ view setCenter:CGPointMake( 0 , -view.frame.size.height * 1.1f ) ];
        [ array addObject:view ];
        [ view release ];
    }
    
    [ self.superview.superview addSubview:self.superview ];
}

- ( void ) clearNumber
{
    for ( int i = 0 ; i < array.count ; ++i )
    {
        [ [ array objectAtIndex:i ] removeFromSuperview ];
    }
    [ array removeAllObjects ];
    
}

- ( void ) changeNumber:( int )n
{
    if ( change )
    {
        [ self endChange ];
    }
    
    if ( number == n )
    {
        return;
    }
    
    
    numbers = number;
    numberc = n;
    
    add = numberc > number;
    
    change = 1;
    
    delayPer = 1.0f / ABS( numberc - number );
    delay = 0.0f;
}


- ( void ) initView:(NSString*)n :( int )w :( int )h
{
    width = w;
    height = h;
    
    [ name release ];
    name = n.copy;
    
    for ( int i = 0 ; i < array.count ; ++i )
    {
        [ [ array objectAtIndex:i ] removeFromSuperview ];
    }
    
    [ array removeAllObjects ];
    [ array release ];
    array = [ [ NSMutableArray alloc ] init ];
    
    NumType = NT_CENTER;
}


- ( void ) endChange
{
    [ self setNumber:numberc ];
    change = NO;
}


- ( void ) update:( float )d
{
    if ( !change )
    {
        return;
    }
    
    delay += d;
    
    
    if ( add )
    {
        number = numbers + delay / delayPer;
        [ self setNumber:number ];
        
        if ( number > numberc )
        {
            [ self endChange ];
        }
    }
    else
    {
        number = numbers - delay / delayPer;
        [ self setNumber:number ];
        
        if ( number < numberc )
        {
            [ self endChange ];
        }
    }
}

- ( void ) dealloc
{
    for ( int i = 0 ; i < array.count ; ++i )
    {
        [ [ array objectAtIndex:i ] removeFromSuperview ];
    }
    [ array removeAllObjects ];
    [ array release ];
    array = NULL;
    
    [ name release ];
    name = NULL;
    
    [ super dealloc ];
}




@end
