
 
#include "GameSocket.h"

#include <fcntl.h>
#include <netdb.h>
#include <netinet/in.h>
#include <sys/socket.h>
#include <sys/time.h>
#include <sys/types.h>
#include <arpa/inet.h>
#include <unistd.h>
#include "sys/errno.h"





GameSocket::GameSocket()
{
    
}

GameSocket::~GameSocket()
{
    close();
}


fvoid   GameSocket::open()
{
    if ( opened )
    {
        return;
    }
    
    connected = F_FALSE;
    listening = F_FALSE;
    
    readBufferSize = SOCKET_DEFAULT_READ_BUFFER_SIZE;
    
    if ( (socketfd = socket(AF_INET, SOCK_STREAM, 0)) < 0 )
    {
        return;
    }
    
    oBuffer.initBuffer( SOCKET_DEFAULT_READ_BUFFER_SIZE );
    iBuffer.initBuffer( SOCKET_DEFAULT_READ_BUFFER_SIZE );
    
    opened = F_TRUE;
}

fvoid   GameSocket::close()
{
    if ( !opened )
    {
        return;
    }
    
    if ( socketfd != SOCKET_INVALID_DESCRIPTOR )
    {
        ::close( socketfd );
        socketfd = SOCKET_INVALID_DESCRIPTOR;
    }
    
    
    connected = F_FALSE;
    listening = F_FALSE;
    remotePort = SOCKET_INVALID_PORT;
    
    oBuffer.releaseBuffer();
    iBuffer.releaseBuffer();
    
    opened = F_TRUE;
}


fbool   GameSocket::connectToHostNameTimeTest( const fbyte* hostName , fuint16 port , fint32 t )
{
    setBlocking( F_FALSE );
    
    struct hostent* remoteHost;
    struct sockaddr_in remoteAddr;
    
    // Socket must be created, and not already connected
    
    if ( socketfd == SOCKET_INVALID_DESCRIPTOR )
    {
        return F_FALSE;
    }
    
    if ( connected )
    {
        return F_FALSE;
    }
    
    
    // Look up host
    
    if ( ( remoteHost = gethostbyname( hostName ) ) == NULL )
    {
        return F_FALSE;
    }
    
    
    // Copy host address and port into socket address structure
    
    bzero((char*)&remoteAddr, sizeof(remoteAddr));
    remoteAddr.sin_family = AF_INET;
    bcopy((char*)remoteHost->h_addr, (char*)&remoteAddr.sin_addr.s_addr, remoteHost->h_length);
    remoteAddr.sin_port = htons(port);
    
    // Request connection, raise on failure
    
    struct timeval timeout;
    timeout.tv_sec = t;
    timeout.tv_usec = 0;
    
    fd_set readfds;
    FD_ZERO( &readfds );
    FD_SET( socketfd , &readfds );
    
    int error = -1 , len;
    getsockopt( socketfd , SOL_SOCKET, SO_ERROR , &error, (socklen_t *)&len );
    
    if ( ( connect( socketfd , (struct sockaddr*)&remoteAddr , sizeof(remoteAddr) ) == -1 ) )
    {
        if( select( socketfd + 1, NULL , &readfds , NULL , &timeout ) > 0 )
        {
            int error = -1 , len;
            getsockopt( socketfd , SOL_SOCKET, SO_ERROR , &error, (socklen_t *)&len );
            
            if( error == 0 )
            {
                close();
                return F_TRUE;
            }
            else
                return F_FALSE;
        }
        else
        {
            return F_FALSE;
        }
    }
    
    return F_FALSE;
}


fbool   GameSocket::connectToHostName( const fbyte* hostName , fuint16 port )
{
    setBlocking( F_TRUE );
    
    struct hostent* remoteHost;
    struct sockaddr_in remoteAddr;

    // Socket must be created, and not already connected

    if ( socketfd == SOCKET_INVALID_DESCRIPTOR )
    {
        return F_FALSE;
    }
        
    
    if ( connected )
    {
        return F_FALSE;
    }
        
    
    // Look up host 
    
    if ( ( remoteHost = gethostbyname( hostName ) ) == NULL )
    {
        return F_FALSE;
    }
    
    // Copy host address and port into socket address structure
    
    bzero( (char*)&remoteAddr, sizeof(remoteAddr) );
    remoteAddr.sin_family = AF_INET;
    bcopy( (char*)remoteHost->h_addr , (char*)&remoteAddr.sin_addr.s_addr , remoteHost->h_length );
    remoteAddr.sin_port = htons(port);

    // Request connection, raise on failure
    
    if ( ( connect( socketfd , (struct sockaddr*)&remoteAddr , sizeof(remoteAddr) ) < 0 ) )
    {
        return F_FALSE;
    }
       

    // Note successful connection
    
    remoteHostName = hostName;
    remotePort = port;

    connected = F_TRUE;
    
    setBlocking( F_FALSE );
    
    return F_TRUE;
}


fbool   GameSocket::isConnected()
//
// Returns whether the socket is connected
//
{
    return connected;
}


fbool   GameSocket::isReadable()
//
// Returns whether or not data is available at the Socket for reading
//
{
    int count;
    fd_set readfds;
    struct timeval timeout;
    
    // Socket must be created and connected
    
    if ( socketfd == SOCKET_INVALID_DESCRIPTOR )
        return F_FALSE;

    if ( !connected )
        return F_FALSE;
    

    // Create a file descriptor set for just this socket

    FD_ZERO( &readfds );
    FD_SET( socketfd , &readfds );
   
    // Create a timeout of zero (don't wait)
   
    timeout.tv_sec = 0;
    timeout.tv_usec = 0;
 
    // Check socket for data
 
    count = select( socketfd + 1 , &readfds , NULL , NULL , &timeout );
    
    // Return value of less than 0 indicates error

    if ( count < 0 )
    {
        return F_FALSE;
    }
    // select() returns number of descriptors that matched, so 1 == has data, 0 == no data
    
    return (count == 1);
}


fbool   GameSocket::isWritable()
//
// Returns whether or not the Socket can be written to
//
{
    int count;
    fd_set writefds;
    struct timeval timeout;
    
    // Socket must be created and connected
    
    if ( socketfd == SOCKET_INVALID_DESCRIPTOR )
    {
        return F_FALSE;
    }
    
    if ( !connected )
    {
        return F_FALSE;
    }
    
    // Create a file descriptor set for just this socket

    FD_ZERO( &writefds );
    FD_SET( socketfd , &writefds );
   
    // Create a timeout of zero (don't wait)
   
    timeout.tv_sec = 0;
    timeout.tv_usec = 0;
 
    // Check socket for data
 
    count = select( socketfd + 1 , NULL , &writefds , NULL , &timeout );
    
    // Return value of less than 0 indicates error

    if ( count < 0 )
    {
        return F_TRUE;
    }
    
    // select() returns number of descriptors that matched, so 1 == write OK
    
    return (count == 1);
}


fuint32 GameSocket::getReadBufferSize()
//
// Returns this Socket's readBuffer size
//
{
    return readBufferSize;
}


fvoid   GameSocket::recvData()
{
    ssize_t count;
    
	// Socket must be created and connected
    
    if ( socketfd == SOCKET_INVALID_DESCRIPTOR )
    {
        return;
    }
    
    if ( !connected )
    {
        return;
    }
    
    
    if ( !isReadable() )
    {
        return;
    }
    
    // a bug,
    count = recv( socketfd , iBuffer.getBufferEnd() , 10240 , 0 );
    
    if ( count > 0 )
    {
        // Got some data, append it to user's buffer
        
        iBuffer.write( count );
    }
    else if ( count == 0 )
    {
        // Other side has disconnected, so close down our socket
        
        close();
    }
    else if ( count < 0 )
    {
        // recv() returned an error. 
        
        if ( errno == EAGAIN )
        {
            // No data available to read (and socket is non-blocking)
            count = 0;
        }
        else
        {
            close();
            //[ ioBuffer clearBuffer ];
            return;
        }
//            [NSException raise:SOCKET_EX_RECV_FAILED 
//                        format:SOCKET_EX_RECV_FAILED_F, strerror(errno)];
    }
}


fvoid       GameSocket::sendData()
{
    int len = oBuffer.getLen();
    
    if ( !len )
    {
        return;
    }
    
    ssize_t tmp = send( socketfd , oBuffer.getStart() , len , 0 );
    
    if( tmp < 0 )
    {
        return;
    }
    
    oBuffer.removeBuffer( tmp );
}


const fbyte*    GameSocket::getRemoteHostName()
// Returns the remote hostname that the socket is connected to,
// or NULL if the socket is not connected.
//
{
    return remoteHostName.c_str();
}


fuint16         GameSocket::getRemoteHostPort()
//
// Returns the remote port number that the socket is connected to, 
// or 0 if not connected.
//
{
    return remotePort;
}


fvoid           GameSocket::setBlocking( fbool shouldBlock )
//
// Switch the socket to blocking or non-blocking mode
//
{
    int flags;
    int result;
    
    flags = fcntl(socketfd, F_GETFL, 0);

    if ( flags < 0 )
    {
        return;
    }

    if ( shouldBlock )
    {
        // Set it to blocking...
        result = fcntl( socketfd , F_SETFL , flags & ~O_NONBLOCK );
    }
    else
    {
        // Set it to non-blocking...
        result = fcntl( socketfd , F_SETFL , flags | O_NONBLOCK);
    }

    if ( result < 0 )
    {
        return;
    }
}


fvoid           GameSocket::writeData( netSocketHead* head )
{
    oBuffer.write( head , head->size );
}







