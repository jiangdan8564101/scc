//
//  PublicUIHandler.m
//  sc
//
//  Created by fox on 13-9-8.
//
//

#import "PublicUIHandler.h"
#import "GameSceneManager.h"
#import "PlayerInfoUIHandler.h"
#import "TeamUIHandler.h"
#import "TalkUIHandler.h"
#import "PlayerData.h"
#import "InfoQuestUIHandler.h"
#import "InfoQuestReportUIHandler.h"
#import "QuestData.h"


@implementation PublicUIHandler


static PublicUIHandler* gPublicUIHandler;
+ (PublicUIHandler*) instance
{
    if ( !gPublicUIHandler )
    {
        gPublicUIHandler = [ [ PublicUIHandler alloc] init ];
        [ gPublicUIHandler initUIHandler:@"PublicUIView" isAlways:YES isSingle:NO ];
        
    }
    
    return gPublicUIHandler;
}


- ( void ) onInited
{
    UIButton* button = ( UIButton* )[ view viewWithTag:103 ];
    [ button addTarget:self action:@selector(onGo) forControlEvents:UIControlEventTouchUpInside ];
    
    button = ( UIButton* )[ view viewWithTag:100 ];
    [ button addTarget:self action:@selector(onEmploy) forControlEvents:UIControlEventTouchUpInside ];
    
    button = ( UIButton* )[ view viewWithTag:101 ];
    [ button addTarget:self action:@selector(onQuest) forControlEvents:UIControlEventTouchUpInside ];
    
    button = ( UIButton* )[ view viewWithTag:102 ];
    [ button addTarget:self action:@selector(onTeam) forControlEvents:UIControlEventTouchUpInside ];
    
    goldLabel = ( UILabel* )[ view viewWithTag:500 ];
}


- ( void ) onOpened
{
    [ super onOpened ];
    
    [ self updateGold ];
}


- ( void ) updateGold
{
    [ goldLabel setText:[ NSString stringWithFormat:@"%d" , [ PlayerData instance ].getGold ] ];
}


- ( void ) onQuest
{
    [ [ QuestData instance ] checkQuest ];
    
    playSound( PST_OK );
}


- ( void ) onTeam
{
    [ [ TeamUIHandler instance ] visible:YES ];
    
    playSound( PST_OK );
}


- ( void ) onEmploy
{
//[ [ EmployUIHandler instance ] visible:YES ];
    [ [ PlayerInfoUIHandler instance ] visible:YES ];
    [ [ PlayerInfoUIHandler instance ] setMode:PlayerInfoUIEmploy ];
    
    playSound( PST_OK );
}


- ( void ) onGo
{
    [ self onOver ];
    
//    [ [ TalkUIHandler instance ] visible:YES ];
//    [ [ TalkUIHandler instance ] setData:1101 ];
//    [ [ TalkUIHandler instance ] setSel:self :@selector( onOver ) ];
    
    [ self visible:NO ];
    
    playSound( PST_CANCEL );
}


- ( void ) onOver
{
    [ [ GameSceneManager instance ] activeScene:GS_CITY ];
}


@end
