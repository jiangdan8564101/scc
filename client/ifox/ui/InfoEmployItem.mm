//
//  InfoEmployItem.m
//  sc
//
//  Created by fox on 13-12-29.
//
//

#import "InfoEmployItem.h"
#import "CreatureConfig.h"
#import "InfoEmployScrollView.h"

@implementation InfoEmployItem

@synthesize CreautreID , Index;

- ( void ) setData:( int )data
{
    CreatureCommonData* comm = [ [ CreatureConfig instance ] getCommonData:data ];
    
    UILabel* label = (UILabel*)[ self viewWithTag:100 ];
    [ label setText:[ NSString stringWithFormat:@"%d" , comm.EnemyIndex ] ];
    
    label = ( UILabel* )[ self viewWithTag:101 ];
    [ label setText:comm.Name ];
    
    CreautreID = data;
}


- ( void ) updateData
{
    
}


- ( void ) setSelect:( BOOL )b
{
    
}





@end
