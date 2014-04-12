//
//  TeamUIHandler.m
//  sc
//
//  Created by fox on 13-9-15.
//
//

#import "TeamUIHandler.h"
#import "PlayerCreatureData.h"
#import "GameDataManager.h"
#import "PlayerInfoUIHandler.h"


@implementation TeamUIHandler


static TeamUIHandler* gTeamUIHandler;
+ ( TeamUIHandler* ) instance
{
    if ( !gTeamUIHandler )
    {
        gTeamUIHandler = [ [ TeamUIHandler alloc] init ];
        [ gTeamUIHandler initUIHandler:@"TeamUIView" isAlways:NO isSingle:YES ];
    }
    
    return gTeamUIHandler;
}


- ( void ) onInited
{
    UIButton* button = ( UIButton* )[ view viewWithTag:100 ];
    [ button addTarget:self action:@selector(onBack) forControlEvents:UIControlEventTouchUpInside ];
    
    for ( int i = 0 ; i < MAX_TEAM ; ++i )
    {
        teamButton[ i ] = ( UIButton* )[ view viewWithTag:150 + i ];
        [ teamButton[ i ] addTarget:self action:@selector(onTeamClick:) forControlEvents:UIControlEventTouchUpInside ];
    }
    
    scrollView = ( CreatureScrollView* )[ view viewWithTag:1000 ];
    [ scrollView initFastScrollView:[ uiArray objectAtIndex:1 ] :self :@selector( onCreatureClick: ) ];
    scrollView.delegate = self;
    scrollView.UseFirstSelect = NO;
    
    pageLabel = ( UILabel* )[ view viewWithTag:1001 ];
    
    for ( int i = 0 ; i < MAX_BATTLE_PLAYER ; i++ )
    {
        team[ i ] = (CreatureListItem*)[ view viewWithTag:2000 + i ];
        [ (UIButton*)[ team[ i ] viewWithTag:200 ] addTarget:self action:@selector(onClick:)forControlEvents:UIControlEventTouchUpInside ];
    }
    
    button = (UIButton*)[ view viewWithTag:1010 ];
    [ button addTarget:self action:@selector(onInfo) forControlEvents:UIControlEventTouchUpInside ];
    
    [ super onInited ];
    
    teamLabel = (UILabel*)[ view viewWithTag:2005 ];
    
    //   [ self updateData ];
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
    
    [ self updateData ];
    [ self updateSelectTeam ];
}


- ( void ) onClosed
{
    [ super onClosed ];
}


- ( void ) onInfo
{
    [ [ PlayerInfoUIHandler instance ] visible:YES ];
    [ [ PlayerInfoUIHandler instance ] setMode:PlayerInfoUIItem ];
    
    playSound( PST_OK );
}


- ( void ) updateSelectTeam
{
    [ teamLabel setText:NSLocalizedString( @"TeamCreature" , nil ) ];
    
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


- ( void ) updateData
{
    if ( !view )
    {
        return;
    }
    
    [ scrollView clear ];
    
    NSMutableDictionary* dic = [ PlayerCreatureData instance ].PlayerDic;
    
    NSArray* values = [ dic allValues ];
    
    for ( fint32 i = 0 ; i < values.count ; ++i )
    {
        CreatureCommonData* data = [ values objectAtIndex:i ];
        
        if ( data.Team == INVALID_ID )
        {
            [ scrollView addItem:data ];
        }
    }
    
    int count = [ scrollView getPageCount ];
    [ scrollView updateContentSize ];
    [ scrollView setNeedsLayout ];
    
    [ pageLabel setText:[ NSString stringWithFormat:@"%d/%d" ,  1 , count ] ];
    [ pageLabel setHidden:!count ];
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
    
    playSound( PST_OK );
}


- ( void ) onCreatureClick:( CreatureListItem* )item
{
    if ( !item )
    {
        return;
    }
    
    int c = item.CreatureID;
    //int index = item.Index;
    
    CreatureCommonData* comm = [ [ PlayerCreatureData instance ] getCommonData:c ];
    
    int targetIndex = INVALID_ID;
    int* team1 = [ [ PlayerCreatureData instance ] getTeam:selectTeam ];
    for ( int i = 0 ; i < MAX_BATTLE_PLAYER ; ++i )
    {
        if ( team1[ i ] == 0 )
        {
            targetIndex = i;
            break;
        }
    }
    
    [ teamLabel setText:@"" ];
    
    if ( targetIndex != INVALID_ID )
    {
        [ [ PlayerCreatureData instance ] addMember:selectTeam :targetIndex :comm.cID ];
        
        comm.Team = selectTeam;
        
        //[ scrollView removeItem:index ];
        [ team[ targetIndex ] setData:comm ];
        [ team[ targetIndex ] setHidden:NO ];
        
        [ self updateData ];
//        pageControl.numberOfPages = scrollView.DataCount / 6;
//        pageControl.numberOfPages += ( scrollView.DataCount % 6 ) ? 1 : 0;
//        
//        if ( pageControl.currentPage >= pageControl.numberOfPages )
//        {
//            pageControl.currentPage--;
//        }
    }
}


- ( void ) onClick:( UIButton* )button
{
    CreatureListItem* par = ( CreatureListItem* )button.superview;
    
    int target = par.tag - 2000;
    int c = team[ target ].CreatureID;
    
    CreatureCommonData* comm = [ [ PlayerCreatureData instance ] getCommonData:c ];
    comm.Team = INVALID_ID;
    
    [ [ PlayerCreatureData instance ] removeMember:selectTeam :target ];
    
    [ scrollView addItem:comm ];
    [ scrollView updateContentSize ];
    [ scrollView setNeedsLayout ];
    
    //[ self updateData ];
    [ self updateSelectTeam ];
    
    [ pageLabel setText:[ NSString stringWithFormat:@"%d/%d" , scrollView.SelectIndex + 1 , [ scrollView getPageCount ] ] ];
    [ pageLabel setHidden:NO ];
    
    playSound( PST_SELECT );
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)sv
{
    int index = fabs( sv.contentOffset.x ) / sv.frame.size.width;
    scrollView.SelectIndex = index;
    [ pageLabel setText:[ NSString stringWithFormat:@"%d/%d" , scrollView.SelectIndex + 1 , [ scrollView getPageCount ] ] ];
}


- ( void ) onBack
{
    [ self visible:NO ];
    
    playSound( PST_CANCEL );
}


@end

