//
//  ClientDefine.h
//  sc
//
//  Created by fox1 on 12-7-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#include "baseDefine.h"
#include "gameDefine.h"
#include "logManager.h"
using namespace FOXSDK;

extern float        SCENE_WIDTH;
extern float        SCENE_HEIGHT;
extern float        GAME_SPEED;


#define             EFFECT_PATH @"effect/"
#define             ACTION_PATH @"action/"
#define             MAP_PATH @"map/"
#define             SOUND_PATH @"sound/"
#define             XML_PATH @"xml/"
#define             SCENE_PATH @"xml/scene/"
#define             GUIDE_PATH @"xml/guide/"
#define             HEAD_PATH @"head/"
#define             ICON_PATH @"icon/"
#define             CREATURE_PATH @"creature/"

enum PlaySoundType
{
    PST_OK = 0,
    PST_CANCEL = 1,
    PST_ERROR = 2,
    PST_SELECT = 3,
    
    PST_ALCHEMY = 4,
    PST_START = 5,
};

extern void playSound( int n );

extern NSData* loadXML( NSString* name );
extern NSArray* getSortKeys( NSDictionary* dic );
extern int getRand( int min , int max );
#define UI_CLOSE_BUTTON_TAG 99999

#define DOOR_NORTH 2
#define DOOR_SOUTH 4
#define DOOR_WEST 8
#define DOOR_EAST 16
#define DOOR_Path 32
#define DOOR_NOPath 64

#ifdef DEBUG
#define DEBUGLOG( fmt , a... ) NSLog( @"%s , %s , line %d " fmt @"\n" , __FILE__,__FUNCTION__ , __LINE__ , ##a );
#else
#define DEBUGLOG( fmt , a... )
#endif




