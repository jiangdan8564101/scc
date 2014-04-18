//
//  UIFastScrollViewItem.h
//  sc
//
//  Created by fox on 14-1-5.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface UIFastScrollViewItem : UIView
{


}

@property( nonatomic ) int Index;

- ( void ) setData:( NSObject* ) data;
- ( void ) updateData;

- ( void ) clear;
- ( void ) setSelect:( BOOL )b;
- ( void ) setNew:( BOOL )b;
- ( void ) setNever:( BOOL )b;

@end
