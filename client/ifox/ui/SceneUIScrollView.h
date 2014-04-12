//
//  SceneUIScrollView.h
//  sc
//
//  Created by fox on 13-2-11.
//
//

#import <UIKit/UIKit.h>
#import "SceneUIItemView.h"
#import "MapConfig.h"

@interface SceneUIScrollView : UIScrollView
{
    SceneUIItemView* itemView;
    SceneUIItemView* select;
    
    NSMutableDictionary* sceneDic;
    
    SceneMap* sceneMap;
    
    NSObject* object;
    SEL sel;
}


- ( void ) setData:( SceneMap* )sm;


- ( void ) initItemView:( SceneUIItemView* )item :( NSObject* )obj :( SEL )s;
- ( void ) releaseItemView;

@end
