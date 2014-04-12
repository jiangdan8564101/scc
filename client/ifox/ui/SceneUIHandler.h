//
//  SceneUIHandler.h
//  sc
//
//  Created by fox on 13-2-10.
//
//

#import "UIHandlerZoom.h"
#import "MapConfig.h"
#import "SceneUIScrollView.h"
#import "SceneUIItemView.h"
#import "CreatureListItem.h"
#import "ItemConfig.h"


@interface SceneUIHandler : UIHandlerZoom
{
    SceneUIScrollView* scrollView;
    
    CreatureListItem* team[ MAX_BATTLE_PLAYER ];
    UIButton* teamButton[ MAX_TEAM ];
    
    UIView* teamView;
    
    int selectTeam;
    SceneUIItemView* selectScene;
    
    UIButton* startButton;
    UIButton* sendButton;
    UIButton* sendBackButton;
    
    UITextView* digTextView;
    UITextView* collectTextView;
    UITextView* creatureTextView;
    
    UILabel* nameLabel;
    UILabel* dayLabel;
    
    UITextView* teamLabel;
}

@property( nonatomic ) int SelScene , SelTeam;

+ ( SceneUIHandler* ) instance;

- ( void ) startBattle;

- ( void ) updateScene:( SceneMap* )sm;

@end
