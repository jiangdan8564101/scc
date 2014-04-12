//
//  InfoStoryItem.m
//  sc
//
//  Created by fox on 13-12-29.
//
//

#import "InfoStoryItem.h"

@implementation InfoStoryItem
@synthesize StoryID , Index;

- ( void ) setData:( StoryConfigData* )data
{
    UILabel* label = (UILabel*)[ self viewWithTag:100 ];
    [ label setText:[ NSString stringWithFormat:@"%d" , data.Index ] ];
    
    label = ( UILabel* )[ self viewWithTag:101 ];
    [ label setText:data.Name ];
    
    StoryID = data.ID;
}


- ( void ) updateData
{
    
}


- ( void ) setSelect:( BOOL )b
{
    
}



@end
