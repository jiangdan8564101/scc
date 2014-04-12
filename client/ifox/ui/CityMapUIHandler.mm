//
//  CityMapUIHandler.m
//  sc
//
//  Created by fox on 13-1-13.
//
//

#import "CityMapUIHandler.h"
#import "GameSceneManager.h"
#import "TalkUIHandler.h"

#import "GuideConfig.h"
#import "PlayerData.h"
#import "AlertUIHandler.h"
#import "ItemData.h"
#import "BattleMapScene.h"



@implementation CityMapUIHandler

static CityMapUIHandler* gCityMapUIHandler;
+ ( CityMapUIHandler* ) instance
{
    if ( !gCityMapUIHandler )
    {
        gCityMapUIHandler = [ [ CityMapUIHandler alloc ] init ];
        [ gCityMapUIHandler initUIHandler:@"CityMapUIView" isAlways:YES isSingle:NO ];
    }
    
    return gCityMapUIHandler;
}


- ( void ) onInited
{
    UIButton* button = (UIButton*)[ view viewWithTag:100 ];
    [ button addTarget:self action:@selector(onWorldTouchUp) forControlEvents:UIControlEventTouchUpInside ];
    
    button = (UIButton*)[ view viewWithTag:101 ];
    [ button addTarget:self action:@selector(onWorkTouchUp) forControlEvents:UIControlEventTouchUpInside ];
    
    button = (UIButton*)[ view viewWithTag:102 ];
    [ button addTarget:self action:@selector(onPublicTouchUp) forControlEvents:UIControlEventTouchUpInside ];
    
    button = (UIButton*)[ view viewWithTag:103 ];
    [ button addTarget:self action:@selector(onShopTouchUp) forControlEvents:UIControlEventTouchUpInside ];
    
    button = (UIButton*)[ view viewWithTag:104 ];
    [ button addTarget:self action:@selector(onProTouchUp) forControlEvents:UIControlEventTouchUpInside ];
    
    button = (UIButton*)[ view viewWithTag:105 ];
    [ button addTarget:self action:@selector(onAssTouchUp) forControlEvents:UIControlEventTouchUpInside ];

    button = (UIButton*)[ view viewWithTag:99 ];
    [ button addTarget:self action:@selector(onSpecialTouchUp) forControlEvents:UIControlEventTouchUpInside ];
    
    [ super onInited ];
    
    //[ [ TalkUIHandler instance ] visible:YES ];
    //[ [ TalkUIHandler instance ] setData:0 ];
}

- ( void ) onOpened
{
    [ super onOpened ];
    
    UIButton* button = (UIButton*)[ view viewWithTag:99 ];
    
    PackItemData* data = [ [ ItemData instance ] getItem:SPECIAL_ITEM ];
    button.hidden = data.Number <= 0;
}

- ( void )animationFinished
{
    [ view setAlpha:1.0f ];
}


- ( void ) onClosed
{
    [ super onClosed ];
}

- ( void ) onSpecialTouchUp
{
    PackItemData* data = [ [ ItemData instance ] getItem:SPECIAL_ITEM ];
    
    if ( data.Number > 0 )
    {
        [ [ ItemData instance ] sellItem:SPECIAL_ITEM :1 ];
        
        [ [ BattleMapScene instance ] loadSP ];
        [ [ GameSceneManager instance ] activeScene:GS_BATTLE ];
    }
    
}


- ( void ) onPublicTouchUp
{
//    GuideConfigData* data = [ [ GuideConfig instance ] getData:SOT_PUBLIC ];
//    
//    if ( data.Story > [ PlayerData instance ].Story )
//    {
//        [ [ TalkUIHandler instance ] visible:YES ];
//        [ [ TalkUIHandler instance ] setData:SOT_NOTOPEN ];
//        return;
//    }
    
    [ [ GameSceneManager instance ] activeScene:GS_PUBLIC ];
    playSound( PST_OK );
}

- ( void ) onWorkTouchUp
{
    GuideConfigData* data = [ [ GuideConfig instance ] getData:SOT_HOME ];
    
    if ( data.NextStory > [ PlayerData instance ].Story )
    {
        [ [ TalkUIHandler instance ] visible:YES ];
        [ [ TalkUIHandler instance ] setData:SOT_NOTOPEN1 ];
        playSound( PST_CANCEL );
        return;
    }
    playSound( PST_OK );
    [ [ GameSceneManager instance ] activeScene:GS_WORK ];
}

- ( void )onWorldTouchUp
{
    GuideConfigData* data = [ [ GuideConfig instance ] getData:SOT_WORLD ];
    
    if ( data.NextStory > [ PlayerData instance ].Story )
    {
        [ [ TalkUIHandler instance ] visible:YES ];
        [ [ TalkUIHandler instance ] setData:SOT_NOTOPEN0 ];
        return;
    }
    
    [ [ GameSceneManager instance ] activeScene:GS_WORLD ];
}

- ( void )onShopTouchUp
{
    [ [ GameSceneManager instance ] activeScene:GS_SHOP ];
    playSound( PST_OK );
}

- ( void )onProTouchUp
{
    GuideConfigData* data = [ [ GuideConfig instance ] getData:SOT_PROFESSION ];
    
    if ( data.NextStory > [ PlayerData instance ].Story )
    {
        [ [ TalkUIHandler instance ] visible:YES ];
        [ [ TalkUIHandler instance ] setData:SOT_NOTOPEN4 ];
        
        playSound( PST_ERROR );
        return;
    }
    
    playSound( PST_OK );
    
    [ [ GameSceneManager instance ] activeScene:GS_PROFESSION ];
}


- ( void ) onAssTouchUp
{
    GuideConfigData* data = [ [ GuideConfig instance ] getData:SOT_ASSOCIATION ];
    
    if ( data.NextStory > [ PlayerData instance ].Story )
    {
        [ [ TalkUIHandler instance ] visible:YES ];
        [ [ TalkUIHandler instance ] setData:SOT_NOTOPEN8 ];
        playSound( PST_ERROR );
        return;
    }
    playSound( PST_OK );
    [ [ GameSceneManager instance ] activeScene:GS_ASSOCIATION ];
}


@end



