//
//  InfoStoryItem.h
//  sc
//
//  Created by fox on 13-12-29.
//
//

#import <Foundation/Foundation.h>
#import "StoryConfig.h"


@interface InfoStoryItem : UIView


@property( nonatomic ) int StoryID , Index;

- ( void ) setData:( StoryConfigData* )data;

- ( void ) updateData;

- ( void ) setSelect:( BOOL )b;



@end
