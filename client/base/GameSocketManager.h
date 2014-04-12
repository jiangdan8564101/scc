//
//  GameSocketManager.h
//  SoraTD
//
//  Created by fox on 13-3-21.
//
//

#ifndef GameSocketManager_h
#define GameSocketManager_h


#include "clientDefine.h"
#include "GameSocket.h"

#include "netMsgDefine.h"


struct GameSocketManagerMsgHandler
{
    GameSocketManagerMsgHandler()
    : f( F_NULL )
    {
    }
    
    fvoid*  f;
    string  des;
};

class GameSocketManager : public baseSingle< GameSocketManager >
{
    
public:
    
    static fvoid    init();
    
    static fbool    isConnected();
    
    static fbool    MainSocketConnect( const fbyte* ip , fint32 port );
    static fvoid    MainSocketSendMsg( netSocketHead* head );
    static fvoid    MainSocketRegeditMsg( fint32 msg , fvoid* handler , const fbyte* des );
    
    static fvoid    MainSocketUpdate( freal32 delay );



};

//extern GameSocketManager* gGameSocketManager;

#endif


