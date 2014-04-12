//
//  InfoMonsterItem.m
//  sc
//
//  Created by fox on 13-12-31.
//
//

#import "InfoMonsterItem.h"
#import "CreatureConfig.h"
#import "InfoEmployScrollView.h"
#import "InfoMonsterUIHandler.h"
#import "SceneData.h"

@implementation InfoMonsterItem

@synthesize CreautreID;


- ( void ) setData:( NSObject* )obj
{
    NSNumber* num = ( NSNumber* )obj;
    
    CreatureCommonData* comm = [ [ CreatureConfig instance ] getCommonData:[ num intValue ] ];
    
    UILabel* label = (UILabel*)[ self viewWithTag:100 ];
    [ label setText:[ NSString stringWithFormat:@"%d" , comm.EnemyIndex ] ];
    
    label = ( UILabel* )[ self viewWithTag:101 ];
    
    
    if ( [ [ SceneData instance ] getEnemy:comm.ID ] )
    {
        [ label setText:comm.Name ];
    }
    else
    {
        [ label setText:@"？？？？？？？" ];
    }
    
    
    
    CreautreID = [ num intValue ];
}


- ( void ) updateData
{
    
}


- ( void ) setSelect:( BOOL )b
{
    
}





@end
