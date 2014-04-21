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
        
        if ( sub != data.BattleMap )
        {
            continue;
        }
        
        if ( data.Employ && ![ [ PlayerCreatureData instance ] getCommonDataWithID:data.Employ ] )
        {
            continue;
        }
        
        int nextID = [ [ EventData instance ] getCompleteEvent:data.ID ];
        
        if ( nextID )
        {
            // compleated,,
            
            if ( ![ [ EventData instance ] getCompleteEvent:nextID ] )
            {
                if ( getRand( 0 , 100 ) > data.Random )
                {
                    return;
                }
                
                ActiveEvent = data;
            }
        }
        else
        {
            if ( getRand( 0 , 100 ) > data.Random )
            {
                return;
            }
            
            ActiveEvent = data;
        }
    }
}

- ( void ) clearEvent
{
    ActiveEvent = NULL;
}

//- ( void ) checkEvent
//{
//    if ( ActiveEvent )
//    {
//        return;
//    }
//    
//    if ( [ TalkUIHandler instance ].isOpened )
//    {
//        return;
//    }
//    
//    NSMutableDictionary* dic = [ EventConfig instance ].Dic;
//    
//    for ( int i = 0 ; i < dic.count ; ++i )
//    {
//        EventConfigData* data = [ dic.allValues objectAtIndex: i ];
//        
//        int nextID = [ [ EventData instance ] getCompleteEvent:data.ID ];
//        
//        if ( nextID != 0 )
//        {
//            continue;
//        }
//        
//        if ( data.Employ && ![ [ PlayerCreatureData instance ] getCommonDataWithID:data.Employ ] )
//        {
//            continue;
//        }
//        
////        if ( data.Story && [ PlayerData instance ].Story >= data.Story )
////        {
////            if ( getRand( 0 , 100 ) > data.Random )
////            {
////                return;
////            }
////            
////            ActiveEvent = data;
////            break;
////        }
//        
//        if ( [ [ EventData instance ] checkCompleteEventNext:data.ID ] )
//        {
//            if ( getRand( 0 , 100 ) > data.Random )
//            {
//                return;
//            }
//            
//            ActiveEvent = data;
//            break;
//        }
//    }
//    
//    if ( ActiveEvent )
//    {
//        [ [ TalkUIHandler instance ] visible:YES ];
//        [ [ TalkUIHandler instance ] setData:ActiveEvent.StartGuide ];
//    }
//}


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
        
        if ( ActiveEvent.ComItem0 )
        {
            [ [ ItemData instance ] addItem:ActiveEvent.ComItem0 : ActiveEvent.ComItemNum0 ];
        }
        
        if ( ActiveEvent.ComItem1 )
        {
            [ [ ItemData instance ] addItem:ActiveEvent.ComItem1 : ActiveEvent.ComItemNum1 ];
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
    
    if ( ![ [ PlayerData instance ] getMonsterData:ActiveEvent.BattleMonster ] )
    {
        [ self endEvent:NO ];

        return;
    }
    
    [ self endEvent:YES ];
}


@end
