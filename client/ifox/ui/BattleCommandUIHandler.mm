//
//  BattleCommandUIHandler.m
//  sc
//
//  Created by fox on 13-3-1.
//
//

#import "BattleCommandUIHandler.h"
#import "BattleCreatureInfoUIHandler.h"
#import "BattleMapScene.h"
#import "BattleNetHandler.h"

@implementation BattleCommandUIHandler

static BattleCommandUIHandler* gBattleCommandUIHandler;
+ (BattleCommandUIHandler*) instance
{
    if ( !gBattleCommandUIHandler )
    {
        gBattleCommandUIHandler = [ [ BattleCommandUIHandler alloc] init ];
        [ gBattleCommandUIHandler initUIHandler:@"BattleCommandView" isAlways:YES isSingle:NO ];
    }
    
    return gBattleCommandUIHandler;
}

- ( void ) onInited
{
    UIButton* cButton = (UIButton*)[ view viewWithTag:100 ];
    [ cButton addTarget:self action:@selector(onCancel) forControlEvents:UIControlEventTouchUpInside ];
    
    UIButton* sButton1 = (UIButton*)[ view viewWithTag:200 ];
    [ sButton1 addTarget:self action:@selector(onStay) forControlEvents:UIControlEventTouchUpInside ];
    
    UIButton* sButton = (UIButton*)[ view viewWithTag:300 ];
    [ sButton addTarget:self action:@selector(onSkill) forControlEvents:UIControlEventTouchUpInside ];
}


- ( void ) onClosed
{
    //creature = NULL;
}

- ( void ) onSkill
{
    //[ self visible:NO ];
}

- ( void ) onStay
{
    [ creature endMove ];
    [ creature switchPos ];
    
    [ [ BattleStage instance ] addCount:creature ];
    
    creature = NULL;
    
    [ [ BattleMapScene instance ] clearMovePath ];
    [ [ BattleMapScene instance ] clearSelect ];
    
    [ [ BattleStage instance ] checkEndTurn ];
    
    [ self visible:NO ];
    [ [ BattleCreatureInfoUIHandler instance ] visible:NO ];
}

- ( void ) onCancel
{
    [ creature backPos ];
    creature = NULL;
    
    [ [ BattleMapScene instance ] clearMovePath ];
    [ [ BattleMapScene instance ] clearSelect ];
    
    [ self visible:NO ];
    [ [ BattleCreatureInfoUIHandler instance ] visible:NO ];
}


- ( void ) setData:( BattleCreature* )c
{
    creature = c;
}

- ( void ) setPos:( float ) x :( float )y
{
    if ( x > SCENE_WIDTH - view.frame.size.width )
    {
        x = SCENE_WIDTH - view.frame.size.width;
    }
    
    if ( y > SCENE_HEIGHT - view.frame.size.height )
    {
        y = SCENE_HEIGHT - view.frame.size.height;
    }
    
    if ( x < view.frame.size.width )
    {
        x = view.frame.size.width;
    }
    
    if ( y < view.frame.size.height )
    {
        y = view.frame.size.height;
    }
    
    [ view setCenter:CGPointMake( x - 100 , y ) ];
}

@end
