//
//  BattleLogUIHandler.m
//  sc
//
//  Created by fox on 13-9-1.
//
//

#import "BattleLogUIHandler.h"
#import "CreatureConfig.h"
#import "BattleMapScene.h"

@implementation BattleLogUIHandler



static BattleLogUIHandler* gBattleLogUIHandler;
+ ( BattleLogUIHandler* ) instance
{
    if ( !gBattleLogUIHandler )
    {
        gBattleLogUIHandler = [ [ BattleLogUIHandler alloc ] init ];
        [ gBattleLogUIHandler initUIHandler:@"BattleLogUIView" isAlways:YES isSingle:NO ];
    }
    
    return gBattleLogUIHandler;
}

- ( void ) onInited
{
    webView = ( ChatUIWebView* )[ view viewWithTag:1000 ];
    [ webView initChatUIWebView ];
    
    battleView = [ view viewWithTag:2000 ];
    battleView.hidden = YES;
    
    for ( int i = 0 ; i < MAX_BATTLE_ENEMY ; i++ )
    {
        enemyView[ i ] = ( BattleEnemyView* )[ view viewWithTag:2100 + i ];
        [ enemyView[ i ] initBattleEnemyView ];
    }
    
    for ( int i = 0 ; i < MAX_BATTLE_ENEMY ; i++ )
    {
        selfView[ i ] = ( BattleCreatureView* )[ view viewWithTag:3000 + i ];
        [ selfView[ i ] initBattleCreatureView ];
    }

    whiteView = [ view viewWithTag:5555 ];
    whiteView.alpha = 0.0f;
}


- ( void ) onClosed
{
    //[ self endFight ];
}

- ( void ) startFightMovie:( NSObject* )obj :( SEL )s
{
    fadeTime = 0;
    
    object = obj;
    sel = s;
    
    [ self fadeOut ];
}

- ( void ) fightEffectCritical
{
    if ( [ [ BattleMapScene instance ] getActiveLogUI ] != self )
    {
        return;
    }
    
    [ UIView animateWithDuration:0.05f / GAME_SPEED animations:^{
        view.center = CGPointMake( view.center.x, view.center.y + 25.0f );
    } completion:^(BOOL finished) {
        [ UIView animateWithDuration:0.05f / GAME_SPEED animations:^{
            view.center = CGPointMake( view.center.x, view.center.y - 25.0f );
        } completion:^(BOOL finished) {
            [ UIView animateWithDuration:0.07f / GAME_SPEED animations:^{
                view.center = CGPointMake( view.center.x, view.center.y + 20.0f );
            } completion:^(BOOL finished) {
                [ UIView animateWithDuration:0.08f / GAME_SPEED animations:^{
                    view.center = CGPointMake( view.center.x, view.center.y - 20.0f );
                } completion:^(BOOL finished) {
                    
                }];
            }];
        }];
    }];
    
    
//    UIImageView* imageView = (UIImageView*)[ view viewWithTag:11000 ];
//    [ imageView setAlpha:1.0f ];
//    imageView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
//    
//    [ UIView beginAnimations:@"fightEffectCritical" context:nil ];
//    [ UIView setAnimationDuration:0.4f ];
//    [ imageView setAlpha:0.0f ];
//    imageView.transform = CGAffineTransformMakeScale(3.1f, 3.1f);
//    [ UIView commitAnimations ];
}

- ( void ) fadeOut
{
    whiteView.userInteractionEnabled = YES;
    
    whiteView.alpha = 1.0f;
    
    [ UIView beginAnimations:@"fade out" context:nil ];
    [ UIView setAnimationDuration:0.1f / GAME_SPEED ];
    [ UIView setAnimationDelegate:self ];
    [ UIView setAnimationDidStopSelector:@selector(animationFadeOutFinished) ];
    [ UIView setAnimationCurve:UIViewAnimationCurveEaseIn ];
    
    whiteView.alpha = 0.9f;
    
    [ UIView commitAnimations ];
    
    fadeTime++;
}

- ( void ) animationFadeOutFinished
{
    if ( fadeTime > 0 )
    {
        whiteView.userInteractionEnabled = YES;
        
        whiteView.alpha = 0.9f;
        
        [ UIView beginAnimations:@"fade out1" context:nil ];
        [ UIView setAnimationDuration:0.3f / GAME_SPEED ];
        [ UIView setAnimationDelegate:self ];
        [ UIView setAnimationDidStopSelector:@selector(animationFadeOut1Finished) ];
        [ UIView setAnimationCurve:UIViewAnimationCurveEaseIn ];
        
        whiteView.alpha = 0.0f;
        
        [ UIView commitAnimations ];
        return;
    }

    
    whiteView.userInteractionEnabled = YES;
    
    whiteView.alpha = 0.5f;
    
    [ UIView beginAnimations:@"fade in" context:nil ];
    [ UIView setAnimationDuration:0.1f / GAME_SPEED ];
    [ UIView setAnimationDelegate:self ];
    [ UIView setAnimationDidStopSelector:@selector(animationFadeInFinished) ];
    [ UIView setAnimationCurve:UIViewAnimationCurveEaseIn ];
    
    whiteView.alpha = 1.0f;
    
    [ UIView commitAnimations ];
    
    fadeTime++;
}

- ( void ) animationFadeInFinished
{
    if ( fadeTime > 0 )
    {
        whiteView.userInteractionEnabled = YES;
        
        whiteView.alpha = 1.0f;
        
        [ UIView beginAnimations:@"fade out1" context:nil ];
        [ UIView setAnimationDuration:0.3f / GAME_SPEED ];
        [ UIView setAnimationDelegate:self ];
        [ UIView setAnimationDidStopSelector:@selector(animationFadeOut1Finished) ];
        [ UIView setAnimationCurve:UIViewAnimationCurveEaseIn ];
        
        whiteView.alpha = 0.0f;
        
        [ UIView commitAnimations ];
        return;
    }
    
    [ self fadeOut ];
}

- ( void ) animationFadeOut1Finished
{
    whiteView.userInteractionEnabled = NO;
    
    [ object performSelector:sel withObject:nil ];

    object = NULL;
    sel = NULL;
}

- ( void ) onRelease
{
    [ webView releaseChatUIWebView ];
    webView = NULL;
}

- ( void ) startSelfFight:( int )index
{
    [ selfView[ index ] startFight ];
}

- ( void ) startEnemyFight:( int )index
{
    [ enemyView[ index ] startFight ];
}

- ( void ) updateSelf:( NSArray* )arr
{
    for ( int i = 0 ; i < arr.count ; i++ )
    {
        [ selfView[ i ] updateData:[ arr objectAtIndex:i ] ];
    }
}

- ( void ) fightSelf:( NSArray* )arr :( NSString* )eff :( int )hit
{
    BOOL sound = [ [ BattleMapScene instance ] getActiveMapLayer ].LayerIndex == 0 && [ [ BattleMapScene instance ] getActiveLogUI ] == self;
    BOOL played = NO;
    
    for ( int i = 0 ; i < arr.count ; i++ )
    {
        int hp = [ [ arr objectAtIndex:i ] intValue ];
        
        if ( hp && sound && !played )
        {
            played = YES;
            [ selfView[ i ] fight:hp :hit :eff :YES ];
        }
        else
        {
            [ selfView[ i ] fight:hp :hit :eff :NO ];
        }
    }
}

- ( void ) fightEnemy:( NSArray* )arr :( NSString* )eff :( int )hit
{
    BOOL sound = [ [ BattleMapScene instance ] getActiveMapLayer ].LayerIndex == 0 && [ [ BattleMapScene instance ] getActiveLogUI ] == self;
    BOOL played = NO;
    
    for ( int i = 0 ; i < arr.count ; i++ )
    {
        int hp = [ [ arr objectAtIndex:i ] intValue ];
        
        if ( hp && sound && !played )
        {
            played = YES;
            [ enemyView[ i ] fight:hp :hit :eff :YES ];
        }
        else
        {
            [ enemyView[ i ] fight:hp :hit :eff :NO ];
        }
    }
}


- ( void ) fightSelfF:( NSArray* )arr :( NSString* )eff
{
    BOOL sound = [ [ BattleMapScene instance ] getActiveMapLayer ].LayerIndex == 0 && [ [ BattleMapScene instance ] getActiveLogUI ] == self;
    BOOL played = NO;
    
    for ( int i = 0 ; i < arr.count ; i++ )
    {
        float f = [ [ arr objectAtIndex:i ] floatValue ];
        
        if ( f && sound && !played )
        {
            played = YES;
            [ selfView[ i ] fightF:f :eff :YES ];
        }
        else
        {
            [ selfView[ i ] fightF:f :eff :NO ];
        }
    }
}

- ( void ) fightEnemyF:( NSArray* )arr :( NSString* )eff
{
    BOOL sound = [ [ BattleMapScene instance ] getActiveMapLayer ].LayerIndex == 0 && [ [ BattleMapScene instance ] getActiveLogUI ] == self;
    BOOL played = NO;
    
    for ( int i = 0 ; i < arr.count ; i++ )
    {
        float f = [ [ arr objectAtIndex:i ] floatValue ];
        
        if ( f && sound && !played )
        {
            played = YES;
            [ enemyView[ i ] fightF:f :eff :YES ];
        }
        else
        {
            [ enemyView[ i ] fightF:f :eff :NO ];
        }
    }
}

- ( void ) deadSelf:( NSArray* )arr
{
    
}

- ( void ) dead:( NSArray* )arr
{
    for ( int i = 0 ; i < arr.count ; i++ )
    {
        BOOL dead = [ [ arr objectAtIndex:i ] boolValue ];
        
        if ( dead )
        {

            [ UIView animateWithDuration:0.4f
                              animations:^{
                                    enemyView[ i ].alpha = 0.99f;
                              }completion:^(BOOL finish){
                                  [ UIView animateWithDuration:0.5f
                                                    animations:^{
                                                        enemyView[ i ].alpha = 0.0f;
                                                    }completion:^(BOOL finish){
                                                        enemyView[ i ].alpha = 1.0f;
                                                        enemyView[ i ].hidden = YES;
                                                    }];
                              }];
        }
    }

}


- ( void ) update:(float)delay
{
    for ( int i = 0 ; i < MAX_BATTLE_ENEMY ; ++i )
    {
        [ enemyView[ i ] update:delay ];
        [ selfView[ i ] update:delay ];
    }
}

- ( void ) start:( NSArray* )arr
{
    battleView.hidden = YES;
    
    for ( int i = 0 ; i < MAX_BATTLE_ENEMY ; i++ )
    {
        [ enemyView[ i ] setHidden:YES ];
        [ selfView[ i ] setHidden:YES ];
    }
    
    for ( int i = 0 ; i < arr.count ; i++ )
    {
        CreatureCommonData* comm = [ arr objectAtIndex:i ];
        
        [ selfView[ i ] setData:comm ];
        [ selfView[ i ] setHidden:NO ];
    }
}

- ( void ) startFight:( NSArray* )arr :( BOOL )b :( BOOL )sp
{
    battleView.hidden = NO;
    
    for ( int i = 0 ; i < MAX_BATTLE_ENEMY ; i++ )
    {
        [ enemyView[ i ] setHidden:YES ];        
    }
    
    for ( int i = 0 ; i < arr.count ; i++ )
    {
        CreatureCommonData* comm = [ arr objectAtIndex:i ];
        
        [ enemyView[ i ] setHidden:NO ];
        [ enemyView[ i ] setData:comm :b :sp ];
    }
}


- ( void ) endFight
{
    battleView.hidden = YES;
    
    for ( int i = 0 ; i < MAX_BATTLE_ENEMY ; i++ )
    {
        [ enemyView[ i ] setHidden:YES ];
    }
}


- ( void ) appandMsg:( NSString* )str
{
    NSString* msg;
    
    if ( gActualResource.type >= RESPAD2 )
    {
        msg = [ NSString stringWithFormat:@"<font size=5 color=#FFFFFF>%@</font>" , str ];
    }
    else
    {
        msg = [ NSString stringWithFormat:@"<font size=2 color=#FFFFFF>%@</font>" , str ];
    }
    
    [ webView appendHTMLText:msg ];
    [ webView moveBottom ];
}


- ( void ) clearMsg
{
    [ webView clearText ];
}

@end
