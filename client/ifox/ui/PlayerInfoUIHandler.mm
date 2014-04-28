//
//  PlayerInfoUIHandler.m
//  sc
//
//  Created by fox on 13-9-8.
//
//

#import "PlayerInfoUIHandler.h"
#import "PlayerEmployData.h"
#import "PlayerCreatureData.h"
#import "PlayerData.h"
#import "AlarmUIHandler.h"
#import "AlertUIHandler.h"
#import "PublicUIHandler.h"

@implementation PlayerInfoUIHandler


static PlayerInfoUIHandler* gPlayerInfoUIHandler;
+ (PlayerInfoUIHandler*) instance
{
    if ( !gPlayerInfoUIHandler )
    {
        gPlayerInfoUIHandler = [ [ PlayerInfoUIHandler alloc] init ];
        [ gPlayerInfoUIHandler initUIHandler:@"PlayerInfoView" isAlways:NO isSingle:YES ];
    }
    
    return gPlayerInfoUIHandler;
}


- ( void ) onInited
{
    employButton = ( UIButton* )[ view viewWithTag:200 ];
    [ employButton addTarget:self action:@selector(onEmploy) forControlEvents:UIControlEventTouchUpInside ];
    
    fireButton = ( UIButton* )[ view viewWithTag:201 ];
    [ fireButton addTarget:self action:@selector(onFire) forControlEvents:UIControlEventTouchUpInside ];
    
    
    UIButton* button = ( UIButton* )[ view viewWithTag:100 ];
    [ button addTarget:self action:@selector(onBack) forControlEvents:UIControlEventTouchUpInside ];
    
    scrollView = (PlayerInfoScrollView*)[ view viewWithTag:1000 ];
    [ scrollView initFastScrollView:[ uiArray objectAtIndex:1 ] :self :@selector( onClick: ) ];
    scrollView.delegate = self;
    
    scrollPageLabel = ( UILabel* )[ view viewWithTag:1001 ];
    
    imageView = (UIImageView*)[ view viewWithTag:1002 ];
    centerPoint = imageView.center;
    
    [ super onInited ];
    
    [ view setCenter:CGPointMake( SCENE_WIDTH * 0.5f , SCENE_HEIGHT * 0.5f ) ];
    
    itemArray = [ [ NSMutableArray alloc ] init ];

    [ employButton setHidden:YES ];
    [ fireButton setHidden:YES ];
    
    employLabel = (UILabel*)[ view viewWithTag:211 ];
    goldLabel = (UILabel*)[ view viewWithTag:210 ];
}


- ( void ) onOpened
{
    [ super onOpened ];
    [ self clearData ];
}


- ( void ) onClosed
{
    [ super onClosed ];
    
    [ scrollView clear ];
    
    [ itemArray removeAllObjects ];
}


- ( void ) updateEmployData
{
    if ( !view )
    {
        return;
    }
    
    [ [ PlayerEmployData instance ] reloadData ];
    
    [ scrollView clear ];
    [ itemArray removeAllObjects ];
    
    for ( int i = 0 ; i < [ PlayerEmployData instance ].PlayerArray.count ; ++i )
    {
        [ itemArray addObject:[ [ PlayerEmployData instance ].PlayerArray objectAtIndex:i ] ];
    }
    
    if ( !itemArray.count )
    {
        [ employButton setHidden:YES ];
        [ scrollPageLabel setHidden:YES ];
        
        [ self clearData ];
        
        return;
    }
    
    for ( int i = 0 ; i < itemArray.count ; ++i )
    {
        [ scrollView addItem:[ itemArray objectAtIndex:i ] ];
    }
    
    
    [ scrollView updateContentSize ];
    [ scrollView setNeedsLayout ];
    
    int count = [ scrollView getPageCount ];
    [ scrollPageLabel setText:[ NSString stringWithFormat:@"%d/%d" , 1 , count ] ];
    [ scrollPageLabel setHidden:!count ];
    
    CreatureCommonData* comm = [ itemArray objectAtIndex:0 ];
    [ self updateData:comm ];
    [ self setPos:0 ];
    
    [ employButton setHidden:NO ];
    [ fireButton setHidden:YES ];
}


- ( void ) updatePlayerData
{
    if ( !view )
    {
        return;
    }
    
    [ scrollView clear ];
    [ itemArray removeAllObjects ];
    
    NSMutableDictionary* dic = [ PlayerCreatureData instance ].PlayerDic;
    NSArray* arr = getSortKeys( dic );
    
    for ( int i = 0 ; i < arr.count ; ++i )
    {
        [ itemArray addObject:[ dic objectForKey:[ arr objectAtIndex:i ] ] ];
    }
    
    for ( int i = 0 ; i < itemArray.count ; ++i )
    {
        [ scrollView addItem:[ itemArray objectAtIndex:i ] ];
    }
    
    [ scrollView updateContentSize ];
    [ scrollView setNeedsLayout ];
    
    int count = [ scrollView getPageCount ];
    [ scrollPageLabel setText:[ NSString stringWithFormat:@"%d/%d" , 1 , count ] ];
    [ scrollPageLabel setHidden:!count ];
    
    CreatureCommonData* comm = [ itemArray objectAtIndex:0 ];
    [ self updateData:comm ];
    
    [ employButton setHidden:YES ];
    [ fireButton setHidden:YES ];
}


- ( void ) updateData:( CreatureCommonData* )com
{
    NSString* str = [ NSString stringWithFormat:@"CS%@AA" , com.Action ];
    NSString* path = [ [ NSBundle mainBundle ] pathForResource:str ofType:@"png" inDirectory:CREATURE_PATH ];
    UIImage* image = [ UIImage imageWithContentsOfFile:path ];
    
    CGSize sz = image.size;
    [ imageView setImage:image ];
    CGRect rect = imageView.frame;
    
    if ( gActualResource.type >= RESPAD2 )
    {
        
    }
    else
    {
        sz.width *= 0.5f;
        sz.height *= 0.5f;
    }
    
    rect.size = sz;
    
    
    CGPoint point = centerPoint;
    if ( com.ImageOffsetX )
    {
        point.x += -sz.width * 0.5f + com.ImageOffsetX;
    }
    else
    {
        point.x += -sz.width * 0.5f;
    }
    
    if ( com.ImageOffsetY )
    {
        point.y += -sz.height + com.ImageOffsetY;
    }
    else
    {
        point.y += -sz.height;
    }
    
    rect.origin = point;
    
    [ imageView setFrame:rect ];
    
    NSString* str1 = [ NSString localizedStringWithFormat:NSLocalizedString( @"EmployText" , nil ) , [ com getEmployPrice ] ];
    [ employLabel setText:str1 ];
    
    [ self updateGold ];
}

- ( void ) updateGold
{
    [ goldLabel setText:[ NSString stringWithFormat:@"%d" , [ PlayerData instance ].Gold ] ];
}

- ( void ) scrollViewDidEndDecelerating:( UIScrollView* )sv
{
    int index = fabs( sv.contentOffset.x ) / sv.frame.size.width;
    
    [ scrollPageLabel setText:[ NSString stringWithFormat:@"%d/%d" , index + 1 , [ scrollView getPageCount ] ] ];
    
    scrollView.SelectIndex = index;
    
    CreatureCommonData* comm = [ itemArray objectAtIndex:index ];
    [ self updateData:comm ];
}


- ( void ) setFireMode
{
    [ fireButton setHidden:NO ];
}


- ( void ) setMode:( int )m
{
    mode = m;
    
    switch ( m )
    {
        case PlayerInfoUINormal:
        case PlayerInfoUIItem:
        {
            [ self updatePlayerData ];
        }
            break;
        case PlayerInfoUIEmploy:
        {
            [ self updateEmployData ];
        }
            break;
        
            break;
    }
    
}


- ( void ) setPos:( int )p
{
    [ scrollPageLabel setText:[ NSString stringWithFormat:@"%d/%d" , p + 1 , [ scrollView getPageCount ] ] ];
    
    [ scrollView setPos:p ];
    
    CreatureCommonData* comm = [ itemArray objectAtIndex:p ];
    [ self updateData:comm ];
}


- ( void ) clearData
{
    [ imageView setImage:NULL ];
    
    [ employLabel setText:@"" ];
    [ goldLabel setText:@"" ];
    
    [ employButton setHidden:YES ];
    [ fireButton setHidden:YES ];
}


- ( void ) onEmploy
{
    if ( scrollView.DataCount )
    {
        int select = scrollView.SelectIndex;
        
        if ( [ [ PlayerEmployData instance ] canEmploy:select ] )
        {
            playSound( PST_OK );
            [ [ AlertUIHandler instance ] alert:NSLocalizedString( @"Employ", nil ) ];
        }
        else
        {
            playSound( PST_ERROR );
            [ [ AlertUIHandler instance ] alert:NSLocalizedString( @"NotGold", nil ) ];
            return;
        }
        
        [ self updateGold ];
        
        
        [ [ PlayerEmployData instance ] employ:select ];
        //[ scrollView removeItem:select ];
        [ itemArray removeObjectAtIndex:select ];
        [ [ PublicUIHandler instance ] updateGold ];
        
        [ self updateEmployData ];
    }
    else
    {
        
    }
}



- ( void ) onFire
{
    CreatureCommonData* comm = [ itemArray objectAtIndex:scrollView.SelectIndex ];
    [ self updateData:comm ];
    
    if ( !comm.EmployPrice )
    {
        playSound( PST_ERROR );
        
        [ [ AlertUIHandler instance ] alert:NSLocalizedString( @"Notfire", nil ) ];
        return;
    }
    
    playSound( PST_OK );
    
    [ [ AlarmUIHandler instance ] alarm :NSLocalizedString( @"Fire", nil ) :self :@selector(onFire1) :NULL :NULL ];
}


- ( void ) onFire1
{
    CreatureCommonData* comm = [ itemArray objectAtIndex:scrollView.SelectIndex ];
    
    [ [ PlayerCreatureData instance ] removeCommonData:comm.cID ];
    
    
    if ( scrollView.DataCount )
    {
        int select = scrollView.SelectIndex;
        
        [ itemArray removeObjectAtIndex:select ];
        
        [ self updatePlayerData ];
        [ self setPos:scrollView.SelectIndex ];
        [ self setFireMode ];
    }
    else
    {
        
    }
}


- ( void ) onClick:( PlayerInfoView* )info
{
    if ( !info )
    {
        return;
    }
    
    
}


- ( void ) onBack
{
    [ self visible:NO ];
    
    playSound( PST_CANCEL );
}


@end
