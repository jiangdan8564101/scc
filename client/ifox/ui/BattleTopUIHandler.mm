//
//  BattleTopUIHandler.m
//  sc
//
//  Created by fox on 13-2-13.
//
//

#import "BattleTopUIHandler.h"
#import "GameSceneManager.h"
#import "GameDataManager.h"
#import "BattleNetHandler.h"
#import "BattleStage.h"
#import "TalkUIHandler.h"
#import "GuideConfig.h"
#import "PlayerData.h"
#import "BattleMapScene.h"

@implementation BattleTopUIHandler


static BattleTopUIHandler* gBattleTopUIHandler;
+ (BattleTopUIHandler*) instance
{
    if ( !gBattleTopUIHandler )
    {
        gBattleTopUIHandler = [ [ BattleTopUIHandler alloc] init ];
        [ gBattleTopUIHandler initUIHandler:@"BattleTopUIView" isAlways:YES isSingle:NO ];
    }
    
    return gBattleTopUIHandler;
}


- ( void ) addADB
{
    if ( ADBView )
    {
        [ ADBView removeFromSuperview ];
        [ ADBView release ];
        ADBView = NULL;
    }
    
    ADBView = [ [ ADBannerView alloc]initWithFrame:CGRectMake( 0.0f , 0.0f , 0.0f , 0.0f ) ];
    
    ADBView.requiredContentSizeIdentifiers = [ NSSet setWithObjects:ADBannerContentSizeIdentifierPortrait, ADBannerContentSizeIdentifierLandscape, nil];
    
    ADBView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
    
    ADBView.delegate = self;
    
    //ADBView.userInteractionEnabled = NO;
    
    float w = view.frame.size.width;
    float h = ADBView.frame.size.height;
    
    [ view addSubview:ADBView ];
    
    ADBView.frame = CGRectMake( 0.0f , 0.0f , w , h );
    
    CGRect rect = ADBView.frame;
    ADBView.frame = CGRectMake( ( w - rect.size.width ) * 0.5f , 0.0f , rect.size.width , rect.size.height );
    
    ADBView.hidden = YES;
}

- ( void ) onInited
{
    [ view setCenter:CGPointMake( SCENE_WIDTH * 0.5f , view.frame.size.height * 0.5f ) ];
    
    UIButton* button = (UIButton*)[ view viewWithTag:1000 ];
    [ button addTarget:self action:@selector(onOut) forControlEvents:UIControlEventTouchUpInside ];
    
    imageView = (UIImageView*)[ view viewWithTag:1002 ];
    
    width = imageView.frame.size.width;
    
    for ( int i = 0 ; i < MAX_BATTLE_LAYER ; ++i )
    {
        UIButton* button = (UIButton*)[ view viewWithTag:2000 + i ];
        
        [ button addTarget:self action:@selector(onSendClick:) forControlEvents:UIControlEventTouchUpInside ];
    }
    
    button = (UIButton*)[ view viewWithTag:3000 ];
    [ button addTarget:self action:@selector(onSpeed) forControlEvents:UIControlEventTouchUpInside ];
    
//    button = (UIButton*)[ view viewWithTag:1001 ];
//    [ button addTarget:self action:@selector(onEnd) forControlEvents:UIControlEventTouchUpInside ];
//    
//    button = (UIButton*)[ view viewWithTag:1200 ];
//    [ button addTarget:self action:@selector(onItem) forControlEvents:UIControlEventTouchUpInside ];
//    
//    button = (UIButton*)[ view viewWithTag:1201 ];
//    [ button addTarget:self action:@selector(onLoseWin) forControlEvents:UIControlEventTouchUpInside ];
//    
//    button = (UIButton*)[ view viewWithTag:1202 ];
//    [ button addTarget:self action:@selector(onSetting) forControlEvents:UIControlEventTouchUpInside ];
}


- (void)bannerViewActionDidFinish:(ADBannerView *)banner
{
    [ ADBView removeFromSuperview ];
    [ ADBView release ];
    ADBView = NULL;
}


- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    NSLog( @"%@" , error );
}

- ( void ) onOpened
{
    [ self updateSpeed ];
    
    [ self addADB ];
}

- ( void ) onClosed
{
    
}


- ( void ) onEnd
{
    
}

- ( void ) onOut
{
    if ( ![ [ GameDataManager instance ] getBuyItem ] && ADBView.hidden )
    {
        ADBView.hidden = NO;
        return;
    }
    
    GuideConfigData* data = [ [ GuideConfig instance ] getData:SOT_HOME ];
    
    if ( data.NextStory > [ PlayerData instance ].Story )
    {
        [ [ TalkUIHandler instance ] visible:YES ];
        [ [ TalkUIHandler instance ] setData:SOT_NOTOPEN1 ];
        return;
    }
    
    [ [ GameSceneManager instance ] activeScene:GS_WORLD ];
}

- ( void ) onSpeed
{
    if ( ![ [ GameDataManager instance ] getBuyItem ] && ADBView.hidden )
    {
        ADBView.hidden = NO;
        return;
    }
    
    if ( GAME_SPEED == 1.0f )
    {
        GAME_SPEED = 1.5f;
    }
    else if ( GAME_SPEED == 1.5f )
    {
        GAME_SPEED = 2.0f;
    }
    else
    {
        GAME_SPEED = 1.0f;
    }
    
    [ PlayerData instance ].BattleSpeed = GAME_SPEED;
    [ self updateSpeed ];
}

- ( void ) onItem
{
    
}
- ( void ) onLoseWin
{
    
}
- ( void ) onSetting
{
    
}

- ( void ) onSendClick:(UIButton*)button
{
    [ [ BattleMapScene instance ] activeLayer:button.tag - 2000 ];
}


- ( void ) setPer:( float )p
{
    UILabel* label = (UILabel*)[ view viewWithTag:1001 ];
    [ label setText:[ NSString stringWithFormat:@"%.0f%%" , p * 100.0f ] ];
    
    CGRect rect = imageView.frame;
    rect.size.width = width * ( p );
    [ imageView setFrame:rect ];
}

- ( void ) updateData
{
    //
}

- ( void ) updateSpeed
{
    UIButton* button = (UIButton*)[ view viewWithTag:3000 ];
    
    if ( GAME_SPEED == 1.0f )
    {
        [ button setTitle:NSLocalizedString( @"GameSpeed1" , nil ) forState:UIControlStateNormal ];
    }
    else if ( GAME_SPEED == 1.5f )
    {
        [ button setTitle:NSLocalizedString( @"GameSpeed2" , nil ) forState:UIControlStateNormal ];
    }
    else
    {
        [ button setTitle:NSLocalizedString( @"GameSpeed4" , nil ) forState:UIControlStateNormal ];
    }
}


- ( void ) setSendData:( int )c
{
    for ( int i = 0 ; i < MAX_BATTLE_LAYER ; ++i )
    {
        UIButton* button = (UIButton*)[ view viewWithTag:2000 + i ];
        [ button setHidden:YES ];
    }
    
    if ( c == 1 )
    {
        return;
    }
    
    for ( int i = 0 ; i < c ; ++i )
    {
        UIButton* button = (UIButton*)[ view viewWithTag:2000 + i ];
        [ button setHidden:NO ];
    }
}

@end
