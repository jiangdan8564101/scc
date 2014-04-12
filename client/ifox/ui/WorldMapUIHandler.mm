//
//  WorldMapUIHandler.m
//  sc
//
//  Created by fox on 13-1-13.
//
//

#import "WorldMapUIHandler.h"
#import "GameSceneManager.h"
#import "MapConfig.h"
#import "SceneUIHandler.h"
#import "PlayerData.h"
#import "TalkUIHandler.h"

@implementation WorldMapUIHandler

static WorldMapUIHandler* gWorldMapUIHandler;
+ (WorldMapUIHandler*) instance
{
    if ( !gWorldMapUIHandler )
    {
        gWorldMapUIHandler = [ [ WorldMapUIHandler alloc] init ];
        [ gWorldMapUIHandler initUIHandler:@"WorldMapUIView" isAlways:YES isSingle:NO ];
    }
    
    return gWorldMapUIHandler;
}


- ( void ) onInited
{
    CGRect rect = view.frame;
    
    if ( gActualResource.type >= RESPAD2 )
    {
        rect.origin.x = -450;
        rect.origin.y = 0;
    }
    else
    {
        rect.origin.x = -750;
        rect.origin.y = -200;
    }
    
    [ view setFrame:rect ];
    
    [ super onInited ];
    
    NSArray* array = [ MapConfig instance ].Scenes.allValues;
    for ( int i = 0 ; i < array.count ; ++i )
    {
        SceneMap* sm = [ array objectAtIndex:i ];
        
        UIButton* button = (UIButton*)[ view viewWithTag:sm.ID ];
        [ button addTarget:self action:@selector(onBattleButton:) forControlEvents:UIControlEventTouchUpInside ];
        [ button addTarget:self action:@selector(onBattleButtonDown:) forControlEvents:UIControlEventTouchDown ];
        [ button addTarget:self action:@selector(onBattleButtonCancel:) forControlEvents:UIControlEventTouchCancel ];
        [ button addTarget:self action:@selector(onBattleButtonCancel:) forControlEvents:UIControlEventTouchUpOutside ];
        [ button addTarget:self action:@selector(onBattleButtonCancel:) forControlEvents:UIControlEventTouchDragOutside ];
        
        UIView* view1 = (UIView*)[ view viewWithTag:1000 + sm.ID ];
        [ view1 setHidden:YES ];
        
        UILabel* label = (UILabel*)[ view viewWithTag:2000 + sm.ID ];
        [ label setText:sm.Name ];
    }
    
}

- ( void ) onOpened
{
    [ super onOpened ];
    
    NSArray* array = [ MapConfig instance ].Scenes.allValues;
    for ( int i = 0 ; i < array.count ; ++i )
    {
        SceneMap* sm = [ array objectAtIndex:i ];
        
        UIButton* button = (UIButton*)[ view viewWithTag:sm.ID ];
        
        UIView* view1 = (UIView*)[ view viewWithTag:1000 + sm.ID ];
        
        BOOL b = sm.Story > [ PlayerData instance ].Story || [ PlayerData instance ].WorkRank < sm.WorkRank;
        
        if ( [ PlayerData instance ].WorkRank + 1 == sm.WorkRank )
        {
            //button.highlighted = YES;
            [ button setHidden:sm.Story > [ PlayerData instance ].Story ];
        }
        else
        {
            [ button setHidden:b ];
        }
        
        [ view1 setHidden:YES ];
    }
}


- ( void ) onClosed
{
    [ super onClosed ];
}


- ( void ) onCityTouchUp
{
    [ [ GameSceneManager instance ] activeScene:GS_CITY ];
}


- ( void ) hiddenView:( int )tag :( BOOL )b
{
    UIView* view1 = (UIView*)[ view viewWithTag:1000 + tag ];
    [ view1 setHidden:b ];
}

- ( void ) onBattleButtonDown:( UIButton* )button
{
    [ self hiddenView:button.tag :NO ];
}

- ( void ) onBattleButtonCancel:( UIButton* )button
{
    [ self hiddenView:button.tag :YES ];
}

- ( void ) onBattleButton:( UIButton* )button
{
    [ self hiddenView:button.tag :YES ];
    
    int tag = button.tag;
    
    if ( tag == 1 )
    {
        [ self onCityTouchUp ];
        return;
    }
    
    SceneMap* sm = [ [ MapConfig instance ] getSceneMap:tag ];
    
    if ( !sm )
    {
        return;
    }
    
    if ( [ PlayerData instance ].WorkRank + 1 == sm.WorkRank )
    {
        //button.highlighted = YES;
        [ [ TalkUIHandler instance ] visible:YES ];
        [ [ TalkUIHandler instance ] setData:SOT_NOTOPEN9 ];
        playSound( PST_ERROR );
        return;
    }
    
    [ [ SceneUIHandler instance ] visible:YES ];
    [ [ SceneUIHandler instance ] updateScene:sm ];
    
    playSound( PST_OK );
}


@end
