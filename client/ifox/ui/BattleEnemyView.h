//
//  BattleEnemyView.h
//  sc
//
//  Created by fox on 13-9-3.
//
//

#import <UIKit/UIKit.h>

#import "BattleNumberView.h"
#import "CreatureConfig.h"
#import "UIEffectAction.h"


@interface BattleEnemyView : UIView
{
    BattleNumberView* numberViewOri;
    BattleNumberView* numberView;
    
    UIImageView* imageView;
    
    CGPoint centerPoint;
    CGPoint centerPointHP;
    CGRect rectHP;
    CGRect rectHPBG;
    CGRect rectBossHP;
    CGRect rectBossHPBG;


    UIImageView* imageViewHP;
    UIImageView* imageViewHPBG;
    
    float hpWidth;
    
    UIEffectAction* effect;
    
    BOOL boss;
    BOOL sp;
    float timeSP;
    BOOL addSP;
    
    CreatureCommonData* comm;
}


- ( void ) startFight;
- ( void ) fight:( int )hp :( int )hit :( NSString* )eff :( BOOL )sound;
- ( void ) fightF:( float )f :( NSString* )eff :( BOOL )sound;

- ( void ) setData:( CreatureCommonData* )c :( BOOL )b :( BOOL )sp;

- ( void ) initBattleEnemyView;
- ( void ) releaseBattleEnemyView;

- ( void ) update:( float )d;



@end
