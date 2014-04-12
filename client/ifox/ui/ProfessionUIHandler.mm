//
//  ProfessionUIHandler.m
//  sc
//
//  Created by fox on 13-11-17.
//
//

#import "ProfessionUIHandler.h"
#import "PlayerInfoUIHandler.h"
#import "PlayerCreatureData.h"
#import "ProfessionConfig.h"
#import "UILabelStroke.h"
#import "GameSceneManager.h"
#import "TalkUIHandler.h"
#import "PlayerData.h"
#import "AlertUIHandler.h"
#import "ItemData.h"


@implementation ProfessionUIHandler




static ProfessionUIHandler* gProfessionUIHandler;
+ ( ProfessionUIHandler* ) instance
{
    if ( !gProfessionUIHandler )
    {
        gProfessionUIHandler = [ [ ProfessionUIHandler alloc] init ];
        [ gProfessionUIHandler initUIHandler:@"ProfessionUIView" isAlways:YES isSingle:NO ];
    }
    
    return gProfessionUIHandler;
}


- ( void ) onInited
{
    [ super onInited ];
    
    creatureScrollView = (CreatureScrollView*)[ view viewWithTag:1000 ];
    creatureScrollView.delegate = self;
    creaturePageLabel = ( UILabel* )[ view viewWithTag:1001 ];
    [ creatureScrollView initFastScrollView:[ uiArray objectAtIndex:1 ] :self :@selector( onCreatureClick: ) ];
    creatureScrollView.UseSelect = YES;
    
    
    proScrollView = (ProfessionListScrollView*)[ view viewWithTag:2000 ];
    proScrollView.delegate = self;
    proPageLabel = ( UILabel* )[ view viewWithTag:2001 ];
    [ proScrollView initFastScrollView:[ uiArray objectAtIndex:2 ] :self :@selector( onProClick: ) ];
    
    UIButton* button = (UIButton*)[ view viewWithTag:1010 ];
    [ button addTarget:self action:@selector(onInfo) forControlEvents:UIControlEventTouchUpInside ];
    
    button = (UIButton*)[ view viewWithTag:1200 ];
    [ button addTarget:self action:@selector(onCloseClick) forControlEvents:UIControlEventTouchUpInside ];
    
    button = (UIButton*)[ view viewWithTag:1300 ];
    [ button addTarget:self action:@selector(onProfessionClick) forControlEvents:UIControlEventTouchUpInside ];
    
    
    nameLabel = (UILabel*)[ view viewWithTag:2130 ];
    conLabel = (UILabel*)[ view viewWithTag:2131 ];
    desLabel = (UITextView*)[ view viewWithTag:2132 ];
    con1Label = (UILabel*)[ view viewWithTag:2133 ];
    goldLabel = (UILabel*)[ view viewWithTag:2134 ];
}


- ( void ) onOpened
{
    [ super onOpened ];
    
    selectCreature = NULL;
    
    [ self updateCreatureData ];
    [ self updateProData ];
}


- ( void ) scrollViewDidEndDecelerating:( UIScrollView* )sv
{
    int index = fabs( sv.contentOffset.x ) / sv.frame.size.width;
    
    if ( sv == creatureScrollView )
    {
        [ creaturePageLabel setText:[ NSString stringWithFormat:@"%d/%d" , index + 1 , [ creatureScrollView getPageCount ] ] ];
    }
    else
    {
        [ proPageLabel setText:[ NSString stringWithFormat:@"%d/%d" , index + 1 , [ proScrollView getPageCount ] ] ];
    }
    
}


- ( void ) onProfessionClick
{
    if ( !selectCreature.CreatureID )
    {
        return;
    }
    
    if ( !selectPro )
    {
        return;
    }
    
    PackItemData* pack = [ [ ItemData instance ] getItem:selectPro.ProID + PRO_ITEM ];
    
    if ( pack.Number )
    {
        [ [ ItemData instance ] removeItem:pack.ItemID :1 ];
        
        CreatureCommonData* comm = [ [ PlayerCreatureData instance ] getCommonData:selectCreature.CreatureID ];
        
        if ( selectPro.ProID == comm.ProfessionID )
        {
            return;
        }
        
        [ comm changeProfession:selectPro.ProID ];
        
        [ self updateSelectPro ];
        [ self updateProState ];
        
        [ [ AlertUIHandler instance ] alert:NSLocalizedString( @"ChangePro", nil) ];
        
        playSound( PST_OK );
    }
    else
    {
        [ [ AlertUIHandler instance ] alert:NSLocalizedString( @"ChangeProError", nil) ];
        playSound( PST_ERROR );
    }
    
    
}


- ( void ) onCloseClick
{
    playSound( PST_CANCEL );
    
    [ self onOver ];
    
//    [ [ TalkUIHandler instance ] visible:YES ];
//    [ [ TalkUIHandler instance ] setData:1201 ];
//    [ [ TalkUIHandler instance ] setSel:self :@selector( onOver ) ];
    
    [ self visible:NO ];
}

- ( void ) onOver
{
    [ [ GameSceneManager instance ] activeScene:GS_CITY ];
}

- ( void ) onInfo
{
    playSound( PST_OK );
    
    [ [ PlayerInfoUIHandler instance ] visible:YES ];
    [ [ PlayerInfoUIHandler instance ] setMode:PlayerInfoUIItem ];
}

- ( void ) onClosed
{
    [ super onClosed ];
    
}

- ( void ) updateSelectPro
{
    if ( !selectPro )
    {
        return;
    }
    
    ProfessionConfigData* data = [ [ ProfessionConfig instance ] getProfessionConfig:selectPro.ProID ];
    
    CreatureCommonData* comm = [ [ PlayerCreatureData instance ] getCommonData:selectCreature.CreatureID ];
    
    ProfessionConfigData* data1 = [ [ ProfessionConfig instance ] getProfessionConfig:comm.ProfessionID ];
    
    NSMutableString* str = [ NSMutableString string ];
    NSArray* allkeys = data.Conditions.allKeys;
    for ( int i = 0 ; i < allkeys.count ; ++i )
    {
        int ii = [ [ allkeys objectAtIndex:i ] intValue ];
        int dd = [ [ data.Conditions objectForKey:[ NSNumber numberWithInt:ii ] ] intValue ];
        
        ProfessionConfigData* data2 = [ [ ProfessionConfig instance ] getProfessionConfig:ii ];
        
        [ str appendFormat:@"%@LV%d  " , data2.Name , dd ];
    }
    
    if ( !str.length )
    {
        [ str appendString:NSLocalizedString( @"NOCondition" , nil ) ];
    }
    
    [ nameLabel setText:data.Name ];
    [ conLabel setText:str ];
    [ desLabel setText:data.Des ];
    [ con1Label setText:data1.Name ];
    [ goldLabel setText:[ NSString stringWithFormat:@"%d" , [ PlayerData instance ] .Gold ] ];
}


- ( void ) updateProState
{
    if ( !selectCreature )
    {
        return;
    }
    
    CreatureCommonData* comm = [ [ PlayerCreatureData instance ] getCommonData:selectCreature.CreatureID ];
    
    for ( int i = 0 ; i < proScrollView.DataCount ; ++i )
    {
        ProfessionListItem* item = ( ProfessionListItem* ) [ proScrollView getItem:i ];
        
        ProfessionLevelData* level = [ comm getProLevelData:item.ProID ];

        [ item setLevel:level.Level ];
        [ item setEquip:comm.ProfessionID == item.ProID ? PLIT_EQUIP : PLIT_CLEAR ];
        [ item setNumber ];
    }
    
}


- ( void ) updateProData
{
    if ( !view )
    {
        return;
    }
    
    [ proScrollView clear ];
    
    selectPro = NULL;
    
    
    CreatureCommonData* comm = [ [ PlayerCreatureData instance ] getCommonData:selectCreature.CreatureID ];
    NSArray* allKeys = getSortKeys( comm.Profession );
    
    for ( fint32 i = 0 ; i < allKeys.count ; ++i )
    {
        ProfessionLevelData* data = [ comm.Profession objectForKey:[ allKeys objectAtIndex:i ] ];
        
        [ proScrollView addItem:data ];
    }
    
    NSMutableDictionary* dic = [ ProfessionConfig instance ].Dic;
    NSArray* values = [ dic allValues ];
    for ( fint32 i = 0 ; i < values.count ; ++i )
    {
        ProfessionConfigData* data1 = [ values objectAtIndex:i ];
        NSArray* allKeys = data1.Conditions.allKeys;
        
        ProfessionLevelData* ld = [ comm getProLevelData:data1.ID ];
        
        if ( ld )
        {
            continue;
        }
        
        BOOL b = YES;
        
        for ( int j = 0 ; j < allKeys.count ; j++ )
        {
            int ii = [ [ allKeys objectAtIndex:j ] intValue ];
            int lv = [ [ data1.Conditions objectForKey:[ allKeys objectAtIndex:j ] ] intValue ];
            
            ProfessionLevelData* ld = [ comm getProLevelData:ii ];
            
            if ( ld.Level < lv )
            {
                b = NO;
                break;
            }
        }
        
        if ( b )
        {
            ProfessionLevelData* data = [ [ ProfessionLevelData alloc ] init ];
            data.ID = data1.ID;
            data.Level = 0;
            
            [ proScrollView addItem:data ];
            [ data release ];
        }
    }
    
    int count = [ proScrollView getPageCount ];
    [ proScrollView updateContentSize ];
    [ proScrollView setNeedsLayout ];
    
    [ proPageLabel setText:[ NSString stringWithFormat:@"%d/%d" , 1 , count ] ];
    [ proPageLabel setHidden:!count ];
    
    [ self updateSelectPro ];
    [ self updateProState ];
}


- ( void ) updateCreatureData
{
    if ( !view )
    {
        return;
    }
    
    [ creatureScrollView clear ];
    
    NSMutableDictionary* dic = [ PlayerCreatureData instance ].PlayerDic;
    
    NSArray* values = [ dic allValues ];
    
    for ( fint32 i = 0 ; i < values.count ; ++i )
    {
        CreatureCommonData* data = [ values objectAtIndex:i ];
        
        [ creatureScrollView addItem:data ];
    }
    
    int count = [ creatureScrollView getPageCount ];
    [ creatureScrollView updateContentSize ];

    [ creaturePageLabel setText:[ NSString stringWithFormat:@"%d/%d" , 1 , count ] ];
    [ creaturePageLabel setHidden:!count ];
}


- ( void ) onCreatureClick:( CreatureListItem* )item
{
    if ( selectCreature == item )
    {
        return;
    }
    
    if ( item )
    {
        selectCreature = item;
    }
    
    [ self updateProData ];
    //[ self updateProState ];
    //[ self updateSelectPro ];
}


- ( void ) onProClick:( ProfessionListItem* )item
{
    if ( selectPro == item )
    {
        return;
    }
    
    if ( item )
    {
        selectPro = item;
    }
    
    [ self updateSelectPro ];
    [ self updateProState ];
}



@end
