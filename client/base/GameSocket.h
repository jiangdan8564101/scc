
#ifndef _GAMESOCKET_H_
#define _GAMESOCKET_H_


#include "GameSocketIOBuffer.h"




#define SOCKET_DEFAULT_READ_BUFFER_SIZE 4096000
#define SOCKET_MAX_PENDING_CONNECTIONS 5


#define SOCKET_EX_ACCEPT_FAILED				@"Socket: Accept failed"
#define SOCKET_EX_ACCEPT_FAILED_F			@"Socket: Accept failed: %s"
#define SOCKET_EX_ALREADY_CONNECTED			@"Socket: Already connected"
#define SOCKET_EX_BAD_SOCKET_DESCRIPTOR		@"Socket: Bad socket descriptor"
#define SOCKET_EX_BIND_FAILED				@"Socket: Bind failed"
#define SOCKET_EX_BIND_FAILED_F				@"Socket: Bind failed: %s"
#define SOCKET_EX_CANT_CREATE_SOCKET		@"Socket: Can't create socket"
#define SOCKET_EX_CANT_CREATE_SOCKET_F		@"Socket: Can't create socket: %s"
#define SOCKET_EX_CONNECT_FAILED			@"Socket: Connect failed"
#define SOCKET_EX_CONNECT_FAILED_F			@"Socket: Connect failed: %s"
#define SOCKET_EX_FCNTL_FAILED				@"Socket: Fcntl failed"
#define SOCKET_EX_FCNTL_FAILED_F			@"Socket: Fcntl failed: %s"
#define SOCKET_EX_HOST_NOT_FOUND			@"Socket: Host not found"
#define SOCKET_EX_HOST_NOT_FOUND_F			@"Socket: Host not found: %s"
#define SOCKET_EX_INVALID_BUFFER			@"Socket: Invalid buffer"
#define SOCKET_EX_LISTEN_FAILED				@"Socket: Listen failed"
#define SOCKET_EX_LISTEN_FAILED_F			@"Socket: Listen failed: %s"
#define SOCKET_EX_MALLOC_FAILED				@"Socket: Malloc failed"
#define SOCKET_EX_NOT_CONNECTED				@"Socket: Not connected"
#define SOCKET_EX_NOT_LISTENING				@"Socket: Not listening"
#define SOCKET_EX_RECV_FAILED				@"Socket: Recv failed"
#define SOCKET_EX_RECV_FAILED_F				@"Socket: Recv failed: %s"
#define SOCKET_EX_SELECT_FAILED				@"Socket: Select failed"
#define SOCKET_EX_SELECT_FAILED_F			@"Socket: Select failed: %s"
#define SOCKET_EX_SEND_FAILED				@"Socket: Send failed"
#define SOCKET_EX_SEND_FAILED_F				@"Socket: Send failed: %s"
#define SOCKET_EX_SETSOCKOPT_FAILED			@"Socket: Setsockopt failed"
#define SOCKET_EX_SETSOCKOPT_FAILED_F		@"Socket: Setsockopt failed: %s"

// Default, uninitialized values for instance variables

#define SOCKET_INVALID_PORT	0
#define SOCKET_INVALID_DESCRIPTOR -1

// AbstractSocket interface
//
// AbstractSocket is an abstract base class, intended to provide functionality
// that is common to its subclasses.  You should not be creating AbstractSockets
// in your code.  More likely, you want to create a Socket or BufferedSocket,
// both of which inherit from this class.

class GameSocket
{
public:

    GameSocket();
    ~GameSocket();
    
    GameSocketIOBuffer&     GetIBuffer()
    {
        return iBuffer;
    }
    GameSocketIOBuffer&     GetOBuffer()
    {
        return oBuffer;
    }
    
    //pthread_mutex_init(&s_requestQueueMutex, NULL);
    //pthread_mutex_init(&s_responseQueueMutex, NULL);
    
    //pthread_create(&s_networkThread, NULL, networkThread, NULL);
    //pthread_detach(s_networkThread);
    
    fvoid   open();
    fvoid   close();
    
    fbool   isConnected();
    
    fbool   connectToHostName( const fbyte* hostName , fuint16 port );
    fbool   connectToHostNameTimeTest( const fbyte* hostName , fuint16 port , fint32 t );
    
    fbool   isReadable();
    fbool   isWritable();
    
    fuint32 getReadBufferSize();
    
    fvoid   recvData();
    fvoid   sendData();
    
    fvoid   writeData( netSocketHead* head );
    
    fvoid   setBlocking( fbool shouldBlock );
    
    const fbyte*    getRemoteHostName();
    fuint16         getRemoteHostPort();
    
    fvoid   runThread();
    
private:
    
    fbool 			connected;
    fbool			listening;
    
    fuint32         readBufferSize;
    string          remoteHostName;
    fuint16         remotePort;
    int 			socketfd;
    
    GameSocketIOBuffer  oBuffer;
    GameSocketIOBuffer  iBuffer;
    
    fbool           opened;
};


#endif

