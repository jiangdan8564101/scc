//
//  LoginNetHandler.m
//  sc
//
//  Created by fox on 12-10-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LoginNetHandler.h"

#import "PlayerData.h"
#import "PlayerCreatureData.h"
#import "GameLogin.h"
#import "GameMain.h"
//
//void recvMsgLoginServer( netSocketHead* msg )
//{
//    RECV_MSG_LOGIN* login = ( RECV_MSG_LOGIN* )msg;
//    
//    [ PlayerData instance ].GUID = login->guid;
//    [ PlayerData instance ].Money = login->money;
//    [ PlayerData instance ].Gold = login->gold;
//    
//    [ LoginNetHandler sendMsgLoginData ];
//}
//
//
//void recvMsgLoginCreature( netSocketHead* msg )
//{
//    RECV_MSG_LOGIN_CREATRUE* login = ( RECV_MSG_LOGIN_CREATRUE* )msg;
//    
//    
//    for ( int i = 0 ; i < login->count ; i++ )
//    {
//        CreatureCommonData* data = [ [ CreatureCommonData alloc ] init ];
//        
//        data.ID = login->data[ i ].ID;
//        data.TitleID = login->data[ i ].titleID;
//        [ data.Name setString:[ NSString stringWithUTF8String: login->data[ i ].name ] ];
//        [ data.Action setString:[ [ PlayerConfig instance ] getAction:data.ID] ];
//        data.Type = login->data[ i ].type;
//        data.Battle = login->data[ i ].battle;
//        data.Level = login->data[ i ].level;
//        data.WeaponLevel = login->data[ i ].weaponLevel;
//        data.EXP = login->data[ i ].EXP;
//        data.MaxEXP = login->data[ i ].maxEXP;
//        
//        
//        for ( int j = 0 ; j < GCACount ; j++ )
//        {
//            [ data.Attribute addObject:[ NSNumber numberWithInt:login->data[ i ].attribute[ j ] ] ];
//        }
//        for ( int j = 0 ; j < MAX_SKILL ; j++ )
//        {
//            [ data.Skill addObject:[ NSNumber numberWithInt:login->data[ i ].skill[ j ] ] ];
//        }
//        for ( int j = 0 ; j < GCECount ; j++ )
//        {
//            [ data.Equip addObject:[ NSNumber numberWithInt:login->data[ i ].equip[ j ] ] ];
//        }
//        
//        data.BaseData.HP = login->data[ i ].baseData.HP;
//        data.BaseData.MaxHP = login->data[ i ].baseData.maxHP;
//        data.BaseData.SP = login->data[ i ].baseData.SP;
//        data.BaseData.MaxSP = login->data[ i ].baseData.maxSP;
//        data.BaseData.FS = login->data[ i ].baseData.FS;
//        data.BaseData.MaxFS = login->data[ i ].baseData.maxFS;
//        data.BaseData.PAtk = login->data[ i ].baseData.pAtk;
//        data.BaseData.PDef = login->data[ i ].baseData.pDef;
//        data.BaseData.MAtk = login->data[ i ].baseData.mAtk;
//        data.BaseData.MDef = login->data[ i ].baseData.mDef;
//        data.BaseData.Agile = login->data[ i ].baseData.agile;
//        data.BaseData.Lucky = login->data[ i ].baseData.lucky;
//        data.BaseData.Hit = login->data[ i ].baseData.hit;
//        data.BaseData.Miss = login->data[ i ].baseData.miss;
//        data.BaseData.Critical = login->data[ i ].baseData.critical;
//        data.BaseData.Move = login->data[ i ].baseData.move;
//        data.BaseData.CP = login->data[ i ].baseData.cp;
//        data.BaseData.Guest = login->data[ i ].baseData.guest;
//        data.BaseData.Command = login->data[ i ].baseData.command;
//        data.BaseData.Kill = login->data[ i ].baseData.kill;
//        
//        [ [ PlayerCreatureData instance ] setCommonData:data.ID :data ];
//                
//        [ data release];
//    }
//    
//    [ [ GameLogin instance ] releaseGameLogin ];
//    [ [ GameMain instance ] initGameMain ];
//}
//
//
//@implementation LoginNetHandler
//
//+ ( void ) sendMsgLoginData
//{
//    SEND_MSG_LOGIN_DATA msg;
//    
//    GameSocketManager::MainSocketSendMsg( &msg );
//}
//
//+ (void) sendMsgLoginServer
//{
//    SEND_MSG_LOGIN msg;
//    
//    msg.login = 1;
//    GameSocketManager::MainSocketSendMsg( &msg );
//}
//
//
//+ ( void ) initNetHandler
//{
//    GameSocketManager::MainSocketRegeditMsg( _MSG_RECV_LOGIN_GAMESERVICE , (void*)(&recvMsgLoginServer) , "login" );
//    GameSocketManager::MainSocketRegeditMsg( _MSG_RECV_LOGIN_CREATURE , (void*)(&recvMsgLoginCreature) , "login creature" );
//}
//
//
//@end
