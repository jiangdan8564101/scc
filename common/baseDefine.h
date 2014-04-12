//
//  baseDefine.h
//  test
//
//  Created by fox on 12-11-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#ifndef baseDefine_h
#define baseDefine_h



#ifdef WIN32
#include <stdio.h>

#include <WinSock2.h>
#include <ws2tcpip.h>
#include <mstcpip.h>
#include <mswsock.h>
#include <Windows.h>

#else
#include <stdint.h>
#endif

#include "baseTemplate.h"

#include <vector>
#include <list>
#include <string>
#include <queue>
#include <map>
using namespace std;

#ifdef WIN32
typedef __int64                     fint64;
#else
typedef int64_t                     fint64;
#endif
typedef unsigned long long          fuint64;

typedef wchar_t						fwchar;

typedef char						fbyte;
typedef unsigned char				fubyte;

typedef short						fint16;
typedef unsigned short				fuint16;

typedef int							fint32;
typedef unsigned int				fuint32;

typedef long						flong;
typedef unsigned long				fulong;

typedef void						fvoid;

typedef float						freal32;
typedef double						freal64;

typedef int							fbool;



struct netSocketHead
{
    unsigned short size;
    unsigned short type;
};


#define F_TRUE 1
#define F_FALSE 0
#define F_NULL 0

#define F_SAFE_DELETE(a) if( a ){ delete a; } 
#define F_SAFE_RELEASE(a) if( a ){ a->Release(); }

#define F_USE_PRINT

#endif





