//
//  BattleLevelUpUIHandler.m
//  sc
//
//  Created by fox on 13-9-7.
//
//

#import "BattleLevelUpUIHandler.h"

@implementation BattleLevelUpUIHandler



static BattleLevelUpUIHandler* gBattleLevelUpUIHandler;
+ (BattleLevelUpUIHandler*) instance
{
    if ( !gBattleLevelUpUIHandler )
    {
        gBattleLevelUpUIHandler = [ [ BattleLevelUpUIHandler alloc] init ];
        [ gBattleLevelUpUIHandler initUIHandler:@"BattleLevelUpView" isAlways:NO isSingle:NO ];
    }
    
    return gBattleLevelUpUIHandler;
}


- ( void ) onInited
{
    for ( int i = 0 ; i < 15 ; i++ )
    {
        upView[ i ] = (UIImageView*)[ view viewWithTag:200 ];
        label[ i ] = (UILabel*)[ view viewWithTag:100 ];
        upLabel[ i ] = (UILabel*)[ view viewWithTag:300 ];
    }
    
    for ( int i = 0 ; i < 15 ; i++ )
    {
        [ upView[ i ] setHidden:YES ];
        [ upLabel[ i ] setHidden:YES ];
    }
}


- ( void ) onClosed
{
    
}


- ( void ) setData:( CreatureCommonData* )c1 :( CreatureCommonData* )c2
{
    for ( int i = 0 ; i < 15 ; i++ )
    {
        [ upView[ i ] setHidden:YES ];
        [ upLabel[ i ] setHidden:YES ];
    }
    
    
}

@end
