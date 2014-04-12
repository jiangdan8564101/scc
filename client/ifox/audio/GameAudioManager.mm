//
//  GameAudioManager.m
//  ixyhz
//
//  Created by fox1 on 12-8-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GameAudioManager.h"
#import "ClientDefine.h"

@implementation GameAudioManager


@synthesize MusicVolume = musicVolume , SoundVolume = soundVolume;
@synthesize Enabled;
@synthesize AudioQueue;
@synthesize Playing = playing;

- ( void ) play :( NSTimeInterval )t
{
    dispatch_async( AudioQueue , ^{
        
        //NSLog( @"ref %d" , music.retainCount );
        
        if ( music && music.retainCount <= 0 )
        {
            return;
        }
        
        [ music stop ];
        [ music release ];
        music = NULL;
        
        if ( !playing.length )
        {
            return;
        }
        
        music = [ [ GameSoundHandler alloc ] init ];
        [ music initSoundHandler:playing :@"mp3" ];
        music.delegate = NULL;
        [ music setEnableRate:YES ];
        [ music setRate:1.0f + ( GAME_SPEED - 1 ) * 0.25f ];
        
        [ music setLoop:YES ];
        [ music setVolume: Enabled ? musicVolume : 0 ];
        [ music setCurrentTime:t ];
    } );
}

- ( NSTimeInterval ) getCurrectTime
{
    if ( music.retainCount <= 0 )
    {
        return 0;
    }
    
    return music.currentTime;
}


- ( void ) playMusic:( NSString* ) name :( NSTimeInterval )t
{
    if ( [ playing isEqualToString:name ] )
    {
        return;
    }
    
    [ playing release ];
    playing = name.retain;
    
    if ( !Enabled )
    {
        return;
    }
    
    [ self play:t ];
    
}

- ( void ) stopMusic
{
    dispatch_async( AudioQueue , ^{
    
        [ music stop ];
        
        [playing release ];
        playing = NULL;
    } );
}

- ( void ) playSound:( NSString* ) name
{
    NSString* path = [ [ NSBundle mainBundle] pathForResource:name ofType:@"wav" inDirectory:SOUND_PATH ];
    
    if ( !path )
    {
        return;
    }
    
    if ( !Enabled || !soundVolume || !name )
    {
        return;
    }
        
    dispatch_async( AudioQueue , ^{
        
        GameSoundHandler* sound = [ [ GameSoundHandler alloc ] init ];
        
        [ sound initSoundHandler:name :@"wav" ];
        [ sound setEnableRate:YES ];
        [ sound setRate:1.0f + ( GAME_SPEED - 1 ) * 0.25f ];
        
        [ sound setLoop:NO ];
        [ sound setVolume: Enabled ? soundVolume : 0 ];
    } );
}


- ( void ) setMusicVolume:( float ) v
{
    musicVolume = v;
    
    dispatch_async( AudioQueue , ^{
        [ music setVolume: Enabled ? v : 0.0f ];
    } );
}


- ( void ) setEnabled:(BOOL)e
{
    Enabled = e;
    
    if ( playing && Enabled && !music )
    {
        [ self play:0 ];
        return;
    }
    
    dispatch_async( AudioQueue , ^{
        [ music setVolume: Enabled ? musicVolume : 0.0f ];
    } );
}

- ( void ) setSoundVolume:( float ) v
{
    soundVolume = v;
}


- ( void ) initAudioManager
{
    music = NULL;
    
    Enabled = YES;
    
    musicVolume = 1.0f;
    soundVolume = 1.0f;
    
    AudioQueue = dispatch_queue_create("AudioQueue", NULL);
}


- ( void ) releaseAudioManager
{
    [ music release ];
    music = NULL;
    
    dispatch_release( AudioQueue );
    AudioQueue = NULL;
}


GameAudioManager* gGameAudioManager = NULL;
+ ( GameAudioManager* ) instance
{
    if ( !gGameAudioManager ) 
    {
        gGameAudioManager = [ [ GameAudioManager alloc ] init ];
    }
    
    return gGameAudioManager;
}


- ( void ) audioPlayerDidFinishPlaying:(AVAudioPlayer*)player successfully:(BOOL)flag
{
    dispatch_async( AudioQueue , ^{
        
        if ( player != music )
        {
            [ player release ];
        }
    } );
}





@end
