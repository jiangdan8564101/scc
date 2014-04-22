//
//  BattleEndItem.m
//  sc
//
//  Created by fox on 13-5-19.
//
//

#import "BattleEndItemUIHandler.h"
#import "BattleLoseWinUIHandler.h"
#import "ItemData.h"
#import "GameSceneManager.h"
#import "BattleMapScene.h"
#import "PlayerData.h"

@implementation BattleEndItemUIHandler



static BattleEndItemUIHandler* gBattleEndItemUIHandler;
+ (BattleEndItemUIHandler*) instance
{
    if ( !gBattleEndItemUIHandler )
    {
        gBattleEndItemUIHandler = [ [ BattleEndItemUIHandler alloc] init ];
        [ gBattleEndItemUIHandler initUIHandler:@"BattleEndItemView" isAlways:NO isSingle:NO ];
    }
    
    return gBattleEndItemUIHandler;
}


- ( void ) onInited
{
    [ super onInited ];
    
    UIButton* button = (UIButton*)[ view viewWithTag:3000 ];
    [ button addTarget:self action:@selector(onTouchUp) forControlEvents:UIControlEventTouchUpInside ];
}


- ( void ) onTouchUp
{
    //[ self visible:NO ];
    //[ [ BattleLoseWinUIHandler instance ] show:YES ];
    
    [ self visible:NO ];
    
    if ( [ [ BattleMapScene instance ] checkEnd ] )
    {
        [ [ GameSceneManager instance ] activeScene:[ BattleMapScene instance ].SPMap ? GS_CITY : GS_WORLD ];
    }
    
    playSound( PST_OK );
}


- ( void ) setWin:( BOOL )win :( NSString* )name :( float )per
{
    UILabel* labelName = (UILabel*)[ view viewWithTag:2000 ];
    [ labelName setText:name ];
    
    UIImageView* imageView1 = ( UIImageView* )[ view viewWithTag:2001 ];
    UIImageView* imageView2 = ( UIImageView* )[ view viewWithTag:2002 ];
    UIImageView* imageView3 = ( UIImageView* )[ view viewWithTag:2003 ];

    if ( win )
    {
        if ( per == 1.0f )
        {
            [ imageView2 setHidden:YES ];
            [ imageView1 setHidden:NO ];
            [ imageView3 setHidden:YES ];
        }
        else
        {
            [ imageView2 setHidden:YES ];
            [ imageView1 setHidden:YES ];
            [ imageView3 setHidden:NO ];
        }
    }
    else
    {
        [ imageView2 setHidden:NO ];
        [ imageView1 setHidden:YES ];
        [ imageView3 setHidden:YES ];
    }
    
}

- ( void ) setData:( NSMutableDictionary* )dic :(int)gold
{
    UIImageView* imageView1 = (UIImageView*)[ view viewWithTag:3001 ];
    UIImageView* imageView2 = (UIImageView*)[ view viewWithTag:3002 ];
    imageView1.hidden = YES;
    imageView2.hidden = NO;
    
    for ( int i = 0 ; i < 10 ; i++ )
    {
        UIView* view1 = [ view viewWithTag:1000 + i ];
        [ view1 setHidden:YES ];
    }
    
    int count = 0;
    for ( int i = 0 ; i < dic.count ; i++ )
    {
        UIView* view1 = [ view viewWithTag:1000 + i ];
        
        if ( view1 )
        {
            [ view1 setHidden:NO ];
            
            int itemID = [ [ dic.allKeys objectAtIndex:i ] intValue ];
            
            if ( itemID )
            {
                PackItemData* itemData = [ [ ItemData instance ] getItem:itemID ];
                ItemConfigData* configData = [ [ ItemConfig instance ] getData:itemData.ItemID ];
                
                if ( configData.ID == GOLD_ITEM || configData.ID == SPECIAL_ITEM )
                {
                    imageView1.hidden = NO;
                    imageView2.hidden = YES;
                    
                    UILabel* labelName = (UILabel*)[ view1 viewWithTag:100 ];
                    [ labelName setTextColor:[ UIColor yellowColor ]  ];
                }
                else
                {
                    UILabel* labelName = (UILabel*)[ view1 viewWithTag:100 ];
                    [ labelName setTextColor:[ UIColor whiteColor ]  ];
                }
                
                if ( itemData )
                {
                    UILabel* labelName = (UILabel*)[ view1 viewWithTag:100 ];
                    [ labelName setText:configData.Name ];
                    
                    int nnn = [ [ dic objectForKey:[ NSNumber numberWithInt:itemID ] ] intValue ];
                    count += nnn;
                    UILabel* labelNum = (UILabel*)[ view1 viewWithTag:200 ];
                    [ labelNum setText:[ NSString stringWithFormat:@"%d" , nnn ] ];
                    
                    UILabel* labelNum1 = (UILabel*)[ view1 viewWithTag:300 ];
                    [ labelNum1 setText:[ NSString stringWithFormat:@"%d" , itemData.Number ] ];
                    
                    UIImageView* image = (UIImageView*)[ view1 viewWithTag:400 ];
                    image.hidden = NO;
                }
                
            }
        }
    }
    
    if ( gold )
    {
        UIView* view1 = [ view viewWithTag:1000 + dic.count ];
        
        if ( view1 )
        {
            [ view1 setHidden:NO ];
            
            UILabel* labelName = (UILabel*)[ view1 viewWithTag:100 ];
            [ labelName setText:NSLocalizedString( @"Gold" , nil ) ];
            [ labelName setTextColor:[ UIColor whiteColor ]  ];
            
            UILabel* labelNum = (UILabel*)[ view1 viewWithTag:200 ];
            [ labelNum setText:[ NSString stringWithFormat:@"%d" , gold ] ];
            
            UILabel* labelNum1 = (UILabel*)[ view1 viewWithTag:300 ];
            [ labelNum1 setText:@"" ];
            
            UIImageView* image = (UIImageView*)[ view1 viewWithTag:400 ];
            image.hidden = YES;
        }
       
    }
    
    
    UILabel* labelNum1 = (UILabel*)[ view viewWithTag:2010 ];
    [ labelNum1 setText:[ NSString stringWithFormat:@"%d" , count ] ];
    

    
}


- ( void ) update:(float)delay
{
    
}



@end
