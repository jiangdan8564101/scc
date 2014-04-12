//
//  BattleNetHandler.m
//  sc
//
//  Created by fox on 13-2-15.
//
//

#import "BattleNetHandler.h"
#import "BattleMapScene.h"
#import "GameSceneManager.h"
#import "BattleStage.h"

//
//@implementation BattleNetHandler
//
//
//
//void recvMsgBattle( netSocketHead* head )
//{
//    //RECV_MSG_BATTLE* msg = ( RECV_MSG_BATTLE* )head;
//    
//    
//}
//
//
//
//void recvMsgBattleFight( netSocketHead* head )
//{
//    RECV_MSG_BATTLE_FIGHT* msg = ( RECV_MSG_BATTLE_FIGHT* )head;
//    
//    [ [ BattleStage instance ] addResult:msg->result dead:msg->dead ];
//}
//
//void recvMsgBattleResult( netSocketHead* head )
//{
//    //RECV_MSG_BATTLE_RESULT* msg = ( RECV_MSG_BATTLE_RESULT* )head;
//    
//    
//    
//}
//
//
//
//
//
//+ (void) sendMsgBattle:( int )s
//{
//    SEND_MSG_BATTLE msg;
//    msg.scene = s;
//    
//    GameSocketManager::MainSocketSendMsg( &msg );
//}
//
//+ ( void ) sendMsgBattleFight:( int )i :( int )t :( int )hp
//{
//    SEND_MSG_BATTLE_FIGHT msg;
//    
//    msg.ID = i;
//    msg.targetID = t;
//    msg.hp = hp;
//    
//    GameSocketManager::MainSocketSendMsg( &msg );
//}
//
//
//
//+ ( void ) initNetHandler
//{
//    GameSocketManager::MainSocketRegeditMsg( _MSG_RECV_BATTLE , (void*)&recvMsgBattle , "" );
//    GameSocketManager::MainSocketRegeditMsg( _MSG_RECV_BATTLE_FIGHT , (void*)&recvMsgBattleFight , "" );
//    GameSocketManager::MainSocketRegeditMsg( _MSG_RECV_BATTLE_RESULT , (void*)&recvMsgBattleResult , "" );
//    
//}
//
//
//@end
