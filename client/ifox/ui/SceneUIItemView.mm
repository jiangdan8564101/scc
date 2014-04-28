//
//  SceneUIItemView.m
//  sc
//
//  Created by fox on 13-2-11.
//
//

#import "SceneUIItemView.h"
#import "MapConfig.h"
#import "SceneData.h"
#import "PlayerCreatureData.h"


@implementation SceneUIItemView
@synthesize SubSceneID;


- ( void ) setData:( SubSceneMap* )data
{
    SubSceneID = data.ID;
    
    SceneDataItem* item = [ [ SceneData instance ] getSceneData:data.ID ];
    
    UILabel* label = (UILabel*)[ self viewWithTag:100 ];
    [ label setText:data.Name ];
    
    label = (UILabel*)[ self viewWithTag:101 ];
    [ label setText:[ NSString stringWithFormat:@"%d" , data.LV ] ];
    
    label = (UILabel*)[ self viewWithTag:102 ];
    [ label setText:[ NSString stringWithFormat:NSLocalizedString( @"occupy" , nil ) ] ];
    label = (UILabel*)[ self viewWithTag:103 ];
    
    [ label setText:[ NSString stringWithFormat:@"%.0f%%" , item.Per * 100 ] ];
    
    UIImageView* imageView = (UIImageView*)[ self viewWithTag:106 ];
    if ( item.Complete )
    {
        label = (UILabel*)[ self viewWithTag:102 ];
        [ label setHidden:YES ];
        
        label = (UILabel*)[ self viewWithTag:103 ];
        [ label setHidden:YES ];
        
        [ imageView setHidden:NO ];
    }
    else
    {
        [ imageView setHidden:YES ];
    }
    
    imageView = (UIImageView*)[ self viewWithTag:107 ];
    [ imageView setHidden:!item.SPEnemy ];
    
    [ self updateTeam ];
}

- ( void ) updateTeam
{
    UILabel* label = (UILabel*)[ self viewWithTag:99 ];
    
    int t = [[ PlayerCreatureData instance ] getSendTeam:SubSceneID ];
    
    if ( t != INVALID_ID )
    {
        NSString* str1 = [ NSString localizedStringWithFormat:NSLocalizedString( @"TeamN" , nil ) , t + 1 ];
        [ label setText:str1 ];
    }
    else
    {
        [ label setText:@"" ];
    }
    
}


- ( void ) setNew:( BOOL )b
{
    UIImageView* imageView = (UIImageView*)[ self viewWithTag:110 ];
    [ imageView setHidden:!b ];
}


@end

