//
//  SceneUIHandler.m
//  sc
//
//  Created by fox on 13-2-10.
//
//

#import "SceneUIHandler.h"
#import "PlayerCreatureData.h"
#import "BattleMapScene.h"
#import "GameSceneManager.h"
#import "SceneData.h"
#import "PlayerData.h"

@implementation SceneUIHandler
@synthesize SelScene , SelTeam;

static SceneUIHandler* gSceneUIHandler;
+ (SceneUIHandler*) instance
{
    if ( !gSceneUIHandler )
    {
        gSceneUIHandler = [ [ SceneUIHandler alloc] init ];
        [ gSceneUIHandler initUIHandler:@"SceneUIView" isAlways:NO isSingle:NO ];

    }
    
    return gSceneUIHandler;
}


- ( void ) onInited
{
    [ super onInited ];
    
    scrollView = (SceneUIScrollView*)[ view viewWithTag:1000 ];
    [ scrollView initItemView:[ uiArray objectAtIndex:1 ] :self :@selector(onClick:) ];
    
    UIButton* button = (UIButton*)[ view viewWithTag:999 ];
    [ button addTarget:self action:@selector(onBack) forControlEvents:UIControlEventTouchUpInside ];
    
    button = ( UIButton* )[ view viewWithTag:100 ];
    [ button addTarget:self action:@selector(onBack) forControlEvents:UIControlEventTouchUpInside ];
    
    for ( int i = 0 ; i < MAX_TEAM ; ++i )
    {
        teamButton[ i ] = ( UIButton* )[ view viewWithTag:150 + i ];
        [ teamButton[ i ] addTarget:self action:@selector(onTeamClick:) forControlEvents:UIControlEventTouchUpInside ];
    }
    
    for ( int i = 0 ; i < MAX_BATTLE_PLAYER ; i++ )
    {
        team[ i ] = (CreatureListItem*)[ view viewWithTag:2000 + i ];
        //[ (UIButton*)[ team[ i ] viewWithTag:200 ] addTarget:self action:@selector(onClick:)forControlEvents:UIControlEventTouchUpInside ];
    }
    
    nameLabel = (UILabel*)[ view viewWithTag:1030 ];
    dayLabel = (UILabel*)[ view viewWithTag:1031 ];
    
    startButton = ( UIButton* )[ view viewWithTag:1011 ];
    sendButton = ( UIButton* )[ view viewWithTag:1010 ];
    sendBackButton = ( UIButton* )[ view viewWithTag:1012 ];
    
    [ startButton setEnabled:NO ];
    [ sendButton setEnabled:NO ];
    
    [ startButton addTarget:self action:@selector(onStart) forControlEvents:UIControlEventTouchUpInside ];
    [ sendButton addTarget:self action:@selector(onSend) forControlEvents:UIControlEventTouchUpInside ];
    [ sendBackButton addTarget:self action:@selector(onSendBack) forControlEvents:UIControlEventTouchUpInside ];
    
    teamLabel = (UITextView*)[ view viewWithTag:2005 ];
    
    digTextView = ( UITextView* )[ view viewWithTag:1020 ];
    collectTextView = ( UITextView* )[ view viewWithTag:1021 ];
    creatureTextView = ( UITextView* )[ view viewWithTag:1022 ];
}


- ( void ) onOpened
{
    [ super onOpened ];
    
    for ( int i = 0 ; i < MAX_TEAM ; ++i )
    {
        [ teamButton[ i ] setSelected:NO ];
    }
    
    [ teamButton[ 0 ] setSelected:YES ];
    
    selectTeam = 0;
    
    [ startButton setEnabled:NO ];
    [ sendButton setEnabled:NO ];
    [ sendBackButton setHidden:YES ];
}


- ( void ) onTeamClick:( UIButton* )button
{
    if ( selectTeam == button.tag - 150 )
    {
        return;
    }
    
    for ( int i = 0 ; i < MAX_TEAM ; ++i )
    {
        [ teamButton[ i ] setSelected:NO ];
    }
    
    [ button setSelected:YES ];
    
    selectTeam = button.tag - 150;
    
    [ self updateSelectTeam ];
    [ self updateButton ];
    
    playSound( PST_OK );
}

- ( void ) startBattle
{
    [ [ BattleMapScene instance ] load:SelScene :SelTeam ];
    [ [ GameSceneManager instance ] activeScene:GS_BATTLE ];
}

- ( void ) onStart
{
    SelTeam = selectTeam;
    SelScene = selectScene.SubSceneID;
    
    if ( ![ [ PlayerData instance ] checkBattleStory:selectScene.SubSceneID ] )
    {
        [ self startBattle ];
    }
    
    // playSound( PST_START );
    //[ [ BattleMapScene1 instance ] load:selectScene :selectTeam ];
    //[ [ GameSceneManager instance ] activeScene:GS_BATTLE1 ];
}

- ( void ) onSend
{
    [ startButton setEnabled:NO ];
    [ sendBackButton setHidden:NO ];
    [ sendBackButton setEnabled:YES ];
    [ sendButton setHidden:YES ];
    
    [ [ PlayerCreatureData instance ] setSendTeam:selectTeam :selectScene.SubSceneID ];
    
    [ selectScene updateTeam ];
    
    playSound( PST_OK );
}

- ( void ) onSendBack
{
    [ startButton setEnabled:YES ];
    [ sendBackButton setHidden:YES ];
    [ sendButton setHidden:NO ];
    [ sendButton setEnabled:YES ];
    
    
    int t = [ [ PlayerCreatureData instance ] getSendTeam:selectScene.SubSceneID ];
    [ [ PlayerCreatureData instance ] clearSendTeam:t ];
    
    [ selectScene updateTeam ];
    
    playSound( PST_OK );
}

- ( void ) updateSubScene
{
    if ( selectScene )
    {
        SubSceneMap* ssm = [ [ MapConfig instance ] getSubSceneMap:selectScene.SubSceneID ];
        
        NSMutableString* str = [ NSMutableString string ];
        
        SceneDataItem* sitem = [ [ SceneData instance ] getSceneData:ssm.ID ];
        
        NSMutableDictionary* dicTemp = [ NSMutableDictionary dictionary ];
        
        for ( int i = 0 ; i < ssm.Collect.count ; i++ )
        {
            CreatureBaseIDPerNum* ipn = [ ssm.Collect objectAtIndex:i ];
            ItemConfigData* item = [ [ ItemConfig instance ] getData:ipn.ID ];
            
            if ( [ dicTemp objectForKey:[ NSNumber numberWithInt:ipn.ID ] ] )
            {
                continue;
            }
            
            if ( item && [ sitem getCollect:ipn.ID ] )
            {
                [ str appendString:item.Name ];
            }
            else
            {
                [ str appendString:NSLocalizedString(@"none", nil) ];
            }
            
            [ dicTemp setObject:item forKey:[ NSNumber numberWithInt:ipn.ID ] ];
            [ str appendString:@"\n" ];
            [ collectTextView setText:str ];
        }
        if ( gActualResource.type >= RESPAD2 )
        {
            [ collectTextView setFont:[ UIFont fontWithName:@"Helvetica Bold" size:19 ] ];
        }
        else
        {
            [ collectTextView setFont:[ UIFont fontWithName:@"Helvetica Bold" size:11 ] ];
        }
        [ collectTextView setTextAlignment:NSTextAlignmentCenter ];
        [ collectTextView setTextColor:[ UIColor whiteColor ] ];
        
        [ dicTemp removeAllObjects ];
        [ str setString:@"" ];
        for ( int i = 0 ; i < ssm.Dig.count ; i++ )
        {
            CreatureBaseIDPerNum* ipn = [ ssm.Dig objectAtIndex:i ];
            ItemConfigData* item = [ [ ItemConfig instance ] getData:ipn.ID ];
            
            if ( [ dicTemp objectForKey:[ NSNumber numberWithInt:ipn.ID ] ] )
            {
                continue;
            }
            
            if ( item && [ sitem getDig:ipn.ID ] )
            {
                [ str appendString:item.Name ];
            }
            else
            {
                [ str appendString:NSLocalizedString(@"none", nil) ];
            }
            
            [ dicTemp setObject:item forKey:[ NSNumber numberWithInt:ipn.ID ] ];
            [ str appendString:@"\n" ];
            [ digTextView setText:str ];
        }
        
        if ( gActualResource.type >= RESPAD2 )
        {
            [ digTextView setFont:[ UIFont fontWithName:@"Helvetica Bold" size:19 ] ];
        }
        else
        {
            [ digTextView setFont:[ UIFont fontWithName:@"Helvetica Bold" size:11 ] ];
        }
        
        [ digTextView setTextAlignment:NSTextAlignmentCenter ];
        [ digTextView setTextColor:[ UIColor whiteColor ] ];
        
        [ dicTemp removeAllObjects ];
        [ str setString:@"" ];
        for ( int i = 0 ; i < ssm.Enemy.count ; i++ )
        {
            CreatureBaseIDPerNum* ipn = [ ssm.Enemy objectAtIndex:i ];
            CreatureCommonData* comm = [ [ CreatureConfig instance ] getCommonData:ipn.ID ];
            
            if ( [ dicTemp objectForKey:[ NSNumber numberWithInt:ipn.ID ] ] )
            {
                continue;
            }
            
            if ( comm && [ sitem getEnemy:comm.ID ] )
            {
                [ str appendString:comm.Name ];
            }
            else
            {
                [ str appendString:NSLocalizedString(@"none", nil) ];
            }
            
            [ dicTemp setObject:comm forKey:[ NSNumber numberWithInt:ipn.ID ] ];
            
            [ str appendString:@"\n" ];
            [ creatureTextView setText:str ];
        }
        
        if ( gActualResource.type >= RESPAD2 )
        {
            [ creatureTextView setFont:[ UIFont fontWithName:@"Helvetica Bold" size:19 ] ];
        }
        else
        {
            [ creatureTextView setFont:[ UIFont fontWithName:@"Helvetica Bold" size:11 ] ];
        }
        
        [ creatureTextView setTextAlignment:NSTextAlignmentCenter ];
        [ creatureTextView setTextColor:[ UIColor whiteColor ] ];
        
        [ dicTemp removeAllObjects ];
    }
}

- ( void ) updateButton
{
    [ startButton setEnabled:NO ];
    [ sendButton setEnabled:NO ];
    [ sendButton setHidden:NO ];
    
    if ( selectScene )
    {
        int* team1 = [ [ PlayerCreatureData instance ] getTeam:selectTeam ];
        
        for ( int i = 0 ; i < MAX_BATTLE_PLAYER ; i++ )
        {
            int c = team1[ i ];
            
            if ( c )
            {
                [ startButton setEnabled:YES ];
                [ sendButton setEnabled:NO ];
                [ sendBackButton setEnabled:NO ];
                [ sendBackButton setHidden:YES ];
                
                SceneDataItem* item = [ [ SceneData instance ] getSceneData:selectScene.SubSceneID ];
                
                if ( item.Per == 1.0f && [ [ PlayerCreatureData instance ] getFreeTeamCount ] >= 2 )
                {
                    [ sendButton setHidden:NO ];
                    [ sendButton setEnabled:YES ];
                    [ sendBackButton setHidden:YES ];
                }
                
                if ( [ [ PlayerCreatureData instance ] getTeamSend:selectTeam ] != INVALID_ID )
                {
                    [ startButton setEnabled:NO ];
                    [ sendButton setEnabled:NO ];
                    [ sendButton setHidden:NO ];
                    [ sendBackButton setHidden:YES ];
                }
                
                if ( [ [ PlayerCreatureData instance ] getSendTeam:selectScene.SubSceneID ] != INVALID_ID )
                {
                    [ startButton setEnabled:NO ];
                    [ sendButton setEnabled:YES ];
                    [ sendButton setHidden:YES ];
                    [ sendBackButton setHidden:NO ];
                    [ sendBackButton setEnabled:YES ];
                    
                }
                
                
                return;
            }
        }
    }
}

- ( void ) onClick:( SceneUIItemView* )item
{
    selectScene = item;
    
    [ self updateSubScene ];
    [ self updateButton ];
    
    playSound( PST_SELECT );
}


- ( void ) updateSelectTeam
{
    [ teamLabel setText:NSLocalizedString(@"TeamNull",nil ) ];
    
    int* team1 = [ [ PlayerCreatureData instance ] getTeam:selectTeam ];
    
    for ( int i = 0 ; i < MAX_BATTLE_PLAYER ; i++ )
    {
        [ team[ i ] clear ];
        [ team[ i ] setHidden:YES ];
        
        int c = team1[ i ];
        
        if ( c )
        {
            CreatureCommonData* comm = [ [ PlayerCreatureData instance ] getCommonData:c ];
            
            [ team[ i ] setData:comm ];
            [ team[ i ] setHidden:NO ];
            
            [ teamLabel setText:@"" ];
        }
    }
}


- ( void ) onClosed
{
    [ super onClosed ];
}

- ( void ) onRelease
{
    [ scrollView releaseItemView ];
    scrollView = NULL;
}

- ( void ) onBack
{
    [ self visible:NO ];
    
    playSound( PST_CANCEL );
}


- ( void ) updateScene:( SceneMap* )sm
{
    [ scrollView setData:sm ];
    
    [ nameLabel setText:sm.Name ];
    [ dayLabel setText:[ NSString stringWithFormat:@"%d" , sm.Day ] ];
    
    [ self updateSelectTeam ];
}


@end


