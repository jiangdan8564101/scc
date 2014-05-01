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

void saveXML( NSString* name , NSString* input , NSString* output )
{
    NSString* path = [ NSString stringWithFormat:@"%@/%@" , input , name ];
    
    NSRange range = [ path rangeOfString:@".xml" ];
    
    if ( !range.length )
    {
        return;
    }
    
    if ( !path )
    {
        return;
    }
    
    NSFileHandle* file = [ NSFileHandle fileHandleForReadingAtPath:path ];
    
    if ( !file )
    {
        return;
    }
    
    NSData* data = [ file readDataToEndOfFile ];
    NSData* xmlData = [ data base64EncodedDataWithOptions:NSDataBase64Encoding64CharacterLineLength ];
    
    range.location = 0; range.length = name.length - 3;
    NSString* pathOut = [ NSString stringWithFormat:@"%@/%@dat" , output , [ name substringWithRange:range ] ];
    
    NSFileManager* fm = [ NSFileManager defaultManager ];
    [ fm createFileAtPath:pathOut contents:xmlData attributes:nil ];
    [ file closeFile ];
}


void saveDat()
{
#ifdef DEUBG
    NSFileManager* fileManager = [ NSFileManager defaultManager ];
    NSError* error = nil;
    NSArray* fileList = [ fileManager contentsOfDirectoryAtPath:@"/Users/fox/Desktop/scc/client/ifox/Resources/xml" error:&error ];
    
    for ( int i = 0 ; i < fileList.count ; ++i )
    {
        saveXML( [ fileList objectAtIndex:i ] , @"/Users/fox/Desktop/scc/client/ifox/Resources/xml" , @"/Users/fox/Desktop/scc/client/ifox/Resources/dat" );
    }
    
    fileList = [ fileManager contentsOfDirectoryAtPath:@"/Users/fox/Desktop/scc/client/ifox/Resources/xml/scene" error:&error ];
    for ( int i = 0 ; i < fileList.count ; ++i )
    {
        saveXML( [ fileList objectAtIndex:i ] , @"/Users/fox/Desktop/scc/client/ifox/Resources/xml/scene" , @"/Users/fox/Desktop/scc/client/ifox/Resources/dat/scene" );
    }
#endif
}

#define USEXMLDATA 1

NSData* loadXML( NSString* name )
{
    saveDat();
    
    if( USEXMLDATA )
    {
        NSString* path = [ [ NSBundle mainBundle ] pathForResource:name ofType:@"dat" inDirectory:XML_DATA_PATH ];
        
        if ( !path )
        {
            return NULL;
        }
        
        NSFileHandle* file = [ NSFileHandle fileHandleForReadingAtPath:path ];
        
        if ( !file )
        {
            return NULL;
        }
        
        NSData* data = [ file readDataToEndOfFile ];
        
        NSData* xmlData = [ [ [ NSData alloc ] initWithBase64EncodedData:data options:NSDataBase64DecodingIgnoreUnknownCharacters ] autorelease ];
        return xmlData;
    }
    else
    {
        NSString* path = [ [ NSBundle mainBundle ] pathForResource:name ofType:@"xml" inDirectory:XML_PATH ];
        
        if ( !path )
        {
            return NULL;
        }
        
        NSFileHandle* file = [ NSFileHandle fileHandleForReadingAtPath:path ];
        
        if ( !file )
        {
            return NULL;
        }
        
        NSData* data = [ file readDataToEndOfFile ];
        
        return data;
    }
}

NSData* loadXMLScene( NSString* name )
{
    saveDat();
    
    if( USEXMLDATA )
    {
        NSString* path = [ [ NSBundle mainBundle ] pathForResource:name ofType:@"dat" inDirectory:SCENE_DATA_PATH ];
        
        if ( !path )
        {
            return NULL;
        }
        
        NSFileHandle* file = [ NSFileHandle fileHandleForReadingAtPath:path ];
        
        if ( !file )
        {
            return NULL;
        }
        
        NSData* data = [ file readDataToEndOfFile ];
        
        NSData* xmlData = [ [ [ NSData alloc ] initWithBase64EncodedData:data options:NSDataBase64DecodingIgnoreUnknownCharacters ] autorelease ];
        return xmlData;
    }
    else
    {
        NSString* path = [ [ NSBundle mainBundle ] pathForResource:name ofType:@"xml" inDirectory:SCENE_PATH ];
        
        if ( !path )
        {
            return NULL;
        }
        
        NSFileHandle* file = [ NSFileHandle fileHandleForReadingAtPath:path ];
        
        if ( !file )
        {
            return NULL;
        }
        
        NSData* data = [ file readDataToEndOfFile ];
        
        return data;
    }
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



