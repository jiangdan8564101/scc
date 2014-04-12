//
//  netMsgDefine.h
//  test
//
//  Created by fox on 13-1-9.
//
//

#ifndef netMsgDefine_h
#define netMsgDefine_h

#include "netMsgType.h"


//////////////////////////////////////////////////////////////////////////
//@ login

#pragma pack(1)

//struct SEND_MSG_LOGIN : public netSocketHead
//{
//    fint32 login;
//    
//    SEND_MSG_LOGIN()
//    {
//        size = sizeof( *this );
//        type = _MSG_SEND_LOGIN_GAMESERVICE;
//    }
//};
//
//struct RECV_MSG_LOGIN : public netSocketHead
//{
//    fint32 login;
//    
//    fint32 guid;
//    fint32 money;
//    fint32 gold;
//        
//    RECV_MSG_LOGIN()
//    {
//        size = sizeof( *this );
//        type = _MSG_RECV_LOGIN_GAMESERVICE;
//    }
//};
//
//
//
//
//struct SEND_MSG_LOGIN_DATA : public netSocketHead
//{
//    SEND_MSG_LOGIN_DATA()
//    {
//        size = sizeof( *this );
//        type = _MSG_SEND_LOGIN_DATA;
//    }
//};
//
//struct RECV_MSG_LOGIN_CREATRUE : public netSocketHead
//{
//    fint32 count;
//    
//    gameCreatureCommonData data[ MAX_PLAYER_CREATURE ];
//    
//    RECV_MSG_LOGIN_CREATRUE()
//    {
//        size = sizeof( *this );
//        type = _MSG_RECV_LOGIN_CREATURE;
//    }
//};
//
//
//
////////////////////////////////////////////////////////////////////////////
////@ battle
//
//struct SEND_MSG_BATTLE : public netSocketHead
//{
//    fint32 scene;
//    
//    SEND_MSG_BATTLE()
//    :   scene( 0 )
//    {
//        size = sizeof( *this );
//        type = _MSG_SEND_BATTLE;
//    }
//};
//
//
//struct RECV_MSG_BATTLE : public netSocketHead
//{
//    fint32 scene;
//    fint32 fight;
//    
//    RECV_MSG_BATTLE()
//    : fight( 0 ) , scene( 0 )
//    {
//        size = sizeof( *this );
//        type = _MSG_RECV_BATTLE;
//    }
//};
//
//
//struct SEND_MSG_BATTLE_FIGHT : public netSocketHead
//{
//    fint16 ID;
//    fint16 targetID;
//    
//    // 这里不严谨，要修改成服务器校验。
//    fint16 hp;
//    
//    SEND_MSG_BATTLE_FIGHT()
//    : ID( 0 ) , targetID( 0 ) , hp( 0 )
//    {
//        size = sizeof( *this );
//        type = _MSG_SEND_BATTLE_FIGHT;
//    }
//};
//
//
//
//
//struct battleResultTurn
//{
//    fbyte   type;
//    fbyte   side;
//    
//    fint16  hp;
//    fint16  sp;
//    fint16  fs;
//};
//
//struct battleDead
//{
//    fbyte   isdead;
//    
//    fint16  item[ MAX_BATTLE_ITEM ];
//    
//    fbyte   islevelup;
//    
//    gameCreatureCommonData data;
//};
//
//
//struct battleResult
//{
//    fint32          turn;
//    
//    fint32          ID;
//    fint32          targetID;
//    
//    battleResultTurn    turns[ MAX_BATTLE_TURN ];
//    
//    fbyte exp;
//};
//
//struct RECV_MSG_BATTLE_FIGHT : public netSocketHead
//{
//    battleResult result;
//    battleDead dead;
//    
//    RECV_MSG_BATTLE_FIGHT()
//    {
//        size = sizeof( *this );
//        type = _MSG_RECV_BATTLE_FIGHT;
//    }
//};
//
//
//struct SEND_MSG_BATTLE_RESULT : public netSocketHead
//{
//    fint32 scene;
//    
//    SEND_MSG_BATTLE_RESULT()
//    :   scene( 0 )
//    {
//        size = sizeof( *this );
//        type = _MSG_SEND_BATTLE_RESULT;
//    }
//};
//
//struct RECV_MSG_BATTLE_RESULT : public netSocketHead
//{
//    fint32 scene;
//    fint32 result;
//    
//    RECV_MSG_BATTLE_RESULT()
//    :   scene( 0 ) , result( 0 )
//    {
//        size = sizeof( *this );
//        type = _MSG_RECV_BATTLE_RESULT;
//    }
//};

#pragma pop

//////////////////////////////////////////////////////////////////////////
// 



//////////////////////////////////////////////////////////////////////////


#endif

