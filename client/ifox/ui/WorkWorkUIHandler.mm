//
//  WorkWorkUIHandler.m
//  sc
//
//  Created by fox on 13-1-17.
//
//

#import "WorkWorkUIHandler.h"
#import "WorkFurnitureUIHandler.h"
#import "WorkWorkUIView.h"
#import "PlayerData.h"


@implementation WorkWorkUIHandler

@synthesize SelectFloor;


static WorkWorkUIHandler* gWorkWorkUIHandler;
+ (WorkWorkUIHandler*) instance
{
    if ( !gWorkWorkUIHandler )
    {
        gWorkWorkUIHandler = [ [ WorkWorkUIHandler alloc] init ];
        [ gWorkWorkUIHandler initUIHandler:@"WorkWorkUIView" isAlways:YES isSingle:NO ];

    }
    
    return gWorkWorkUIHandler;
}


- ( void ) onInited
{
    [ super onInited ];
    
    for ( int i = 100 ; i < 200 ; ++i )
    {
        WorkWorkFloor* button = (WorkWorkFloor*)[ view viewWithTag:i ];
        
        if ( i >= 100 && i < 110 )
        {
            button.Type = WUT_HOME;
            
            if ( button )
            {
                workButton[ WUT_HOME ][ i - 100 ] = button;
            }
        }
        else if ( i >= 110 && i < 130 )
        {
            button.Type = WUT_WORK;

            if ( button )
            {
                workButton[ WUT_WORK ][ i - 110 ] = button;
            }
        }
        else if ( i >= 130 && i < 160 )
        {
            button.Type = WUT_SHOP;
            
            if ( button )
            {
                workButton[ WUT_SHOP ][ i - 130 ] = button;
            }
        }
        else
        {
            button.Type = WUT_GROUND;
            
            if ( button )
            {
                workButton[ WUT_GROUND ][ i - 160 ] = button;
            }
        }
        
        
        
        int itemID = [ [ PlayerData instance ] getWorkItemData:i ];
        if ( itemID )
        {
            [ button setItem:itemID ];
        }
        
        [ button addTarget:self action:@selector(onFloorClick:) forControlEvents:UIControlEventTouchUpInside ];
    }
}

- ( void ) onOpened
{
    [ super onOpened ];
    
    [ self updateData ];
}


- ( void ) onClosed
{
    [ super onClosed ];
    
    SelectFloor = NULL;
}

- ( void ) updateLevel
{
    for ( int i = 0 ; i < 32 ; ++i )
    {
        for ( int j = 0 ; j < WUT_COUNT ; j++ )
        {
            [ workButton[ j ][ i ] setHidden:YES ];
        }
    }
    
    for ( int i = 0 ; i < [ PlayerData instance ].WorkLevel[ WUT_HOME ] ; ++i )
    {
        [ workButton[ WUT_HOME ][ i ] setHidden:NO ];
    }
    for ( int i = 0 ; i < [ PlayerData instance ].WorkLevel[ WUT_GROUND ] ; ++i )
    {
        [ workButton[ WUT_GROUND ][ i ] setHidden:NO ];
    }
    for ( int i = 0 ; i < [ PlayerData instance ].WorkLevel[ WUT_WORK ] ; ++i )
    {
        [ workButton[ WUT_WORK ][ i ] setHidden:NO ];
    }
    for ( int i = 0 ; i < [ PlayerData instance ].WorkLevel[ WUT_SHOP ] ; ++i )
    {
        [ workButton[ WUT_SHOP ][ i ] setHidden:NO ];
    }
}


- ( void ) onFloorClick:( UIButton* )button
{
    WorkWorkUIView* view1 = (WorkWorkUIView*)view;
    
    if ( !view1.EditMode )
    {
        return;
    }
    
    SelectFloor = (WorkWorkFloor*)button;
    
    [ [ WorkFurnitureUIHandler instance ] visible:YES ];
    
    playSound( PST_OK );
}



- ( void ) updateData
{
    UILabel* label = (UILabel*)[ view viewWithTag:1300 ];
    [ label setText:[NSString stringWithFormat:@"%d" , [ PlayerData instance ].WorkRank ] ];
    
    label = (UILabel*)[ view viewWithTag:1301 ];
    [ label setText:[NSString stringWithFormat:@"%d" , [ PlayerData instance ].AssessRank ] ];
    
    label = (UILabel*)[ view viewWithTag:1310 ];
    [ label setText:[NSString stringWithFormat:@"%d/%d" , [ PlayerData instance ].WorkLevel[0] , MAX_WORK_RANK ] ];
    label = (UILabel*)[ view viewWithTag:1311 ];
    [ label setText:[NSString stringWithFormat:@"%d/%d" , [ PlayerData instance ].WorkLevel[1] , MAX_WORK_RANK ] ];
    label = (UILabel*)[ view viewWithTag:1312 ];
    [ label setText:[NSString stringWithFormat:@"%d/%d" , [ PlayerData instance ].WorkLevel[2] , MAX_WORK_RANK ] ];
    label = (UILabel*)[ view viewWithTag:1313 ];
    [ label setText:[NSString stringWithFormat:@"%d/%d" , [ PlayerData instance ].WorkLevel[3] , MAX_WORK_RANK ] ];
    
    label = (UILabel*)[ view viewWithTag:1302 ];
    [ label setText:[NSString stringWithFormat:@"%d" , [ PlayerData instance ].AlchemyRank ] ];
    
    label = (UILabel*)[ view viewWithTag:1303 ];
    [ label setText:[NSString stringWithFormat:@"%d" , [ PlayerData instance ].getGold ] ];
    
    [ self updateLevel ];
}

- ( void ) update:(float)delay
{
    for ( int i = 0 ; i < WUT_COUNT ; ++i )
    {
        for ( int j = 0 ; j < 32 ; ++j )
        {
            [ workButton[i][j] update:delay ];
        }
    }
}




@end
