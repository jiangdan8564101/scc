//
//  SceneUIItemView.h
//  sc
//
//  Created by fox on 13-2-11.
//
//

#import <UIKit/UIKit.h>
#import "MapConfig.h"


@interface SceneUIItemView : UIView
{
    
}

@property ( nonatomic ) int SubSceneID;

- ( void ) updateTeam;

- ( void ) setData:( SubSceneMap* )data;
- ( void ) setNew:( BOOL )b;

@end
