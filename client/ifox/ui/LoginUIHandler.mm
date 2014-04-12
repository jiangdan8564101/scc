//
//  LoginUIHandler.m
//  sc
//
//  Created by fox on 12-10-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LoginUIHandler.h"
#import "GameMain.h"
#import "GameLogin.h"
#import "GameVideoManager.h"
#import "LoginNetHandler.h"
#import "BattleAttackUIHandler.h"
#import "PlayerData.h"
#import "GameAudioManager.h"
#import "UIEffectAction.h"
#import "GameDataManager.h"
#import "AlertUIHandler.h"
#import "PlayerEmployData.h"
#import "ItemData.h"
#import "AlarmUIHandler.h"
#import "PlayerCreatureData.h"


@implementation LoginUIHandler


static LoginUIHandler* gLoginUIHandler;
+ (LoginUIHandler*) instance
{
    if ( !gLoginUIHandler )
    {
        gLoginUIHandler = [ [ LoginUIHandler alloc] init ];
        [ gLoginUIHandler initUIHandler:@"LoginUIView" isAlways:YES isSingle:NO ];
    }
    
    return gLoginUIHandler;
}


- ( void ) onInited
{
    [ super onInited ];
    
    newGameButton = (UIButton*)[ view viewWithTag:100 ];
    [ newGameButton addTarget:self action:@selector( onNewGame ) forControlEvents:UIControlEventTouchUpInside ];
    
    loadGameButton = (UIButton*)[ view viewWithTag:200 ];
    [ loadGameButton addTarget:self action:@selector( onLoadGame ) forControlEvents:UIControlEventTouchUpInside ];
    
    [ UIView beginAnimations:@"fade in login" context:nil ];
    [ UIView setAnimationDuration:1.0f ];
    [ UIView setAnimationDelegate:self ];
    [ UIView setAnimationCurve:UIViewAnimationCurveEaseIn ];
    newGameButton.alpha = 1.0f;
    loadGameButton.alpha = 1.0f;
    [ UIView commitAnimations ];
    
    UILabel* label1 = (UILabel*)[ view viewWithTag:1001 ];
    [ label1 setText:NSLocalizedString( @"GameLogin1", nil ) ];
    UIButton* label2 = (UIButton*)[ view viewWithTag:1002 ];
    [ label2 setTitle:NSLocalizedString( @"GameLogin2", nil ) forState:UIControlStateNormal ];
    [ label2 addTarget:self action:@selector( onNewGame1 ) forControlEvents:UIControlEventTouchUpInside ];
    
    UIButton* label3 = (UIButton*)[ view viewWithTag:1003 ];
    [ label3 setTitle:NSLocalizedString( @"GameLogin3", nil ) forState:UIControlStateNormal ];
    [ label3 addTarget:self action:@selector( onNewGame2 ) forControlEvents:UIControlEventTouchUpInside ];
    UITextView* label4 = (UITextView*)[ view viewWithTag:1004 ];
    [ label4 setText:NSLocalizedString( @"GameLogin4", nil ) ];
    
    UIButton* label5 = (UIButton*)[ view viewWithTag:1005 ];
    [ label5 addTarget:self action:@selector( onCancel1 ) forControlEvents:UIControlEventTouchUpInside ];

    
    [ [ GameAudioManager instance ] playMusic:@"BGM013" :0 ];
}

- ( void ) onCancel1
{
    UIView* view1 = (UIView*)[ view viewWithTag:1000 ];
    view1.hidden = YES;
}


- ( void ) onNewGame1
{
    [ [ PlayerEmployData instance ] employCreature:MAIN_PLAYER_ID1 ];
    CreatureCommonData* comm = [ [ PlayerCreatureData instance ] getCommonDataWithID:MAIN_PLAYER_ID1 ];
    [ [ PlayerCreatureData instance ] addMember:0 :0 :comm.cID ];
    comm.Team = 0;
    
    [ [ PlayerEmployData instance ] reloadData ];
    
    [ PlayerData instance ].Gold = 500;
    
    [ [ GameDataManager instance ] saveData ];
    
    [ [ ItemData instance ] addItem:HP_ITEM :50 ];
    
    int ii = [ [ GameDataManager instance ] getBuyItem ];
    if ( ii )
    {
        [ [ ItemData instance ] addItem:SPECIAL_ITEM :ii ];
    }
    
    [ [ GameMain instance ] initGameMain ];
    
    
    [ self visible:NO ];
}

- ( void ) onNewGame2
{
    [ [ PlayerEmployData instance ] employCreature:MAIN_PLAYER_ID1 ];
    CreatureCommonData* comm = [ [ PlayerCreatureData instance ] getCommonDataWithID:MAIN_PLAYER_ID1 ];
    [ [ PlayerCreatureData instance ] addMember:0 :0 :comm.cID ];
    comm.Team = 0;
    
    [ [ PlayerEmployData instance ] employCreature:MAIN_PLAYER_ID2 ];
    //[ [ PlayerEmployData instance ] employCreature:MAIN_PLAYER_ID3 ];
    [ [ PlayerEmployData instance ] employCreature:MAIN_PLAYER_ID4 ];
    
    [ PlayerData instance ].Gold = 500;
    [ PlayerData instance ].Story = FREE_MODE_STORY;
    
    int ii = [ [ GameDataManager instance ] getBuyItem ];
    if ( ii )
    {
        [ [ ItemData instance ] addItem:SPECIAL_ITEM :ii ];
    }
    
    [ [ ItemData instance ] addItem:WORK_RANK_ITEM :1 ];
    [ [ ItemData instance ] addItem:HP_ITEM :50 ];
    
    [ [ PlayerEmployData instance ] reloadData ];
    
    [ [ GameDataManager instance ] saveData ];
    
    [ [ GameMain instance ] initGameMain ];
    
    [ self visible:NO ];
}

- ( void ) onNewGame
{
    BOOL b = [ [ GameDataManager instance ] hasData ];
    
    if ( b )
    {
        [ [AlarmUIHandler instance ] alarm:NSLocalizedString( @"GameLogin6", nil ) :self :@selector(onNewGame11) :nil :nil ];
    }
    else
    {
        [ self onNewGame11 ];
    }
}

- ( void ) onNewGame11
{
    UIView* view1 = (UIView*)[ view viewWithTag:1000 ];
    view1.alpha = 0.0f;
    view1.hidden = NO;
    
    [ UIView beginAnimations:@"fade in login1" context:nil ];
    [ UIView setAnimationDuration:0.5f ];
    [ UIView setAnimationDelegate:self ];
    [ UIView setAnimationCurve:UIViewAnimationCurveEaseIn ];
    view1.alpha = 1.0f;
    [ UIView commitAnimations ];
}


- ( void ) onLoadGame
{
    BOOL b = [ [ GameDataManager instance ] readData ];
    
    if ( b )
    {
        [ [ GameAudioManager instance ] playSound:@"D0116" ];
        
        [ [ GameLogin instance ] releaseGameLogin ];
        [ [ GameMain instance ] initGameMain ];
        
        [ self visible:NO ];
    }
    else
    {
        [ [ AlertUIHandler instance ] alert:NSLocalizedString( @"GameLogin5", nil ) ];
    }
}



@end



