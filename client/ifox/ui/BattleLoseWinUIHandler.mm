//
//  BattleLoseWinUIHandler.m
//  sc
//
//  Created by fox on 13-8-25.
//
//

#import "BattleLoseWinUIHandler.h"
#import "GameSceneManager.h"
#import "BattleMapScene.h"

@implementation BattleLoseWinUIHandler


static BattleLoseWinUIHandler* gBattleLoseWinUIHandler;
+ ( BattleLoseWinUIHandler* ) instance
{
    if ( !gBattleLoseWinUIHandler )
    {
        gBattleLoseWinUIHandler = [ [ BattleLoseWinUIHandler alloc] init ];
        [ gBattleLoseWinUIHandler initUIHandler:@"BattleLoseWinUIView" isAlways:NO isSingle:YES ];
    }
    
    return gBattleLoseWinUIHandler;
}

- ( void ) show:( NSString* )name :( BOOL )win :( float )per
{
    [ self visible:YES ];
    
    
}

- ( void ) onInited
{
    [ super onInited ];
    
    UIButton* button = (UIButton*)[ view viewWithTag:2000 ];
    [ button addTarget:self action:@selector(onClick) forControlEvents:UIControlEventTouchUpInside ];
}

- ( void ) onClick
{
    [ self visible:NO ];
    
    if ( [ [ BattleMapScene instance ] checkEnd ] )
    {
        [ [ GameSceneManager instance ] activeScene:GS_WORLD ];
    }
}

@end
