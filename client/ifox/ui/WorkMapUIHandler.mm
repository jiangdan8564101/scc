//
//  WorkMapUIHandler.m
//  sc
//
//  Created by fox on 13-1-15.
//
//

#import "WorkMapUIHandler.h"
#import "GameSceneManager.h"
#import "ItemListUIHandler.h"
#import "AlchemyUIHandler.h"
#import "ShopUIHandler.h"
#import "ProfessionUIHandler.h"
#import "WorkOutlayUIHandler.h"
//#import "InfoStoryUIHandler.h"
#import "InfoEmployUIHandler.h"
#import "InfoMonsterUIHandler.h"
#import "PlayerData.h"
#import "TalkUIHandler.h"

@implementation WorkMapUIHandler


static WorkMapUIHandler* gWorkMapUIHandler;
+ (WorkMapUIHandler*) instance
{
    if ( !gWorkMapUIHandler )
    {
        gWorkMapUIHandler = [ [ WorkMapUIHandler alloc] init ];
        [ gWorkMapUIHandler initUIHandler:@"WorkMapUIView" isAlways:YES isSingle:NO ];
    }
    
    return gWorkMapUIHandler;
}


- ( void ) onInited
{
    [ super onInited ];
    
    [ view setCenter:CGPointMake( view.frame.size.width * 0.5f , SCENE_HEIGHT * 0.5f ) ];
    
    for ( int i = 0 ; i < 5 ; i++ )
    {
        mainbutton[ i ] = ( UIButton* )[ view viewWithTag:100 + i ];
    }
    
    [ mainbutton[ 0 ] addTarget:self action:@selector(onInfoClick) forControlEvents:UIControlEventTouchUpInside ];
    [ mainbutton[ 1 ] addTarget:self action:@selector(onWorkClick) forControlEvents:UIControlEventTouchUpInside ];
    [ mainbutton[ 2 ] addTarget:self action:@selector(onItemClick) forControlEvents:UIControlEventTouchUpInside ];
    [ mainbutton[ 3 ] addTarget:self action:@selector(onSettingClick) forControlEvents:UIControlEventTouchUpInside ];
    [ mainbutton[ 4 ] addTarget:self action:@selector(onGoTownClick) forControlEvents:UIControlEventTouchUpInside ];
    
    
    for ( int i = 0 ; i < 5 ; i++ )
    {
        workButton[ i ] = ( UIButton* )[ view viewWithTag:200 + i ];
        [ workButton[ i ] setHidden:YES ];
    }
    [ workButton[ 0 ] setHidden:YES ];
    
    [ workButton[ 1 ] addTarget:self action:@selector(onAlchemyClick) forControlEvents:UIControlEventTouchUpInside ];
    [ workButton[ 2 ] addTarget:self action:@selector(onClothClick) forControlEvents:UIControlEventTouchUpInside ];
    [ workButton[ 3 ] addTarget:self action:@selector(onOutlayClick) forControlEvents:UIControlEventTouchUpInside ];
    [ workButton[ 4 ] addTarget:self action:@selector(onReturnClick) forControlEvents:UIControlEventTouchUpInside ];
    
    
    for ( int i = 0 ; i < 5 ; i++ )
    {
        infoButton[ i ] = ( UIButton* )[ view viewWithTag:300 + i ];
        [ infoButton[ i ] setHidden:YES ];
    }
    [ infoButton[ 0 ] addTarget:self action:@selector(onInfoStoryClick) forControlEvents:UIControlEventTouchUpInside ];
    [ infoButton[ 1 ] addTarget:self action:@selector(onInfoEmployClick) forControlEvents:UIControlEventTouchUpInside ];
    [ infoButton[ 2 ] addTarget:self action:@selector(onInfoMonsterClick) forControlEvents:UIControlEventTouchUpInside ];
    [ infoButton[ 3 ] addTarget:self action:@selector(onInfoBackClick) forControlEvents:UIControlEventTouchUpInside ];
}

- ( void ) onInfoEmployClick
{
    [ [ InfoEmployUIHandler instance ] visible:YES ];
    
    playSound( PST_OK );
}

- ( void ) onInfoMonsterClick
{
    [ [ InfoMonsterUIHandler instance ] visible:YES ];
    
    playSound( PST_OK );
}

- ( void ) onInfoStoryClick
{
    //[ [ InfoStoryUIHandler instance ] visible:YES ];
    
    //playSound( PST_OK );
}

- ( void ) onInfoBackClick
{
    [ self enableMain:YES ];
    [ self hiddenWork:YES ];
    [ self hiddenInfo:YES ];
    
    for ( int i = 0 ; i < 5 ; i++ )
    {
        [ mainbutton[ i ] setHidden:NO ];
    }
    
    playSound( PST_CANCEL );
}

- ( void ) onGoTownClick
{
    [ [ GameSceneManager instance ] activeScene:GS_CITY ];
    
    playSound( PST_CANCEL );
}


- ( void ) onSettingClick
{
    playSound( PST_OK );
}

- ( void ) onItemClick
{
    [ [ ItemListUIHandler instance ] visible:YES ];
    
    playSound( PST_OK );
    //[ [ CreatureListUIHandler instance ] visible:YES ];
}


- ( void ) onInfoClick
{
    [ self enableMain:YES ];
    [ self hiddenWork:YES ];
    [ self hiddenInfo:NO ];
    
    for ( int i = 0 ; i < 5 ; i++ )
    {
        [ mainbutton[ i ] setHidden:YES ];
    }
    
    playSound( PST_OK );
}


- ( void ) hiddenWork:( BOOL )b
{
    for ( int i = 0 ; i < 5 ; i++ )
    {
        [ workButton[ i ] setHidden:b ];
    }
}

- ( void ) hiddenInfo:( BOOL )b
{
    for ( int i = 0 ; i < 5 ; i++ )
    {
        [ infoButton[ i ] setHidden:b ];
    }
}

- ( void ) enableMain:( BOOL )b
{
    for ( int i = 0 ; i < 5 ; i++ )
    {
        [ mainbutton[ i ] setEnabled:b ];
    }
}


- ( void ) onOutlayClick
{
    [ [ WorkOutlayUIHandler instance ] visible:YES ];
    //[ [ WorkOutlayUIHandler instance ] showPay ];
    [ [ WorkOutlayUIHandler instance ] updateData:[ [ PlayerData instance ] getDay ] ];
    
    playSound( PST_OK );
}


- ( void ) onWorkClick
{
    [ self enableMain:NO ];
    [ self hiddenWork:NO ];
    [ self hiddenInfo:YES ];
    
    playSound( PST_OK );
}


- ( void ) onReturnClick
{
    [ self enableMain:YES ];
    [ self hiddenWork:YES ];
    [ self hiddenInfo:YES ];
    
    playSound( PST_CANCEL );
}


- ( void ) onAlchemyClick
{
    //[ [ ProfessionUIHandler instance ] visible:YES ];
    //[ [ ShopUIHandler instance ] visible:YES ];
    [ [ AlchemyUIHandler instance ] visible:YES ];
    
    playSound( PST_OK );
}

- ( void ) onClothClick
{
    [ [ TalkUIHandler instance ] visible:YES ];
    [ [ TalkUIHandler instance ] setData:SOT_NOTOPEN8 ];
    playSound( PST_ERROR );
}


@end
