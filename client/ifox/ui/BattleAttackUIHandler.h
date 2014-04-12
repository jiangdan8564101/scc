//
//  BattleAttackUIHandler.h
//  sc
//
//  Created by fox on 13-5-5.
//
//

#import "UIHandler.h"
#import "netMsgDefine.h"
#import "BattleNumberView.h"

@interface BattleAttackUIHandler : UIHandler
{
    battleResult    result;
    
    BattleNumberView* viewHP1;
    BattleNumberView* viewHP2;
    
    fint32          playTurn;
}


+ ( BattleAttackUIHandler* ) instance;

- ( void ) setData:( battleResult* )r;

- ( void ) play;

@end
