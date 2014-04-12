//
//  ItemListScrollView.h
//  sc
//
//  Created by fox on 13-9-23.
//
//

#import <UIKit/UIKit.h>
#import "ItemListItem.h"
#import "ItemData.h"
#import "ProfessionConfig.h"

@interface ItemListScrollView : UIScrollView
{
    NSMutableDictionary* onScreenViewDic;
    NSMutableArray* offScreenViewArray;
    
    int startIndex;
    int endIndex;
    int selectIndex;
    
    NSMutableArray* dataArray;
    NSMutableArray* array;
    NSMutableArray* originPointArray;
    
    ItemListItem* itemView;
    
    NSObject* object;
    SEL sel;
}

@property ( nonatomic ) int DataCount;

- ( void ) initItemScrollView:( ItemListItem* )item :( NSObject* )obj :(SEL)s;

- ( int ) getPageCount;
- ( void ) updaContentSize;
- ( void ) setPos:( int )p;

- ( void ) removeItem:( int )i;
- ( void ) addItem:( PackItemData* )data;
- ( void ) addSkillItem:( ProfessionSkillData* )data;

- ( ItemListItem* ) getItem:( int )i;
- ( void ) setSelect:( int )i;

- ( void ) clear;

@end
