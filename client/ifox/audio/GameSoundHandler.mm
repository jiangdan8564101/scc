//
//  SoundHandler.m
//  ixyhz
//
//  Created by fox1 on 12-8-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GameSoundHandler.h"
#import "ClientDefine.h"
#import "GameAudioManager.h"

@implementation GameSoundHandler


- ( void ) setLoop:( BOOL ) b
{
    self.numberOfLoops = b ? NSIntegerMax : 0 ;
}



- ( void ) initSoundHandler:(NSString *)name :( NSString* )type
{
    NSString* path = [ [ NSBundle mainBundle] pathForResource:name ofType:type inDirectory:SOUND_PATH ];
    
    if ( !path )
    {
        assert( 0 );
    }
    
    
    NSURL *url = [ NSURL fileURLWithPath:path ];
    
    NSError *error;
    [ self initWithContentsOfURL:url
                           error:&error];
    
    if ( error )
    {
        NSLog( @"%@" , error );
        return;
    }
    else
    {
        self.delegate = [ GameAudioManager instance ];
        [ self play ];
    }
    //});
    
}



@end
