//
//  GameAudioManager.h
//  ixyhz
//
//  Created by fox1 on 12-8-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "GameSoundHandler.h"

@interface GameAudioManager : NSObject< AVAudioPlayerDelegate >
{
    NSString* playing;
    
    GameSoundHandler* music;
    
    float musicVolume;
    float soundVolume;
}

@property ( assign ) dispatch_queue_t AudioQueue;
@property ( nonatomic ) BOOL Enabled;
@property ( nonatomic , readonly ) float SoundVolume , MusicVolume;
@property ( nonatomic , assign ) NSString* Playing;

- ( NSTimeInterval ) getCurrectTime;
- ( void ) playMusic:( NSString* ) name :( NSTimeInterval )t;
- ( void ) stopMusic;

- ( void ) playSound:( NSString* ) name;

- ( void ) setMusicVolume:( float ) v;
- ( void ) setSoundVolume:( float ) v;

- ( void ) initAudioManager;
- ( void ) releaseAudioManager;

+ ( GameAudioManager* ) instance;


@end
