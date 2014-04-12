//
//  GameEventManager.m
//  sc
//
//  Created by fox on 14-1-13.
//
//

#import "GameEventManager.h"
#import "EventConfig.h"
#import "EventData.h"
#import "PlayerData.h"
#import "PlayerCreatureData.h"
#import "GameSceneManager.h"
#import "TalkUIHandler.h"
#import "PlayerEmployData.h"
#import "ItemData.h"
#import "QuestData.h"


@implementation GameEventManager
@synthesize ActiveEvent;

GameEventManager* gGameEventManager = NULL;
+( GameEventManager* )instance
{
    if ( !gGameEventManager )
    {
        gGameEventManager = [ [ GameEventManager alloc ] init ];
    }
    
    return  gGameEventManager;
}


- ( void ) checkBattleEvent:( int )sub
{
    if ( ActiveEvent )
    {
        return;
    }
    
    NSMutableDictionary* dic = [ EventConfig instance ].Dic;
    
    
    for ( int i = 0 ; i < dic.count ; ++i )
    {
        EventConfigData* data = [ dic.allValues objectAtIndex: i ];
        
        int nextID = [ [ EventData instance ] getCompleteEvent:data.ID ];
        
        if ( nextID != 0 )
        {
            // compleated,,
            continue;
        }
        
        if ( sub != data.BattleMap )
        {
            continue;
        }
        
        if ( data.Employ && ![ [ PlayerCreatureData instance ] getCommonDataWithID:data.Employ ] )
        {
            continue;
        }
        
        if ( data.Quest && [ [ QuestData instance ] getQuest:data.Quest ] != QDT_ACTIVE )
        {
            continue;
        }
        
        if ( data.Story && [ PlayerData instance ].Story >= data.Story )
        {
            if ( getRand( 0 , 100 ) > data.Random )
            {
                return;
            }
            
            ActiveEvent = data;
            break;
        }
        
        if ( [ [ EventData instance ] checkCompleteEventNext:data.ID ] )
        {
            if ( getRand( 0 , 100 ) > data.Random )
            {
                return;
            }
            
            ActiveEvent = data;
            break;
        }
        
    }
    
    if ( ActiveEvent )
    {
        [ [ TalkUIHandler instance ] visible:YES ];
        [ [ TalkUIHandler instance ] setData:ActiveEvent.StartGuide ];
    }
    
}

- ( void ) clearEvent
{
    ActiveEvent = NULL;
}

- ( void ) checkEvent
{
    if ( ActiveEvent )
    {
        return;
    }
    
    if ( [ TalkUIHandler instance ].isOpened )
    {
        return;
    }
    
    NSMutableDictionary* dic = [ EventConfig instance ].Dic;
    
    for ( int i = 0 ; i < dic.count ; ++i )
    {
        EventConfigData* data = [ dic.allValues objectAtIndex: i ];
        
        int nextID = [ [ EventData instance ] getCompleteEvent:data.ID ];
        
        if ( nextID != 0 )
        {
            continue;
        }
        
        if ( data.CheckScene.length && ![ [ GameSceneManager instance ] checkScene:data.CheckScene ] )
        {
            continue;
        }
        
        if ( data.Employ && ![ [ PlayerCreatureData instance ] getCommonDataWithID:data.Employ ] )
        {
            continue;
        }
        
        if ( data.Story && [ PlayerData instance ].Story >= data.Story )
        {
            if ( getRand( 0 , 100 ) > data.Random )
            {
                return;
            }
            
            ActiveEvent = data;
            break;
        }
        
        if ( [ [ EventData instance ] checkCompleteEventNext:data.ID ] )
        {
            if ( getRand( 0 , 100 ) > data.Random )
            {
                return;
            }
            
            ActiveEvent = data;
            break;
        }
    }
    
    if ( ActiveEvent )
    {
        [ [ TalkUIHandler instance ] visible:YES ];
        [ [ TalkUIHandler instance ] setData:ActiveEvent.StartGuide ];
    }
}


- ( void ) endEvent:( BOOL )b
{
    if ( !ActiveEvent )
    {
        return;
    }
    
    if ( b )
    {
        [ [ TalkUIHandler instance ] visible:YES ];
        [ [ TalkUIHandler instance ] setData:ActiveEvent.ComGuide ];
        
        [ [ EventData instance ] setCompleteEvent:ActiveEvent.ID ];
        
        [ [ ItemData instance ] addItem:ActiveEvent.ComItem0 : ActiveEvent.ComItemNum0 ];
        
        if ( ActiveEvent.ComQuest )
        {
            [ [ QuestData instance ] setQuest:ActiveEvent.ComQuest :QDT_COMPLETE ];
        }
    }
    else
    {
        [ [ TalkUIHandler instance ] visible:YES ];
        [ [ TalkUIHandler instance ] setData:ActiveEvent.FailedGuide ];
    }
    
    ActiveEvent = NULL;
}


- ( void ) checkEventComplete
{
    if ( !ActiveEvent )
    {
        return;
    }
    
    if ( [ [ [ ItemData instance ] getItem:ActiveEvent.CItem0 ] Number ] < ActiveEvent.CItemNum0 )
    {
        ActiveEvent = NULL;
        [ self endEvent:NO ];
        return;
    }
    
    if ( ActiveEvent.CKill && [ [ PlayerData instance ] getMonsterData:ActiveEvent.BattleMonster ] < ActiveEvent.CKill )
    {
        ActiveEvent = NULL;
        [ self endEvent:NO ];
        return;
    }
    
    if ( ActiveEvent.CLevel && [ PlayerData instance ].WorkRank < ActiveEvent.CLevel )
    {
        ActiveEvent = NULL;
        [ self endEvent:NO ];
        return;
    }

    [ self endEvent:YES ];
}


@end
