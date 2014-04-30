//
//  TimeUIHandler.m
//  sc
//
//  Created by fox on 13-9-8.
//
//

#import "TimeUIHandler.h"
#import "PlayerData.h"
#import "TalkUIHandler.h"
#import "GameSceneManager.h"
#import "CatUIHandler.h"
#import "GameCenterFile.h"

@implementation TimeUIHandler




static TimeUIHandler* gTimeUIHandler;
+ (TimeUIHandler*) instance
{
    if ( !gTimeUIHandler )
    {
        gTimeUIHandler = [ [ TimeUIHandler alloc] init ];
        [ gTimeUIHandler initUIHandler:@"TimeUIView" isAlways:YES isSingle:NO ];
        
    }
    
    return gTimeUIHandler;
}


- ( void ) onInited
{
    UIButton* button = (UIButton*)[ view viewWithTag:1000 ];
    [ button addTarget:self action:@selector(onGo1) forControlEvents:UIControlEventTouchUpInside ];
    button = (UIButton*)[ view viewWithTag:1001 ];
    [ button addTarget:self action:@selector(onGo3) forControlEvents:UIControlEventTouchUpInside ];
    
    button = (UIButton*)[ view viewWithTag:1002 ];
    [ button addTarget:self action:@selector(onCat) forControlEvents:UIControlEventTouchUpInside ];
    
    button = (UIButton*)[ view viewWithTag:1003 ];
    [ button addTarget:self action:@selector(onGameCenter) forControlEvents:UIControlEventTouchUpInside ];
    
    
    
    [ view setCenter:CGPointMake( view.frame.size.width * 0.5f , view.frame.size.height * 0.5f ) ];
}


- ( void ) updateData
{
    UILabel* label = (UILabel*)[ view viewWithTag:2000 ];
    [ label setText:[ NSString stringWithFormat:@"%d" , [ PlayerData instance ].Year ] ];
    label = (UILabel*)[ view viewWithTag:2001 ];
    [ label setText:[ NSString stringWithFormat:@"%d" , [ PlayerData instance ].Month ] ];
    label = (UILabel*)[ view viewWithTag:2002 ];
    [ label setText:[ NSString stringWithFormat:@"%d" , [ PlayerData instance ].Day ] ];
    
    if ( [ PlayerData instance ].GoPay )
    {
        [ [ GameSceneManager instance ] activeScene:GS_ASSOCIATION ];
        
    }
}


- ( void ) onCat
{
    [ [ CatUIHandler instance ] visible:YES ];
}


- ( void ) onGameCenter
{
    [ [ GameKitHelper sharedGameKitHelper ] showGameCenter ];
    //[ [ GameKitHelper sharedGameKitHelper ] showLeaderboard ];
}

- ( void ) onGo1
{
    [ [ PlayerData instance ] goDate:1 ];
    [ self updateData ];
}

- ( void ) onGo3
{
    [ [ PlayerData instance ] goDate:3 ];
    [ self updateData ];
}

- ( void ) onOpened
{
    [ super onOpened ];
    [ self updateData ];
}

- ( void ) onClosed
{
    [ super onClosed ];
}



@end
