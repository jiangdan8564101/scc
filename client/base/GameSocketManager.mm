//
//  GameSocketManager.m
//  sc
//
//  Created by fox1 on 12-7-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GameSocketManager.h"
#import "GameManager.h"

//@implementation GameSocketManager


//SEND_MSG_LOGIN gSendMsgLogin;
//SEND_MSG_BATTLE gSendMsgBattle;


Socket* gMainSocket = NULL;
BOOL gMainSocketIsConnected = NO;
void* gMainSocketBuffer = NULL;
NSMutableDictionary* gMainSocketMsgDic = NULL;
NSString* gMainSocketIP = @"";
int gMainSocketPort = 0;

+ ( Socket* ) MainSocket
{
    return gMainSocket;
}


+ ( void ) MainSocketRegeditMsg:( int )msg :( void* )handler
{
    [ gMainSocketMsgDic setValue:[ NSNumber numberWithInt:(int)handler ] forKey:[ NSString stringWithFormat:@"%d" , msg ] ];
}




+ ( BOOL ) MainSocketConnect:( NSString* )ip :( int )port
{
    gMainSocketIP = ip;
    gMainSocketPort = port;
    
    BOOL b = [ gMainSocket connectToHostName:ip port:port ];
    
    if ( b ) 
    {
        gMainSocketIsConnected = YES;
    }
    
    return b;
}


+ ( BOOL ) MainSocketSendMsg:( netSocketHead* )msg
{
    if ( gMainSocketIsConnected ) 
    {
#if DEBUG
        DEBUGLOG( @" send msg : \n%d %d " , msg->type , msg->size );
#endif
        
        [ gMainSocket writeDataC:msg ];
    }
    else 
    {
        return NO;
    }
    
    return YES;
}


- ( void )dealloc
{
    [ super dealloc ];
    free( gMainSocketBuffer );
    
    [ gMainSocket release ];
}


GameSocketManager* gGameSocketManager = NULL;
+ ( GameSocketManager* ) instance
{
    if ( !gGameSocketManager ) 
    {
        gGameSocketManager = [ [ GameSocketManager alloc ] init ];
        gMainSocket = [ [ Socket alloc ] init ];
        [ gMainSocket open ];
        
        gMainSocketBuffer = malloc( SOCKET_DEFAULT_READ_BUFFER_SIZE );
        gMainSocketMsgDic = [ [ NSMutableDictionary alloc ] init ];
    }
    
    return gGameSocketManager;
}


+ ( void ) errorHandlerMainSocket:( netSocketHead* )msg
{
    
    
}


+ ( void ) handlerMainSocket:( netSocketHead* )msg
{
    void (*p)( netSocketHead* ) = ( void (*)( netSocketHead* ) )[ [ gMainSocketMsgDic objectForKey:[ NSString stringWithFormat:@"%d" , msg->type ] ] intValue ];
    
    if ( p ) 
    {
        (*p)( msg );
    }
}


+ ( BOOL ) isConnected
{
    if ( gMainSocket && gMainSocket.isConnected ) 
    {
        return YES;
    }
    
    return NO;
}


+ ( void ) updateMainSocket:( float )delay
{
    if ( gMainSocketIsConnected ) 
    {
        if ( !gMainSocket.isConnected ) 
        {
            // reconnect,,,
            
            gMainSocketIsConnected = NO;
            
            //            [ gMainSocket open ];
            //            [ GameSocketManager MainSocketConnect:gMainSocketIP :gMainSocketPort ];
            //            
            //            if ( !gMainSocketIsConnected ) 
            //            {
            //                // exit client,,,
            //                [ [ GameManager instance ] releaseGameManager ];
            //                exit( 0 );
            //            }
            
            //exit( 0 );
            
            return;
        }
    }
    else 
    {
        return;
    }
    
    static float timeDelay = 0.0f;
    timeDelay += delay;
    
    if ( timeDelay < 0.2f )
    {
        return;
    }
    
    timeDelay = 0.0f;
    
    [ gMainSocket readBufferData ];
    
    IOBuffer* buffer = gMainSocket.GetIOBuffer;
    
    if ( [ buffer getLen ] ) 
    {
        netSocketHead* msghead = (netSocketHead*)[ buffer getStart ];
        int len = msghead->size;
        
        if ( [ buffer read:gMainSocketBuffer :len :0 ] )
        {
            DEBUGLOG( @" recv msg : \n  len:%d %d" , msghead->type , msghead->size );
            
            [ GameSocketManager handlerMainSocket:msghead ];
            
            [ buffer removeBuffer:len ];
        }
        else 
        {
            return;
        }
        
    }
    
}



@end
