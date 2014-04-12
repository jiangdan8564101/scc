//
//  InfoStoryScrollView.h
//  sc
//
//  Created by fox on 13-12-29.
//
//

#import <UIKit/UIKit.h>
#import "InfoStoryItem.h"


@interface InfoStoryScrollView : UIScrollView
{
    InfoStoryItem* itemView;
    
    NSMutableArray* array;
    
    NSObject* object;
    SEL sel;
}

@property ( nonatomic ) int DataCount;
@property ( nonatomic ) BOOL UseSelect;


- ( void ) initStoryScrollView:( InfoStoryItem* )item :( NSObject* )obj :( SEL )s;

- ( void ) updaContentSize;

- ( void ) removeItem:( int )i;
- ( void ) addItem:( StoryConfigData* )data;
- ( void ) setSelect:( int )i;

- ( InfoStoryItem* ) getItem:( int )i;

- ( void ) clear;

@end
