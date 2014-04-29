//
//  BattleCreatureView.h
//  sc
//
//  Created by fox on 13-9-2.
//
//

#import <UIKit/UIKit.h>
#import "BattleNumberView.h"
#import "CreatureConfig.h"
#import "UILabelStroke.h"
#import "UIEffectAction.h"


@interface BattleCreatureView : UIView
{
    BattleNumberView* numberViewOri;
    BattleNumberView* numberView;
    
    UIImage* imageNormal;
    UIImage* imageDead;
    
    UIImageView* imageView;
    UIView* view;
    
    UIImageView* hpView;
    UIImageView* spView;
    UIImageView* fsView;
    UIImageView* bgView;
    
    UILabelStroke* hpLabel;
    UILabelStroke* spLabel;
    UILabelStroke* fsLabel;
    UILabelStroke* lvLabel;
    
    UIEffectAction* effect;
    
    UIView* deadMask;
}

- ( void ) startFight;
- ( void ) fight:( int )hp :( int )hit :( NSString* )eff :( BOOL )sound;
- ( void ) fightF:( float )f :( NSString* )eff :( BOOL )sound;

- ( void ) setData:( CreatureCommonData* )c;
- ( void ) updateData:( CreatureCommonData* )c;

- ( void ) initBattleCreatureView;
- ( void ) releaseBattleCreatureView;

- ( void ) update:( float )d;

@end
