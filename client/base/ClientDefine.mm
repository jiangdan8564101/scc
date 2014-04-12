//
//  GameDefine.m
//  sc
//
//  Created by fox1 on 12-7-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ClientDefine.h"
#import "GameAudioManager.h"


float       SCENE_WIDTH = 1024.0f;
float       SCENE_HEIGHT = 768.0f;

float       GAME_SPEED = 1.0f;

int getRand( int min , int max )
{
    return rand() % ( max - min ) + min;
}

void playSound( int n )
{
    switch ( n )
    {
        case PST_OK:
            [ [ GameAudioManager instance ] playSound:@"SE012" ];
            break;
        case PST_CANCEL:
            [ [ GameAudioManager instance ] playSound:@"SE013" ];
            break;
        case PST_ERROR:
            [ [ GameAudioManager instance ] playSound:@"SE016" ];
            break;
        case PST_SELECT:
            [ [ GameAudioManager instance ] playSound:@"SE020" ];
            break;
        case PST_ALCHEMY:
            [ [ GameAudioManager instance ] playSound:@"D0718" ];
            break;
        case PST_START:
            [ [ GameAudioManager instance ] playSound:@"SE014" ];
            break;
        default:
            break;
    }
}

NSData* loadXML( NSString* name )
{
    NSString* path = [ [ NSBundle mainBundle ] pathForResource:name ofType:@"xml" inDirectory:XML_PATH ];
    
    if ( !path )
    {
        return NULL;
    }
    
    NSFileHandle* file = [ NSFileHandle fileHandleForReadingAtPath:path ];
    
    if ( !file )
    {
        return NULL ;
    }
    
    NSData* data = [ file readDataToEndOfFile ];
    [ file closeFile ];
    
    return data;
}

NSArray* getSortKeys( NSDictionary* dic )
{
    return [ dic.allKeys sortedArrayUsingComparator:^(id obj1, id obj2)
            {
                if ([ obj1 intValue ] > [ obj2 intValue ]) 
                {
                    return (NSComparisonResult)NSOrderedDescending;
                }
                
                if ([ obj1 intValue ] < [ obj2 intValue ]) 
                {
                    return (NSComparisonResult)NSOrderedAscending;
                }
                
                return (NSComparisonResult)NSOrderedSame;
            }]; 
}



