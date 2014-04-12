//
//  UIFastScrollView.h
//  sc
//
//  Created by fox on 14-1-5.
//
//

#import <UIKit/UIKit.h>
#import "UIFastScrollViewItem.h"


@interface UIFastScrollView : UIScrollView
{
    NSMutableDictionary* onScreenViewDic;
    NSMutableArray* offScreenViewArray;
    
    int startIndex;
    int endIndex;
    
    
    NSMutableArray* dataArray;
    NSMutableArray* array;
    NSMutableArray* originPointArray;
    
    UIFastScrollViewItem* itemView;
    
    NSObject* object;
    SEL sel;

}

@property ( nonatomic ) int DataCount , SelectIndex;
@property ( nonatomic ) BOOL UseSelect , UseFirstSelect;


- ( void ) initFastScrollView:( UIFastScrollViewItem* )item :( NSObject* )obj :(SEL)s;

- ( int ) getPageCount;
- ( void ) updateContentSize;
- ( void ) setPos:( int )p;

- ( void ) removeItem:( int )i;
- ( void ) addItem:( NSObject* )d;
- ( void ) setSelect:( int )i;

- ( UIFastScrollViewItem* ) getItem:( int )i;

- ( void ) clear;



@end
