//
//  InfoEmployScrollView.h
//  sc
//
//  Created by fox on 13-12-29.
//
//

#import "InfoEmployItem.h"

@interface InfoEmployScrollView : UIScrollView
{
    InfoEmployItem* itemView;
    
    NSMutableArray* array;
    
    NSObject* object;
    SEL sel;
}

@property ( nonatomic ) int DataCount;
@property ( nonatomic ) BOOL UseSelect;


- ( void ) initEmployScrollView:( InfoEmployItem* )item :( NSObject* )obj :( SEL )s;

- ( void ) updaContentSize;

- ( void ) removeItem:( int )i;
- ( void ) addItem:( int )data;
- ( void ) setSelect:( int )i;

- ( InfoEmployItem* ) getItem:( int )i;

- ( void ) clear;


@end
