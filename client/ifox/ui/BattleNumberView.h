//
//  BattleNumberView.h
//  sc
//
//  Created by fox on 13-5-5.
//
//

#import <UIKit/UIKit.h>

enum NumberType
{
    NT_NORMAL = 0,
    NT_CENTER,
};

@interface BattleNumberView : UIView
{
    int number;
    
    int width;
    int height;
    
    NSString* name;
    
    NSMutableArray* array;
    
    int numbers;
    int numberc;
    int add;
    BOOL change;
    float delay;
    float delayPer;
    
}

@property ( nonatomic ) int NumType;

- ( void ) changeNumber:( int )n;

- ( void ) update:( float )d;

- ( int ) getNumber;
- ( void ) setNumber:( int )n;
- ( void ) clearNumber;

- ( void ) initView:(NSString*)n :( int )w :( int )h;


@end
